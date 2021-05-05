alias Chukinas.Dreadnought.{MountRotation}
alias Chukinas.Geometry.Trig

defmodule MountRotation do
  @moduledoc """
  Fully qualifies a portion of a unit's mounts's action
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :mount_id, integer()
    # Rotation
    field :angle_final, number()
    field :angle_travel, number()
    # TODO homogenize field names
    field :start_angle, number()
    field :direction, :cw | :ccw
    # Time as fractions of turn animation time
    field :start, number()
    field :duration, number()
    # TODO later, add description of cannon firing
  end

  # *** *******************************
  # *** NEW

  def new(mount_id, angle_final, angle_travel, opts \\ []) do
    angle_final = Trig.normalize_angle(angle_final)
    fields = Chukinas.Util.Opts.merge!(opts,
      start: 0.5,
      duration: 0.5
    )
    |> Keyword.merge(
      mount_id: mount_id,
      angle_final: angle_final,
      angle_travel: angle_travel,
      direction: (if angle_travel < 0, do: :ccw, else: :cw),
      start_angle: Trig.normalize_angle(angle_final - angle_travel)
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  #def end_pose(%{geo_path: path}) do
  #  Path.get_end_pose(path)
  #end

  # *** *******************************
  # *** STRUCT COMPARE

  #def compare(%{fractional_start_time: a}, %{fractional_start_time: b}) do
  #  cond do
  #    a < b -> :lt
  #    a > b -> :gt
  #    a == b -> :eq
  #  end
  #end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(action, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      keywords = [
        time: {action.start, action.duration},
        angle: {action.angle_final, action.angle_travel},
        direction: action.direction,
        start_angle: action.start_angle
      ]
      concat [
        col.("$Mount-#{action.mount_id}-Action"),
        to_doc(keywords, opts)
      ]
    end
  end
end
