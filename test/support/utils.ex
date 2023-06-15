defmodule Tenantee.Test.Utils do
  @moduledoc """
  Collection of helper functions for testing
  """

  @doc """
  Decodes HTML entities in a string
  """
  @spec decode_html_entities(String.t()) :: String.t()
  def decode_html_entities(string) when is_bitstring(string) do
    HtmlEntities.decode(string)
  end
end
