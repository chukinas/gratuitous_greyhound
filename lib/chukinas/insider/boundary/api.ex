defmodule Chukinas.Insider.Boundary.API do
  alias Chukinas.User
  alias Chukinas.Insider.Core.{Event, State}
  alias Chukinas.Insider.Boundary.{Registry, Room}

  # *** *******************************
  # *** API

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
    event = build_event(room_name, :flip)
    Room.handle_event(event, user)
  end

  @spec change_user_name(String.t(), any(), String.t()) :: State.t()
  def change_user_name(room_name, user_uuid, new_name) do
    user = User.new(user_uuid)
    event = build_event(room_name, :change_user_name, new_name)
    Room.handle_event(event, user)
  end

  # *** *******************************
  # *** HELPERS

  @spec build_event(String.t(), Event.event_name(), any()) :: Event.t()
  defp build_event(room_name, event_name, payload \\ nil) do
    [name: event_name, payload: payload]
    |> Event.new()
    |> find_room(room_name)
  end

  # should this take an event?
  # should it be private?
  @spec find_room(Event.t(), String.t()) :: Event.t()
  defp find_room(event, room_name) do
    room_pid = Registry.get_room_pid(room_name)
    Event.set_room(event, room_pid)
  end


end
