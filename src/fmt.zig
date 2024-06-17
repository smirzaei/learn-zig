const std = @import("std");

// https://github.com/ziglang/zig/blob/0.12.x/lib/std/fmt.zig
// / The format string must be comptime-known and may contain placeholders following
// / this format:
// / `{[argument][specifier]:[fill][alignment][width].[precision]}`
// /
// / Above, each word including its surrounding [ and ] is a parameter which you have to replace with something:
// /
// / - *argument* is either the numeric index or the field name of the argument that should be inserted
// /   - when using a field name, you are required to enclose the field name (an identifier) in square
// /     brackets, e.g. {[score]...} as opposed to the numeric index form which can be written e.g. {2...}
// / - *specifier* is a type-dependent formatting option that determines how a type should formatted (see below)
// / - *fill* is a single unicode codepoint which is used to pad the formatted text
// / - *alignment* is one of the three bytes '<', '^', or '>' to make the text left-, center-, or right-aligned, respectively
// / - *width* is the total width of the field in unicode codepoints
// / - *precision* specifies how many decimals a formatted number should have
// /
// / Note that most of the parameters are optional and may be omitted. Also you can leave out separators like `:` and `.` when
// / all parameters after the separator are omitted.
// / Only exception is the *fill* parameter. If *fill* is required, one has to specify *alignment* as well, as otherwise
// / the digits after `:` is interpreted as *width*, not *fill*.
// /
// / The *specifier* has several options for types:
// / - `x` and `X`: output numeric value in hexadecimal notation
// / - `s`:
// /   - for pointer-to-many and C pointers of u8, print as a C-string using zero-termination
// /   - for slices of u8, print the entire slice as a string without zero-termination
// / - `e`: output floating point value in scientific notation
// / - `d`: output numeric value in decimal notation
// / - `b`: output integer value in binary notation
// / - `o`: output integer value in octal notation
// / - `c`: output integer as an ASCII character. Integer type must have 8 bits at max.
// / - `u`: output integer as an UTF-8 sequence. Integer type must have 21 bits at max.
// / - `?`: output optional value as either the unwrapped value, or `null`; may be followed by a format specifier for the underlying value.
// / - `!`: output error union value as either the unwrapped value, or the formatted error value; may be followed by a format specifier for the underlying value.
// / - `*`: output the address of the value instead of the value itself.
// / - `any`: output a value of any type using its default format

pub fn main() !void {
    const pi = 3.14159265359;
    const point = .{ .x = 1, .y = 2, .z = 3 };
    const stderr = std.io.getStdErr().writer();
    try std.fmt.format(stderr, "{d:.2} {}\n", .{pi, point});

    // An easier way to write to stderr
    std.debug.print("{d:.2}\n", .{pi});
}
