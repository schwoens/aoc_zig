const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {}

fn part1(comptime len: usize, in: *const [len:0]u8) usize {
    var head = .{ 0, 0 };
    var tail = .{ 0, 0 };

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        var split = std.mem.tokenizeAny(u8, line, " ");

        const dir = split.next().?[0];
        const steps = try std.fmt.parseInt(split.next().?, 10);

        for (0..steps) |i| {
            _ = i;
            switch (dir) {
                'R' => head[0] += 1,
                'D' => head[1] += 1,
                'L' => head[0] -= 1,
                'U' => head[1] -= 1,
            }

            if (!isTouching(&head, &tail)) {
                switch (dir) {
                    'R' => tail[0] += 1,
                    'D' => tail[1] += 1,
                    'L' => tail[0] -= 1,
                    'U' => tail[1] -= 1,
                }
            }
        }
    }
}

fn isTouching(head: *struct { isize, isize }, tail: *struct { isize, isize }) bool {
    for (-1..2) |y| {
        for (-1..2) |x| {
            if (head[0] + x == tail[0] and head[1] + y == tail[1]) {
                return true;
            }
        }
    }
    return false;
}
