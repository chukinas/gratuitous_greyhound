defmodule Chukinas.Skies.Game.Location do

  alias Chukinas.Skies.Game.{Box, Spaces}

  @type t :: Box.id() | Spaces.id()

  # TODO this is vm stuff. Move there?
  @spec to_friendly_string(t()) :: String.t()
  def to_friendly_string({x, y}), do: "Space (#{x}, #{y})"
  def to_friendly_string(id) when is_atom(id), do: atom_to_display_string(id)
  def to_friendly_string({_pos, typ, _alt} = id) when is_atom(typ) do
    id
    |> Tuple.to_list()
    |> Enum.map(&atom_to_display_string/1)
    |> Enum.join("/")
  end

  # TODO prob belongs in vm as well
  # TODO what should nil render as?
  # defp atom_to_display_string(nil), do: "Nil"
  defp atom_to_display_string(:notentered), do: "Not Yet Entered"
  defp atom_to_display_string(atom) do
    atom |> Atom.to_string() |> String.capitalize()
  end
end

# TODO initial unselect crashes
# TODO try https://github.com/keathley/norm
