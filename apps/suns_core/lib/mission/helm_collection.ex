defmodule SunsCore.Mission.Helm.Collection do

  alias SunsCore.Mission.Cmd
  alias SunsCore.Mission.Helm

  # *** *******************************
  # *** TYPES

  @type t :: [Helm.t]

  # *** *******************************
  # *** REDUCERS

  def clear_cmd(helms) do
    Enum.map(helms, &%Helm{&1 | cmd: nil})
  end
  def clear_cmd_initiative(helms) do
    update_cmd = fn cmd -> Cmd.clear_initiative(cmd) end
    helms
    |> Enum.map(&Helm.update_cmd(&1, update_cmd))
  end

  # *** *******************************
  # *** CONVERTERS

  def all_cmd_assigned?(helms) do
    Enum.all?(helms, fn %Helm{cmd: cmd} -> cmd end)
  end

  def sorted_player_ids_starting_with(helms, starting_player_id) do
    helms
    |> Enum.map(&Helm.id/1)
    |> Enum.sort # later, might need to be starter about this
    |> Stream.cycle
    |> Stream.take(2 * length(helms)) # Just in case the starting_player_id isn't present
    |> Stream.drop_while(&(&1 != starting_player_id))
    |> Enum.take(length(helms))
  end

end
