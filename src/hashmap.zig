const std = @import("std");

const Repo = struct {
    cache: std.AutoHashMap([]const u8, u8),

    fn init(allocator: std.mem.Allocator) Repo {
        return .{
            .cache = std.AutoHashMap([]const u8, u8).init(allocator)
        };
    }

    fn deinit(self: *Repo) void {
        self.cache.deinit();
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const alloc = gpa.allocator();

    var map = std.StringHashMap(u8).init(alloc); // For String keys
    // const map = std.AutoHashMap(usize, u8).init(alloc); // For other type of keys
    defer map.deinit();

    try map.put("a", 1);
    try map.put("b", 2);

    if (map.get("a")) |a| {
        std.debug.print("found a {}\n", .{a});
    }

    const b = map.get("b").?;
    std.debug.print("found b {}\n", .{b});

    const c = map.get("c") orelse 3;
    std.debug.print("found c {}\n", .{c});

    var removed = map.remove("b");
    std.debug.print("removed b {}\n", .{removed});


    removed = map.remove("b");
    std.debug.print("removed b {}\n", .{removed});
}
