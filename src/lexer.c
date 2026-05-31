#include <chlisp/lexer.h>
#include <string.h>
#include <stdbool.h>
#include <stdio.h>


enum Atoms read_token(const char* text, size_t size, size_t cursor, size_t* begin, size_t* end)
{
    bool symbol = false;
    *end = cursor;
    *begin = cursor;
    while (cursor < size)
    {
        if (text[cursor] == ' ' ||
            text[cursor] == '\t' ||
            text[cursor] == '\n')
        {
            if (symbol)
            {
                ++*end;
                return ATOM_SYMBOL;
            }

            ++*begin;
            ++cursor;
            continue;
        }

        if (text[cursor] == '(')
        {
            if (!symbol)
            {
                ++*end;
                return ATOM_OPEN_SEXPR;
            }

            return ATOM_SYMBOL;
        }
        else if (text[cursor] == ')')
        {
            if (!symbol)
            {
                ++*end;
                return ATOM_CLOSE_SEXPR;
            }

            return ATOM_SYMBOL;
        }

        symbol = true;
        ++cursor;
        ++*end;
    }

    if (symbol)
        return ATOM_SYMBOL;
    else
        return ATOM_ERROR;
}
