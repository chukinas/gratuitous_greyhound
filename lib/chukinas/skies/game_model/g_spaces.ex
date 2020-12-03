defmodule Chukinas.Skies.Game.Spaces do

  alias Chukinas.Skies.Game.{Formation, Space}

  # *** *******************************
  # *** TYPES

  @type map_spaces() :: %{Space.id() => integer()}

  @type t() :: [Space.t()]

  # *** *******************************
  # *** NEW

  @spec new(Formation.id()) :: t()
  def new(map_id) do
    map(map_id)
    |> Map.to_list()
    |> Enum.map(&build_space/1)
  end

  # *** *******************************
  # *** HELPERS

  @spec build_space({Space.id(), integer()}) :: Space.t()
  defp build_space({space_id, lethal_level}) do
    Space.new(space_id, lethal_level)
  end

  @spec map(Formation.id()) :: map_spaces()
  defp map({1, "a"}) do
    %{
                   {2, 1} => 1, {3, 1} => 1, {4, 1} => 1,
      {1, 2} => 1, {2, 2} => 1, {3, 2} => 2, {4, 2} => 1,
      {1, 3} => 1, {2, 3} => 2, {3, 3} => 3, {4, 3} => 1,
      {1, 4} => 1, {2, 4} => 2, {3, 4} => 2, {4, 4} => 1,
      {1, 5} => 1, {2, 5} => 1, {3, 5} => 1, {4, 5} => 1,
    }
  end
  defp map({2, "b"}) do
    %{
      {1, 1} => 1, {2, 1} => 1, {3, 1} => 1, {4, 1} => 1,
      {1, 2} => 1, {2, 2} => 2, {3, 2} => 2, {4, 2} => 1,
      {1, 3} => 1, {2, 3} => 2, {3, 3} => 2, {4, 3} => 1,
      {1, 4} => 1, {2, 4} => 2, {3, 4} => 2, {4, 4} => 1,
      {1, 5} => 1, {2, 5} => 2, {3, 5} => 2, {4, 5} => 1,
      {1, 6} => 1, {2, 6} => 1, {3, 6} => 1, {4, 6} => 1,
    }
  end

end
