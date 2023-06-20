defmodule Tenantee.Entity.CommunicationChannel do
  @moduledoc """
  Helper functions for communication channels.
  """
  alias Tenantee.Schema.CommunicationChannel, as: Schema
  alias Tenantee.Repo

  @doc """
  Creates a new communication channel.
  """
  @spec create(map) :: {:ok, Schema.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs) do
    %Schema{}
    |> Schema.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a communication channel by id.
  """
  @spec get(integer()) :: {:ok, Schema.t()} | {:error, String.t()}
  def get(id) do
    case Repo.get(Schema, id) do
      nil -> {:error, "Communication channel not found"}
      channel -> {:ok, channel}
    end
  end

  @doc """
  Deletes a communication channel.
  """
  @spec delete(integer()) :: :ok | {:error, String.t()}
  def delete(id) do
    with {:ok, channel} <- get(id),
         {:ok, _} <- Repo.delete(channel) do
      :ok
    end
  end
end
