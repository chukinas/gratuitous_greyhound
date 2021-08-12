# TODO rename PlayerProcesses?

defmodule Dreadnought.Sessions.PlayerRegistry do
  @moduledoc"""
  Maps player UUIDs to PIDs

  For human players, a UUID will map to 0..* LiveViews.
  For AI players, a UUID will map to a GenServer.
  """

  @me :user_registry

  def child_spec(_init_arg) do
    Registry.child_spec(keys: :unique, name: @me)
  end

  def register(user_uuid) do
    Registry.register(@me, user_uuid, nil)
  end

  def pids(user_uuid) do
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
