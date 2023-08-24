defmodule TenanteeWeb.Router do
  use TenanteeWeb, :router
  alias TenanteeWeb.Csp
  alias TenanteeWeb.Plugs.ForceConfig

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TenanteeWeb.Layouts, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" => Csp.generate_csp()
    }
  end

  pipeline :config_required do
    plug ForceConfig
  end

  scope "/", TenanteeWeb do
    pipe_through :browser

    live "/", HomeLive

    scope "/properties" do
      pipe_through :config_required

      live "/", PropertyLive.List
      live "/new", PropertyLive.Add

      scope "/:id" do
        live "/", PropertyLive.Edit
        live "/expenses", PropertyLive.Expenses
      end
    end

    scope "/tenants" do
      pipe_through :config_required

      live "/", TenantLive.List
      live "/new", TenantLive.Add

      scope "/:id" do
        live "/", TenantLive.Edit
        live "/channels", TenantLive.CommunicationChannels
        live "/rents", TenantLive.Rent
      end
    end

    live "/settings", ConfigLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TenanteeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tenantee, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TenanteeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
