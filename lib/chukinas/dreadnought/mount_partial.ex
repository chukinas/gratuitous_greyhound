alias Chukinas.Dreadnought.{MountPartial}

# TODO is this the right name for it? How well does this go with turret.ex?
# TODO is 'MountAction' better?
defmodule MountPartial do
  @moduledoc """
  Fully qualifies a portion of a unit's mounts's action
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :turret_id, integer()
    # Rotation
    field :angle_final, number()
    field :angle_travel, number()
    # Time as fractions of turn animation time
    field :start, number()
    field :duration, number()
    # TODO later, add description of cannon firing
  end

  # *** *******************************
  # *** NEW

  def new(turret_id, angle_final, angle_travel, opts \\ []) do
    fields = Chukinas.Util.Opts.merge!(opts,
      start: 0,
      duration: 1
    )
    |> Keyword.merge(
      turret_id: turret_id,
      angle_final: angle_final,
      angle_travel: angle_travel
    )
    struct!(__MODULE__, fields)
  end

  # *** *******************************
  # *** GETTERS

  #def end_pose(%{geo_path: path}) do
  #  Path.get_end_pose(path)
  #end

  # *** *******************************
  # *** STRUCT COMPARE

  #def compare(%{fractional_start_time: a}, %{fractional_start_time: b}) do
  #  cond do
  #    a < b -> :lt
  #    a > b -> :gt
  #    a == b -> :eq
  #  end
  #end
end
