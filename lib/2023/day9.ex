defmodule Mix.Tasks.Day9 do
  use Mix.Task

  def run(_) do
    {_, content} = File.read("./input/2023_9.txt")
    solve(content, :part2) |> inspect() |> IO.puts()
  end

  def reverse_if_part_two(list, part) do
    if part == :part2 do
      Enum.reverse(list)
    else
      list
    end
  end

  def solve(content, part) do
    content
    |> String.split("\n")
    |> Stream.reject(&(&1 === ""))
    |> Stream.map(fn line ->
      line
      |> String.split(" ")
      |> Stream.map(&String.to_integer/1)
      |> Enum.to_list()
      |> then(&reverse_if_part_two(&1, part))
    end)
    |> Stream.map(&extrapolate/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  def extrapolate(list) do
    extrapolate(list, 0)
  end

  def to_difference_list(nums) do
    list =
      nums
      |> Stream.chunk_every(2, 1, :discard)
      |> Enum.reduce([], fn [a, b], acc -> [b - a | acc] end)
      |> Enum.reverse()

    list
  end

  def extrapolate([0], acc) do
    acc
  end

  def extrapolate(list, acc) do
    extrapolate(
      to_difference_list(list),
      List.last(list) + acc
    )
  end
end
