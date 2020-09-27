defmodule Chukinas.Insider.Phase do
  @type t :: :on | :off

  # defguard is_valid(phase) when phase in [:on, :off]

  def initial(), do: :off

  @spec flip(t()) :: t()
  def flip(:off), do: :on
  def flip(:on), do: :off
end
