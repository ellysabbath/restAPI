defmodule RestAPI.ServicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RestAPI.Services` context.
  """

  @doc """
  Generate a service.
  """
  def service_fixture(attrs \\ %{}) do
    {:ok, service} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        assisted_people: 42,
        challenge_type: "some challenge_type",
        date: ~D[2025-07-01],
        description: "some description",
        name: "some name",
        people_prayed_for: "some people_prayed_for",
        prayed_for: 42,
        status: "some status"
      })
      |> RestAPI.Services.create_service()

    service
  end
end
