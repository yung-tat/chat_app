defmodule ChatAppWeb.RoomChannel do
  alias ChatApp.UserRooms
  use ChatAppWeb, :channel

  @impl true
  def join(topic, _payload, socket) do
    "room:" <> room_id = topic

    with user_id = socket.assigns.user,
         true <- UserRooms.is_user_authorized?(user_id, room_id) do
      {:ok, socket}
    else
      _ ->
        {:error, "User is not authorized to join this room"}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
