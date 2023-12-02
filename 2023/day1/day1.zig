const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");
const test_input2 = @embedFile("test_input2.txt");

pub fn main() void {
    print("Part 1: {}\n", .{part1(input)});
    print("Part 2: {}\n", .{part2(input)});
}

fn part1(in: []const u8) usize {
    var sum: usize = 0;
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    while (lines.next()) |line| {
        const first_digit = line[std.mem.indexOfAny(u8, line, "123456789").?];
        const last_digit = line[std.mem.lastIndexOfAny(u8, line, "123456789").?];

        const string = [_]u8{ first_digit, last_digit };
        const value = std.fmt.parseInt(usize, &string, 10) catch unreachable;
        sum += value;
    }
    return sum;
}

fn part2(in: []const u8) usize {
    var sum: usize = 0;
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    while (lines.next()) |line| {
        const first_digit_index = std.mem.indexOfAny(u8, line, "123456789");
        const first_digit_value: ?usize = if (first_digit_index) |index| line[index] - '0' else null;

        const words = [_][]const u8{ "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
        var first_word_index: ?usize = null;
        var first_word_value: ?usize = null;
        for (words, 1..) |word, value| {
            if (std.mem.indexOf(u8, line, word)) |index| {
                if (first_word_index == null or index < first_word_index.?) {
                    first_word_index = index;
                    first_word_value = value;
                }
            }
        }

        const first: usize = if (first_digit_index == null)
            first_word_value.?
        else if (first_word_index == null)
            first_digit_value.?
        else if (first_digit_index.? < first_word_index.?)
            first_digit_value.?
        else
            first_word_value.?;

        const last_digit_index: ?usize = std.mem.lastIndexOfAny(u8, line, "123456789");
        const last_digit_value: ?usize = if (last_digit_index) |index| line[index] - '0' else null;

        var last_word_index: ?usize = null;
        var last_word_value: ?usize = null;
        for (words, 1..) |word, value| {
            if (std.mem.lastIndexOf(u8, line, word)) |index| {
                if (last_word_index == null or index > last_word_index.?) {
                    last_word_index = index;
                    last_word_value = value;
                }
            }
        }

        const last: usize = if (last_digit_index == null)
            last_word_value.?
        else if (last_word_index == null)
            last_digit_value.?
        else if (last_digit_index.? > last_word_index.?)
            last_digit_value.?
        else
            last_word_value.?;

        sum += first * 10 + last;
    }
    return sum;
}

test "Part 1" {
    const expected: usize = 142;
    const actual = part1(test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2" {
    const expected: usize = 281;
    const actual = part2(test_input2);
    try std.testing.expectEqual(expected, actual);
}
