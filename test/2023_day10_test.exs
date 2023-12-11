defmodule Day102023Tests do
  use ExUnit.Case

  @test_input ~s"..F7.
.FJ|.
SJ.L7
|F--J
LJ..."

  @pt_2_input ~s".F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ..."


  @grid PipeModule.parse(@test_input)
  @pt_2_grid PipeModule.parse(@pt_2_input)

  assert "solves part1" do
    animal_coords = PipeModule.find_animal(@grid)
    loop = PipeModule.find_loop(animal_coords, [], @grid)
    {coord, [count, count]} = PipeModule.furthest_from_animal(loop)
    assert count == 8
    assert coord = {4, 2}
  end

  assert "solves part 2" do
    animal_coords = PipeModule.find_animal(@pt_2_grid)
    loop = PipeModule.find_loop(animal_coords, [], @pt_2_grid)
    count = PipeModule.get_inside_count(@pt_2_grid, loop)
    assert count == 8
  end
end
