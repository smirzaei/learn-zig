const std = @import("std");

/// This kind of interface is more performant and very easy to implement.
/// The downside is that you must have access to the source code in order to
/// be able to modify it.
const Stringer = union(enum) {
    hello: Hello,
    bye: Bye,

    fn toString(self: Stringer) []const u8 {
        return switch (self) {
            inline else => |it| it.toString(),
        };
    }
};

const Hello = struct {
    fn toString(_: Hello) []const u8 {
        return "Hello, world!";
    }
};

const Bye = struct {
    fn toString(_: Bye) []const u8 {
        return "Goodbye cruel world...";
    }
};

fn print(s: Stringer) void {
    std.debug.print("{s}\n", .{s.toString()});
}

pub fn main() !void {
    const hello = Stringer{
        .hello = Hello{},
    };

    const bye = Stringer{
        .bye = Bye{},
    };

    print(hello);
    print(bye);
}
