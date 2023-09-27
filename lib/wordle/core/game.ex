defmodule Wordle.Core.Game do
  alias Wordle.Core.Dictionary

  defstruct(
    answer: [],
    game_state: :initializing,
    guesses: [],
    turns_left: 6
  )

  def new(), do: new(Dictionary.random_word())

  def new(random_word) when is_binary(random_word) do
    struct(
      %__MODULE__{},
      [answer: String.graphemes(random_word)]
    )
  end

  def guess_word(%__MODULE__{game_state: state}=game, _guess)
    when state in [:won, :lost] do
    return_game_and_tally(game)
  end

  def guess_word(game, guess) do
    game
    |> check_guess(guess)
    |> return_game_and_tally()
  end

  defp check_guess(%__MODULE__{turns_left: 1}=game, _guess) do
    %{ game | game_state: :lost, turns_left: 0 }
  end

  defp check_guess(%__MODULE__{answer: answer, turns_left: turns, guesses: guesses}=game, guess) do
    str_answer = Enum.join(answer)
    new_state = maybe_won?(guess == str_answer)

    %{
      game |
      game_state: new_state,
      guesses: [assign_colors_to_guess(guess, answer) | guesses],
      turns_left: turns - 1
    }
  end

  defp maybe_won?(true), do: :won
  defp maybe_won?(_false), do: :continue

  defp assign_colors_to_guess(guess, answer) do
    guess_with_index =
      guess
      |> String.graphemes()
      |> Enum.with_index()

    for {guess, index} <- guess_with_index do
      guess
      |> is_letter_in_word?(answer)
      |> assign_color(answer, guess, index)
    end
  end

  defp assign_color(true, answer, guess, index) do
    answer
    |> is_at_correct_position?(guess, index)
    |> assign_green_or_yellow(guess)
  end

  defp assign_color(_false, _answer, guess, _index), do: { guess, :gray }

  defp is_letter_in_word?(guess, answer), do: guess in answer

  defp is_at_correct_position?(answer, guess, index), do:  Enum.at(answer, index) == guess

  defp assign_green_or_yellow(true, guess), do: { guess, :green }
  defp assign_green_or_yellow(false, guess), do: { guess, :yellow }

  def tally(game) do
    %{
      answer: Enum.join(game.answer),
      game_state: game.game_state,
      guesses: Enum.reverse(game.guesses),
      turns_left: game.turns_left
    }
  end

  defp return_game_and_tally(game) do
    { game, tally(game) }
  end
end
