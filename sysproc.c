#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int pq_enqueue(struct proc *p);
struct proc* pq_dequeue();

int
sys_fork(void)
{
	return fork();
}

int
sys_exit(void)
{
	exit();
	return 0; // not reached
}

int
sys_wait(void)
{
	return wait();
}

int
sys_kill(void)
{
	int pid;

	if (argint(0, &pid) < 0) return -1;
	return kill(pid);
}

int
sys_getpid(void)
{
	return myproc()->pid;
}

int
sys_sbrk(void)
{
	int addr;
	int n;

	if (argint(0, &n) < 0) return -1;
	addr = myproc()->sz;
	if (growproc(n) < 0) return -1;
	return addr;
}

int
sys_sleep(void)
{
	int  n;
	uint ticks0;

	if (argint(0, &n) < 0) return -1;
	acquire(&tickslock);
	ticks0 = ticks;
	while (ticks - ticks0 < n) {
		if (myproc()->killed) {
			release(&tickslock);
			return -1;
		}
		sleep(&ticks, &tickslock);
	}
	release(&tickslock);
	return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
	uint xticks;

	acquire(&tickslock);
	xticks = ticks;
	release(&tickslock);
	return xticks;
}


/* Iterate throught the global array of mutexes.
find the index of the first 'empty mutex' 
(mutex is available), set mutex fields, initialize 
this process's reference to the mutex, return 
index/mutexid or -1 if full */
int 
sys_mcreate(char *name){

	argptr(0,(void*)&name,sizeof(*name));
	struct proc *p = myproc();
	int i;

	acquire(&MUTEXES.lock);
	for (i=0; i<MUX_MAXNUM; i++){
		if (MUTEXES.muxes[i].name == 0){
			// set mutex fields
			MUTEXES.muxes[i].name = name;
			MUTEXES.muxes[i].state = 0;

			// initialize process reference
			p->mux_ptrs[i] = &MUTEXES.muxes[i];

			release(&MUTEXES.lock);
			return i;
		}
	}
	release(&MUTEXES.lock);
	return -1;
}

int
sys_mdelete(int muxid){
	
	argint(0,(int*)&muxid);
	struct proc *curproc = myproc();
	struct proc *p;

	// verify we have access to this mutex
	if (curproc->mux_ptrs[muxid] == 0){
		return 0;
	}

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if (p != curproc && p->mux_ptrs[muxid] != 0){
			goto rmptr;
		}			
	} // if we made it here, we are the only process with access to this mutex

	// atomically set global mutex to empty state
	acquire(&MUTEXES.lock);
	curproc->mux_ptrs[muxid]->name = 0;
	curproc->mux_ptrs[muxid]->state = -1;
	release(&MUTEXES.lock);

	// remove reference to mutex
	curproc->mux_ptrs[muxid] = 0;
	return 1;


rmptr:
	// remove this process's reference to mutex
	curproc->mux_ptrs[muxid] = 0;
	return 1;
}


int
sys_mlock(int muxid){

	argint(0,(int*)&muxid);
	struct proc *p = myproc();
	int i;

	// verify this process has access to this mutex
	if (p->mux_ptrs[muxid] == 0){
		return 0;
	}

	acquire(&MUTEXES.lock);
	while (p->mux_ptrs[muxid]->state == 1){ // lock taken, block waiting for your turn

		//cprintf("A\n");

		/* atomically enqueue myself into wait queue
		if this process is already on the wait queue, do not add it again */
		acquire(&wqueue.lock);
		for (i=0; i<1000; i++){
			if (wqueue.queue[i] == p){
				break;
			}
			if (wqueue.queue[i] == 0){
				wqueue.queue[i] = p;
				break;
			}
		}
		release(&wqueue.lock);
		if (i == 1000){
			// wait queue is full
			return 0;
		}
		
		// put myself to sleep and call scheduler
		release(&MUTEXES.lock);
		acquire(&ptable.lock);
		p->state = SLEEPING;
		sched();
		release(&ptable.lock);

		acquire(&MUTEXES.lock);
	}

	// lock available, take the lock
	p->mux_ptrs[muxid]->state = 1;
	release(&MUTEXES.lock);
	return 1;
}

int
sys_munlock(int muxid){

	argint(0,(int*)&muxid);
	struct proc *p, *sleepy_proc;
	p = myproc();
	int i;


	/* verify this process has access to this mutex
	and make sure proc is currently holding this mutex*/
	if (p->mux_ptrs[muxid] == 0 || p->mux_ptrs[muxid]->state != 1){
		return 0;
	}
	
	// set lock state to available
	acquire(&MUTEXES.lock);
	p->mux_ptrs[muxid]->state = 0;
	release(&MUTEXES.lock);

	// atomically dequeue process from wait queue and wake it up
	acquire(&wqueue.lock);
	sleepy_proc = wqueue.queue[0];
	// if the queue is empty we are done
	if (sleepy_proc == 0){
		release(&wqueue.lock);
		return 1;
	}
	for (i=0; i<999; i++){
		wqueue.queue[i] = wqueue.queue[i+1];
	}
	wqueue.queue[999] = 0;
	release(&wqueue.lock);

	acquire(&ptable.lock);
	sleepy_proc->state = RUNNABLE;
	if (pq_enqueue(sleepy_proc) < 0){
		// queue is full
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
	}
	release(&ptable.lock);

	return 1;
}


int
sys_waitcv(int muxid){

	argint(0,(int*)&muxid);
	struct proc *p = myproc();
	int i;

	/* atomically enqueue proc to mux's cv wait queue if this 
	process is already on the wait queue, do not add it again */
	acquire(&MUTEXES.lock);
	for (i=0; i<1000; i++){
		if (p->mux_ptrs[muxid]->cv[i] == p){
			break;
		}
		if (p->mux_ptrs[muxid]->cv[i] == 0){
			p->mux_ptrs[muxid]->cv[i] = p;
			break;
		}
	}
	release(&MUTEXES.lock);
	if (i == 1000){
		// cv wait queue is full
		return 0;
	}
	
	// sleep self and call scheduler
	acquire(&ptable.lock);
	p->state = SLEEPING;
	// release mutex
	if (!sys_munlock(muxid)){
		return 0;
	}
	sched();
	release(&ptable.lock);

	// take mutex
	if (!sys_mlock(muxid)){
		return 0;
	}
	return 1;

}
int 
sys_signalcv(int muxid){

	argint(0,(int*)&muxid);
	struct proc *p, *sleepy_proc; 
	p = myproc();
	int i;

	/* verify this process has access to this mutex
	and make sure proc is currently holding this mutex*/
	if (p->mux_ptrs[muxid] == 0 || p->mux_ptrs[muxid]->state != 1){
		return 0;
	}

	// atomically dequeue proc from mux's cv wait queue
	acquire(&MUTEXES.lock);
	sleepy_proc = p->mux_ptrs[muxid]->cv[0];
	if (sleepy_proc == 0){
		release(&MUTEXES.lock);
		return 0;
	}
	for (i=0; i<999; i++){
		p->mux_ptrs[muxid]->cv[i] = p->mux_ptrs[muxid]->cv[i+1];
	}
	p->mux_ptrs[muxid]->cv[999] = 0;
	release(&MUTEXES.lock);

	// wake up proc 
	acquire(&ptable.lock);
	sleepy_proc->state = RUNNABLE;
	if (pq_enqueue(sleepy_proc) < 0){
		// queue is full
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
	}
	release(&ptable.lock);

	return 1;
}


/* attempts to set the priority of the process identified by pid to priority. 
The priority of the initial process was already set to 0 (highest priority), 
and all child processes inherit the priority level of parent*/
int 
sys_prio_set(int pid, int priority){

	argint(0,(int*)&pid);	
	argint(1,(int*)&priority);
	struct proc *curproc = myproc();
	struct proc *p;

	//temporarily
	//cprintf("%d\n", curproc->priority);

	if (priority >= PRIO_MAX){
		// invalid priority
		return -1;
	}

	// quick-exit case 1: process is trying to set priority above its own
	if (priority < curproc->priority){
		return -1;
	}
	// quick-exit case 2: pid refers to this process
	if (curproc->pid == pid){
		curproc->priority = priority;
		return 1;
	}


	// validate that the pid process is in ancestry of current process:
	// search through proc table until we find process with pid
	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		if (p != curproc && p->pid == pid){
			break;
		}
	}
	if (p >= &ptable.proc[NPROC]){
		// this pid doesnt exist
		release(&ptable.lock);
		return -1;
	}
	// search down it's parent links until we either find the current proc, or we reach pid <= 1
	int found = 0;
	struct proc *i = p->parent;
	while (i->pid > 1){
		if (i == curproc){
			found = 1;
			break;
		}
		i = i->parent;
	}
	if (found){
		p->priority = priority;
	} else{
		// this process is not in your ancestry
		release(&ptable.lock);
		return -1;
	}
	release(&ptable.lock);
	return 1;
}

// user forks a bunch of children, sets varying priority levels, and calls this function for each of them
void
sys_testpqeq(){

	acquire(&ptable.lock);
	struct proc *p = myproc();
	
	int priority = p->priority;
	char prio_char = (char)(priority+47);
	p->name[0] = prio_char; 
	p->name[1] = '\0';

	// enqueue 
	pq_enqueue(p);
	release(&ptable.lock);



}

// after user enqueued a bunch of procs using the above function, dequeue them all and observe the order
void
sys_testpqdq(){

	struct proc *p = pq_dequeue();
	int count = 0;
	while (count < 3){

		if (p->name[0] == '1'){
			cprintf("%s\n", p->name);
			count++;
		}
		else if (p->name[0] == '2'){
			cprintf("%s\n", p->name);
			count++;
		}
		else if (p->name[0] == '3'){
			cprintf("%s\n", p->name);
			count++;
		}

		p = pq_dequeue();
	}
	
	
}