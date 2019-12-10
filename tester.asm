
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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 34             	sub    $0x34,%esp

	exit();
}

int mutex_create(char *name){
	return mcreate(name);
  14:	68 fe 0e 00 00       	push   $0xefe
  19:	e8 84 0a 00 00       	call   aa2 <mcreate>
  1e:	89 c3                	mov    %eax,%ebx
	if (fork() == 0){
  20:	e8 d5 09 00 00       	call   9fa <fork>
  25:	83 c4 10             	add    $0x10,%esp
  28:	85 c0                	test   %eax,%eax
  2a:	75 1c                	jne    48 <main+0x48>
}
int mutex_delete(int muxid){
	return mdelete(muxid);
}
int mutex_lock(int muxid){
	return mlock(muxid);
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	53                   	push   %ebx
  30:	e8 7d 0a 00 00       	call   ab2 <mlock>
		printf(1, "child: about to exit while holding lock\n");
  35:	59                   	pop    %ecx
  36:	5b                   	pop    %ebx
  37:	68 cc 0f 00 00       	push   $0xfcc
  3c:	6a 01                	push   $0x1
  3e:	e8 4d 0b 00 00       	call   b90 <printf>
		exit();
  43:	e8 ba 09 00 00       	call   a02 <exit>
		wait();
  48:	e8 bd 09 00 00       	call   a0a <wait>
	return mlock(muxid);
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	53                   	push   %ebx
  51:	e8 5c 0a 00 00       	call   ab2 <mlock>
		if (!mutex_lock(mux_id)){
  56:	83 c4 10             	add    $0x10,%esp
  59:	85 c0                	test   %eax,%eax
  5b:	0f 84 86 00 00 00    	je     e7 <main+0xe7>
			printf(1,"parent: was able to take the lock\n");
  61:	50                   	push   %eax
  62:	50                   	push   %eax
  63:	68 f8 0f 00 00       	push   $0xff8
  68:	6a 01                	push   $0x1
  6a:	e8 21 0b 00 00       	call   b90 <printf>
}
int mutex_unlock(int muxid){
	return munlock(muxid);
  6f:	89 1c 24             	mov    %ebx,(%esp)
  72:	e8 43 0a 00 00       	call   aba <munlock>
  77:	83 c4 10             	add    $0x10,%esp
	return mcreate(name);
  7a:	83 ec 0c             	sub    $0xc,%esp
  7d:	68 21 0f 00 00       	push   $0xf21
  82:	e8 1b 0a 00 00       	call   aa2 <mcreate>
  87:	89 c3                	mov    %eax,%ebx
	if (fork() == 0){
  89:	e8 6c 09 00 00       	call   9fa <fork>
  8e:	83 c4 10             	add    $0x10,%esp
  91:	85 c0                	test   %eax,%eax
  93:	75 65                	jne    fa <main+0xfa>
	return mlock(muxid);
  95:	83 ec 0c             	sub    $0xc,%esp
  98:	53                   	push   %ebx
  99:	e8 14 0a 00 00       	call   ab2 <mlock>
		if (!mutex_lock(muxid)){
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	85 c0                	test   %eax,%eax
  a3:	0f 84 15 02 00 00    	je     2be <main+0x2be>
  a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int cv_wait(int muxid){
	return waitcv(muxid);
}
int cv_signal(int muxid){
	return signalcv(muxid);
  b0:	83 ec 0c             	sub    $0xc,%esp
  b3:	53                   	push   %ebx
  b4:	e8 11 0a 00 00       	call   aca <signalcv>
		while (!cv_signal(muxid)){
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	85 c0                	test   %eax,%eax
  be:	74 f0                	je     b0 <main+0xb0>
	return munlock(muxid);
  c0:	83 ec 0c             	sub    $0xc,%esp
  c3:	53                   	push   %ebx
  c4:	e8 f1 09 00 00       	call   aba <munlock>
		if (!mutex_unlock(muxid)){
  c9:	83 c4 10             	add    $0x10,%esp
  cc:	85 c0                	test   %eax,%eax
  ce:	0f 85 e5 01 00 00    	jne    2b9 <main+0x2b9>
			printf(1,"SIGNAL UNLOCK FAILURE\n");
  d4:	50                   	push   %eax
  d5:	50                   	push   %eax
  d6:	68 3e 0f 00 00       	push   $0xf3e
  db:	6a 01                	push   $0x1
  dd:	e8 ae 0a 00 00       	call   b90 <printf>
			exit();
  e2:	e8 1b 09 00 00       	call   a02 <exit>
			printf(1,"parent: can't take the lock\n");
  e7:	52                   	push   %edx
  e8:	52                   	push   %edx
  e9:	68 04 0f 00 00       	push   $0xf04
  ee:	6a 01                	push   $0x1
  f0:	e8 9b 0a 00 00       	call   b90 <printf>
  f5:	83 c4 10             	add    $0x10,%esp
  f8:	eb 80                	jmp    7a <main+0x7a>
	return mlock(muxid);
  fa:	83 ec 0c             	sub    $0xc,%esp
  fd:	53                   	push   %ebx
  fe:	e8 af 09 00 00       	call   ab2 <mlock>
	if (!mutex_lock(muxid)){
 103:	83 c4 10             	add    $0x10,%esp
 106:	85 c0                	test   %eax,%eax
 108:	74 27                	je     131 <main+0x131>
	return waitcv(muxid);
 10a:	83 ec 0c             	sub    $0xc,%esp
 10d:	53                   	push   %ebx
 10e:	e8 af 09 00 00       	call   ac2 <waitcv>
	if (!cv_wait(muxid)){
 113:	83 c4 10             	add    $0x10,%esp
 116:	85 c0                	test   %eax,%eax
 118:	0f 85 b3 01 00 00    	jne    2d1 <main+0x2d1>
		printf(1,"CV WAIT FAILURE\n");
 11e:	50                   	push   %eax
 11f:	50                   	push   %eax
 120:	68 55 0f 00 00       	push   $0xf55
 125:	6a 01                	push   $0x1
 127:	e8 64 0a 00 00       	call   b90 <printf>
		exit();
 12c:	e8 d1 08 00 00       	call   a02 <exit>
		printf(1,"LOCK FAILURE\n");
 131:	50                   	push   %eax
 132:	50                   	push   %eax
 133:	68 30 0f 00 00       	push   $0xf30
 138:	6a 01                	push   $0x1
 13a:	e8 51 0a 00 00       	call   b90 <printf>
		exit();
 13f:	e8 be 08 00 00       	call   a02 <exit>
	if (prio_set(getpid(), 10) > 0){
 144:	e8 39 09 00 00       	call   a82 <getpid>
 149:	56                   	push   %esi
 14a:	56                   	push   %esi
 14b:	6a 0a                	push   $0xa
 14d:	50                   	push   %eax
 14e:	e8 7f 09 00 00       	call   ad2 <prio_set>
 153:	83 c4 10             	add    $0x10,%esp
 156:	85 c0                	test   %eax,%eax
 158:	0f 8e fe 03 00 00    	jle    55c <main+0x55c>
		printf(1,"decrease priority: PASSED, should pass\n");
 15e:	53                   	push   %ebx
 15f:	53                   	push   %ebx
 160:	68 1c 10 00 00       	push   $0x101c
 165:	6a 01                	push   $0x1
 167:	e8 24 0a 00 00       	call   b90 <printf>
 16c:	83 c4 10             	add    $0x10,%esp
	if (prio_set(getpid(), 0) > 0){
 16f:	e8 0e 09 00 00       	call   a82 <getpid>
 174:	52                   	push   %edx
 175:	52                   	push   %edx
 176:	6a 00                	push   $0x0
 178:	50                   	push   %eax
 179:	e8 54 09 00 00       	call   ad2 <prio_set>
 17e:	83 c4 10             	add    $0x10,%esp
 181:	85 c0                	test   %eax,%eax
 183:	0f 8e bd 03 00 00    	jle    546 <main+0x546>
		printf(1,"increase priority: PASSED, should fail\n");
 189:	50                   	push   %eax
 18a:	50                   	push   %eax
 18b:	68 6c 10 00 00       	push   $0x106c
 190:	6a 01                	push   $0x1
 192:	e8 f9 09 00 00       	call   b90 <printf>
 197:	83 c4 10             	add    $0x10,%esp
	int pid = fork();
 19a:	e8 5b 08 00 00       	call   9fa <fork>
	if (pid == 0){
 19f:	85 c0                	test   %eax,%eax
	int pid = fork();
 1a1:	89 c3                	mov    %eax,%ebx
	if (pid == 0){
 1a3:	0f 84 9b 03 00 00    	je     544 <main+0x544>
		if (prio_set(pid, 15) > 0){
 1a9:	57                   	push   %edi
 1aa:	57                   	push   %edi
 1ab:	6a 0f                	push   $0xf
 1ad:	50                   	push   %eax
 1ae:	e8 1f 09 00 00       	call   ad2 <prio_set>
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	85 c0                	test   %eax,%eax
 1b8:	0f 8e b4 03 00 00    	jle    572 <main+0x572>
			printf(1,"decrease child priority: PASSED, should pass\n");
 1be:	56                   	push   %esi
 1bf:	56                   	push   %esi
 1c0:	68 bc 10 00 00       	push   $0x10bc
 1c5:	6a 01                	push   $0x1
 1c7:	e8 c4 09 00 00       	call   b90 <printf>
 1cc:	83 c4 10             	add    $0x10,%esp
		if (prio_set(pid, 10) > 0){
 1cf:	52                   	push   %edx
 1d0:	52                   	push   %edx
 1d1:	6a 0a                	push   $0xa
 1d3:	53                   	push   %ebx
 1d4:	e8 f9 08 00 00       	call   ad2 <prio_set>
 1d9:	83 c4 10             	add    $0x10,%esp
 1dc:	85 c0                	test   %eax,%eax
 1de:	0f 8e ec 03 00 00    	jle    5d0 <main+0x5d0>
			printf(1,"set child priority to parent priority: PASSED, should pass\n");
 1e4:	50                   	push   %eax
 1e5:	50                   	push   %eax
 1e6:	68 1c 11 00 00       	push   $0x111c
 1eb:	6a 01                	push   $0x1
 1ed:	e8 9e 09 00 00       	call   b90 <printf>
 1f2:	83 c4 10             	add    $0x10,%esp
		if (prio_set(pid, 1) > 0){
 1f5:	50                   	push   %eax
 1f6:	50                   	push   %eax
 1f7:	6a 01                	push   $0x1
 1f9:	53                   	push   %ebx
 1fa:	e8 d3 08 00 00       	call   ad2 <prio_set>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	85 c0                	test   %eax,%eax
 204:	0f 8e b0 03 00 00    	jle    5ba <main+0x5ba>
			printf(1,"set child priority above parent: PASSED, should fail\n");
 20a:	50                   	push   %eax
 20b:	50                   	push   %eax
 20c:	68 94 11 00 00       	push   $0x1194
 211:	6a 01                	push   $0x1
 213:	e8 78 09 00 00       	call   b90 <printf>
 218:	83 c4 10             	add    $0x10,%esp
	return mcreate(name);
 21b:	83 ec 0c             	sub    $0xc,%esp
 21e:	be 05 00 00 00       	mov    $0x5,%esi
 223:	68 a0 0f 00 00       	push   $0xfa0
 228:	e8 75 08 00 00       	call   aa2 <mcreate>
 22d:	83 c4 10             	add    $0x10,%esp
 230:	89 c3                	mov    %eax,%ebx
 232:	eb 09                	jmp    23d <main+0x23d>
	for(i=0; i<5; i++){
 234:	83 ee 01             	sub    $0x1,%esi
 237:	0f 84 4b 03 00 00    	je     588 <main+0x588>
		if (fork() == 0){
 23d:	e8 b8 07 00 00       	call   9fa <fork>
 242:	85 c0                	test   %eax,%eax
 244:	75 ee                	jne    234 <main+0x234>
	return mlock(muxid);
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	53                   	push   %ebx
 24a:	e8 63 08 00 00       	call   ab2 <mlock>
			if (!mutex_lock(id)){
 24f:	83 c4 10             	add    $0x10,%esp
 252:	85 c0                	test   %eax,%eax
 254:	0f 84 d7 fe ff ff    	je     131 <main+0x131>
				printf(1,"%d\n", j);
 25a:	56                   	push   %esi
 25b:	6a 01                	push   $0x1
 25d:	68 a5 0f 00 00       	push   $0xfa5
 262:	6a 01                	push   $0x1
 264:	e8 27 09 00 00       	call   b90 <printf>
 269:	83 c4 0c             	add    $0xc,%esp
 26c:	6a 02                	push   $0x2
 26e:	68 a5 0f 00 00       	push   $0xfa5
 273:	6a 01                	push   $0x1
 275:	e8 16 09 00 00       	call   b90 <printf>
 27a:	83 c4 0c             	add    $0xc,%esp
 27d:	6a 03                	push   $0x3
 27f:	68 a5 0f 00 00       	push   $0xfa5
 284:	6a 01                	push   $0x1
 286:	e8 05 09 00 00       	call   b90 <printf>
			printf(1,"\n");
 28b:	5f                   	pop    %edi
 28c:	58                   	pop    %eax
 28d:	68 b7 0f 00 00       	push   $0xfb7
 292:	6a 01                	push   $0x1
 294:	e8 f7 08 00 00       	call   b90 <printf>
	return munlock(muxid);
 299:	89 1c 24             	mov    %ebx,(%esp)
 29c:	e8 19 08 00 00       	call   aba <munlock>
			if (!mutex_unlock(id)){
 2a1:	83 c4 10             	add    $0x10,%esp
 2a4:	85 c0                	test   %eax,%eax
 2a6:	75 11                	jne    2b9 <main+0x2b9>
				printf(1,"UNLOCK FAILURE\n");
 2a8:	51                   	push   %ecx
 2a9:	51                   	push   %ecx
 2aa:	68 45 0f 00 00       	push   $0xf45
 2af:	6a 01                	push   $0x1
 2b1:	e8 da 08 00 00       	call   b90 <printf>
 2b6:	83 c4 10             	add    $0x10,%esp
		exit();
 2b9:	e8 44 07 00 00       	call   a02 <exit>
			printf(1,"SIGNAL LOCK FAILURE\n");
 2be:	50                   	push   %eax
 2bf:	50                   	push   %eax
 2c0:	68 29 0f 00 00       	push   $0xf29
 2c5:	6a 01                	push   $0x1
 2c7:	e8 c4 08 00 00       	call   b90 <printf>
			exit();
 2cc:	e8 31 07 00 00       	call   a02 <exit>
	wait();
 2d1:	e8 34 07 00 00       	call   a0a <wait>
	printf(1,"CV SUCCESS\n");
 2d6:	50                   	push   %eax
 2d7:	50                   	push   %eax
 2d8:	68 66 0f 00 00       	push   $0xf66
 2dd:	6a 01                	push   $0x1
 2df:	e8 ac 08 00 00       	call   b90 <printf>
	struct myproc *p0 = (struct myproc*)malloc(sizeof(struct myproc));
 2e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 2eb:	e8 00 0b 00 00       	call   df0 <malloc>
	struct myproc *p1 = (struct myproc*)malloc(sizeof(struct myproc));
 2f0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
	struct myproc *p0 = (struct myproc*)malloc(sizeof(struct myproc));
 2f7:	89 c7                	mov    %eax,%edi
	struct myproc *p1 = (struct myproc*)malloc(sizeof(struct myproc));
 2f9:	e8 f2 0a 00 00       	call   df0 <malloc>
	struct myproc *p2 = (struct myproc*)malloc(sizeof(struct myproc));
 2fe:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
	struct myproc *p1 = (struct myproc*)malloc(sizeof(struct myproc));
 305:	89 c3                	mov    %eax,%ebx
	struct myproc *p2 = (struct myproc*)malloc(sizeof(struct myproc));
 307:	e8 e4 0a 00 00       	call   df0 <malloc>
	struct myproc *p3 = (struct myproc*)malloc(sizeof(struct myproc));
 30c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
	struct myproc *p2 = (struct myproc*)malloc(sizeof(struct myproc));
 313:	89 c6                	mov    %eax,%esi
 315:	89 45 dc             	mov    %eax,-0x24(%ebp)
	struct myproc *p3 = (struct myproc*)malloc(sizeof(struct myproc));
 318:	e8 d3 0a 00 00       	call   df0 <malloc>
	struct myproc *p4 = (struct myproc*)malloc(sizeof(struct myproc));
 31d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
	struct myproc *p3 = (struct myproc*)malloc(sizeof(struct myproc));
 324:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	struct myproc *p4 = (struct myproc*)malloc(sizeof(struct myproc));
 327:	e8 c4 0a 00 00       	call   df0 <malloc>
	struct myproc *p5 = (struct myproc*)malloc(sizeof(struct myproc));
 32c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
	struct myproc *p4 = (struct myproc*)malloc(sizeof(struct myproc));
 333:	89 45 e0             	mov    %eax,-0x20(%ebp)
	struct myproc *p5 = (struct myproc*)malloc(sizeof(struct myproc));
 336:	e8 b5 0a 00 00       	call   df0 <malloc>
	p3->priority = 3;	p3->name = "proc 3";
 33b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	struct myproc *p5 = (struct myproc*)malloc(sizeof(struct myproc));
 33e:	89 c1                	mov    %eax,%ecx
	p4->priority = 4;	p4->name = "proc 4";
 340:	8b 45 e0             	mov    -0x20(%ebp),%eax
	p0->priority = 0;	p0->name = "proc 0";
 343:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
 349:	c7 47 04 72 0f 00 00 	movl   $0xf72,0x4(%edi)
	p5->priority = 0;	p5->name = "proc 5";
 350:	83 c4 10             	add    $0x10,%esp
	p1->priority = 1;	p1->name = "proc 1";
 353:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
 359:	c7 43 04 79 0f 00 00 	movl   $0xf79,0x4(%ebx)
	p2->priority = 2;	p2->name = "proc 2";
 360:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
 366:	c7 46 04 80 0f 00 00 	movl   $0xf80,0x4(%esi)
	p3->priority = 3;	p3->name = "proc 3";
 36d:	c7 02 03 00 00 00    	movl   $0x3,(%edx)
 373:	c7 42 04 87 0f 00 00 	movl   $0xf87,0x4(%edx)
	p4->priority = 4;	p4->name = "proc 4";
 37a:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
 380:	c7 40 04 8e 0f 00 00 	movl   $0xf8e,0x4(%eax)
	p5->priority = 0;	p5->name = "proc 5";
 387:	31 c0                	xor    %eax,%eax
 389:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
 38f:	c7 41 04 95 0f 00 00 	movl   $0xf95,0x4(%ecx)
			head_tail[m][n] = 0;
 396:	c7 80 20 16 00 00 00 	movl   $0x0,0x1620(%eax)
 39d:	00 00 00 
 3a0:	c7 80 24 16 00 00 00 	movl   $0x0,0x1624(%eax)
 3a7:	00 00 00 
 3aa:	83 c0 08             	add    $0x8,%eax
	for (m=0; m<PRIO_MAX; m++){
 3ad:	83 f8 50             	cmp    $0x50,%eax
 3b0:	75 e4                	jne    396 <main+0x396>
	int priority = p->priority;
 3b2:	8b 37                	mov    (%edi),%esi
 3b4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
	if (tail == ((head-1)%QSIZE)){
 3b7:	8b 0c f5 20 16 00 00 	mov    0x1620(,%esi,8),%ecx
	int tail = head_tail[priority][1];
 3be:	8b 14 f5 24 16 00 00 	mov    0x1624(,%esi,8),%edx
	if (tail == ((head-1)%QSIZE)){
 3c5:	8d 41 ff             	lea    -0x1(%ecx),%eax
	int tail = head_tail[priority][1];
 3c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	if (tail == ((head-1)%QSIZE)){
 3cb:	b9 64 00 00 00       	mov    $0x64,%ecx
 3d0:	99                   	cltd   
 3d1:	f7 f9                	idiv   %ecx
 3d3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 3d6:	39 d1                	cmp    %edx,%ecx
 3d8:	74 1e                	je     3f8 <main+0x3f8>
	pqueues[priority][tail] = p;
 3da:	6b c6 64             	imul   $0x64,%esi,%eax
 3dd:	01 c8                	add    %ecx,%eax
 3df:	89 3c 85 80 16 00 00 	mov    %edi,0x1680(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 3e6:	8d 41 01             	lea    0x1(%ecx),%eax
 3e9:	b9 64 00 00 00       	mov    $0x64,%ecx
 3ee:	99                   	cltd   
 3ef:	f7 f9                	idiv   %ecx
 3f1:	89 14 f5 24 16 00 00 	mov    %edx,0x1624(,%esi,8)
	int priority = p->priority;
 3f8:	8b 33                	mov    (%ebx),%esi
	if (tail == ((head-1)%QSIZE)){
 3fa:	b9 64 00 00 00       	mov    $0x64,%ecx
 3ff:	8b 04 f5 20 16 00 00 	mov    0x1620(,%esi,8),%eax
	int tail = head_tail[priority][1];
 406:	8b 3c f5 24 16 00 00 	mov    0x1624(,%esi,8),%edi
	if (tail == ((head-1)%QSIZE)){
 40d:	83 e8 01             	sub    $0x1,%eax
 410:	99                   	cltd   
 411:	f7 f9                	idiv   %ecx
 413:	39 d7                	cmp    %edx,%edi
 415:	74 19                	je     430 <main+0x430>
	pqueues[priority][tail] = p;
 417:	6b c6 64             	imul   $0x64,%esi,%eax
 41a:	01 f8                	add    %edi,%eax
 41c:	89 1c 85 80 16 00 00 	mov    %ebx,0x1680(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 423:	8d 47 01             	lea    0x1(%edi),%eax
 426:	99                   	cltd   
 427:	f7 f9                	idiv   %ecx
 429:	89 14 f5 24 16 00 00 	mov    %edx,0x1624(,%esi,8)
	int priority = p->priority;
 430:	8b 4d dc             	mov    -0x24(%ebp),%ecx
	if (tail == ((head-1)%QSIZE)){
 433:	bf 64 00 00 00       	mov    $0x64,%edi
	int priority = p->priority;
 438:	8b 19                	mov    (%ecx),%ebx
	if (tail == ((head-1)%QSIZE)){
 43a:	8b 04 dd 20 16 00 00 	mov    0x1620(,%ebx,8),%eax
	int tail = head_tail[priority][1];
 441:	8b 34 dd 24 16 00 00 	mov    0x1624(,%ebx,8),%esi
	if (tail == ((head-1)%QSIZE)){
 448:	83 e8 01             	sub    $0x1,%eax
 44b:	99                   	cltd   
 44c:	f7 ff                	idiv   %edi
 44e:	39 d6                	cmp    %edx,%esi
 450:	74 19                	je     46b <main+0x46b>
	pqueues[priority][tail] = p;
 452:	6b c3 64             	imul   $0x64,%ebx,%eax
 455:	01 f0                	add    %esi,%eax
 457:	89 0c 85 80 16 00 00 	mov    %ecx,0x1680(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 45e:	8d 46 01             	lea    0x1(%esi),%eax
 461:	99                   	cltd   
 462:	f7 ff                	idiv   %edi
 464:	89 14 dd 24 16 00 00 	mov    %edx,0x1624(,%ebx,8)
	int priority = p->priority;
 46b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	if (tail == ((head-1)%QSIZE)){
 46e:	bf 64 00 00 00       	mov    $0x64,%edi
	int priority = p->priority;
 473:	8b 31                	mov    (%ecx),%esi
	if (tail == ((head-1)%QSIZE)){
 475:	8b 04 f5 20 16 00 00 	mov    0x1620(,%esi,8),%eax
	int tail = head_tail[priority][1];
 47c:	8b 1c f5 24 16 00 00 	mov    0x1624(,%esi,8),%ebx
	if (tail == ((head-1)%QSIZE)){
 483:	83 e8 01             	sub    $0x1,%eax
 486:	99                   	cltd   
 487:	f7 ff                	idiv   %edi
 489:	39 d3                	cmp    %edx,%ebx
 48b:	74 19                	je     4a6 <main+0x4a6>
	pqueues[priority][tail] = p;
 48d:	6b c6 64             	imul   $0x64,%esi,%eax
 490:	01 d8                	add    %ebx,%eax
 492:	89 0c 85 80 16 00 00 	mov    %ecx,0x1680(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 499:	8d 43 01             	lea    0x1(%ebx),%eax
 49c:	99                   	cltd   
 49d:	f7 ff                	idiv   %edi
 49f:	89 14 f5 24 16 00 00 	mov    %edx,0x1624(,%esi,8)
	int priority = p->priority;
 4a6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
	if (tail == ((head-1)%QSIZE)){
 4a9:	bf 64 00 00 00       	mov    $0x64,%edi
	int priority = p->priority;
 4ae:	8b 31                	mov    (%ecx),%esi
	if (tail == ((head-1)%QSIZE)){
 4b0:	8b 04 f5 20 16 00 00 	mov    0x1620(,%esi,8),%eax
	int tail = head_tail[priority][1];
 4b7:	8b 1c f5 24 16 00 00 	mov    0x1624(,%esi,8),%ebx
	if (tail == ((head-1)%QSIZE)){
 4be:	83 e8 01             	sub    $0x1,%eax
 4c1:	99                   	cltd   
 4c2:	f7 ff                	idiv   %edi
 4c4:	39 d3                	cmp    %edx,%ebx
 4c6:	74 19                	je     4e1 <main+0x4e1>
	pqueues[priority][tail] = p;
 4c8:	6b c6 64             	imul   $0x64,%esi,%eax
 4cb:	01 d8                	add    %ebx,%eax
 4cd:	89 0c 85 80 16 00 00 	mov    %ecx,0x1680(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 4d4:	8d 43 01             	lea    0x1(%ebx),%eax
 4d7:	99                   	cltd   
 4d8:	f7 ff                	idiv   %edi
 4da:	89 14 f5 24 16 00 00 	mov    %edx,0x1624(,%esi,8)
	int priority = p->priority;
 4e1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
	if (tail == ((head-1)%QSIZE)){
 4e4:	bf 64 00 00 00       	mov    $0x64,%edi
	int priority = p->priority;
 4e9:	8b 31                	mov    (%ecx),%esi
	if (tail == ((head-1)%QSIZE)){
 4eb:	8b 04 f5 20 16 00 00 	mov    0x1620(,%esi,8),%eax
	int tail = head_tail[priority][1];
 4f2:	8b 1c f5 24 16 00 00 	mov    0x1624(,%esi,8),%ebx
	if (tail == ((head-1)%QSIZE)){
 4f9:	83 e8 01             	sub    $0x1,%eax
 4fc:	99                   	cltd   
 4fd:	f7 ff                	idiv   %edi
 4ff:	39 d3                	cmp    %edx,%ebx
 501:	74 19                	je     51c <main+0x51c>
	pqueues[priority][tail] = p;
 503:	6b c6 64             	imul   $0x64,%esi,%eax
 506:	01 d8                	add    %ebx,%eax
 508:	89 0c 85 80 16 00 00 	mov    %ecx,0x1680(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 50f:	8d 43 01             	lea    0x1(%ebx),%eax
 512:	99                   	cltd   
 513:	f7 ff                	idiv   %edi
 515:	89 14 f5 24 16 00 00 	mov    %edx,0x1624(,%esi,8)
	struct myproc *p = pq_dequeue();
 51c:	e8 9f 01 00 00       	call   6c0 <pq_dequeue>
	while (p != NULL){
 521:	83 f8 ff             	cmp    $0xffffffff,%eax
 524:	0f 84 1a fc ff ff    	je     144 <main+0x144>
		printf(1, "%s\n",p->name);
 52a:	57                   	push   %edi
 52b:	ff 70 04             	pushl  0x4(%eax)
 52e:	68 9c 0f 00 00       	push   $0xf9c
 533:	6a 01                	push   $0x1
 535:	e8 56 06 00 00       	call   b90 <printf>
		p = pq_dequeue();
 53a:	e8 81 01 00 00       	call   6c0 <pq_dequeue>
 53f:	83 c4 10             	add    $0x10,%esp
 542:	eb dd                	jmp    521 <main+0x521>
 544:	eb fe                	jmp    544 <main+0x544>
		printf(1,"increase priority: FAILED, should fail\n");
 546:	50                   	push   %eax
 547:	50                   	push   %eax
 548:	68 94 10 00 00       	push   $0x1094
 54d:	6a 01                	push   $0x1
 54f:	e8 3c 06 00 00       	call   b90 <printf>
 554:	83 c4 10             	add    $0x10,%esp
 557:	e9 3e fc ff ff       	jmp    19a <main+0x19a>
		printf(1,"decrease priority: FAILED, should pass\n");
 55c:	51                   	push   %ecx
 55d:	51                   	push   %ecx
 55e:	68 44 10 00 00       	push   $0x1044
 563:	6a 01                	push   $0x1
 565:	e8 26 06 00 00       	call   b90 <printf>
 56a:	83 c4 10             	add    $0x10,%esp
 56d:	e9 fd fb ff ff       	jmp    16f <main+0x16f>
			printf(1,"decrease child priority: FAILED, should pass\n");
 572:	51                   	push   %ecx
 573:	51                   	push   %ecx
 574:	68 ec 10 00 00       	push   $0x10ec
 579:	6a 01                	push   $0x1
 57b:	e8 10 06 00 00       	call   b90 <printf>
 580:	83 c4 10             	add    $0x10,%esp
 583:	e9 47 fc ff ff       	jmp    1cf <main+0x1cf>
 588:	be 0a 00 00 00       	mov    $0xa,%esi
		wait();
 58d:	e8 78 04 00 00       	call   a0a <wait>
	for(i=0; i<10; i++){
 592:	83 ee 01             	sub    $0x1,%esi
 595:	75 f6                	jne    58d <main+0x58d>
	return mdelete(muxid);
 597:	83 ec 0c             	sub    $0xc,%esp
 59a:	53                   	push   %ebx
 59b:	e8 0a 05 00 00       	call   aaa <mdelete>
	if (!mutex_delete(id)){
 5a0:	83 c4 10             	add    $0x10,%esp
 5a3:	85 c0                	test   %eax,%eax
 5a5:	75 3f                	jne    5e6 <main+0x5e6>
		printf(1,"DELETE FAILURE\n");
 5a7:	52                   	push   %edx
 5a8:	52                   	push   %edx
 5a9:	68 a9 0f 00 00       	push   $0xfa9
 5ae:	6a 01                	push   $0x1
 5b0:	e8 db 05 00 00       	call   b90 <printf>
		exit();
 5b5:	e8 48 04 00 00       	call   a02 <exit>
			printf(1,"set child priority above parent: FAILED, should fail\n");
 5ba:	50                   	push   %eax
 5bb:	50                   	push   %eax
 5bc:	68 cc 11 00 00       	push   $0x11cc
 5c1:	6a 01                	push   $0x1
 5c3:	e8 c8 05 00 00       	call   b90 <printf>
 5c8:	83 c4 10             	add    $0x10,%esp
 5cb:	e9 4b fc ff ff       	jmp    21b <main+0x21b>
			printf(1,"set child priority to parent priority: FAILED, should pass\n");
 5d0:	50                   	push   %eax
 5d1:	50                   	push   %eax
 5d2:	68 58 11 00 00       	push   $0x1158
 5d7:	6a 01                	push   $0x1
 5d9:	e8 b2 05 00 00       	call   b90 <printf>
 5de:	83 c4 10             	add    $0x10,%esp
 5e1:	e9 0f fc ff ff       	jmp    1f5 <main+0x1f5>
	return mlock(muxid);
 5e6:	83 ec 0c             	sub    $0xc,%esp
 5e9:	53                   	push   %ebx
 5ea:	e8 c3 04 00 00       	call   ab2 <mlock>
	if (!mutex_lock(id)){
 5ef:	83 c4 10             	add    $0x10,%esp
 5f2:	85 c0                	test   %eax,%eax
 5f4:	0f 85 bf fc ff ff    	jne    2b9 <main+0x2b9>
		printf(1,"DELETE SUCCESS\n");
 5fa:	50                   	push   %eax
 5fb:	50                   	push   %eax
 5fc:	68 b9 0f 00 00       	push   $0xfb9
 601:	6a 01                	push   $0x1
 603:	e8 88 05 00 00       	call   b90 <printf>
		exit();
 608:	e8 f5 03 00 00       	call   a02 <exit>
 60d:	66 90                	xchg   %ax,%ax
 60f:	90                   	nop

00000610 <init_queue>:
void init_queue(){
 610:	55                   	push   %ebp
 611:	b8 20 16 00 00       	mov    $0x1620,%eax
 616:	89 e5                	mov    %esp,%ebp
 618:	90                   	nop
 619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			head_tail[m][n] = 0;
 620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 626:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
 62d:	83 c0 08             	add    $0x8,%eax
	for (m=0; m<PRIO_MAX; m++){
 630:	3d 70 16 00 00       	cmp    $0x1670,%eax
 635:	75 e9                	jne    620 <init_queue+0x10>
}
 637:	5d                   	pop    %ebp
 638:	c3                   	ret    
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000640 <pq_enqueue>:
pq_enqueue (struct myproc *p){
 640:	55                   	push   %ebp
	if (tail == ((head-1)%QSIZE)){
 641:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
pq_enqueue (struct myproc *p){
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
	int priority = p->priority;
 64a:	8b 45 08             	mov    0x8(%ebp),%eax
pq_enqueue (struct myproc *p){
 64d:	53                   	push   %ebx
	int priority = p->priority;
 64e:	8b 38                	mov    (%eax),%edi
	if (tail == ((head-1)%QSIZE)){
 650:	8b 04 fd 20 16 00 00 	mov    0x1620(,%edi,8),%eax
	int tail = head_tail[priority][1];
 657:	8b 1c fd 24 16 00 00 	mov    0x1624(,%edi,8),%ebx
	if (tail == ((head-1)%QSIZE)){
 65e:	8d 70 ff             	lea    -0x1(%eax),%esi
 661:	89 f0                	mov    %esi,%eax
 663:	f7 e9                	imul   %ecx
 665:	89 f0                	mov    %esi,%eax
 667:	c1 f8 1f             	sar    $0x1f,%eax
 66a:	c1 fa 05             	sar    $0x5,%edx
 66d:	29 c2                	sub    %eax,%edx
 66f:	6b d2 64             	imul   $0x64,%edx,%edx
 672:	29 d6                	sub    %edx,%esi
 674:	39 de                	cmp    %ebx,%esi
 676:	74 38                	je     6b0 <pq_enqueue+0x70>
	pqueues[priority][tail] = p;
 678:	6b c7 64             	imul   $0x64,%edi,%eax
 67b:	8b 75 08             	mov    0x8(%ebp),%esi
 67e:	01 d8                	add    %ebx,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
 680:	83 c3 01             	add    $0x1,%ebx
	pqueues[priority][tail] = p;
 683:	89 34 85 80 16 00 00 	mov    %esi,0x1680(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
 68a:	89 d8                	mov    %ebx,%eax
 68c:	f7 e9                	imul   %ecx
 68e:	89 d8                	mov    %ebx,%eax
 690:	c1 f8 1f             	sar    $0x1f,%eax
 693:	89 d1                	mov    %edx,%ecx
 695:	c1 f9 05             	sar    $0x5,%ecx
 698:	29 c1                	sub    %eax,%ecx
	return 1;
 69a:	b8 01 00 00 00       	mov    $0x1,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
 69f:	6b c9 64             	imul   $0x64,%ecx,%ecx
 6a2:	29 cb                	sub    %ecx,%ebx
 6a4:	89 1c fd 24 16 00 00 	mov    %ebx,0x1624(,%edi,8)
}
 6ab:	5b                   	pop    %ebx
 6ac:	5e                   	pop    %esi
 6ad:	5f                   	pop    %edi
 6ae:	5d                   	pop    %ebp
 6af:	c3                   	ret    
		return -1;
 6b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6b5:	eb f4                	jmp    6ab <pq_enqueue+0x6b>
 6b7:	89 f6                	mov    %esi,%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006c0 <pq_dequeue>:
pq_dequeue(){
 6c0:	55                   	push   %ebp
	int priority = 0;
 6c1:	31 c9                	xor    %ecx,%ecx
pq_dequeue(){
 6c3:	89 e5                	mov    %esp,%ebp
 6c5:	56                   	push   %esi
 6c6:	53                   	push   %ebx
 6c7:	89 f6                	mov    %esi,%esi
 6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
 6d0:	8b 04 cd 20 16 00 00 	mov    0x1620(,%ecx,8),%eax
 6d7:	3b 04 cd 24 16 00 00 	cmp    0x1624(,%ecx,8),%eax
 6de:	75 30                	jne    710 <pq_dequeue+0x50>
		priority++;
 6e0:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
 6e3:	83 f9 0a             	cmp    $0xa,%ecx
 6e6:	75 e8                	jne    6d0 <pq_dequeue+0x10>
		printf(1,"all queues are empty\n");
 6e8:	83 ec 08             	sub    $0x8,%esp
 6eb:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6f0:	68 e8 0e 00 00       	push   $0xee8
 6f5:	6a 01                	push   $0x1
 6f7:	e8 94 04 00 00       	call   b90 <printf>
 6fc:	83 c4 10             	add    $0x10,%esp
}
 6ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
 702:	89 f0                	mov    %esi,%eax
 704:	5b                   	pop    %ebx
 705:	5e                   	pop    %esi
 706:	5d                   	pop    %ebp
 707:	c3                   	ret    
 708:	90                   	nop
 709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	struct myproc *p = pqueues[priority][head];
 710:	6b d1 64             	imul   $0x64,%ecx,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 713:	8d 58 01             	lea    0x1(%eax),%ebx
	struct myproc *p = pqueues[priority][head];
 716:	01 c2                	add    %eax,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 718:	89 d8                	mov    %ebx,%eax
	struct myproc *p = pqueues[priority][head];
 71a:	8b 34 95 80 16 00 00 	mov    0x1680(,%edx,4),%esi
	head_tail[priority][0] = (head+1)%QSIZE;
 721:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 726:	f7 ea                	imul   %edx
 728:	89 d8                	mov    %ebx,%eax
 72a:	c1 f8 1f             	sar    $0x1f,%eax
 72d:	c1 fa 05             	sar    $0x5,%edx
 730:	29 c2                	sub    %eax,%edx
 732:	89 d8                	mov    %ebx,%eax
 734:	6b d2 64             	imul   $0x64,%edx,%edx
 737:	29 d0                	sub    %edx,%eax
 739:	89 04 cd 20 16 00 00 	mov    %eax,0x1620(,%ecx,8)
}
 740:	8d 65 f8             	lea    -0x8(%ebp),%esp
 743:	89 f0                	mov    %esi,%eax
 745:	5b                   	pop    %ebx
 746:	5e                   	pop    %esi
 747:	5d                   	pop    %ebp
 748:	c3                   	ret    
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000750 <mutex_create>:
int mutex_create(char *name){
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
}
 753:	5d                   	pop    %ebp
	return mcreate(name);
 754:	e9 49 03 00 00       	jmp    aa2 <mcreate>
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000760 <mutex_delete>:
int mutex_delete(int muxid){
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
}
 763:	5d                   	pop    %ebp
	return mdelete(muxid);
 764:	e9 41 03 00 00       	jmp    aaa <mdelete>
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000770 <mutex_lock>:
int mutex_lock(int muxid){
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
}
 773:	5d                   	pop    %ebp
	return mlock(muxid);
 774:	e9 39 03 00 00       	jmp    ab2 <mlock>
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000780 <mutex_unlock>:
int mutex_unlock(int muxid){
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
}
 783:	5d                   	pop    %ebp
	return munlock(muxid);
 784:	e9 31 03 00 00       	jmp    aba <munlock>
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000790 <cv_wait>:
int cv_wait(int muxid){
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
}
 793:	5d                   	pop    %ebp
	return waitcv(muxid);
 794:	e9 29 03 00 00       	jmp    ac2 <waitcv>
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007a0 <cv_signal>:
int cv_signal(int muxid){
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	5d                   	pop    %ebp
	return signalcv(muxid);
 7a4:	e9 21 03 00 00       	jmp    aca <signalcv>
 7a9:	66 90                	xchg   %ax,%ax
 7ab:	66 90                	xchg   %ax,%ax
 7ad:	66 90                	xchg   %ax,%ax
 7af:	90                   	nop

000007b0 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	53                   	push   %ebx
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
 7b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 7ba:	89 c2                	mov    %eax,%edx
 7bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7c0:	83 c1 01             	add    $0x1,%ecx
 7c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 7c7:	83 c2 01             	add    $0x1,%edx
 7ca:	84 db                	test   %bl,%bl
 7cc:	88 5a ff             	mov    %bl,-0x1(%edx)
 7cf:	75 ef                	jne    7c0 <strcpy+0x10>
		;
	return os;
}
 7d1:	5b                   	pop    %ebx
 7d2:	5d                   	pop    %ebp
 7d3:	c3                   	ret    
 7d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000007e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	53                   	push   %ebx
 7e4:	8b 55 08             	mov    0x8(%ebp),%edx
 7e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 7ea:	0f b6 02             	movzbl (%edx),%eax
 7ed:	0f b6 19             	movzbl (%ecx),%ebx
 7f0:	84 c0                	test   %al,%al
 7f2:	75 1c                	jne    810 <strcmp+0x30>
 7f4:	eb 2a                	jmp    820 <strcmp+0x40>
 7f6:	8d 76 00             	lea    0x0(%esi),%esi
 7f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 800:	83 c2 01             	add    $0x1,%edx
 803:	0f b6 02             	movzbl (%edx),%eax
 806:	83 c1 01             	add    $0x1,%ecx
 809:	0f b6 19             	movzbl (%ecx),%ebx
 80c:	84 c0                	test   %al,%al
 80e:	74 10                	je     820 <strcmp+0x40>
 810:	38 d8                	cmp    %bl,%al
 812:	74 ec                	je     800 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 814:	29 d8                	sub    %ebx,%eax
}
 816:	5b                   	pop    %ebx
 817:	5d                   	pop    %ebp
 818:	c3                   	ret    
 819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 820:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 822:	29 d8                	sub    %ebx,%eax
}
 824:	5b                   	pop    %ebx
 825:	5d                   	pop    %ebp
 826:	c3                   	ret    
 827:	89 f6                	mov    %esi,%esi
 829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000830 <strlen>:

uint
strlen(char *s)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 836:	80 39 00             	cmpb   $0x0,(%ecx)
 839:	74 15                	je     850 <strlen+0x20>
 83b:	31 d2                	xor    %edx,%edx
 83d:	8d 76 00             	lea    0x0(%esi),%esi
 840:	83 c2 01             	add    $0x1,%edx
 843:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 847:	89 d0                	mov    %edx,%eax
 849:	75 f5                	jne    840 <strlen+0x10>
		;
	return n;
}
 84b:	5d                   	pop    %ebp
 84c:	c3                   	ret    
 84d:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 850:	31 c0                	xor    %eax,%eax
}
 852:	5d                   	pop    %ebp
 853:	c3                   	ret    
 854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 85a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000860 <memset>:

void *
memset(void *dst, int c, uint n)
{
 860:	55                   	push   %ebp
 861:	89 e5                	mov    %esp,%ebp
 863:	57                   	push   %edi
 864:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 867:	8b 4d 10             	mov    0x10(%ebp),%ecx
 86a:	8b 45 0c             	mov    0xc(%ebp),%eax
 86d:	89 d7                	mov    %edx,%edi
 86f:	fc                   	cld    
 870:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 872:	89 d0                	mov    %edx,%eax
 874:	5f                   	pop    %edi
 875:	5d                   	pop    %ebp
 876:	c3                   	ret    
 877:	89 f6                	mov    %esi,%esi
 879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000880 <strchr>:

char *
strchr(const char *s, char c)
{
 880:	55                   	push   %ebp
 881:	89 e5                	mov    %esp,%ebp
 883:	53                   	push   %ebx
 884:	8b 45 08             	mov    0x8(%ebp),%eax
 887:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 88a:	0f b6 10             	movzbl (%eax),%edx
 88d:	84 d2                	test   %dl,%dl
 88f:	74 1d                	je     8ae <strchr+0x2e>
		if (*s == c) return (char *)s;
 891:	38 d3                	cmp    %dl,%bl
 893:	89 d9                	mov    %ebx,%ecx
 895:	75 0d                	jne    8a4 <strchr+0x24>
 897:	eb 17                	jmp    8b0 <strchr+0x30>
 899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8a0:	38 ca                	cmp    %cl,%dl
 8a2:	74 0c                	je     8b0 <strchr+0x30>
	for (; *s; s++)
 8a4:	83 c0 01             	add    $0x1,%eax
 8a7:	0f b6 10             	movzbl (%eax),%edx
 8aa:	84 d2                	test   %dl,%dl
 8ac:	75 f2                	jne    8a0 <strchr+0x20>
	return 0;
 8ae:	31 c0                	xor    %eax,%eax
}
 8b0:	5b                   	pop    %ebx
 8b1:	5d                   	pop    %ebp
 8b2:	c3                   	ret    
 8b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008c0 <gets>:

char *
gets(char *buf, int max)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	57                   	push   %edi
 8c4:	56                   	push   %esi
 8c5:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 8c6:	31 f6                	xor    %esi,%esi
 8c8:	89 f3                	mov    %esi,%ebx
{
 8ca:	83 ec 1c             	sub    $0x1c,%esp
 8cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 8d0:	eb 2f                	jmp    901 <gets+0x41>
 8d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 8d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 8db:	83 ec 04             	sub    $0x4,%esp
 8de:	6a 01                	push   $0x1
 8e0:	50                   	push   %eax
 8e1:	6a 00                	push   $0x0
 8e3:	e8 32 01 00 00       	call   a1a <read>
		if (cc < 1) break;
 8e8:	83 c4 10             	add    $0x10,%esp
 8eb:	85 c0                	test   %eax,%eax
 8ed:	7e 1c                	jle    90b <gets+0x4b>
		buf[i++] = c;
 8ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 8f3:	83 c7 01             	add    $0x1,%edi
 8f6:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 8f9:	3c 0a                	cmp    $0xa,%al
 8fb:	74 23                	je     920 <gets+0x60>
 8fd:	3c 0d                	cmp    $0xd,%al
 8ff:	74 1f                	je     920 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 901:	83 c3 01             	add    $0x1,%ebx
 904:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 907:	89 fe                	mov    %edi,%esi
 909:	7c cd                	jl     8d8 <gets+0x18>
 90b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 90d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 910:	c6 03 00             	movb   $0x0,(%ebx)
}
 913:	8d 65 f4             	lea    -0xc(%ebp),%esp
 916:	5b                   	pop    %ebx
 917:	5e                   	pop    %esi
 918:	5f                   	pop    %edi
 919:	5d                   	pop    %ebp
 91a:	c3                   	ret    
 91b:	90                   	nop
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 920:	8b 75 08             	mov    0x8(%ebp),%esi
 923:	8b 45 08             	mov    0x8(%ebp),%eax
 926:	01 de                	add    %ebx,%esi
 928:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 92a:	c6 03 00             	movb   $0x0,(%ebx)
}
 92d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 930:	5b                   	pop    %ebx
 931:	5e                   	pop    %esi
 932:	5f                   	pop    %edi
 933:	5d                   	pop    %ebp
 934:	c3                   	ret    
 935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000940 <stat>:

int
stat(char *n, struct stat *st)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	56                   	push   %esi
 944:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 945:	83 ec 08             	sub    $0x8,%esp
 948:	6a 00                	push   $0x0
 94a:	ff 75 08             	pushl  0x8(%ebp)
 94d:	e8 f0 00 00 00       	call   a42 <open>
	if (fd < 0) return -1;
 952:	83 c4 10             	add    $0x10,%esp
 955:	85 c0                	test   %eax,%eax
 957:	78 27                	js     980 <stat+0x40>
	r = fstat(fd, st);
 959:	83 ec 08             	sub    $0x8,%esp
 95c:	ff 75 0c             	pushl  0xc(%ebp)
 95f:	89 c3                	mov    %eax,%ebx
 961:	50                   	push   %eax
 962:	e8 f3 00 00 00       	call   a5a <fstat>
	close(fd);
 967:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 96a:	89 c6                	mov    %eax,%esi
	close(fd);
 96c:	e8 b9 00 00 00       	call   a2a <close>
	return r;
 971:	83 c4 10             	add    $0x10,%esp
}
 974:	8d 65 f8             	lea    -0x8(%ebp),%esp
 977:	89 f0                	mov    %esi,%eax
 979:	5b                   	pop    %ebx
 97a:	5e                   	pop    %esi
 97b:	5d                   	pop    %ebp
 97c:	c3                   	ret    
 97d:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 980:	be ff ff ff ff       	mov    $0xffffffff,%esi
 985:	eb ed                	jmp    974 <stat+0x34>
 987:	89 f6                	mov    %esi,%esi
 989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000990 <atoi>:

int
atoi(const char *s)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	53                   	push   %ebx
 994:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 997:	0f be 11             	movsbl (%ecx),%edx
 99a:	8d 42 d0             	lea    -0x30(%edx),%eax
 99d:	3c 09                	cmp    $0x9,%al
	n = 0;
 99f:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 9a4:	77 1f                	ja     9c5 <atoi+0x35>
 9a6:	8d 76 00             	lea    0x0(%esi),%esi
 9a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 9b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 9b3:	83 c1 01             	add    $0x1,%ecx
 9b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 9ba:	0f be 11             	movsbl (%ecx),%edx
 9bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 9c0:	80 fb 09             	cmp    $0x9,%bl
 9c3:	76 eb                	jbe    9b0 <atoi+0x20>
	return n;
}
 9c5:	5b                   	pop    %ebx
 9c6:	5d                   	pop    %ebp
 9c7:	c3                   	ret    
 9c8:	90                   	nop
 9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009d0 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	56                   	push   %esi
 9d4:	53                   	push   %ebx
 9d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9d8:	8b 45 08             	mov    0x8(%ebp),%eax
 9db:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 9de:	85 db                	test   %ebx,%ebx
 9e0:	7e 14                	jle    9f6 <memmove+0x26>
 9e2:	31 d2                	xor    %edx,%edx
 9e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 9e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 9ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 9ef:	83 c2 01             	add    $0x1,%edx
 9f2:	39 d3                	cmp    %edx,%ebx
 9f4:	75 f2                	jne    9e8 <memmove+0x18>
	return vdst;
}
 9f6:	5b                   	pop    %ebx
 9f7:	5e                   	pop    %esi
 9f8:	5d                   	pop    %ebp
 9f9:	c3                   	ret    

000009fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 9fa:	b8 01 00 00 00       	mov    $0x1,%eax
 9ff:	cd 40                	int    $0x40
 a01:	c3                   	ret    

00000a02 <exit>:
SYSCALL(exit)
 a02:	b8 02 00 00 00       	mov    $0x2,%eax
 a07:	cd 40                	int    $0x40
 a09:	c3                   	ret    

00000a0a <wait>:
SYSCALL(wait)
 a0a:	b8 03 00 00 00       	mov    $0x3,%eax
 a0f:	cd 40                	int    $0x40
 a11:	c3                   	ret    

00000a12 <pipe>:
SYSCALL(pipe)
 a12:	b8 04 00 00 00       	mov    $0x4,%eax
 a17:	cd 40                	int    $0x40
 a19:	c3                   	ret    

00000a1a <read>:
SYSCALL(read)
 a1a:	b8 05 00 00 00       	mov    $0x5,%eax
 a1f:	cd 40                	int    $0x40
 a21:	c3                   	ret    

00000a22 <write>:
SYSCALL(write)
 a22:	b8 10 00 00 00       	mov    $0x10,%eax
 a27:	cd 40                	int    $0x40
 a29:	c3                   	ret    

00000a2a <close>:
SYSCALL(close)
 a2a:	b8 15 00 00 00       	mov    $0x15,%eax
 a2f:	cd 40                	int    $0x40
 a31:	c3                   	ret    

00000a32 <kill>:
SYSCALL(kill)
 a32:	b8 06 00 00 00       	mov    $0x6,%eax
 a37:	cd 40                	int    $0x40
 a39:	c3                   	ret    

00000a3a <exec>:
SYSCALL(exec)
 a3a:	b8 07 00 00 00       	mov    $0x7,%eax
 a3f:	cd 40                	int    $0x40
 a41:	c3                   	ret    

00000a42 <open>:
SYSCALL(open)
 a42:	b8 0f 00 00 00       	mov    $0xf,%eax
 a47:	cd 40                	int    $0x40
 a49:	c3                   	ret    

00000a4a <mknod>:
SYSCALL(mknod)
 a4a:	b8 11 00 00 00       	mov    $0x11,%eax
 a4f:	cd 40                	int    $0x40
 a51:	c3                   	ret    

00000a52 <unlink>:
SYSCALL(unlink)
 a52:	b8 12 00 00 00       	mov    $0x12,%eax
 a57:	cd 40                	int    $0x40
 a59:	c3                   	ret    

00000a5a <fstat>:
SYSCALL(fstat)
 a5a:	b8 08 00 00 00       	mov    $0x8,%eax
 a5f:	cd 40                	int    $0x40
 a61:	c3                   	ret    

00000a62 <link>:
SYSCALL(link)
 a62:	b8 13 00 00 00       	mov    $0x13,%eax
 a67:	cd 40                	int    $0x40
 a69:	c3                   	ret    

00000a6a <mkdir>:
SYSCALL(mkdir)
 a6a:	b8 14 00 00 00       	mov    $0x14,%eax
 a6f:	cd 40                	int    $0x40
 a71:	c3                   	ret    

00000a72 <chdir>:
SYSCALL(chdir)
 a72:	b8 09 00 00 00       	mov    $0x9,%eax
 a77:	cd 40                	int    $0x40
 a79:	c3                   	ret    

00000a7a <dup>:
SYSCALL(dup)
 a7a:	b8 0a 00 00 00       	mov    $0xa,%eax
 a7f:	cd 40                	int    $0x40
 a81:	c3                   	ret    

00000a82 <getpid>:
SYSCALL(getpid)
 a82:	b8 0b 00 00 00       	mov    $0xb,%eax
 a87:	cd 40                	int    $0x40
 a89:	c3                   	ret    

00000a8a <sbrk>:
SYSCALL(sbrk)
 a8a:	b8 0c 00 00 00       	mov    $0xc,%eax
 a8f:	cd 40                	int    $0x40
 a91:	c3                   	ret    

00000a92 <sleep>:
SYSCALL(sleep)
 a92:	b8 0d 00 00 00       	mov    $0xd,%eax
 a97:	cd 40                	int    $0x40
 a99:	c3                   	ret    

00000a9a <uptime>:
SYSCALL(uptime)
 a9a:	b8 0e 00 00 00       	mov    $0xe,%eax
 a9f:	cd 40                	int    $0x40
 aa1:	c3                   	ret    

00000aa2 <mcreate>:
SYSCALL(mcreate)
 aa2:	b8 16 00 00 00       	mov    $0x16,%eax
 aa7:	cd 40                	int    $0x40
 aa9:	c3                   	ret    

00000aaa <mdelete>:
SYSCALL(mdelete)
 aaa:	b8 17 00 00 00       	mov    $0x17,%eax
 aaf:	cd 40                	int    $0x40
 ab1:	c3                   	ret    

00000ab2 <mlock>:
SYSCALL(mlock)
 ab2:	b8 18 00 00 00       	mov    $0x18,%eax
 ab7:	cd 40                	int    $0x40
 ab9:	c3                   	ret    

00000aba <munlock>:
SYSCALL(munlock)
 aba:	b8 19 00 00 00       	mov    $0x19,%eax
 abf:	cd 40                	int    $0x40
 ac1:	c3                   	ret    

00000ac2 <waitcv>:
SYSCALL(waitcv)
 ac2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 ac7:	cd 40                	int    $0x40
 ac9:	c3                   	ret    

00000aca <signalcv>:
SYSCALL(signalcv)
 aca:	b8 1b 00 00 00       	mov    $0x1b,%eax
 acf:	cd 40                	int    $0x40
 ad1:	c3                   	ret    

00000ad2 <prio_set>:
SYSCALL(prio_set)
 ad2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 ad7:	cd 40                	int    $0x40
 ad9:	c3                   	ret    

00000ada <testpqeq>:
SYSCALL(testpqeq)
 ada:	b8 1d 00 00 00       	mov    $0x1d,%eax
 adf:	cd 40                	int    $0x40
 ae1:	c3                   	ret    

00000ae2 <testpqdq>:
SYSCALL(testpqdq)
 ae2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 ae7:	cd 40                	int    $0x40
 ae9:	c3                   	ret    
 aea:	66 90                	xchg   %ax,%ax
 aec:	66 90                	xchg   %ax,%ax
 aee:	66 90                	xchg   %ax,%ax

00000af0 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 af0:	55                   	push   %ebp
 af1:	89 e5                	mov    %esp,%ebp
 af3:	57                   	push   %edi
 af4:	56                   	push   %esi
 af5:	53                   	push   %ebx
 af6:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 af9:	85 d2                	test   %edx,%edx
{
 afb:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 afe:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 b00:	79 76                	jns    b78 <printint+0x88>
 b02:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 b06:	74 70                	je     b78 <printint+0x88>
		x   = -xx;
 b08:	f7 d8                	neg    %eax
		neg = 1;
 b0a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 b11:	31 f6                	xor    %esi,%esi
 b13:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 b16:	eb 0a                	jmp    b22 <printint+0x32>
 b18:	90                   	nop
 b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 b20:	89 fe                	mov    %edi,%esi
 b22:	31 d2                	xor    %edx,%edx
 b24:	8d 7e 01             	lea    0x1(%esi),%edi
 b27:	f7 f1                	div    %ecx
 b29:	0f b6 92 0c 12 00 00 	movzbl 0x120c(%edx),%edx
	} while ((x /= base) != 0);
 b30:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 b32:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 b35:	75 e9                	jne    b20 <printint+0x30>
	if (neg) buf[i++] = '-';
 b37:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 b3a:	85 c0                	test   %eax,%eax
 b3c:	74 08                	je     b46 <printint+0x56>
 b3e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 b43:	8d 7e 02             	lea    0x2(%esi),%edi
 b46:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 b4a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 b4d:	8d 76 00             	lea    0x0(%esi),%esi
 b50:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 b53:	83 ec 04             	sub    $0x4,%esp
 b56:	83 ee 01             	sub    $0x1,%esi
 b59:	6a 01                	push   $0x1
 b5b:	53                   	push   %ebx
 b5c:	57                   	push   %edi
 b5d:	88 45 d7             	mov    %al,-0x29(%ebp)
 b60:	e8 bd fe ff ff       	call   a22 <write>

	while (--i >= 0) putc(fd, buf[i]);
 b65:	83 c4 10             	add    $0x10,%esp
 b68:	39 de                	cmp    %ebx,%esi
 b6a:	75 e4                	jne    b50 <printint+0x60>
}
 b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b6f:	5b                   	pop    %ebx
 b70:	5e                   	pop    %esi
 b71:	5f                   	pop    %edi
 b72:	5d                   	pop    %ebp
 b73:	c3                   	ret    
 b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 b78:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 b7f:	eb 90                	jmp    b11 <printint+0x21>
 b81:	eb 0d                	jmp    b90 <printf>
 b83:	90                   	nop
 b84:	90                   	nop
 b85:	90                   	nop
 b86:	90                   	nop
 b87:	90                   	nop
 b88:	90                   	nop
 b89:	90                   	nop
 b8a:	90                   	nop
 b8b:	90                   	nop
 b8c:	90                   	nop
 b8d:	90                   	nop
 b8e:	90                   	nop
 b8f:	90                   	nop

00000b90 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b90:	55                   	push   %ebp
 b91:	89 e5                	mov    %esp,%ebp
 b93:	57                   	push   %edi
 b94:	56                   	push   %esi
 b95:	53                   	push   %ebx
 b96:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 b99:	8b 75 0c             	mov    0xc(%ebp),%esi
 b9c:	0f b6 1e             	movzbl (%esi),%ebx
 b9f:	84 db                	test   %bl,%bl
 ba1:	0f 84 b3 00 00 00    	je     c5a <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 ba7:	8d 45 10             	lea    0x10(%ebp),%eax
 baa:	83 c6 01             	add    $0x1,%esi
	state = 0;
 bad:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 baf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 bb2:	eb 2f                	jmp    be3 <printf+0x53>
 bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 bb8:	83 f8 25             	cmp    $0x25,%eax
 bbb:	0f 84 a7 00 00 00    	je     c68 <printf+0xd8>
	write(fd, &c, 1);
 bc1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 bc4:	83 ec 04             	sub    $0x4,%esp
 bc7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 bca:	6a 01                	push   $0x1
 bcc:	50                   	push   %eax
 bcd:	ff 75 08             	pushl  0x8(%ebp)
 bd0:	e8 4d fe ff ff       	call   a22 <write>
 bd5:	83 c4 10             	add    $0x10,%esp
 bd8:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 bdb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 bdf:	84 db                	test   %bl,%bl
 be1:	74 77                	je     c5a <printf+0xca>
		if (state == 0) {
 be3:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 be5:	0f be cb             	movsbl %bl,%ecx
 be8:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 beb:	74 cb                	je     bb8 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 bed:	83 ff 25             	cmp    $0x25,%edi
 bf0:	75 e6                	jne    bd8 <printf+0x48>
			if (c == 'd') {
 bf2:	83 f8 64             	cmp    $0x64,%eax
 bf5:	0f 84 05 01 00 00    	je     d00 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 bfb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 c01:	83 f9 70             	cmp    $0x70,%ecx
 c04:	74 72                	je     c78 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 c06:	83 f8 73             	cmp    $0x73,%eax
 c09:	0f 84 99 00 00 00    	je     ca8 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 c0f:	83 f8 63             	cmp    $0x63,%eax
 c12:	0f 84 08 01 00 00    	je     d20 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 c18:	83 f8 25             	cmp    $0x25,%eax
 c1b:	0f 84 ef 00 00 00    	je     d10 <printf+0x180>
	write(fd, &c, 1);
 c21:	8d 45 e7             	lea    -0x19(%ebp),%eax
 c24:	83 ec 04             	sub    $0x4,%esp
 c27:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 c2b:	6a 01                	push   $0x1
 c2d:	50                   	push   %eax
 c2e:	ff 75 08             	pushl  0x8(%ebp)
 c31:	e8 ec fd ff ff       	call   a22 <write>
 c36:	83 c4 0c             	add    $0xc,%esp
 c39:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 c3c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 c3f:	6a 01                	push   $0x1
 c41:	50                   	push   %eax
 c42:	ff 75 08             	pushl  0x8(%ebp)
 c45:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 c48:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 c4a:	e8 d3 fd ff ff       	call   a22 <write>
	for (i = 0; fmt[i]; i++) {
 c4f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 c53:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 c56:	84 db                	test   %bl,%bl
 c58:	75 89                	jne    be3 <printf+0x53>
		}
	}
}
 c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 c5d:	5b                   	pop    %ebx
 c5e:	5e                   	pop    %esi
 c5f:	5f                   	pop    %edi
 c60:	5d                   	pop    %ebp
 c61:	c3                   	ret    
 c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 c68:	bf 25 00 00 00       	mov    $0x25,%edi
 c6d:	e9 66 ff ff ff       	jmp    bd8 <printf+0x48>
 c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 c78:	83 ec 0c             	sub    $0xc,%esp
 c7b:	b9 10 00 00 00       	mov    $0x10,%ecx
 c80:	6a 00                	push   $0x0
 c82:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 c85:	8b 45 08             	mov    0x8(%ebp),%eax
 c88:	8b 17                	mov    (%edi),%edx
 c8a:	e8 61 fe ff ff       	call   af0 <printint>
				ap++;
 c8f:	89 f8                	mov    %edi,%eax
 c91:	83 c4 10             	add    $0x10,%esp
			state = 0;
 c94:	31 ff                	xor    %edi,%edi
				ap++;
 c96:	83 c0 04             	add    $0x4,%eax
 c99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 c9c:	e9 37 ff ff ff       	jmp    bd8 <printf+0x48>
 ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 ca8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 cab:	8b 08                	mov    (%eax),%ecx
				ap++;
 cad:	83 c0 04             	add    $0x4,%eax
 cb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 cb3:	85 c9                	test   %ecx,%ecx
 cb5:	0f 84 8e 00 00 00    	je     d49 <printf+0x1b9>
				while (*s != 0) {
 cbb:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 cbe:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 cc0:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 cc2:	84 c0                	test   %al,%al
 cc4:	0f 84 0e ff ff ff    	je     bd8 <printf+0x48>
 cca:	89 75 d0             	mov    %esi,-0x30(%ebp)
 ccd:	89 de                	mov    %ebx,%esi
 ccf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 cd2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 cd5:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 cd8:	83 ec 04             	sub    $0x4,%esp
					s++;
 cdb:	83 c6 01             	add    $0x1,%esi
 cde:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 ce1:	6a 01                	push   $0x1
 ce3:	57                   	push   %edi
 ce4:	53                   	push   %ebx
 ce5:	e8 38 fd ff ff       	call   a22 <write>
				while (*s != 0) {
 cea:	0f b6 06             	movzbl (%esi),%eax
 ced:	83 c4 10             	add    $0x10,%esp
 cf0:	84 c0                	test   %al,%al
 cf2:	75 e4                	jne    cd8 <printf+0x148>
 cf4:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 cf7:	31 ff                	xor    %edi,%edi
 cf9:	e9 da fe ff ff       	jmp    bd8 <printf+0x48>
 cfe:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 d00:	83 ec 0c             	sub    $0xc,%esp
 d03:	b9 0a 00 00 00       	mov    $0xa,%ecx
 d08:	6a 01                	push   $0x1
 d0a:	e9 73 ff ff ff       	jmp    c82 <printf+0xf2>
 d0f:	90                   	nop
	write(fd, &c, 1);
 d10:	83 ec 04             	sub    $0x4,%esp
 d13:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 d16:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 d19:	6a 01                	push   $0x1
 d1b:	e9 21 ff ff ff       	jmp    c41 <printf+0xb1>
				putc(fd, *ap);
 d20:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 d23:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 d26:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 d28:	6a 01                	push   $0x1
				ap++;
 d2a:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 d2d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 d30:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 d33:	50                   	push   %eax
 d34:	ff 75 08             	pushl  0x8(%ebp)
 d37:	e8 e6 fc ff ff       	call   a22 <write>
				ap++;
 d3c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 d3f:	83 c4 10             	add    $0x10,%esp
			state = 0;
 d42:	31 ff                	xor    %edi,%edi
 d44:	e9 8f fe ff ff       	jmp    bd8 <printf+0x48>
				if (s == 0) s = "(null)";
 d49:	bb 04 12 00 00       	mov    $0x1204,%ebx
				while (*s != 0) {
 d4e:	b8 28 00 00 00       	mov    $0x28,%eax
 d53:	e9 72 ff ff ff       	jmp    cca <printf+0x13a>
 d58:	66 90                	xchg   %ax,%ax
 d5a:	66 90                	xchg   %ax,%ax
 d5c:	66 90                	xchg   %ax,%ax
 d5e:	66 90                	xchg   %ax,%ax

00000d60 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 d60:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d61:	a1 00 16 00 00       	mov    0x1600,%eax
{
 d66:	89 e5                	mov    %esp,%ebp
 d68:	57                   	push   %edi
 d69:	56                   	push   %esi
 d6a:	53                   	push   %ebx
 d6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 d6e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d78:	39 c8                	cmp    %ecx,%eax
 d7a:	8b 10                	mov    (%eax),%edx
 d7c:	73 32                	jae    db0 <free+0x50>
 d7e:	39 d1                	cmp    %edx,%ecx
 d80:	72 04                	jb     d86 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 d82:	39 d0                	cmp    %edx,%eax
 d84:	72 32                	jb     db8 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 d86:	8b 73 fc             	mov    -0x4(%ebx),%esi
 d89:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 d8c:	39 fa                	cmp    %edi,%edx
 d8e:	74 30                	je     dc0 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 d90:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 d93:	8b 50 04             	mov    0x4(%eax),%edx
 d96:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 d99:	39 f1                	cmp    %esi,%ecx
 d9b:	74 3a                	je     dd7 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 d9d:	89 08                	mov    %ecx,(%eax)
	freep = p;
 d9f:	a3 00 16 00 00       	mov    %eax,0x1600
}
 da4:	5b                   	pop    %ebx
 da5:	5e                   	pop    %esi
 da6:	5f                   	pop    %edi
 da7:	5d                   	pop    %ebp
 da8:	c3                   	ret    
 da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 db0:	39 d0                	cmp    %edx,%eax
 db2:	72 04                	jb     db8 <free+0x58>
 db4:	39 d1                	cmp    %edx,%ecx
 db6:	72 ce                	jb     d86 <free+0x26>
{
 db8:	89 d0                	mov    %edx,%eax
 dba:	eb bc                	jmp    d78 <free+0x18>
 dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 dc0:	03 72 04             	add    0x4(%edx),%esi
 dc3:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 dc6:	8b 10                	mov    (%eax),%edx
 dc8:	8b 12                	mov    (%edx),%edx
 dca:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 dcd:	8b 50 04             	mov    0x4(%eax),%edx
 dd0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 dd3:	39 f1                	cmp    %esi,%ecx
 dd5:	75 c6                	jne    d9d <free+0x3d>
		p->s.size += bp->s.size;
 dd7:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 dda:	a3 00 16 00 00       	mov    %eax,0x1600
		p->s.size += bp->s.size;
 ddf:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 de2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 de5:	89 10                	mov    %edx,(%eax)
}
 de7:	5b                   	pop    %ebx
 de8:	5e                   	pop    %esi
 de9:	5f                   	pop    %edi
 dea:	5d                   	pop    %ebp
 deb:	c3                   	ret    
 dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000df0 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 df0:	55                   	push   %ebp
 df1:	89 e5                	mov    %esp,%ebp
 df3:	57                   	push   %edi
 df4:	56                   	push   %esi
 df5:	53                   	push   %ebx
 df6:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 df9:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 dfc:	8b 15 00 16 00 00    	mov    0x1600,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 e02:	8d 78 07             	lea    0x7(%eax),%edi
 e05:	c1 ef 03             	shr    $0x3,%edi
 e08:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 e0b:	85 d2                	test   %edx,%edx
 e0d:	0f 84 9d 00 00 00    	je     eb0 <malloc+0xc0>
 e13:	8b 02                	mov    (%edx),%eax
 e15:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 e18:	39 cf                	cmp    %ecx,%edi
 e1a:	76 6c                	jbe    e88 <malloc+0x98>
 e1c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 e22:	bb 00 10 00 00       	mov    $0x1000,%ebx
 e27:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 e2a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 e31:	eb 0e                	jmp    e41 <malloc+0x51>
 e33:	90                   	nop
 e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 e38:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 e3a:	8b 48 04             	mov    0x4(%eax),%ecx
 e3d:	39 f9                	cmp    %edi,%ecx
 e3f:	73 47                	jae    e88 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 e41:	39 05 00 16 00 00    	cmp    %eax,0x1600
 e47:	89 c2                	mov    %eax,%edx
 e49:	75 ed                	jne    e38 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 e4b:	83 ec 0c             	sub    $0xc,%esp
 e4e:	56                   	push   %esi
 e4f:	e8 36 fc ff ff       	call   a8a <sbrk>
	if (p == (char *)-1) return 0;
 e54:	83 c4 10             	add    $0x10,%esp
 e57:	83 f8 ff             	cmp    $0xffffffff,%eax
 e5a:	74 1c                	je     e78 <malloc+0x88>
	hp->s.size = nu;
 e5c:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 e5f:	83 ec 0c             	sub    $0xc,%esp
 e62:	83 c0 08             	add    $0x8,%eax
 e65:	50                   	push   %eax
 e66:	e8 f5 fe ff ff       	call   d60 <free>
	return freep;
 e6b:	8b 15 00 16 00 00    	mov    0x1600,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 e71:	83 c4 10             	add    $0x10,%esp
 e74:	85 d2                	test   %edx,%edx
 e76:	75 c0                	jne    e38 <malloc+0x48>
	}
}
 e78:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 e7b:	31 c0                	xor    %eax,%eax
}
 e7d:	5b                   	pop    %ebx
 e7e:	5e                   	pop    %esi
 e7f:	5f                   	pop    %edi
 e80:	5d                   	pop    %ebp
 e81:	c3                   	ret    
 e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 e88:	39 cf                	cmp    %ecx,%edi
 e8a:	74 54                	je     ee0 <malloc+0xf0>
				p->s.size -= nunits;
 e8c:	29 f9                	sub    %edi,%ecx
 e8e:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 e91:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 e94:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 e97:	89 15 00 16 00 00    	mov    %edx,0x1600
}
 e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 ea0:	83 c0 08             	add    $0x8,%eax
}
 ea3:	5b                   	pop    %ebx
 ea4:	5e                   	pop    %esi
 ea5:	5f                   	pop    %edi
 ea6:	5d                   	pop    %ebp
 ea7:	c3                   	ret    
 ea8:	90                   	nop
 ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 eb0:	c7 05 00 16 00 00 04 	movl   $0x1604,0x1600
 eb7:	16 00 00 
 eba:	c7 05 04 16 00 00 04 	movl   $0x1604,0x1604
 ec1:	16 00 00 
		base.s.size                = 0;
 ec4:	b8 04 16 00 00       	mov    $0x1604,%eax
 ec9:	c7 05 08 16 00 00 00 	movl   $0x0,0x1608
 ed0:	00 00 00 
 ed3:	e9 44 ff ff ff       	jmp    e1c <malloc+0x2c>
 ed8:	90                   	nop
 ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 ee0:	8b 08                	mov    (%eax),%ecx
 ee2:	89 0a                	mov    %ecx,(%edx)
 ee4:	eb b1                	jmp    e97 <malloc+0xa7>
