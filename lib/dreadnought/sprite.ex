defmodule Dreadnought.Sprite do

    use Dreadnought.PositionOrientationSize
    use Dreadnought.TypedStruct
  alias Dreadnought.Sprite.Spec

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    field :spec, Spec.t
  end

end
