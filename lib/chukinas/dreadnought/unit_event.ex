alias Chukinas.Dreadnought.{Unit}
alias Unit.Event, as: Ev

defprotocol Ev do
  @moduledoc """
  Something a unit actually does or experiences during a turn

  While UnitActions represent things a unit *chooses* to do,
  Events represent things that *actually* happen,
  such as the rotation of a turret or the sinking of the ship.
  """

  def event?(event)

  def delay_and_duration(event)

  def stashable?(event)

  #def duration(event)
end
