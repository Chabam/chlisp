CC=gcc
C_FLAGS=-Wall -Iinclude/ -g

chlisp: src/main.c src/lexer.o src/expressions.o build
	$(CC) $(C_FLAGS) src/main.c -o build/chlisp src/lexer.o src/expressions.o

build:
	mkdir build

src/lexer.o: src/lexer.c
	$(CC) $(C_FLAGS) src/lexer.c -c -o src/lexer.o

src/expressions.o: src/expressions.c
	$(CC) $(C_FLAGS) src/expressions.c -c -o src/expressions.o
