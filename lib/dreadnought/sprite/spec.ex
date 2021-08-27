defmodule Dreadnought.Sprite.Spec do

  alias Dreadnought.Sprite.Importer

  @type t :: {function_name :: atom, arg :: String.t}

  @sprite_specs Importer.sprite_specs()

  @module __MODULE__
  defmacro __using__(_opts) do
    quote do
      require unquote(@module)
      import unquote(@module), only: :macros
      alias unquote(@module)
      # TODO DRYify
      @type sprite_spec :: {function_name :: atom, arg :: String.t}
    end
  end

  defguard is_sprite_spec(sprite_spec) when sprite_spec in @sprite_specs

  def all, do: @sprite_specs

  @spec new(atom, String.t) :: t
  def new(func_name, arg) do
    spec = {func_name, arg}
    true = is_sprite_spec(spec)
    spec
  end

  # *** *******************************
  # *** CONVERTERS

  def name({_function, value} = sprite_spec) when is_sprite_spec(sprite_spec), do: value

end
