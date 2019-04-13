#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include <math.h>
#include <stdbool.h>

#include "lib.h"

void test_n3tree(FILE *pfile){
    
}

void test_nTable(FILE *pfile){
    
}

char* strings[10] = {"aa","bb","dd","ff","00","zz","cc","ee","gg","hh"};

/** List **/
void test_list(FILE *pfile) {
    char *a, *b, *c;
    list_t* l1;
    // listAddFirst
    fprintf(pfile,"==> listAddFirst");
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listAddLast
    fprintf(pfile,"==> listAddLast");
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listAddLast(l1,strClone("ULTIMO"));
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listAdd
    fprintf(pfile,"==> listAdd");
    l1 = listNew();
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    l1 = listNew();
    listAddFirst(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("ULTIMO"));
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listRemove
    fprintf(pfile,"==> listRemove");
    l1 = listNew();
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++) {
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
        listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    }
    listRemove(l1, strings[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemove(l1, strings[2], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemove(l1, "PRIMERO", (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listRemove(l1, "ULTIMO", (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);/*
    // listRemoveFirst
    fprintf(pfile,"==> listRemove");
    l1 = listNew();
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listRemoveFirst(l1, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
    // listRemoveLast
    /*fprintf(pfile,"==> listRemove");
    l1 = listNew();
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    for(int i=0; i<5;i++)
        listAdd(l1,strClone(strings[i]),(funcCmp_t*)&strCmp);
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listAddFirst(l1,strClone("PRIMERO"));
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listAddLast(l1,strClone("ULTIMO"));
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);
	l1 = listNew();
	listAddFirst(l1,strClone("PRIMERO"));
	listAddLast(l1,strClone("PRIMERO"));
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
    listRemoveLast(l1, (funcDelete_t*)&strDelete);
	listPrint(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);*/
/*
    l1 = listNew();
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddFirst(l1,strClone(strings[0]));
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddFirst(l1,strClone("PRIMERO"));
    listAddFirst(l1,strClone("PRIMERO"));
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddFirst(l1,strClone("PRIMERO"));
    listRemove(l1, strings[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddFirst(l1,strClone("PRIMERO"));
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listRemove(l1, strings[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddLast(l1,strClone("PRIMERO"));
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddLast(l1,strClone("PRIMERO"));
    listAddLast(l1,strClone("PRIMERO"));
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddLast(l1,strClone("PRIMERO"));
    listRemove(l1, strings[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listAddLast(l1,strClone("PRIMERO"));
    listRemove(l1, strings[0], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listRemove(l1, strings[1], (funcCmp_t*)&strCmp, (funcDelete_t*)&strDelete);
    listPrintReverse(l1,pfile,(funcPrint_t*)&strPrint); fprintf(pfile,"\n");
    listDelete(l1,(funcDelete_t*)&strDelete);*/
}

int main (void){
    FILE *pfile = fopen("salida.caso.propios.txt","w");
    //test_n3tree(pfile);
    //test_nTable(pfile);
    test_list(pfile);
    fclose(pfile);
    return 0;
}


