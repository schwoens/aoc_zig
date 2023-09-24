const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

const std = @import("std");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    std.debug.print("Part 1: {}", .{part1_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !u32 {
    var max_calories: u32 = 0;
    var calories: u32 = 0;
    var lines = std.mem.splitAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        if (std.mem.eql(u8, line.?, "")) {
            if (calories > max_calories) {
                max_calories = calories;
            }
            calories = 0;
            continue;
        }
        calories += try std.fmt.parseInt(u32, line.?, 10);
    }
    return max_calories;
}

test "Part 1 is correct" {
    const expected: u32 = 24000;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
