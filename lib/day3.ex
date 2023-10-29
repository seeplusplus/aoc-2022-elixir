defmodule Day3 do
  def init_state(part) do
    %{sum: 0, part: part}
  end

  defp find_duplicates(line) do
    line |>
      String.to_charlist() |>
      Enum.chunk_every(Integer.floor_div(String.length(line), 2)) |>
      Enum.map(&MapSet.new/1) |>
      then(fn [a,b] -> MapSet.intersection(a,b) end) |>
      MapSet.to_list()
  end

  defp to_priority(c) do
    u = if is_nil(c) do 0 else if c < 97 do c - 38 else c - 96 end end
    u
  end

  def execute(line, state) do
    increment_sum = fn s -> Map.update(state, :sum, 0, &(&1 + s)) end 

    trimmed = line |> String.trim()

    unless String.length(trimmed) == 0 do
      trimmed |>
        find_duplicates() |>
        Enum.map(&to_priority(&1)) |>
        Enum.reduce(&(&1 + &2)) |>
        increment_sum.()
    else
      state
    end
  end

  def get_answer(state) do
    state.sum
  end
end

