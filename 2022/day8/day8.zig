const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});
    const part2_res = try part2(input.len, input);
    print("Part 2: {}\n", .{part2_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var grid: std.ArrayList(std.ArrayList(u8)) = std.ArrayList(std.ArrayList(u8)).init(allocator);
    defer {
        for (grid.items) |list| {
            list.deinit();
        }
        grid.deinit();
    }

    try grid.append(std.ArrayList(u8).init(allocator));
    const trimmed_in = std.mem.trim(u8, in, "\n");
    for (trimmed_in) |char| {
        if (char == '\n') {
            try grid.append(std.ArrayList(u8).init(allocator));
            continue;
        }
        try grid.items[grid.items.len - 1].append(try std.fmt.charToDigit(char, 10));
    }

    var visible_count: usize = 0;
    for (0..grid.items.len) |y| {
        for (0..grid.items[y].items.len) |x| {
            visible_count += if (isVisible(x, y, &grid)) 1 else 0;
        }
    }
    return visible_count;
}

fn part2(comptime len: usize, in: *const [len:0]u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var grid: std.ArrayList(std.ArrayList(u8)) = std.ArrayList(std.ArrayList(u8)).init(allocator);
    defer {
        for (grid.items) |list| {
            list.deinit();
        }
        grid.deinit();
    }

    try grid.append(std.ArrayList(u8).init(allocator));
    const trimmed_in = std.mem.trim(u8, in, "\n");
    for (trimmed_in) |char| {
        if (char == '\n') {
            try grid.append(std.ArrayList(u8).init(allocator));
            continue;
        }
        try grid.items[grid.items.len - 1].append(try std.fmt.charToDigit(char, 10));
    }

    var max_score: usize = 0;
    for (0..grid.items.len) |y| {
        for (0..grid.items[y].items.len) |x| {
            const score = getScenicScore(x, y, &grid);
            if (score > max_score) {
                max_score = score;
            }
        }
    }
    return max_score;
}

fn isVisible(x: usize, y: usize, grid: *std.ArrayList(std.ArrayList(u8))) bool {
    const height = grid.items[y].items[x];
    var north = true;
    for (0..y) |yi| {
        if (grid.items[yi].items[x] >= height) {
            north = false;
        }
    }
    var south = true;
    for (y + 1..grid.items.len) |yi| {
        if (grid.items[yi].items[x] >= height) {
            south = false;
        }
    }
    var west = true;
    for (0..x) |xi| {
        if (grid.items[y].items[xi] >= height) {
            west = false;
        }
    }
    var east = true;
    for (x + 1..grid.items[y].items.len) |xi| {
        if (grid.items[y].items[xi] >= height) {
            east = false;
        }
    }
    return north or south or west or east;
}

fn getScenicScore(x: usize, y: usize, grid: *std.ArrayList(std.ArrayList(u8))) usize {
    if (x == 0 or y == 0 or x == grid.items[y].items.len - 1 or y == grid.items.len - 1) {
        return 0;
    }
    const height = grid.items[y].items[x];
    var north: usize = 0;
    var i: usize = y - 1;
    while (i > 0) : (i -= 1) {
        north += 1;
        if (grid.items[i].items[x] >= height) {
            break;
        }
        if (i <= 1) {
            north += 1;
            break;
        }
    }
    var south: usize = 0;
    i = y + 1;
    while (i < grid.items.len) : (i += 1) {
        south += 1;
        if (grid.items[i].items[x] >= height) {
            break;
        }
    }
    var west: usize = 0;
    i = x - 1;
    while (i > 0) : (i -= 1) {
        west += 1;
        if (grid.items[y].items[i] >= height) {
            break;
        }
        if (i <= 1) {
            west += 1;
            break;
        }
    }
    var east: usize = 0;
    i = x + 1;
    while (i < grid.items[y].items.len) : (i += 1) {
        east += 1;
        if (grid.items[y].items[i] >= height) {
            break;
        }
    }
    return north * south * west * east;
}

test "Part 1" {
    const expected: usize = 21;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2" {
    const expected: usize = 8;
    const actual = try part2(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
