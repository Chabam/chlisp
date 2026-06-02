const std = @import("std");

pub const Atoms = enum {
    open_sexpr,
    close_sexpr,
    symbol,
};

pub fn read_token(text: []u8, input_cursor: usize, begin: *usize, end: *usize) ?Atoms {
    var is_symbol: bool = false;
    var cursor = input_cursor;

    begin.* = cursor;
    end.* = cursor;

    while (cursor < text.len) : ({
        cursor = cursor + 1;
        end.* = end.* + 1;
    }) {
        if (text[cursor] == ' ' or
            text[cursor] == '\t' or
            text[cursor] == '\n')
        {
            if (is_symbol) {
                return Atoms.symbol;
            }

            begin.* = begin.* + 1;
            continue;
        }

        if (text[cursor] == '(') {
            if (!is_symbol) {
                end.* = end.* + 1;
                return Atoms.open_sexpr;
            }

            return Atoms.symbol;
        } else if (text[cursor] == ')') {
            if (!is_symbol) {
                end.* = end.* + 1;
                return Atoms.close_sexpr;
            }

            return Atoms.symbol;
        }

        is_symbol = true;
    }

    if (!is_symbol)
        return null;

    return Atoms.symbol;
}
