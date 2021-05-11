alias Chukinas.Geometry.{Pose, Position, Trig}

defmodule Pose do

  require Position

  use TypedStruct
  typedstruct enforce: true do
    field :x, number()
    field :y, number()
    field :angle, number()
  end

  defimpl Inspect do
    import Inspect.Algebra
    require IOP
    def inspect(pose, opts) do
      fields = [
        x: round(pose.x),
        y: round(pose.y),
        angle: round(pose.angle)
      ]
      concat [
        IOP.color("#Pose<"),
        IOP.doc(fields),
        IOP.color(">")
      ]
    end
  end

  # *** *******************************
  # *** NEW

  def new({x, y}, angle), do: new(x, y, angle)
  def new(%{x: x, y: y}, angle), do: new(x, y, angle)
  def new(x, y, angle) do
    %__MODULE__{
      x: x,
      y: y,
      angle: Trig.normalize_angle(angle),
    }
  end

  def origin(), do: new(0, 0, 0)

  # *** *******************************
  # *** GETTERS

  def angle(%{angle: angle}), do: angle

  # *** *******************************
  # *** SETTERS

  def put_angle(pose, angle), do: %__MODULE__{pose | angle: angle}

  # *** *******************************
  # *** API

  def rotate(%__MODULE__{} = pose, angle) do
    %{pose | angle: Trig.normalize_angle(pose.angle + angle)}
  end

  def straight(pose, length) do
    dx = length * Trig.cos(pose.angle)
    dy = length * Trig.sin(pose.angle)
    new(pose.x + dx, pose.y + dy, pose.angle)
  end

  def left(pose, length) do
    pose
    |> rotate(-90)
    |> straight(length)
  end

  def right(pose, length) do
    pose
    |> rotate(90)
    |> straight(length)
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

#  defimpl Inspect do
#    import Inspect.Algebra
#    def inspect(pose, opts) do
#      col = fn string -> color(string, :cust_struct, opts) end
#      concat [
#        col.("#Pose<"),
#        to_doc({round(pose.x), round(pose.y)}, opts), "∠ " , to_doc(round(pose.angle), opts),
#        "°",
#        col.(">")
#      ]
#    end
#  end
end
