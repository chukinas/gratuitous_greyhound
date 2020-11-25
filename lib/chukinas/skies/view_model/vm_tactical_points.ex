defmodule Chukinas.Skies.ViewModel.TacticalPoints do

  alias Chukinas.Skies.Game.TacticalPoints

  @type t() :: %{
    avail: integer(),
    # starting: integer(),
    # spent: integer(),
  }

  # *** *******************************
  # *** BUILD

  @spec build(TacticalPoints.t()) :: t()
  def build(tp) do
    %{
      avail: tp.starting - tp.spent
    }
  end

end
