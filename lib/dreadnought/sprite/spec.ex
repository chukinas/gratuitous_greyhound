defmodule Dreadnought.Sprite.Spec do

  # TODO rename..
  alias Dreadnought.Core.Sprites

  @type t :: {function_name :: atom, arg :: String.t}

  @sprite_specs Sprites.sprite_specs()

  @module __MODULE__
  defmacro __using__(_opts) do
    quote do
      require unquote(@module)
      import unquote(@module)
    end
  end

  defguard is_sprite_spec(sprite_spec) when sprite_spec in @sprite_specs

  ## TODO write macro that pulls the local module name
  #def new_mission_spec(module, mission_name) do
  #  {module, mission_name}
  #end

  #def name_from_mission_spec({_module, name} = sprite_spec)
  #when is_mission_spec(sprite_spec) do
  #  name
  #end

end
