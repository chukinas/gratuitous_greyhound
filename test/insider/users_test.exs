defmodule Chukinas.Insider.Core.UsersTest do
  use ExUnit.Case
  alias Chukinas.Insider.Core.{Users}
  alias Chukinas.User

  # *** *******************************
  # *** USER

  test "adding a user" do
    users =
      build_users()
      |> Users.add(build_user())
    user_list =Map.get(users, :list)
    assert 1 = Enum.count(user_list)
    users = Users.unregister_pid(users, self())
    [user | []] = users.list
    assert 0 = Enum.count(user.pids)
  end

  test "new user, then register" do
    assert :new = Users.lookup_user_id(build_users, build_user)
    users = Users.add(build_users, build_user)
    assert 1 = Users.lookup_user_id(users, build_user)

  end

  def build_users() do
    Users.new()
  end

  def build_user() do
    User.new("Jonathan")
  end
end
