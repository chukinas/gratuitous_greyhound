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
    groups: [vm_group()],
    # groups: [vm_group()],
    # action_required: boolean(),
    # complete: boolean()
  }

  # *** *******************************
  # *** BUILDERS

  @spec build(Squadron.t()) :: t()
  def build(_fighters) do
    # vm_groups = fighters
    # |> Squadron.group()
    # |> Enum.map(&build_group/1)
    %{
      groups: [
        %{
          starting_location: "dogfight",
          fighters: [
            build_fighter("red baron"),
          ],
          state: :not_avail
        },
        %{
          starting_location: "nose: high",
          fighters: [
            build_fighter("john"),
            build_fighter("steve"),
          ],
          state: :pending,
        },
        %{
          starting_location: "tail: level",
          fighters: [
            build_fighter("bill"),
            build_fighter("ted"),
          ],
          state: :selected
        },
        %{
          starting_location: "tail: level",
          fighters: [
            build_fighter("the rock"),
            build_fighter("the hulk"),
          ],
          state: :complete
        },
      ]
      # groups: vm_groups,
      # action_required: false,
      # complete: false
    }
  end

  # @spec build_group(Squadron.group()) :: vm_group()
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


  # @spec build_fighter(Squadron.fighter()) :: vm_fighter()
  def build_fighter(pilot_name) do
    %{
      # TODO temp
      id: Enum.random(1..999),
      name: pilot_name,
      hits: rand_hits(),
      airframe: :bf109,
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
