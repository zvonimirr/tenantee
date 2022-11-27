defmodule Tenantee.Utils.Error do
  use TenanteeWeb, :controller
  alias TenanteeWeb.ErrorView

  @moduledoc """
  Error handling utilities.
  """

  @doc """
  Given a connection, return a proper response with the error message.
  """
  def respond(conn, status, message) when is_binary(message) and is_atom(status) do
    conn
    |> put_status(status)
    |> put_view(ErrorView)
    |> render("error.json", %{message: message})
  end
end
