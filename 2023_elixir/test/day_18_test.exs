defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  test "solve/2 part 1" do
    assert Day18.solve(:part_1, "#{File.cwd!()}/test/files/day_18_test_input.txt") == 62
  end

  test "solve/2 part 2" do
    assert Day18.solve(:part_2, "#{File.cwd!()}/test/files/day_18_test_input.txt") ==
             952_408_144_115
  end
end
