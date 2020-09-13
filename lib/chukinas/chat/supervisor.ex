defmodule Chukinas.Chat.Supervisor do
  use Supervisor
  alias Chukinas.Chat.Room

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      Room.Registry,
      {DynamicSupervisor, strategy: :one_for_one, name: Room.Supervisor}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
