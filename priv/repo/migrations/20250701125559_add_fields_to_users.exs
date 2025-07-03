defmodule MyApp.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :full_name, :string
      add :age, :integer
      add :contact, :string
      add :role, :string, default: "user"
    end
  end
end
