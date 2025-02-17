defmodule ChatAppWeb.Router do
  use ChatAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChatAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug
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
  end
end
