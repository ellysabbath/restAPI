defmodule RestAPIWeb.DeaconsLive do
  use RestAPIWeb, :live_view
  alias RestAPI.Accounts

  def mount(_params, _session, socket) do
    if connected?(socket), do: send(self(), :load_deacons)

    {:ok,
     socket
     |> assign(page_title: "Deacons Dashboard")
     |> assign(deacons: [], loading: true)}
  end

  def handle_info(:load_deacons, socket) do
    deacons = Accounts.list_deacons()
    {:noreply, assign(socket, deacons: deacons, loading: false)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen w-full bg-gradient-to-b from-green-100 to-white flex flex-col items-center justify-start p-6">
      <h1 class="text-4xl font-bold text-blue-800 mb-8 flex items-center gap-2">
        👤 <%= @page_title %>
      </h1>

      <div class="bg-white shadow-xl rounded-xl w-full max-w-6xl p-6">
        <div class="overflow-x-auto rounded-md">
          <table class="w-full text-sm text-left text-gray-700">
            <thead class="bg-gray-100 text-gray-800">
              <tr>
                <th class="px-6 py-3">Full Name</th>
                <th class="px-6 py-3">Age</th>
                <th class="px-6 py-3">Contact</th>
                <th class="px-6 py-3">Email</th>
                <th class="px-6 py-3">Role</th>
                <th class="px-6 py-3">Member Since</th>
                <th class="px-6 py-3">Actions</th>
              </tr>
            </thead>
            <tbody id="deacon-table-body" class="divide-y divide-gray-200">
              <%= if @loading do %>
                <tr><td colspan="7" class="text-center py-4">Loading...</td></tr>
              <% else %>
                <%= if Enum.empty?(@deacons) do %>
                  <tr><td colspan="7" class="text-center py-4 text-gray-500">No deacons found.</td></tr>
                <% else %>
                  <%= for deacon <- @deacons do %>
                    <tr id={"deacon-#{deacon.id}"} class="hover:bg-gray-50">
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="text-green-900 font-medium"><%= deacon.full_name %></span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-blue-900"><%= deacon.age %></td>
                      <td class="px-6 py-4 whitespace-nowrap text-purple-900"><%= deacon.contact %></td>
                      <td class="px-6 py-4 whitespace-nowrap text-gray-900"><%= deacon.email %></td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class={if deacon.role == "deacon", do: "bg-green-100 text-green-800", else: "bg-blue-100 text-blue-800"} <> 
                          <%= String.capitalize(deacon.role) %>
                        </span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-gray-500 text-sm">
                        <%= Timex.format!(deacon.inserted_at, "{Mshort} {D}, {YYYY}") %>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-right space-x-2">
                        <button onclick={"editDeacon(#{deacon.id})"} class="text-indigo-600 hover:text-indigo-900">Edit</button>
                        <button onclick={"deleteDeacon(#{deacon.id})"} class="text-red-600 hover:text-red-900">Delete</button>
                      </td>
                    </tr>
                  <% end %>
                <% end %>
              <% end %>
            </tbody>
          </table>
        </div>
        <div class="mt-6 text-right">
          <button id="add-deacon-btn"
                  class="inline-flex items-center px-4 py-2 text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700">
            Add Deacon +
          </button>
        </div>
      </div>

      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
      <script>
        /* Utility to fetch CSRF token from cookies */
        function getCookie(name) {
          let v = document.cookie.split('; ').find(row => row.startsWith(name+'='));
          return v ? decodeURIComponent(v.split('=')[1]) : null;
        }
        const csrftoken = getCookie('_csrf_token');

        function formatDate(str) {
          const d = new Date(str);
          return isNaN(d) ? "" : d.toLocaleDateString(undefined, { year: 'numeric', month:'short', day:'numeric' });
        }

        async function fetchDeacons() {
          const url = window.location.origin + '/api/deacons/';
          const res = await fetch(url, { headers: { 'X-CSRFToken': csrftoken } });
          if (!res.ok) return console.error("Fetch failed:", res.status);
          const data = await res.json();
          const list = data.data || data || [];

          const tbody = document.getElementById('deacon-table-body');
          tbody.innerHTML = '';
          if (list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center text-gray-500 py-4">No deacons found.</td></tr>';
            return;
          }

          list.forEach(d => {
            const tr = document.createElement('tr');
            tr.id = `deacon-${d.id}`;
            tr.className = 'hover:bg-gray-50';
            tr.innerHTML = `
              <td class="px-6 py-4 text-green-900 font-medium">${d.full_name || ''}</td>
              <td class="px-6 py-4 text-blue-900">${d.age || ''}</td>
              <td class="px-6 py-4 text-purple-900">${d.contact || ''}</td>
              <td class="px-6 py-4 text-gray-900">${d.email || ''}</td>
              <td class="px-6 py-4">
                <span class="${d.role == 'deacon' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'} px-2 py-1 rounded-full text-xs">
                  ${d.role ? d.role.charAt(0).toUpperCase()+d.role.slice(1) : ''}
                </span>
              </td>
              <td class="px-6 py-4 text-gray-500 text-sm">${formatDate(d.inserted_at || d.created_at)}</td>
              <td class="px-6 py-4 text-right space-x-2">
                <button onclick="editDeacon(${d.id})" class="text-indigo-600">Edit</button>
                <button onclick="deleteDeacon(${d.id})" class="text-red-600">Delete</button>
              </td>`;
            tbody.appendChild(tr);
          });
        }

        async function addDeacon() {
          const { value: fv, isConfirmed } = await Swal.fire({
            title: 'Add Deacon', html:
              `<input id="fn" class="swal2-input" placeholder="Full Name">
               <input id="em" class="swal2-input" placeholder="Email">
               <input id="ag" type="number" class="swal2-input" placeholder="Age">
               <input id="ct" class="swal2-input" placeholder="Contact">
               <select id="rl" class="swal2-input">
                 <option value="deacon">Deacon</option>
                 <option value="normal user">Normal User</option>
               </select>`,
            showCancelButton: true, preConfirm: () => ({
              deacon: {
                full_name: document.getElementById('fn').value,
                email: document.getElementById('em').value,
                age: +document.getElementById('ag').value,
                contact: document.getElementById('ct').value,
                role: document.getElementById('rl').value
              }
            })
          });
          if (!isConfirmed) return;

          const res = await fetch('/api/deacons/', {
            method: 'POST',
            headers: { 'Content-Type':'application/json', 'X-CSRFToken': csrftoken },
            body: JSON.stringify(fv)
          });
          if (res.ok) {
            Swal.fire({ icon:'success', title:'Deacon created!', timer:1200, showConfirmButton:false });
            fetchDeacons();
          } else Swal.fire({ icon:'error', title:'Error', text:'Failed to create.' });
        }

        window.editDeacon = async id => {
          const r = await fetch(`/api/deacons/${id}`);
          if (!r.ok) return Swal.fire({icon:'error', title:'Error fetching'});
          const d = (await r.json()).data || await r.json();
          const { value: fv, isConfirmed } = await Swal.fire({
            title: 'Edit Deacon', html:
              `<input id="fn" class="swal2-input" placeholder="Full Name" value="${d.full_name}">
               <input id="em" class="swal2-input" placeholder="Email" value="${d.email}">
               <input id="ag" type="number" class="swal2-input" placeholder="Age" value="${d.age}">
               <input id="ct" class="swal2-input" placeholder="Contact" value="${d.contact}">
               <select id="rl" class="swal2-input">
                 <option value="deacon"${d.role=='deacon'?' selected':''}>Deacon</option>
                 <option value="normal user"${d.role=='normal user'?' selected':''}>Normal User</option>
               </select>`,
            showCancelButton: true, preConfirm: () => ({
              deacon: {
                full_name: document.getElementById('fn').value,
                email: document.getElementById('em').value,
                age: +document.getElementById('ag').value,
                contact: document.getElementById('ct').value,
                role: document.getElementById('rl').value
              }
            })
          });
          if (!isConfirmed) return;

          const u = await fetch(`/api/deacons/${id}`, {
            method: 'PUT',
            headers: { 'Content-Type':'application/json', 'X-CSRFToken': csrftoken },
            body: JSON.stringify(fv)
          });
          if (u.ok) {
            Swal.fire({ icon:'success', title:'Updated!', timer:1200, showConfirmButton:false });
            fetchDeacons();
          } else Swal.fire({ icon:'error', title:'Update failed' });
        };

        window.deleteDeacon = async id => {
          const { isConfirmed } = await Swal.fire({title:'Confirm delete?', icon:'warning', showCancelButton:true});
          if (!isConfirmed) return;
          const r = await fetch(`/api/deacons/${id}`, {
            method: 'DELETE',
            headers: { 'X-CSRFToken': csrftoken }
          });
          if (r.ok) {
            Swal.fire({ icon:'success', title:'Deleted', timer:1200, showConfirmButton:false });
            fetchDeacons();
          } else Swal.fire({ icon:'error', title:'Delete failed' });
        };

        document.addEventListener('DOMContentLoaded', () => {
          fetchDeacons();
          document.getElementById('add-deacon-btn').addEventListener('click', addDeacon);
        });
      </script>
    </div>
    """
  end
end
