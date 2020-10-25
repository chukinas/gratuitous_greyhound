defmodule Chukinas.Insider.Core.Event do

  # *** *******************************
  # *** TYPES

  # TODO name is req'd
  defstruct [:payload, :name, :room, version_incremented?: false]

  @type event_name :: :flip | :get_state | :unregister_pid | :change_user_name
  @type t :: %__MODULE__{
    name: event_name(),
    payload: any(),
    room: nil | pid(),
    version_incremented?: boolean()
  }

  # TODO remove map?
  # @spec new(event_name() | keyword()) :: t()
  # @spec new(event_name() | [name: event_name(), optional(any()): any()]) :: t()
  def new(name) when is_atom(name) do
    %__MODULE__{name: name}
  end
  def new(opts) do
    struct!(__MODULE__, opts)
  end

  @spec version_is_incremented(t()) :: t()
  def version_is_incremented(event) do
    %{event | version_incremented?: true}
  end

  # *** *******************************
  # *** ROOM

  @spec set_room(t(), pid()) :: t()
  def set_room(event, room) do
    %{event | room: room}
  end

  @spec get_room_pid(t()) :: pid()
  def get_room_pid(%{room: room}) when is_pid(room) do
    room
  end
end
