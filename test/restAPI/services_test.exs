defmodule RestAPI.ServicesTest do
  use RestAPI.DataCase

  alias RestAPI.Services

  describe "services" do
    alias RestAPI.Services.Service

    import RestAPI.ServicesFixtures

    @invalid_attrs %{amount: nil, assisted_people: nil, challenge_type: nil, date: nil, description: nil, name: nil, people_prayed_for: nil, prayed_for: nil, status: nil}

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Services.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Services.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      valid_attrs = %{amount: "120.5", assisted_people: 42, challenge_type: "some challenge_type", date: ~D[2025-07-01], description: "some description", name: "some name", people_prayed_for: "some people_prayed_for", prayed_for: 42, status: "some status"}

      assert {:ok, %Service{} = service} = Services.create_service(valid_attrs)
      assert service.amount == Decimal.new("120.5")
      assert service.assisted_people == 42
      assert service.challenge_type == "some challenge_type"
      assert service.date == ~D[2025-07-01]
      assert service.description == "some description"
      assert service.name == "some name"
      assert service.people_prayed_for == "some people_prayed_for"
      assert service.prayed_for == 42
      assert service.status == "some status"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Services.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      update_attrs = %{amount: "456.7", assisted_people: 43, challenge_type: "some updated challenge_type", date: ~D[2025-07-02], description: "some updated description", name: "some updated name", people_prayed_for: "some updated people_prayed_for", prayed_for: 43, status: "some updated status"}

      assert {:ok, %Service{} = service} = Services.update_service(service, update_attrs)
      assert service.amount == Decimal.new("456.7")
      assert service.assisted_people == 43
      assert service.challenge_type == "some updated challenge_type"
      assert service.date == ~D[2025-07-02]
      assert service.description == "some updated description"
      assert service.name == "some updated name"
      assert service.people_prayed_for == "some updated people_prayed_for"
      assert service.prayed_for == 43
      assert service.status == "some updated status"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Services.update_service(service, @invalid_attrs)
      assert service == Services.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Services.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Services.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Services.change_service(service)
    end
  end
end
