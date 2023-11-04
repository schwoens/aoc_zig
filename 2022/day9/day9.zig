const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");
const test_input2 = @embedFile("test_input2.txt");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {}\n", .{part1_res});

    const part2_res = try part2(input.len, input);
    print("Part 2: {}\n", .{part2_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !usize {
    var head: struct { isize, isize } = .{ 0, 0 };
    var tail: struct { isize, isize } = .{ 0, 0 };

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var tail_memory = std.AutoHashMap(struct { isize, isize }, void).init(allocator);
    defer tail_memory.deinit();

    try tail_memory.put(tail, {});

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        var split = std.mem.tokenizeAny(u8, line.?, " ");

        const dir = split.next().?[0];
        const steps = try std.fmt.parseInt(usize, split.next().?, 10);

        for (0..steps) |i| {
            _ = i;
            switch (dir) {
                'R' => head[0] += 1,
                'D' => head[1] += 1,
                'L' => head[0] -= 1,
                'U' => head[1] -= 1,
                else => unreachable,
            }

            if (!isTouching(&head, &tail)) {
                switch (dir) {
                    'R' => tail[0] += 1,
                    'D' => tail[1] += 1,
                    'L' => tail[0] -= 1,
                    'U' => tail[1] -= 1,
                    else => unreachable,
                }
                switch (dir) {
                    'R', 'L' => tail[1] = head[1],
                    'D', 'U' => tail[0] = head[0],
                    else => unreachable,
                }
                try tail_memory.put(tail, {});
            }
        }
    }
    return tail_memory.count();
}

fn part2(comptime len: usize, in: *const [len:0]u8) !usize {
    var rope = [_]struct { isize, isize }{.{ 0, 0 }} ** 10;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var tail_memory = std.AutoHashMap(struct { isize, isize }, void).init(allocator);
    defer tail_memory.deinit();

    try tail_memory.put(rope[9], {});

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        var split = std.mem.tokenizeAny(u8, line.?, " ");

        const dir = split.next().?[0];
        const steps = try std.fmt.parseInt(usize, split.next().?, 10);

        for (0..steps) |i| {
            _ = i;
            switch (dir) {
                'R' => rope[0][0] += 1,
                'D' => rope[0][1] += 1,
                'L' => rope[0][0] -= 1,
                'U' => rope[0][1] -= 1,
                else => unreachable,
            }

            for (1..10) |knot| {
                if (!isTouching(&rope[knot - 1], &rope[knot])) {
                    var dx = rope[knot - 1][0] - rope[knot][0];
                    var dy = rope[knot - 1][1] - rope[knot][1];

                    rope[knot][0] += std.math.sign(dx);
                    rope[knot][1] += std.math.sign(dy);

                    try tail_memory.put(rope[9], {});
                }
            }
        }
    }
    return tail_memory.count();
}
fn isTouching(head: *struct { isize, isize }, tail: *struct { isize, isize }) bool {
    var y: isize = -1;
    var x: isize = -1;
    while (y < 2) : (y += 1) {
        x = -1;
        while (x < 2) : (x += 1) {
            if (head[0] + x == tail[0] and head[1] + y == tail[1]) {
                return true;
            }
        }
    }
    return false;
}

test "isTouching" {
    var head: struct { isize, isize } = .{ 1, 0 };
    var tail: struct { isize, isize } = .{ 0, 0 };
    try std.testing.expect(isTouching(&head, &tail));
}

test "Part 1" {
    const expected: usize = 13;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2.1" {
    var expected: usize = 1;
    var actual = try part2(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}

test "Part 2.2" {
    var expected: usize = 36;
    var actual = try part2(test_input2.len, test_input2);
    try std.testing.expectEqual(expected, actual);
}
