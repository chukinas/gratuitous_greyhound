defmodule Chukinas.Skies.ViewModel.TacticalPoints do

  alias Chukinas.Skies.Game.TacticalPoints

  # TODO add struct
  @type t() :: %{
    starting: integer(),
    avail: integer(),
    # spent: integer(),
  }

  # *** *******************************
  # *** BUILD

  @spec build(TacticalPoints.t()) :: t()
  def build(tp) do
    %{
      starting: tp.starting,
      avail: tp.starting - tp.spent - tp.spent_committed,
    }
  end

end
