alias Chukinas.Sessions

defmodule ChukinasWeb.Router do
  use ChukinasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChukinasWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_uuid_in_session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChukinasWeb do
    pipe_through :browser
    get "/", PageController, :index
    get "/minis", PageController, :minis
    get "/music", PageController, :music
    live "/dreadnought", DreadnoughtLive
    live "/dreadnought/rooms", DreadnoughtLive, :room
    live "/dreadnought/rooms/:room", DreadnoughtLive, :room
    live "/dreadnought/play", DreadnoughtPlayLive
    live "/dreadnought/gallery", DreadnoughtLive, :gallery
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChukinasWeb do
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
      live_dashboard "/dashboard", metrics: ChukinasWeb.Telemetry
    end
  end

  # TODO move this to a module?
  def put_uuid_in_session(conn, _opts) do
    {conn, uuid} =
      case conn.req_cookies["uuid"] do
        nil ->
          uuid = Sessions.new_uuid()
          conn = put_resp_cookie(conn, "uuid", uuid)
          {conn, uuid}
        uuid ->
          {conn, uuid}
      end
    put_session(conn, :uuid, uuid)
  end

end
