const std = @import("std");

const pair = @import("pair.zig");
const Pair = pair.Pair;
const value = @import("value.zig");

pub const Value = union(enum) {
    number: u64,
    symbol: []u8,
    pair: *pair.Pair,
    nil,
    pub fn print(self: Value, writer: *std.Io.Writer) !void {
        switch (self) {
            .number => |number| try writer.print("{d}", .{number}),
            .symbol => |symbol| try writer.print("{s}", .{symbol}),
            .pair => |ppair| {
                try writer.print("(", .{});
                try ppair.*.head.print(writer);
                try writer.print(" . ", .{});
                try ppair.*.tail.print(writer);
                try writer.print(")", .{});
            },
            .nil => try writer.print("nil", .{})
        }
    }
};
