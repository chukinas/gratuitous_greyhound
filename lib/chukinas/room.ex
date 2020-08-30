defmodule Chukinas.Room do
  use GenServer
  alias Chukinas.Room

  #############################################################################
  # STATE
  #############################################################################

  defstruct name: "undefined", messages: []

  #############################################################################
  # CLIENT API
  #############################################################################

  # def start_link(room_name) do
  #   GenServer.start_link(__MODULE__, %Room{name: room_name})
  # end

  #############################################################################
  # SERVER CALLBACKS
  #############################################################################

  @impl true
  def init(room_name) do
    {:ok, %Room{name: room_name}}
  end

  @impl true
  def handle_call({:send_message, msg}, _from, %Room{:messages => messages} = state) do
    messages = [msg | messages] |> print_messages

    {:reply, messages, %{state | messages: messages}}
  end

  #############################################################################
  # HELPERS
  #############################################################################

  defp print_messages(messages) do
    IO.puts(messages)
    messages
  end
end
