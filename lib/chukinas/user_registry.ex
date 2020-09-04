defmodule Chukinas.Chat.UserRegistry do
  use GenServer
  alias Chukinas.User

  #############################################################################
  # CLIENT API
  #############################################################################

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def upsert_user(%User{} = user) do
    new_user_list = GenServer.call(__MODULE__, {:upsert_user, user})
    Enum.each(new_user_list, fn %User{pid: pid} ->
      send(pid, {:update_user_list, new_user_list})
    end)
    :ok
  end

  #############################################################################
  # SERVER CALLBACKS
  #############################################################################

  @impl true
  def init(_opts) do
    {:ok, []}
  end

  @impl true
  def handle_call({:upsert_user, %User{} = user}, _from, user_list) do
    new_user_list = User.upsert(user_list, user)
    {:reply, new_user_list, new_user_list}
  end
end
