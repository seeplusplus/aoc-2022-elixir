defmodule Mix.Tasks.Day5 do
  use Mix.Task

  def run(_) do
    IO.stream() |> parse() |> part2() |> IO.puts()
  end

  def split_int_list(s, sep) do
    s |> String.split(sep) |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
  end

  def parse_line("seeds: " <> seeds) do
    {
      :seeds,
      seeds |> split_int_list(" ")
    }
  end

  def parse_line(line) when line != "" do
    make_range = fn line ->
      [dest_start, source_start, len] = line |> split_int_list(" ")
      {:range, {RangeUtil.from_start(dest_start, len), RangeUtil.from_start(source_start, len)}}
    end

    cap = Regex.run(~r/(\w+)-to-(\w+) map:/, line)

    case cap do
      [_, source, dest] -> {:map_key, {source |> String.to_atom(), dest |> String.to_atom()}}
      nil -> make_range.(line)
    end
  end

  def parse(input) do
    for line <- input,
        line = line |> String.trim(),
        line != "",
        reduce: %{} do
      acc ->
        {type, data} = parse_line(line)

        case type do
          :seeds ->
            ranges = data |> Enum.chunk_every(2)

            acc
            |> Map.put(type, data)
            |> Map.put(
              :ranges,
              ranges |> Stream.map(fn [start, len] -> RangeUtil.from_start(start, len) end)
            )

          :map_key ->
            {source, dest} = data

            acc
            |> Map.update(:maps, %{source => {dest, []}}, fn maps ->
              maps |> Map.put(source, {dest, []})
            end)
            |> Map.put(:last_map_key, source)

          :range ->
            %{last_map_key: last_map_key} = acc

            acc
            |> Map.update!(
              :maps,
              fn maps ->
                maps
                |> Map.update!(last_map_key, fn {dest, ranges} ->
                  {dest, [data | ranges]}
                end)
              end
            )
        end
    end
  end

  def get_location(:location, n, _) when is_integer(n) do
    n
  end

  def get_location(:location, range) do
    [range]
  end

  def get_location(source, n, maps) when is_integer(n) do
    {dest, ranges} = maps |> Map.get(source)

    transpose =
      case ranges
           |> Enum.find(fn {_, start} -> n in start end) do
        {dest_range, source_range} -> RangeUtil.transpose(n, source_range, dest_range)
        nil -> n
      end

    get_location(dest, transpose, maps)
  end

  def get_location(source, range) do
    {dest, ranges} = :persistent_term.get(:maps) |> Map.get(source)

    {transposed, leftover} =
      for {dest_range, source_range} <- ranges,
          reduce: {[], [range]} do
        {transposed_ranges, leftover} ->
          intersection = RangeUtil.intersection(range, source_range)

          offset = intersection.first - source_range.first
          transpose_start = dest_range.first + offset
          transposed = RangeUtil.from_start(transpose_start, intersection |> Range.size())

          {
            [transposed | transposed_ranges],
            leftover
            |> Enum.flat_map(fn r -> RangeUtil.difference(r, intersection) end)
          }
      end

    domain = leftover ++ transposed
    domain |> Stream.reject(&(&1 == ..)) |> Stream.flat_map(&get_location(dest, &1))
  end

  def part1(state) do
    for seed <- state.seeds do
      get_location(:seed, seed, state.maps)
    end
    |> Enum.min()
  end

  def loop_receive(max_len, acc, count) do
    cond do
      count == max_len -> acc

      true ->
        receive do
          n -> loop_receive(max_len, min(n, acc), count + 1)
        end
    end
  end

  def part2(state) do
    current = self()

    :persistent_term.put(:maps, state.maps)

    pids =
      for range <- state.ranges do
        spawn_link(fn ->
          send(
            current,
            get_location(:seed, range)
            |> Stream.map(fn u -> u.first end)
            |> Enum.min()
          )
        end)
      end

    loop_receive(
      pids |> Enum.count(),
      nil,
      0
    )
  end
end
