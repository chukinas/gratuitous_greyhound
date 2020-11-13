defmodule Chukinas.Skies.ViewModel.Pilots do
  alias Chukinas.Skies.Game.Fighter
  # TODO rename to Squadron?

  # @type vm_fighter :: %{
  #   name: String.t(),
  #   hits: String.t(),
  #   # TODO selected?
  #   aircraft: Fighter.type(),
  # }
  # @type vm_group :: %{
  #   pilots: [vm_fighter()],
  #   start_turn_location: String.t(),
  #   # attack_space: String.t(),
  #   end_turn_location: String.t(),
  #   # action_required: boolean(),
  #   # complete: boolean()
  # }
  @type t :: %{
    groups: [String.t()],
    # groups: [vm_group()],
    # action_required: boolean(),
    # complete: boolean()
  }

  @spec build(Fighter.t()) :: t()
  def build(_fighters) do
    # vm_groups = fighters
    # |> Fighter.group()
    # |> Enum.map(&build_group/1)
    %{
      groups: [
        "john and steve",
        "bill and ted"
      ]
      # groups: vm_groups,
      # action_required: false,
      # complete: false
    }
  end

  # @spec build_group(Fighter.group()) :: vm_group()
  # defp build_group(group) do
  #   %{
  #     pilots: Enum.map(group, &build_fighter/1),
  #     start_turn_location: "Not Yet Entered",
  #     # attack_space: "1, 1",
  #     end_turn_location: "Nose/High",
  #     # action_required: true,
  #     # complete: true
  #   }
  # end


  # @spec build_fighter(Fighter.fighter()) :: vm_fighter()
  # def build_fighter(fighter) do
  #   %{
  #     name: fighter.pilot_name,
  #     hits: rand_hits(),
  #     aircraft: fighter.type
  #   }
  # end

  # @spec rand_hits() :: String.t()
  # defp rand_hits() do
  #   [
  #     "Fuselage",
  #     "Rudder",
  #     "Engine"
  #   ]
  #   |> Enum.random()
  # end

end
