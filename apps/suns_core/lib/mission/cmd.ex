defmodule SunsCore.Mission.Cmd do

  # *** *******************************
  # *** TYPES

  use Util.GetterStruct
  getter_struct do
    field :initiative, integer, enforce: false
    field :jump, integer, enforce: false
    field :tactical, integer, enforce: false
  end

  # *** *******************************
  # *** CONSTRUCTORS

  def new(init, jump, tactical) do
    %__MODULE__{
      initiative: init,
      jump: jump,
      tactical: tactical
    }
  end

  def empty(), do: %__MODULE__{}

  # *** *******************************
  # *** REDUCERS

  def clear_initiative(%__MODULE__{} = cmd) do
    %{cmd | initiative: 0}
  end

  # *** *******************************
  # *** CONVERTERS

  def total_assigned(%__MODULE__{} = cmd) do
    cmd.initiative + cmd.jump + cmd.tactical
  end

  # *** *******************************
  # *** CONVERTERS (ok/error checks)

  def check_all_cmd_assigned(cmd, scale) do
    if total_assigned(cmd) == cmd_per_turn(scale) do
      :ok
    else
      {:error, "Total assigned CMD must total Scale + 3"}
    end
  end

  def check_assigns_gte_zero(%__MODULE__{} = cmd) do
    if cmd.initiative >= 0 && cmd.jump >= 0 && cmd.tactical >= 0 do
      :ok
    else
      {:error, "All CMD assignments must be greater than or equal to zero."}
    end
  end

  # *** *******************************
  # *** HELPERS

  def cmd_per_turn(scale), do: scale + 3

end
