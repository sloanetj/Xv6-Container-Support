#include "types.h"
#include "user.h"
#include "printf.h"
#include "mutex.h"
#include "cv.h"

#define PRIO_MAX 10
#define QSIZE 100
#define NULL ((void*)-1)
	
struct myproc {
	int priority;
	char * name;	
};

int head_tail[PRIO_MAX][2];
struct myproc *pqueues[PRIO_MAX][QSIZE];


void init_queue(){
	// initialize all pqueues to empty
	int m, n;
	for (m=0; m<PRIO_MAX; m++){
		for (n=0; n<2; n++){
			head_tail[m][n] = 0;
		}
	}
}

int 
pq_enqueue (struct myproc *p){

	int priority = p->priority;
	int head = head_tail[priority][0];
	int tail = head_tail[priority][1];

	if (tail == ((head-1)%QSIZE)){
		// queue is full
		return -1;
	}

	//update tail
	pqueues[priority][tail] = p;
	head_tail[priority][1] = (tail+1)%QSIZE;


	// TEMPORARILY: print out contents of this queue
	// printf(1,"head index of pqueue %d = %d\n", priority, head);
	// printf(1,"tail index of pqueue %d = %d\n", priority, head_tail[priority][1]);
	// printf(1,"contents of pqueue %d:\n", priority);
	// int i = head;
	// while (i < head_tail[priority][1] && i < QSIZE){
	// 	printf(1,"%s ", pqueues[priority][i]->name);
	// 	//printf(1,"! ");
	// 	i++;
	// }
	// printf(1,"\n");

	return 1;
}

struct myproc*
pq_dequeue(){
	// go to highest priority, non-empty queue 
	int priority = 0;
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
		priority++;

	if (priority >= PRIO_MAX){
		// all queues are empty
		printf(1,"all queues are empty\n");
		return NULL;
	}

	// get proc
	int head = head_tail[priority][0];
	struct myproc *p = pqueues[priority][head];

	// update head
	head_tail[priority][0] = (head+1)%QSIZE;
	return p;
}

int main(){

	int mux_id = mutex_create("mymux");
	if (fork() == 0){
		mutex_lock(mux_id);
		printf(1, "child: about to exit while holding lock\n");
		exit();
	}
	else{
		wait();
		if (!mutex_lock(mux_id)){
			printf(1,"parent: can't take the lock\n");
		}
		else {
			printf(1,"parent: was able to take the lock\n");
			mutex_unlock(mux_id);
		}
	}

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


	// struct myproc *p0 = (struct myproc*)malloc(sizeof(struct myproc));
	// struct myproc *p1 = (struct myproc*)malloc(sizeof(struct myproc));
	// struct myproc *p2 = (struct myproc*)malloc(sizeof(struct myproc));
	// struct myproc *p3 = (struct myproc*)malloc(sizeof(struct myproc));
	// struct myproc *p4 = (struct myproc*)malloc(sizeof(struct myproc));
	// struct myproc *p5 = (struct myproc*)malloc(sizeof(struct myproc));

	// p0->priority = 0;	p0->name = "proc 0";
	// p1->priority = 1;	p1->name = "proc 1";
	// p2->priority = 2;	p2->name = "proc 2";
	// p3->priority = 3;	p3->name = "proc 3";
	// p4->priority = 4;	p4->name = "proc 4";
	// p5->priority = 0;	p5->name = "proc 5";

	// init_queue();
	// pq_enqueue(p0);
	// pq_enqueue(p1);
	// pq_enqueue(p2);
	// pq_enqueue(p3);
	// pq_enqueue(p4);
	// pq_enqueue(p5);

	// struct myproc *p = pq_dequeue();
	// while (p != NULL){
	// 	printf(1, "%s\n",p->name);
	// 	p = pq_dequeue();
	// }


	// TEST SET PRIORITY

	// //set my priority to a lower value - should work
	// if (prio_set(getpid(), 10) > 0){
	// 	printf(1,"decrease priority: PASSED, should pass\n");
	// } else {
	// 	printf(1,"decrease priority: FAILED, should pass\n");
	// }
	// // try and set by priority to higher value - should fail
	// if (prio_set(getpid(), 0) > 0){
	// 	printf(1,"increase priority: PASSED, should fail\n");
	// } else {
	// 	printf(1,"increase priority: FAILED, should fail\n");
	// }
	
	// int pid = fork();
	// if (pid == 0){
	// 	while(1);
	// } else {
	// 	// fork a child and have parent set the childs priority to be lower - should work
	// 	if (prio_set(pid, 15) > 0){
	// 		printf(1,"decrease child priority: PASSED, should pass\n");
	// 	} else {
	// 		printf(1,"decrease child priority: FAILED, should pass\n");
	// 	}
	// 	// set the child's priority to be equal to parent - should work
	// 	if (prio_set(pid, 10) > 0){
	// 		printf(1,"set child priority to parent priority: PASSED, should pass\n");
	// 	} else {
	// 		printf(1,"set child priority to parent priority: FAILED, should pass\n");
	// 	}
	// 	// set the child's priority to be greater than parent - should fail
	// 	if (prio_set(pid, 1) > 0){
	// 		printf(1,"set child priority above parent: PASSED, should fail\n");
	// 	} else {
	// 		printf(1,"set child priority above parent: FAILED, should fail\n");
	// 	}
	// }
	


	// int id;
	// int i;
	// int j;

	// id = mutex_create("mux1");
	
	// for(i=0; i<5; i++){
	// 	if (fork() == 0){
	// 		if (!mutex_lock(id)){
	// 			printf(1,"LOCK FAILURE\n");
	// 			exit();
	// 		}
	// 		for(j=1; j<4; j++){
	// 			printf(1,"%d\n", j);
	// 		}
	// 		printf(1,"\n");
	// 		if (!mutex_unlock(id)){
	// 			printf(1,"UNLOCK FAILURE\n");
	// 		}
		
	// 		exit();
	// 	}
	// }

	// for(i=0; i<10; i++){
	// 	wait();
	// }

	// test delete
	// if (!mutex_delete(id)){
	// 	printf(1,"DELETE FAILURE\n");
	// 	exit();
	// }
	// if (!mutex_lock(id)){
	// 	printf(1,"DELETE SUCCESS\n");
	// 	exit();
	// }
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