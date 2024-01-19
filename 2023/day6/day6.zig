const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    print("Part 1: {}\n", .{try part1(input)});
    print("Part 2: {}\n", .{try part2(input)});
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

fn part2(in: []const u8) !usize {
    var area = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = area.allocator();

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    const time_line = lines.next().?;
    const distance_line = lines.next().?;

    var times = time_line[(std.mem.indexOf(u8, time_line, ":").? + 1)..];
    var distances = distance_line[(std.mem.indexOf(u8, distance_line, ":").? + 1)..];

    const replaced_time_size = std.mem.replacementSize(u8, times, " ", "");
    const replaced_distance_size = std.mem.replacementSize(u8, distances, " ", "");

    var replaced_time = try allocator.alloc(u8, replaced_time_size);
    var replaced_distance = try allocator.alloc(u8, replaced_distance_size);

    _ = std.mem.replace(u8, times, " ", "", replaced_time);
    _ = std.mem.replace(u8, distances, " ", "", replaced_distance);

    var time = try std.fmt.parseInt(usize, replaced_time, 10);
    var distance = try std.fmt.parseInt(usize, replaced_distance, 10);

    var possibilities: usize = 0;
    var time_pressed: usize = 1;
    while (time_pressed < time) : (time_pressed += 1) {
        if (time_pressed * (time - time_pressed) > distance) {
            possibilities += 1;
        }
    }
    return possibilities;
}

test "Part 1" {
    const expected: usize = 288;
    const actual = try part1(test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2" {
    const expected: usize = 71503;
    const actual = try part2(test_input);
    try std.testing.expectEqual(expected, actual);
}
