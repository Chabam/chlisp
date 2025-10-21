#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <chlisp/string_utils.h>
#include <chlisp/defines.h>

int read_string(int fd, char** dest, int* count)
{
    uint8_t sexp_size = 0;
    char c;
    uint8_t buf_size = 8;
    char* buf = malloc(buf_size);

    while(read(fd, &c, 1) > 0)
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

    *dest = malloc(sexp_size);
    *count = sexp_size;
    strcpy(*dest, buf);
    free(buf);

    return CHLISP_SUCCESS;
}
