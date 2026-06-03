const value = @import("value.zig");
const Value = value.Value;

pub const Pair = struct {
    head: *const Value,
    tail: *const Value,
    pub fn init(head: *const Value, tail: *const Value) Pair {
        return .{ .head = head, .tail = tail };
    }
};
