const std = @import("std");

pub const TokenType = enum {
    open_sexpr,
    close_sexpr,
    symbol,
};

pub const Token = struct { type: TokenType, begin: usize, text: [] const u8 };

pub const Tokenizer = struct {
    cursor: usize,
    text: []const u8,
    pub fn init(text: []u8) Tokenizer {
        return Tokenizer{ .cursor = 0, .text = text };
    }
    pub fn next(self: *Tokenizer) ?Token {
        var is_symbol: bool = false;

        var begin = self.cursor;
        var end = self.cursor;
        defer self.cursor = end;

        while (self.cursor < self.text.len) : ({
            self.cursor = self.cursor + 1;
            end = end + 1;
        }) {
            if (self.text[self.cursor] == ' ' or
                self.text[self.cursor] == '\t' or
                self.text[self.cursor] == '\n')
            {
                if (is_symbol) {
                    return Token{ .type = TokenType.symbol, .begin = begin, .text = self.text[begin..end] };
                }

                begin = begin + 1;
                continue;
            }

            if (self.text[self.cursor] == '(') {
                if (!is_symbol) {
                    end = end + 1;
                    return Token{ .type = TokenType.open_sexpr, .begin = begin, .text = self.text[begin..end] };
                }

                return Token{ .type = TokenType.symbol, .begin = begin, .text = self.text[begin..end] };
            } else if (self.text[self.cursor] == ')') {
                if (!is_symbol) {
                    end = end + 1;
                    return Token{ .type = TokenType.close_sexpr, .begin = begin, .text = self.text[begin..end] };
                }

                return Token{ .type = TokenType.symbol, .begin = begin, .text = self.text[begin..end] };
            }

            is_symbol = true;
        }

        if (!is_symbol)
            return null;

        return Token{ .type = TokenType.symbol, .begin = begin, .text = self.text[begin..end] };
    }
};
