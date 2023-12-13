defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "solve/2 part 1" do
    assert Day12.solve(:part_1, "#{File.cwd!()}/test/files/day_12_test_input.txt") == 21
  end

  test "solve/2 part 2" do
    assert Day12.solve(:part_2, "#{File.cwd!()}/test/files/day_12_test_input.txt") == 525_152
  end

  test "process_line part 1" do
    assert Day12.process_line("???.###", "1,1,3") == 1
    assert Day12.process_line(".??..??...?##.", "1,1,3") == 4
    assert Day12.process_line("?#?#?#?#?#?#?#?", "1,3,1,6") == 1
    assert Day12.process_line("????.#...#..", "4,1,1") == 1
    assert Day12.process_line("????.######..#####.", "1,6,5") == 4
    assert Day12.process_line("?###????????", "3,2,1") == 10

    # Extra test cases
    assert Day12.process_line(".##.?#??.#.?#", "2,1,1,1") == 1
  end
end
