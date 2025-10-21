CC=gcc
C_FLAGS=-Wall -Iinclude/

chlisp: src/main.c string_utils.o
	$(CC) $(C_FLAGS) src/main.c string_utils.o -o chlisp

string_utils.o: src/string_utils.c include/chlisp/string_utils.h
	$(CC) $(C_FLAGS) -c src/string_utils.c
