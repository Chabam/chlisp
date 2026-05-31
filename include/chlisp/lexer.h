#ifndef LEXER_H
#define LEXER_H

#include <chlisp/expressions.h>

#include <stdint.h>
#include <stddef.h>

enum Atoms read_token(const char* text, size_t size, size_t cursor, size_t* begin, size_t* end);

#endif // LEXER_H
