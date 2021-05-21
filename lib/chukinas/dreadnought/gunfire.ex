alias Chukinas.Dreadnought.{Gunfire, Spritesheet, Turret, Unit, Sprite}
alias Chukinas.Geometry.Pose
alias Chukinas.LinearAlgebra.CSys

defmodule Gunfire do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :sprite, Sprite.t()
    field :pose, Pose.t()
    field :id_string, Pose.t()
    #field :time_start, number()
    #field :time_duration, number()
  end

  # *** *******************************
  # *** NEW

  def new(unit, turret_id) do
    turret = Unit.turret(unit, turret_id)
    position_vector =
      turret
      |> Turret.gun_barrel_vector
      |> CSys.Conversion.convert_to_world_vector(unit, turret)
    angle = CSys.Conversion.sum_angles(turret, unit)
    Pose.new(position_vector, angle)
           |> new
  end
  def new(pose) do
    spritename = "explosion_" <> Enum.random(~w(1 2 3))
    sprite = Spritesheet.blue(spritename)
    %__MODULE__{
      sprite: sprite,
      pose: pose,
      # TODO replace with a better method. All I need is a unique DOM ID.
      id_string: "gunfire-#{Enum.random(1..10_000)}"
    }
  end

  # *** *******************************
  # *** GETTERS

  # *** *******************************
  # *** SETTERS

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    require IOP
    def inspect(gunfire, opts) do
      title = "Gunfire"
      fields =
        gunfire
        |> Map.take([
          :pose
        ])
        |> Enum.into([])
      IOP.struct(title, fields)
    end
  end
end
