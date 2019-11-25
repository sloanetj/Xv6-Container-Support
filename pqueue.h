#define PRIO_MAX 20
#define QSIZE 100


// // head and tail indicies for each queue
// // head_tail[0] = head
// // head_tail[1] = tail
// int head_tail[PRIO_MAX][2];

// // array of priority queues, where each sub-array is a queue of same-priority procs
// struct proc *pqueues[PRIO_MAX][QSIZE];


// int 
// pq_enqueue (struct proc *p){

// 	int priority = p->priority;
// 	int head = head_tail[priority][0];
// 	int tail = head_tail[priority][1];

// 	if (tail == (head-1)%QSIZE){
// 		// queue is full
// 		return 0;
// 	}

// 	//update tail
// 	pqueues[priority][tail] =  p;
// 	head_tail[priority][1] = (tail+1)%QSIZE;
// 	return 1;
// }

// struct proc *p
// pq_dequeue(){
// 	// go to highest priority, non-empty queue 
// 	int priority = 0;
// 	while (head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
// 		priority++;

// 	if (priority == PRIO_MAX){
// 		// all queues are empty
// 		return 0;
// 	}

// 	// get proc
// 	int head = head_tail[priority][0];
// 	struct proc *p = pqueues[priority][head];

// 	// update head
// 	head_tail[priority][0] = (head+1)%QSIZE;
// 	return 1;
// }

























// struct pqueue {
// 	struct pqueue *head;
// 	struct pqueue *tail;
// };
// struct pqueue_node {
// 	int priority;
// 	struct proc * p;
// 	struct pqueue *next;
// };

// struct pqueue *pqueue_table[PRIO_MAX];	// this needs to be initialized to 0's in the new/modified scheduler function



// // enqueues a process into the proper pqueue - determined by proc's priority field
// int
// pq_enqueue(struct proc *p){
// 	int priority = p->priority;

// 	// create new pqueue node
// 	struct pqueue_node *node = (struct pqueue_node *) kalloc(sizeof(struct pqueue_node));
// 	pqueue_node->priority = priority;
// 	pqueue_node->p;
// 	pqueue_node->next = 0;

// 	// if there is no pqueue of this priority, create one, assign head/tail
// 	if (pqueue_table[priority] == 0){
// 		struct pqueue *priority_queue = (struct pqueue *) kalloc(sizeof(struct pqueue));
// 		priority_queue->head = node;
// 		priority_queue->tail = node;
// 		return 1;
// 	}

// 	// new nodes go to the tail of the pqueue
// 	pqueue_table[priority]->tail->next = node;
// 	pqueue_table[priority]->tail = node;
// 	return 1;
// }

// // dequeues from pqueue table - gets highest priority proc at head of given pqueue
// struct proc*
// pq_dequeue(){

// 	// start at highest priority queue
// 	int priority = 0;
// 	while (pqueue_table[priority] == 0)
// 		priority++;

// 	// get proc at head, remove and free old head, update head 
// 	struct proc *p = pqueue_table[priority]->head->p;
// 	struct pqueue_node *backup_head = pqueue_table[priority]->head;
// 	pqueue_table[priority]->head = pqueue_table[priority]->head->next;
// 	backup_head->next = 0;
// 	kfree(backup_head)

// 	return p;
// }