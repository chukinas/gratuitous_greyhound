defmodule Chukinas.Insider.Event do

  # *** *******************************
  # *** TYPES

  defstruct [:payload, :name, :room, version_incremented?: false]

  @type event_name :: :flip | :get_state
  @type t :: %__MODULE__{name: event_name(), payload: any(), room: nil | pid(), version_incremented?: boolean()}

  @spec new(event_name(), any()) :: t()
  def new(name, payload \\ nil) do
    %__MODULE__{name: name, payload: payload}
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
