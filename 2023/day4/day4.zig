const std = @import("std");
const print = std.debug.print;
const tokenizeAny = std.mem.tokenizeAny;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    print("Part 1: {}\n", .{try part1(input)});
    print("Part 2: {}\n", .{try part2(input)});
}

fn part1(in: []const u8) !usize {
    var total_value: usize = 0;
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var lines = tokenizeAny(u8, in, "\n");
    while (lines.next()) |line| {
        var value: usize = 0;

        const colon_index = std.mem.indexOf(u8, line, ":").?;
        const pipe_index = std.mem.indexOf(u8, line, "|").?;

        var winning_nums = std.AutoHashMap(usize, void).init(allocator);
        defer winning_nums.deinit();
        var winning_nums_iter = tokenizeAny(u8, line[colon_index + 1 .. pipe_index], " ");
        while (winning_nums_iter.next()) |num| {
            try winning_nums.put(try std.fmt.parseInt(usize, num, 10), {});
        }

        var nums = std.ArrayList(usize).init(allocator);
        defer nums.deinit();
        var nums_iter = tokenizeAny(u8, line[pipe_index + 1 ..], " ");
        while (nums_iter.next()) |num| {
            try nums.append(try std.fmt.parseInt(usize, num, 10));
        }

        for (nums.items) |num| {
            if (winning_nums.contains(num)) {
                if (value == 0) {
                    value = 1;
                } else {
                    value *= 2;
                }
            }
        }
        total_value += value;
    }
    return total_value;
}

fn part2(in: []const u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var card_amount: usize = 0;
    var cards = std.AutoHashMap(usize, usize).init(allocator);
    defer cards.deinit();

    var winning_cards_memory = std.AutoHashMap(usize, usize).init(allocator);
    defer winning_cards_memory.deinit();

    var lines = tokenizeAny(u8, in, "\n");
    while (lines.next()) |line| {
        const space_index = std.mem.indexOf(u8, line, " ").?;
        const colon_index = std.mem.indexOf(u8, line, ":").?;
        const pipe_index = std.mem.indexOf(u8, line, "|").?;

        const card_number = try std.fmt.parseInt(usize, std.mem.trim(u8, line[space_index + 1 .. colon_index], " "), 10);

        card_amount += 1;
        if (cards.get(card_number)) |val| {
            try cards.put(card_number, val + 1);
        } else {
            try cards.put(card_number, 1);
        }

        var card_countdown: ?usize = cards.get(card_number);
        while (card_countdown != null and card_countdown.? > 0) : (card_countdown.? -= 1) {
            var winning_nums = std.AutoHashMap(usize, void).init(allocator);
            defer winning_nums.deinit();
            var winning_nums_iter = tokenizeAny(u8, line[colon_index + 1 .. pipe_index], " ");
            while (winning_nums_iter.next()) |num| {
                try winning_nums.put(try std.fmt.parseInt(usize, num, 10), {});
            }

            var nums = std.ArrayList(usize).init(allocator);
            defer nums.deinit();
            var nums_iter = tokenizeAny(u8, line[pipe_index + 1 ..], " ");
            while (nums_iter.next()) |num| {
                try nums.append(try std.fmt.parseInt(usize, num, 10));
            }

            if (winning_cards_memory.get(card_number)) |v| {
                var val: usize = v;
                while (val > 0) : (val -= 1) {
                    card_amount += 1;
                    try cards.put(card_number + val, cards.get(card_number + val).? + 1);
                }
                continue;
            }

            var winning_cards: usize = 0;
            for (nums.items) |num| {
                if (winning_nums.contains(num)) {
                    winning_cards += 1;
                    card_amount += 1;
                    if (cards.get(card_number + winning_cards)) |val| {
                        try cards.put(card_number + winning_cards, val + 1);
                    } else {
                        try cards.put(card_number + winning_cards, 1);
                    }
                }
            }
            try winning_cards_memory.put(card_number, winning_cards);
        }
    }
    return card_amount;
}

test "Part 1" {
    const expected: usize = 13;
    const actual = try part1(test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2" {
    const expected: usize = 30;
    const actual = try part2(test_input);
    try std.testing.expectEqual(expected, actual);
}
