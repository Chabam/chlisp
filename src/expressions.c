#include <chlisp/expressions.h>

const char* atom_to_string(enum Atoms atom)
{
    switch (atom)
    {
        case ATOM_OPEN_SEXPR:
            return "ATOM_OPEN_SEXPR";
        case ATOM_CLOSE_SEXPR:
            return "ATOM_CLOSE_SEXPR";
        case ATOM_SYMBOL:
            return "ATOM_SYMBOL";
        default:
            return "UNKOWN";
    }
}
