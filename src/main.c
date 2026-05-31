#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <chlisp/lexer.h>

void print_usage()
{
    printf("chlisp FILE");
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        print_usage();
        return 1;
    }

    const char* file_path = argv[1];

    FILE* file = fopen(file_path, "r");
    fseek(file, 0, SEEK_END);
    size_t file_size = ftell(file);

    char* file_content = (char*)malloc(file_size);
    fseek(file, 0, 0);
    fread(file_content, file_size, file_size, file);
    fclose(file);

    printf("file content: %s\n", file_content);
    size_t cursor = 0;
    size_t begin;
    size_t end;
    while (cursor <= file_size)
    {
        enum Atoms atom_t = read_token(file_content, file_size, cursor, &begin, &end);

        if (atom_t == ATOM_ERROR)
            break;

        size_t token_size = end - begin;
        char* token = calloc(0, token_size + 1);
        memcpy(token, &file_content[begin], token_size);
        printf("%ld,%ld,%s: %s\n", cursor, token_size, token, atom_to_string(atom_t));
        free(token);
        cursor += token_size;
    }

    free(file_content);
    return 0;
}
