const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const alloc = gpa.allocator();

    // len = 0, capacity = 0
    var list = std.ArrayList(u8).init(alloc);
    defer list.deinit();

    std.debug.print("{any}\t{d}\t{d}\n\n", .{list.items, list.items.len, list.capacity});

    for (0..10) |i| try list.append(@truncate(i));

    std.debug.print("{any}\n\n", .{list.items});
    std.debug.print("{any}\t{d}\t{d}\n\n", .{list.items, list.items.len, list.capacity});

    var list2 = try std.ArrayList(usize).initCapacity(alloc, 10);
    defer list2.deinit();


    std.debug.print("{any}\t{d}\t{d}\n\n", .{list2.items, list2.items.len, list2.capacity});
    for (0..10) |i| list2.appendAssumeCapacity(i);
    std.debug.print("{any}\t{d}\t{d}\n\n", .{list2.items, list2.items.len, list2.capacity});

}
