defmodule Mix.Tasks.Day9 do
  use Mix.Task

  def run(_) do
    {_, content} = File.read("./input/2023_9.txt")

    solve(content)|> inspect() |> IO.puts()
  end

  def solve(content) do
    content
      |> String.split("\n")
      |> Stream.reject(&(&1 === ""))
      |> Stream.map(fn line ->
        line
        |> String.split(" ")
        |> Stream.map(&String.to_integer/1)
        |> Enum.to_list()
      end) 
      |> Stream.map(fn list -> 
      IO.puts(inspect(list))
      extrapolate(list)
      end)
      |> Enum.reduce([], 
        fn l, acc -> 
        [l |> Enum.sum()
        | acc]
      end)  |> Enum.sum()
      
  end

  def extrapolate(list) do
    extrapolate(list, [])
  end

  def to_difference_list(nums) do
    IO.puts("differencing #{inspect(nums)}")
    list = nums 
      |> Stream.chunk_every(2, 1, :discard)
      |> Enum.reduce([], fn [a,b], acc -> [ b - a | acc] end)
    IO.puts("differenc was #{inspect(list)}")
    list
  end

  def extrapolate([0], acc) do
    [0 | acc]
  end

  def extrapolate(list, acc) do
    IO.puts("extrapolating #{inspect(list)}")
    extrapolate(
      list |> to_difference_list() |> Enum.reverse(),
      [list |> List.last() | acc]
    )
  end

  end
