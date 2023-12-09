defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "solve/2 part 1" do
    assert Day7.solve(:part_1, "#{File.cwd!()}/test/files/day_7_test_input.txt") == 6440
  end

  test "solve/2 part 2" do
    assert Day7.solve(:part_2, "#{File.cwd!()}/test/files/day_7_test_input.txt") == 5905
  end

  test "process_line/1" do
    # 2 of a kind
    assert Day7.process_line("K9J5A 123", true) == {[13, 9, 0, 5, 14], 2, 123}
    # 3 of a kind
    assert Day7.process_line("TKQJT 123", true) == {[10, 13, 12, 0, 10], 4, 123}
    # 4 of a kind
    assert Day7.process_line("JK4KJ 123", true) == {[0, 13, 4, 13, 0], 6, 123}
  end
end
