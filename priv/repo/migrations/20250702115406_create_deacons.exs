defmodule RestAPI.Repo.Migrations.CreateDeacons do
  use Ecto.Migration

  def change do
    create table(:deacons) do
      add :full_name, :string
      add :email, :string
      add :age, :integer
      add :contact, :string
      add :role, :string

      timestamps(type: :utc_datetime)
    end
  end
end
