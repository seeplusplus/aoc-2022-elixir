defmodule PipeModule do
  @pipe_types %{
    "|" => {:n, :s},
    "-" => {:e, :w},
    "L" => {:n, :e},
    "J" => {:n, :w},
    "7" => {:s, :w},
    "F" => {:s, :e},
    "." => :ground,
    "S" => :animal
  }

  def parse(input) do
    for u <-
          input
          |> String.split("\n")
          |> Stream.with_index()
          |> Enum.flat_map(fn {line, line_idx} ->
            line
            |> String.graphemes()
            |> Stream.with_index()
            |> Enum.map(fn {pipe_char, index} ->
              {{index, line_idx}, Map.get(@pipe_types, pipe_char)}
            end)
          end),
        into: %{} do
      u
    end
  end

  def connects?(pipe1, pipe2, _) when pipe1 == :ground or pipe2 == :ground do
    false
  end

  def connects?(pipe1, pipe2, orientation) do
    can_connect?(pipe1, orientation) and can_connect?(pipe2, flip(orientation))
  end

  def flip(orientation) do
    case orientation do
      :n -> :s
      :s -> :n
      :w -> :e
      :e -> :w
    end
  end

  def can_connect?(:animal, _) do
    true
  end

  def can_connect?({d1, d2}, orientation) do
    d1 == orientation or d2 == orientation
  end

  def to_orientation({x1, x2}, {y1, y2}) do
    {z1, z2} = {y1 - x1, y2 - x2}

    case z1 do
      0 ->
        case z2 do
          -1 -> :n
          1 -> :s
        end

      1 ->
        case z2 do
          0 -> :e
        end

      -1 ->
        case z2 do
          0 -> :w
        end
    end
  end

  def furthest_from_animal(loop) do
    loop
    |> Enum.reduce(
      %{},
      fn {pipe, steps}, acc ->
        Map.update(acc, pipe, [steps], fn p -> [steps | p] end)
      end
    )
    |> Stream.filter(fn {_, a} -> a |> Enum.count() == 2 end)
    |> Enum.reject(fn {_, [a, b]} -> a != b or a == 0 end)
    |> Enum.at(0)
  end

  def find_animal(grid) do
    grid
      |> Enum.find(nil, fn {_, pipe} -> pipe == :animal end)
      |> elem(0)
  end
  def find_loop({i, j}, pipes, grid) do
    pipe = Map.get(grid, {i, j})
    connected_neighbors =
      for ii <- -1..1,
          jj <- -1..1,
          (ii == 0 or jj == 0) and !(ii == 0 and jj == 0),
          {z1, z2} = {i + ii, j + jj},
          z1 != -1 and z2 != -1,
          neighbor = Map.get(grid, {z1, z2}),
          connects?(pipe, neighbor, to_orientation({i, j}, {z1, z2})) do
        {z1, z2}
      end

    connected_pipes_checked =
      Enum.filter(
        connected_neighbors,
        fn n -> Enum.any?(pipes, fn {p, _} -> n == p end) end
      )

    if connected_pipes_checked
       |> Enum.count() == 2 do
      pipes
    else
      step = pipes |> Enum.count()

      Enum.flat_map(
        connected_neighbors
        |> Enum.reject(fn n -> Enum.any?(pipes, fn {p, _} -> p == n end) end),
        fn {ii, jj} ->
          find_loop({ii, jj}, [{{i, j}, step} | pipes], grid)
        end
      )
    end
  end

  defp loop_as_set(loop) do
    loop |> Stream.map(&elem(&1, 0)) |> MapSet.new()
  end

  def to_string(pipe) do
    case pipe do
      :ground -> "."
      :animal -> "S"
      # List.to_string([])
      {:n, :s} -> <<0x2551::8>>
      {:e, :w} -> List.to_string([0x2550])
      {:n, :e} -> List.to_string([0x255A])
      {:n, :w} -> List.to_string([0x255D])
      {:s, :w} -> List.to_string([0x2557])
      {:s, :e} -> List.to_string([0x2554])
      _ -> ""
    end
  end

  def get_tile_under_animal(loop) do
    # TODO
  end

  def get_inside_count(grid, loop) do
    loop_set = loop_as_set(loop)

    for room <-
          grid
          |> Enum.sort_by(fn {{x, y}, _} -> {y, x} end)
          |> Enum.map_reduce(
            %{n: false, s: false, o: 0, i: 0},
            fn {{x, y}, tile}, %{n: n, s: s, o: o, i: i} ->
              tile =
                if tile == :animal do
                  get_tile_under_animal(loop)
                  tile
                else
                  tile
                end

              {n, s, o, i} =
                if loop_set |> MapSet.member?({x, y}) do
                  n = if PipeModule.opens_north?(tile), do: !n, else: n
                  s = if PipeModule.opens_south?(tile), do: !s, else: s
                  {n, s, o, i}
                else
                  {i, o} =
                    if n || s do
                      i = i + 1
                      {i, o}
                    else
                      o = o + 1
                      {i, o}
                    end

                  {n, s, o, i}
                end

              tile_location =
                if loop_set |> MapSet.member?({x, y}),
                  do: :loop,
                  else:
                    (case n || s do
                       true -> :inside
                       false -> :outside
                     end)

              {{{x, y}, {tile, tile_location}}, %{n: n, s: s, o: o, i: i}}
            end
          )
          |> elem(0),
        into: %{} do
      room
    end
    |> Map.values()
    |> Enum.filter(&(elem(&1, 1) == :inside))
    |> Enum.count()
  end

  def opens_north?({a, b}) when a == :n or b == :n do
    true
  end

  def opens_north?(_) do
    false
  end

  def opens_south?({a, b}) when a == :s or b == :s do
    true
  end

  def opens_south?(:animal) do
    true
  end

  def opens_south?(_) do
    false
  end
end
