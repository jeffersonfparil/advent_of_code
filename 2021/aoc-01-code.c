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

typedef struct {
  int sca_1;
  int sca_2;
  int sca_3;
} Trio;

void updateTrio(Trio* T, int element){
 T->sca_1 = T->sca_2;
 T->sca_2 = T->sca_3;
 T->sca_3 = element;
}

int main(int argc, char* argv[])
{
    ///////////////////////////////////////////
    /// Part 1
    ///////////////////////////////////////////
    char const* const fileName = argv[1];
    FILE* file = fopen(fileName, "r");
    
    int lineSize = 1024; 
    char line[lineSize];

    int previous = -1;
    int current;

    Array a;
    initArray(&a, 5);  // initially 5 elements

    while (fgets(line, sizeof(line), file)) {
        // type cast from string to int
        current = atoi(line);
        // printf("%i\n", current);
        if (current > previous) {
            // printf("%i\n", current);
            insertArray(&a, current);
        }
        previous = current;
    }


    // count the number of elements in the array
    int i=0;
    int length=0;
    while (a.array[i] != '\0'){
        i = i + 1;
        length=length+1;
    }
    int out = length - 1;
    printf("##############################################\n");
    printf("Part 1:\n");
    printf("%i\n", out);
    printf("##############################################\n");

    // free array memory
    fclose(file);
    freeArray(&a);

    ///////////////////////////////////////////
    /// Part 2
    //////////////////////////////////////////
    FILE* file2 = fopen(fileName, "r");
    Array b;
    initArray(&b, 1); // initialise with just 1 element because why not eh?!
    Trio Trio_previous;
    Trio Trio_current;
    Trio_previous.sca_1 = -1;
    Trio_previous.sca_2 = -1;
    Trio_previous.sca_3 = -1;
    Trio_current.sca_1 = -1;
    Trio_current.sca_2 = -1;
    Trio_current.sca_3 = -1;

    i = 0;

    int sum_Trio_previous;
    int sum_Trio_current;

    while (fgets(line, sizeof(line), file2)) {
        current = atoi(line);

        // fill-up Trio_previous first
        if (Trio_previous.sca_1 == -1){
          updateTrio(&Trio_previous, current);
        } else if (i > 3) {
          Trio_previous = Trio_current;
        }
        // fill-up Trio_current one index after the first line of the input file
        if (i > 0){
          updateTrio(&Trio_current, current);
        }
        if (i >= 3){
          sum_Trio_previous = Trio_previous.sca_1 + Trio_previous.sca_2 + Trio_previous.sca_3;
          sum_Trio_current = Trio_current.sca_1 + Trio_current.sca_2 + Trio_current.sca_3;
          if (sum_Trio_current > sum_Trio_previous) {
              insertArray(&b, current);
          }
        }
      i++;
    }

    i = 0;
    length=0;
    while (b.array[i] != '\0'){
        i = i + 1;
        length=length+1;
    }
    out = length;
    printf("##############################################\n");
    printf("Part 2:\n");
    printf("%i\n", out);
    printf("##############################################\n");

    freeArray(&a);
    fclose(file2);


    return 0;
}

// **Compile:**
// gcc aoc-01-code.c -o aoc-01-code
// **Execute:**
// time ./aoc-01-code aoc-01-input.txt