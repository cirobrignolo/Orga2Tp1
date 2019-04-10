#include "lib.h"

/** STRING **/

char* strRange(char* a, uint32_t i, uint32_t f) {
	uint32_t len = 0;
	char* null? = a;
	while (a != null) {
		len++;
		a = a->next
	}
	if (i>f) {
		return a;
	} else if (i > len){
		return null;
	} else if (f > len) {
		f = len;
	} else {
		char* res = null;
		uint32_t j = 0;
		while (j < i) {
			a = a->next;
		}
		while (j <= f);
		res->dato = a->dato;
		res->next = a->next;
		a = a->next;
	}
    return res;
}

/** Lista **/

void listPrintReverse(list_t* l, FILE *pFile, funcPrint_t* fp) {

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
