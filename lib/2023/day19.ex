defmodule Mix.Tasks.Day19 do
  def run(args) do
    [part | _] = args
    {_, puzzle_input} = File.read("./input/2023_19.txt")
    part = if part == "1", do: :part1, else: :part2 

    {commands, toys} = parse(puzzle_input, case part do 
      :part1 -> &build_comparator/1
      :part2 -> &build_range_comparator/1
      end)

    cond do
      part == :part1 -> solve_part_1(commands, toys)
      part == :part2 -> solve_part_2(commands)
    end |> IO.puts()
  end

  def build_comparator(map) do
    %{"comp" => comp, "facet" => facet, "target" => target, "thresh" => thresh} = map

    if comp == "" do
      fn _ -> target end
    else
      comp =
        if comp == ">" do
          fn a, b -> a > b end
        else
          comp == "<"
          fn a, b -> a < b end
        end

      thresh = String.to_integer(thresh)

      fn toy ->
        if toy |> Map.get(facet) |> comp.(thresh) do
          target
        else
          nil
        end
      end
    end
  end

  def build_range_comparator(map) do
    %{"comp" => comp, "facet" => facet, "target" => target, "thresh" => thresh} = map

    if comp == "" do
      fn toy -> [{toy, target}] end
    else
      thresh = String.to_integer(thresh)

      fn toy ->
        toy
        |> Map.get(facet)
        |> RangeUtil.split_at(thresh, if(comp == ">", do: :lb, else: :ub))
        |> Enum.map(fn new_range ->
          if comp == ">" and new_range.first > thresh do
            {new_range, target}
          else
            if comp == "<" and new_range.last < thresh do
              {new_range, target}
            else
              {new_range, nil}
            end
          end
        end)
        |> Enum.map(fn {new_range, target} ->
          {toy |> Map.put(facet, new_range), target}
        end)
      end
    end
  end

  def parse(puzzle_input, comparator_builder) do
    [commands, toys] = puzzle_input |> String.split("\n\n")

    commands =
      commands
      |> String.split("\n")
      |> Enum.map(fn l ->
        [label, inner | _] = String.split(l, ["{", "}"])
        inner = String.split(inner, ",")

        steps =
          inner
          |> Enum.map(fn i ->
            r = ~r/(((?P<facet>[xmas])(?P<comp>[<>])(?P<thresh>\d+):)?(?P<target>\w+),?)/
            Regex.named_captures(r, i) |> comparator_builder.()
          end)

        {label, steps}
      end)
      |> Map.new()

    toys =
      toys
      |> String.split("\n")
      |> Stream.reject(&(&1 == ""))
      |> Enum.map(fn t ->
        [_, u, _] = String.split(t, ["{", "}"])

        u
        |> String.split(",")
        |> Stream.map(fn f -> f |> String.split("=") end)
        |> Enum.map(fn [f, t] ->
          {f, String.to_integer(t)}
        end)
        |> Map.new()
      end)

    {commands, toys}
  end

  def map_toy(toy, label, map) do
    if label === "A" or label === "R" do
      label
    else
      map
      |> Map.get(label)
      |> Enum.reduce_while(
        nil,
        fn f, _ ->
          dest = f.(toy)
          {if(is_nil(dest), do: :cont, else: :halt), dest}
        end
      )
      |> then(fn dest -> map_toy(toy, dest, map) end)
    end
  end

  def map_toy_range(toy_range, label, commands) do
    if label === "A" or label === "R" do
      [{toy_range, label}]
    else
      commands
      |> Map.get(label)
      |> Enum.reduce_while(
        [{toy_range, nil}],
        fn f, acc ->
          new =
            acc
            |> Enum.flat_map(fn {range, target} ->
              if is_nil(target) do
                f.(range)
              else
                [{range, target}]
              end
            end)

          {
            if(Enum.all?(new, fn {_, dest} -> !is_nil(dest) end), do: :halt, else: :cont),
            new
          }
        end
      )
      |> Enum.flat_map(fn {r, t} -> map_toy_range(r, t, commands) end)
    end
  end

  def solve_part_1(toys, commands) do
    toys
    |> Enum.filter(fn t -> map_toy(t, "in", commands) === "A" end)
    |> Enum.map(fn t ->
      t |> Map.values() |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def solve_part_2(commands) do
    toy_range = %{"x" => 1..4000, "m" => 1..4000, "a" => 1..4000, "s" => 1..4000}

    map_toy_range(toy_range, "in", commands)
    |> Stream.filter(fn {_, r} -> r === "A" end)
    |> Stream.map(&elem(&1, 0))
    |> Stream.map(fn r ->
      Map.values(r) |> Enum.reduce(1, fn rr, acc -> acc * Range.size(rr) end)
    end)
    |> Enum.sum()
  end
end
