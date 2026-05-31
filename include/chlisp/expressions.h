#ifndef EXPRESSIONS_H
#define EXPRESSIONS_H

enum Atoms
{
    ATOM_OPEN_SEXPR,
    ATOM_CLOSE_SEXPR,
    ATOM_SYMBOL,
    ATOM_ERROR
};

const char* atom_to_string(enum Atoms atom);

#endif // EXPRESSIONS_H
