defmodule RestAPI.Accounts.Deacon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "deacons" do
    field :age, :integer
    field :contact, :string
    field :email, :string
    field :full_name, :string
    field :role, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(deacon, attrs) do
    deacon
    |> cast(attrs, [:full_name, :email, :age, :contact, :role])
    |> validate_required([:full_name, :email, :age, :contact, :role])
  end
end
