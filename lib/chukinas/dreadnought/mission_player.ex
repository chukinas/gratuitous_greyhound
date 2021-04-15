alias Chukinas.Dreadnought.{Mission.Player, Command, Unit}

defmodule Player do
  @moduledoc """
  Holds the information needed to a single player taking his turn
  """

  # *** *******************************
  # *** TYPES

  use TypedStruct

  typedstruct do
    field :active_units, [Unit.t()], default: []
    field :other_units, [Unit.t()], default: []
    field :commands, [Command.t()], default: []
  end

  # *** *******************************
  # *** NEW

  def new(units) do
    %__MODULE__{ other_units: units }
    |> calc_active_units
  end

  # *** *******************************
  # *** API

  def issue_command(mission_player, command) do
    mission_player
    |> Map.update!(:commands, & [command | &1])
    |> calc_active_units
  end

  # *** *******************************
  # *** PRIVATE

  defp calc_active_units(player) do
    complete_unit_ids =
      player.commands
      |> Enum.map(& &1.unit_id)
    {completed_units, incomplete_units} =
      player.active_units ++ player.other_units
      |> Enum.split_with(& &1.id in complete_unit_ids)
    {active_units, other_incomplete_units} =
      incomplete_units
      |> Enum.split(1)
    %{player |
      active_units: active_units,
      other_units: completed_units ++ other_incomplete_units
    }
    |> IOP.inspect("calc current unit")
  end

  # *** *******************************
  # *** IMPLEMENTATIONS

  defimpl Inspect do
    import Inspect.Algebra
    def inspect(player, opts) do
      summary = %{
        active_unit_ids: Enum.map(player.active_units, & &1.id),
        inactive_unit_ids: Enum.map(player.other_units, & &1.id)
      }
     concat ["#Player<", to_doc(summary, opts), ">"]
    end
  end
end
