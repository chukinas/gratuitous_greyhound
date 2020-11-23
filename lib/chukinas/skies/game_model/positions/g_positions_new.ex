defmodule Chukinas.Skies.Game.Positions.New do
  # TODO rename spec?
  # TODO remove the alias rename
  alias Chukinas.Skies.Game.Box, as: Position


  # *** *******************************
  # *** TYPES

  @type direction :: Position.generic_direction() | :this
  @type altitude :: Position.altitude() | :any
  @type move :: {direction(), Position.location_type(), altitude(), Position.cost()}
  @type box_spec :: {direction(), Position.location_type(), Position.altitude(), [move()]}
  @type t :: [box_spec()]

  # *** *******************************
  # *** BUILD

  def build() do
    [:nose, :left, :right, :tail]
    |> Enum.map(&build_position/1)
    |> Map.new()
  end

  @spec build_position(Position.specific_direction()) :: Position.t()
  defp build_position(direction) do
    generic_location = Position.to_generic(direction)
    boxes = build_boxes(generic_location)
    # TODO replace :this with specific direction
    # TODO replace flank moves with two moves: :left and :right
    {direction, boxes}
  end

  @spec build_boxes(Position.generic_direction()) :: t()
  defp build_boxes(direction) do
    boxes = [
      high_position_spec(direction),
      level_position_spec(direction),
      low_position_spec(direction),
    ]
    ++ return_box_specs()
    ++ approach_box_specs(direction)
    boxes
  end


  @spec high_position_spec(Position.generic_direction) :: box_spec()
  defp high_position_spec(location) do
    common_moves = [
      {:this, :approach, :high, 0},
      {:this, :preapproach, :level, 0},
      {:this, :preapproach, :low, 0},
    ]
    specific_moves = case location do
      :nose -> [
        {:flank, :preapproach, :any, 0},
        {:tail, :preapproach, :any, 0},
      ]
      :flank -> [
        {:nose, :preapproach, :any, 1},
        {:tail, :preapproach, :any, 0},
      ]
      :tail -> [
        {:nose, :preapproach, :any, 2},
        {:flank, :preapproach, :any, 1},
      ]
    end
    {:this, :preapproach, :high, common_moves ++ specific_moves}
  end

  @spec level_position_spec(Position.generic_direction) :: box_spec()
  defp level_position_spec(location) do
    common_moves = [
      {:this, :approach, :level, 0},
      {:this, :preapproach, :high, 0},
      {:this, :preapproach, :low, 0},
    ]
    specific_moves = case location do
      :nose -> [
        {:flank, :preapproach, :any, 0},
        {:tail, :preapproach, :any, 0},
      ]
      :flank -> [
        {:this, :approach, :high, 1},
        {:nose, :preapproach, :any, 1},
        {:tail, :preapproach, :any, 0},
      ]
      :tail -> [
        {:nose, :preapproach, :any, 2},
        {:flank, :preapproach, :any, 1},
      ]
    end
    {:this, :preapproach, :level, common_moves ++ specific_moves}
  end

  @spec low_position_spec(Position.generic_direction) :: box_spec()
  defp low_position_spec(location) do
    common_moves = [
      {:this, :approach, :low, 0},
      {:this, :preapproach, :high, 1},
      {:this, :preapproach, :level, 0},
    ]
    specific_moves = case location do
      :nose -> [
        {:flank, :preapproach, :any, 0},
        {:tail, :preapproach, :high, 1},
        {:tail, :preapproach, :low, 0},
      ]
      :flank -> [
        {:nose, :preapproach, :any, 2},
        {:tail, :preapproach, :any, 0},
      ]
      :tail -> [
        {:nose, :preapproach, :any, 2},
        {:flank, :preapproach, :any, 1},
      ]
    end
    {:this, :preapproach, :low, common_moves ++ specific_moves}
  end

  @spec return_box_specs() :: t()
  defp return_box_specs() do
    [
      {:this, {:return, :evasive}, :high, [
        {:this, {:return, :determined}, :high, 0},
      ]},
      {:this, {:return, :determined}, :high, [
        {:this, :preapproach, :high, 0},
      ]},
      {:this, {:return, :determined}, :low, [
        {:this, :preapproach, :low, 0},
      ]},
      {:this, {:return, :evasive}, :low, [
        {:this, {:return, :determined}, :low, 0},
      ]},
    ]
  end

  @spec approach_box_specs(Position.generic_direction) :: t()
  defp approach_box_specs(direction) do
    common_boxes = [
      {:this, :approach, :low, []},
      {:this, :approach, :high, []},
    ]
    case direction do
      :flank -> common_boxes
      _ -> [{:this, :approach, :level, []} | common_boxes]
    end
  end

  @spec some_move() :: move()
  def some_move() do
    {:this, :preapproach, :high, 0}
  end
end
