defmodule Dreadnought.Core.Island.Spec do

  use Dreadnought.PositionOrientationSize

  @type t :: {:square | :triangle, pose_map}
  @type island_spec :: t

  @module __MODULE__
  defmacro __using__(_opts) do
    quote do
      require unquote(@module)
      import unquote(@module)
      alias unquote(@module)
      # TODO how to dedup this?
      @type island_spec :: {:square | :triangle, pose_map}
    end
  end

  @shape ~w/square triangle/a

  defguard is_island_spec(island_spec)
  when is_tuple(island_spec)
  and tuple_size(island_spec) === 2
  and elem(island_spec, 0) in @shape
  and elem(island_spec, 1) |> has_pose

  # *** *******************************
  # *** CONVERTERS

  def pose({_shape, pose} = island_spec) when is_island_spec(island_spec) do
    pose
  end

  def shape({shape, _pose} = island_spec) when is_island_spec(island_spec) do
    shape
  end

end

# *** *********************************
# *** LIST MODULE
# *** *********************************

defmodule Dreadnought.Core.Island.Spec.List do
  alias Dreadnought.Core.Island.Spec

  @spec remove_dup_shapes([Spec.t]) :: [Spec.t]
  def remove_dup_shapes(island_specs) when is_list(island_specs) do
    Enum.uniq_by(island_specs, &Spec.shape/1)
  end

end
