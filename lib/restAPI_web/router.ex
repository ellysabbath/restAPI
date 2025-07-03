defmodule RestAPIWeb.Router do
  use RestAPIWeb, :router

  import RestAPIWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RestAPIWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RestAPIWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/users", PageController, :users
  end

  scope "/api", RestAPIWeb do
    pipe_through :api
    resources "/posts", PostController,except: [:new, :edit]

  end


  # Other scopes may use custom stacks.
  # scope "/api", RestAPIWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:restAPI, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RestAPIWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", RestAPIWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{RestAPIWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", RestAPIWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{RestAPIWeb.UserAuth, :ensure_authenticated}] do
      live "/deacons", DeaconsLive, :index
       live "/services", ServicesLive
       live "/assets", AssetsLive

      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end


  scope "/deacons", RestAPIWeb do
  pipe_through :browser

  live "/", DeaconsLive, :index
  live "/new", DeaconsLive, :new
  live "/:id/edit", DeaconsLive, :edit
end

 pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RestAPIWeb do
    pipe_through :api

    resources "/deacons", DeaconController, except: [:new, :edit]
  end


scope "/api", RestAPIWeb do
  pipe_through :api
  resources "/services", ServiceController, except: [:new, :edit]
end


# lib/restAPI_web/router.ex


scope "/api", RestAPIWeb do
  pipe_through :api
  resources "/rasilimali", RasilimaController, except: [:new, :edit]
end


 scope "/", RestAPIWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{RestAPIWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
