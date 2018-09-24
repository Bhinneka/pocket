defmodule Pocket do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # list options
    options = [
      ip: Application.get_env(:extcp, :ip, {127,0,0,1}),
      port: Application.get_env(:extcp, :port, 9000)
    ]
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Pocket.Worker.start_link(arg)
      {Pocket.Server, options},
    ]

    opts = [strategy: :one_for_one, name: Pocket.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
