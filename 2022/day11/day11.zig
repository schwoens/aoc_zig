const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() void {}

fn part1(comptime len: usize, in: *const [len:0]u8) !usize {
    var segments = std.mem.tokenizeAny(u8, in, ":\n");
    var segment = segments.next();
    while (segment != null) : (segment = segments.next()) {
        const seg = std.mem.trim(u8, segment.?, " ");
        print("{s}\n!!!\n", .{seg});
    }
    return 0;
}

test "Part 1" {
    const expected: usize = 10605;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
