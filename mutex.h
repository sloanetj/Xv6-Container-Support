#define MUX_MAXNUM 20

int mutex_create(char *name);
void mutex_delete(int muxid);

void mutex_lock(int muxid); 
void mutex_unlock(int muxid);