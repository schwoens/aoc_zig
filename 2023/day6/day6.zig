const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    print("Part 1: {}", .{try part1(input)});
}

fn part1(in: []const u8) !usize {
    var product: usize = 1;

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    const time_line = lines.next().?;
    const distance_line = lines.next().?;

    var times = std.mem.tokenizeAny(u8, time_line[(std.mem.indexOf(u8, time_line, ":").? + 1)..], " ");
    var distances = std.mem.tokenizeAny(u8, distance_line[(std.mem.indexOf(u8, distance_line, ":").? + 1)..], " ");

    while (times.next()) |time_string| {
        const time = try std.fmt.parseInt(usize, time_string, 10);
        const distance = try std.fmt.parseInt(usize, distances.next().?, 10);

        var possibilities: usize = 0;
        var time_pressed: usize = 1;
        while (time_pressed < time) : (time_pressed += 1) {
            if (time_pressed * (time - time_pressed) > distance) {
                possibilities += 1;
            }
        }
        product *= possibilities;
    }
    return product;
}

test "Part 1" {
    const expected: usize = 288;
    const actual = try part1(test_input);
    try std.testing.expectEqual(expected, actual);
}
