defmodule Tenantee.Data.ExpenseTest do
  alias Tenantee.Entity.Expense
  import Money.Sigil
  import Tenantee.Test.Factory.{Property, Tenant}
  use Tenantee.DataCase

  test "creates an expense" do
    {:ok, property} = generate_property()

    assert {:ok, _expense} =
             Expense.create(%{
               name: "Expense",
               description: "Expense description",
               paid: false,
               amount: ~M[100.00]USD,
               property_id: property.id,
               tenant_id: nil
             })
  end

  test "gets an expense by id" do
    {:ok, property} = generate_property()

    {:ok, expense} =
      Expense.create(%{
        name: "Expense",
        description: "Expense description",
        paid: false,
        amount: ~M[100.00]USD,
        property_id: property.id,
        tenant_id: nil
      })

    assert {:ok, _expense} = Expense.get(expense.id)
  end

  test "deletes an expense" do
    {:ok, property} = generate_property()

    {:ok, expense} =
      Expense.create(%{
        name: "Expense",
        description: "Expense description",
        paid: false,
        amount: ~M[100.00]USD,
        property_id: property.id,
        tenant_id: nil
      })

    assert :ok = Expense.delete(expense.id)
  end

  test "pays the expense" do
    {:ok, property} = generate_property()

    {:ok, expense} =
      Expense.create(%{
        name: "Expense",
        description: "Expense description",
        paid: false,
        amount: ~M[100.00]USD,
        property_id: property.id,
        tenant_id: nil
      })

    assert :ok = Expense.pay(expense.id)
  end

  test "updates the payer" do
    {:ok, property} = generate_property()

    {:ok, expense} =
      Expense.create(%{
        name: "Expense",
        description: "Expense description",
        paid: false,
        amount: ~M[100.00]USD,
        property_id: property.id,
        tenant_id: nil
      })

    {:ok, tenant} = generate_tenant()

    assert {:ok, _expense} = Expense.set_payer(expense, tenant.id)
  end

  test "gets the loss" do
    {:ok, property} = generate_property()

    {:ok, _expense} =
      Expense.create(%{
        name: "Expense",
        description: "Expense description",
        paid: true,
        amount: ~M[100.00]USD,
        property_id: property.id,
        tenant_id: nil
      })

    assert {:ok, amount} = Expense.get_loss()
    assert amount == ~M[100.00]USD
  end

  test "errors when getting expense by id" do
    assert {:error, "Expense not found"} = Expense.get(-1)
  end

  test "errors when deleting expense by id" do
    assert {:error, "Expense not found"} = Expense.delete(-1)
  end
end
