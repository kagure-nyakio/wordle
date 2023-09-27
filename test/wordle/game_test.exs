defmodule GameTest do
  use ExUnit.Case

  alias Wordle.Core.Game

  describe "new/0" do
    test "returns a game struct" do
      game =  game()

      assert game.turns_left == 6
      assert game.game_state == :initializing
      assert game.answer == String.graphemes("field")
      assert game.guesses == []
    end
  end

  describe "guess_word/2" do
    test "recognises a won or lost game" do
      for state <- [:won, :lost] do
        game = game() |> Map.put(:game_state, state)

        { new_game, _tally } = Game.guess_word(game, "tests")

        assert new_game == game
      end
    end

    test "player can play a game in a sequence of moves" do
      [
        ["tests", :continue, 5, [ [{"t", :gray}, {"e", :yellow}, {"s", :gray}, {"t", :gray}, {"s", :gray}]]],
        ["debug", :continue, 4, [[{"t", :gray}, {"e", :yellow}, {"s", :gray}, {"t", :gray}, {"s", :gray}], [{"d", :yellow}, {"e", :yellow}, {"b", :gray}, {"u", :gray},  {"g", :gray} ]]],
      ] |> test_sequence_of_moves()
    end

  end

  def game, do: Game.new("field")

  defp test_sequence_of_moves(moves) do
    game = game()
    Enum.reduce(moves, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, guesses], game) do
    {game, tally} = Game.guess_word(game, guess)

    assert tally.game_state == state
    assert tally.guesses == guesses
    assert tally.turns_left == turns

    game
  end
end
