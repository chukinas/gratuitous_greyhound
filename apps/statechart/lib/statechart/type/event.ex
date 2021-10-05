defmodule Statechart.Type.Event do

  # *** *******************************
  # *** TYPES

  @type t :: atom

  # *** *******************************
  # *** CONSTRUCTORS

  def to_atom(event), do: coerce(event)

  @deprecated "use to_atom/1 instead"
  def coerce(%{__struct__: module}), do: module
  def coerce(event), do: event

  # *** *******************************
  # *** REDUCERS

  # *** *******************************
  # *** CONVERTERS

end
