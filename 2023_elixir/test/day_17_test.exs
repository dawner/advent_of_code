defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  test "solve/2 part 1" do
    assert Day17.solve(:part_1, "#{File.cwd!()}/test/files/day_17_test_input.txt") == 102
  end

  test "solve/2 part 2" do
    assert Day17.solve(:part_2, "#{File.cwd!()}/test/files/day_17_test_input.txt") == 94
  end

  test "solve/2 part 2 simpler" do
    assert Day17.solve(:part_2, "#{File.cwd!()}/test/files/day_17_test_2_input.txt") == 71
  end
end
