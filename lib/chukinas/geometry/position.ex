alias Chukinas.Geometry.{Position, Pose, Point}

defprotocol Position do

  @type position_tuple() :: {number(), number()}
  @type translation() :: position_tuple() | t()

  @spec to_tuple(t()) :: position_tuple()
  def to_tuple(position)

  @spec translate(t(), translation()) :: t()
  def translate(positionable, translation)

end

defimpl Position, for: [Pose, Point] do

  def to_tuple(%{x: x, y: y}), do: {x, y}

  def translate(positionable, translation) do
    Map.merge(positionable, sanitize_translation(translation), fn _k, orig, trans ->
      orig + trans
    end)
  end

  defp sanitize_translation({x, y}), do: %{x: x, y: y}
  defp sanitize_translation(%{x: x, y: y}), do: %{x: x, y: y}

end
