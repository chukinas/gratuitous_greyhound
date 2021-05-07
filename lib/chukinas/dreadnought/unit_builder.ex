alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret}
alias Chukinas.Geometry.{Pose}
alias Chukinas.LinearAlgebra.Vector

defmodule Unit.Builder do

  def blue_destroyer(id, opts \\ []) do
    sprite = Spritesheet.blue("hull_blue_small")
    turrets = build_turrets(sprite, {:blue, "turret_blue_2"}, [
      {1, 0},
    ])
    fields =
      [
        health: 50,
        sprite: sprite,
        turrets: turrets
      ]
      |> Keyword.merge(opts)
    Unit.new(id, fields)
  end

  def blue_dreadnought(id, opts \\ []) do
    sprite = Spritesheet.blue("hull_blue_large")
    turrets = build_turrets(sprite, {:blue, "turret_blue_1"}, [
      {1, 0},
      {2, 0},
      {3, 180}
    ])
    fields =
      [
        health: 150,
        sprite: sprite,
        turrets: turrets
      ]
      |> Keyword.merge(opts)
    Unit.new(id, fields)
  end

  def red_cruiser(id, opts \\ []) do
    sprite = Spritesheet.red("ship_large")
    turrets = build_turrets(sprite, {:red, "turret1"}, [
      {1, 0},
      {2, 180}
    ])
    fields =
      [
        health: 100,
        sprite: sprite,
        turrets: turrets
      ]
      |> Keyword.merge(opts)
    Unit.new(id, fields)
  end

  def red_destroyer(id, opts \\ []) do
    sprite = Spritesheet.red("ship_small")
    turrets = build_turrets(sprite, {:red, "turret1"}, [
      {1, 0}
    ])
    fields =
      [
        health: 50,
        sprite: sprite,
        turrets: turrets
      ]
      |> Keyword.merge(opts)
    Unit.new(id, fields)
  end

  # *** *******************************
  # *** PRIVATE

  defp build_turrets(unit_sprite, {sprite_fun, sprite_name}, turret_tuples) do
    turret_sprite = apply(Spritesheet, sprite_fun, [sprite_name])
    Enum.map(turret_tuples, fn {mount_id, rest_angle} ->
      relative_mount_position = Sprite.mount_position(unit_sprite, mount_id)
      pose =
        relative_mount_position
        |> Pose.new(rest_angle)
      vector_position =
        relative_mount_position
        |> Vector.new
      Turret.new(mount_id, pose, turret_sprite, vector_position)
    end)
  end
end
