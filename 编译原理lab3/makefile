all: bison gcc clean

bison:
	bison -d hw3_1.y
	bison -d hw3_2.y

gcc:
	gcc hw3_1.tab.c -o hw3_1
	gcc hw3_2.tab.c -o hw3_2

clean:
	-rm *.c
	-rm *.h
