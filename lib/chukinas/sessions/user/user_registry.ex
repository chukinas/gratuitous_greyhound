alias Chukinas.Sessions.User

defmodule User.Registry do

  @me :user_registry

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: @me)
  end

  #def start_link(_init_arg) do
  #  Registry.start_link(keys: :unique, name: @me)
  #end

  def register(user_uuid) do
    Registry.register(@me, user_uuid, nil)
  end

  def pids(user_uuid) do
    #IOP.inspect Registry.keys(@me), "User reg, pids, keys"
    for {pid, _value} <- Registry.lookup(@me, user_uuid), do: pid
  end

  def count do
    Registry.count(@me)
  end

  def all_uuids do
    Registry.select @me, [{
      {:"$1", :_, :_},
      [],
      [:"$1"]
    }]
  end

end
