defmodule TenanteeWeb.Router do
  use TenanteeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/swagger" do
    # coveralls-ignore-start
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :tenantee,
      swagger_file: "swagger.json"

    # coveralls-ignore-stop
  end

  scope "/api", TenanteeWeb do
    pipe_through :api

    get "/health-check", HealthCheckController, :index

    scope "/properties" do
      post "/", PropertyController, :add
      get "/", PropertyController, :list
      get "/:id", PropertyController, :find
      patch "/:id", PropertyController, :update
      delete "/:id", PropertyController, :delete_by_id
      put "/:id/tenants/:tenant", PropertyController, :add_tenant
      delete "/:id/tenants/:tenant", PropertyController, :remove_tenant
      get "/:id/rents/unpaid", PropertyController, :unpaid_rents
    end

    scope "/tenants" do
      post "/", TenantController, :add
      get "/", TenantController, :list
      get "/:id", TenantController, :find
      patch "/:id", TenantController, :update
      delete "/:id", TenantController, :delete_by_id
      get "/:id/rents", TenantController, :all_rents
      get "/:id/rents/unpaid", TenantController, :unpaid_rents
    end

    scope "/rent" do
      get "/", RentController, :list
      get "/paid", RentController, :list_paid
      get "/unpaid", RentController, :list_unpaid
      post "/:id/mark-as-paid", RentController, :mark_as_paid
      post "/:id/mark-as-unpaid", RentController, :mark_as_unpaid
    end

    scope "/preferences" do
      get "/", PreferencesController, :list
      put "/", PreferencesController, :set
    end
  end

  # coveralls-ignore-start
  def swagger_info do
    %{
      schemes: ["http", "https"],
      info: %{
        title: "Tenantee API",
        version: Keyword.get(Tenantee.MixProject.project(), :version),
        description: "API for the Tenantee platform"
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{
          name: "General",
          description: "General API information"
        },
        %{
          name: "Property",
          description: "Property management"
        },
        %{
          name: "Tenant",
          description: "Tenant management"
        },
        %{
          name: "Rent",
          description: "Rent management"
        },
        %{
          name: "Preferences",
          description: "Preferences management"
        }
      ]
    }
  end

  # coveralls-ignore-stop
end
