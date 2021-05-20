alias Chukinas.Dreadnought.{Unit}
alias Chukinas.Geometry.Path
alias Chukinas.Svg

defmodule Unit.Event.Maneuver do
  @moduledoc """
  Fully qualifies a portion of a unit's maneuver

  A list of these (or even none or just one) is used by the frontend
  to render a series of motion animations.
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :id, integer(), default: 1
    field :geo_path, Path.t()
    field :svg_path, String.t()
    # TODO rename these to delay and duration
    field :fractional_start_time, number()
    field :fractional_duration, number()
  end

  # *** *******************************
  # *** NEW

  def new(geo_path, opts \\ []) do
    fields = Chukinas.Util.Opts.merge!(opts,
      fractional_start_time: 0,
      fractional_duration: 1
    )
    |> Keyword.merge(
      geo_path: geo_path,
      svg_path: Svg.get_path_string(geo_path)
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  def end_pose(%{geo_path: path}) do
    Path.get_end_pose(path)
  end

  # *** *******************************
  # *** STRUCT COMPARE

  def compare(%{fractional_start_time: a}, %{fractional_start_time: b}) do
    cond do
      a < b -> :lt
      a > b -> :gt
      a == b -> :eq
    end
  end


  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Unit.Event do
    def event?(_event), do: true
    def delay_and_duration(%{
      fractional_start_time: delay,
      fractional_duration: duration
    }) do
      {delay, duration}
    end
    def stashable?(_event), do: false
  end

  defimpl Inspect do
    require IOP
    def inspect(event, opts) do
      title = "Event(Maneuver)"
      fields = [
        delay: event.fractional_start_time
      ]
      IOP.struct(title, fields)
    end
  end

end
