alias Dreadnought.Core.{Unit}
alias Unit.Event, as: Ev

defmodule Ev.MountRotation do
  @moduledoc """
  Fully qualifies a portion of a unit's mounts's action
  """

  use Dreadnought.Math

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
    angle_end = normalize_angle(angle_end)
    time_duration = case angle_travel do
      0 -> 1
      trav -> Float.round(abs(trav) / 360 / 2.0, 2)
    end
    fields = Dreadnought.Util.Opts.merge!(opts,
      time_start: 1 - time_duration,
      time_duration: time_duration
    )
    |> Keyword.merge(
      mount_id: mount_id,
      angle_end: angle_end,
      angle_direction: (if angle_travel < 0, do: :ccw, else: :cw),
      angle_start: normalize_angle(angle_end - angle_travel)
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Ev do
    def event?(_event), do: true
    def delay_and_duration(%{time_start: delay, time_duration: duration}) do
      {delay, duration}
    end
    def stashable?(_event), do: false
  end

  defimpl Inspect do
    require IOP
    def inspect(event, opts) do
      title = "Event(MountRotation)"
      fields = [
        time: {event.time_start, event.time_duration},
      ]
      IOP.struct(title, fields)
    end
  end
end
