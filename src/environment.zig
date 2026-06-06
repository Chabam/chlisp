const std = @import("std");

const value = @import("value.zig");

const Frame = std.StringHashMap(value.Value);

pub const Environment = struct {
    parent: ?*Environment,
    values: Frame,
    pub fn init(allocator: std.mem.Allocator) Environment {
        return Environment{
            .parent = null,
            .values = Frame.init(allocator)
        };
    }

    pub fn deinit(self: *Environment) void {
        self.values.deinit();
    }

    pub fn addValue(self: *Environment, name: []u8, val: value.Value) !void {
        try self.values.put(name, val);
    }

    pub fn print(self: *Environment, writer: *std.Io.Writer) !void {
        var it = self.values.iterator();
        while (it.next()) |entry| {
            try writer.print("{s} => ", .{entry.key_ptr.*});
            try entry.value_ptr.*.print(writer);
            try writer.print("\n", .{});
        }
    }
};
