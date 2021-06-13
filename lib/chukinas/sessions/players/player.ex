defmodule Chukinas.Sessions.User do

  alias Chukinas.Dreadnought.Player
  alias Chukinas.Sessions.UserSession

  # *** *******************************
  # *** TYPES

  use TypedStruct
  typedstruct enforce: false do
    field :uuid, String.t(), enforce: true
    field :name, String.t()
    field :room_name, String.t()
    field :player_id, integer
    field :players, [Player.t]
  end

  # *** *******************************
  # *** NEW

  def new do
    new Ecto.UUID.generate()

  end

  def new(uuid) do
    %__MODULE__{
      uuid: uuid
    }
  end

  # *** *******************************
  # *** GETTERS

  def uuid(%__MODULE__{uuid: value}), do: value

  def name(%__MODULE__{name: value}), do: value

  def room_name(%__MODULE__{room_name: value}), do: value


  # *** *******************************
  # *** SETTERS

  def merge_user_session(
    %__MODULE__{} = user,
    %UserSession{} = user_session
  ) do
    new_values = %{
      name: user_session |> UserSession.username,
      room_name: user_session |> UserSession.room,
    }
    Map.merge(user, new_values)
  end

end
