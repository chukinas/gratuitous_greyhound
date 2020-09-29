defmodule Chukinas.Insider.Event do
  alias Chukinas.User

  # *** *******************************
  # *** TYPES

  defstruct [:user, :payload, :name, :room]

  @type event_name :: :flip
  @type event_type :: event_name() | [event_name()]
  # @type t :: {event_name(), %User{}, payload()}
  @type t :: %__MODULE__{
    name: event_type(),
    user: User.t(),
    payload: any(),
    room: nil | pid()
  }

  @spec new(event_name(), User.t(), any()) :: t()
  def new(name, user, payload \\ nil) do
    %__MODULE__{name: name, user: user, payload: payload}
  end

  # *** *******************************
  # *** User

  def get_user(event), do: event.user
  def set_user(event, user), do: %{event | user: user}

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
