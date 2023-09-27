defmodule Wordle.GameFactory do
  use DynamicSupervisor

  alias Wordle.Boundary.Server

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def new_game(game_name) do
    child_spec = {Server, game_name}

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
