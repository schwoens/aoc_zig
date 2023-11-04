const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    print("Part 1: {}\n", .{try part1(input.len, input)});
    print("Part 2:\n", .{});
    try part2(input.len, input);
}

fn part1(comptime len: usize, in: *const [len:0]u8) !isize {
    var clock: isize = 0;
    var x: isize = 1;
    var strength_sum: isize = 0;

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        var split = std.mem.tokenizeAny(u8, line.?, " ");
        const command = split.next().?;
        const value = split.next();

        switch (std.meta.stringToEnum(Command, command).?) {
            .addx => {
                for (0..2) |_| {
                    clock += 1;
                    for (0..6) |i| {
                        if (clock == 20 + i * 40) {
                            strength_sum += x * clock;
                        }
                    }
                }
                x += try std.fmt.parseInt(isize, value.?, 10);
            },
            .noop => {
                clock += 1;
                for (0..6) |i| {
                    if (clock == 20 + i * 40) {
                        strength_sum += x * clock;
                    }
                }
            },
        }
    }
    return strength_sum;
}

fn part2(comptime len: usize, in: *const [len:0]u8) !void {
    var clock: usize = 0;
    var x: isize = 1;

    var screen = [_]bool{false} ** (40 * 6);

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        var split = std.mem.tokenizeAny(u8, line.?, " ");
        const command = split.next().?;
        const value = split.next();

        switch (std.meta.stringToEnum(Command, command).?) {
            .addx => {
                for (0..2) |_| {
                    draw_pixel(&screen, clock, x);
                    clock += 1;
                }
                x += try std.fmt.parseInt(isize, value.?, 10);
            },
            .noop => {
                draw_pixel(&screen, clock, x);
                clock += 1;
            },
        }
    }
    print_screen(&screen);
}

fn draw_pixel(screen: *[40 * 6]bool, clock: usize, x: isize) void {
    const sprite_pos = x;
    var draw_pos = clock;

    while (draw_pos >= 40) {
        draw_pos -= 40;
    }

    if (draw_pos >= sprite_pos - 1 and draw_pos <= sprite_pos + 1) {
        screen[clock] = true;
    }
}

fn print_screen(screen: *[40 * 6]bool) void {
    for (0..6) |row| {
        for (0..40) |col| {
            const i = col + row * 40;
            if (screen[i]) print("#", .{}) else print(".", .{});
        }
        print("\n", .{});
    }
}

const Command = enum {
    addx,
    noop,
};

test "Part 1" {
    const expected: isize = 13140;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
