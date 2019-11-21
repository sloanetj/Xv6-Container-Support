#include "types.h"
#include "user.h"
#include "shm.h"



int
main(void)
{

  char* shared_memory_address1 = shm_get("test");

  // int test = 1;
  // *shared_memory_address1 = test;

  // if (fork() == 0){
  //   char* shared_memory_address2 = shm_get("Test");
  //   *shared_memory_address2 -= 1;
  //   exit();
  // }
  //wait();
  printf(1,shared_memory_address1);

  exit();
}
