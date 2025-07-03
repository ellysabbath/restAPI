defmodule RestAPIWeb.AssetsLive do
  use RestAPIWeb, :live_view
  alias RestAPI.Rasilimali

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: send(self(), :load_assets)

    {:ok,
     assign(socket,
       page_title: "Assets Dashboard",
       assets: [],
       loading: true
     )}
  end

  @impl true
  def handle_info(:load_assets, socket) do
    assets = Rasilimali.list_rasilimali()
    {:noreply, assign(socket, assets: assets, loading: false)}
  end

  @impl true
  def handle_event("edit", %{"id" => id}, socket) do
    asset = Rasilimali.get_rasilima!(id)
    {:noreply, push_event(socket, "edit_asset", %{id: id, asset: asset_to_map(asset)})}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    asset = Rasilimali.get_rasilima!(id)
    {:ok, _} = Rasilimali.delete_rasilima(asset)
    assets = Rasilimali.list_rasilimali()
    {:noreply, assign(socket, assets: assets)}
  end

  defp asset_to_map(asset) do
    %{
      id: asset.id,
      jina_la_vifaa: asset.jina_la_vifaa,
      idadi_jumla: asset.idadi_jumla,
      hali: asset.hali,
      imara: asset.imara,
      vibovu: asset.vibovu,
      uhitaji: asset.uhitaji,
      idadi_ya_uhitaji: asset.idadi_ya_uhitaji,
      gharama: asset.gharama
    }
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen w-full bg-gradient-to-b from-green-100 to-white p-6">
      <h1 class="text-4xl font-bold text-green-800 mb-6 text-center"><%= @page_title %></h1>

      <div class="bg-white rounded-xl shadow-xl max-w-6xl mx-auto p-4">
        <table class="w-full text-sm text-gray-700 border border-gray-300">
          <thead class="bg-gray-100 text-left">
            <tr>
              <th class="p-2 border">#</th>
              <th class="p-2 border">Jina la Vifaa</th>
              <th class="p-2 border">Idadi Jumla</th>
              <th class="p-2 border">Hali</th>
              <th class="p-2 border">Imara</th>
              <th class="p-2 border">Vibovu</th>
              <th class="p-2 border">Uhitaji</th>
              <th class="p-2 border">Idadi ya Uhitaji</th>
              <th class="p-2 border">Gharama</th>
              <th class="p-2 border">Hatua</th>
            </tr>
          </thead>
          <tbody>
            <%= if @loading do %>
              <tr><td colspan="10" class="text-center p-4">Loading...</td></tr>
            <% else %>
              <%= for asset <- @assets do %>
                <tr id={"asset-#{asset.id}"}>
                  <td class="p-2 border"><%= asset.id %></td>
                  <td class="p-2 border"><%= asset.jina_la_vifaa %></td>
                  <td class="p-2 border"><%= asset.idadi_jumla %></td>
                  <td class="p-2 border"><%= asset.hali %></td>
                  <td class="p-2 border"><%= asset.imara %></td>
                  <td class="p-2 border"><%= asset.vibovu %></td>
                  <td class="p-2 border"><%= asset.uhitaji %></td>
                  <td class="p-2 border"><%= asset.idadi_ya_uhitaji %></td>
                  <td class="p-2 border"><%= asset.gharama %></td>
                  <td class="p-2 border text-right">
                    <button phx-click="edit" phx-value-id={asset.id} class="text-blue-600 hover:underline">✏️</button>
                    <button phx-click="delete" phx-value-id={asset.id} class="text-red-600 hover:underline">🗑️</button>
                  </td>
                </tr>
              <% end %>
            <% end %>
          </tbody>
        </table>

        <div class="mt-4 text-right">
          <button id="add-asset-btn" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">Add Asset +</button>
        </div>
      </div>

      <!-- SweetAlert2 JS -->
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
      <script>
        function getCookie(name) {
          let v = document.cookie.split('; ').find(row => row.startsWith(name + '='));
          return v ? decodeURIComponent(v.split('=')[1]) : null;
        }

        const csrftoken = getCookie('_csrf_token');

        document.getElementById('add-asset-btn').addEventListener('click', async () => {
          const { value: formData, isConfirmed } = await Swal.fire({
            title: 'Add Asset',
            html: `
              <input id="jina_la_vifaa" class="swal2-input" placeholder="Jina la Vifaa">
              <input id="idadi_jumla" type="number" class="swal2-input" placeholder="Idadi Jumla">
              <select id="hali" class="swal2-input">
                <option value="">Chagua hali</option>
                <option value="vizima">Vizima</option>
                <option value="wastani">Wastani</option>
                <option value="vibovu">Vibovu</option>
                <option value="vinahitaji marekebisho">Vinahitaji Marekebisho</option>
              </select>
              <input id="imara" type="number" class="swal2-input" placeholder="Imara">
              <input id="vibovu" type="number" class="swal2-input" placeholder="Vibovu">
              <select id="uhitaji" class="swal2-input">
                <option value="">Chagua uhitaji</option>
                <option value="vinahitajika">Vinahitajika</option>
                <option value="havihitajiki">Havihitajiki</option>
                <option value="viboreshwe tu">Viboreshwe tu</option>
              </select>
              <input id="idadi_ya_uhitaji" type="number" class="swal2-input" placeholder="Idadi ya Uhitaji">
              <input id="gharama" type="number" step="0.01" class="swal2-input" placeholder="Gharama">
            `,
            showCancelButton: true,
            preConfirm: () => ({
              rasilima: {
                jina_la_vifaa: document.getElementById('jina_la_vifaa').value,
                idadi_jumla: +document.getElementById('idadi_jumla').value,
                hali: document.getElementById('hali').value,
                imara: +document.getElementById('imara').value,
                vibovu: +document.getElementById('vibovu').value,
                uhitaji: document.getElementById('uhitaji').value,
                idadi_ya_uhitaji: +document.getElementById('idadi_ya_uhitaji').value,
                gharama: +document.getElementById('gharama').value
              }
            })
          });

          if (!isConfirmed) return;

          const res = await fetch("/api/rasilimali", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-CSRFToken": csrftoken
            },
            body: JSON.stringify(formData)
          });

          if (res.ok) {
            Swal.fire("Imeongezwa!", "", "success");
            window.location.reload();
          } else {
            const err = await res.json();
            Swal.fire("Imeshindikana", err.message || "Error", "error");
          }
        });

        window.addEventListener("phx:edit_asset", async (e) => {
          const asset = e.detail.asset;
          const id = e.detail.id;

          const { value: formData, isConfirmed } = await Swal.fire({
            title: "Edit Asset",
            html: `
              <input id="jina_la_vifaa" class="swal2-input" value="${asset.jina_la_vifaa}">
              <input id="idadi_jumla" type="number" class="swal2-input" value="${asset.idadi_jumla}">
              <select id="hali" class="swal2-input">
                <option value="vizima" ${asset.hali === "vizima" ? "selected" : ""}>Vizima</option>
                <option value="wastani" ${asset.hali === "wastani" ? "selected" : ""}>Wastani</option>
                <option value="vibovu" ${asset.hali === "vibovu" ? "selected" : ""}>Vibovu</option>
                <option value="vinahitaji marekebisho" ${asset.hali === "vinahitaji marekebisho" ? "selected" : ""}>Vinahitaji Marekebisho</option>
              </select>
              <input id="imara" type="number" class="swal2-input" value="${asset.imara}">
              <input id="vibovu" type="number" class="swal2-input" value="${asset.vibovu}">
              <select id="uhitaji" class="swal2-input">
                <option value="vinahitajika" ${asset.uhitaji === "vinahitajika" ? "selected" : ""}>Vinahitajika</option>
                <option value="havihitajiki" ${asset.uhitaji === "havihitajiki" ? "selected" : ""}>Havihitajiki</option>
                <option value="viboreshwe tu" ${asset.uhitaji === "viboreshwe tu" ? "selected" : ""}>Viboreshwe tu</option>
              </select>
              <input id="idadi_ya_uhitaji" type="number" class="swal2-input" value="${asset.idadi_ya_uhitaji}">
              <input id="gharama" type="number" step="0.01" class="swal2-input" value="${asset.gharama}">
            `,
            showCancelButton: true,
            preConfirm: () => ({
              rasilima: {
                jina_la_vifaa: document.getElementById("jina_la_vifaa").value,
                idadi_jumla: +document.getElementById("idadi_jumla").value,
                hali: document.getElementById("hali").value,
                imara: +document.getElementById("imara").value,
                vibovu: +document.getElementById("vibovu").value,
                uhitaji: document.getElementById("uhitaji").value,
                idadi_ya_uhitaji: +document.getElementById("idadi_ya_uhitaji").value,
                gharama: +document.getElementById("gharama").value
              }
            })
          });

          if (!isConfirmed) return;

          const res = await fetch(`/api/rasilimali/${id}`, {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
              "X-CSRFToken": csrftoken
            },
            body: JSON.stringify(formData)
          });

          if (res.ok) {
            Swal.fire("Imehaririwa!", "", "success");
            window.location.reload();
          } else {
            const err = await res.json();
            Swal.fire("Imeshindikana", err.message || "Error", "error");
          }
        });
      </script>
    </div>
    """
  end
end
