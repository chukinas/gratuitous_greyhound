# TODO rename Chukinas.Sessions.SessionSupervisor ?
alias Chukinas.SessionSupervisor
alias Chukinas.Sessions.RoomRegistry
alias Chukinas.Sessions.RoomDynamicSupervisor
alias Chukinas.Sessions.UserRegistry
alias Chukinas.Sessions.Players

defmodule SessionSupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      RoomRegistry,
      RoomDynamicSupervisor,
      UserRegistry,
      Players,
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
