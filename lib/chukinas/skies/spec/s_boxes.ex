defmodule Chukinas.Skies.Spec.Boxes do
  alias Chukinas.Skies.Terms

  def build() do
    [:nose, :left, :right, :tail]
    |> Enum.map(&build_location/1)
    |> Map.new()
  end

  defp build_location(direction) when direction in [:right, :left] do
    {_, boxes} = build_location(:flank)
    {direction, boxes}
  end

  defp build_location(direction) do
    boxes = [
      high_position_spec(direction),
      level_position_spec(direction),
      low_position_spec(direction),
    ]
    ++ return_box_specs()
    ++ approach_box_specs(direction)
    {direction, boxes}
  end

  @spec high_position_spec(Terms.generic_direction) :: any()
  defp high_position_spec(location) do
    common_moves = [
      {:this, :approach, :high, 0},
      {:this, :position, :level, 0},
      {:this, :position, :low, 0},
    ]
    specific_moves = case location do
      :nose -> [
        {:flank, :position, :any, 0},
        {:tail, :position, :any, 0},
      ]
      :flank -> [
        {:nose, :position, :any, 1},
        {:tail, :position, :any, 0},
      ]
      :tail -> [
        {:nose, :position, :any, 2},
        {:flank, :position, :any, 1},
      ]
    end
    {:this, :position, :high, common_moves ++ specific_moves}
  end

  @spec level_position_spec(Terms.generic_direction) :: any()
  defp level_position_spec(location) do
    common_moves = [
      {:this, :approach, :level, 0},
      {:this, :position, :high, 0},
      {:this, :position, :low, 0},
    ]
    specific_moves = case location do
      :nose -> [
        {:flank, :position, :any, 0},
        {:tail, :position, :any, 0},
      ]
      :flank -> [
        {:this, :approach, :high, 1},
        {:nose, :position, :any, 1},
        {:tail, :position, :any, 0},
      ]
      :tail -> [
        {:nose, :position, :any, 2},
        {:flank, :position, :any, 1},
      ]
    end
    {:this, :position, :level, common_moves ++ specific_moves}
  end

  @spec low_position_spec(Terms.generic_direction) :: any()
  defp low_position_spec(location) do
    common_moves = [
      {:this, :approach, :low, 0},
      {:this, :position, :high, 1},
      {:this, :position, :level, 0},
    ]
    specific_moves = case location do
      :nose -> [
        {:flank, :position, :any, 0},
        {:tail, :position, :high, 1},
        {:tail, :position, :low, 0},
      ]
      :flank -> [
        {:nose, :position, :any, 2},
        {:tail, :position, :any, 0},
      ]
      :tail -> [
        {:nose, :position, :any, 2},
        {:flank, :position, :any, 1},
      ]
    end
    {:this, :position, :low, common_moves ++ specific_moves}
  end

  defp return_box_specs() do
    [
      {:this, {:return, :evasive}, :high, [
        {:this, {:return, :determined}, :high, 0},
      ]},
      {:this, {:return, :determined}, :high, [
        {:this, :position, :high, 0},
      ]},
      {:this, {:return, :determined}, :low, [
        {:this, :position, :low, 0},
      ]},
      {:this, {:return, :evasive}, :low, [
        {:this, {:return, :determined}, :low, 0},
      ]},
    ]
  end

  @spec high_position_spec(Terms.generic_direction) :: any()
  defp approach_box_specs(direction) do
    common_boxes = [
      {:this, :approach, :low},
      {:this, :approach, :high},
    ]
    case direction do
      :flank -> common_boxes
      _ -> [{:this, :approach, :level} | common_boxes]
    end
  end
end