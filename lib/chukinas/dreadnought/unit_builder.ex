alias Chukinas.Dreadnought.{Unit, Sprite, Spritesheet, Turret}
alias Chukinas.Geometry.{Pose}

defmodule Unit.Builder do

  def red_cruiser(id, opts \\ []) do
    sprite = Spritesheet.red("ship_large")
    turrets = build_turrets(sprite, {:red, "turret1"}, [
      {1, 0},
      {2, 180}
    ])
    fields =
      [
        health: 100,
        sprite: sprite |> Sprite.center,
        turrets: turrets
      ]
      |> Keyword.merge(opts)
    Unit.new(id, fields)
  end

  # *** *******************************
  # *** PRIVATE

  defp build_turrets(unit_sprite, {sprite_fun, sprite_name}, turret_tuples) do
    turret_sprite = apply(Spritesheet, sprite_fun, [sprite_name]) |> Sprite.center
    Enum.map(turret_tuples, fn {pos, orient} ->
      position = unit_sprite.mounts[pos] |> Pose.new(orient)
      Turret.new(pos, position, turret_sprite)
    end)
  end
end
