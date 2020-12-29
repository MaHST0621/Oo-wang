all: lcc  clean

lc:
	flex hw4.l
	gcc lex.yy.c -o lc.out
	./lc.out<test.c>testout0

lcc:
	flex -+ test0.l
	g++ lex.yy.cc -o lcc.out
	./lcc.out<test.c>testout1


clean:
	rm *.out
	rm lex.*
