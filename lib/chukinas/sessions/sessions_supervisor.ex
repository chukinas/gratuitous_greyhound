alias Chukinas.SessionSupervisor
#alias Chukinas.Sessions.Room

defmodule SessionSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      Chukinas.Sessions.RoomRegistry,
      Chukinas.Sessions.RoomDynamicSupervisor,
      #{Chukinas.Sessions.RoomRegistry, []},
      #{Room, "red"},
      #{Room, "black"},
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_room(room_name) do
    {_, pid, _, _} = Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {current_room_name, _, _, _} ->
      current_room_name == room_name
    end)
    pid
  end

end
