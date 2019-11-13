#include "types.h"
#include "user.h"
#include "printf.h"
#include "mutex.h"

int main(){
	int mux_id;

	mux_id = mutex_create("mux1");
	printf(1,"%d\n", mux_id);

	mux_id = mutex_create("mux2");
	printf(1,"%d\n", mux_id);

	exit();
}

int mutex_create(char *name){
	return mcreate(name);
}