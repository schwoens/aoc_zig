const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});

    const part2_res = try part2(input.len, input);
    print("Part 2: {}\n", .{part2_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !u32 {
    var max_calories: u32 = 0;
    var calories: u32 = 0;
    var lines = std.mem.splitAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        if (std.mem.eql(u8, line.?, "")) {
            if (calories > max_calories) {
                max_calories = calories;
            }
            calories = 0;
            continue;
        }
        calories += try std.fmt.parseInt(u32, line.?, 10);
    }
    return max_calories;
}

fn part2(comptime len: usize, in: *const [len:0]u8) !u32 {
    var max_calories = [_]u32{0} ** 3;
    var calories: u32 = 0;
    var lines = std.mem.splitAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        if (std.mem.eql(u8, line.?, "")) {
            for (0..max_calories.len) |i| {
                if (max_calories[i] < calories) {
                    var j: usize = max_calories.len - 1;
                    while (j > i) : (j -= 1) {
                        max_calories[j] = max_calories[j - 1];
                    }
                    max_calories[i] = calories;
                    break;
                }
            }
            calories = 0;
            continue;
        }
        calories += try std.fmt.parseInt(u32, line.?, 10);
    }
    var total_max_calories: u32 = 0;
    for (max_calories) |cals| {
        total_max_calories += cals;
    }
    return total_max_calories;
}

test "Part 1 is correct" {
    const expected: u32 = 24000;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2 is correct" {
    const expected: u32 = 45000;
    const actual = try part2(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
