#include "types.h"
#include "user.h"
#include "shm.h"



int
main(void)
{

  char* shared_memory_address = shm_get("test");

//  shm_get("test");

  int test = 1;
  *shared_memory_address = test;

  if (fork() == 0){
    //char* shared_memory_address2 = shared_memory_address1;
    *shared_memory_address -= 1;
    printf(1, "    %d  \n", *shared_memory_address);
    exit();
  }
  wait();

  exit();
}














// printf(1, "   %x     ", shared_memory_address1);
//
// shm_rem("test");
//
//
//
//
// char* shared_memory_address2 = shm_get("test2");
//
//
//  printf(1, "   %x     ", shared_memory_address2);
//
//  shm_rem("test2");
//
//
// printf(1, " MADE IT\n");
