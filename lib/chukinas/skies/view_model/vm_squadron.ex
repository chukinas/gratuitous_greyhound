defmodule Chukinas.Skies.ViewModel.Squadron do
  alias Chukinas.Skies.Game.{Squadron}
  alias Chukinas.Skies.ViewModel.TacticalPoints

  # *** *******************************
  # *** TYPES

  @type vm_fighter :: %{
    id: integer(),
    name: String.t(),
    hits: String.t(),
    airframe: Squadron.airframe(),
  }

  @type vm_tags :: [:delay_entry] | []

  @type vm_group :: %{
    fighters: [vm_fighter()],
    starting_location: String.t(),
    state: :not_avail | :pending | :selected | :complete,
    tags: vm_tags(),
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

  @spec build(Squadron.t(), TacticalPoints.t()) :: t()
  def build(squadron, tactical_points) do
    # vm_groups = fighters
    # |> Squadron.group()
    # |> Enum.map(&build_group/1)
    avail_tp = tactical_points.avail
    %{
      # TODO rename available tp?
      current_tp: avail_tp,
      groups: squadron
        |> Squadron.group()
        |> Enum.map(&(build_group(&1, avail_tp))),
      # groups: vm_groups,
      # action_required: false,
      # complete: false
    }
  end

  @spec build_group(Squadron.group(), integer()) :: vm_group()
  defp build_group([f | _] = group, avail_tp) do
    %{
      starting_location: f.start_turn_location,
      fighters: Enum.map(group, &build_fighter/1),
      state: f.state,
      tag: [] |> maybe_delay_entry(f, avail_tp)
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


  @spec maybe_delay_entry(vm_tags(), Squadron.fighter(), integer()) :: vm_tags()
  def maybe_delay_entry(current_tags, fighter, avail_tp) do
    if fighter.start_turn_location == :not_entered && avail_tp > 0 do
      [:delay_entry | current_tags]
    else
      current_tags
    end
  end

end
