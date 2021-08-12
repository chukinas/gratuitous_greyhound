defmodule Dreadnought.Core.UnitBuilder do

  use Dreadnought.PositionOrientationSize
  alias Dreadnought.Core.Turret
  alias Dreadnought.Core.Sprites
  alias Dreadnought.Core.Unit

  # *** *******************************
  # *** CONSTRUCTORS

  def combat_unit_atom_list do
    [
      :blue_destroyer,
      :blue_dreadnought,
      :red_cruiser,
      :red_destroyer
    ]
  end

  def build(hull_name, unit_id, player_id, pose \\ pose_origin(), opts \\ [])

  def build(:blue_merchant, id, player_id, pose, opts) do
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

  def build(:blue_destroyer, id, player_id, pose, opts) do
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

  def build(:blue_dreadnought, id, player_id, pose, opts) do
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
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, pose, fields)
  end

  def build(:red_cruiser, id, player_id, pose, opts) do
    sprite = Sprites.red("ship_large")
    turrets = build_turrets(sprite, {:red, "turret1"}, [
      {1, 0},
      {2, 180}
    ])
    fields =
      [
        health: 100,
        sprite: sprite,
        turrets: turrets,
        name: "noname"
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, pose, fields)
  end

  def build(:red_destroyer, id, player_id, pose, opts) do
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
  # *** PRIVATE HELPERS

  defp build_turrets(unit_sprite, {sprite_fun, sprite_name}, turret_tuples) do
    turret_sprite = apply(Sprites, sprite_fun, [sprite_name])
    Enum.map(turret_tuples, fn {mount_id, rest_angle} ->
      pose =
        unit_sprite
        |> Sprites.mount_position(mount_id)
        |> pose_from_position(rest_angle)
      Turret.new(mount_id, turret_sprite, pose)
    end)
  end
end
