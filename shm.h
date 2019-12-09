#define SHM_MAXNUM  32  //max shared memory
#define NULL  (void*)-1  //max shared memory

struct shm_pg{
  uint allocated; //boolean to tell if its allocated alread
  char* name;
  char*  pa; //pa
  uint ref_count; //tracks how many processes have the shared page mapped into them
};

struct {
	uint initialized; //0 if not initialized, 1 if initialized
	struct shm_pg pages[SHM_MAXNUM];
} shmtable;

char *shm_get(char *name);
int   shm_rem(char *name);
