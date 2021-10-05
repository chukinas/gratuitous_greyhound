defmodule SunsCore.Event.Setup.AddTable do

  use SunsCore.Event, :impl
  alias SunsCore.Space.ShapeWithArea
  alias SunsCore.Mission.Table
  alias SunsCore.Mission.Contract
  alias Util.IdList

  # *** *******************************
  # *** TYPES

  event_struct do
    field :shape, ShapeWithArea.t
  end

  # *** *******************************
  # *** CONSTRUCTORS

  @spec new(ShapeWithArea.t) :: t
  def new(shape) do
    %__MODULE__{
      shape: shape
    }
  end

  # *** *******************************
  # *** CONVERTERS

  def we_have_enough_tables?(_, snapshot) do
    required_table_count =
      snapshot
      |> S.contracts
      |> Contract.Collection.required_table_count
    current_table_count =
      snapshot
      |> S.tables
      |> Enum.count
    (current_table_count >= required_table_count)
  end

  # *** *******************************
  # *** CALLBACKS

  @impl Event
  def guard(ev, snapshot) do
    if we_have_enough_tables?(ev, snapshot) do
      {:error, "There are already enough tables!"}
    else
      :ok
    end
  end

  @impl Event
  def action(%__MODULE__{shape: shape}, snapshot) do
    table =
      snapshot
      |> S.tables
      |> IdList.next_id
      |> Table.new(shape)
    snapshot
    |> S.put_new(table)
    |> ok
  end

  @impl Event
  def post_guard(ev, snapshot) do
    if we_have_enough_tables?(ev, snapshot) do
      # TODO this should probably be called :proceed ?
      :ok
    else
      :stay
    end
  end

end
