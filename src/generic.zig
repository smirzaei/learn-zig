const std = @import("std");

pub fn Point(comptime T: type) type {
    return struct {
        x: T,
        y: T,

        const Self = @This();

        pub fn new(x: T, y: T) Self {
            return .{ .x = x, .y = y };
        }

        pub fn distance(self: Self, other: Self) f64 {
            const diffx: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(self.x - other.x),
                .Float => self.x - self.x,
                else => @compileError("invalid type"),
            };

            const diffy: f64 = switch (@typeInfo(T)) {
                .Int => @floatFromInt(self.y - other.y),
                .Float => self.y - self.y,
                else => @compileError("invalid type"),
            };

            return @sqrt(diffx * diffx + diffy * diffy);
        }
    };
}

pub fn main() !void {
    const p1 = Point(i64).new(10, 20);
    const p2 = Point(i64).new(5, 10);

    const distance = p1.distance(p2);
    std.debug.print("p1: {}, p2: {}, distance: {d:.2}\n", .{ p1, p2, distance });
}
