defmodule Day2 do
  def init_state() do
    score_with_points(0)
  end

  defp score_with_points(p) do
    %{score: p}
  end

  defp parse_match(line) do
    [p1, p2] = String.split(line, " ") |> Enum.map(&String.trim/1)
    match = parse_match(p1, p2)

    match
  end

  defp parse_match(left, right) do
    {parse_move(left, :left), parse_move(right, :right)}
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

  defp points_from_player_move(match) do
    {_, player_move} = match

    case player_move do
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

  defp outcome(match) do
    {opponent, player} = match
    case sort_(player, opponent) do
      1 -> :win
      0 -> :draw
      -1 -> :loss
    end
  end

  defp points_from_outcome(match) do
    case outcome(match) do
      :win -> 6
      :draw -> 3
      :loss -> 0
    end
  end

  def execute(line, state) do
    if line |> String.trim() |> String.length == 0 do
      state
    else
      match = parse_match(line)
      
      score_with_points(
        state.score + 
        points_from_player_move(match) +
        points_from_outcome(match))

    end
  end

  def get_answer(state) do
    state.score
  end
end
