defmodule AOCRunner do
  defp is_empty(s) do
    (s |> String.trim() |> String.length()) == 0
  end

  def run(advent, part) do
    {_, state} = IO.stream() |>
    Enum.reduce_while(
      {nil, advent.init_state(part)},
      fn line, acc -> line
        |> then(fn line ->
            {u, state} = acc
            {u, advent.execute(line, state)}
          end)
        |> then(fn {u, s} ->
            if (line |> is_empty()) && (u |> is_empty()) do
              {:halt, {u, s}}
            else
              {:cont, {u, s}}
            end
          end)
        |> then(fn {reduce_atom, {_, state}} -> {reduce_atom, {String.trim(line), state}} end)
      end
    )

    IO.puts(advent.get_answer(state))
  end
end
