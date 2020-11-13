defmodule Chukinas.Skies.ViewModel.Pilots do
  alias Chukinas.Skies.Game.Fighter
  # TODO rename to Fighters?

  @type pilot :: %{
    name: String.t(),
    hits: any(),
    # TODO selected?
    aircraft: Fighter.type(),
  }
  @type group :: %{
    pilots: [pilot()],
    start_turn_location: String.t(),
    attack_space: String.t(),
    end_turn_location: String.t(),
    action_required: boolean(),
    complete: boolean()
  }
  @type t :: %{
    groups: [group()],
    action_required: boolean(),
    complete: boolean()
  }

  def build() do
    nil
  end

end
