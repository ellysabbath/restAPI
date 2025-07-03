defmodule RestAPI.Rasilimali do
  use Ecto.Schema
  import Ecto.Changeset
  alias RestAPI.Repo

  schema "rasilimali" do
    field :gharama, :decimal
    field :hali, :string
    field :idadi_jumla, :integer
    field :idadi_ya_uhitaji, :integer
    field :imara, :integer
    field :jina_la_vifaa, :string
    field :uhitaji, :string
    field :vibovu, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rasilimali, attrs) do
    rasilimali
    |> cast(attrs, [
      :jina_la_vifaa,
      :idadi_jumla,
      :hali,
      :imara,
      :vibovu,
      :uhitaji,
      :idadi_ya_uhitaji,
      :gharama
    ])
    |> validate_required([
      :jina_la_vifaa,
      :idadi_jumla,
      :hali,
      :imara,
      :vibovu,
      :uhitaji,
      :idadi_ya_uhitaji,
      :gharama
    ])
  end

  # CONTEXT FUNCTIONS ADDED BELOW

  def list_rasilimali do
    Repo.all(__MODULE__)
  end

  def get_rasilima!(id) do
    Repo.get!(__MODULE__, id)
  end

  def create_rasilima(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update_rasilima(%__MODULE__{} = rasilima, attrs) do
    rasilima
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_rasilima(%__MODULE__{} = rasilima) do
    Repo.delete(rasilima)
  end
end
