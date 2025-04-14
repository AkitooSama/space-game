const std = @import("std");

pub const GameSettings = struct {
    title: [:0]const u8,
    screen_width: f32,
    screen_height: f32,
    fps: c_int,

    pub fn parseFileAttributes(
        allocator: std.mem.Allocator,
        json_slice: []const u8,
    ) !std.json.Parsed(GameSettings) {
        return std.json.parseFromSlice(
            GameSettings, allocator, json_slice, .{}
        );
    }

    pub fn loadFileAttributes(
        filepath: []const u8,
        allocator: std.mem.Allocator,
    ) !struct { []const u8, std.json.Parsed(GameSettings) } {
        const file = try std.fs.cwd().openFile(filepath, .{});
        defer file.close();

        const max_file_size = 4 * 1024;
        const json_slice = try file.readToEndAlloc(allocator, max_file_size);
        errdefer allocator.free(json_slice);

        return .{
            json_slice,
            try parseFileAttributes(allocator, json_slice),
        };
    }
};
