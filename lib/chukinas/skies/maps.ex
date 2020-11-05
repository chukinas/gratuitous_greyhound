defmodule Chukinas.Skies.Maps do

  def build_map_spec() do
    [
      {0, 0, 5}, {1, 0, 4}, {2, 0, 1}, {3, 0, 10},
      {0, 1, 5}, {1, 1, 4}, {2, 1, 1}, {3, 1, 10},
      {0, 2, 5}, {1, 2, 4}, {2, 2, 1}, {3, 2, 10},
      {0, 3, 5}, {1, 3, 4}, {2, 3, 1}, {3, 3, 10},
    ]
  end

  # def get_overall_map_size(map) do

  # end

  def map_grouped_by_rows() do
    [
      [{0, 0, 5}, {1, 0, 4}, {2, 0, 1}, {3, 0, 9}],
      [{0, 1, 3}, {1, 1, 4}, {2, 1, 5}, {3, 1, 8}],
      [{0, 2, 1}, {1, 2, 9}, {2, 2, 1}, {3, 2, 2}],
      [{0, 3, 5}, {1, 3, 4}, {2, 3, 3}, {3, 3, 1}],
    ]
  end

  def get_number(space) do
    elem(space, 2)
  end
end
