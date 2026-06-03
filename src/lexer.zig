const std = @import("std");

pub const TokenType = enum {
    open_sexpr,
    close_sexpr,
    symbol,
};

pub const Token = struct { type: TokenType, begin: usize, text: []const u8 };

pub const Tokenizer = struct {
    cursor: usize,
    text: []const u8,
    pub fn init(text: []u8) Tokenizer {
        return Tokenizer{ .cursor = 0, .text = text };
    }
    pub fn next(self: *Tokenizer) ?Token {
        var begin = self.cursor;
        var end = self.cursor;
        defer self.cursor = end;

        var tt: ?TokenType = null;
        const open_sexpr_chars = [_]u8{'('};
        const close_sexpr_chars = [_]u8{')'};
        const whitespace_chars = [_]u8{ ' ', '\t', '\n' };
        while (self.cursor < self.text.len) : ({
            self.cursor = self.cursor + 1;
            end = end + 1;
        }) {
            if (std.mem.indexOfScalar(u8, &whitespace_chars, self.text[self.cursor])) |_| {
                if (tt != null)
                    break;

                begin = begin + 1;
                continue;
            }

            // TODO: check if I really want to support multiple open/close chars
            if (std.mem.indexOfScalar(u8, &open_sexpr_chars, self.text[self.cursor])) |_| {
                if (tt == null) {
                    end = end + 1;
                    tt = TokenType.open_sexpr;
                    break;
                }

                break;
            }

            if (std.mem.indexOfScalar(u8, &close_sexpr_chars, self.text[self.cursor])) |_| {
                if (tt == null) {
                    end = end + 1;
                    tt = TokenType.close_sexpr;
                    break;
                }

                break;
            }

            tt = TokenType.symbol;
        }

        if (tt == null)
            return null;

        return Token{ .type = tt.?, .begin = begin, .text = self.text[begin..end] };
    }
};
