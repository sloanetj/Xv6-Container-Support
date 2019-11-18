#define SHM_MAXNUM  32  //max shared memory


struct shm_pg{
  uint allocated; //boolean to tell if its allocated alread
  char* name;
  char*  addr;
  int  vas;
  uint ref_count; //tracks how many processes have the shared page mapped into them
};

char *shm_get(char *name);
int   shm_rem(char *name);
