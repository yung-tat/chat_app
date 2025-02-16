defmodule ChatApp.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias ChatApp.Repo

  # alias ChatApp.Schemas.Room
  alias ChatApp.Schemas.User

  def get_rooms_by_user(user_id) do
    with user <- Repo.get(User, user_id),
        user <- Repo.preload(user, :user_rooms) do
          user.user_rooms
        end
  end
end
