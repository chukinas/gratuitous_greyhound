defmodule Chukinas.Insider.Users do
  alias Chukinas.User

  @type t :: list(%User{})

  @spec new() :: __MODULE__.t()
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

end
