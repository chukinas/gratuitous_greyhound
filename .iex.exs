# Load global config
import_file_if_available("~/.iex.exs")

alias Chukinas.User
alias Chukinas.Chat.{Users, Room}
alias Chukinas.Chat.Room.Registry, as: RoomRegistry
alias Chukinas.Insider.API, as: I

# {:ok, pid} = StateMachine.start_link()

room_name = "yellow"
user = %{User.new(self()) | name: "Jonathan"}
# I.flip(room_name, user)
