defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  test "solve/2 part 1" do
    assert Day15.solve(:part_1, "#{File.cwd!()}/test/files/day_15_test_input.txt") == 1320
  end

  test "solve/2 part 2" do
    assert Day15.solve(:part_2, "#{File.cwd!()}/test/files/day_15_test_input.txt") == 145
  end
end
