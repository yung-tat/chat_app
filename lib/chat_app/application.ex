defmodule ChatApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChatAppWeb.Telemetry,
      ChatApp.Repo,
      {Registry, keys: :unique, name: ChatApp.RoomRegistry},
      ChatApp.RoomSupervisor,
      {DNSCluster, query: Application.get_env(:chat_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChatApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChatApp.Finch},
      # Start a worker by calling: ChatApp.Worker.start_link(arg)
      # {ChatApp.Worker, arg},
      # Start to serve requests, typically the last entry
      ChatApp.AppSetup,
      ChatAppWeb.Endpoint
    ]

    # This cache stores in a table like: {room_id, invite_code}
    :ets.new(:invite_code_registry, [:public, :named_table])
    # This stores in the reverse like: {invite_code, room_id}
    :ets.new(:invite_code_reverse_registry, [:public, :named_table])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
