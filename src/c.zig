const std = @import("std");

// Don't forget to include the C files in build.zig file

const math = @cImport({
    // @cDefine("INCREMENT_BY", "50");
    @cInclude("math.h");
});

pub fn main() !void {
    const a = 1;
    const b = 2;
    const c = math.add(a, b);

    std.debug.print("result: {d}\n", .{c});
    const d = math.increment(c);
    std.debug.print("result: {d}\n", .{d});
}
