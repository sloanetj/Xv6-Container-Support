#include "types.h"
#include "user.h"
#include "printf.h"
#include "mutex.h"

int main(){
	int id;
	int i;
	int j;

	id = mutex_create("mux1");
	
	// TRY USING PIPES INSTEAD - DIFFERENT PROCESSES MAY HAVE DIFFERENT KERNEL STACKS
	for(i=0; i<5; i++){
		if (fork() == 0){
			if (!mutex_lock(id)){
				printf(1,"LOCK FAILURE\n");
				exit();
			}
			for(j=1; j<4; j++){
				printf(1,"%d\n", j);
			}
			printf(1,"\n");
			if (!mutex_unlock(id)){
				printf(1,"UNLOCK FAILURE\n");
			}
		
			exit();
		}
	}

	for(i=0; i<10; i++){
		wait();
	}

	exit();
}

int mutex_create(char *name){
	return mcreate(name);
}
int mutex_lock(int muxid){
	return mlock(muxid);
}
int mutex_unlock(int muxid){
	return munlock(muxid);
}