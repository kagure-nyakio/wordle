defmodule Wordle.Boundary.Server do
  use GenServer

  alias Wordle.Core.Game
  alias Wordle.Core.Dictionary

  @registry Wordle.Game.Registry

  def start_link(game) do
    GenServer.start_link(__MODULE__, game, name: via_tuple(game))
  end

  def guess_word(game, guess) do
    game = via_tuple(game)

    if Dictionary.is_word?(guess) do
      GenServer.call(game, {:guess_word, guess})
    else
      GenServer.call(game, :not_a_word)
    end
  end

  def tally(game), do: GenServer.call(game, :tally)

  def child_spec(game) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [game]}
    }
  end

  defp via_tuple(game) do
    {:via, Registry, {@registry, game}}
  end

  @impl true
  def init(game) do
    IO.puts("Starting new game #{game}")
    {:ok, Game.new()}
  end

  @impl true
  def handle_call({:guess_word, guess}, _from, game) do
    {game, tally} = Game.guess_word(game, guess)

    {:reply, {:ok, tally}, game}
  end

  @impl true
  def handle_call(:not_a_word, _from, game) do
    {:reply, {:error, :not_a_word}, game}
  end

  @impl true
  def handle_call(:tally, _from, game) do
    {:reply, Game.tally(game), game}
  end
end
