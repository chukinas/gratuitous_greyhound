alias Chukinas.Sessions.Room.Impl
alias Chukinas.Util.Maps

defmodule Impl do
  use TypedStruct

  typedstruct do
    field :name, String.t, enforce: true
    field :members, [String.t], default: []
  end

  # *** *******************************
  # *** NEW

  def new(room_name) do
    %__MODULE__{
      name: room_name
    }
  end

  # *** *******************************
  # *** GETTERS

  def members(%__MODULE__{members: value}), do: value

  def member_count(room) do
    room
    |> members
    |> Enum.count
  end

  # *** *******************************
  # *** API

  def add_member(room, member_name) do
    room = Maps.push(room, :members, member_name)
    member_number = room |> member_count
    {:ok, member_number, room}
  end

  def print_members(room) do
    room
    |> members
    |> Enum.reverse
    |> Stream.with_index(1)
    |> Enum.each(fn {member_name, number} -> IO.puts("#{number}: #{member_name}") end)
    nil
  end

end
