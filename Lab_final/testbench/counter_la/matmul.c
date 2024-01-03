#include "matmul.h"

int* __attribute__ ((section(".mprjram"))) matmul()
{
  for (int i = 0; i < SIZE * SIZE; i++)
  {
    result[i] = reg_y;
  }
  return result;
}
