defmodule Chukinas.Dreadnought.Unit.Builder do

  use Chukinas.PositionOrientationSize
  alias Chukinas.Dreadnought.Turret
  alias Chukinas.Dreadnought.Sprites
  alias Chukinas.Dreadnought.Unit


  def blue_merchant(id, player_id, pose, opts \\ []) do
    fields =
      [
        health: 40,
        sprite: Sprites.blue("hull_blue_merchant"),
        turrets: [],
        name: "noname"
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, pose, fields)
  end

  def blue_destroyer(id, player_id, pose, opts \\ []) do
    sprite = Sprites.blue("hull_blue_small")
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
    Unit.new(id, player_id, pose, fields)
  end

  def blue_dreadnought(id, player_id, pose, name, opts \\ []) do
    sprite = Sprites.blue("hull_blue_large")
    turrets = build_turrets(sprite, {:blue, "turret_blue_1"}, [
      {1, 0},
      {2, 0},
      {3, 180}
    ])
    fields =
      [
        health: 150,
        sprite: sprite,
        turrets: turrets,
        name: name
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, pose, fields)
  end

  def red_cruiser(id, player_id, pose, opts \\ []) do
    sprite = Sprites.red("ship_large")
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
    Unit.new(id, player_id, pose, fields)
  end

  def red_destroyer(id, player_id, pose, opts \\ []) do
    sprite = Sprites.red("ship_small")
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
    Unit.new(id, player_id, pose, fields)
  end

  # *** *******************************
  # *** PRIVATE

  defp build_turrets(unit_sprite, {sprite_fun, sprite_name}, turret_tuples) do
    turret_sprite = apply(Sprites, sprite_fun, [sprite_name])
    Enum.map(turret_tuples, fn {mount_id, rest_angle} ->
      pose =
        unit_sprite
        |> Sprites.mount_position(mount_id)
        |> pose_new(rest_angle)
      Turret.new(mount_id, turret_sprite, pose)
    end)
  end
end
