#include "mutex.h"
#define PRIO_MAX 20
#define QSIZE 100
#define NULL ((void*)-1)


/* mutex contains the name given at creation, and the state of the mutex: 
1 if taken, 0 if not taken. Additionally, each mutex has a condition variable
wait queue associated with it - used in sending/recieving requests to/from CM */
struct mutex {
	char *name;
	int state;

	struct proc *cv[1000];
};

/* global array contains all the mutexes indexed by the mutex id returned at 
creation and a lock for atomic read/writes */
struct mutex_table {
	struct spinlock lock; 
	struct mutex muxes[MUX_MAXNUM];
};
struct mutex_table MUTEXES;

// Per-CPU state
struct cpu {
	uchar            apicid;     // Local APIC ID
	struct context * scheduler;  // swtch() here to enter scheduler
	struct taskstate ts;         // Used by x86 to find stack for interrupt
	struct segdesc   gdt[NSEGS]; // x86 global descriptor table
	volatile uint    started;    // Has the CPU started?
	int              ncli;       // Depth of pushcli nesting.
	int              intena;     // Were interrupts enabled before pushcli?
	struct proc *    proc;       // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int        ncpu;

// PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
	uint edi;
	uint esi;
	uint ebx;
	uint ebp;
	uint eip;
};

enum procstate
{
	UNUSED,
	EMBRYO,
	SLEEPING,
	RUNNABLE,
	RUNNING,
	ZOMBIE
};

#define SHM_MAXNUM  32  //max shared memory
// Per-process state
// MODIFIED TO INCLUDE MUTEX-REFERECNE TABLE
struct proc {
	uint              sz;            // Size of process memory (bytes)
	pde_t *           pgdir;         // Page table
	char *            kstack;        // Bottom of kernel stack for this process
	enum procstate    state;         // Process state
	int               pid;           // Process ID
	struct proc *     parent;        // Parent process
	struct trapframe *tf;            // Trap frame for current syscall
	struct context *  context;       // swtch() here to run process
	void *            chan;          // If non-zero, sleeping on chan
	int               killed;        // If non-zero, have been killed
	struct file *     ofile[NOFILE]; // Open files
	struct inode *    cwd;           // Current directory
	char              name[16];      // Process name (debugging)

	/* array indexed by mutex id. If the process has access to a 
	particular mutex, the pointer at a the corresponding index
	points to the mutex in the global array. If the process does 
	not have access, the corresponding pointer in the array is 
	0 (null). */
	struct mutex *	  mux_ptrs[MUX_MAXNUM];	

	// priority of proccess, range 0-PRIO_MAX
	uint priority;
	
	struct shm_pg*     shmpgs[SHM_MAXNUM];


};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap



/* wait queue used for unblocking processes waiting to take a mutex, really just an 
array, of static size. i.e. maximum of 1000 processes can wait on a mutex */
struct wait_queue {
	struct spinlock lock;
	struct proc *queue[1000];
};
struct wait_queue wqueue;


struct {
	struct spinlock lock;
	struct proc     proc[NPROC];

	// head and tail indicies for each queue
	// head_tail[0] = head
	// head_tail[1] = tail
	int head_tail[PRIO_MAX][2];

	// array of priority queues, where each sub-array is a queue of same-priority procs
	struct proc *pqueues[PRIO_MAX][QSIZE];
} ptable;

