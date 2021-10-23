defmodule SunsCore.Mission.Scale do

  @type t :: integer

  def divide_by_two(scale), do: divide_by(scale, 2)

  def divide_by(scale, number) do
    # TODO round up or down?
    Float.ceil(scale / number)
  end

end
