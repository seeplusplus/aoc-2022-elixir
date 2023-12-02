defmodule AOCRunner do
  @spec is_empty?(s :: String.t()) :: boolean()
  defp is_empty?(s) do
    String.trim(s) |> String.length() == 0
  end

  @spec both_empty?(a :: String.t(), b :: String.t()) :: boolean()
  defp both_empty?(a, b) do
    is_empty?(a) && is_empty?(b)
  end

  @spec run(advent :: Advent, part :: :part1 | :part2) :: nil
  def run(advent, part) do
    # runs the advent execute method with the current line,
    # until two empty lines are sent
    run_until_exit = fn line, acc ->
      {_, state} = acc

      put_elem(acc, 1, advent.execute(line |> String.trim(), state))
      |> then(fn {last_line, s} ->
        {if(both_empty?(line, last_line), do: :halt, else: :cont), {String.trim(line), s}}
      end)
    end

    IO.stream()
    |> Enum.reduce_while(
      {nil, advent.init_state(part)},
      &run_until_exit.(&1, &2)
    )
    |> elem(1)
    |> advent.get_answer()
    |> IO.puts()

    nil
  end
end
