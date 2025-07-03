defmodule RestAPI.Repo.Migrations.CreateRasilimali do
  use Ecto.Migration

  def change do
    create table(:rasilimali) do
      add :jina_la_vifaa, :string
      add :idadi_jumla, :integer
      add :hali, :string
      add :imara, :integer
      add :vibovu, :integer
      add :uhitaji, :string
      add :idadi_ya_uhitaji, :integer
      add :gharama, :decimal

      timestamps(type: :utc_datetime)
    end
  end
end
