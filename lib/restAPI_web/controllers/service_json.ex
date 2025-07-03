defmodule RestAPIWeb.ServiceJSON do
  alias RestAPI.Services.Service

  @doc """
  Renders a list of services.
  """
  def index(%{services: services}) do
    %{data: for(service <- services, do: data(service))}
  end

  @doc """
  Renders a single service.
  """
  def show(%{service: service}) do
    %{data: data(service)}
  end

  defp data(%Service{} = service) do
    %{
      id: service.id,
    id: service.id,
    jina_kamili_la_mshiriki: service.name,
    kufanyika_maombi: service.description,
    idadi_ya_watu_walio_saidiwa: service.assisted_people,
    kiasi: service.amount,
    idadi_ya_watu_ulio_waombea: service.prayed_for,
    aina_ya_changamoto: service.challenge_type,
    watu_walio_ombewa: service.people_prayed_for,
    tarehe: service.date,
    hali: service.status,
    imeongezwa: service.inserted_at,
    imebadilishwa: service.updated_at
    }
  end
end
