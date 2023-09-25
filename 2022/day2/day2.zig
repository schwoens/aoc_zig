const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !u32 {
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    var score: u32 = 0;
    while (line != null) : (line = lines.next()) {
        const opponent = line.?[0];
        const me = line.?[2];

        score += switch (opponent) {
            'A' => switch (me) {
                'X' => 4,
                'Y' => 8,
                'Z' => 3,
                else => 0,
            },
            'B' => switch (me) {
                'X' => 1,
                'Y' => 5,
                'Z' => 9,
                else => 0,
            },
            'C' => switch (me) {
                'X' => 7,
                'Y' => 2,
                'Z' => 6,
                else => 0,
            },
            else => 0,
        };
    }
    return score;
}

test "Part 1 is correct" {
    const expected: u32 = 15;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
