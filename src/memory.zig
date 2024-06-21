const std = @import("std");

// The better idea would be to get the output buffer from the caller and
// just check if it's large enough, instead of allocating in this function
// and returning the allocated buffer
fn copyArrayFromStack(allocator: std.mem.Allocator) ![]u8 {
    const arr = [4]u8{ 'F', 'o', 'o', '\n' };
    std.debug.print("&arr = {*}\n", .{&arr});

    const heap = try allocator.alloc(u8, arr.len);
    // It's a good practice to clean up in case of an error
    errdefer allocator.free(heap);

    std.debug.print("&heap = {*}\n", .{heap});

    @memcpy(heap, arr[0..]);

    return heap;
}

const UserConfig = struct {
    name: []const u8,
};

const User = struct {
    name: []u8,
    allocator: std.mem.Allocator,

    fn init(allocator: std.mem.Allocator, config: UserConfig) !*User {
        const ptr = try allocator.create(User);
        errdefer allocator.destroy(ptr);

        std.debug.print("&usr_ptr = {*}\n", .{ptr});

        ptr.name = try allocator.alloc(u8, config.name.len);
        errdefer allocator.free(ptr.name);

        std.debug.print("&ptr.name = {*}\n", .{ptr.name});

        @memcpy(ptr.name, config.name);
        ptr.allocator = allocator;

        return ptr;
    }

    fn deinit(self: *User) void {
        self.allocator.free(self.name);
        self.allocator.destroy(self);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    // For debugging purposes you can log all (de)allocations:
    var logging_allocator = std.heap.loggingAllocator(gpa.allocator());
    const allocator = logging_allocator.allocator();

    const data = try copyArrayFromStack(allocator);
    defer allocator.free(data);

    std.debug.print("&data = {*} - {s}\n", .{ data, data });

    const u = try User.init(allocator, .{ .name = "bar" });
    defer u.deinit();

    std.debug.print("&u = {*}\n", .{u});

    // FixedBufferAllocator doesn't actually allocate anything on the heap
    // You create a buffer on the stack and it uses it as the underlying memory
    // It's more performant, because you don't need to make additional syscalls
    // but you'd need to calculate the size and make sure it's not so large that
    // it won't fit in the stack.
    std.debug.print("====================\n", .{});
    std.debug.print("FixedBufferAllocator\n", .{});
    std.debug.print("====================\n", .{});
    const nUsers = 2;
    var fba_buf: [nUsers * @sizeOf(User)]u8 = undefined;
    std.debug.print("&fbaBuf = {*}\n", .{&fba_buf});
    std.debug.print("fbaBuf = {d}\n", .{fba_buf});

    var fba = std.heap.FixedBufferAllocator.init(&fba_buf);
    // Since fba uses stack, there is no deinit method and it's cleaned up
    // when it goes out of scope

    // CAUTION: When creating the underlying buffer, it doesn't account for
    // dynamic sized fields like "name" in this case. If you add a name, there
    // won't be enough room to allocate a second user. If you want to have room
    // for name then you need to account for it when initializing the backing array.
    const user1 = try User.init(fba.allocator(), .{ .name = "" });
    std.debug.print("fbaBuf = {d}\n", .{fba_buf});
    std.debug.print("&user1 = {*} - user1.name = {s}\n", .{ user1, user1.name });

    const user2 = try User.init(fba.allocator(), .{ .name = "" });
    std.debug.print("fbaBuf = {d}\n", .{fba_buf});
    std.debug.print("&user1 = {*} - user1.name = {s}\n", .{ user2, user2.name });

    // ArenaAllocator, allocates a page of memory and whenever it's used to
    // make an allocation, it uses the memory from the page and it can only
    // deallocate the whole page at once. Good usecases:
    // * If you have a short lived application, it doesn't need to release memory
    //   as it goes and can release the whole memory once it's finished.
    // * For request-based allocation. Imagine a web server scenario, you can
    //   create an ArenaAllocator for each web request and release the whole memory
    //   once the request is finished.

    // MemoryPool is very useful when you need to make allocations of the same size
    // meaning you need to make many allocation for the same type, then it can
    // reuse the deallocated spots which leads to less memory fragmentation.
    var pool = std.heap.MemoryPool(u64).init(allocator);
    defer pool.deinit();
    const a1 = try pool.create();
    const a2 = try pool.create();
    const a3 = try pool.create();
    pool.destroy(a3);
    const a4 = try pool.create();

    std.debug.print("&a1: {*}. &a2: {*}. &a3: {*} &a4: {*}\n", .{ &a1, &a2, &a3, &a4 });
}
