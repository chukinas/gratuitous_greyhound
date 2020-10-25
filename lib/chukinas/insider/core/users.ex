defmodule Chukinas.Insider.Core.Users do
  alias Chukinas.User
  alias Chukinas.Insider.Core.Users

  # *** *******************************
  # *** TYPES

  defstruct list: [],
            next_id: 1

  @type t :: %__MODULE__{list: list(User.t()), next_id: integer()}

  @spec new() :: t()
  def new(), do: %__MODULE__{list: [], next_id: 1}

  # *** *******************************
  # *** PID

  @spec lookup_user_id(t(), User.t()) :: integer() | :new
  def lookup_user_id(users, user) do
    case Enum.find(users.list, fn u -> User.are_same_user?(u, user) end) do
      %User{id: id} -> id
      _ -> :new
    end
  end

  @spec unregister_pid(t(), pid()) :: t()
  def unregister_pid(users, pid) do
    list = Enum.map(users.list, &User.remove_pid(&1, pid))
    %{users | list: list}
  end

  # *** *******************************
  # *** USER

  @spec add(Users.t(), User.t()) :: Users.t()
  def add(users, user) do
    user = User.set_id(user, users.next_id)
    list = [user | users.list]
    %{users | list: list, next_id: users.next_id + 1}
  end
end
