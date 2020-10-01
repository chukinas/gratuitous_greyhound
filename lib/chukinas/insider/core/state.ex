defmodule Chukinas.Insider.State do
  alias Chukinas.Insider.{State, Users, Phase}

  # *** *******************************
  # *** TYPES

  defstruct phase: Phase.initial(),
            users: Users.new(),
            count: 0,
            name: ""

  @type t :: %__MODULE__{phase: Phase.t(), users: Users.t(), count: integer()}

  @spec new(String.t()) :: t()
  def new(room_name), do: %__MODULE__{name: room_name}

  # *** *******************************
  # *** COUNT

  @spec increment_count(t) :: t
  def increment_count(state) do
    %{state | count: state.count + 1}
  end

  # *** *******************************
  # *** USERS

  @spec set_users(t(), Users.t()) :: t()
  def set_users(state, users) do
    %{state | users: users}
  end

  # *** *******************************
  # *** PHASE

  @spec get_phase(%State{}) :: Phase.t()
  def get_phase(state) do
    state.phase
  end

  def set_phase(state, func) when is_function(func, 1) do
    Map.update!(state, :phase, func)
  end

  def set_phase(state, phase) do
    %{state | phase: phase}
  end
end
