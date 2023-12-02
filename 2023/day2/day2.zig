const std = @import("std");
const print = std.debug.print;
const indexOf = std.mem.indexOf;
const parseInt = std.fmt.parseInt;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() void {
    print("Part 1: {}\n", .{part1(input.len, input)});
    print("Part 2: {}\n", .{part2(input.len, input)});
}

fn part1(comptime len: usize, in: *const [len:0]u8) usize {
    var id_sum: usize = 0;

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    while (lines.next()) |line| {
        const colon_index = indexOf(u8, line, ":").?;
        const id = parseInt(usize, line[5..colon_index], 10) catch unreachable;
        var cubes = std.mem.tokenizeAny(u8, line[colon_index + 1 ..], ",;");
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

fn part2(comptime len: usize, in: *const [len:0]u8) usize {
    var power_sum: usize = 0;

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    while (lines.next()) |line| {
        var required_cubes = [_]usize{ 0, 0, 0 };
        const colon_index = indexOf(u8, line, ":").?;
        var cubes = std.mem.tokenizeAny(u8, line[colon_index + 1 ..], ",;");
        while (cubes.next()) |cube| {
            var cube_split = std.mem.tokenizeAny(u8, cube, " ");
            const amount = parseInt(usize, cube_split.next().?, 10) catch unreachable;
            const color = std.meta.stringToEnum(Color, cube_split.next().?).?;

            const arr_index = @intFromEnum(color);
            if (amount > required_cubes[arr_index]) {
                required_cubes[arr_index] = amount;
            }
        }
        power_sum += required_cubes[0] * required_cubes[1] * required_cubes[2];
    }
    return power_sum;
}

const Color = enum(usize) {
    red,
    green,
    blue,
};

test "Part 1" {
    const expected: usize = 8;
    const actual = part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2" {
    const expected: usize = 2286;
    const actual = part2(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
