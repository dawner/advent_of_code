defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "solve/2 part 1" do
    assert Day14.solve(:part_1, "#{File.cwd!()}/test/files/day_14_test_input.txt") == 136
  end

  test "solve/2 part 2" do
    assert Day14.solve(:part_2, "#{File.cwd!()}/test/files/day_14_test_input.txt") == 64
  end
end
