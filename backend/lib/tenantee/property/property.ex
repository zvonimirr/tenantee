defmodule Tenantee.Property do
  alias Tenantee.Repo
  alias Tenantee.Property.Schema
  import Ecto.Query

  def create_property(attrs) do
    %Schema{}
    |> Schema.changeset(attrs)
    |> Repo.insert()
  end

  def get_property(id) do
    Repo.get(Schema, id)
  end

  def get_all_properties do
    Repo.all(Schema)
  end

  def update_property(id, attrs) do
    get_property(id)
    |> Schema.changeset(attrs)
    |> Repo.update()
  end

  def delete_property(id) do
    from(p in Schema, where: p.id == ^id)
    |> Repo.delete_all()
  end
end
