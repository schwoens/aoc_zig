const std = @import("std");
const Io = std.Io;

const Range = struct {
    start: usize,
    end: usize,

    fn from_string(string: []const u8) !Range {
        var split = std.mem.tokenizeAny(u8, string, "-");    
        const start_str = split.next().?;
        const end_str = split.next().?;
        const start = try std.fmt.parseInt(usize, start_str, 10);
        const end = try std.fmt.parseInt(usize, end_str, 10);
        return .{ .start = start, .end = end };
    }

    fn contains(self: *const Range, id: usize) bool {
        return id <= self.end and id >= self.start; 
    }
};

pub fn main(init: std.process.Init) !void {
    const arena: std.mem.Allocator = init.arena.allocator();

    const io = init.io;

    const input = try read_to_string(arena, io, "input.txt");
    defer arena.free(input);

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout_writer = &stdout_file_writer.interface;

    try stdout_writer.print("Part 1: {}", .{try part1(arena, input)});

    try stdout_writer.flush();
}

pub fn part1(allocator: std.mem.Allocator, input: []const u8) !usize {
    const trimmed_input = std.mem.trim(u8, input, "\n ");
    var fresh_ingredients: usize = 0;

    var ranges: std.ArrayList(Range) = .empty;
    defer ranges.deinit(allocator);

    var sections = std.mem.tokenizeSequence(u8, trimmed_input, "\n\n");

    const range_section = sections.next().?;
    const id_section = sections.next().?;

    var range_section_iter = std.mem.tokenizeAny(u8, range_section, "\n");
    while (range_section_iter.next()) |line| {
        try ranges.append(allocator, try Range.from_string(line)); 
    }

    var id_section_iter = std.mem.tokenizeAny(u8, id_section, "\n");
    while (id_section_iter.next()) |line| {
        const id = try std.fmt.parseInt(usize, line, 10); 
        if (is_fresh(ranges, id)) {
            fresh_ingredients += 1;
        }
    }

    return fresh_ingredients;
}

fn is_fresh(ranges: std.ArrayList(Range), id: usize) bool {
    for (ranges.items) |range| {
        if (range.contains(id)) {
            return true;
        }
    }
    return false;
}

fn read_to_string(allocator: std.mem.Allocator, io: Io, filename: []const u8) ![]const u8 {
    const file = try std.Io.Dir.cwd().openFile(io, filename, .{ .mode = .read_only });
    defer file.close(io);

    const file_length = try file.length(io);

    var file_buffer: [1024]u8 = undefined;
    var file_reader = file.reader(io, &file_buffer);

    const contents = try file_reader.interface.readAlloc(allocator, file_length);
    return contents;
}

test "part1" {
    const gpa = std.testing.allocator;
    const io = std.testing.io;

    const input = try read_to_string(gpa, io, "test_input.txt");
    defer gpa.free(input);

    const result = part1(gpa, input);
    try std.testing.expectEqual(3, result);
}
