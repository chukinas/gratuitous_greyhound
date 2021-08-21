defmodule Dreadnought.Core.Island.Spec do

  use Dreadnought.PositionOrientationSize

  @type t :: {:square | :triangle, pose_map}
  @type island_spec :: t

  @module __MODULE__
  defmacro __using__(_opts) do
    quote do
      require unquote(@module)
      import unquote(@module)
      @type island_spec :: t
    end
  end

  @shape ~w/square triangle/a

  defguard is_island_spec(island_spec)
  when is_tuple(island_spec)
  and tuple_size(island_spec) === 2
  and elem(island_spec, 0) in @shape
  and elem(island_spec, 1) |> has_pose

end
