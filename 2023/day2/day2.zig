const std = @import("std");
const print = std.debug.print;
const indexOf = std.mem.indexOf;
const parseInt = std.fmt.parseInt;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() void {
    print("Part 1: {}\n", .{part1(input.len, input)});
}

fn part1(comptime len: usize, in: *const [len:0]u8) usize {
    var id_sum: usize = 0;

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    while (lines.next()) |line| {
        const collon_index = indexOf(u8, line, ":").?;
        const id = parseInt(usize, line[5..collon_index], 10) catch unreachable;
        var cubes = std.mem.tokenizeAny(u8, line[collon_index + 1 ..], ",;");
        while (cubes.next()) |cube| {
            var cube_split = std.mem.tokenizeAny(u8, cube, " ");
            const amount = parseInt(usize, cube_split.next().?, 10) catch unreachable;
            const color = std.meta.stringToEnum(Color, cube_split.next().?).?;

            const allowed_amount: usize = switch (color) {
                .red => 12,
                .green => 13,
                .blue => 14,
            };
            if (amount > allowed_amount) break;
        } else {
            id_sum += id;
        }
    }
    return id_sum;
}

const Color = enum {
    red,
    green,
    blue,
};

test "Part 1" {
    const expected: usize = 8;
    const actual = part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
