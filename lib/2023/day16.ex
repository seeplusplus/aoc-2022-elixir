defmodule Lightmap do
  defstruct grid: %{}, height: 0, width: 0


  @char_map %{
    ?. => :space,
    ?/ => :fw_mirror,

    ?\\ => :bk_mirror,
    ?| => :vert_split,
    ?- => :horz_split
  }
  def out_of_bounds?(%Lightmap{height: height, width: width}, {x, y}) do
    x < 0 || y < 0 || y >= height || x >= width
  end

  def parse(input) do
    grid =
      for ent <-

            input
            |> String.split("\n")
            |> Stream.with_index()
            |> Stream.flat_map(fn {line, row_index} ->
              line
              |> String.to_charlist()
              |> Stream.with_index()
              |> Enum.map(fn {char, col_index} ->

                {{col_index, row_index}, @char_map[char]}
              end)
            end),
          into: %{} do
        ent
      end

    %Lightmap{
      grid: grid,
      height: input |> String.trim() |> String.split("\n") |> Enum.count(),
      width: input |> String.trim() |> String.split("\n") |> Enum.at(0) |> String.length()
    }
  end
end

defmodule Lightbeam do
  def trace([], _, positions) do
    positions
  end

  def trace(heads, map, positions) do
    new_heads =
      heads
      |> Stream.flat_map(fn {pos, dir} ->
        next_position(pos, dir, Map.get(map.grid, pos))
      end)
      |> Stream.reject(fn {new_pos, _} ->
        Lightmap.out_of_bounds?(map, new_pos)
      end)
      |> Enum.reject(fn {new_pos, new_dir} ->
        MapSet.member?(positions, {new_pos, new_dir})
      end)

    positions =
      for {pos, dir} <- new_heads,
          reduce: positions do
        acc -> MapSet.put(acc, {pos, dir})
      end

    trace(new_heads, map, positions)
  end

  def solve_for_pos_and_direction(pos, direction, map) do
    initial_pos_dir = {pos, direction}


    Lightbeam.trace([initial_pos_dir], map, MapSet.new([initial_pos_dir]))
    |> Stream.map(&elem(&1, 0))
    |> Stream.uniq()
    |> Enum.count()
  end


  def solve_for_max_along_edges(puzzle_input) do
    map = Lightmap.parse(puzzle_input)
    rows = puzzle_input |> String.trim() |> String.split("\n") |> Enum.with_index()

    {first_row, _} = rows |> Enum.at(0)
    {_, last_row_idx} = rows |> Enum.at(-1)

    last_col_idx = (first_row |> String.length()) - 1


    for row <- 0..last_row_idx, reduce: 0 do
      acc -> max(acc, Lightbeam.solve_for_pos_and_direction({0, row}, :right, map))
    end
    |> max(
      for row <- 0..last_row_idx, reduce: 0 do
        acc -> max(acc, Lightbeam.solve_for_pos_and_direction({last_col_idx, row}, :left, map))
      end
    )
    |> max(

      for col <- 0..last_col_idx, reduce: 0 do
        acc -> max(acc, Lightbeam.solve_for_pos_and_direction({col, 0}, :down, map))
      end
    )
    |> max(
      for col <- 0..last_col_idx, reduce: 0 do
        acc -> max(acc, Lightbeam.solve_for_pos_and_direction({col, last_row_idx}, :up, map))
      end
    )

  end


  @direction_tuple %{
    :up => {0, -1},
    :down => {0, 1},
    :left => {-1, 0},

    :right => {1, 0}
  }

  @direction_map %{
    :vert_split => %{
      :up => [:up],
      :down => [:down],
      :left => [:up, :down],
      :right => [:up, :down]

    },
    :horz_split => %{
      :left => [:left],
      :right => [:right],
      :up => [:left, :right],
      :down => [:left, :right]
    },
    :fw_mirror => %{
      :left => [:down],
      :up => [:right],
      :right => [:up],
      :down => [:left]
    },
    :bk_mirror => %{
      :left => [:up],
      :up => [:left],
      :right => [:down],
      :down => [:right]
    },
    :space => %{
      :left => [:left],

      :right => [:right],
      :up => [:up],

      :down => [:down]
    }
  }

  def next_position(current_position, direction, tile) do
    @direction_map[tile][direction]
    |> Enum.map(fn dir ->

      {
        TupleUtil.pairwise_sum(current_position, @direction_tuple[dir]),
        dir
      }
    end)
  end

  def visualize_trace(trace, input) do
    for {row, r_idx} <- input |> String.trim() |> String.split("\n") |> Stream.with_index(),
        {_, col} <- row |> String.to_charlist() |> Stream.with_index(),
        max_col = row |> String.length() do
      if trace |> Enum.any?(&(elem(&1, 0) === {col, r_idx})) do
        IO.write("#")
      else
        IO.write(".")

      end

      if col === max_col - 1 do
        IO.write("\n")
      end
    end
  end
end
