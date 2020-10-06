defmodule Chukinas.Insider.Boundary.API do
  alias Chukinas.User
  alias Chukinas.Insider.Core.{Event, State}
  alias Chukinas.Insider.Boundary.{Registry, Room}

  @spec get_state(String.t(), any()) :: State.t()
  def get_state(room_name, user_uuid) do
    user = User.new(user_uuid)
    event =
      Event.new(:get_state)
      |> find_room(room_name)
    Room.handle_event(event, user)
  end

  @spec flip(String.t(), any()) :: State.t()
  def flip(room_name, user_uuid) do
    user = User.new(user_uuid)
    event =
      Event.new(:flip)
      |> find_room(room_name)
    Room.handle_event(event, user)
  end

  @spec find_room(Event.t(), String.t()) :: Event.t()
  def find_room(event, room_name) do
    room_pid = Registry.get_room_pid(room_name)
    Event.set_room(event, room_pid)
  end

end
