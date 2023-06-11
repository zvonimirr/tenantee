defmodule Tenantee.Redis do
  @moduledoc """
  Redis client for Tenantee, using Redix.
  """

  @doc """
  Sends commands to Redis, utilizing the already configured Redix app.
  """
  def command(command, args \\ []) do
    Redix.command(:redix, command, args)
  end
end
