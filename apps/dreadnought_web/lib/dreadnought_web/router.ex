defmodule DreadnoughtWeb.Router do

  use DreadnoughtWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DreadnoughtWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :dreadnought do
    plug :browser
    plug :put_uuid_in_session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DreadnoughtWeb do
    pipe_through :browser
    get "/", PageController, :redirect_to_dreadnought
    get "/minis", PageController, :redirect_to_dreadnought
    get "/music", PageController, :redirect_to_dreadnought
    get "/dev", PageController, :dev
    get "/elixir-reading", PageController, :redirect_to_goodreads_elixir
  end

  scope "/dreadnought", DreadnoughtWeb do
    pipe_through :dreadnought
    live "/", MainLive, :homepage, as: :dreadnought_main
    live "/play", PlayLive, :play, as: :dreadnought_main
    live "/demo", MainLive, :demo, as: :dreadnought_main
    live "/gallery", MainLive, :gallery, as: :dreadnought_main
    get "/grid", PageController, :redirect_to_dreadnought
    live "/setup", MainLive, :setup, as: :dreadnought_main
    # TODO temp:
    live "/world", WorldLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", DreadnoughtWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: DreadnoughtWeb.Telemetry
    end
  end

  # TODO move this to a module?
  def put_uuid_in_session(conn, _opts) do
    {conn, uuid} =
      case conn.req_cookies["uuid"] do
        nil ->
          uuid = Ecto.UUID.generate()
          conn = put_resp_cookie(conn, "uuid", uuid, path: "/dreadnought")
          {conn, uuid}
        uuid ->
          {conn, uuid}
      end
    put_session(conn, :uuid, uuid)
  end

end
