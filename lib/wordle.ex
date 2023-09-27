defmodule Wordle do
  @moduledoc """
  Guess a 5 letter word.
  """

  alias Wordle.GameFactory
  alias Wordle.Boundary.Server

  @doc """
  Start a new game
  """
  defdelegate new_game(name), to: GameFactory

  @doc """
  Guess a five letter word
  """
  defdelegate guess_word(game, guess), to: Server

  @doc """
  Returns game tally
  """
  defdelegate tally(game), to: Server
end
