defmodule TenanteeWeb.Router do
  use TenanteeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TenanteeWeb do
    pipe_through :api
  end
end
