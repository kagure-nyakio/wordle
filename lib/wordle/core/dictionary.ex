defmodule Wordle.Core.Dictionary do
  @moduledoc """
  Returns a random five letter word
  """

  @word_list "./priv/words.txt"
              |> Path.expand()
              |> File.read!()

  def word_list() do
    @word_list
    |> String.split("\n")
    |> MapSet.new()
  end

  def random_word() do
    word_list()
    |> Enum.random()
  end

  def is_word?(word) do
    MapSet.member?(word_list(), word)
  end
end
