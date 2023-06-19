defmodule TenanteeWeb.ErrorHTML do
  @moduledoc """
  Default error HTML templates.
  """

  use TenanteeWeb, :html

  embed_templates "error_html/*"

  @doc """
  The default error page render.
  """
  @spec render(String.t(), Keyword.t()) :: String.t()
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
