defmodule SunsCore.Mission.Helm.Collection do

  alias SunsCore.Mission.Cmd
  alias SunsCore.Mission.Helm

  @type t :: [Helm.t]

  # REDUCERS
  def clear_cmd(helms) do
    Enum.map(helms, &%Helm{&1 | cmd: nil})
  end
  def clear_cmd_initiative(helms) do
    update_cmd = fn cmd -> Cmd.clear_initiative(cmd) end
    helms
    |> Enum.map(&Helm.update_cmd(&1, update_cmd))
  end

  # CONVERTERS
  def all_cmd_assigned?(helms) do
    Enum.all?(helms, fn %Helm{cmd: cmd} -> cmd end)
  end

end
