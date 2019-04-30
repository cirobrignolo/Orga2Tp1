#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <stdbool.h>

#include "lib.h"

char* strings[10] = {"aa","bb","dd","ff","00","zz","cc","ee","gg","hh"};

/** nTable **/
void test_nTable(FILE *pfile) {
    char *a, *b, *c;
    nTable_t *n;
    // nTableAdd
    fprintf(pfile,"==> nTableAdd");
    n = nTableNew(2);
    for(int s=0;s<2;s++) {
        for(int i=0;i<10;i++) {
            nTableAdd(n, s, strClone(strings[i]), (funcCmp_t*)&strCmp);}}
    // nTableRemoveSlot
    fprintf(pfile,"==> nTableRemoveSlot");
    for(int i=0;i<2;i++) {
        a = strClone(strings[i]);
        nTableRemoveSlot(n,i,a,(funcCmp_t*)&strCmp,(funcDelete_t*)&strDelete);
        strDelete(a);}
    // nTableRemoveAll
    fprintf(pfile,"==> nTableRemoveAll");
    for(int i=0;i<2;i++) {
        a = strClone(strings[i]);
        nTableRemoveAll(n,a,(funcCmp_t*)&strCmp,(funcDelete_t*)&strDelete);
        strDelete(a);}
    // nTableDeleteSlot
    fprintf(pfile,"==> nTableDeleteSlot");
    for(int i=0;i<0;i++) {
        nTableDeleteSlot(n,i,(funcDelete_t*)&strDelete);}
    nTablePrint(n,pfile,(funcPrint_t*)&strPrint);
    nTableDelete(n,(funcDelete_t*)&strDelete);
}


int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    //test_strings(pfile);
    //test_list(pfile);
    //test_n3Tree(pfile);
    test_nTable(pfile);
    fclose(pfile);
    return 0;
}


