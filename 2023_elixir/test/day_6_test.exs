defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "solve/2 part 1" do
    assert Day6.solve(:part_1, "#{File.cwd!()}/test/files/day_6_test_input.txt") == 288
  end

  test "solve/2 part 2" do
    assert Day6.solve(:part_2, "#{File.cwd!()}/test/files/day_6_test_input.txt") == 71503
  end
end
