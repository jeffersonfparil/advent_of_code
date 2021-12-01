#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
  int *array;
  size_t used;
  size_t size;
} Array;

void initArray(Array *a, size_t initialSize) {
  a->array = malloc(initialSize * sizeof(int));
  a->used = 0;
  a->size = initialSize;
}

void insertArray(Array *a, int element) {
  // a->used is the number of used entries, because a->array[a->used++] updates a->used only *after* the array has been accessed.
  // Therefore a->used can go up to a->size 
  if (a->used == a->size) {
    a->size *= 2;
    a->array = realloc(a->array, a->size * sizeof(int));
  }
  a->array[a->used++] = element;
}

void freeArray(Array *a) {
  free(a->array);
  a->array = NULL;
  a->used = a->size = 0;
}


int main(int argc, char* argv[])
{
    char const* const fileName = argv[1]; // should check that argc > 1
    FILE* file = fopen(fileName, "r"); /* should check the result */
    
    int lineSize = 1024; 
    char line[lineSize];

    int previous = -1;
    int current;

    Array a;

    initArray(&a, 5);  // initially 5 elements

    while (fgets(line, sizeof(line), file)) {
        /* note that fgets don't strip the terminating \n, checking its
           presence would allow to handle lines longer that sizeof(line) */

        // print string
        // printf("%s", line);
        // type cast from string to int
        current = atoi(line);
        // printf("%i\n", current);
        if (current > previous) {
            // printf("%i\n", current);
            insertArray(&a, current);
        }
        previous = current;
    }
    /* may check feof here to make a difference between eof and io failure -- network
       timeout for instance */

    // free(copy);
    // copy = NULL;

    fclose(file);

    // count the number of elements in the array
    // int out = sizeof(a.array) / sizeof(a.array[0]);
    // printf("%i\n", out);
    // for (int i; i<100; i++){
    //     printf("%i\n", a.array[i]);
    // }
    int i=0;
    int length=0;
    while (a.array[i] != '\0'){
        i = i + 1;
        length=length+1;
    }
    int out = length - 1;
    printf("%i\n", out);

    return 0;
}

