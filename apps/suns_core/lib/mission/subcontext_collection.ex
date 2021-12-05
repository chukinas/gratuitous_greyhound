defmodule SunsCore.Mission.Subcontext.Collection do

  alias SunsCore.Mission.Subcontext

  # *** *******************************
  # *** TYPES

  @type t :: [Subcontext.t]

  # *** *******************************
  # *** CONSTRUCTORS

  def new, do: []

  # *** *******************************
  # *** REDUCERS

  def put(subcontexts, subcontext) do
    [subcontext | delete(subcontexts, subcontext)]
  end

  def delete(subcontexts, module_or_struct) do
    Enum.reject(subcontexts, &Subcontext.same_type?(&1, module_or_struct))
  end

  # *** *******************************
  # *** CONVERTERS

  def has?(subcontexts, module_or_struct) do
    Enum.any?(subcontexts, &Subcontext.same_type?(&1, module_or_struct))
  end

  def fetch!(subcontexts, module_or_struct) do
    true = has?(subcontexts, module_or_struct)
    Enum.find(subcontexts, &Subcontext.same_type?(&1, module_or_struct))
  end

end
