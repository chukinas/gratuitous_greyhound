defmodule Chukinas.Skies.Game.Boxes do

  alias Chukinas.Skies.Game.Box

  # *** *******************************
  # *** TYPES

  # TODO look for private types in other modules
  @typep direction :: Box.generic_direction() | :this
  @typep altitude :: Box.altitude() | :any
  @typep move :: {direction(), Box.location_type(), altitude(), Box.cost()}
  @typep box_spec :: {direction(), Box.location_type(), Box.altitude(), [move()]}
  @type t :: [box_spec()]

  # *** *******************************
  # *** NEW

  @spec new() :: [Box.t()]
  def new() do
    [:nose, :left, :right, :tail]
    |> Enum.map(&new_position/1)
    |> Enum.concat()
  end

  # *** *******************************
  # *** HELPERS: NEW

  @spec new_position(Box.specific_direction()) :: [Box.t()]
  defp new_position(position) do
    [
      new_high_preapproach(position),
      new_level_preapproach(position),
      new_low_preapproach(position),
      new_return_boxes(position),
      new_approach_boxes(position),
    ]
    |> Enum.concat()
  end

  @spec new_high_preapproach(Box.specific_direction) :: [Box.t()]
  defp new_high_preapproach(position) do
    common_moves = [
      {{:this, :approach, :high}, 0},
      {{:this, :preapproach, :level}, 0},
      {{:this, :preapproach, :low}, 0},
    ]
    specific_moves = case Box.to_generic(position) do
      :nose -> [
        {{:flank, :preapproach, :any}, 0},
        {{:tail, :preapproach, :any}, 0},
      ]
      :flank -> [
        {{:nose, :preapproach, :any}, 1},
        {{:tail, :preapproach, :any}, 0},
      ]
      :tail -> [
        {{:nose, :preapproach, :any}, 2},
        {{:flank, :preapproach, :any}, 1},
      ]
    end
    moves = common_moves ++ specific_moves
    |> Enum.map(&expand_flank_and_altitude/1)
    |> Enum.concat()
    [%Box{
      location: {position, :preapproach, :high},
      moves: moves,
    }]
  end

  @spec new_level_preapproach(Box.specific_direction) :: [Box.t()]
  defp new_level_preapproach(position) do
    common_moves = [
      {{position, :approach, :level}, 0},
      {{position, :preapproach, :high}, 0},
      {{position, :preapproach, :low}, 0},
    ]
    specific_moves = case Box.to_generic(position) do
      :nose -> [
        {{:flank, :preapproach, :any}, 0},
        {{:tail, :preapproach, :any}, 0},
      ]
      :flank -> [
        {{position, :approach, :high}, 1},
        {{:nose, :preapproach, :any}, 1},
        {{:tail, :preapproach, :any}, 0},
      ]
      :tail -> [
        {{:nose, :preapproach, :any}, 2},
        {{:flank, :preapproach, :any}, 1},
      ]
    end
    moves = common_moves ++ specific_moves
    |> Enum.map(&expand_flank_and_altitude/1)
    |> Enum.concat()
    [%Box{
      location: {position, :preapproach, :level},
      moves: moves,
    }]
  end

  @spec new_low_preapproach(Box.specific_direction) :: [Box.t()]
  defp new_low_preapproach(position) do
    moves = [
      # Common moves
      {{position, :approach, :low}, 0},
      {{position, :preapproach, :high}, 1},
      {{position, :preapproach, :level}, 0},
    ]
    ++
    # specific moves
    case Box.to_generic(position) do
      :nose -> [
        {{:flank, :preapproach, :any}, 0},
        {{:tail, :preapproach, :high}, 1},
        {{:tail, :preapproach, :low}, 0},
      ]
      :flank -> [
        {{:nose, :preapproach, :any}, 2},
        {{:tail, :preapproach, :any}, 0},
      ]
      :tail -> [
        {{:nose, :preapproach, :any}, 2},
        {{:flank, :preapproach, :any}, 1},
      ]
    end
    |> Enum.map(&expand_flank_and_altitude/1)
    |> Enum.concat()
    [%Box{
      location: {position, :preapproach, :low},
      moves: moves,
    }]
  end

  @spec new_return_boxes(Box.specific_direction()) :: [Box.t()]
  defp new_return_boxes(position) do
    [
      %Box{
        location: {position, {:return, :evasive}, :high},
        moves: [{{position, {:return, :determined}, :high}, 0}]
      },
      %Box{
        location: {position, {:return, :determined}, :high},
        moves: [{{position, :preapproach, :high}, 0}]
      },
      %Box{
        location: {position, {:return, :determined}, :low},
        moves: [{{position, :preapproach, :low}, 0}]
      },
      %Box{
        location: {position, {:return, :evasive}, :low},
        moves: [{{position, {:return, :determined}, :low}, 0}]
      },
    ]
  end

  @spec new_approach_boxes(Box.specific_direction()) :: [Box.t()]
  defp new_approach_boxes(position) do
    common_boxes = [
      {position, :approach, :low},
      {position, :approach, :high},
    ]
    case Box.to_generic(position) do
      :flank -> common_boxes
      _ ->[{position, :approach, :level} | common_boxes]
    end
    |> Enum.map(&%Box{location: &1, moves: []})
  end

  # *** *******************************
  # *** HELPERS

  defp expand_flank_and_altitude({{dir, loc, alt}, cost}) do
    {dir, loc, alt}
    |> expand_altitude()
    |> Enum.map(&expand_flank/1)
    |> Enum.concat()
    |> Enum.map(&({&1, cost}))
  end

  def expand_altitude({dir, loc_type, :any}) do
    [:high, :level, :low] |> Enum.map(&({dir, loc_type, &1}))
  end
  def expand_altitude(location), do: [location]

  def expand_flank({:flank, loc_type, altitude}) do
    [:right, :left] |> Enum.map(&({&1, loc_type, altitude}))
  end
  def expand_flank(location), do: [location]

end
