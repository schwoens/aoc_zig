const std = @import("std");
const puzzle_input = @embedFile("puzzle_input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() void {
    std.debug.print("Part 1: {}", .{part1(puzzle_input)});
}

fn part1(in: []const u8) usize {
    var safe_level_sum: usize = 0;
    var levels = std.mem.tokenizeAny(u8, in, "\n");
    while (levels.next()) |level| {
        if (is_safe(level)) safe_level_sum += 1;
    }
    return safe_level_sum;
}

fn is_safe(level: []const u8) bool {
    var previous_height: ?usize = null;
    var slope: ?Slope = null;
    var heights = std.mem.tokenizeAny(u8, level, " ");
    while (heights.next()) |height_string| {
        const height = std.fmt.parseInt(usize, height_string, 10) catch unreachable;
        if (previous_height == null) {
            previous_height = height;
            continue;
        }
        if (slope == null) {
            if (previous_height orelse unreachable < height) slope = Slope.upward;
            if (previous_height orelse unreachable > height) slope = Slope.downward;
            if (previous_height orelse unreachable == height) return false;
        }
        switch (slope orelse unreachable) {
            .downward => {
                if (previous_height orelse unreachable < height) return false;
                const delta = @abs((previous_height orelse unreachable) - height);
                if (delta < 1 or delta > 3) return false;
            },
            .upward => {
                if (previous_height orelse unreachable > height) return false;
                const delta = @abs(height - (previous_height orelse unreachable));
                if (delta < 1 or delta > 3) return false;
            },
        }
        previous_height = height;
    }
    return true;
}

const Slope = enum { downward, upward };

test "Part 1" {
    const expected: usize = 2;
    const actual = part1(test_input);
    try std.testing.expectEqual(expected, actual);
}
