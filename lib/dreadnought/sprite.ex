defmodule Dreadnought.Sprite do

    use Dreadnought.PositionOrientationSize
    use Dreadnought.TypedStruct
  alias Dreadnought.Core.Mount
  alias Dreadnought.Sprite.Image
  alias Dreadnought.Sprite.Spec
  alias Dreadnought.Util.IdList

  # *** *******************************
  # *** TYPES

  typedstruct enforce: true do
    rect_fields()
    field :spec, Spec.t
    field :image_spec, Image.Spec.t
    field :mounts, [Mount.t()]
  end

  # *** *******************************
  # *** CONSTRUCTORS

  # *** *******************************
  # *** CONVERTERS

  def mount_position(%__MODULE__{mounts: mounts}, mount_id) do
    mounts
    |> IdList.fetch!(mount_id)
    |> position_new
  end

  def mounts(%__MODULE__{mounts: mounts}), do: mounts

end
