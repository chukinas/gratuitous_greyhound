alias Chukinas.Dreadnought.{Gunfire, Spritesheet}

defmodule Gunfire do

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :sprite, Sprite.t()
    field :pose, Pose.t()
    #field :time_start, number()
    #field :time_duration, number()
  end

  # *** *******************************
  # *** NEW

  def new(pose) do
    spritename = "explosion_" <> Enum.random(~w(1 2 3))
    sprite = Spritesheet.blue(spritename)
    %__MODULE__{
      sprite: sprite,
      pose: pose,
    }
  end

  # *** *******************************
  # *** GETTERS

  # *** *******************************
  # *** SETTERS

  # *** *******************************
  # *** API

  # *** *******************************
  # *** PRIVATE

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(gunfire, opts) do
      col = fn string -> color(string, :cust_struct, opts) end
      unit_map =
        gunfire
        |> Map.take([
          :pose
        ])
        |> Enum.into([])
        #|> Keyword.put(:health, gunfire.percent_remaining_health(gunfire))
      concat [
        col.("#Gunfire"),
        to_doc(unit_map, opts)]
    end
  end
end
