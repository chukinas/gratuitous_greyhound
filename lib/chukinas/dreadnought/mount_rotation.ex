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
    field :angle_start, number()
    field :angle_end, number()
    field :angle_direction, :cw | :ccw
    field :time_start, number()
    field :time_duration, number()
  end

  # *** *******************************
  # *** NEW

  def new(mount_id, angle_end, angle_travel, opts \\ []) do
    angle_end = Trig.normalize_angle(angle_end)
    fields = Chukinas.Util.Opts.merge!(opts,
      time_start: 0.5,
      time_duration: 0.5
    )
    |> Keyword.merge(
      mount_id: mount_id,
      angle_end: angle_end,
      angle_direction: (if angle_travel < 0, do: :ccw, else: :cw),
      angle_start: Trig.normalize_angle(angle_end - angle_travel)
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(action, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      keywords = [
        time: {action.time_start, action.time_duration},
        angle_start: action.angle_start,
        angle_end: action.angle_end,
        angle_direction: action.angle_direction,
      ]
      concat [
        col.("$Mount-#{action.mount_id}-Action"),
        to_doc(keywords, opts)
      ]
    end
  end
end
