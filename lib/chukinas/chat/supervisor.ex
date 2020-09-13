defmodule Chukinas.Chat.Supervisor do
  use Supervisor
  alias Chukinas.Chat.Room.Registry, as: RoomRegistry
  alias Chukinas.Chat.Room.Supervisor, as: RoomSupervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      RoomRegistry,
      RoomSupervisor
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
