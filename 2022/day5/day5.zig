const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {s}\n", .{part1_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) ![9:0]u8 {
    var file = std.mem.tokenizeSequence(u8, in, "\n\n");

    var stack_lines = std.mem.tokenizeAny(u8, file.next().?, "\n");
    var instruction_lines = std.mem.tokenizeAny(u8, file.next().?, "\n");

    // initialize stacks
    var stacks = [_]std.ArrayList(u8){undefined} ** 9;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    for (0..stacks.len) |i| {
        stacks[i] = std.ArrayList(u8).init(allocator);
    }

    defer for (stacks) |stack| {
        stack.deinit();
    };

    // fill stacks with initial state

    var stack_line = stack_lines.next();
    while (stack_line != null) : (stack_line = stack_lines.next()) {
        var i: usize = 0;
        while (i + 1 + i * 3 < stack_line.?.len) : (i += 1) {
            const label = stack_line.?[i + 1 + i * 3];
            if (std.ascii.isAlphabetic(label)) {
                try stacks[i].insert(0, label);
            }
        }
    }

    // compute the instructions

    var instruction = instruction_lines.next();
    while (instruction != null) : (instruction = instruction_lines.next()) {
        var instr_parts = std.mem.tokenizeAny(u8, instruction.?, " ");
        _ = instr_parts.next();
        const amount = try std.fmt.parseInt(usize, instr_parts.next().?, 10);
        _ = instr_parts.next();
        const from = try std.fmt.parseInt(usize, instr_parts.next().?, 10);
        _ = instr_parts.next();
        const to = try std.fmt.parseInt(usize, instr_parts.next().?, 10);

        for (0..amount) |_| {
            if (stacks[from - 1].getLastOrNull() != null) {
                try stacks[to - 1].append(stacks[from - 1].pop());
            }
        }
    }

    // read top labels from left to right

    var result = [_:0]u8{0} ** 9;

    outer: for (0..stacks.len) |i| {
        if (stacks[i].items.len < 1) {
            break :outer;
        }
        var top = stacks[i].pop();
        while (top == 0) : (top = stacks[i].pop()) {}
        result[i] = top;
    }

    return result;
}

test "Part 1" {
    const expected: [9:0]u8 = .{ 'C', 'M', 'Z' } ++ .{0} ** 6;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqualStrings(&expected, &actual);
}
