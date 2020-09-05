defmodule Chukinas.Chat.Supervisor do
  use Supervisor
  alias Chukinas.Chat.UserRegistry

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      UserRegistry
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
