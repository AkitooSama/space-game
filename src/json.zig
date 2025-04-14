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
};

pub const LoadedSettings = struct {
    raw: []const u8,
    data: std.json.Parsed(GameSettings),

    pub fn deinit(self: *LoadedSettings, allocator: std.mem.Allocator) void {
        self.data.deinit();
        allocator.free(self.raw);
    }
};

pub fn loadFileAttributes(
    filepath: []const u8,
    allocator: std.mem.Allocator,
) !LoadedSettings {
    const file = try std.fs.cwd().openFile(filepath, .{});
    defer file.close();

    const stat = try file.stat();
    const json_slice = try file.readToEndAlloc(allocator, stat.size);
    errdefer allocator.free(json_slice);

    return LoadedSettings{
        .raw = json_slice,
        .data = try GameSettings.parseFileAttributes(allocator, json_slice),
    };
}
