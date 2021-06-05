defmodule ExHmacExample.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    with(
      children <- [],
      opts <- [strategy: :one_for_one, name: ExHmacExample.Supervisor]
    ) do
      Supervisor.start_link(children, opts)
    end
  end
end
