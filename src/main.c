#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <chlisp/string_utils.h>
#include <chlisp/defines.h>

int is_balanced(const char* sexp)
{
    uint8_t current_depth = 0;
    size_t i = 0;
    while (sexp[i] != '\0')
    {
        if (sexp[i] == '(')
        {
            ++current_depth;
        }
        else if (sexp[i] == ')')
        {
            --current_depth;
        }
        ++i;
    }

    return current_depth == 0;
}


int main(int argc, char** argv)
{
    printf("> ");
    fflush(stdout);

    char* sexp = NULL;
    int char_count;
    int ret = read_string(0, &sexp, &char_count);

    if (ret != CHLISP_SUCCESS)
        exit(1);

    printf("The sexp is %s\n", sexp);
    if (is_balanced(sexp))
    {
        printf("It is balanced 🤓\n");
    }
    else
    {
        printf("It is not balanced 😢\n");
    }
    free(sexp);

    return 0;
}
