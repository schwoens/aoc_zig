const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    print("Part 1: {}\n", .{try part1(input)});
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
