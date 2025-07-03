defmodule RestAPI.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :amount, :decimal
    field :assisted_people, :integer
    field :challenge_type, :string
    field :date, :date
    field :description, :string
    field :name, :string
    field :people_prayed_for, :string
    field :prayed_for, :integer
    field :status, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:name, :description, :status, :assisted_people, :amount, :prayed_for, :challenge_type, :people_prayed_for, :date])
    |> validate_required([:name, :description, :status, :assisted_people, :amount, :prayed_for, :challenge_type, :people_prayed_for, :date])
  end
end
