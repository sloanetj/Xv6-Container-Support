#include "types.h"
#include "user.h"
#include "shm.h"



int
main(void)
{

  char* shared_memory_address = shm_get("test");
  *shared_memory_address = 1;

  if (fork() == 0){
    sleep(1000);
    printf(1,"%d\n",*shared_memory_address);
    exit();
  }
  //else{
    *shared_memory_address = 7;
  //  printf(1,"%d\n",*shared_memory_address);

    wait();
  //}
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
