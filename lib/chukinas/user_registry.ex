defmodule Chukinas.Chat.UserRegistry do
  use GenServer

  #############################################################################
  # CLIENT API
  #############################################################################

  def start_link(_opts) do
    IO.puts("\nstarting Chukinas.Chat.UserRegistry!!!\n")
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def upsert_user(new_user) do
    new_user_list = GenServer.call(__MODULE__, {:upsert_user, new_user})
    Enum.each(new_user_list, fn {pid, _user_name} ->
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
  def handle_call({:upsert_user, user}, _from, user_list) do
    new_user_list = _upsert_user(user_list, user)
    {:reply, new_user_list, new_user_list}
  end

  #############################################################################
  # HELPERS
  #############################################################################

  defp _upsert_user(user_list, { new_pid, _user_name } = new_user) do
    user_list
    |> Enum.filter(fn {pid, _user_name} -> pid != new_pid end)
    |> (fn users -> [new_user | users] end).()
    # |> (&[new_user | &1]) TODO try to make this work
  end
end
