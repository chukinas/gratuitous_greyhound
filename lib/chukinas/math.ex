defmodule Chukinas.Math do

  alias Chukinas.Geometry.Trig
  require Trig

  # *** *******************************
  # *** MACROS

  defmacro __using__(_opts) do
    # TODO do something with opts
    quote do
      require Chukinas.Math
      import Chukinas.Math
      alias Chukinas.Geometry.Trig
    end
  end

  defguard angle_is_normal(angle)
    when Trig.angle_is_normal(angle)

  # *** *******************************
  # *** FUNCTIONS

  def sign(x) when x <  0, do: -1
  def sign(x) when x == 0, do:  0
  def sign(x) when x >  0, do:  1

  def flip_sign(x), do: x * sign(x)

end
