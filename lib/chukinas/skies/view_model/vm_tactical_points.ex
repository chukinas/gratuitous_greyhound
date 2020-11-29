defmodule Chukinas.Skies.ViewModel.TacticalPoints do

  alias Chukinas.Skies.Game.TacticalPoints

  defstruct [
    :starting,
    :avail,
  ]

  @type t() :: %__MODULE__{
    starting: integer(),
    avail: integer(),
  }

  # *** *******************************
  # *** BUILD

  @spec build(TacticalPoints.t()) :: t()
  def build(tp) do
    %__MODULE__{
      starting: tp.starting,
      avail: tp.starting - tp.spent_this_phase - tp.spent_committed,
    }
  end

end
