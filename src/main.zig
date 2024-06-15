const std = @import("std");
const root = @import("root.zig");
const bar = @import("foo/bar.zig");
const err = @import("error.zig");

pub fn main() !void {
    try err.main();
}
