defmodule Chukinas.Insider.API do

  alias Chukinas.Insider.Server

  def start_link(room_name) do
    Server.start_link(room_name)
  end

  def flip() do
    event = {:flip, self()}
    Server.handle_event(event)
  end

end
