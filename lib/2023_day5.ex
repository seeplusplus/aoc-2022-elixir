defmodule Mix.Tasks.Day5 do
  use Mix.Task

  def run(_) do
    IO.stream() |> parse() |> part1() |> IO.puts()
  end

  def split_int_list(s, sep) do
    s |> String.split(sep) |> Enum.map(fn n -> Integer.parse(n) |> elem(0) end)
  end

  def parse_line("seeds: " <> seeds) do
    {:seeds, seeds |> split_int_list(" ")}
  end

  def parse_line(line) when line != "" do
    make_range = fn line ->
      [dest_start, source_start, len] = line |> split_int_list(" ")
       {:range, {RangeUtil.from_start(dest_start, len), RangeUtil.from_start(source_start, len)}}
    end
    cap = Regex.run(~r/(\w+)-to-(\w+) map:/, line)
    case cap do
     [_, source, dest] -> {:map_key, { source |> String.to_atom(), dest |> String.to_atom() } }
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
          :seeds -> acc |> Map.put(type, data)
          :map_key -> { source, dest } = data
            acc 
              |> Map.update(:maps, %{source => {dest, []}}, fn maps -> maps |> Map.put(source, {dest, []}) end)
              |> Map.put(:last_map_key, source)
          :range -> %{last_map_key: last_map_key} = acc
            acc |> Map.update!(
              :maps,
              fn maps -> maps 
                |> Map.update!(last_map_key, fn {dest, ranges} ->
                  {dest, [data | ranges]}
                end)
              end)
        end
    end
  end
  def get_location(:location, n, _) do
    n
  end
  def get_location(source, n, maps) do
    {dest, ranges} = maps |> Map.get(source)
    transpose = case ranges |> Enum.find(fn {_, source} ->
      n in source
    end) do
      {dest_range, source_range} ->RangeUtil.transpose(n, source_range, dest_range)
      nil -> n
    end
    IO.puts({dest, transpose} |> inspect())
    get_location(dest, transpose, maps)
  end

  def part1(state) do
    for seed <- state.seeds do
      get_location(:seed, seed, state.maps)
    end |> Enum.min()
  end
end
