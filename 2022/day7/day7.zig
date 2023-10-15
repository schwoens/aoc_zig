const std = @import("std");
const print = std.debug.print;

const input = @embedFile("input.txt");
const test_input = @embedFile("test_input.txt");

pub fn main() !void {
    const part1_res = try part1(input.len, input);
    print("Part 1: {}", .{part1_res});
}

fn part1(comptime len: usize, in: *const [len:0]u8) !usize {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var root = Directory.init(null, allocator);
    defer root.deinit();

    var current_dir: *Directory = &root;

    var lines = std.mem.tokenizeAny(u8, in, "\n");
    var line = lines.next();
    while (line != null) : (line = lines.next()) {
        var words = std.mem.tokenizeAny(u8, line.?, " ");

        const parts = .{ words.next(), words.next(), words.next() };

        if (std.mem.eql(u8, parts[0].?, "$")) {
            // is command
            // ignore everything but cd
            if (!std.mem.eql(u8, parts[1].?, "cd")) continue;
            const new_dir_label = parts[2].?;
            // ignore root
            if (std.mem.eql(u8, new_dir_label, "/")) continue;
            // cd ..
            if (std.mem.eql(u8, new_dir_label, "..")) {
                current_dir = current_dir.parent.?;
                continue;
            }
            // cd [name]
            var new_dir = Directory.init(current_dir, allocator);
            try current_dir.children.append(new_dir);
            current_dir = &current_dir.children.items[current_dir.children.items.len - 1];
        } else if (!std.mem.eql(u8, parts[0].?, "dir")) {
            // is file
            // add size to dir
            const size = try std.fmt.parseInt(u32, parts[0].?, 10);
            current_dir.size += size;
        }
    }

    return root.getSum();
}

const Directory = struct {
    size: usize = 0,
    parent: ?*Directory,
    children: std.ArrayList(Directory),

    fn init(parent: ?*Directory, allocator: std.mem.Allocator) Directory {
        return Directory{
            .parent = parent,
            .children = std.ArrayList(Directory).init(allocator),
        };
    }

    fn deinit(self: Directory) void {
        for (self.children.items) |child| {
            child.deinit();
        }
        self.children.deinit();
    }

    fn getTotalSize(self: Directory) usize {
        var totalSize = self.size;
        for (self.children.items) |child| {
            totalSize += child.getTotalSize();
        }
        return totalSize;
    }

    fn getSum(self: Directory) usize {
        var sum: usize = 0;
        var size = self.getTotalSize();
        if (size < 100000) {
            sum += size;
        }
        for (self.children.items) |child| {
            sum += child.getSum();
        }
        return sum;
    }
};

test "Part 1" {
    const expected: usize = 95437;
    const actual = try part1(test_input.len, test_input);
    try std.testing.expectEqual(expected, actual);
}
