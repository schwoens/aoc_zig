const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    print("Part 1: {}\n", .{try part1(input)});
    print("Part 2: {}\n", .{try part2(input)});
}

fn part1(in: []const u8) !usize {
    var sum: usize = 0;
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var above: ?[]const u8 = null;
    var line = lines.next();
    var below = lines.next();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    var digits = std.ArrayList(u8).init(allocator);
    defer digits.deinit();
    var indicies = std.ArrayList(usize).init(allocator);
    defer indicies.deinit();

    while (line != null) {
        var i: usize = 0;
        while (i < line.?.len) : (i += 1) {
            while (std.ascii.isDigit(line.?[i])) : (i += 1) {
                try digits.append(line.?[i]);
                try indicies.append(i);
                if (i == line.?.len - 1) break;
            }
            if (digits.items.len == 0) continue;
            const number = try digits.toOwnedSlice();
            for (indicies.items) |index| {
                if (isAdjacentToSymbol(line.?, above, below, index)) {
                    sum += try std.fmt.parseInt(usize, number, 10);
                    break;
                }
            }
            indicies.clearAndFree();
        }
        above = line;
        line = below;
        below = lines.next();
    }
    return sum;
}

fn part2(in: []const u8) !usize {
    var sum: usize = 0;
    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var above: ?[]const u8 = null;
    var line = lines.next();
    var below = lines.next();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    while (line != null) {
        var i: usize = 0;
        while (i < line.?.len) : (i += 1) {
            if (line.?[i] == '*') {
                const nums = try getAdjacentNumbers(.{ above, line, below }, i, allocator);
                if (nums.len == 2) {
                    sum += nums[0] * nums[1];
                }
            }
        }
        above = line;
        line = below;
        below = lines.next();
    }
    return sum;
}

fn getAdjacentNumbers(lines: [3]?[]const u8, i: usize, allocator: std.mem.Allocator) ![]usize {
    var numbers = std.ArrayList(usize).init(allocator);
    defer numbers.deinit();

    var digits = std.ArrayList(u8).init(allocator);
    defer digits.deinit();

    var x: isize = -1;
    while (x < 2) : (x += 1) {
        for (lines) |line| {
            if (line != null) {
                const ii: isize = @intCast(i);
                var index: usize = @intCast(ii + x);
                while (std.ascii.isDigit(line.?[index])) : (index -= 1) {
                    try digits.insert(0, line.?[index]);
                    if (index == 0) break;
                }
                index = @intCast(ii + x);
                while (std.ascii.isDigit(line.?[index])) : (index += 1) {
                    if (index == ii + x) continue;
                    try digits.append(line.?[index]);
                    if (index == line.?.len - 1) break;
                }

                if (digits.items.len < 1) {
                    continue;
                }
                const slice = try digits.toOwnedSlice();
                const num = try std.fmt.parseInt(usize, slice, 10);
                for (numbers.items) |number| {
                    if (number == num) break;
                } else {
                    try numbers.append(num);
                }
            }
        }
    }
    return numbers.toOwnedSlice();
}

fn isSymbol(c: u8) bool {
    return c != '.' and !std.ascii.isDigit(c);
}

fn isAdjacentToSymbol(line: []const u8, above: ?[]const u8, below: ?[]const u8, i: usize) bool {
    var adjacent = i > 0 and isSymbol(line[i - 1]) or i < line.len - 1 and isSymbol(line[i + 1]);
    if (above != null) {
        if (i > 0 and isSymbol(above.?[i - 1]) or isSymbol(above.?[i]) or i < above.?.len - 1 and isSymbol(above.?[i + 1])) {
            adjacent = true;
        }
    }
    if (below != null) {
        if (i > 0 and isSymbol(below.?[i - 1]) or isSymbol(below.?[i]) or i < below.?.len - 1 and isSymbol(below.?[i + 1])) {
            adjacent = true;
        }
    }
    return adjacent;
}

test "Part 1" {
    const expected: usize = 4361;
    const actual = try part1(test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2" {
    const expected: usize = 467835;
    const actual = try part2(test_input);
    try std.testing.expectEqual(expected, actual);
}
