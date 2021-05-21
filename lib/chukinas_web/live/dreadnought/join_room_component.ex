defmodule ChukinasWeb.Dreadnought.JoinRoomComponent do
  use ChukinasWeb, :live_component

  #use Ecto.Schema
  # http://blog.plataformatec.com.br/2016/05/ectos-insert_all-and-schemaless-queries/

  def validate(params) do
    data  = %{}
    types = %{first_name: :string, last_name: :string, email: :string}

    changeset =
      {data, types}
      |> Ecto.Changeset.cast(params, Map.keys(types))
      #|> validate_required(...)
      #|> validate_length(...)
    changeset
  end

  @impl true
  def render(assigns) do
    ChukinasWeb.DreadnoughtView.render("component_join_room.html", assigns)
  end
end
