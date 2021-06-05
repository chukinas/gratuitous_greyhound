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

  def count do
    Registry.count(@me)
  end

end
