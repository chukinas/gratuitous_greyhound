defmodule Chukinas.Repo do
  use Ecto.Repo,
    otp_app: :chukinas,
    adapter: Ecto.Adapters.Postgres
end
