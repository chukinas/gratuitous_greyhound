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
      field :x, number
      field :y, number
    end
  end

  defmacro pose_fields do
    quote do
      position_fields()
      field :angle, number()
    end
  end

  defmacro size_fields do
    quote do
      field :width, number()
      field :height, number()
    end
  end

  #defmacro rect_fields do
  #  quote do
  #    position_fields()
  #    size_fields()
  #  end
  #end

end
