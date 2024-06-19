const std = @import("std");

pub const Stringer = struct {
    ptr: *anyopaque,
    toStringFn: *const fn (*anyopaque, []u8) std.fmt.BufPrintError!void,

    pub fn toString(self: Stringer, buf: []u8) !void {
        try self.toStringFn(self.ptr, buf);
    }
};

const Greeter = struct {
    name: []const u8,

    pub fn toString(ptr: *anyopaque, buf: []u8) !void {
        const self: *Greeter = @ptrCast(@alignCast(ptr));
        _ = try std.fmt.bufPrint(buf, "Hello {s}\n", .{self.name});
    }

    pub fn stringer(self: *Greeter) Stringer {
        return .{
            .ptr = self,
            .toStringFn = Greeter.toString,
        };
    }
};

const Farewell = struct {
    name: []const u8,

    pub fn toString(ptr: *anyopaque, buf: []u8) !void {
        const self: *Farewell = @ptrCast(@alignCast(ptr));
        _ = try std.fmt.bufPrint(buf, "So long {s}\n", .{self.name});
    }

    pub fn stringer(self: *Farewell) Stringer {
        return .{
            .ptr = self,
            .toStringFn = Farewell.toString,
        };
    }
};

fn print(s: Stringer) !void {
    var buf: [20]u8 = [_]u8{0} ** 20;
    try s.toString(buf[0..]);

    std.debug.print("{s}", .{buf});
}

pub fn main() !void {
    var g = Greeter{
        .name = "Foo",
    };
    try print(g.stringer());

    var f = Farewell{
        .name = "Bar",
    };
    try print(f.stringer());
}
