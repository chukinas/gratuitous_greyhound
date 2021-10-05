defmodule SunsCore.Mission.Helm do

  # *** *******************************
  # *** TYPES

  @cmd_categories ~w/initiative jump tactical/a
  @cmd_start Enum.map(@cmd_categories, &{&1, 0})
             |> Map.new()

  use TypedStruct

  typedstruct enforce: true do
    # same as player_id
    field(:id, pos_integer)
    field(:credits, integer, default: 0)
    field(:cmd, map, default: @cmd_start)
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(player_id), do: %__MODULE__{id: player_id}

  # *** *******************************
  # *** REDUCERS

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

  def credits(%__MODULE__{credits: value}), do: value

end
