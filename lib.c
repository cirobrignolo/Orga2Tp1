#include "lib.h"

/** STRING **/

char* strRange(char* a, uint32_t i, uint32_t f) {
	uint32_t len = strLen(a);
	if (i > f){
		i=0;
		f=len;
	} else if (i > len){
		i = f;
	} else if (f > len){
		f = len;
	}
	len = f-i;
	len += 2; //f  es inclusive entonce (f+1) + i + 1 para el 0
	char* res = malloc(len);
	int c = 0;
	for (uint32_t j=i; j <= f; j++){
		*(res+c) = *(a+j);
		c++;
	}
	*(res+c) = 0;
	free (a);
	return res;
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
/*
void n3treePrintAux(n3treeElem_t** t, FILE *pFile, funcPrint_t* fp) { //es doble puntero
	char* espacio = " ";

	if (*t != NULL) {
		struct n3treeElem_t* izquierda = &(*t)->left;
		n3treePrintAux(izquierda,pFile,fp);
		if (fp != 0){
        	(*fp)((*t)->data, pFile);
    	} else {
        	fprintf(pFile, "%p", (*t)->data);
    	}
    	struct list_t* lista = (*t)->center;
    	if (lista != NULL){
    		listPrint(lista,pFile,fp);
    	}
    	if (fp != 0){
        	(*fp)(espacio, pFile);
    	} else {
        	fprintf(pFile, "%s", espacio);
    	}
    	struct n3treeElem_t* derecha = &(*t)->right;
		n3treePrintAux(derecha,pFile,fp);
	}
}

void n3treePrint(n3tree_t* t, FILE *pFile, funcPrint_t* fp) {
	char* menor = "<";
	char* mayor = ">";
	char* espacio = " ";

	if (fp != 0){
        (*fp)(menor, pFile);
        (*fp)(menor, pFile);
        (*fp)(espacio, pFile);
    } else {
        fprintf(pFile, "%s", menor);
        fprintf(pFile, "%s", menor);
        fprintf(pFile, "%s", espacio);
    }

    struct n3treeElem_t* primero = &t->first;
    n3treePrintAux(primero,pFile,fp);

    if (fp != 0){
        (*fp)(mayor, pFile);
        (*fp)(mayor, pFile);
    } else {
        fprintf(pFile, "%s", mayor);
        fprintf(pFile, "%s", mayor);
    }

}*/



void n3treePrintAux(n3treeElem_t** t, FILE *pFile,funcPrint_t* fp) {

	if (*t != NULL){
		char* whitespace = malloc(2); 
		*whitespace = ' '; 
		*(whitespace + 1) = '\0';
		n3treeElem_t* current = (*t);
		n3treeElem_t** left = &(*t)->left;
		n3treeElem_t** right = &(*t)->right;

		n3treePrintAux(left, pFile, fp);
		
		if (fp){
			(*fp)(current->data, pFile);
		}else{ 
			fprintf(pFile, "%p", current->data);
		}

		bool emptyList = current->center->first == NULL;
		
		if (!emptyList){
			listPrint(current->center, pFile, fp);
		}

		if (fp){
			(*fp)(whitespace, pFile);
		}else{ 
			fprintf(pFile, "%s", whitespace);
		}
	
		n3treePrintAux(right, pFile, fp);
		
		free(whitespace);
	}
}



void n3treePrint(n3tree_t* t, FILE *pFile,funcPrint_t* fp) {
	char* openSB = malloc(2); 
	*openSB = '[';
 	*(openSB + 1) = '\0';

	char* closeSB = malloc(2); 
	*closeSB = ']'; 
	*(closeSB + 1) = '\0';
	
	char* comma = malloc(2);
	 *comma = ','; 
	 *(comma + 1) = '\0';
	
	char* openDAB = malloc(4);
	 *openDAB = '<';
	 *(openDAB + 1) = '<';
	  *(openDAB + 2) = ' ';
	   *(openDAB + 3) = '\0';
	
	char* closeDAB = malloc(3);
	 *closeDAB = '>'; 
	 *(closeDAB + 1) = '>'; 
	 *(closeDAB + 2) = '\0';
	
	
	fprintf(pFile, "%s", openDAB);
	
	n3treePrintAux(&t->first, pFile, fp);
	
	fprintf(pFile, "%s", closeDAB);
	
	
	free(openSB); 
	free(closeSB); 
	free(comma); 
	free(openDAB); 
	free(closeDAB);

}


/** nTable **/

void nTableRemoveAll(nTable_t* t, void* data, funcCmp_t* fc, funcDelete_t* fd) {
	uint32_t i = 0;
	while(i < t->size){
		nTableRemoveSlot(t,i,data,fc,fd);
		i++;
	}
	return;
}

void nTablePrint(nTable_t* t, FILE *pFile, funcPrint_t* fp) {
	char* espacioIgual = " = ";
	uint32_t i = 0;
	while(i < t->size){
		fprintf(pFile, "%d" "%s", i, espacioIgual);
		listPrint(t->listArray[i], pFile, fp);
		fprintf(pFile, "\n");
		i++;
	}

	return;
}
