const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() void {
    const part1_res = part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) usize {
    for (0..len - 4) |i| {
        var unique = outer: for (in[i .. i + 4], i..) |char, j| {
            for (in[j + 1 .. i + 4]) |c| {
                if (char == c) {
                    break :outer false;
                }
            }
        } else true;

        if (unique) {
            return i + 4;
        }
    }
    return 0;
}

test "Part 1" {
    const expected: usize = 7;
    const actual = part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
