defmodule Chukinas.User do
  alias Chukinas.User

  # *** *******************************
  # *** TYPES

  @enforce_keys k = [:uuid, :pids, :id]
  defstruct k ++ [name: ""]
  @type user_id :: integer() | :unk | :new
  @type t :: %__MODULE__{uuid: any(), pids: [pid()], id: user_id(), name: String.t()}

  @spec new(uuid :: any()) :: t()
  def new(uuid) do
    %User{uuid: uuid, pids: [self()], id: :unk}
    # %{user | }
  end

  # *** *******************************
  # *** PIDS

  @spec have_matching_pid([t()]) :: boolean()
  def have_matching_pid(users) do
    pid_intersection_count =
      users
      |> Enum.map(&get_pid_mapset/1)
      |> Enum.reduce(nil, &reduce/2)
      |> MapSet.size()
     pid_intersection_count > 0
  end

  defp get_pid_mapset(user) do
    MapSet.new(user.pids)
  end

  defp reduce(mapset, nil), do: mapset
  defp reduce(mapset, acc_mapset) do
    MapSet.intersection(mapset, acc_mapset)
  end

  @spec remove_pid(t(), pid()) :: t()
  def remove_pid(user, pid) do
    pids = List.delete(user.pids, pid)
    %{user | pids: pids}
  end

  # *** *******************************
  # *** UUID

  @spec are_same_user?(t(), t()) :: boolean
  def are_same_user?(left, right) do
    left.uuid === right.uuid
  end

  # *** *******************************
  # *** ID

  @spec get_id(t()) :: user_id()
  def get_id(user), do: user.id

  @spec set_id(t(), user_id()) :: t()
  def set_id(user, id), do: %{user | id: id}

  @spec new?(t()) :: boolean() | {:error, String.t()}
  def new?(%{id: :new}), do: true
  def new?(%{id: id}) when is_integer(id), do: false
  def new?(%{id: :unk}), do: {:error, "Populate user id first!"}

  def mark_new(user), do: %{user | id: :new}

  # *** *******************************
  # *** OTHER

  def update(nil, user_update), do: user_update
  # TODO guard against uuids being different
  def update(user, user_update) do
    user
    |> Map.put(:name, user_update.name)
    |> merge_pids(user_update)
    |> merge_name(user_update)
  end

  def send(user, msg) do
    user.pids
    |> Enum.each(fn pid -> Kernel.send(pid, msg) end)
  end

  #############################################################################
  # HELPERS
  #############################################################################

  defp merge_pids(user, user_update) do
    pids =
      user.pids ++ user_update.pids
      |> Enum.uniq()
    Map.put(user, :pids, pids)
  end

  defp merge_name(user, user_update) do
    name = case user_update.name do
      :undefined -> user.name
      _ -> user_update.name
    end
    Map.put(user, :name, name)
  end
end
