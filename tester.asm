
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
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx

	exit();
}

int mutex_create(char *name){
	return mcreate(name);
  10:	bb 05 00 00 00       	mov    $0x5,%ebx
int main(){
  15:	83 ec 18             	sub    $0x18,%esp
	return mcreate(name);
  18:	68 8e 0a 00 00       	push   $0xa8e
  1d:	e8 10 06 00 00       	call   632 <mcreate>
  22:	83 c4 10             	add    $0x10,%esp
  25:	89 c6                	mov    %eax,%esi
		if (fork() == 0){
  27:	e8 5e 05 00 00       	call   58a <fork>
  2c:	85 c0                	test   %eax,%eax
  2e:	0f 84 ba 00 00 00    	je     ee <main+0xee>
	for(i=0; i<5; i++){
  34:	83 eb 01             	sub    $0x1,%ebx
  37:	75 ee                	jne    27 <main+0x27>
  39:	bb 0a 00 00 00       	mov    $0xa,%ebx
  3e:	66 90                	xchg   %ax,%ax
		wait();
  40:	e8 55 05 00 00       	call   59a <wait>
	for(i=0; i<10; i++){
  45:	83 eb 01             	sub    $0x1,%ebx
  48:	75 f6                	jne    40 <main+0x40>
	return mcreate(name);
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	68 97 0a 00 00       	push   $0xa97
  52:	e8 db 05 00 00       	call   632 <mcreate>
  57:	89 c3                	mov    %eax,%ebx
	if (fork() == 0){
  59:	e8 2c 05 00 00       	call   58a <fork>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	75 52                	jne    b7 <main+0xb7>
}
int mutex_delete(int muxid){
	return mdelete(muxid);
}
int mutex_lock(int muxid){
	return mlock(muxid);
  65:	83 ec 0c             	sub    $0xc,%esp
  68:	53                   	push   %ebx
  69:	e8 d4 05 00 00       	call   642 <mlock>
		if (!mutex_lock(muxid)){
  6e:	83 c4 10             	add    $0x10,%esp
  71:	85 c0                	test   %eax,%eax
  73:	0f 84 fc 00 00 00    	je     175 <main+0x175>
  79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int cv_wait(int muxid){
	return waitcv(muxid);
}
int cv_signal(int muxid){
	return signalcv(muxid);
  80:	83 ec 0c             	sub    $0xc,%esp
  83:	53                   	push   %ebx
  84:	e8 d1 05 00 00       	call   65a <signalcv>
		while (!cv_signal(muxid)){
  89:	83 c4 10             	add    $0x10,%esp
  8c:	85 c0                	test   %eax,%eax
  8e:	74 f0                	je     80 <main+0x80>
	return munlock(muxid);
  90:	83 ec 0c             	sub    $0xc,%esp
  93:	53                   	push   %ebx
  94:	e8 b1 05 00 00       	call   64a <munlock>
		if (!mutex_unlock(muxid)){
  99:	83 c4 10             	add    $0x10,%esp
  9c:	85 c0                	test   %eax,%eax
  9e:	0f 85 cc 00 00 00    	jne    170 <main+0x170>
			printf(1,"SIGNAL UNLOCK FAILURE\n");
  a4:	51                   	push   %ecx
  a5:	51                   	push   %ecx
  a6:	68 b4 0a 00 00       	push   $0xab4
  ab:	6a 01                	push   $0x1
  ad:	e8 6e 06 00 00       	call   720 <printf>
			exit();
  b2:	e8 db 04 00 00       	call   592 <exit>
	return mlock(muxid);
  b7:	83 ec 0c             	sub    $0xc,%esp
  ba:	53                   	push   %ebx
  bb:	e8 82 05 00 00       	call   642 <mlock>
	if (!mutex_lock(muxid)){
  c0:	83 c4 10             	add    $0x10,%esp
  c3:	85 c0                	test   %eax,%eax
  c5:	74 37                	je     fe <main+0xfe>
	return waitcv(muxid);
  c7:	83 ec 0c             	sub    $0xc,%esp
  ca:	53                   	push   %ebx
  cb:	e8 82 05 00 00       	call   652 <waitcv>
	if (!cv_wait(muxid)){
  d0:	83 c4 10             	add    $0x10,%esp
  d3:	85 c0                	test   %eax,%eax
  d5:	0f 85 ad 00 00 00    	jne    188 <main+0x188>
		printf(1,"CV WAIT FAILURE\n");
  db:	52                   	push   %edx
  dc:	52                   	push   %edx
  dd:	68 cb 0a 00 00       	push   $0xacb
  e2:	6a 01                	push   $0x1
  e4:	e8 37 06 00 00       	call   720 <printf>
		exit();
  e9:	e8 a4 04 00 00       	call   592 <exit>
	return mlock(muxid);
  ee:	83 ec 0c             	sub    $0xc,%esp
  f1:	56                   	push   %esi
  f2:	e8 4b 05 00 00       	call   642 <mlock>
			if (!mutex_lock(id)){
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	85 c0                	test   %eax,%eax
  fc:	75 13                	jne    111 <main+0x111>
				printf(1,"LOCK FAILURE\n");
  fe:	51                   	push   %ecx
  ff:	51                   	push   %ecx
 100:	68 a6 0a 00 00       	push   $0xaa6
 105:	6a 01                	push   $0x1
 107:	e8 14 06 00 00       	call   720 <printf>
				exit();
 10c:	e8 81 04 00 00       	call   592 <exit>
				printf(1,"%d\n", j);
 111:	50                   	push   %eax
 112:	6a 01                	push   $0x1
 114:	68 93 0a 00 00       	push   $0xa93
 119:	6a 01                	push   $0x1
 11b:	e8 00 06 00 00       	call   720 <printf>
 120:	83 c4 0c             	add    $0xc,%esp
 123:	6a 02                	push   $0x2
 125:	68 93 0a 00 00       	push   $0xa93
 12a:	6a 01                	push   $0x1
 12c:	e8 ef 05 00 00       	call   720 <printf>
 131:	83 c4 0c             	add    $0xc,%esp
 134:	6a 03                	push   $0x3
 136:	68 93 0a 00 00       	push   $0xa93
 13b:	6a 01                	push   $0x1
 13d:	e8 de 05 00 00       	call   720 <printf>
			printf(1,"\n");
 142:	58                   	pop    %eax
 143:	5a                   	pop    %edx
 144:	68 b2 0a 00 00       	push   $0xab2
 149:	6a 01                	push   $0x1
 14b:	e8 d0 05 00 00       	call   720 <printf>
	return munlock(muxid);
 150:	89 34 24             	mov    %esi,(%esp)
 153:	e8 f2 04 00 00       	call   64a <munlock>
			if (!mutex_unlock(id)){
 158:	83 c4 10             	add    $0x10,%esp
 15b:	85 c0                	test   %eax,%eax
 15d:	75 11                	jne    170 <main+0x170>
				printf(1,"UNLOCK FAILURE\n");
 15f:	56                   	push   %esi
 160:	56                   	push   %esi
 161:	68 bb 0a 00 00       	push   $0xabb
 166:	6a 01                	push   $0x1
 168:	e8 b3 05 00 00       	call   720 <printf>
 16d:	83 c4 10             	add    $0x10,%esp
			exit();
 170:	e8 1d 04 00 00       	call   592 <exit>
			printf(1,"SIGNAL LOCK FAILURE\n");
 175:	53                   	push   %ebx
 176:	53                   	push   %ebx
 177:	68 9f 0a 00 00       	push   $0xa9f
 17c:	6a 01                	push   $0x1
 17e:	e8 9d 05 00 00       	call   720 <printf>
			exit();
 183:	e8 0a 04 00 00       	call   592 <exit>
	wait();
 188:	e8 0d 04 00 00       	call   59a <wait>
	printf(1,"CV SUCCESS\n");
 18d:	50                   	push   %eax
 18e:	50                   	push   %eax
 18f:	68 dc 0a 00 00       	push   $0xadc
 194:	6a 01                	push   $0x1
 196:	e8 85 05 00 00       	call   720 <printf>
	exit();
 19b:	e8 f2 03 00 00       	call   592 <exit>

000001a0 <init_queue>:
void init_queue(){
 1a0:	55                   	push   %ebp
 1a1:	b8 00 0f 00 00       	mov    $0xf00,%eax
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	90                   	nop
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			head_tail[m][n] = 0;
 1b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 1b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 1bd:	83 c0 08             	add    $0x8,%eax
	for (m=0; m<PRIO_MAX; m++){
 1c0:	3d 50 0f 00 00       	cmp    $0xf50,%eax
 1c5:	75 e9                	jne    1b0 <init_queue+0x10>
}
 1c7:	5d                   	pop    %ebp
 1c8:	c3                   	ret    
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001d0 <pq_enqueue>:
pq_enqueue (struct myproc *p){
 1d0:	55                   	push   %ebp
	if (tail == ((head-1)%QSIZE)){
 1d1:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
pq_enqueue (struct myproc *p){
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	57                   	push   %edi
 1d9:	56                   	push   %esi
	int priority = p->priority;
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
pq_enqueue (struct myproc *p){
 1dd:	53                   	push   %ebx
	int priority = p->priority;
 1de:	8b 38                	mov    (%eax),%edi
	if (tail == ((head-1)%QSIZE)){
 1e0:	8b 04 fd 00 0f 00 00 	mov    0xf00(,%edi,8),%eax
	int tail = head_tail[priority][1];
 1e7:	8b 1c fd 04 0f 00 00 	mov    0xf04(,%edi,8),%ebx
	if (tail == ((head-1)%QSIZE)){
 1ee:	8d 70 ff             	lea    -0x1(%eax),%esi
 1f1:	89 f0                	mov    %esi,%eax
 1f3:	f7 e9                	imul   %ecx
 1f5:	89 f0                	mov    %esi,%eax
 1f7:	c1 f8 1f             	sar    $0x1f,%eax
 1fa:	c1 fa 05             	sar    $0x5,%edx
 1fd:	29 c2                	sub    %eax,%edx
 1ff:	6b d2 64             	imul   $0x64,%edx,%edx
 202:	29 d6                	sub    %edx,%esi
 204:	39 de                	cmp    %ebx,%esi
 206:	74 38                	je     240 <pq_enqueue+0x70>
	pqueues[priority][tail] = p;
 208:	6b c7 64             	imul   $0x64,%edi,%eax
 20b:	8b 75 08             	mov    0x8(%ebp),%esi
 20e:	01 d8                	add    %ebx,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
 210:	83 c3 01             	add    $0x1,%ebx
	pqueues[priority][tail] = p;
 213:	89 34 85 60 0f 00 00 	mov    %esi,0xf60(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 21a:	89 d8                	mov    %ebx,%eax
 21c:	f7 e9                	imul   %ecx
 21e:	89 d8                	mov    %ebx,%eax
 220:	c1 f8 1f             	sar    $0x1f,%eax
 223:	89 d1                	mov    %edx,%ecx
 225:	c1 f9 05             	sar    $0x5,%ecx
 228:	29 c1                	sub    %eax,%ecx
	return 1;
 22a:	b8 01 00 00 00       	mov    $0x1,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
 22f:	6b c9 64             	imul   $0x64,%ecx,%ecx
 232:	29 cb                	sub    %ecx,%ebx
 234:	89 1c fd 04 0f 00 00 	mov    %ebx,0xf04(,%edi,8)
}
 23b:	5b                   	pop    %ebx
 23c:	5e                   	pop    %esi
 23d:	5f                   	pop    %edi
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    
		return -1;
 240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 245:	eb f4                	jmp    23b <pq_enqueue+0x6b>
 247:	89 f6                	mov    %esi,%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <pq_dequeue>:
pq_dequeue(){
 250:	55                   	push   %ebp
	int priority = 0;
 251:	31 c9                	xor    %ecx,%ecx
pq_dequeue(){
 253:	89 e5                	mov    %esp,%ebp
 255:	56                   	push   %esi
 256:	53                   	push   %ebx
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
 260:	8b 04 cd 00 0f 00 00 	mov    0xf00(,%ecx,8),%eax
 267:	3b 04 cd 04 0f 00 00 	cmp    0xf04(,%ecx,8),%eax
 26e:	75 30                	jne    2a0 <pq_dequeue+0x50>
		priority++;
 270:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
 273:	83 f9 0a             	cmp    $0xa,%ecx
 276:	75 e8                	jne    260 <pq_dequeue+0x10>
		printf(1,"all queues are empty\n");
 278:	83 ec 08             	sub    $0x8,%esp
		return NULL;
 27b:	be ff ff ff ff       	mov    $0xffffffff,%esi
		printf(1,"all queues are empty\n");
 280:	68 78 0a 00 00       	push   $0xa78
 285:	6a 01                	push   $0x1
 287:	e8 94 04 00 00       	call   720 <printf>
		return NULL;
 28c:	83 c4 10             	add    $0x10,%esp
}
 28f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 292:	89 f0                	mov    %esi,%eax
 294:	5b                   	pop    %ebx
 295:	5e                   	pop    %esi
 296:	5d                   	pop    %ebp
 297:	c3                   	ret    
 298:	90                   	nop
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	struct myproc *p = pqueues[priority][head];
 2a0:	6b d1 64             	imul   $0x64,%ecx,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 2a3:	8d 58 01             	lea    0x1(%eax),%ebx
	struct myproc *p = pqueues[priority][head];
 2a6:	01 c2                	add    %eax,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 2a8:	89 d8                	mov    %ebx,%eax
	struct myproc *p = pqueues[priority][head];
 2aa:	8b 34 95 60 0f 00 00 	mov    0xf60(,%edx,4),%esi
	head_tail[priority][0] = (head+1)%QSIZE;
 2b1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 2b6:	f7 ea                	imul   %edx
 2b8:	89 d8                	mov    %ebx,%eax
 2ba:	c1 f8 1f             	sar    $0x1f,%eax
 2bd:	c1 fa 05             	sar    $0x5,%edx
 2c0:	29 c2                	sub    %eax,%edx
 2c2:	89 d8                	mov    %ebx,%eax
 2c4:	6b d2 64             	imul   $0x64,%edx,%edx
 2c7:	29 d0                	sub    %edx,%eax
 2c9:	89 04 cd 00 0f 00 00 	mov    %eax,0xf00(,%ecx,8)
}
 2d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2d3:	89 f0                	mov    %esi,%eax
 2d5:	5b                   	pop    %ebx
 2d6:	5e                   	pop    %esi
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002e0 <mutex_create>:
int mutex_create(char *name){
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
}
 2e3:	5d                   	pop    %ebp
	return mcreate(name);
 2e4:	e9 49 03 00 00       	jmp    632 <mcreate>
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002f0 <mutex_delete>:
int mutex_delete(int muxid){
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
}
 2f3:	5d                   	pop    %ebp
	return mdelete(muxid);
 2f4:	e9 41 03 00 00       	jmp    63a <mdelete>
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000300 <mutex_lock>:
int mutex_lock(int muxid){
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
}
 303:	5d                   	pop    %ebp
	return mlock(muxid);
 304:	e9 39 03 00 00       	jmp    642 <mlock>
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000310 <mutex_unlock>:
int mutex_unlock(int muxid){
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
}
 313:	5d                   	pop    %ebp
	return munlock(muxid);
 314:	e9 31 03 00 00       	jmp    64a <munlock>
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <cv_wait>:
int cv_wait(int muxid){
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
}
 323:	5d                   	pop    %ebp
	return waitcv(muxid);
 324:	e9 29 03 00 00       	jmp    652 <waitcv>
 329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000330 <cv_signal>:
int cv_signal(int muxid){
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	5d                   	pop    %ebp
	return signalcv(muxid);
 334:	e9 21 03 00 00       	jmp    65a <signalcv>
 339:	66 90                	xchg   %ax,%ax
 33b:	66 90                	xchg   %ax,%ax
 33d:	66 90                	xchg   %ax,%ax
 33f:	90                   	nop

00000340 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 34a:	89 c2                	mov    %eax,%edx
 34c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 350:	83 c1 01             	add    $0x1,%ecx
 353:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 357:	83 c2 01             	add    $0x1,%edx
 35a:	84 db                	test   %bl,%bl
 35c:	88 5a ff             	mov    %bl,-0x1(%edx)
 35f:	75 ef                	jne    350 <strcpy+0x10>
		;
	return os;
}
 361:	5b                   	pop    %ebx
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
 364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 36a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000370 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 55 08             	mov    0x8(%ebp),%edx
 377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 37a:	0f b6 02             	movzbl (%edx),%eax
 37d:	0f b6 19             	movzbl (%ecx),%ebx
 380:	84 c0                	test   %al,%al
 382:	75 1c                	jne    3a0 <strcmp+0x30>
 384:	eb 2a                	jmp    3b0 <strcmp+0x40>
 386:	8d 76 00             	lea    0x0(%esi),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 390:	83 c2 01             	add    $0x1,%edx
 393:	0f b6 02             	movzbl (%edx),%eax
 396:	83 c1 01             	add    $0x1,%ecx
 399:	0f b6 19             	movzbl (%ecx),%ebx
 39c:	84 c0                	test   %al,%al
 39e:	74 10                	je     3b0 <strcmp+0x40>
 3a0:	38 d8                	cmp    %bl,%al
 3a2:	74 ec                	je     390 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 3a4:	29 d8                	sub    %ebx,%eax
}
 3a6:	5b                   	pop    %ebx
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3b0:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 3b2:	29 d8                	sub    %ebx,%eax
}
 3b4:	5b                   	pop    %ebx
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    
 3b7:	89 f6                	mov    %esi,%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <strlen>:

uint
strlen(char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 3c6:	80 39 00             	cmpb   $0x0,(%ecx)
 3c9:	74 15                	je     3e0 <strlen+0x20>
 3cb:	31 d2                	xor    %edx,%edx
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
 3d0:	83 c2 01             	add    $0x1,%edx
 3d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3d7:	89 d0                	mov    %edx,%eax
 3d9:	75 f5                	jne    3d0 <strlen+0x10>
		;
	return n;
}
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 3e0:	31 c0                	xor    %eax,%eax
}
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003f0 <memset>:

void *
memset(void *dst, int c, uint n)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 3f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 d7                	mov    %edx,%edi
 3ff:	fc                   	cld    
 400:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 402:	89 d0                	mov    %edx,%eax
 404:	5f                   	pop    %edi
 405:	5d                   	pop    %ebp
 406:	c3                   	ret    
 407:	89 f6                	mov    %esi,%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <strchr>:

char *
strchr(const char *s, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	53                   	push   %ebx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 41a:	0f b6 10             	movzbl (%eax),%edx
 41d:	84 d2                	test   %dl,%dl
 41f:	74 1d                	je     43e <strchr+0x2e>
		if (*s == c) return (char *)s;
 421:	38 d3                	cmp    %dl,%bl
 423:	89 d9                	mov    %ebx,%ecx
 425:	75 0d                	jne    434 <strchr+0x24>
 427:	eb 17                	jmp    440 <strchr+0x30>
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 430:	38 ca                	cmp    %cl,%dl
 432:	74 0c                	je     440 <strchr+0x30>
	for (; *s; s++)
 434:	83 c0 01             	add    $0x1,%eax
 437:	0f b6 10             	movzbl (%eax),%edx
 43a:	84 d2                	test   %dl,%dl
 43c:	75 f2                	jne    430 <strchr+0x20>
	return 0;
 43e:	31 c0                	xor    %eax,%eax
}
 440:	5b                   	pop    %ebx
 441:	5d                   	pop    %ebp
 442:	c3                   	ret    
 443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000450 <gets>:

char *
gets(char *buf, int max)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
 455:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 456:	31 f6                	xor    %esi,%esi
 458:	89 f3                	mov    %esi,%ebx
{
 45a:	83 ec 1c             	sub    $0x1c,%esp
 45d:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 460:	eb 2f                	jmp    491 <gets+0x41>
 462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 468:	8d 45 e7             	lea    -0x19(%ebp),%eax
 46b:	83 ec 04             	sub    $0x4,%esp
 46e:	6a 01                	push   $0x1
 470:	50                   	push   %eax
 471:	6a 00                	push   $0x0
 473:	e8 32 01 00 00       	call   5aa <read>
		if (cc < 1) break;
 478:	83 c4 10             	add    $0x10,%esp
 47b:	85 c0                	test   %eax,%eax
 47d:	7e 1c                	jle    49b <gets+0x4b>
		buf[i++] = c;
 47f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 483:	83 c7 01             	add    $0x1,%edi
 486:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 489:	3c 0a                	cmp    $0xa,%al
 48b:	74 23                	je     4b0 <gets+0x60>
 48d:	3c 0d                	cmp    $0xd,%al
 48f:	74 1f                	je     4b0 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 491:	83 c3 01             	add    $0x1,%ebx
 494:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 497:	89 fe                	mov    %edi,%esi
 499:	7c cd                	jl     468 <gets+0x18>
 49b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 49d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 4a0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a6:	5b                   	pop    %ebx
 4a7:	5e                   	pop    %esi
 4a8:	5f                   	pop    %edi
 4a9:	5d                   	pop    %ebp
 4aa:	c3                   	ret    
 4ab:	90                   	nop
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b0:	8b 75 08             	mov    0x8(%ebp),%esi
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	01 de                	add    %ebx,%esi
 4b8:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 4ba:	c6 03 00             	movb   $0x0,(%ebx)
}
 4bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c0:	5b                   	pop    %ebx
 4c1:	5e                   	pop    %esi
 4c2:	5f                   	pop    %edi
 4c3:	5d                   	pop    %ebp
 4c4:	c3                   	ret    
 4c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004d0 <stat>:

int
stat(char *n, struct stat *st)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 4d5:	83 ec 08             	sub    $0x8,%esp
 4d8:	6a 00                	push   $0x0
 4da:	ff 75 08             	pushl  0x8(%ebp)
 4dd:	e8 f0 00 00 00       	call   5d2 <open>
	if (fd < 0) return -1;
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	85 c0                	test   %eax,%eax
 4e7:	78 27                	js     510 <stat+0x40>
	r = fstat(fd, st);
 4e9:	83 ec 08             	sub    $0x8,%esp
 4ec:	ff 75 0c             	pushl  0xc(%ebp)
 4ef:	89 c3                	mov    %eax,%ebx
 4f1:	50                   	push   %eax
 4f2:	e8 f3 00 00 00       	call   5ea <fstat>
	close(fd);
 4f7:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 4fa:	89 c6                	mov    %eax,%esi
	close(fd);
 4fc:	e8 b9 00 00 00       	call   5ba <close>
	return r;
 501:	83 c4 10             	add    $0x10,%esp
}
 504:	8d 65 f8             	lea    -0x8(%ebp),%esp
 507:	89 f0                	mov    %esi,%eax
 509:	5b                   	pop    %ebx
 50a:	5e                   	pop    %esi
 50b:	5d                   	pop    %ebp
 50c:	c3                   	ret    
 50d:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 510:	be ff ff ff ff       	mov    $0xffffffff,%esi
 515:	eb ed                	jmp    504 <stat+0x34>
 517:	89 f6                	mov    %esi,%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000520 <atoi>:

int
atoi(const char *s)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 527:	0f be 11             	movsbl (%ecx),%edx
 52a:	8d 42 d0             	lea    -0x30(%edx),%eax
 52d:	3c 09                	cmp    $0x9,%al
	n = 0;
 52f:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 534:	77 1f                	ja     555 <atoi+0x35>
 536:	8d 76 00             	lea    0x0(%esi),%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 540:	8d 04 80             	lea    (%eax,%eax,4),%eax
 543:	83 c1 01             	add    $0x1,%ecx
 546:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 54a:	0f be 11             	movsbl (%ecx),%edx
 54d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 550:	80 fb 09             	cmp    $0x9,%bl
 553:	76 eb                	jbe    540 <atoi+0x20>
	return n;
}
 555:	5b                   	pop    %ebx
 556:	5d                   	pop    %ebp
 557:	c3                   	ret    
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000560 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	56                   	push   %esi
 564:	53                   	push   %ebx
 565:	8b 5d 10             	mov    0x10(%ebp),%ebx
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 56e:	85 db                	test   %ebx,%ebx
 570:	7e 14                	jle    586 <memmove+0x26>
 572:	31 d2                	xor    %edx,%edx
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 578:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 57c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 57f:	83 c2 01             	add    $0x1,%edx
 582:	39 d3                	cmp    %edx,%ebx
 584:	75 f2                	jne    578 <memmove+0x18>
	return vdst;
}
 586:	5b                   	pop    %ebx
 587:	5e                   	pop    %esi
 588:	5d                   	pop    %ebp
 589:	c3                   	ret    

0000058a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 58a:	b8 01 00 00 00       	mov    $0x1,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <exit>:
SYSCALL(exit)
 592:	b8 02 00 00 00       	mov    $0x2,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <wait>:
SYSCALL(wait)
 59a:	b8 03 00 00 00       	mov    $0x3,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <pipe>:
SYSCALL(pipe)
 5a2:	b8 04 00 00 00       	mov    $0x4,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <read>:
SYSCALL(read)
 5aa:	b8 05 00 00 00       	mov    $0x5,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <write>:
SYSCALL(write)
 5b2:	b8 10 00 00 00       	mov    $0x10,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <close>:
SYSCALL(close)
 5ba:	b8 15 00 00 00       	mov    $0x15,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <kill>:
SYSCALL(kill)
 5c2:	b8 06 00 00 00       	mov    $0x6,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <exec>:
SYSCALL(exec)
 5ca:	b8 07 00 00 00       	mov    $0x7,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <open>:
SYSCALL(open)
 5d2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <mknod>:
SYSCALL(mknod)
 5da:	b8 11 00 00 00       	mov    $0x11,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <unlink>:
SYSCALL(unlink)
 5e2:	b8 12 00 00 00       	mov    $0x12,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <fstat>:
SYSCALL(fstat)
 5ea:	b8 08 00 00 00       	mov    $0x8,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <link>:
SYSCALL(link)
 5f2:	b8 13 00 00 00       	mov    $0x13,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <mkdir>:
SYSCALL(mkdir)
 5fa:	b8 14 00 00 00       	mov    $0x14,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <chdir>:
SYSCALL(chdir)
 602:	b8 09 00 00 00       	mov    $0x9,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <dup>:
SYSCALL(dup)
 60a:	b8 0a 00 00 00       	mov    $0xa,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <getpid>:
SYSCALL(getpid)
 612:	b8 0b 00 00 00       	mov    $0xb,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <sbrk>:
SYSCALL(sbrk)
 61a:	b8 0c 00 00 00       	mov    $0xc,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <sleep>:
SYSCALL(sleep)
 622:	b8 0d 00 00 00       	mov    $0xd,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <uptime>:
SYSCALL(uptime)
 62a:	b8 0e 00 00 00       	mov    $0xe,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <mcreate>:
SYSCALL(mcreate)
 632:	b8 16 00 00 00       	mov    $0x16,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <mdelete>:
SYSCALL(mdelete)
 63a:	b8 17 00 00 00       	mov    $0x17,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <mlock>:
SYSCALL(mlock)
 642:	b8 18 00 00 00       	mov    $0x18,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <munlock>:
SYSCALL(munlock)
 64a:	b8 19 00 00 00       	mov    $0x19,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <waitcv>:
SYSCALL(waitcv)
 652:	b8 1a 00 00 00       	mov    $0x1a,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <signalcv>:
SYSCALL(signalcv)
 65a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <prio_set>:
SYSCALL(prio_set)
 662:	b8 1c 00 00 00       	mov    $0x1c,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <testpqeq>:
SYSCALL(testpqeq)
 66a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <testpqdq>:
SYSCALL(testpqdq)
 672:	b8 1e 00 00 00       	mov    $0x1e,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    
 67a:	66 90                	xchg   %ax,%ax
 67c:	66 90                	xchg   %ax,%ax
 67e:	66 90                	xchg   %ax,%ax

00000680 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 689:	85 d2                	test   %edx,%edx
{
 68b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 68e:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 690:	79 76                	jns    708 <printint+0x88>
 692:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 696:	74 70                	je     708 <printint+0x88>
		x   = -xx;
 698:	f7 d8                	neg    %eax
		neg = 1;
 69a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 6a1:	31 f6                	xor    %esi,%esi
 6a3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6a6:	eb 0a                	jmp    6b2 <printint+0x32>
 6a8:	90                   	nop
 6a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 6b0:	89 fe                	mov    %edi,%esi
 6b2:	31 d2                	xor    %edx,%edx
 6b4:	8d 7e 01             	lea    0x1(%esi),%edi
 6b7:	f7 f1                	div    %ecx
 6b9:	0f b6 92 f0 0a 00 00 	movzbl 0xaf0(%edx),%edx
	} while ((x /= base) != 0);
 6c0:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 6c2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 6c5:	75 e9                	jne    6b0 <printint+0x30>
	if (neg) buf[i++] = '-';
 6c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6ca:	85 c0                	test   %eax,%eax
 6cc:	74 08                	je     6d6 <printint+0x56>
 6ce:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 6d3:	8d 7e 02             	lea    0x2(%esi),%edi
 6d6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 6da:	8b 7d c0             	mov    -0x40(%ebp),%edi
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
 6e0:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
 6e6:	83 ee 01             	sub    $0x1,%esi
 6e9:	6a 01                	push   $0x1
 6eb:	53                   	push   %ebx
 6ec:	57                   	push   %edi
 6ed:	88 45 d7             	mov    %al,-0x29(%ebp)
 6f0:	e8 bd fe ff ff       	call   5b2 <write>

	while (--i >= 0) putc(fd, buf[i]);
 6f5:	83 c4 10             	add    $0x10,%esp
 6f8:	39 de                	cmp    %ebx,%esi
 6fa:	75 e4                	jne    6e0 <printint+0x60>
}
 6fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ff:	5b                   	pop    %ebx
 700:	5e                   	pop    %esi
 701:	5f                   	pop    %edi
 702:	5d                   	pop    %ebp
 703:	c3                   	ret    
 704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 708:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 70f:	eb 90                	jmp    6a1 <printint+0x21>
 711:	eb 0d                	jmp    720 <printf>
 713:	90                   	nop
 714:	90                   	nop
 715:	90                   	nop
 716:	90                   	nop
 717:	90                   	nop
 718:	90                   	nop
 719:	90                   	nop
 71a:	90                   	nop
 71b:	90                   	nop
 71c:	90                   	nop
 71d:	90                   	nop
 71e:	90                   	nop
 71f:	90                   	nop

00000720 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	57                   	push   %edi
 724:	56                   	push   %esi
 725:	53                   	push   %ebx
 726:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 729:	8b 75 0c             	mov    0xc(%ebp),%esi
 72c:	0f b6 1e             	movzbl (%esi),%ebx
 72f:	84 db                	test   %bl,%bl
 731:	0f 84 b3 00 00 00    	je     7ea <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 737:	8d 45 10             	lea    0x10(%ebp),%eax
 73a:	83 c6 01             	add    $0x1,%esi
	state = 0;
 73d:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 73f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 742:	eb 2f                	jmp    773 <printf+0x53>
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 748:	83 f8 25             	cmp    $0x25,%eax
 74b:	0f 84 a7 00 00 00    	je     7f8 <printf+0xd8>
	write(fd, &c, 1);
 751:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 754:	83 ec 04             	sub    $0x4,%esp
 757:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 75a:	6a 01                	push   $0x1
 75c:	50                   	push   %eax
 75d:	ff 75 08             	pushl  0x8(%ebp)
 760:	e8 4d fe ff ff       	call   5b2 <write>
 765:	83 c4 10             	add    $0x10,%esp
 768:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 76b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 76f:	84 db                	test   %bl,%bl
 771:	74 77                	je     7ea <printf+0xca>
		if (state == 0) {
 773:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 775:	0f be cb             	movsbl %bl,%ecx
 778:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 77b:	74 cb                	je     748 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 77d:	83 ff 25             	cmp    $0x25,%edi
 780:	75 e6                	jne    768 <printf+0x48>
			if (c == 'd') {
 782:	83 f8 64             	cmp    $0x64,%eax
 785:	0f 84 05 01 00 00    	je     890 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 78b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 791:	83 f9 70             	cmp    $0x70,%ecx
 794:	74 72                	je     808 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 796:	83 f8 73             	cmp    $0x73,%eax
 799:	0f 84 99 00 00 00    	je     838 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 79f:	83 f8 63             	cmp    $0x63,%eax
 7a2:	0f 84 08 01 00 00    	je     8b0 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 7a8:	83 f8 25             	cmp    $0x25,%eax
 7ab:	0f 84 ef 00 00 00    	je     8a0 <printf+0x180>
	write(fd, &c, 1);
 7b1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7b4:	83 ec 04             	sub    $0x4,%esp
 7b7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7bb:	6a 01                	push   $0x1
 7bd:	50                   	push   %eax
 7be:	ff 75 08             	pushl  0x8(%ebp)
 7c1:	e8 ec fd ff ff       	call   5b2 <write>
 7c6:	83 c4 0c             	add    $0xc,%esp
 7c9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7cc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7cf:	6a 01                	push   $0x1
 7d1:	50                   	push   %eax
 7d2:	ff 75 08             	pushl  0x8(%ebp)
 7d5:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 7d8:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 7da:	e8 d3 fd ff ff       	call   5b2 <write>
	for (i = 0; fmt[i]; i++) {
 7df:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 7e3:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 7e6:	84 db                	test   %bl,%bl
 7e8:	75 89                	jne    773 <printf+0x53>
		}
	}
}
 7ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7ed:	5b                   	pop    %ebx
 7ee:	5e                   	pop    %esi
 7ef:	5f                   	pop    %edi
 7f0:	5d                   	pop    %ebp
 7f1:	c3                   	ret    
 7f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 7f8:	bf 25 00 00 00       	mov    $0x25,%edi
 7fd:	e9 66 ff ff ff       	jmp    768 <printf+0x48>
 802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 808:	83 ec 0c             	sub    $0xc,%esp
 80b:	b9 10 00 00 00       	mov    $0x10,%ecx
 810:	6a 00                	push   $0x0
 812:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 815:	8b 45 08             	mov    0x8(%ebp),%eax
 818:	8b 17                	mov    (%edi),%edx
 81a:	e8 61 fe ff ff       	call   680 <printint>
				ap++;
 81f:	89 f8                	mov    %edi,%eax
 821:	83 c4 10             	add    $0x10,%esp
			state = 0;
 824:	31 ff                	xor    %edi,%edi
				ap++;
 826:	83 c0 04             	add    $0x4,%eax
 829:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 82c:	e9 37 ff ff ff       	jmp    768 <printf+0x48>
 831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 838:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 83b:	8b 08                	mov    (%eax),%ecx
				ap++;
 83d:	83 c0 04             	add    $0x4,%eax
 840:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 843:	85 c9                	test   %ecx,%ecx
 845:	0f 84 8e 00 00 00    	je     8d9 <printf+0x1b9>
				while (*s != 0) {
 84b:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 84e:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 850:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 852:	84 c0                	test   %al,%al
 854:	0f 84 0e ff ff ff    	je     768 <printf+0x48>
 85a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 85d:	89 de                	mov    %ebx,%esi
 85f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 862:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 865:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 868:	83 ec 04             	sub    $0x4,%esp
					s++;
 86b:	83 c6 01             	add    $0x1,%esi
 86e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 871:	6a 01                	push   $0x1
 873:	57                   	push   %edi
 874:	53                   	push   %ebx
 875:	e8 38 fd ff ff       	call   5b2 <write>
				while (*s != 0) {
 87a:	0f b6 06             	movzbl (%esi),%eax
 87d:	83 c4 10             	add    $0x10,%esp
 880:	84 c0                	test   %al,%al
 882:	75 e4                	jne    868 <printf+0x148>
 884:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 887:	31 ff                	xor    %edi,%edi
 889:	e9 da fe ff ff       	jmp    768 <printf+0x48>
 88e:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 890:	83 ec 0c             	sub    $0xc,%esp
 893:	b9 0a 00 00 00       	mov    $0xa,%ecx
 898:	6a 01                	push   $0x1
 89a:	e9 73 ff ff ff       	jmp    812 <printf+0xf2>
 89f:	90                   	nop
	write(fd, &c, 1);
 8a0:	83 ec 04             	sub    $0x4,%esp
 8a3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8a6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8a9:	6a 01                	push   $0x1
 8ab:	e9 21 ff ff ff       	jmp    7d1 <printf+0xb1>
				putc(fd, *ap);
 8b0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 8b3:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 8b6:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 8b8:	6a 01                	push   $0x1
				ap++;
 8ba:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 8bd:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 8c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8c3:	50                   	push   %eax
 8c4:	ff 75 08             	pushl  0x8(%ebp)
 8c7:	e8 e6 fc ff ff       	call   5b2 <write>
				ap++;
 8cc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 8cf:	83 c4 10             	add    $0x10,%esp
			state = 0;
 8d2:	31 ff                	xor    %edi,%edi
 8d4:	e9 8f fe ff ff       	jmp    768 <printf+0x48>
				if (s == 0) s = "(null)";
 8d9:	bb e8 0a 00 00       	mov    $0xae8,%ebx
				while (*s != 0) {
 8de:	b8 28 00 00 00       	mov    $0x28,%eax
 8e3:	e9 72 ff ff ff       	jmp    85a <printf+0x13a>
 8e8:	66 90                	xchg   %ax,%ax
 8ea:	66 90                	xchg   %ax,%ax
 8ec:	66 90                	xchg   %ax,%ax
 8ee:	66 90                	xchg   %ax,%ax

000008f0 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 8f0:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f1:	a1 e0 0e 00 00       	mov    0xee0,%eax
{
 8f6:	89 e5                	mov    %esp,%ebp
 8f8:	57                   	push   %edi
 8f9:	56                   	push   %esi
 8fa:	53                   	push   %ebx
 8fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 8fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 908:	39 c8                	cmp    %ecx,%eax
 90a:	8b 10                	mov    (%eax),%edx
 90c:	73 32                	jae    940 <free+0x50>
 90e:	39 d1                	cmp    %edx,%ecx
 910:	72 04                	jb     916 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 912:	39 d0                	cmp    %edx,%eax
 914:	72 32                	jb     948 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 916:	8b 73 fc             	mov    -0x4(%ebx),%esi
 919:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 91c:	39 fa                	cmp    %edi,%edx
 91e:	74 30                	je     950 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 920:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 923:	8b 50 04             	mov    0x4(%eax),%edx
 926:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 929:	39 f1                	cmp    %esi,%ecx
 92b:	74 3a                	je     967 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 92d:	89 08                	mov    %ecx,(%eax)
	freep = p;
 92f:	a3 e0 0e 00 00       	mov    %eax,0xee0
}
 934:	5b                   	pop    %ebx
 935:	5e                   	pop    %esi
 936:	5f                   	pop    %edi
 937:	5d                   	pop    %ebp
 938:	c3                   	ret    
 939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 940:	39 d0                	cmp    %edx,%eax
 942:	72 04                	jb     948 <free+0x58>
 944:	39 d1                	cmp    %edx,%ecx
 946:	72 ce                	jb     916 <free+0x26>
{
 948:	89 d0                	mov    %edx,%eax
 94a:	eb bc                	jmp    908 <free+0x18>
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 950:	03 72 04             	add    0x4(%edx),%esi
 953:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 956:	8b 10                	mov    (%eax),%edx
 958:	8b 12                	mov    (%edx),%edx
 95a:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 95d:	8b 50 04             	mov    0x4(%eax),%edx
 960:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 963:	39 f1                	cmp    %esi,%ecx
 965:	75 c6                	jne    92d <free+0x3d>
		p->s.size += bp->s.size;
 967:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 96a:	a3 e0 0e 00 00       	mov    %eax,0xee0
		p->s.size += bp->s.size;
 96f:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 972:	8b 53 f8             	mov    -0x8(%ebx),%edx
 975:	89 10                	mov    %edx,(%eax)
}
 977:	5b                   	pop    %ebx
 978:	5e                   	pop    %esi
 979:	5f                   	pop    %edi
 97a:	5d                   	pop    %ebp
 97b:	c3                   	ret    
 97c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000980 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	57                   	push   %edi
 984:	56                   	push   %esi
 985:	53                   	push   %ebx
 986:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 989:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 98c:	8b 15 e0 0e 00 00    	mov    0xee0,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 992:	8d 78 07             	lea    0x7(%eax),%edi
 995:	c1 ef 03             	shr    $0x3,%edi
 998:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 99b:	85 d2                	test   %edx,%edx
 99d:	0f 84 9d 00 00 00    	je     a40 <malloc+0xc0>
 9a3:	8b 02                	mov    (%edx),%eax
 9a5:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 9a8:	39 cf                	cmp    %ecx,%edi
 9aa:	76 6c                	jbe    a18 <malloc+0x98>
 9ac:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9b2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9b7:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 9ba:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9c1:	eb 0e                	jmp    9d1 <malloc+0x51>
 9c3:	90                   	nop
 9c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9c8:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 9ca:	8b 48 04             	mov    0x4(%eax),%ecx
 9cd:	39 f9                	cmp    %edi,%ecx
 9cf:	73 47                	jae    a18 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 9d1:	39 05 e0 0e 00 00    	cmp    %eax,0xee0
 9d7:	89 c2                	mov    %eax,%edx
 9d9:	75 ed                	jne    9c8 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 9db:	83 ec 0c             	sub    $0xc,%esp
 9de:	56                   	push   %esi
 9df:	e8 36 fc ff ff       	call   61a <sbrk>
	if (p == (char *)-1) return 0;
 9e4:	83 c4 10             	add    $0x10,%esp
 9e7:	83 f8 ff             	cmp    $0xffffffff,%eax
 9ea:	74 1c                	je     a08 <malloc+0x88>
	hp->s.size = nu;
 9ec:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 9ef:	83 ec 0c             	sub    $0xc,%esp
 9f2:	83 c0 08             	add    $0x8,%eax
 9f5:	50                   	push   %eax
 9f6:	e8 f5 fe ff ff       	call   8f0 <free>
	return freep;
 9fb:	8b 15 e0 0e 00 00    	mov    0xee0,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 a01:	83 c4 10             	add    $0x10,%esp
 a04:	85 d2                	test   %edx,%edx
 a06:	75 c0                	jne    9c8 <malloc+0x48>
	}
}
 a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 a0b:	31 c0                	xor    %eax,%eax
}
 a0d:	5b                   	pop    %ebx
 a0e:	5e                   	pop    %esi
 a0f:	5f                   	pop    %edi
 a10:	5d                   	pop    %ebp
 a11:	c3                   	ret    
 a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 a18:	39 cf                	cmp    %ecx,%edi
 a1a:	74 54                	je     a70 <malloc+0xf0>
				p->s.size -= nunits;
 a1c:	29 f9                	sub    %edi,%ecx
 a1e:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 a21:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 a24:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 a27:	89 15 e0 0e 00 00    	mov    %edx,0xee0
}
 a2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 a30:	83 c0 08             	add    $0x8,%eax
}
 a33:	5b                   	pop    %ebx
 a34:	5e                   	pop    %esi
 a35:	5f                   	pop    %edi
 a36:	5d                   	pop    %ebp
 a37:	c3                   	ret    
 a38:	90                   	nop
 a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 a40:	c7 05 e0 0e 00 00 e4 	movl   $0xee4,0xee0
 a47:	0e 00 00 
 a4a:	c7 05 e4 0e 00 00 e4 	movl   $0xee4,0xee4
 a51:	0e 00 00 
		base.s.size                = 0;
 a54:	b8 e4 0e 00 00       	mov    $0xee4,%eax
 a59:	c7 05 e8 0e 00 00 00 	movl   $0x0,0xee8
 a60:	00 00 00 
 a63:	e9 44 ff ff ff       	jmp    9ac <malloc+0x2c>
 a68:	90                   	nop
 a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 a70:	8b 08                	mov    (%eax),%ecx
 a72:	89 0a                	mov    %ecx,(%edx)
 a74:	eb b1                	jmp    a27 <malloc+0xa7>
