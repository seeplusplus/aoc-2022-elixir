defmodule Exercise1 do
  def to_command(s) do
    try do
      {:add, s |> String.trim() |> String.to_integer()}
    rescue 
      ArgumentError -> {:reset}
    end
  end

  def get_answer(state) do
    elem(state, 1) |> 
      Enum.reduce(0, fn i, acc -> i + acc end)
  end

  def init_state() do
    {nil, [0, 0, 0], false}
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
    new_total = [ new_current | total ] |> 
      Enum.sort(:desc) |>
      Enum.take(3)
    {new_current, new_total, exit}
  end

  defp apply_reset(state) do
    {current, total, exit} = state
    case current do
      nil -> {current, total, true}
      _ -> {nil, total, exit}
    end
  end
end

