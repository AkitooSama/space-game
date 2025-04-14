const std = @import("std");
const rl = @cImport(@cInclude("raylib.h"));
const my_json = @import("json.zig");
const player = @import("player.zig");

const Vector2 = rl.Vector2;

fn makeRect(pos: [2]f32, size: [2]f32) struct { pos: Vector2, size: Vector2 } {
    return .{
        .pos = .{ .x = pos[0], .y = pos[1] },
        .size = .{ .x = size[0], .y = size[1] },
    };
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const json_slice, const parsed = try my_json.GameSettings.loadFileAttributes("src/settings.json", allocator);
    const settings = parsed.value;
    defer {
        parsed.deinit();
        allocator.free(json_slice);
    }

    rl.InitWindow(
        @as(c_int, @intFromFloat(settings.screen_width)),
        @as(c_int, @intFromFloat(settings.screen_height)),
        settings.title
    );
    defer rl.CloseWindow();

    rl.SetTargetFPS(settings.fps);

    var text_buf: [64]u8 = undefined;

    var p = player.Player.init(
        @divTrunc(settings.screen_width, 2),
        @divTrunc(settings.screen_height, 2),
    );

    var camera = rl.Camera2D{
        .offset = .{
            .x = @divTrunc(settings.screen_width, 2),
            .y = @divTrunc(settings.screen_height, 2),
        },
        .target = p.pos,
        .rotation = 0,
        .zoom = 1.0,
    };

    while (!rl.WindowShouldClose()) {
        p.update();
        p.applyGravity(rl.GetFrameTime());
        camera.target = p.pos;

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.BLACK);
        rl.BeginMode2D(camera);

        const rect = makeRect([2]f32{30, 350}, [2]f32{150, 50});
        rl.DrawRectangleV(rect.pos, rect.size, rl.DARKBROWN);

        rl.DrawCircleV(p.pos, 20, rl.DARKGRAY);
        rl.EndMode2D();

        const len = try std.fmt.bufPrint(&text_buf, "x:{}, y:{}", .{
            @as(i32, @intFromFloat(p.pos.x)),
            @as(i32, @intFromFloat(p.pos.y)),
        });
        text_buf[len.len] = 0;
        rl.DrawText(&text_buf[0], 0, 0, 25, rl.DARKBLUE);
    }
}
