defmodule Chukinas.Skies.Game.Bombers do

  alias Chukinas.Skies.Game.{Bomber, Map}

  # *** *******************************
  # *** TYPES

  @type t :: [Bomber.t()]

  # *** *******************************
  # *** NEW

  @spec new(Map.id()) :: [Bomber.t()]
  def new(map_spec) do
    map_spec(map_spec)
    |> Enum.with_index()
    |> Enum.map(&build_bombers/1)
    |> Enum.concat()
  end

  # *** *******************************
  # *** MAP SPEC

  @spec map_spec(Map.id()) :: [[Bomber.location()]]
  defp map_spec({1, "a"}) do
    [
      [
        {2, 2}, {3, 2},
        {2, 3},
        {2, 4},
      ]
    ]
  end
  defp map_spec({1, "b"}) do
    [
      [
        {2, 2},
        {2, 3},
        {2, 4},
        {2, 5},
        {2, 6},
      ]
    ]
  end

  # *** *******************************
  # *** HELPERS

  @spec build_bombers({[Bomber.location()], integer()}) :: [Bomber.t()]
  defp build_bombers({bomber_list, element_index}) do
    bomber_list
    |> Enum.map(&Bomber.new(element_index, &1))
  end

end
