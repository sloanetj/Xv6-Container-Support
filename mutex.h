#define MUX_MAXNUM 20

int mutex_create(char *name);
int mutex_delete(int muxid);

int mutex_lock(int muxid); 
int mutex_unlock(int muxid);