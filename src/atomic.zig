const std = @import("std");
const root = @import("root.zig");
const bar = @import("foo/bar.zig");

const fmt = std.fmt;
const Thread = std.Thread;
const Mutex = Thread.Mutex;
const RwLock = Thread.RwLock;
const Atomic = std.atomic.Value;

const Counter = struct {
    count: Atomic(usize) = Atomic(usize).init(0),

    fn increment(self: *Counter) void {
        _ = self.count.fetchAdd(1, .acq_rel);
    }

    fn print(self: *Counter) !void {
        const count = self.count.load(.acquire);

        var b: [20]u8 = undefined;
        _ = try fmt.bufPrint(&b, "Counter: {d}\n", .{count});

        const writer = std.io.getStdErr().writer();
        _ = try writer.write(&b);
    }
};

pub fn main() !void {
    var c = Counter{};
    try c.print();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const alloc = gpa.allocator();

    var pool: Thread.Pool = undefined;
    try pool.init(.{
        .allocator = alloc,
    });

    // Need to get a direct reference to the increment method
    // Calling c.increment raises an error which says that it cannot find
    // a field named "increment"
    //
    // Another approach is to create a wrapper function that takes a counter
    // and calls increment:
    // fn incrementFn(ctx: *Counter) void {
    //     Counter.increment(ctx);
    // }
    const incrementFn = @field(Counter, "increment");

    for (0..100000) |_| {
        try pool.spawn(incrementFn, .{&c});
    }
    pool.deinit(); // Wait for all tasks to finish


    try c.print();
}
