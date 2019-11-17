#include "types.h"
#include "user.h"
#include "printf.h"
#include "mutex.h"
#include "cv.h"

int main(){
	int id;
	int i;
	int j;

	id = mutex_create("mux1");
	
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

	// test delete
	// if (!mutex_delete(id)){
	// 	printf(1,"DELETE FAILURE\n");
	// 	exit();
	// }
	// if (!mutex_lock(id)){
	// 	printf(1,"DELETE SUCCESS\n");
	// 	exit();
	// }


	// test cv's
	int muxid = mutex_create("cv test");
	if (fork() == 0){
		
		if (!mutex_lock(muxid)){
			printf(1,"SIGNAL LOCK FAILURE\n");
			exit();
		}
		while (!cv_signal(muxid)){
		}
		if (!mutex_unlock(muxid)){
			printf(1,"SIGNAL UNLOCK FAILURE\n");
			exit();
		}
		exit();
	}
	if (!mutex_lock(muxid)){
		printf(1,"LOCK FAILURE\n");
		exit();
	}
	if (!cv_wait(muxid)){
		printf(1,"CV WAIT FAILURE\n");
		exit();
	}
	wait();
	printf(1,"CV SUCCESS\n");

	exit();
}

int mutex_create(char *name){
	return mcreate(name);
}
int mutex_delete(int muxid){
	return mdelete(muxid);
}
int mutex_lock(int muxid){
	return mlock(muxid);
}
int mutex_unlock(int muxid){
	return munlock(muxid);
}

int cv_wait(int muxid){
	return waitcv(muxid);
}
int cv_signal(int muxid){
	return signalcv(muxid);
}