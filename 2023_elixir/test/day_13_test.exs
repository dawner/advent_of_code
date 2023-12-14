defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "solve/2 part 1" do
    assert Day13.solve(:part_1, "#{File.cwd!()}/test/files/day_13_test_input.txt") == 405
  end

  test "solve/2 part 2" do
    assert Day13.solve(:part_2, "#{File.cwd!()}/test/files/day_13_test_input.txt") == 400
  end
end
