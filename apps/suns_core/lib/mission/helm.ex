defmodule SunsCore.Mission.Helm do

  alias SunsCore.Mission.Cmd
  alias __MODULE__

  # *** *******************************
  # *** TYPES

  # initiative_cmd = index below
  @initiative_die [12, 10, 8, 6, 3]

  @cmd_categories ~w/initiative jump tactical/a

  use Util.GetterStruct
  getter_struct do
    # same as player_id
    field :id, pos_integer
    field :credits, integer, default: 0
    field :cmd, nil | Cmd.t, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(player_id), do: %__MODULE__{id: player_id}

  # *** *******************************
  # *** REDUCERS

  def put_cmd(%__MODULE__{} = helm, cmd) do
    %__MODULE__{helm | cmd: cmd}
  end

  @deprecated "Use put_cmd/2 instead."
  def add_cmd(%__MODULE__{} = helm, key, count)
      when key in @cmd_categories and
             is_integer(count) do
    update_cmd = fn cmd -> Map.update!(cmd, key, &(&1 + count)) end
    Map.update!(helm, :cmd, update_cmd)
  end

  def spend_cmd(helm, key, count \\ 1) do
    add_cmd(helm, key, -count)
  end

  def spend_credits(%__MODULE__{} = helm, cost) do
    Map.update!(helm, :credits, & &1 - cost)
  end

  def update_cmd(%__MODULE__{cmd: cmd} = helm, fun) do
    %__MODULE__{helm | cmd: fun.(cmd)}
  end

  # *** *******************************
  # *** CONVERTERS

  def jump_cmd(helm), do: do_cmd(helm, :jump)
  def initiative_cmd(helm), do: do_cmd(helm, :initiative)
  def tactical_cmd(helm), do: do_cmd(helm, :tactical)

  def has_jump_cmd?(helm), do: do_cmd(helm, :jump) > 0
  def has_initiative_cmd?(helm), do: do_cmd(helm, :initiative) > 0
  def has_tactical_cmd?(helm), do: do_cmd(helm, :tactical) > 0

  defp do_cmd(%__MODULE__{cmd: cmd}, key) when key in @cmd_categories do
    Map.fetch!(cmd, key)
  end

  def initiative_rolloff_die(%__MODULE__{cmd: cmd}) do
    Enum.at(
      @initiative_die,
      Cmd.initiative(cmd),
      Enum.min(@initiative_die)
    )
  end

  # *** *******************************
  # *** COLLECTION

  defmodule Collection do
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

end
