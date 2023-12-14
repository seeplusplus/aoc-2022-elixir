defmodule Galaxy do
  def init(input) do
    rows = input |> String.split("\n")

    %{
      rows: rows
    }
  end

  def get_cols(rows) do
    col_count = rows |> Enum.at(0) |> String.length()

    for col <- 0..(col_count - 1) do
      rows |> Stream.map(&String.at(&1, col)) |> Enum.join("")
    end
  end

  def expand_if_empty(space) do
    case String.contains?(space, "#") do
      true -> [space]
      false -> [space, space]
    end

  end


  def expand_as_cols(galaxy) do
    rows =
      galaxy.rows
      |> Enum.flat_map(&expand_if_empty/1)


    cols =

      get_cols(rows)
      |> Enum.flat_map(&expand_if_empty/1)


    cols
  end

  def distance({x1, x2}, {y1, y2}) do
    abs(x1 - y1) + abs(x2 - y2)
  end

  def shortest_path(cols) do
    galaxies =
      cols
      |> Stream.with_index()
      |> Enum.flat_map(fn {col, col_index} ->
        col
        |> String.graphemes()
        |> Stream.with_index()
        |> Stream.filter(&(elem(&1, 0) === "#"))
        |> Enum.map(fn {_, row_index} -> {col_index, row_index} end)
      end)


    for galaxy <- galaxies,
        other_galaxy <- galaxies,
        galaxy != other_galaxy,
        into: %{} do
      {{galaxy, other_galaxy}, distance(galaxy, other_galaxy)}
    end
  end

  def emptiness_betwixt({x2, x1}, {y2, y1}, cols, rows) do
    min_x = min(x1, y1)
    max_x = max(x1, y1)

    min_y = min(x2, y2)
    max_y = max(x2, y2)

    (Stream.filter(rows, fn row -> row > min_x and row < max_x end) |> Enum.count()) +
      (Stream.filter(cols, fn c -> c > min_y and c < max_y end) |> Enum.count())

  end


  def solve_pt_1(input) do
    Galaxy.init(input)

    |> Galaxy.expand_as_cols()

    |> Galaxy.shortest_path()
    |> Stream.map(fn {_, distance} ->
      distance
    end)
    |> Enum.sum()
    |> div(2)

  end


  def get_empty(iter) do
    iter
    |> Stream.with_index()
    |> Stream.reject(&String.contains?(elem(&1, 0), "#"))
    |> Enum.map(&elem(&1, 1))
  end

  def shortest_paths_expansion_adjusted(input, expansion) do
    galaxy = Galaxy.init(input)


    cols = get_cols(galaxy.rows)
    empty_cols = get_empty(cols)

    empty_rows = get_empty(galaxy.rows)

    shortest_paths = shortest_path(cols)


    # adjust_distance = fn (distance, emptiness) -> 
    #   distance + emptiness*(-1+expansion)
    # end

    shortest_paths
    |> Stream.map(fn {{p1, p2}, distance} ->
      # {{p1, p2}, adjust_distance.(distance, emptiness_betwixt(p1, p2, empty_cols, empty_rows))}
      # old + num_empty_rows*(-1 + expansion_factor)
      adjust_distance_for_expansion(
        distance,
        emptiness_betwixt(p1, p2, empty_cols, empty_rows),

        expansion
      )
    end)
    |> Enum.sum()
    |> div(2)

  end


  def adjust_distance_for_expansion(distance, num_empty, expansion_factor) do
    distance + num_empty * (-1 + expansion_factor)
  end
end
