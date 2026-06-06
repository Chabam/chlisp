const value = @import("value.zig");
const Value = value.Value;

pub const Pair = struct {
    head: Value,
    tail: Value,
    pub fn init(head: Value, tail: Value) Pair {
        return .{ .head = head, .tail = tail };
    }
};
