#define SHM_MAXNUM  32  //max shared memory
#define NULL  0  //max shared memory

struct shm_pg{
  uint allocated; //boolean to tell if its allocated alread
  char* name;
  char*  pa; //pa
  //char*  vas;  //va
  uint ref_count; //tracks how many processes have the shared page mapped into them
};

char *shm_get(char *name);
int   shm_rem(char *name);
