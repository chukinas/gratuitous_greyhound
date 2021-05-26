alias Chukinas.Geometry.{Size, Position}
alias Chukinas.PositionOrientationSize, as: POS

defmodule POS do

  #import Position.Guard

  defmacro __using__(_opts) do
    quote do
      require POS
      import POS
    end
  end


  # *** *******************************
  # *** POSITION

  require Position.Guard
  defguard has_position(term) when Position.Guard.has_position(term)

  defdelegate position(term), to: Position, as: :new
  defdelegate position(a, b), to: Position, as: :new

  defdelegate position_from_size(size), to: Position, as: :from_size

  # TODO this doesn't belong here
  defdelegate position_to_vertex(position), to: Position, as: :to_vertex

  defdelegate position_to_tuple(position), to: Position, as: :to_tuple

  defdelegate position_add(has_position, term), to: Position, as: :add
  defdelegate position_add_x(has_position, scalar), to: Position, as: :add_x
  defdelegate position_add_y(has_position, scalar), to: Position, as: :add_y

  defdelegate position_subtract(position, scalar), to: Position, as: :subtract

  defdelegate position_multiply(position, scalar), to: Position, as: :multiply

  defdelegate position_divide(position, scalar), to: Position, as: :divide

  defdelegate position_min_max(items_with_position), to: Position, as: :min_max

  # *** *******************************
  # *** SIZE

  def size_new(a, b) when has_position(a) and has_position(b) do
    Size.new(a, b)
  end
  defdelegate size_new(size), to: Size, as: :new
  defdelegate size_new(a, b), to: Size, as: :new

  defdelegate size_multiply(size, scalar), to: Size, as: :multiply

  defdelegate width(size), to: Size

  defdelegate height(size), to: Size

end
