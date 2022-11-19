defmodule TenanteeWeb.Router do
  use TenanteeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TenanteeWeb do
    pipe_through :api

    get "/health-check", HealthCheckController, :index

    scope "/properties" do
      post "/", PropertyController, :add
      get "/", PropertyController, :list
      get "/:id", PropertyController, :get
      patch "/:id", PropertyController, :update
      delete "/:id", PropertyController, :delete
      put "/:id/tenants/:tenant", PropertyController, :add_tenant
      delete "/:id/tenants/:tenant", PropertyController, :remove_tenant
    end

    scope "/tenants" do
      post "/", TenantController, :add
      get "/", TenantController, :list
      get "/:id", TenantController, :get
      patch "/:id", TenantController, :update
      delete "/:id", TenantController, :delete
    end
  end
end
