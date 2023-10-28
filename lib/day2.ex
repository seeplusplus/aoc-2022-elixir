defmodule Day2 do
  def init_state(part) do
    init_state(0, part)
  end

  defp init_state(score, part) do
    %{score: score, part: part}
  end

  def execute(line, state) do
    if line |> String.trim() |> String.length == 0 do
      state
    else
      {_, player, outcome} = parse_moves(line, state.part)
      
      init_state(
        state.score + 
        points_for_move(player) +
        points_from_outcome(outcome),
        state.part)
    end
  end

  def get_answer(state) do
    state.score
  end

  defp parse_moves(line, part) do
    [p1, p2] = String.split(line, " ") |> Enum.map(&String.trim/1)
    parse_moves(p1, p2, part)
  end

  defp parse_moves(left, right, :part1) do
    match = {parse_move(left, :left), parse_move(right, :right)}
    Tuple.append(match, outcome?(match))
  end

  defp parse_moves(left, right, :part2) do
    left = parse_move(left, :left)
    outcome = outcome?(right)
    right = plan_move(outcome, left)

    {left, right, outcome}
  end

  defp plan_move(outcome, opposing_move) do
    if outcome == :draw do
      opposing_move
    else
      case opposing_move do
        :rock -> case outcome do
          :win -> :paper
          :loss -> :scissors
        end
        :paper -> case outcome do
          :win -> :scissors
          :loss -> :rock
        end
        :scissors -> case outcome do
          :win -> :rock
          :loss -> :paper
        end
      end
    end
  end

  
  defp parse_move(move, side) do
    case side do
      :left -> case move do
        "A" -> :rock
        "B" -> :paper
        "C" -> :scissors
      end
      :right -> case move do
        "X" -> :rock
        "Y" -> :paper
        "Z" -> :scissors
      end
    end
  end

  defp points_for_move(move) do
    case move do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  defp sort_(a, b) do
    if a == b do
      0
    else
      case a do
        :rock -> case b do
          :paper -> -1
          :scissors -> 1
        end
        :paper -> case b do
          :rock -> 1
          :scissors -> -1
        end
        :scissors -> case b do
          :rock -> -1
          :paper -> 1
        end
      end
    end
  end

  defp outcome?(match) when is_tuple(match) and tuple_size(match) == 2 do
    {opponent, player} = match
    case sort_(player, opponent) do
      1 -> :win
      0 -> :draw
      -1 -> :loss
    end
  end

  defp outcome?(plan) do
    case plan do
      "X" -> :loss
      "Y" -> :draw
      "Z" -> :win
    end
  end

  defp points_from_outcome(outcome) do
    case outcome do
      :win -> 6
      :draw -> 3
      :loss -> 0
    end
  end
end
