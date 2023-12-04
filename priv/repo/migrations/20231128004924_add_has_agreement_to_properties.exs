defmodule Tenantee.Repo.Migrations.AddHasAgreementToProperties do
  use Ecto.Migration

  def change do
    alter table(:properties) do
      add :has_agreement, :boolean
    end
  end
end
