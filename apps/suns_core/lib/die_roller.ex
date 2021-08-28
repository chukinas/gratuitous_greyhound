defmodule SunsCore.DieRoller do

  # TODO does this module need to stand by itself? Prob not.
  alias SunsCore.RandomNumberGenerator, as: Num

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct do
    field :rand_num_gen, Num.t, default: Num.new()
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new_seeded, do: %__MODULE__{}

  def new_initialized(rand_num_gen) do
    %__MODULE__{rand_num_gen: rand_num_gen}
    |> init()
  end

  # *** *******************************
  # *** REDUCERS

  def init(%__MODULE__{rand_num_gen: num_gen} = die_roller) do
    Num.to_stream(num_gen)
    die_roller
  end

  # *** *******************************
  # *** CONVERTERS

  def roll(%__MODULE__{}, sides)
  when sides in [2, 3, 6, 8, 10, 12] do
    :rand.uniform()
    |> Kernel.*(sides)
    |> Float.ceil
  end

end
