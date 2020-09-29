defmodule Chukinas.Insider.Users do
  alias Chukinas.User

  @type t :: list(User.t())

  @spec new() :: t()
  def new(), do: []

  # get_id(%{:uuid => user_uuid, :pid => user_pid} = user, users) do
  def set_id(user, users) do
    # TODO implement
    # user =
    #   user
    #   |> Map.put(new?: true)
    #   |> Map.put(id: 1)
    {user, users}
  end

  @spec populate_id(t(), User.t()) :: User.t()
  def populate_id(users, user) do
    user_id = case Enum.find(users, fn u -> User.have_matching_pid([u, user]) end) do
      nil -> :new
      existing_user -> User.get_id(existing_user)
    end
    User.set_id(user, user_id)
  end

end
