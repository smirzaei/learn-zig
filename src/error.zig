const std = @import("std");

const InputError = error{
    EmptyInput,
};

const NumberError = error{
    InvalidCharacter,
    Overflow,
};

const ParseError = InputError || NumberError;
fn parseNumber(s: []const u8) ParseError!u8 {
    if (s.len == 0) {
        return InputError.EmptyInput;
    }

    // parseInt returns ParseIntError which has InvalidCharacter and Overflow
    // It automatically is converted to the NumberError
    return std.fmt.parseInt(u8, s, 10);

}

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    var buf: [10]u8 = undefined;

    while (true) {
        std.debug.print("Write a number: ", .{});
        if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |input| {
            const result = parseNumber(input) catch |err| switch (err) {
                InputError.EmptyInput => {
                    std.debug.print("Wrong input\n", .{});
                    continue;
                },
                NumberError.Overflow => {
                    std.debug.print("Can't fit that number in 8 bits\n", .{});
                    continue;
                },
                NumberError.InvalidCharacter => {
                    std.debug.print("Wrong character", .{});
                    continue;
                }
            };

            std.debug.print("Result: {!}\n", .{result});
        }
    }

}
