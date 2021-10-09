defmodule SunsCore.Mission.Battlegroup.ClassSpec do
  use TypedStruct
  typedstruct enforce: true do
    field :name, atom
    field :cost, pos_integer
    field :mass, pos_integer
    field :thrust, pos_integer
    field :silhouette, pos_integer
    field :shields, pos_integer
    field :primary_weapons, atom
    field :auxiliary_weapons, atom
  end
end
