const std = @import("std");
const print = std.debug.print;

const test_input = @embedFile("test_input.txt");
const input = @embedFile("input.txt");

pub fn main() void {
    const part1_res = part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});
    const part2_res = part2(input.len, input);
    print("Part 2: {}\n", .{part2_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) u32 {
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    var prio_sum: u32 = 0;
    while (line != null) : (line = lines.next()) {
        const compartment1 = line.?[0 .. line.?.len / 2];
        const compartment2 = line.?[line.?.len / 2 ..];

        const item: u8 = label: for (compartment1) |item1| {
            for (compartment2) |item2| {
                if (item1 == item2) {
                    break :label item1;
                }
            }
        } else unreachable;

        prio_sum += if (std.ascii.isLower(item)) item - 96 else item - 38;
    }
    return prio_sum;
}

fn part2(comptime len: usize, in: *const [len:0]u8) u32 {
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    var group = [3][]const u8{ "", "", "" };
    var prio_sum: u32 = 0;
    while (line != null) {
        for (0..3) |i| {
            group[i] = line.?;
            line = lines.next();
        }
        const item = label: for (group[0]) |c1| {
            for (group[1]) |c2| {
                for (group[2]) |c3| {
                    if (c1 == c2 and c2 == c3) break :label c1;
                }
            }
        } else unreachable;
        prio_sum += if (std.ascii.isLower(item)) item - 96 else item - 38;
    }
    return prio_sum;
}

test "Part 1" {
    const expected: u32 = 157;
    const actual: u32 = part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2" {
    const expected: u32 = 70;
    const actual: u32 = part2(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
