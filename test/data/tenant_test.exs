defmodule Tenantee.Data.TenantTest do
  use Tenantee.DataCase
  alias Tenantee.Entity.Tenant
  import Tenantee.Test.Factory.{Tenant, Property}

  test "creates a tenant" do
    assert {:ok, _tenant} =
             Tenant.create(%{
               first_name: Faker.Person.first_name(),
               last_name: Faker.Person.last_name()
             })
  end

  test "updates a tenant" do
    {:ok, tenant} = generate_tenant()

    assert :ok =
             Tenant.update(tenant.id, %{
               first_name: Faker.Person.first_name(),
               last_name: Faker.Person.last_name()
             })
  end

  test "deletes a tenant" do
    {:ok, tenant} = generate_tenant()

    assert :ok = Tenant.delete(tenant.id)
  end

  test "gets all tenants" do
    {:ok, _tenant} = generate_tenant()

    assert [] != Tenant.all()
  end

  test "gets tenant count" do
    {:ok, _tenant} = generate_tenant()

    assert 1 = Tenant.count()
  end

  test "gets tenant by id" do
    {:ok, tenant} = generate_tenant()

    assert {:ok, found_tenant} = Tenant.get(tenant.id)

    assert found_tenant.id == tenant.id
  end

  test "adds & removes tenant from property" do
    {:ok, tenant} = generate_tenant()
    {:ok, property} = generate_property()

    assert :ok = Tenant.add_to_property(tenant.id, property.id)
    assert :ok = Tenant.remove_from_property(tenant.id, property.id)
  end

  test "adds communication channel to tenant" do
    {:ok, tenant} = generate_tenant()

    assert :ok =
             Tenant.add_communication_channel(
               tenant.id,
               %{type: "email", value: Faker.Internet.email()}
             )
  end

  test "errors when getting tenant by id" do
    assert {:error, "Tenant not found."} = Tenant.get(-1)
  end

  test "errors when deleting tenant by id" do
    assert {:error, "Tenant not found."} = Tenant.delete(-1)
  end

  test "errors when updating tenant" do
    assert {:error, "Tenant not found."} =
             Tenant.update(-1, %{
               first_name: Faker.Person.first_name(),
               last_name: Faker.Person.last_name()
             })
  end
end
