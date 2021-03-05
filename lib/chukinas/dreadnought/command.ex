alias Chukinas.Dreadnought.{Command, Segment}
alias Chukinas.Geometry.{Pose, Path}

defmodule Command do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer()
    field :state, atom(), default: :draw_pile
    # 1..5
    # Each speed rating transforms into a distance travelled.
    field :speed, integer(), default: 3
    # Angle of turn
    # 0 for straight maneuver
    # X  for right turn (e.g. 45)
    # -X for left turn (e.g. -45)
    field :angle, integer(), default: 0
    field :step_id, integer(), default: nil
    field :segment_count, integer(), default: 1
  end

  # *** *******************************
  # *** NEW

  # TODO requires an id
  def new(opts \\ []) do
    struct(__MODULE__, opts)
  end

  def random(id) do
    fields =
      [
        id: id,
        speed: Enum.random(1..5),
        angle: -18..18 |> Enum.map(&(&1 * 5)) |> Enum.random()
      ]
    struct(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def id(%__MODULE__{id: id}), do: id

  # *** *******************************
  # *** SETTERS

  def set_step_id(command, step_id) do
    Map.put(command, :step_id, step_id)
  end

  # *** *******************************
  # *** SORT

  def sort_by_segment(cmd1, cmd2) do
    cmd1.step_id >= cmd2.step_id
  end

  # *** *******************************
  # *** BOOLEANS

  # def playable?(%__MODULE__{state: state} = command, id) when is_integer(id) do
  #   command.id == id and playable?(command)
  # end
  def playable?(%__MODULE__{state: state}) do
    state == :in_hand
  end

  def on_path?(command), do: issued? command
  def issued?(%__MODULE__{state: state}) do
    state == :on_path
  end
  def in_draw_pile?(%__MODULE__{state: state}), do: state == :draw_pile

  # *** *******************************
  # *** API

  def generate_segments(command, unit_id, previous_segments) when is_list(previous_segments) do
    start_pose = previous_segments |> List.last() |> Segment.end_pose()
    generate_segments(command, unit_id, start_pose)
  end
  def generate_segments(%__MODULE__{segment_count: 1} = command, unit_id, %Pose{} = start_pose) do
    len = speed_to_distance(command.speed)
    path = case command.angle do
      0 -> Path.new_straight(start_pose, len)
      angle -> Path.new_turn(start_pose, len, angle)
    end
    [Segment.new(path, unit_id, command.step_id)]
  end

  def draw(%__MODULE__{} = command) do
    %{command | state: :in_hand}
  end

  def play(%__MODULE__{} = command, segment_id) when is_integer(segment_id) do
    command
    |> Map.put(:state, :on_path)
    |> Map.put(:step_id, segment_id)
  end

  # TODO this should be moved out into configuration
  def speed_to_distance(speed) when is_integer(speed) do
    %{
      1 => 50,
      2 => 75,
      3 => 100,
      4 => 150,
      5 => 200
    } |> Map.fetch!(speed)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    def inspect(cmd, _opts) do
      path = "mvr(#{round cmd.speed}, #{round cmd.angle}°)"
      id = "(#{cmd.id}, #{cmd.state})"
      "#Command<#{id} #{path} step(#{cmd.step_id}, #{cmd.segment_count})>"
    end
  end
end
