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
    if lacks_config?() do
      conn
      |> redirect(to: "/")
      |> halt()
    else
      conn
    end
  end

  @doc """
  Check if any of the required config values are missing.
  """
  @spec lacks_config?() :: boolean()
  def lacks_config?() do
    [
      Config.get(:name),
      Config.get(:currency)
    ]
    |> Enum.map(&elem(&1, 0))
    |> Enum.any?(&(&1 == :error))
  end
end
