defmodule Chukinas.TypedStruct do

  use TypedStruct

  defmacro __using__(_opts) do
    quote do
      use TypedStruct
      import Chukinas.TypedStruct, only: :macros
    end
  end

  defmacro position_fields do
    quote do
      # TODO can I replace number() with just `number`?
      field :x, number(), enforce: true
      field :y, number(), enforce: true
    end
  end

  defmacro pose_fields do
    quote do
      position_fields()
      field :angle, number(), enforce: true
    end
  end

  defmacro size_fields do
    quote do
      field :width, number(), enforce: true
      field :height, number(), enforce: true
    end
  end

end
