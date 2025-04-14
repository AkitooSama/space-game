const rl = @cImport(@cInclude("raylib.h"));
const Vector2 = rl.Vector2;

pub const Player = struct {
    pos: Vector2,
    gravity: f32 = 80,

    pub fn init(x: f32, y: f32) Player {
        return .{ .pos = .{ .x = x, .y = y }, .gravity = 80 };
    }

    pub fn update(self: *Player) void {
        const vel: f32 = 10;

        if (rl.IsKeyDown(rl.KEY_UP)) self.pos.y -= vel;
        if (rl.IsKeyDown(rl.KEY_DOWN)) self.pos.y += vel;
        if (rl.IsKeyDown(rl.KEY_RIGHT)) self.pos.x += vel;
        if (rl.IsKeyDown(rl.KEY_LEFT)) self.pos.x -= vel;

        if (rl.IsKeyPressed(rl.KEY_SPACE)) self.gravity = 10;
        if (rl.IsKeyReleased(rl.KEY_SPACE)) self.gravity = 80;
    }

    pub fn applyGravity(self: *Player, dt: f32) void {
        self.pos.y += self.gravity * dt;
    }
};
