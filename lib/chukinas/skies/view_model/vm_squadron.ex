defmodule Chukinas.Skies.ViewModel.Squadron do
  alias Chukinas.Skies.Game.Squadron

  # *** *******************************
  # *** TYPES

  @type vm_fighter :: %{
    id: integer(),
    name: String.t(),
    hits: String.t(),
    airframe: Squadron.airframe(),
  }

  @type vm_group :: %{
    fighters: [vm_fighter()],
    starting_location: String.t(),
    state: :not_avail | :pending | :selected | :complete,
    # attack_space: String.t(),
    # end_turn_location: String.t(),
    # action_required: boolean(),
    # complete: boolean()
  }

  @type t :: %{
    current_tp: integer(),
    groups: [vm_group()],
    # groups: [vm_group()],
    # action_required: boolean(),
    # complete: boolean()
  }

  # *** *******************************
  # *** BUILDERS

  @spec build(Squadron.t()) :: t()
  def build(squadron) do
    # vm_groups = fighters
    # |> Squadron.group()
    # |> Enum.map(&build_group/1)
    %{
      current_tp: 1,
      groups: squadron |> Squadron.group() |> Enum.map(&build_group/1),
      # groups: vm_groups,
      # action_required: false,
      # complete: false
    }
  end

  @spec build_group(Squadron.group()) :: vm_group()
  defp build_group([f | _] = group) do
    %{
      starting_location: f.start_turn_location,
      fighters: Enum.map(group, &build_fighter/1),
      state: f.state
    }
  end

  @spec build_fighter(Squadron.fighter()) :: vm_fighter()
  def build_fighter(fighter) do
    %{
      id: fighter.id,
      name: fighter.pilot_name,
      hits: rand_hits(),
      airframe: fighter.airframe,
    }
  end

  @spec rand_hits() :: String.t()
  defp rand_hits() do
    Enum.random([
      "Fuselage",
      "Rudder",
      "Engine"
    ])
  end

end
