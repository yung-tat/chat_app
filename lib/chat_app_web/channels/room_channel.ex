defmodule ChatAppWeb.RoomChannel do
  alias ChatApp.Repo
  alias ChatApp.RoomServer
  alias ChatApp.Messages
  alias ChatApp.UserRooms
  use ChatAppWeb, :channel

  @impl true
  def join("room:" <> room_id, _payload, socket) do
    with user_id <- socket.assigns.user_id,
         true <- UserRooms.is_user_authorized?(user_id, room_id) do
      send(self(), {:after_join, user_id, room_id})
      {:ok, socket}
    else
      _ ->
        {:error, "User is not part of this room"}
    end
  end

  @impl true
  def handle_info({:after_join, user_id, room_id}, socket) do
    # Add joined user to online user list
    room_info = RoomServer.join_user(room_id, user_id)

    # Send updated room info to everyone
    broadcast(socket, "room_info", render_room_info(room_info))

    # Send previous messages to joined user
    messages = Messages.get_messages_by_room(room_id)
    push(socket, "initial_messages", render_messages(messages))
    {:noreply, socket}
  end

  @impl true
  def handle_in("send_message", %{"message" => message}, socket) do
    with "room:" <> room_id <- socket.topic,
         user_id <- socket.assigns.user_id,
         {:ok, message} =
           Messages.create_message(%{message: message, room_id: room_id, user_id: user_id}) do
      broadcast(socket, "new_message", render_message(message))
    end

    {:noreply, socket}
  end

  # @impl true
  # def terminate(_reason, socket) do
  #   room_info = RoomServer.leave_user(socket.assigns.user)
  #   broadcast(socket, "room_info", room_info)
  # end

  defp render_room_info(room_info) do
    %{
      invite_code: room_info.invite_code,
      online_users:
        Enum.map(
          room_info.online_users,
          fn user -> %{id: user.id, name: user.name} end
        )
    }
  end

  defp render_messages(messages) do
    %{
      messages: Enum.map(messages, &render_message(&1))
    }
  end

  defp render_message(message) do
    message = Repo.preload(message, :user)
       %{
        user: %{
          id: message.user.id,
          name: message.user.name
        },
        message: message.message
       }
  end
end
