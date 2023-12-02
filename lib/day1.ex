defmodule Day1 do
  def get_answer(state) do
    {_, total, part} = state

    total
    |> then(fn total ->
      case part do
        :part1 -> total
        :part2 -> total |> Enum.reduce(0, fn i, acc -> i + acc end)
      end
    end)
  end

  def init_state(part) do
    case part do
      :part1 -> {nil, 0, part}
      :part2 -> {nil, [0, 0, 0], part}
    end
  end

  def execute(line, state) do
    apply_command(
      line |> to_command(),
      state
    )
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
    {current, total, part} = state

    new_current =
      n +
        if is_nil(current) do
          0
        else
          current
        end

    {new_current, total, part}
  end

  defp take_top_three(n, list) do
    [n | list]
    |> Enum.sort(:desc)
    |> Enum.take(3)
  end

  defp apply_reset(state) do
    {current, total, part} = state

    if !is_nil(current) do
      case part do
        :part1 -> {nil, max(total, current), part}
        :part2 -> {nil, take_top_three(current, total), part}
      end
    else
      state
    end
  end
end
