defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "solve/2 part 1" do
    assert Day9.solve(:part_1, "#{File.cwd!()}/test/files/day_9_test_input.txt") == 114
  end

  test "solve/2 part 2" do
    assert Day9.solve(:part_2, "#{File.cwd!()}/test/files/day_9_test_input.txt") == 2
  end
end
