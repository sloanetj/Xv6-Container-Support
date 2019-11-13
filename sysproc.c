#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

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
(mutex is available), set mutex fields, return 
index or -1 if full */
int 
sys_mcreate(char *name){

	argptr(0, (void*)&name, sizeof(*name));
	int i;

	for (i=0; i<MUX_MAXNUM; i++){
		if (MUTEXES[i].name == 0){
			MUTEXES[i].name = name;
			MUTEXES[i].state = 0;
			return i;
		}
	}
	return -1;
}

int
sys_mdelete(int muxid){
	return -1;
}
int
sys_mlock(int muxid){
	return -1;
}
int
sys_munlock(int muxid){
	return -1;
}

