const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});
    const part2_res = try part2(input.len, input);
    print("Part 2: {}\n", .{part2_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !u32 {
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    var score: u32 = 0;
    while (line != null) : (line = lines.next()) {
        const opponent = line.?[0];
        const me = line.?[2];

        // A, X - rock
        // B, Y - paper
        // C, Z - scissors

        score += switch (opponent) {
            'A' => switch (me) {
                'X' => 4,
                'Y' => 8,
                'Z' => 3,
                else => unreachable,
            },
            'B' => switch (me) {
                'X' => 1,
                'Y' => 5,
                'Z' => 9,
                else => unreachable,
            },
            'C' => switch (me) {
                'X' => 7,
                'Y' => 2,
                'Z' => 6,
                else => unreachable,
            },
            else => unreachable,
        };
    }
    return score;
}

fn part2(comptime len: usize, in: *const [len:0]u8) !u32 {
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    var score: u32 = 0;
    while (line != null) : (line = lines.next()) {
        const opponent = line.?[0];
        const outcome = line.?[2];

        // A - rock
        // B - paper
        // C - scissors
        // X - lose
        // Y - draw
        // Z - win

        score += switch (opponent) {
            'A' => switch (outcome) {
                'X' => 3,
                'Y' => 4,
                'Z' => 8,
                else => unreachable,
            },
            'B' => switch (outcome) {
                'X' => 1,
                'Y' => 5,
                'Z' => 9,
                else => unreachable,
            },
            'C' => switch (outcome) {
                'X' => 2,
                'Y' => 6,
                'Z' => 7,
                else => unreachable,
            },
            else => unreachable,
        };
    }
    return score;
}

test "Part 1 is correct" {
    const expected: u32 = 15;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2 is correct" {
    const expected: u32 = 12;
    const actual = try part2(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
