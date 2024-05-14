defmodule EtWeb.Router do
  use EtWeb, :router

  import EtWeb.StudentAuth,
    only: [
      fetch_current_student: 2,
      redirect_if_logged_in: 2
    ]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {EtWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_student
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/practice", EtWeb do
    pipe_through [:browser]

    get "/", TopicController, :index

    live "/:topic_id", TenderLive
  end

  scope "/", EtWeb do
    pipe_through [:browser, :redirect_if_logged_in]

    get "/", TenderController, :index
  end

  scope "/", EtWeb do
    pipe_through :browser

    post "/login", TenderController, :login
    delete "/logout", TenderController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", EtWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:exam_tender, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: EtWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
