defmodule RollingRocks do
  def score_rows(rows) do
    rows = rows |> String.split("\n")
    len = rows |> Enum.count()

    rows
    |> Enum.with_index()
    |> Enum.map(fn {l, i} -> {l, len - i} end)
    |> Enum.map(fn {l, i} ->
      {l |> String.to_charlist() |> Enum.filter(&(&1 === ?O)) |> Enum.count(), i}
    end)
    |> Enum.map(fn {c, i} -> c * i end)
    |> Enum.sum()
  end

  def roll_rocks(tiles, direction) do
    tiles
    |> Enum.reject(fn tile -> tile |> Map.get(:tile) == "" end)
    # |> Enum.each(fn tile -> IO.puts(inspect(tile)) end)
    |> Enum.chunk_by(fn tile -> tile |> Map.get(:tile) !== "#" end)
    |> Enum.flat_map(fn chunk ->
      Enum.sort_by(
        chunk,
        fn m -> Map.get(m, :tile) end,
        if(direction === :north or direction === :west, do: :desc, else: :asc)
      )
    end)
  end

  def line_to_tile_map({line, r_idx}) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.map(fn {c, c_idx} -> %{idx: {r_idx, c_idx}, tile: c} end)
  end

  def solve_1(input) do
    StringUtil.transpose(input)
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(&line_to_tile_map(&1))
    |> Enum.map(&roll_rocks(&1, :north))
    |> EnumUtil.transpose()
    |> Enum.map(fn tilemap ->
      tilemap
      |> Enum.map(fn tile -> Map.get(tile, :tile) end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> score_rows()
  end

  def solve_2(input) do
    u =
      1..(10 ** 9)
      |> Enum.reduce_while(
        {%{input => 0}, input, nil},
        fn i, {map, input, _} ->
          rolled = cycle(input)

          cont = if Map.has_key?(map, rolled), do: :halt, else: :cont

          if cont == :halt do
            # IO.puts("collision at #{Map.get(map, rolled)}")
            {cont, {map, rolled, Map.get(map, rolled)}}
          else
            map = Map.put(map, rolled, i)
            {cont, {map, rolled, nil}}
          end
        end
      )

    map = elem(u, 0)
    cycle_start = elem(u, 2)
    cycle_repeat = (elem(u, 0) |> Map.values() |> Enum.max()) + 1
    offset = rem(10 ** 9 - cycle_start, cycle_repeat - cycle_start) + cycle_start


    map
      |> Stream.filter(&(elem(&1, 1) === offset))
      |> Stream.map(fn {t, x} -> {score_rows(t), x} end)
      |> Stream.map(&(elem(&1, 0)))
      |> Enum.at(0)
  end

  def cycle(grid) do
    StringUtil.transpose(grid)
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(&line_to_tile_map(&1))
    |> Enum.map(&roll_rocks(&1, :north))
    |> EnumUtil.transpose()
    |> Enum.map(&roll_rocks(&1, :west))
    |> EnumUtil.transpose()
    |> Enum.map(&roll_rocks(&1, :south))
    |> EnumUtil.transpose()
    |> Enum.map(&roll_rocks(&1, :east))
    |> Enum.map(fn tilemap ->
      tilemap
      |> Enum.map(fn tile -> Map.get(tile, :tile) end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
  end
end
