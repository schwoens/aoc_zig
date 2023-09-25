const std = @import("std");
const print = std.debug.print;

const test_input = @embedFile("test_input.txt");
const input = @embedFile("input.txt");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !u32 {
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    var count: u32 = 0;
    while (line != null) : (line = lines.next()) {
        var pair = std.mem.splitAny(u8, line.?, ",");
        var range1 = [_]u8{0} ** 2;
        var range2 = [_]u8{0} ** 2;

        var range1_it = std.mem.splitAny(u8, pair.next().?, "-");
        var range2_it = std.mem.splitAny(u8, pair.next().?, "-");

        range1[0] = try std.fmt.parseInt(u8, range1_it.next().?, 10);
        range1[1] = try std.fmt.parseInt(u8, range1_it.next().?, 10);
        range2[0] = try std.fmt.parseInt(u8, range2_it.next().?, 10);
        range2[1] = try std.fmt.parseInt(u8, range2_it.next().?, 10);

        const range1_in_range2 = range1[0] >= range2[0] and range1[1] <= range2[1];
        const range2_in_range1 = range2[0] >= range1[0] and range2[1] <= range1[1];

        if (range1_in_range2 or range2_in_range1) {
            count += 1;
        }
    }
    return count;
}

test "Part 1" {
    const expected: u32 = 2;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
