defmodule Chukinas.SessionsTest do
  #use Chukinas.DataCase

  #alias Chukinas.Sessions

  #describe "user_sessions" do
  #  alias Chukinas.Sessions.UserSession

  #  @valid_attrs %{username: "some username"}
  #  @update_attrs %{username: "some updated username"}
  #  @invalid_attrs %{username: nil}

  #  def user_session_fixture(attrs \\ %{}) do
  #    {:ok, user_session} =
  #      attrs
  #      |> Enum.into(@valid_attrs)
  #      |> Sessions.create_user_session()

  #    user_session
  #  end

  #  test "list_user_sessions/0 returns all user_sessions" do
  #    user_session = user_session_fixture()
  #    assert Sessions.list_user_sessions() == [user_session]
  #  end

  #  test "get_user_session!/1 returns the user_session with given id" do
  #    user_session = user_session_fixture()
  #    assert Sessions.get_user_session!(user_session.id) == user_session
  #  end

  #  test "create_user_session/1 with valid data creates a user_session" do
  #    assert {:ok, %UserSession{} = user_session} = Sessions.create_user_session(@valid_attrs)
  #    assert user_session.username == "some username"
  #  end

  #  test "create_user_session/1 with invalid data returns error changeset" do
  #    assert {:error, %Ecto.Changeset{}} = Sessions.create_user_session(@invalid_attrs)
  #  end

  #  test "update_user_session/2 with valid data updates the user_session" do
  #    user_session = user_session_fixture()
  #    assert {:ok, %UserSession{} = user_session} = Sessions.update_user_session(user_session, @update_attrs)
  #    assert user_session.username == "some updated username"
  #  end

  #  test "update_user_session/2 with invalid data returns error changeset" do
  #    user_session = user_session_fixture()
  #    assert {:error, %Ecto.Changeset{}} = Sessions.update_user_session(user_session, @invalid_attrs)
  #    assert user_session == Sessions.get_user_session!(user_session.id)
  #  end

  #  test "delete_user_session/1 deletes the user_session" do
  #    user_session = user_session_fixture()
  #    assert {:ok, %UserSession{}} = Sessions.delete_user_session(user_session)
  #    assert_raise Ecto.NoResultsError, fn -> Sessions.get_user_session!(user_session.id) end
  #  end

  #  test "change_user_session/1 returns a user_session changeset" do
  #    user_session = user_session_fixture()
  #    assert %Ecto.Changeset{} = Sessions.change_user_session(user_session)
  #  end
  #end

  #describe "rooms" do
  #  alias Chukinas.Sessions.Room

  #  @valid_attrs %{name: "some name"}
  #  @update_attrs %{name: "some updated name"}
  #  @invalid_attrs %{name: nil}

  #  def room_fixture(attrs \\ %{}) do
  #    {:ok, room} =
  #      attrs
  #      |> Enum.into(@valid_attrs)
  #      |> Sessions.create_room()

  #    room
  #  end

  #  test "list_rooms/0 returns all rooms" do
  #    room = room_fixture()
  #    assert Sessions.list_rooms() == [room]
  #  end

  #  test "get_room!/1 returns the room with given id" do
  #    room = room_fixture()
  #    assert Sessions.get_room!(room.id) == room
  #  end

  #  test "create_room/1 with valid data creates a room" do
  #    assert {:ok, %Room{} = room} = Sessions.create_room(@valid_attrs)
  #    assert room.name == "some name"
  #  end

  #  test "create_room/1 with invalid data returns error changeset" do
  #    assert {:error, %Ecto.Changeset{}} = Sessions.create_room(@invalid_attrs)
  #  end

  #  test "update_room/2 with valid data updates the room" do
  #    room = room_fixture()
  #    assert {:ok, %Room{} = room} = Sessions.update_room(room, @update_attrs)
  #    assert room.name == "some updated name"
  #  end

  #  test "update_room/2 with invalid data returns error changeset" do
  #    room = room_fixture()
  #    assert {:error, %Ecto.Changeset{}} = Sessions.update_room(room, @invalid_attrs)
  #    assert room == Sessions.get_room!(room.id)
  #  end

  #  test "delete_room/1 deletes the room" do
  #    room = room_fixture()
  #    assert {:ok, %Room{}} = Sessions.delete_room(room)
  #    assert_raise Ecto.NoResultsError, fn -> Sessions.get_room!(room.id) end
  #  end

  #  test "change_room/1 returns a room changeset" do
  #    room = room_fixture()
  #    assert %Ecto.Changeset{} = Sessions.change_room(room)
  #  end
  #end
end
