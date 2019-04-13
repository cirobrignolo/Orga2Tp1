#include "lib.h"

/** STRING **/

char* strRange(char* a, uint32_t i, uint32_t f) {
	uint32_t len = strLen(a);
	if (i > f) {
		i=0;
		f=len;
	} else if (i > len){
		i = f;
	} else if (f > len) {
		f = len;
	}
	len = f-i;
	len += 2; //f  es inclusive entonce (f+1) + i + 1 para el 0
	char* result = malloc(len);
	int c = 0;
	for (uint32_t j=i; j <= f; j++)
	{
		*(result + c) = *(a +  j);
		c++;
	}
	*(result + c) = 0;
	free (a);
	return result;
}

/** Lista **/

void listPrintReverse(list_t* l, FILE *pFile, funcPrint_t* fp) {
	char* corcheteAbierto = "["; 
	char* corcheteCerrado = "]"; 
	char* coma = ",";

    if (fp != 0){
        (*fp)(corcheteAbierto, pFile);
    } else {
        fprintf(pFile, "%s", corcheteAbierto);
    }

    struct s_listElem* nodo = l->last;
    while (nodo){
        struct s_listElem* anterior = nodo->prev;
        if (fp != 0){
        	(*fp)(nodo->data, pFile);
    	} else {
        	fprintf(pFile, "%p", nodo->data);
    	}
        if (anterior != NULL){
        	if (fp){
                (*fp)(coma, pFile);
            }else{
                fprintf(pFile, "%s", coma);
            }
        }
        nodo = anterior; 
    }
    
    if (fp != 0){
        (*fp)(corcheteCerrado, pFile);
    } else {
        fprintf(pFile, "%s", corcheteCerrado);
    }
}


/** n3tree **/

void n3treePrintAux(n3treeElem_t** t, FILE *pFile, funcPrint_t* fp) {

}

void n3treePrint(n3tree_t* t, FILE *pFile, funcPrint_t* fp) {

}

/** nTable **/

void nTableRemoveAll(nTable_t* t, void* data, funcCmp_t* fc, funcDelete_t* fd) {

}

void nTablePrint(nTable_t* t, FILE *pFile, funcPrint_t* fp) {

}
