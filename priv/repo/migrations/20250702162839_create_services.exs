defmodule RestAPI.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :name, :string
      add :description, :string
      add :status, :string
      add :assisted_people, :integer
      add :amount, :decimal
      add :prayed_for, :integer
      add :challenge_type, :string
      add :people_prayed_for, :string
      add :date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
