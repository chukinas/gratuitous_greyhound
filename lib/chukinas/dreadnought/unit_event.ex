alias Chukinas.Dreadnought.{Unit}

defprotocol Unit.Event do
  @moduledoc """
  Something a unit actually does or experiences during a turn

  While UnitActions represent things a unit *chooses* to do,
  Unit.Events represent things that *actually* happen,
  such as the rotation of a turret or the sinking of the ship.
  """

  def event?(event)

  def delay_and_duration(event)

  #def delay(event)

  #def duration(event)
end
