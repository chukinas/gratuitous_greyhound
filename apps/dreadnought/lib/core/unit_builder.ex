# TODO rename Unit.Builder ?
defmodule Dreadnought.Core.UnitBuilder do

    use Spatial.PositionOrientationSize
    use Dreadnought.Sprite.Spec
  alias Dreadnought.Core.Turret
  alias Dreadnought.Core.Unit
  alias Dreadnought.Sprite

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
        turrets: [],
        name: "noname"
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, {:blue, "hull_blue_merchant"}, pose, fields)
  end

  def build(:blue_destroyer, id, player_id, pose, opts) do
    sprite_spec = {:blue, "hull_blue_small"}
    turrets = build_turrets(sprite_spec, {:blue, "turret_blue_2"}, [
      {1, 0},
    ])
    fields =
      [
        health: 50,
        turrets: turrets
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, sprite_spec, pose, fields)
  end

  def build(:blue_dreadnought, id, player_id, pose, opts) do
    sprite_spec = {:blue, "hull_blue_large"}
    turrets = build_turrets(sprite_spec, {:blue, "turret_blue_1"}, [
      {1, 0},
      {2, 0},
      {3, 180}
    ])
    fields =
      [
        health: 150,
        turrets: turrets,
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, sprite_spec, pose, fields)
  end

  def build(:red_cruiser, id, player_id, pose, opts) do
    sprite_spec = {:red, "ship_large"}
    turrets = build_turrets(sprite_spec, {:red, "turret1"}, [
      {1, 0},
      {2, 180}
    ])
    fields =
      [
        health: 100,
        turrets: turrets,
        name: "noname"
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, sprite_spec, pose, fields)
  end

  def build(:red_destroyer, id, player_id, pose, opts) do
    sprite_spec = {:red, "ship_small"}
    turrets = build_turrets(sprite_spec, {:red, "turret1"}, [
      {1, 0}
    ])
    fields =
      [
        health: 50,
        turrets: turrets
      ]
      |> Keyword.merge(opts)
    Unit.new(id, player_id, sprite_spec, pose, fields)
  end

  # *** *******************************
  # *** PRIVATE HELPERS

  defp build_turrets(unit_sprite_spec, turret_sprite_spec, turret_tuples)
  when is_sprite_spec(unit_sprite_spec)
  and is_sprite_spec(turret_sprite_spec) do
    unit_sprite = Sprite.Builder.build(unit_sprite_spec)
    Enum.map(turret_tuples, fn {mount_id, rest_angle} ->
      pose =
        unit_sprite
        |> Sprite.mount_position(mount_id)
        |> pose_from_position(rest_angle)
      Turret.new(mount_id, turret_sprite_spec, pose)
    end)
  end

end
