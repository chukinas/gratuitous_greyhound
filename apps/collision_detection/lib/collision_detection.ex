defmodule CollisionDetection do

  alias CollisionDetection.Entity
  alias CollisionDetection.Collidable

  for type <- ~w/polygon line/a do
    def unquote(type)(coords) do
      Entity.new(coords, unquote(type))
    end
  end

  def point(vector) do
    Entity.new([vector], :point)
  end

  def collide?(item_1, item_2) do
    Entity.collides_with?(
      _to_entity(item_1),
      _to_entity(item_2)
    )
  end

  defdelegate new(coords, type), to: Entity

  defp _to_entity(%Entity{} = entity), do: entity
  defp _to_entity(item), do: Collidable.entity(item)

end
