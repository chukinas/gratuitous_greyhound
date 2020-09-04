defmodule Chukinas.User do
  alias Chukinas.User

  defstruct name: "", pid: "", uuid: ""

  def upsert(user_list, %User{} = user) do
    user_list
    |> Enum.filter(fn %User{pid: pid} -> pid != user.pid end)
    |> (fn users -> [user | users] end).()
  end
end

