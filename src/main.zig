const std = @import("std");
const root = @import("root.zig");
const bar = @import("foo/bar.zig");
const err = @import("error.zig");
const hasmap = @import("hashmap.zig");
const fmt = @import("fmt.zig");
const arrayList = @import("array_list.zig");
const c = @import("c.zig");
const generic = @import("generic.zig");
const unionInterface = @import("interface_union.zig");
const interface = @import("interface.zig");

pub fn main() !void {
    try interface.main();
}
