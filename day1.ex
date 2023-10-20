defmodule Excersize1 do
  def to_command(s) do
    try do
      {:add, s |> String.trim() |> String.to_integer()}
    rescue 
      ArgumentError -> {:reset}
    end
  end

  def init_state() do
    {nil, 0, false}
  end
  def apply_command(command, state) do
    case command do
      {:add, n} -> apply_add(n, state)
      {:reset} -> apply_reset(state)
    end
  end

  defp apply_add(n, state) do
    {current, total, exit} = state
    new_current = if is_nil(current) do 0 else current end + n
    {new_current, max(total, new_current), exit}
  end

  defp apply_reset(state) do
    {current, total, exit} = state
    case current do
      nil -> {current, total, true}
      _ -> {nil, total, exit}
    end
  end
end

result = IO.stream() |> 
  Enum.reduce_while(
    Excersize1.init_state(),
    fn line, acc -> line
      |> Excersize1.to_command()
      |> Excersize1.apply_command(acc)
      |> then(fn acc -> if elem(acc, 2) do {:halt, acc} else {:cont, acc} end end)
    end
  )

  IO.puts(elem(result, 1))
