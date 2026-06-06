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

const expect = std.testing.expect;

test "basic_tokenizing" {
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    const allocator = gpa.allocator();

    const basic_txt = "(+ 1 2)";
    var tokens = try std.ArrayList(Token).initCapacity(allocator, 5);

    var tokenizer = Tokenizer.init(@constCast(basic_txt));
    while (tokenizer.next()) |token| {
        try tokens.append(allocator, token);
    }

    try expect(tokens.items.len == 5);
    try expect(tokens.items[0].type == TokenType.open_sexpr);
    try expect(tokens.items[1].type == TokenType.symbol);
    try expect(tokens.items[2].type == TokenType.symbol);
    try expect(tokens.items[3].type == TokenType.symbol);
    try expect(tokens.items[4].type == TokenType.close_sexpr);
}
