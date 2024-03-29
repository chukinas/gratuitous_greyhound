defmodule Dreadnought.Core.Gunfire do

    use Spatial.PositionOrientationSize
    use Spatial.LinearAlgebra
    use Spatial.TypedStruct
  alias Dreadnought.Core.Turret
  alias Dreadnought.Core.Unit
  alias Dreadnought.Sprite


  # *** *******************************
  # *** TYPES

  typedstruct do
    pose_fields()
    field :sprite, Sprite.t
    field :id_string, String.t
  end

  # *** *******************************
  # *** NEW

  def new(unit, turret_id) do
    turret = Unit.turret(unit, turret_id)
    coord =
      turret
      |> Turret.gun_barrel_vector
      |> vector_wrt_outer_observer([turret, unit])
    angle = angle_from_sum(turret, unit)
    coord
    |> pose_from_vector(angle)
    |> new
  end

  def new(pose) do
    spritename = "explosion_" <> Enum.random(~w(1 2 3))
    sprite = Sprite.Builder.build({:blue, spritename})
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
          pose: pose_from_map(gunfire)
        ]
      IOP.struct(title, fields)
    end
  end
end
