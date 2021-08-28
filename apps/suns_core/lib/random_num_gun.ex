defmodule SunsCore.RandomNumberGenerator do

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct do
    field :seed, tuple
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new() do
    #
    << i1 :: unsigned-integer-32, i2 :: unsigned-integer-32, i3 :: unsigned-integer-32>> = :crypto.strong_rand_bytes(12)
    seed = {i1, i2, i3}
    %__MODULE__{seed: seed}
    #:rand.seed(:exsplus, {i1, i2, i3})
  end

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

  def to_stream(%__MODULE__{seed: seed}) do
    :rand.seed(:exsplus, seed)
    Stream.repeatedly(&:rand.uniform/0)
  end

end

# defmodule SunsCore.DieRoll do
#
#   # *** *******************************
#   # *** TYPES
#
#   @max_roll 120
#
#   use TypedStruct
#   typedstruct do
#     field :type, integer
#     field :val, integer
#   end
#
#   # *** *******************************
#   # *** CONSTRUCTORS
#
#   def universal() do
#     # This returns a "universal roll", one that can later be translated
#     # into an actual die roll.
#     # For example a universal roll of 73 translates into a D6 roll of 4
#     %__MODULE__{
#       type: :universal,
#       val: Enum.random 1..@max_roll
#     }
#   end
#
#   # *** *******************************
#   # *** REDUCERS
#
#   # *** *******************************
#   # *** CONVERTERS
#
#   def get_value(%__MODULE__{type: :universal, val: val}, sides)
#   when sides in [2, 3, 6, 8, 10, 12] do
#     bin_width = @max_roll / sides
#     bin_width
#     |> Stream.iterate(&(&1 + bin_width))
#     |> Stream.filter(fn bin_max_val -> val <= bin_max_val end)
#     |> Enum.take(1)
#     |> List.first
#   end
#
#   # *** *******************************
#   # *** HELPERS
#
# #  "+p
# ##┃ # Although not necessary, let's seed the random algorithm
# ##┃ iex> :rand.seed(:exsplus, {1, 2, 3})
# ##┃ iex> Enum.random([1, 2, 3])
# ##┃ 2
# ##┃ iex> Enum.random([1, 2, 3])
# #┃ 1
# end
