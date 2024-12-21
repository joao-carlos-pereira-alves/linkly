defmodule LinklyWeb.Router do
  use LinklyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LinklyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug LinklyWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Escopo para rotas públicas (login, etc.)
  scope "/", LinklyWeb do
    pipe_through :browser

    get "/", SessionController, :new
    get "/login", SessionController, :new
    post "/", SessionController, :login
    post "/login", SessionController, :login
  end

  # Escopo para rotas autenticadas
  scope "/", LinklyWeb do
    pipe_through [:browser, :auth]

    get "/home", LinkController, :index
  end

  scope "/in", LinklyWeb do
    pipe_through :browser

    # Rota para redirecionar o link encurtado
    get "/:shortened_url", LinkController, :redirect_to_original
  end

  # Other scopes may use custom stacks.
  # scope "/api", LinklyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:linkly, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LinklyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
