defmodule Chukinas.Insider.Boundary.Supervisor do
  use Supervisor
  alias Chukinas.Insider.Boundary.{Room, Registry}

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      Registry,
      {DynamicSupervisor, strategy: :one_for_one, name: Room.Supervisor}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
