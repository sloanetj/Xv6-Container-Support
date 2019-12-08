
_tester:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	// update head
	head_tail[priority][0] = (head+1)%QSIZE;
	return p;
}

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
	// 	exit();
	// }
}

int mutex_create(char *name){
	return mcreate(name);
   f:	83 ec 0c             	sub    $0xc,%esp
  12:	68 5e 0a 00 00       	push   $0xa5e
  17:	e8 e6 05 00 00       	call   602 <mcreate>
  1c:	89 c3                	mov    %eax,%ebx
	if (fork() == 0){
  1e:	e8 37 05 00 00       	call   55a <fork>
  23:	83 c4 10             	add    $0x10,%esp
  26:	85 c0                	test   %eax,%eax
  28:	75 1c                	jne    46 <main+0x46>
}
int mutex_delete(int muxid){
	return mdelete(muxid);
}
int mutex_lock(int muxid){
	return mlock(muxid);
  2a:	83 ec 0c             	sub    $0xc,%esp
  2d:	53                   	push   %ebx
  2e:	e8 df 05 00 00       	call   612 <mlock>
		printf(1, "child: about to exit while holding lock\n");
  33:	58                   	pop    %eax
  34:	5a                   	pop    %edx
  35:	68 d4 0a 00 00       	push   $0xad4
  3a:	6a 01                	push   $0x1
  3c:	e8 af 06 00 00       	call   6f0 <printf>
		exit();
  41:	e8 1c 05 00 00       	call   562 <exit>
		wait();
  46:	e8 1f 05 00 00       	call   56a <wait>
	return mlock(muxid);
  4b:	83 ec 0c             	sub    $0xc,%esp
  4e:	53                   	push   %ebx
  4f:	e8 be 05 00 00       	call   612 <mlock>
		if (!mutex_lock(mux_id)){
  54:	83 c4 10             	add    $0x10,%esp
  57:	85 c0                	test   %eax,%eax
  59:	0f 84 84 00 00 00    	je     e3 <main+0xe3>
			printf(1,"parent: was able to take the lock\n");
  5f:	50                   	push   %eax
  60:	50                   	push   %eax
  61:	68 00 0b 00 00       	push   $0xb00
  66:	6a 01                	push   $0x1
  68:	e8 83 06 00 00       	call   6f0 <printf>
}
int mutex_unlock(int muxid){
	return munlock(muxid);
  6d:	89 1c 24             	mov    %ebx,(%esp)
  70:	e8 a5 05 00 00       	call   61a <munlock>
  75:	83 c4 10             	add    $0x10,%esp
	return mcreate(name);
  78:	83 ec 0c             	sub    $0xc,%esp
  7b:	68 81 0a 00 00       	push   $0xa81
  80:	e8 7d 05 00 00       	call   602 <mcreate>
  85:	89 c3                	mov    %eax,%ebx
	if (fork() == 0){
  87:	e8 ce 04 00 00       	call   55a <fork>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	85 c0                	test   %eax,%eax
  91:	75 63                	jne    f6 <main+0xf6>
	return mlock(muxid);
  93:	83 ec 0c             	sub    $0xc,%esp
  96:	53                   	push   %ebx
  97:	e8 76 05 00 00       	call   612 <mlock>
		if (!mutex_lock(muxid)){
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	85 c0                	test   %eax,%eax
  a1:	0f 84 95 00 00 00    	je     13c <main+0x13c>
  a7:	89 f6                	mov    %esi,%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

int cv_wait(int muxid){
	return waitcv(muxid);
}
int cv_signal(int muxid){
	return signalcv(muxid);
  b0:	83 ec 0c             	sub    $0xc,%esp
  b3:	53                   	push   %ebx
  b4:	e8 71 05 00 00       	call   62a <signalcv>
		while (!cv_signal(muxid)){
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	85 c0                	test   %eax,%eax
  be:	74 f0                	je     b0 <main+0xb0>
	return munlock(muxid);
  c0:	83 ec 0c             	sub    $0xc,%esp
  c3:	53                   	push   %ebx
  c4:	e8 51 05 00 00       	call   61a <munlock>
		if (!mutex_unlock(muxid)){
  c9:	83 c4 10             	add    $0x10,%esp
  cc:	85 c0                	test   %eax,%eax
  ce:	75 7f                	jne    14f <main+0x14f>
			printf(1,"SIGNAL UNLOCK FAILURE\n");
  d0:	53                   	push   %ebx
  d1:	53                   	push   %ebx
  d2:	68 9e 0a 00 00       	push   $0xa9e
  d7:	6a 01                	push   $0x1
  d9:	e8 12 06 00 00       	call   6f0 <printf>
			exit();
  de:	e8 7f 04 00 00       	call   562 <exit>
			printf(1,"parent: can't take the lock\n");
  e3:	50                   	push   %eax
  e4:	50                   	push   %eax
  e5:	68 64 0a 00 00       	push   $0xa64
  ea:	6a 01                	push   $0x1
  ec:	e8 ff 05 00 00       	call   6f0 <printf>
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	eb 82                	jmp    78 <main+0x78>
	return mlock(muxid);
  f6:	83 ec 0c             	sub    $0xc,%esp
  f9:	53                   	push   %ebx
  fa:	e8 13 05 00 00       	call   612 <mlock>
	if (!mutex_lock(muxid)){
  ff:	83 c4 10             	add    $0x10,%esp
 102:	85 c0                	test   %eax,%eax
 104:	74 23                	je     129 <main+0x129>
	return waitcv(muxid);
 106:	83 ec 0c             	sub    $0xc,%esp
 109:	53                   	push   %ebx
 10a:	e8 13 05 00 00       	call   622 <waitcv>
	if (!cv_wait(muxid)){
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	75 3e                	jne    154 <main+0x154>
		printf(1,"CV WAIT FAILURE\n");
 116:	52                   	push   %edx
 117:	52                   	push   %edx
 118:	68 b5 0a 00 00       	push   $0xab5
 11d:	6a 01                	push   $0x1
 11f:	e8 cc 05 00 00       	call   6f0 <printf>
		exit();
 124:	e8 39 04 00 00       	call   562 <exit>
		printf(1,"LOCK FAILURE\n");
 129:	51                   	push   %ecx
 12a:	51                   	push   %ecx
 12b:	68 90 0a 00 00       	push   $0xa90
 130:	6a 01                	push   $0x1
 132:	e8 b9 05 00 00       	call   6f0 <printf>
		exit();
 137:	e8 26 04 00 00       	call   562 <exit>
			printf(1,"SIGNAL LOCK FAILURE\n");
 13c:	50                   	push   %eax
 13d:	50                   	push   %eax
 13e:	68 89 0a 00 00       	push   $0xa89
 143:	6a 01                	push   $0x1
 145:	e8 a6 05 00 00       	call   6f0 <printf>
			exit();
 14a:	e8 13 04 00 00       	call   562 <exit>
		exit();
 14f:	e8 0e 04 00 00       	call   562 <exit>
	wait();
 154:	e8 11 04 00 00       	call   56a <wait>
	printf(1,"CV SUCCESS\n");
 159:	50                   	push   %eax
 15a:	50                   	push   %eax
 15b:	68 c6 0a 00 00       	push   $0xac6
 160:	6a 01                	push   $0x1
 162:	e8 89 05 00 00       	call   6f0 <printf>
	exit();
 167:	e8 f6 03 00 00       	call   562 <exit>
 16c:	66 90                	xchg   %ax,%ax
 16e:	66 90                	xchg   %ax,%ax

00000170 <init_queue>:
void init_queue(){
 170:	55                   	push   %ebp
 171:	b8 40 0f 00 00       	mov    $0xf40,%eax
 176:	89 e5                	mov    %esp,%ebp
 178:	90                   	nop
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			head_tail[m][n] = 0;
 180:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 18d:	83 c0 08             	add    $0x8,%eax
	for (m=0; m<PRIO_MAX; m++){
 190:	3d 90 0f 00 00       	cmp    $0xf90,%eax
 195:	75 e9                	jne    180 <init_queue+0x10>
}
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001a0 <pq_enqueue>:
pq_enqueue (struct myproc *p){
 1a0:	55                   	push   %ebp
	if (tail == ((head-1)%QSIZE)){
 1a1:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
pq_enqueue (struct myproc *p){
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	57                   	push   %edi
 1a9:	56                   	push   %esi
	int priority = p->priority;
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
pq_enqueue (struct myproc *p){
 1ad:	53                   	push   %ebx
	int priority = p->priority;
 1ae:	8b 38                	mov    (%eax),%edi
	if (tail == ((head-1)%QSIZE)){
 1b0:	8b 04 fd 40 0f 00 00 	mov    0xf40(,%edi,8),%eax
	int tail = head_tail[priority][1];
 1b7:	8b 1c fd 44 0f 00 00 	mov    0xf44(,%edi,8),%ebx
	if (tail == ((head-1)%QSIZE)){
 1be:	8d 70 ff             	lea    -0x1(%eax),%esi
 1c1:	89 f0                	mov    %esi,%eax
 1c3:	f7 e9                	imul   %ecx
 1c5:	89 f0                	mov    %esi,%eax
 1c7:	c1 f8 1f             	sar    $0x1f,%eax
 1ca:	c1 fa 05             	sar    $0x5,%edx
 1cd:	29 c2                	sub    %eax,%edx
 1cf:	6b d2 64             	imul   $0x64,%edx,%edx
 1d2:	29 d6                	sub    %edx,%esi
 1d4:	39 de                	cmp    %ebx,%esi
 1d6:	74 38                	je     210 <pq_enqueue+0x70>
	pqueues[priority][tail] = p;
 1d8:	6b c7 64             	imul   $0x64,%edi,%eax
 1db:	8b 75 08             	mov    0x8(%ebp),%esi
 1de:	01 d8                	add    %ebx,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
 1e0:	83 c3 01             	add    $0x1,%ebx
	pqueues[priority][tail] = p;
 1e3:	89 34 85 a0 0f 00 00 	mov    %esi,0xfa0(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 1ea:	89 d8                	mov    %ebx,%eax
 1ec:	f7 e9                	imul   %ecx
 1ee:	89 d8                	mov    %ebx,%eax
 1f0:	c1 f8 1f             	sar    $0x1f,%eax
 1f3:	89 d1                	mov    %edx,%ecx
 1f5:	c1 f9 05             	sar    $0x5,%ecx
 1f8:	29 c1                	sub    %eax,%ecx
	return 1;
 1fa:	b8 01 00 00 00       	mov    $0x1,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
 1ff:	6b c9 64             	imul   $0x64,%ecx,%ecx
 202:	29 cb                	sub    %ecx,%ebx
 204:	89 1c fd 44 0f 00 00 	mov    %ebx,0xf44(,%edi,8)
}
 20b:	5b                   	pop    %ebx
 20c:	5e                   	pop    %esi
 20d:	5f                   	pop    %edi
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    
		return -1;
 210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 215:	eb f4                	jmp    20b <pq_enqueue+0x6b>
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <pq_dequeue>:
pq_dequeue(){
 220:	55                   	push   %ebp
	int priority = 0;
 221:	31 c9                	xor    %ecx,%ecx
pq_dequeue(){
 223:	89 e5                	mov    %esp,%ebp
 225:	56                   	push   %esi
 226:	53                   	push   %ebx
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
 230:	8b 04 cd 40 0f 00 00 	mov    0xf40(,%ecx,8),%eax
 237:	3b 04 cd 44 0f 00 00 	cmp    0xf44(,%ecx,8),%eax
 23e:	75 30                	jne    270 <pq_dequeue+0x50>
		priority++;
 240:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
 243:	83 f9 0a             	cmp    $0xa,%ecx
 246:	75 e8                	jne    230 <pq_dequeue+0x10>
		printf(1,"all queues are empty\n");
 248:	83 ec 08             	sub    $0x8,%esp
		return NULL;
 24b:	be ff ff ff ff       	mov    $0xffffffff,%esi
		printf(1,"all queues are empty\n");
 250:	68 48 0a 00 00       	push   $0xa48
 255:	6a 01                	push   $0x1
 257:	e8 94 04 00 00       	call   6f0 <printf>
		return NULL;
 25c:	83 c4 10             	add    $0x10,%esp
}
 25f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 262:	89 f0                	mov    %esi,%eax
 264:	5b                   	pop    %ebx
 265:	5e                   	pop    %esi
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	90                   	nop
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	struct myproc *p = pqueues[priority][head];
 270:	6b d1 64             	imul   $0x64,%ecx,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 273:	8d 58 01             	lea    0x1(%eax),%ebx
	struct myproc *p = pqueues[priority][head];
 276:	01 c2                	add    %eax,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 278:	89 d8                	mov    %ebx,%eax
	struct myproc *p = pqueues[priority][head];
 27a:	8b 34 95 a0 0f 00 00 	mov    0xfa0(,%edx,4),%esi
	head_tail[priority][0] = (head+1)%QSIZE;
 281:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 286:	f7 ea                	imul   %edx
 288:	89 d8                	mov    %ebx,%eax
 28a:	c1 f8 1f             	sar    $0x1f,%eax
 28d:	c1 fa 05             	sar    $0x5,%edx
 290:	29 c2                	sub    %eax,%edx
 292:	89 d8                	mov    %ebx,%eax
 294:	6b d2 64             	imul   $0x64,%edx,%edx
 297:	29 d0                	sub    %edx,%eax
 299:	89 04 cd 40 0f 00 00 	mov    %eax,0xf40(,%ecx,8)
}
 2a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2a3:	89 f0                	mov    %esi,%eax
 2a5:	5b                   	pop    %ebx
 2a6:	5e                   	pop    %esi
 2a7:	5d                   	pop    %ebp
 2a8:	c3                   	ret    
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <mutex_create>:
int mutex_create(char *name){
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
}
 2b3:	5d                   	pop    %ebp
	return mcreate(name);
 2b4:	e9 49 03 00 00       	jmp    602 <mcreate>
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002c0 <mutex_delete>:
int mutex_delete(int muxid){
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
}
 2c3:	5d                   	pop    %ebp
	return mdelete(muxid);
 2c4:	e9 41 03 00 00       	jmp    60a <mdelete>
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <mutex_lock>:
int mutex_lock(int muxid){
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
}
 2d3:	5d                   	pop    %ebp
	return mlock(muxid);
 2d4:	e9 39 03 00 00       	jmp    612 <mlock>
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002e0 <mutex_unlock>:
int mutex_unlock(int muxid){
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
}
 2e3:	5d                   	pop    %ebp
	return munlock(muxid);
 2e4:	e9 31 03 00 00       	jmp    61a <munlock>
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <cv_wait>:
int cv_wait(int muxid){
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
}
 2f3:	5d                   	pop    %ebp
	return waitcv(muxid);
 2f4:	e9 29 03 00 00       	jmp    622 <waitcv>
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000300 <cv_signal>:
int cv_signal(int muxid){
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	5d                   	pop    %ebp
	return signalcv(muxid);
 304:	e9 21 03 00 00       	jmp    62a <signalcv>
 309:	66 90                	xchg   %ax,%ax
 30b:	66 90                	xchg   %ax,%ax
 30d:	66 90                	xchg   %ax,%ax
 30f:	90                   	nop

00000310 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 320:	83 c1 01             	add    $0x1,%ecx
 323:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 327:	83 c2 01             	add    $0x1,%edx
 32a:	84 db                	test   %bl,%bl
 32c:	88 5a ff             	mov    %bl,-0x1(%edx)
 32f:	75 ef                	jne    320 <strcpy+0x10>
		;
	return os;
}
 331:	5b                   	pop    %ebx
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 33a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 55 08             	mov    0x8(%ebp),%edx
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 34a:	0f b6 02             	movzbl (%edx),%eax
 34d:	0f b6 19             	movzbl (%ecx),%ebx
 350:	84 c0                	test   %al,%al
 352:	75 1c                	jne    370 <strcmp+0x30>
 354:	eb 2a                	jmp    380 <strcmp+0x40>
 356:	8d 76 00             	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 360:	83 c2 01             	add    $0x1,%edx
 363:	0f b6 02             	movzbl (%edx),%eax
 366:	83 c1 01             	add    $0x1,%ecx
 369:	0f b6 19             	movzbl (%ecx),%ebx
 36c:	84 c0                	test   %al,%al
 36e:	74 10                	je     380 <strcmp+0x40>
 370:	38 d8                	cmp    %bl,%al
 372:	74 ec                	je     360 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 374:	29 d8                	sub    %ebx,%eax
}
 376:	5b                   	pop    %ebx
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 380:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 382:	29 d8                	sub    %ebx,%eax
}
 384:	5b                   	pop    %ebx
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    
 387:	89 f6                	mov    %esi,%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <strlen>:

uint
strlen(char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 396:	80 39 00             	cmpb   $0x0,(%ecx)
 399:	74 15                	je     3b0 <strlen+0x20>
 39b:	31 d2                	xor    %edx,%edx
 39d:	8d 76 00             	lea    0x0(%esi),%esi
 3a0:	83 c2 01             	add    $0x1,%edx
 3a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3a7:	89 d0                	mov    %edx,%eax
 3a9:	75 f5                	jne    3a0 <strlen+0x10>
		;
	return n;
}
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 3b0:	31 c0                	xor    %eax,%eax
}
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret    
 3b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003c0 <memset>:

void *
memset(void *dst, int c, uint n)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 3c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	89 d7                	mov    %edx,%edi
 3cf:	fc                   	cld    
 3d0:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	5f                   	pop    %edi
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <strchr>:

char *
strchr(const char *s, char c)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 3ea:	0f b6 10             	movzbl (%eax),%edx
 3ed:	84 d2                	test   %dl,%dl
 3ef:	74 1d                	je     40e <strchr+0x2e>
		if (*s == c) return (char *)s;
 3f1:	38 d3                	cmp    %dl,%bl
 3f3:	89 d9                	mov    %ebx,%ecx
 3f5:	75 0d                	jne    404 <strchr+0x24>
 3f7:	eb 17                	jmp    410 <strchr+0x30>
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 400:	38 ca                	cmp    %cl,%dl
 402:	74 0c                	je     410 <strchr+0x30>
	for (; *s; s++)
 404:	83 c0 01             	add    $0x1,%eax
 407:	0f b6 10             	movzbl (%eax),%edx
 40a:	84 d2                	test   %dl,%dl
 40c:	75 f2                	jne    400 <strchr+0x20>
	return 0;
 40e:	31 c0                	xor    %eax,%eax
}
 410:	5b                   	pop    %ebx
 411:	5d                   	pop    %ebp
 412:	c3                   	ret    
 413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <gets>:

char *
gets(char *buf, int max)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 426:	31 f6                	xor    %esi,%esi
 428:	89 f3                	mov    %esi,%ebx
{
 42a:	83 ec 1c             	sub    $0x1c,%esp
 42d:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 430:	eb 2f                	jmp    461 <gets+0x41>
 432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 438:	8d 45 e7             	lea    -0x19(%ebp),%eax
 43b:	83 ec 04             	sub    $0x4,%esp
 43e:	6a 01                	push   $0x1
 440:	50                   	push   %eax
 441:	6a 00                	push   $0x0
 443:	e8 32 01 00 00       	call   57a <read>
		if (cc < 1) break;
 448:	83 c4 10             	add    $0x10,%esp
 44b:	85 c0                	test   %eax,%eax
 44d:	7e 1c                	jle    46b <gets+0x4b>
		buf[i++] = c;
 44f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 453:	83 c7 01             	add    $0x1,%edi
 456:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 459:	3c 0a                	cmp    $0xa,%al
 45b:	74 23                	je     480 <gets+0x60>
 45d:	3c 0d                	cmp    $0xd,%al
 45f:	74 1f                	je     480 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 461:	83 c3 01             	add    $0x1,%ebx
 464:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 467:	89 fe                	mov    %edi,%esi
 469:	7c cd                	jl     438 <gets+0x18>
 46b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 470:	c6 03 00             	movb   $0x0,(%ebx)
}
 473:	8d 65 f4             	lea    -0xc(%ebp),%esp
 476:	5b                   	pop    %ebx
 477:	5e                   	pop    %esi
 478:	5f                   	pop    %edi
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret    
 47b:	90                   	nop
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 480:	8b 75 08             	mov    0x8(%ebp),%esi
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	01 de                	add    %ebx,%esi
 488:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 48a:	c6 03 00             	movb   $0x0,(%ebx)
}
 48d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 490:	5b                   	pop    %ebx
 491:	5e                   	pop    %esi
 492:	5f                   	pop    %edi
 493:	5d                   	pop    %ebp
 494:	c3                   	ret    
 495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004a0 <stat>:

int
stat(char *n, struct stat *st)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	6a 00                	push   $0x0
 4aa:	ff 75 08             	pushl  0x8(%ebp)
 4ad:	e8 f0 00 00 00       	call   5a2 <open>
	if (fd < 0) return -1;
 4b2:	83 c4 10             	add    $0x10,%esp
 4b5:	85 c0                	test   %eax,%eax
 4b7:	78 27                	js     4e0 <stat+0x40>
	r = fstat(fd, st);
 4b9:	83 ec 08             	sub    $0x8,%esp
 4bc:	ff 75 0c             	pushl  0xc(%ebp)
 4bf:	89 c3                	mov    %eax,%ebx
 4c1:	50                   	push   %eax
 4c2:	e8 f3 00 00 00       	call   5ba <fstat>
	close(fd);
 4c7:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 4ca:	89 c6                	mov    %eax,%esi
	close(fd);
 4cc:	e8 b9 00 00 00       	call   58a <close>
	return r;
 4d1:	83 c4 10             	add    $0x10,%esp
}
 4d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4d7:	89 f0                	mov    %esi,%eax
 4d9:	5b                   	pop    %ebx
 4da:	5e                   	pop    %esi
 4db:	5d                   	pop    %ebp
 4dc:	c3                   	ret    
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 4e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4e5:	eb ed                	jmp    4d4 <stat+0x34>
 4e7:	89 f6                	mov    %esi,%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 4f7:	0f be 11             	movsbl (%ecx),%edx
 4fa:	8d 42 d0             	lea    -0x30(%edx),%eax
 4fd:	3c 09                	cmp    $0x9,%al
	n = 0;
 4ff:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 504:	77 1f                	ja     525 <atoi+0x35>
 506:	8d 76 00             	lea    0x0(%esi),%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 510:	8d 04 80             	lea    (%eax,%eax,4),%eax
 513:	83 c1 01             	add    $0x1,%ecx
 516:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 51a:	0f be 11             	movsbl (%ecx),%edx
 51d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 520:	80 fb 09             	cmp    $0x9,%bl
 523:	76 eb                	jbe    510 <atoi+0x20>
	return n;
}
 525:	5b                   	pop    %ebx
 526:	5d                   	pop    %ebp
 527:	c3                   	ret    
 528:	90                   	nop
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000530 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
 535:	8b 5d 10             	mov    0x10(%ebp),%ebx
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 53e:	85 db                	test   %ebx,%ebx
 540:	7e 14                	jle    556 <memmove+0x26>
 542:	31 d2                	xor    %edx,%edx
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 548:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 54c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 54f:	83 c2 01             	add    $0x1,%edx
 552:	39 d3                	cmp    %edx,%ebx
 554:	75 f2                	jne    548 <memmove+0x18>
	return vdst;
}
 556:	5b                   	pop    %ebx
 557:	5e                   	pop    %esi
 558:	5d                   	pop    %ebp
 559:	c3                   	ret    

0000055a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 55a:	b8 01 00 00 00       	mov    $0x1,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <exit>:
SYSCALL(exit)
 562:	b8 02 00 00 00       	mov    $0x2,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <wait>:
SYSCALL(wait)
 56a:	b8 03 00 00 00       	mov    $0x3,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <pipe>:
SYSCALL(pipe)
 572:	b8 04 00 00 00       	mov    $0x4,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <read>:
SYSCALL(read)
 57a:	b8 05 00 00 00       	mov    $0x5,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <write>:
SYSCALL(write)
 582:	b8 10 00 00 00       	mov    $0x10,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <close>:
SYSCALL(close)
 58a:	b8 15 00 00 00       	mov    $0x15,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <kill>:
SYSCALL(kill)
 592:	b8 06 00 00 00       	mov    $0x6,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <exec>:
SYSCALL(exec)
 59a:	b8 07 00 00 00       	mov    $0x7,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <open>:
SYSCALL(open)
 5a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <mknod>:
SYSCALL(mknod)
 5aa:	b8 11 00 00 00       	mov    $0x11,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <unlink>:
SYSCALL(unlink)
 5b2:	b8 12 00 00 00       	mov    $0x12,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <fstat>:
SYSCALL(fstat)
 5ba:	b8 08 00 00 00       	mov    $0x8,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <link>:
SYSCALL(link)
 5c2:	b8 13 00 00 00       	mov    $0x13,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <mkdir>:
SYSCALL(mkdir)
 5ca:	b8 14 00 00 00       	mov    $0x14,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <chdir>:
SYSCALL(chdir)
 5d2:	b8 09 00 00 00       	mov    $0x9,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <dup>:
SYSCALL(dup)
 5da:	b8 0a 00 00 00       	mov    $0xa,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <getpid>:
SYSCALL(getpid)
 5e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <sbrk>:
SYSCALL(sbrk)
 5ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <sleep>:
SYSCALL(sleep)
 5f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <uptime>:
SYSCALL(uptime)
 5fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <mcreate>:
SYSCALL(mcreate)
 602:	b8 16 00 00 00       	mov    $0x16,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <mdelete>:
SYSCALL(mdelete)
 60a:	b8 17 00 00 00       	mov    $0x17,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <mlock>:
SYSCALL(mlock)
 612:	b8 18 00 00 00       	mov    $0x18,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <munlock>:
SYSCALL(munlock)
 61a:	b8 19 00 00 00       	mov    $0x19,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <waitcv>:
SYSCALL(waitcv)
 622:	b8 1a 00 00 00       	mov    $0x1a,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <signalcv>:
SYSCALL(signalcv)
 62a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <prio_set>:
SYSCALL(prio_set)
 632:	b8 1c 00 00 00       	mov    $0x1c,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <testpqeq>:
SYSCALL(testpqeq)
 63a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <testpqdq>:
SYSCALL(testpqdq)
 642:	b8 1e 00 00 00       	mov    $0x1e,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    
 64a:	66 90                	xchg   %ax,%ax
 64c:	66 90                	xchg   %ax,%ax
 64e:	66 90                	xchg   %ax,%ax

00000650 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 659:	85 d2                	test   %edx,%edx
{
 65b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 65e:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 660:	79 76                	jns    6d8 <printint+0x88>
 662:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 666:	74 70                	je     6d8 <printint+0x88>
		x   = -xx;
 668:	f7 d8                	neg    %eax
		neg = 1;
 66a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 671:	31 f6                	xor    %esi,%esi
 673:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 676:	eb 0a                	jmp    682 <printint+0x32>
 678:	90                   	nop
 679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 680:	89 fe                	mov    %edi,%esi
 682:	31 d2                	xor    %edx,%edx
 684:	8d 7e 01             	lea    0x1(%esi),%edi
 687:	f7 f1                	div    %ecx
 689:	0f b6 92 2c 0b 00 00 	movzbl 0xb2c(%edx),%edx
	} while ((x /= base) != 0);
 690:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 692:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 695:	75 e9                	jne    680 <printint+0x30>
	if (neg) buf[i++] = '-';
 697:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 69a:	85 c0                	test   %eax,%eax
 69c:	74 08                	je     6a6 <printint+0x56>
 69e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 6a3:	8d 7e 02             	lea    0x2(%esi),%edi
 6a6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 6aa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
 6b0:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 6b3:	83 ec 04             	sub    $0x4,%esp
 6b6:	83 ee 01             	sub    $0x1,%esi
 6b9:	6a 01                	push   $0x1
 6bb:	53                   	push   %ebx
 6bc:	57                   	push   %edi
 6bd:	88 45 d7             	mov    %al,-0x29(%ebp)
 6c0:	e8 bd fe ff ff       	call   582 <write>

	while (--i >= 0) putc(fd, buf[i]);
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	39 de                	cmp    %ebx,%esi
 6ca:	75 e4                	jne    6b0 <printint+0x60>
}
 6cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6cf:	5b                   	pop    %ebx
 6d0:	5e                   	pop    %esi
 6d1:	5f                   	pop    %edi
 6d2:	5d                   	pop    %ebp
 6d3:	c3                   	ret    
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 6d8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6df:	eb 90                	jmp    671 <printint+0x21>
 6e1:	eb 0d                	jmp    6f0 <printf>
 6e3:	90                   	nop
 6e4:	90                   	nop
 6e5:	90                   	nop
 6e6:	90                   	nop
 6e7:	90                   	nop
 6e8:	90                   	nop
 6e9:	90                   	nop
 6ea:	90                   	nop
 6eb:	90                   	nop
 6ec:	90                   	nop
 6ed:	90                   	nop
 6ee:	90                   	nop
 6ef:	90                   	nop

000006f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	57                   	push   %edi
 6f4:	56                   	push   %esi
 6f5:	53                   	push   %ebx
 6f6:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 6f9:	8b 75 0c             	mov    0xc(%ebp),%esi
 6fc:	0f b6 1e             	movzbl (%esi),%ebx
 6ff:	84 db                	test   %bl,%bl
 701:	0f 84 b3 00 00 00    	je     7ba <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 707:	8d 45 10             	lea    0x10(%ebp),%eax
 70a:	83 c6 01             	add    $0x1,%esi
	state = 0;
 70d:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 70f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 712:	eb 2f                	jmp    743 <printf+0x53>
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 718:	83 f8 25             	cmp    $0x25,%eax
 71b:	0f 84 a7 00 00 00    	je     7c8 <printf+0xd8>
	write(fd, &c, 1);
 721:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 724:	83 ec 04             	sub    $0x4,%esp
 727:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 72a:	6a 01                	push   $0x1
 72c:	50                   	push   %eax
 72d:	ff 75 08             	pushl  0x8(%ebp)
 730:	e8 4d fe ff ff       	call   582 <write>
 735:	83 c4 10             	add    $0x10,%esp
 738:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 73b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 73f:	84 db                	test   %bl,%bl
 741:	74 77                	je     7ba <printf+0xca>
		if (state == 0) {
 743:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 745:	0f be cb             	movsbl %bl,%ecx
 748:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 74b:	74 cb                	je     718 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 74d:	83 ff 25             	cmp    $0x25,%edi
 750:	75 e6                	jne    738 <printf+0x48>
			if (c == 'd') {
 752:	83 f8 64             	cmp    $0x64,%eax
 755:	0f 84 05 01 00 00    	je     860 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 75b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 761:	83 f9 70             	cmp    $0x70,%ecx
 764:	74 72                	je     7d8 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 766:	83 f8 73             	cmp    $0x73,%eax
 769:	0f 84 99 00 00 00    	je     808 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 76f:	83 f8 63             	cmp    $0x63,%eax
 772:	0f 84 08 01 00 00    	je     880 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 778:	83 f8 25             	cmp    $0x25,%eax
 77b:	0f 84 ef 00 00 00    	je     870 <printf+0x180>
	write(fd, &c, 1);
 781:	8d 45 e7             	lea    -0x19(%ebp),%eax
 784:	83 ec 04             	sub    $0x4,%esp
 787:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 78b:	6a 01                	push   $0x1
 78d:	50                   	push   %eax
 78e:	ff 75 08             	pushl  0x8(%ebp)
 791:	e8 ec fd ff ff       	call   582 <write>
 796:	83 c4 0c             	add    $0xc,%esp
 799:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 79c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 79f:	6a 01                	push   $0x1
 7a1:	50                   	push   %eax
 7a2:	ff 75 08             	pushl  0x8(%ebp)
 7a5:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 7a8:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 7aa:	e8 d3 fd ff ff       	call   582 <write>
	for (i = 0; fmt[i]; i++) {
 7af:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 7b3:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 7b6:	84 db                	test   %bl,%bl
 7b8:	75 89                	jne    743 <printf+0x53>
		}
	}
}
 7ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7bd:	5b                   	pop    %ebx
 7be:	5e                   	pop    %esi
 7bf:	5f                   	pop    %edi
 7c0:	5d                   	pop    %ebp
 7c1:	c3                   	ret    
 7c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 7c8:	bf 25 00 00 00       	mov    $0x25,%edi
 7cd:	e9 66 ff ff ff       	jmp    738 <printf+0x48>
 7d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 7d8:	83 ec 0c             	sub    $0xc,%esp
 7db:	b9 10 00 00 00       	mov    $0x10,%ecx
 7e0:	6a 00                	push   $0x0
 7e2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7e5:	8b 45 08             	mov    0x8(%ebp),%eax
 7e8:	8b 17                	mov    (%edi),%edx
 7ea:	e8 61 fe ff ff       	call   650 <printint>
				ap++;
 7ef:	89 f8                	mov    %edi,%eax
 7f1:	83 c4 10             	add    $0x10,%esp
			state = 0;
 7f4:	31 ff                	xor    %edi,%edi
				ap++;
 7f6:	83 c0 04             	add    $0x4,%eax
 7f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7fc:	e9 37 ff ff ff       	jmp    738 <printf+0x48>
 801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 808:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 80b:	8b 08                	mov    (%eax),%ecx
				ap++;
 80d:	83 c0 04             	add    $0x4,%eax
 810:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 813:	85 c9                	test   %ecx,%ecx
 815:	0f 84 8e 00 00 00    	je     8a9 <printf+0x1b9>
				while (*s != 0) {
 81b:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 81e:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 820:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 822:	84 c0                	test   %al,%al
 824:	0f 84 0e ff ff ff    	je     738 <printf+0x48>
 82a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 82d:	89 de                	mov    %ebx,%esi
 82f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 832:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 835:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 838:	83 ec 04             	sub    $0x4,%esp
					s++;
 83b:	83 c6 01             	add    $0x1,%esi
 83e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 841:	6a 01                	push   $0x1
 843:	57                   	push   %edi
 844:	53                   	push   %ebx
 845:	e8 38 fd ff ff       	call   582 <write>
				while (*s != 0) {
 84a:	0f b6 06             	movzbl (%esi),%eax
 84d:	83 c4 10             	add    $0x10,%esp
 850:	84 c0                	test   %al,%al
 852:	75 e4                	jne    838 <printf+0x148>
 854:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 857:	31 ff                	xor    %edi,%edi
 859:	e9 da fe ff ff       	jmp    738 <printf+0x48>
 85e:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	b9 0a 00 00 00       	mov    $0xa,%ecx
 868:	6a 01                	push   $0x1
 86a:	e9 73 ff ff ff       	jmp    7e2 <printf+0xf2>
 86f:	90                   	nop
	write(fd, &c, 1);
 870:	83 ec 04             	sub    $0x4,%esp
 873:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 876:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 879:	6a 01                	push   $0x1
 87b:	e9 21 ff ff ff       	jmp    7a1 <printf+0xb1>
				putc(fd, *ap);
 880:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 883:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 886:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 888:	6a 01                	push   $0x1
				ap++;
 88a:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 88d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 890:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 893:	50                   	push   %eax
 894:	ff 75 08             	pushl  0x8(%ebp)
 897:	e8 e6 fc ff ff       	call   582 <write>
				ap++;
 89c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 89f:	83 c4 10             	add    $0x10,%esp
			state = 0;
 8a2:	31 ff                	xor    %edi,%edi
 8a4:	e9 8f fe ff ff       	jmp    738 <printf+0x48>
				if (s == 0) s = "(null)";
 8a9:	bb 24 0b 00 00       	mov    $0xb24,%ebx
				while (*s != 0) {
 8ae:	b8 28 00 00 00       	mov    $0x28,%eax
 8b3:	e9 72 ff ff ff       	jmp    82a <printf+0x13a>
 8b8:	66 90                	xchg   %ax,%ax
 8ba:	66 90                	xchg   %ax,%ax
 8bc:	66 90                	xchg   %ax,%ax
 8be:	66 90                	xchg   %ax,%ax

000008c0 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 8c0:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	a1 20 0f 00 00       	mov    0xf20,%eax
{
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	57                   	push   %edi
 8c9:	56                   	push   %esi
 8ca:	53                   	push   %ebx
 8cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 8ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 8d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d8:	39 c8                	cmp    %ecx,%eax
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	73 32                	jae    910 <free+0x50>
 8de:	39 d1                	cmp    %edx,%ecx
 8e0:	72 04                	jb     8e6 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 8e2:	39 d0                	cmp    %edx,%eax
 8e4:	72 32                	jb     918 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 8e6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8e9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ec:	39 fa                	cmp    %edi,%edx
 8ee:	74 30                	je     920 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 8f0:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 8f3:	8b 50 04             	mov    0x4(%eax),%edx
 8f6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8f9:	39 f1                	cmp    %esi,%ecx
 8fb:	74 3a                	je     937 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 8fd:	89 08                	mov    %ecx,(%eax)
	freep = p;
 8ff:	a3 20 0f 00 00       	mov    %eax,0xf20
}
 904:	5b                   	pop    %ebx
 905:	5e                   	pop    %esi
 906:	5f                   	pop    %edi
 907:	5d                   	pop    %ebp
 908:	c3                   	ret    
 909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 910:	39 d0                	cmp    %edx,%eax
 912:	72 04                	jb     918 <free+0x58>
 914:	39 d1                	cmp    %edx,%ecx
 916:	72 ce                	jb     8e6 <free+0x26>
{
 918:	89 d0                	mov    %edx,%eax
 91a:	eb bc                	jmp    8d8 <free+0x18>
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 920:	03 72 04             	add    0x4(%edx),%esi
 923:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 926:	8b 10                	mov    (%eax),%edx
 928:	8b 12                	mov    (%edx),%edx
 92a:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 92d:	8b 50 04             	mov    0x4(%eax),%edx
 930:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 933:	39 f1                	cmp    %esi,%ecx
 935:	75 c6                	jne    8fd <free+0x3d>
		p->s.size += bp->s.size;
 937:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 93a:	a3 20 0f 00 00       	mov    %eax,0xf20
		p->s.size += bp->s.size;
 93f:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 942:	8b 53 f8             	mov    -0x8(%ebx),%edx
 945:	89 10                	mov    %edx,(%eax)
}
 947:	5b                   	pop    %ebx
 948:	5e                   	pop    %esi
 949:	5f                   	pop    %edi
 94a:	5d                   	pop    %ebp
 94b:	c3                   	ret    
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000950 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	57                   	push   %edi
 954:	56                   	push   %esi
 955:	53                   	push   %ebx
 956:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 959:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 95c:	8b 15 20 0f 00 00    	mov    0xf20,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 962:	8d 78 07             	lea    0x7(%eax),%edi
 965:	c1 ef 03             	shr    $0x3,%edi
 968:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 96b:	85 d2                	test   %edx,%edx
 96d:	0f 84 9d 00 00 00    	je     a10 <malloc+0xc0>
 973:	8b 02                	mov    (%edx),%eax
 975:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 978:	39 cf                	cmp    %ecx,%edi
 97a:	76 6c                	jbe    9e8 <malloc+0x98>
 97c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 982:	bb 00 10 00 00       	mov    $0x1000,%ebx
 987:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 98a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 991:	eb 0e                	jmp    9a1 <malloc+0x51>
 993:	90                   	nop
 994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 998:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 99a:	8b 48 04             	mov    0x4(%eax),%ecx
 99d:	39 f9                	cmp    %edi,%ecx
 99f:	73 47                	jae    9e8 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 9a1:	39 05 20 0f 00 00    	cmp    %eax,0xf20
 9a7:	89 c2                	mov    %eax,%edx
 9a9:	75 ed                	jne    998 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 9ab:	83 ec 0c             	sub    $0xc,%esp
 9ae:	56                   	push   %esi
 9af:	e8 36 fc ff ff       	call   5ea <sbrk>
	if (p == (char *)-1) return 0;
 9b4:	83 c4 10             	add    $0x10,%esp
 9b7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9ba:	74 1c                	je     9d8 <malloc+0x88>
	hp->s.size = nu;
 9bc:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 9bf:	83 ec 0c             	sub    $0xc,%esp
 9c2:	83 c0 08             	add    $0x8,%eax
 9c5:	50                   	push   %eax
 9c6:	e8 f5 fe ff ff       	call   8c0 <free>
	return freep;
 9cb:	8b 15 20 0f 00 00    	mov    0xf20,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 9d1:	83 c4 10             	add    $0x10,%esp
 9d4:	85 d2                	test   %edx,%edx
 9d6:	75 c0                	jne    998 <malloc+0x48>
	}
}
 9d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 9db:	31 c0                	xor    %eax,%eax
}
 9dd:	5b                   	pop    %ebx
 9de:	5e                   	pop    %esi
 9df:	5f                   	pop    %edi
 9e0:	5d                   	pop    %ebp
 9e1:	c3                   	ret    
 9e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 9e8:	39 cf                	cmp    %ecx,%edi
 9ea:	74 54                	je     a40 <malloc+0xf0>
				p->s.size -= nunits;
 9ec:	29 f9                	sub    %edi,%ecx
 9ee:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 9f1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 9f4:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 9f7:	89 15 20 0f 00 00    	mov    %edx,0xf20
}
 9fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 a00:	83 c0 08             	add    $0x8,%eax
}
 a03:	5b                   	pop    %ebx
 a04:	5e                   	pop    %esi
 a05:	5f                   	pop    %edi
 a06:	5d                   	pop    %ebp
 a07:	c3                   	ret    
 a08:	90                   	nop
 a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 a10:	c7 05 20 0f 00 00 24 	movl   $0xf24,0xf20
 a17:	0f 00 00 
 a1a:	c7 05 24 0f 00 00 24 	movl   $0xf24,0xf24
 a21:	0f 00 00 
		base.s.size                = 0;
 a24:	b8 24 0f 00 00       	mov    $0xf24,%eax
 a29:	c7 05 28 0f 00 00 00 	movl   $0x0,0xf28
 a30:	00 00 00 
 a33:	e9 44 ff ff ff       	jmp    97c <malloc+0x2c>
 a38:	90                   	nop
 a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 a40:	8b 08                	mov    (%eax),%ecx
 a42:	89 0a                	mov    %ecx,(%edx)
 a44:	eb b1                	jmp    9f7 <malloc+0xa7>
