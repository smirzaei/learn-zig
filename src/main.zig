const std = @import("std");
const root = @import("root.zig");
const bar = @import("foo/bar.zig");
const err = @import("error.zig");
const hasmap = @import("hashmap.zig");
const fmt = @import("fmt.zig");
const arrayList = @import("array_list.zig");

pub fn main() !void {
    try arrayList.main();
}
