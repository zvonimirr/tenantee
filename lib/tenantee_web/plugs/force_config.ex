defmodule TenanteeWeb.Plugs.ForceConfig do
  @moduledoc """
  Force config to be loaded before any request is processed.
  """
  alias Tenantee.Config
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    if Config.lacks_config?() do
      conn
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end
end
