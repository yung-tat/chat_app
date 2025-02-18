defmodule ChatAppWeb.Router do
  use ChatAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ChatAppWeb do
    pipe_through :api

    post "/user/create", UserController, :create
    post "/user/login", UserController, :login
    get "/user/rooms", UserController, :get_user_rooms
    post "/user/join/:invite_code", UserController, :join_room

    post "/room/create", RoomController, :create
    post "/room/create_invite_code", RoomController, :create_invite_code
    get "/room/get_by_invite_code/:invite_code", RoomController, :get_room_by_invite_code
  end
end
