defmodule Chukinas.Dreadnought.Command do
  alias Chukinas.Dreadnought.Vector

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct enforce: true do
    field :speed, integer(), default: 3
    field :angle, integer(), default: 0
    field :segment_number, integer()
    field :segment_count, integer(), default: 1
    field :type, atom(), default: :default
    field :vector_start, Vector.t(), enforce: false
    field :vector_end, Vector.t(), enforce: false
  end

  # *** *******************************
  # *** NEW

  def new(segment_number) do
    %__MODULE__{
      segment_number: segment_number,
    }
  end

  # *** *******************************
  # *** API

  def set_path(%__MODULE__{angle: 0, speed: 3} = command, %Vector{} = start_vector) do
    command
    |> Map.put(:vector_start, start_vector)
    |> Map.put(:vector_end, Vector.move_straight(start_vector, 100))
  end

  # TODO make note about how segments are listed from later (future) to oldest (past)
  def get_segment_numbers(%__MODULE__{segment_number: min_segment} = command) do
    max_segment = min_segment + command.segment_count - 1
    min_segment..max_segment
  end

  def occupies_segment(%__MODULE__{} = command, segment_number) do
    segment_number in get_segment_numbers(command)
  end

end
