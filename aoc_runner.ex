defmodule AOCRunner do
  def run(advent) do
    result = IO.stream() |> 
    Enum.reduce_while(
      advent.init_state(),
      fn line, acc -> line
        |> advent.to_command()
        |> advent.apply_command(acc)
        |> then(fn acc -> if elem(acc, 2) do {:halt, acc} else {:cont, acc} end end)
      end
    )

    IO.puts(advent.get_answer(result))
  end
end
