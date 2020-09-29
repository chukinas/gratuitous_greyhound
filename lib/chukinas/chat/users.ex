defmodule Chukinas.Chat.Users do
  alias Chukinas.User

  def new(), do: Map.new()

  def get_pids(users) when is_map(users) do
    users
    |> Map.values()
    |> Enum.map(fn u -> u.pids end)
    |> Enum.concat()
  end

  def upsert(users, %User{} = user_update) when is_map(users) do
    uuid = user_update.uuid
    updated_user = case Map.fetch(users, uuid) do
      {:ok, user} -> User.update(user, user_update)
      :error -> user_update
    end
    Map.put(users, uuid, updated_user)
  end

  def remove_pid(users, pid) when is_pid(pid) do
    user =
      users
      |> get_user(pid)
      |> User.remove_pid(pid)
    Map.put(users, user.uuid, user)
  end

  def as_list(users) do
    Map.values users
  end

  #############################################################################
  # HELPERS
  #############################################################################

  defp get_user(users, pid) when is_pid(pid) do
    users
    |> Map.values()
    |> Enum.find(fn u -> Enum.member?(u.pids, pid) end)
  end

end
