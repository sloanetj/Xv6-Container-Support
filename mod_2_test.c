#include "types.h"
#include "user.h"
#include "shm.h"



int
main(void)
{


  // char* shared_memory_address2 = shm_get("test2");
  //
  // *shared_memory_address2 = 9;
  //
  //  printf(1, "   %d     ", *shared_memory_address2);
  //
  //  //shm_rem("test2");
  //
  //
  // printf(1, " MADE IT\n");
  // exit();



  char* shared_memory_address1 = shm_get("test1");
  *shared_memory_address1 = 4;
  if(fork() == 0)
  {
    shared_memory_address1 = shm_get("test1");
    //printf(1, "   %x     ", shared_memory_address1);
    *shared_memory_address1 = 7;
    //printf(1, "  %d   \n", *shared_memory_address1);
    exit();

  }
  // else
  // {
  //   //
  //   // shared_memory_address1 = shm_get("test1");
  //   // printf(1, "  %d   \n", *shared_memory_address1);
  // }
  printf(1, "  %d   \n", *shared_memory_address1);
  wait();

   exit();
}

// char* shared_memory_address1 = shm_get("test1");
//
// printf(1, "   %x     ", shared_memory_address1);
//
// shm_rem("test1");
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


//
//   char* shared_memory_address = shm_get("test");
//
//
// //  shm_get("test");
//
//   int test = 6;
//   *shared_memory_address = test;
//
//   int child = fork();
//
//   if (child == 0){
//     sleep(100);
//     *shared_memory_address -= 1;
//     exit();
//   }
//   wait();
//
//   printf(1, "    %d  \n", *shared_memory_address);
//
//





//
// char* shared_memory_address = shm_get("test");
//
// *shared_memory_address = 1;
//
// if (fork() == 0){
// //  sleep(100);
//  *shared_memory_address = 7;
// //  wait();
//   exit();
// }
// //else{
// printf(1,"%d\n",**shared_memory_address);
//
//
//   //wait();
// //}
// exit();










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
