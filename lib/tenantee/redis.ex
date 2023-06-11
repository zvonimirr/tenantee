defmodule Tenantee.Redis do
  @moduledoc """
  Redis client for Tenantee, using Redix.
  """

  @doc """
  Sends commands to Redis, utilizing the already configured Redix app.
  """
  @spec command([String.t()], [term]) :: {:ok, term} | {:error, term}
  def command(command, args \\ []) do
    Redix.command(:redix, command, args)
  end
end
