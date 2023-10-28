defmodule Day1 do
  def get_answer(state) do
    elem(state, 1) |>
      Enum.reduce(0, fn i, acc -> i + acc end)
  end

  def init_state() do
    {nil, [0, 0, 0]}
  end

  def execute(line, state) do 
    apply_command(
      line |> to_command(),
      state)
  end

  defp apply_command(command, state) do
    case command do
      {:add, n} -> apply_add(n, state)
      {:reset} -> apply_reset(state)
    end
  end

  defp to_command(s) do
    try do
      {:add, s |> String.trim() |> String.to_integer()}
    rescue 
      ArgumentError -> {:reset}
    end
  end

  defp apply_add(n, state) do
    {current, total} = state
    new_current = n + if is_nil(current) do 0 else current end
    
    {new_current, total}
  end

  defp take_top_three(n, list) do
    [ n | list ] |>
      Enum.sort(:desc) |>
      Enum.take(3)
  end

  defp apply_reset(state) do
    {current, total} = state
    if !is_nil(current) do
      {nil, take_top_three(current, total)}
    else
      state
    end
  end
end

