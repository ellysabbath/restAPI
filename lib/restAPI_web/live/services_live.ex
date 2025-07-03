defmodule RestAPIWeb.ServicesLive do
  use RestAPIWeb, :live_view
  alias RestAPI.Services
  alias RestAPI.Services.Service

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: send(self(), :load_services)

    {:ok,
     assign(socket,
       page_title: "Services Dashboard",
       services: [],
       loading: true,
       editing: nil
     )}
  end

  @impl true
  def handle_info(:load_services, socket) do
    services = Services.list_services()
    {:noreply, assign(socket, services: services, loading: false)}
  end

  @impl true
  def handle_event("edit", %{"id" => id}, socket) do
    service = Services.get_service!(id)
    {:noreply, push_event(socket, "edit_service", %{id: id, service: service_to_map(service)})}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    service = Services.get_service!(id)
    {:ok, _} = Services.delete_service(service)
    services = Services.list_services()
    {:noreply, assign(socket, services: services)}
  end

  defp service_to_map(service) do
    %{
      id: service.id,
      name: service.name,
      description: service.description,
      assisted_people: service.assisted_people,
      amount: service.amount,
      prayed_for: service.prayed_for,
      challenge_type: service.challenge_type,
      people_prayed_for: service.people_prayed_for,
      date: service.date,
      status: service.status
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen w-full bg-gradient-to-b from-green-100 to-white flex flex-col items-center justify-start p-6">
      <h1 class="text-4xl font-bold text-green-800 mb-8 flex items-center gap-2">
        🛎️ <%= @page_title %>
      </h1>

      <div class="bg-white shadow-xl rounded-xl w-full max-w-6xl p-6">
        <div class="overflow-x-auto rounded-md">
          <table class="w-full text-sm text-left text-gray-700 border border-gray-200 rounded-lg overflow-hidden">
            <thead class="bg-gray-100 text-gray-800">
              <tr>
                <th class="px-4 py-3 border">Jina kamili</th>
                <th class="px-4 py-3 border">Maelezo</th>
                <th class="px-4 py-3 border">Waliosaidiwa</th>
                <th class="px-4 py-3 border">Kiasi</th>
                <th class="px-4 py-3 border">Ulio waombea</th>
                <th class="px-4 py-3 border">Aina ya changamoto</th>
                <th class="px-4 py-3 border">Watu walioombewa</th>
                <th class="px-4 py-3 border">Tarehe</th>
                <th class="px-4 py-3 border">Hali</th>
                <th class="px-4 py-3 border">Hatua</th>
              </tr>
            </thead>
            <tbody id="services-entries-body" class="bg-white text-gray-900">
              <%= if @loading do %>
                <tr><td colspan="10" class="text-center py-4">Loading...</td></tr>
              <% else %>
                <%= if Enum.empty?(@services) do %>
                  <tr><td colspan="10" class="text-center text-gray-500 py-4">Hakuna huduma zilizopatikana.</td></tr>
                <% else %>
                  <%= for service <- @services do %>
                    <tr id={"service-#{service.id}"}>
                      <td class="px-4 py-2 border"><%= service.name %></td>
                      <td class="px-4 py-2 border"><%= service.description %></td>
                      <td class="px-4 py-2 border"><%= service.assisted_people %></td>
                      <td class="px-4 py-2 border"><%= service.amount %></td>
                      <td class="px-4 py-2 border"><%= service.prayed_for %></td>
                      <td class="px-4 py-2 border"><%= service.challenge_type %></td>
                      <td class="px-4 py-2 border"><%= service.people_prayed_for %></td>
                      <td class="px-4 py-2 border"><%= service.date %></td>
                      <td class="px-4 py-2 border"><%= service.status %></td>
                      <td class="px-4 py-2 border text-right space-x-2">
                        <button
                          phx-click="edit"
                          phx-value-id={service.id}
                          class="text-blue-600 hover:underline"
                        >
                          ✏️
                        </button>
                        <button
                          phx-click="delete"
                          phx-value-id={service.id}
                          class="text-red-600 hover:underline"
                        >
                          🗑️
                        </button>
                      </td>
                    </tr>
                  <% end %>
                <% end %>
              <% end %>
            </tbody>
          </table>
        </div>

        <div class="mt-6 text-right">
          <button id="add-service-btn"
                  class="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold text-white bg-green-600 hover:bg-green-700 rounded-md transition">
            Add Service +
          </button>
        </div>
      </div>

      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
      <script>
        function getCookie(name) {
          let v = document.cookie.split('; ').find(row => row.startsWith(name+'='));
          return v ? decodeURIComponent(v.split('=')[1]) : null;
        }

        const csrftoken = getCookie('_csrf_token');

        // Add Service Function
        async function addService() {
          const { value: fv, isConfirmed } = await Swal.fire({
            title: 'Add Service',
            html: `
              <input id="name" class="swal2-input" placeholder="Full Name">
              <input id="description" class="swal2-input" placeholder="huduma ulio toa">
              <input id="assisted_people" type="number" class="swal2-input" placeholder="People Assisted">
              <input id="amount" type="number" class="swal2-input" placeholder="Amount">
              <input id="prayed_for" type="number" class="swal2-input" placeholder="Prayed For">
              <input id="challenge_type" class="swal2-input" placeholder="Challenge Type">
              <input id="people_prayed_for" class="swal2-input" placeholder="People Prayed For">
              <input id="date" type="date" class="swal2-input">
              <select id="status" class="swal2-input">
                <option value="Active">Active</option>
                <option value="Inactive">Inactive</option>
              </select>
            `,
            showCancelButton: true,
            preConfirm: () => ({
              service: {
                name: document.getElementById('name').value,
                description: document.getElementById('description').value,
                assisted_people: +document.getElementById('assisted_people').value,
                amount: +document.getElementById('amount').value,
                prayed_for: +document.getElementById('prayed_for').value,
                challenge_type: document.getElementById('challenge_type').value,
                people_prayed_for: document.getElementById('people_prayed_for').value,
                date: document.getElementById('date').value,
                status: document.getElementById('status').value
              }
            })
          });

          if (!isConfirmed) return;

          const res = await fetch('/api/services', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrftoken },
            body: JSON.stringify(fv)
          });

          if (res.ok) {
            Swal.fire({ icon: 'success', title: 'Service created!', timer: 1200 });
            window.location.reload();
          } else {
            const err = await res.json();
            Swal.fire({ icon: 'error', title: 'Failed to create', text: err.message || 'Unknown error' });
          }
        }

        // Edit Service Function
        async function editService(id, serviceData) {
          const { value: fv, isConfirmed } = await Swal.fire({
            title: 'Edit Service',
            html: `
              <input id="name" class="swal2-input" placeholder="Full Name" value="${serviceData.name}">
              <input id="description" class="swal2-input" placeholder="huduma ulio toa" value="${serviceData.description}">
              <input id="assisted_people" type="number" class="swal2-input" placeholder="People Assisted" value="${serviceData.assisted_people}">
              <input id="amount" type="number" class="swal2-input" placeholder="Amount" value="${serviceData.amount}">
              <input id="prayed_for" type="number" class="swal2-input" placeholder="Prayed For" value="${serviceData.prayed_for}">
              <input id="challenge_type" class="swal2-input" placeholder="Challenge Type" value="${serviceData.challenge_type}">
              <input id="people_prayed_for" class="swal2-input" placeholder="People Prayed For" value="${serviceData.people_prayed_for}">
              <input id="date" type="date" class="swal2-input" value="${serviceData.date}">
              <select id="status" class="swal2-input">
                <option value="Active" ${serviceData.status === 'Active' ? 'selected' : ''}>Active</option>
                <option value="Inactive" ${serviceData.status === 'Inactive' ? 'selected' : ''}>Inactive</option>
              </select>
            `,
            showCancelButton: true,
            preConfirm: () => ({
              service: {
                name: document.getElementById('name').value,
                description: document.getElementById('description').value,
                assisted_people: +document.getElementById('assisted_people').value,
                amount: +document.getElementById('amount').value,
                prayed_for: +document.getElementById('prayed_for').value,
                challenge_type: document.getElementById('challenge_type').value,
                people_prayed_for: document.getElementById('people_prayed_for').value,
                date: document.getElementById('date').value,
                status: document.getElementById('status').value
              }
            })
          });

          if (!isConfirmed) return;

          const res = await fetch(`/api/services/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrftoken },
            body: JSON.stringify(fv)
          });

          if (res.ok) {
            Swal.fire({ icon: 'success', title: 'Service updated!', timer: 1200 });
            window.location.reload();
          } else {
            const err = await res.json();
            Swal.fire({ icon: 'error', title: 'Failed to update', text: err.message || 'Unknown error' });
          }
        }

        // Initialize event listeners
        document.addEventListener('DOMContentLoaded', () => {
          document.getElementById('add-service-btn').addEventListener('click', addService);

          window.addEventListener('phx:edit_service', (e) => {
            editService(e.detail.id, e.detail.service);
          });
        });
      </script>
    </div>
    """
  end
end
