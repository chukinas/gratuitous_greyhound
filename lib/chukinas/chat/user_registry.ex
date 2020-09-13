defmodule Chukinas.Chat.UserRegistry do
  use GenServer
  alias Chukinas.User

  #############################################################################
  # CLIENT API
  #############################################################################

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def upsert(%User{} = user) do
    __MODULE__
    |> GenServer.call({:upsert, user})
    |> notify()
    :ok
  end

  #############################################################################
  # SERVER CALLBACKS
  #############################################################################

  @impl true
  def init(_opts) do
    users = Map.new()
    {:ok, users}
  end

  @impl true
  def handle_call({:upsert, %User{} = user}, _from, users) do
    if not Map.has_key?(users, user.pid), do: Process.monitor(user.pid)
    users = Map.put users, user.pid, user
    {:reply, Map.values(users), users}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, object, _reason}, users) do
    users =
      users
      |> Map.delete(object)
      |> notify()
    {:noreply, users}
  end

  #############################################################################
  # HELPERS
  #############################################################################

  defp notify(users) when is_map(users) do
    notify Map.values(users)
    users
  end

  defp notify(users) when is_list(users) do
    Enum.each(users, fn user ->
      send(user.pid, {:update_user_list, users})
    end)
    users
  end

end
