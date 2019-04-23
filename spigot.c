// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
// file:   spigot.c
// goal:   allows user to enter an output file name, then calculates pi
//         using the spigot algorithm and outputs the result to the file.
// *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *spigot();

// **************************************************************
// function: main
// in/ouput: none
// goal:     get user input for filename, write result to file
// **************************************************************
int main(void) {
    
    FILE * fp;
    char filename[200];
    
    printf("\n ------------------------------------");
    printf("\n    WELCOME TO MY SPIGOT ALGORITHM!");
    printf("\n            (C edition)");
    printf("\n    Built with love for CIS*3190");
    printf("\n    By: Maddie Gabriel (0927580)");
    printf("\n ------------------------------------\n\n");
        
    // get custom output filename from user
    printf(" Enter output filename (with extension): ");
    scanf("%s", filename);
    printf("\n ** Please wait while your result is calculating **\n");
    
    // open file
    fp = fopen(filename, "w");
    
    // call function to calculate result and write it to file
    fprintf(fp, "%s", spigot());
    
    // close the file and tell user where to see result
    fclose(fp);
    printf("\n Done! Please see your result in the file: %s\n\n", filename);
    return 0;
}

// **************************************************************
// function: spigot
// input:    none
// output:   string containing pi result
// goal:     calculate pi result and write to result string
// **************************************************************
char *spigot() {

    int i, j, k, q, x = 0;
    int len, nines = 0, predigit = 0;
    int precision = 1001;
    char buff[10];
    static char res[2000];

    // calculate array length and create empty array
    len = (10 * precision/3) + 1;
    int a[len];

    // initialize array with all 2's
    for (i=0; i<len; i=i+1) {
        a[i] = 2;
    }

    // repeat calculation loop 'precision' times - depends on desired precision
    for (j=1; j<=precision; j=j+1) {
        q = 0;

        // calculate q
        for (i=len; i>0; i=i-1) {
           x = 10 * a[i-1] + q * i;
           a[i-1] = x % (2 * i - 1);
           q = x / (2 * i - 1);
        }

        a[0] = q % 10;
        q = q / 10;

        // append different digits based on q value
        if (q == 9) {
            // if q is 9, increment nines counter
            nines = nines + 1;
        } else if (q == 10) {
             // if q is 10 (overflow case), write 9 then predigit + 1
            sprintf(buff, "%d", predigit + 1);
            strcat(res, buff);

            for (k=0; k<nines; k=k+1) {
                sprintf(buff, "%d", 0);
                strcat(res, buff);
            }

            predigit = 0;
            nines = 0;
        } else {
            // if q is not 9 or 10, print predigit
            sprintf(buff, "%d", predigit);
            strcat(res, buff);

            // advance predigit to next q
            predigit = q;

            // handle nines which were tracked
            if (nines != 0) {
                for (k=0; k<nines; k=k+1) {
                    sprintf(buff, "%d", 9);
                    strcat(res, buff);
                }
                nines = 0;
            }
        }
    }

    // add the final digit
    sprintf(buff, "%d9", predigit);
    strcat(res, buff);
    
    // return the pi result in string format
    return res;
}
