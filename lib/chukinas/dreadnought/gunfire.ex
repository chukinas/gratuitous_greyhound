alias Chukinas.Dreadnought.{Gunfire, Spritesheet, Turret, Unit, Sprite}

defmodule Gunfire do

  use Chukinas.PositionOrientationSize
  use Chukinas.LinearAlgebra

  # *** *******************************
  # *** TYPES

  typedstruct do
    field :sprite, Sprite.t()
    pose_fields()
    field :id_string, String.t()
    #field :time_start, number()
    #field :time_duration, number()
  end

  # *** *******************************
  # *** NEW

  def new(unit, turret_id) do
    turret = Unit.turret(unit, turret_id)
    coord =
      turret
      |> Turret.gun_barrel_vector
      |> vector_transform_from([turret, unit])
    angle = angle_from_sum(turret, unit)
    coord
    |> pose_new(angle)
    |> new
  end
  def new(pose) do
    spritename = "explosion_" <> Enum.random(~w(1 2 3))
    sprite = Spritesheet.blue(spritename)
    fields =
      %{
        sprite: sprite,
        # TODO replace with a better method. All I need is a unique DOM ID.
        id_string: "gunfire-#{Enum.random(1..10_000)}"
      }
      |> merge_pose(pose)
    struct!(__MODULE__, fields)
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
        [
          pose: pose_new(gunfire)
        ]
      IOP.struct(title, fields)
    end
  end
end
