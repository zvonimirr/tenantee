defmodule Tenantee.Repo.Migrations.AddAgreementParamsToProperties do
  use Ecto.Migration

  def change do
    alter table(:properties) do
      add :agreement_params, :map
    end
  end
end
