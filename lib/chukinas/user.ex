defmodule Chukinas.User do
  alias Chukinas.User

  # *** *******************************
  # *** TYPES

  @enforce_keys k = [:uuid, :pids]
  defstruct k ++ [:id, name: ""]
  @type t :: %__MODULE__{uuid: any(), pids: [pid()], id: integer() | nil, name: String.t()}

  @spec new(any()) :: t()
  def new(uuid) do
    %User{uuid: uuid, pids: [self()]}
  end

  # *** *******************************
  # *** OTHER

  def remove_pid(user, pid) do
    pids = Enum.filter(user.pids, fn p -> p != pid end)
    Map.put(user, :pids, pids)
  end

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
