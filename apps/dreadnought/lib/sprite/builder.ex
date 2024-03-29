defmodule Dreadnought.Sprite.Builder do

    use Dreadnought.Sprite.Spec
  alias Dreadnought.Sprite.Importer

  def build({function_atom, arg} = sprite_spec) when is_sprite_spec(sprite_spec) do
    apply(Importer, function_atom, [arg])
  end

end
