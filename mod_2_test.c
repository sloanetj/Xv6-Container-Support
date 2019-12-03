#include "types.h"
#include "user.h"
#include "shm.h"



int
main(void)
{

  char* shared_memory_address1 = shm_get("test");


   printf(1, "   %x     ", shared_memory_address1);

   shm_rem("test");


   char* shared_memory_address2 = shm_get("test2");


    printf(1, "   %x     ", shared_memory_address2);

    shm_rem("test2");

  exit();
}
