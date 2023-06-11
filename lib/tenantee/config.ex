defmodule Tenantee.Config do
  @moduledoc """
  A helper module for managing the configuration of the application.
  """
  alias Tenantee.Redis

  @doc """
  Returns the configuration for the application.
  """
  def get(key, default \\ nil)

  def get(key, default) when is_atom(key) do
    get(Atom.to_string(key), default)
  end

  def get(key, default) when is_bitstring(key) do
    case Redis.command(["GET", key]) do
      {:ok, value} -> if is_nil(value), do: default, else: value
      {:error, _} -> default
    end
  end

  @doc """
  Sets the configuration for the application.
  """
  def set(key, value) when is_atom(key) do
    set(Atom.to_string(key), value)
  end

  def set(key, value) when is_bitstring(key) do
    case Redis.command(["SET", key, value]) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end

  @doc """
  Deletes the configuration for the application.
  """
  def delete(key) when is_atom(key) do
    delete(Atom.to_string(key))
  end

  def delete(key) when is_bitstring(key) do
    case Redis.command(["DEL", key]) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end
end
