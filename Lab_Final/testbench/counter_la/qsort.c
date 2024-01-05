#include "qsort.h"

int __attribute__ ( ( section ( ".mprjram" ) ) ) partition(int low,int hi){
	int pivot = array[hi];
	int i = low-1;
	for (int j = low; j < hi; j++){
		if (array[j] < pivot){
			i = i+1;
			int temp = array[i];
			array[i] = array[j];
			array[j] = temp;
		}
	}
	if (array[hi] < array[i+1]){
		int temp = array[i+1];
		array[i+1] = array[hi];
		array[hi] = temp;
	}
	return i+1;
}

void __attribute__ ( ( section ( ".mprjram" ) ) ) sort(int low, int hi){
	if (low < hi){
		int p = partition(low, hi);
		sort(low, p-1);
		sort(p+1, hi);
	}
}

int* __attribute__ ( ( section ( ".mprjram" ) ) ) qsort(){
	sort(0,SIZE-1);
	return array;
}
