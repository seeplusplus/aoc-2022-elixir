defmodule Mix.Tasks.Day6 do
  use Mix.Task

  def parse(input, :part1) do
    input
    |> Enum.map(fn s ->
      String.split(s, " ")
      |> Enum.reject(fn s -> s === "" or s === "Time:" or s === "Distance:" end)
    end)
    |> Enum.map(fn i ->
      i
      |> Enum.map(fn s ->
        s |> String.trim() |> String.to_integer()
      end)
    end)
  end

  def parse(input, :part2) do
    input
    |> Enum.map(fn s ->
      String.split(s, " ")
      |> Enum.reject(fn s -> s === "" or s === "Time:" or s === "Distance:" end)
    end)
    |> Enum.map(fn u ->
      u
      |> Enum.join("")
      |> String.trim()
      |> String.to_integer()
    end)
  end

  def distance_traveled_in_n_seconds(seconds, duration) do
    seconds * (duration - seconds)
  end

  def polynomial_roots(a, b, c) do
    [
      (-b + :math.sqrt(b ** 2 - 4 * a * c)) / (2 * a),
      (-b - :math.sqrt(b ** 2 - 4 * a * c)) / (2 * a)
    ]
  end

  def solve([time, distance], p) when p === :part2 do
    # number of negative integer solutions to the polynomial
    # x^2 - tx + d < 0
    # where x is time spent holding button, t is the duration of the race (seconds), and d is the distance to beat
    roots = polynomial_roots(1, -time, distance)
    max = roots |> Enum.max()
    min = roots |> Enum.min()
    floor(max) - floor(min)
  end

  def solve([times, distances], p) when p === :part1 do
    for {time, index} <- times |> Enum.with_index(),
        seconds <- 1..(time - 1),
        distance_traveled_in_n_seconds(seconds, time) > distances |> Enum.at(index),
        reduce: %{} do
      acc ->
        acc |> Map.update(time, [seconds], fn u -> [seconds | u] end)
    end
    |> Map.values()
    |> Enum.reduce(
      1,
      fn a, acc ->
        acc * (a |> Enum.count())
      end
    )
  end

  def run(args) do
    part = if args |> Enum.at(0) == "1", do: :part1, else: :part2
    IO.stream() |> parse(part) |> solve(part) |> IO.puts()
  end
end
