defmodule Chukinas.Skies.ViewModel.Positions do

  alias Chukinas.Skies.ViewModel.Position

  # *** *******************************
  # *** TYPES

  @type t :: [Position.t()]

  # *** *******************************
  # *** BUILD

  @spec build() :: t()
  def build() do
    [:nose, :tail, :left, :right]
    |> Enum.map(&Position.build/1)
  end

end

defmodule Chukinas.Skies.ViewModel.Position do

  # *** *******************************
  # *** TYPES

  defstruct [
    :position,
    :build_id,
  ]

  @type t :: %__MODULE__{
    position: atom(),
    build_id: function(),
  }

  # *** *******************************
  # *** BUILD

  @spec build(atom()) :: t()
  def build(position) do
    %__MODULE__{
      position: position,
      build_id: fn box -> "#{Atom.to_string(position)}_#{box}" end
    }
  end

end
