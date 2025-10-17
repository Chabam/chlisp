#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

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

char* read_sexp()
{
    uint8_t sexp_size = 0;
    char c;
    uint8_t buf_size = 8;
    char* buf = malloc(buf_size);

    while(read(0, &c, 1) > 0)
    {
        if (c == '\n')
            break;

        if (buf_size < sexp_size)
        {
            buf_size *= 2;
            char* new_buf = malloc(buf_size);
            char* tmp = buf;
            buf = new_buf;
            free(tmp);
        }

        buf[sexp_size++] = c;
    }
    buf[sexp_size] = '\0';

    char* res = malloc(sexp_size);
    strcpy(res, buf);
    free(buf);

    return res;
}

int main(int argc, char** argv)
{
    printf("> ");
    fflush(stdout);

    char* sexp = read_sexp();
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
