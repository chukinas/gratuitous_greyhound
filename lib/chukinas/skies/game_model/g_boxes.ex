defmodule Chukinas.Skies.Game.Boxes do

  alias Chukinas.Skies.Game.Box

  # *** *******************************
  # *** TYPES

  @type attack_direction :: :nose | :tail | :flank
  @type t :: [Box.t()]

  # *** *******************************
  # *** NEW

  @spec new() :: [Box.t()]
  def new() do
    [:not_entered, :nose, :left, :right, :tail]
    |> Enum.map(&new_position/1)
    |> Enum.concat()
  end

  # *** *******************************
  # *** API

  #TODO spec
  def get_move_cost(all_boxes, {start_id, end_id}) do
    # TODO temp
    # IO.inspect(move, label: "move")
    all_boxes
    |> find_box(start_id)
    # |> IO.inspect(label: "matching box")
    |> Box.get_move_cost(end_id)
    # |> IO.inspect(label: "move cost")
  end

  # *** *******************************
  # *** HELPERS: NEW

  @spec new_position(Box.box_group()) :: [Box.t()]
  defp new_position(:not_entered) do
    [%Box{
      id: :not_entered,
      moves: [
        {:not_entered, 1},
        {{:nose, :preapproach, :low}, 0},
        {{:left, :preapproach, :low}, 0},
        {{:right, :preapproach, :low}, 0},
        {{:tail, :preapproach, :low}, 0},
      ]
    }]
  end
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

  @spec new_high_preapproach(Box.position()) :: [Box.t()]
  defp new_high_preapproach(position) do
    common_moves = [
      {{position, :preapproach, :high}, 0},
      {{position, :approach, :high}, 0},
      {{position, :preapproach, :level}, 0},
      {{position, :preapproach, :low}, 0},
    ]
    specific_moves = case to_attack_direction(position) do
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
      id: {position, :preapproach, :high},
      moves: moves,
    }]
  end

  @spec new_level_preapproach(Box.position) :: [Box.t()]
  defp new_level_preapproach(position) do
    common_moves = [
      {{position, :preapproach, :level}, 0},
      {{position, :approach, :level}, 0},
      {{position, :preapproach, :high}, 0},
      {{position, :preapproach, :low}, 0},
    ]
    specific_moves = case to_attack_direction(position) do
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
      id: {position, :preapproach, :level},
      moves: moves,
    }]
  end

  @spec new_low_preapproach(Box.position) :: [Box.t()]
  defp new_low_preapproach(position) do
    moves = [
      # Common moves
      {{position, :preapproach, :low}, 0},
      {{position, :approach, :low}, 0},
      {{position, :preapproach, :high}, 1},
      {{position, :preapproach, :level}, 0},
    ]
    ++
    # specific moves
    case to_attack_direction(position) do
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
      id: {position, :preapproach, :low},
      moves: moves,
    }]
  end

  @spec new_return_boxes(Box.position()) :: [Box.t()]
  defp new_return_boxes(position) do
    [
      %Box{
        id: {position, {:return, :evasive}, :high},
        moves: [{{position, {:return, :determined}, :high}, 0}]
      },
      %Box{
        id: {position, {:return, :determined}, :high},
        moves: [{{position, :preapproach, :high}, 0}]
      },
      %Box{
        id: {position, {:return, :determined}, :low},
        moves: [{{position, :preapproach, :low}, 0}]
      },
      %Box{
        id: {position, {:return, :evasive}, :low},
        moves: [{{position, {:return, :determined}, :low}, 0}]
      },
    ]
  end

  @spec new_approach_boxes(Box.position()) :: [Box.t()]
  defp new_approach_boxes(position) do
    common_boxes = [
      {position, :approach, :low},
      {position, :approach, :high},
    ]
    case to_attack_direction(position) do
      :flank -> common_boxes
      _ ->[{position, :approach, :level} | common_boxes]
    end
    |> Enum.map(&%Box{id: &1, moves: []})
  end

  # *** *******************************
  # *** HELPERS

  @spec to_attack_direction(Box.position()) :: attack_direction()
  def to_attack_direction(position) do
    case position do
      :right -> :flank
      :left  -> :flank
      other -> other
    end
  end

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
  def expand_altitude(id), do: [id]

  def expand_flank({:flank, loc_type, altitude}) do
    [:right, :left] |> Enum.map(&({&1, loc_type, altitude}))
  end
  def expand_flank(id), do: [id]

  def find_box(boxes, box_id) do
    Enum.find(boxes, fn box -> box.id == box_id end)
  end

end
