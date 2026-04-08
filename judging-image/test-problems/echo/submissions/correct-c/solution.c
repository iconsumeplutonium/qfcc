#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1024

char* strip(char* text) {
    int length = strlen(text);

    // Left Strip
    int start = 0;
    for (int i = 0; i < length; i++) {
        if (!isspace(text[i])) {
            break;
        }

        start++;
    }

    // Right Strip
    int end = length;
    for (int i = 0; i < length; i++) {
        if (!isspace(text[length - 1 - i])) {
            break;
        }

        end--;
    }

    // Empty String
    if (start >= end) {
        return NULL;
    }

    char* buffer = (char*)(malloc(BUFFER_SIZE));
    strcpy(buffer, (text + start));
    buffer[end - start] = 0;

    return buffer;
}

int main() {
    char buffer[BUFFER_SIZE];
    char* result = NULL;

    while (1) {
        result = fgets(buffer, BUFFER_SIZE, stdin);
        if (result == NULL) {
            break;
        }

        result = strip(result);
        if (result != NULL) {
            printf("%s\n", result);
        }
    }

    return 0;
}
