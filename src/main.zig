const std = @import("std");
const rl = @cImport(@cInclude("raylib.h"));
const my_json = @import("json.zig");

const Vector2 = rl.Vector2;

const RADIUS = 20;
const THICKNESS = 10;
const VELOCITY = 10;

var gravity: f32 = 80;

fn update(p: *Vector2, vel: f32) !void {
    if (rl.IsKeyDown(rl.KEY_UP)) p.*.y -= vel;
    if (rl.IsKeyDown(rl.KEY_DOWN)) p.*.y += vel;
    if (rl.IsKeyDown(rl.KEY_RIGHT)) p.*.x += vel;
    if (rl.IsKeyDown(rl.KEY_LEFT)) p.*.x -= vel;

    if (rl.IsKeyPressed(rl.KEY_SPACE)) gravity = 10;
    if (rl.IsKeyReleased(rl.KEY_SPACE)) gravity = 80;
}

fn makeRect(pos: []const f32, size: []const f32) !struct { pos: Vector2, size: Vector2 } {
    return .{
        .pos = Vector2{ .x = @as(f32, pos[0]), .y = @as(f32, pos[1]) },
        .size = Vector2{ .x = @as(f32, size[0]), .y = @as(f32, size[1]) },
    };
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const settings_slice, const settings_parsed = try my_json.GameSettings.loadFileAttributes("src/settings.json", allocator);
    const settings = settings_parsed.value;
    defer {
        settings_parsed.deinit();
        allocator.free(settings_slice);
    }

    rl.InitWindow(
        @as(c_int, @intFromFloat(settings.screen_width)),
        @as(c_int, @intFromFloat(settings.screen_height)),
        settings.title,
    );
    defer rl.CloseWindow();

    rl.SetTargetFPS(settings.fps);

    var buff: [128]u8 = undefined;

    var ballPos = Vector2{
        .x = @divTrunc(settings.screen_width, 2),
        .y = @divTrunc(settings.screen_height, 2),
    };

    var camera = rl.Camera2D{
        .offset = Vector2{
            .x = @divTrunc(settings.screen_width, 2),
            .y = @divTrunc(settings.screen_height, 2),
        },
        .target = ballPos,
        .rotation = 0.0,
        .zoom = 1.0,
    };

    while (!rl.WindowShouldClose()) {
        try update(&ballPos, VELOCITY);
        camera.target = ballPos;

        const dt = rl.GetFrameTime();
        ballPos.y += gravity * dt;

        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.BLACK);
        rl.BeginMode2D(camera);

        const rectVector = try makeRect(&[2]f32{ 30, 350 }, &[2]f32{ 150, 50 });
        rl.DrawRectangleV(rectVector.pos, rectVector.size, rl.DARKBROWN);

        rl.DrawCircleV(ballPos, RADIUS, rl.DARKGRAY);
        rl.EndMode2D();

        const posText = try std.fmt.bufPrint(
            &buff,
            "x:{}, y:{}\n\n\nI'm back :D | stream - 3",
            .{
                @as(i32, @intFromFloat(ballPos.x)),
                @as(i32, @intFromFloat(ballPos.y)),
            },
        );
        buff[posText.len] = 0;
        rl.DrawText(&buff[0], 0, 0, 25, rl.DARKBLUE);
    }
}