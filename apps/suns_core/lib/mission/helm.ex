defmodule SunsCore.Mission.Helm do

  alias SunsCore.Mission.Cmd
  require Cmd

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

  def spend_cmd(helm, key, count \\ 1) when Cmd.is_valid_type(key) do
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

  def get_cmd(%__MODULE__{} = helm, cmd_type) when Cmd.is_valid_type(cmd_type) do
    helm
    |> cmd
    |> Cmd.get(cmd_type)
  end

  for type <- Cmd.valid_types do
    fun_name = "has_#{type}_cmd?" |> String.to_atom
    def unquote(fun_name)(helm) do
      get_cmd(helm, unquote(type)) > 0
    end
  end

  def initiative_rolloff_die(%__MODULE__{cmd: cmd}) do
    Enum.at(
      @initiative_die,
      Cmd.initiative(cmd),
      Enum.min(@initiative_die)
    )
  end

end
