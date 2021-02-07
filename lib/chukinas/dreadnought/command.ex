defmodule Chukinas.Dreadnought.Command do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :speed, integer(), default: 3
    field :angle, integer(), default: 0
    field :segment_number, integer()
    field :segment_count, integer(), default: 1
    field :type, atom(), default: :default
  end

  # *** *******************************
  # *** NEW

  def new(segment_number) do
    %__MODULE__{
      segment_number: segment_number,
    }
  end

end
