defmodule Chukinas.Insider.API do
  # alias Chukinas.Insider.Server
  alias Chukinas.Insider.Registry

  # def start_link(room_name) do
  #   Server.start_link(room_name)
  # end

  def flip(room_name, user_uuid) do
    user = %{uuid: user_uuid}
    event = {:flip, user}
    find_room_and_send_event(room_name, event)
  end

  def find_room_and_send_event(room_name, event) do
    Registry.get_room(room_name)
    |> GenServer.call({:handle_event, event})
  end
end
