const std = @import("std");

pub const ValueType = enum { int, float, symbol };

pub const Value = union(ValueType) { int: i64, float: f64, symbol: []u8 };
