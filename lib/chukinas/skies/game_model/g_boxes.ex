defmodule Chukinas.Skies.Game.Boxes do

  alias Chukinas.Skies.Game.Box

  # *** *******************************
  # *** TYPES

  # TODO revisit, clean up
  # TODO where is :flank?
  @type direction :: Box.generic_direction() | :this
  @type altitude :: Box.altitude() | :any
  @type location :: {direction(), Box.location_type(), altitude()}
  @type move :: {direction(), Box.location_type(), altitude(), Box.cost()}
  @type box_spec :: {direction(), Box.location_type(), Box.altitude(), [move()]}
  @type t :: [box_spec()]

  # *** *******************************
  # *** BUILD

  @spec new() :: [Box.t()]
  def new() do
    [:nose, :left, :right, :tail]
    |> Enum.map(&build_position/1)
    |> Enum.concat()
  end

  @spec build_position(Box.specific_direction()) :: [Box.t()]
  defp build_position(position) do
    [
      high_position_spec(position),
      level_position_spec(position),
      low_position_spec(position),
      return_box_specs(position),
      approach_box_specs(position),
    ]
    |> Enum.concat()
  end

  # *** *******************************
  # *** CONVERTER: 4-TUPLE -> 2-TUPLE

  # TODO these all need to be defp
  # TODO clean this whole thing up

  # def convert_boxes({dir, loc, alt, moves}, specific_direction) when is_list(moves) do
  #   moves = moves
  #   |> Enum.map(&convert_moves(&1, specific_direction))
  #   |> Enum.concat()
  #   {dir, loc, alt}
  #   |> replace_this(specific_direction)
  #   |> expand_altitude()
  #   |> Enum.map(&expand_flank/1)
  #   |> Enum.concat()
  #   |> Enum.map(&({&1, moves}))
  # end

  def expand_flank_and_altitude({{dir, loc, alt}, cost}) do
    {dir, loc, alt}
    |> expand_altitude()
    |> Enum.map(&expand_flank/1)
    |> Enum.concat()
    |> Enum.map(&({&1, cost}))
  end

  # *** *******************************
  # *** CONVERTERS: REPLACE LOCATION

  # # @spec replace_this({direction(), _, _}, Box.specific_direction()) :: [{Box.specific_direction(), _, _}]
  # def replace_this({:this, loc_type, alt}, specific_direction) do
  #   {specific_direction, loc_type, alt}
  # end
  # def replace_this(location, _), do: location

  # *** *******************************
  # *** CONVERTERS: EXPAND LOCATION

  # @spec expand_altitude({_, _, altitude()}) :: [{_, _, Box.altitude()}]
  def expand_altitude({dir, loc_type, :any}) do
    [:high, :level, :low] |> Enum.map(&({dir, loc_type, &1}))
  end
  def expand_altitude(location), do: [location]

  # @spec expand_flank({Box.generic_direction(), _, _}) :: [{Box.specific_direction(), _, _}]
  def expand_flank({:flank, loc_type, altitude}) do
    [:right, :left] |> Enum.map(&({&1, loc_type, altitude}))
  end
  def expand_flank(location), do: [location]

  # *** *******************************
  # *** SPECS

  @spec high_position_spec(Box.specific_direction) :: [Box.t()]
  defp high_position_spec(position) do
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

  @spec level_position_spec(Box.specific_direction) :: [Box.t()]
  defp level_position_spec(position) do
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

  @spec low_position_spec(Box.specific_direction) :: [Box.t()]
  defp low_position_spec(position) do
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

  @spec return_box_specs(Box.specific_direction()) :: [Box.t()]
  # TODO rename funcs
  defp return_box_specs(position) do
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

  @spec approach_box_specs(Box.specific_direction()) :: [Box.t()]
  defp approach_box_specs(position) do
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

end
