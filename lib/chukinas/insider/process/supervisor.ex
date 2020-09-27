defmodule Chukinas.Insider.Supervisor do
  use Supervisor
  alias Chukinas.Insider
  alias Chukinas.Insider.Room

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      Insider.Registry,
      {DynamicSupervisor, strategy: :one_for_one, name: Room.Supervisor}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
