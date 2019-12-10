
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
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp


	testpqeq();
  11:	e8 d4 04 00 00       	call   4ea <testpqeq>


	
	exit();
  16:	e8 f7 03 00 00       	call   412 <exit>
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <init_queue>:
void init_queue(){
  20:	55                   	push   %ebp
  21:	b8 20 0d 00 00       	mov    $0xd20,%eax
  26:	89 e5                	mov    %esp,%ebp
  28:	90                   	nop
  29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			head_tail[m][n] = 0;
  30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  3d:	83 c0 08             	add    $0x8,%eax
	for (m=0; m<PRIO_MAX; m++){
  40:	3d 70 0d 00 00       	cmp    $0xd70,%eax
  45:	75 e9                	jne    30 <init_queue+0x10>
}
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    
  49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000050 <pq_enqueue>:
pq_enqueue (struct myproc *p){
  50:	55                   	push   %ebp
	if (tail == ((head-1)%QSIZE)){
  51:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
pq_enqueue (struct myproc *p){
  56:	89 e5                	mov    %esp,%ebp
  58:	57                   	push   %edi
  59:	56                   	push   %esi
	int priority = p->priority;
  5a:	8b 45 08             	mov    0x8(%ebp),%eax
pq_enqueue (struct myproc *p){
  5d:	53                   	push   %ebx
	int priority = p->priority;
  5e:	8b 38                	mov    (%eax),%edi
	if (tail == ((head-1)%QSIZE)){
  60:	8b 04 fd 20 0d 00 00 	mov    0xd20(,%edi,8),%eax
	int tail = head_tail[priority][1];
  67:	8b 1c fd 24 0d 00 00 	mov    0xd24(,%edi,8),%ebx
	if (tail == ((head-1)%QSIZE)){
  6e:	8d 70 ff             	lea    -0x1(%eax),%esi
  71:	89 f0                	mov    %esi,%eax
  73:	f7 e9                	imul   %ecx
  75:	89 f0                	mov    %esi,%eax
  77:	c1 f8 1f             	sar    $0x1f,%eax
  7a:	c1 fa 05             	sar    $0x5,%edx
  7d:	29 c2                	sub    %eax,%edx
  7f:	6b d2 64             	imul   $0x64,%edx,%edx
  82:	29 d6                	sub    %edx,%esi
  84:	39 de                	cmp    %ebx,%esi
  86:	74 38                	je     c0 <pq_enqueue+0x70>
	pqueues[priority][tail] = p;
  88:	6b c7 64             	imul   $0x64,%edi,%eax
  8b:	8b 75 08             	mov    0x8(%ebp),%esi
  8e:	01 d8                	add    %ebx,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
  90:	83 c3 01             	add    $0x1,%ebx
	pqueues[priority][tail] = p;
  93:	89 34 85 80 0d 00 00 	mov    %esi,0xd80(,%eax,4)
	head_tail[priority][1] = (tail+1)%QSIZE;
  9a:	89 d8                	mov    %ebx,%eax
  9c:	f7 e9                	imul   %ecx
  9e:	89 d8                	mov    %ebx,%eax
  a0:	c1 f8 1f             	sar    $0x1f,%eax
  a3:	89 d1                	mov    %edx,%ecx
  a5:	c1 f9 05             	sar    $0x5,%ecx
  a8:	29 c1                	sub    %eax,%ecx
	return 1;
  aa:	b8 01 00 00 00       	mov    $0x1,%eax
	head_tail[priority][1] = (tail+1)%QSIZE;
  af:	6b c9 64             	imul   $0x64,%ecx,%ecx
  b2:	29 cb                	sub    %ecx,%ebx
  b4:	89 1c fd 24 0d 00 00 	mov    %ebx,0xd24(,%edi,8)
}
  bb:	5b                   	pop    %ebx
  bc:	5e                   	pop    %esi
  bd:	5f                   	pop    %edi
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    
		return -1;
  c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  c5:	eb f4                	jmp    bb <pq_enqueue+0x6b>
  c7:	89 f6                	mov    %esi,%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000d0 <pq_dequeue>:
pq_dequeue(){
  d0:	55                   	push   %ebp
	int priority = 0;
  d1:	31 c9                	xor    %ecx,%ecx
pq_dequeue(){
  d3:	89 e5                	mov    %esp,%ebp
  d5:	56                   	push   %esi
  d6:	53                   	push   %ebx
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
  e0:	8b 04 cd 20 0d 00 00 	mov    0xd20(,%ecx,8),%eax
  e7:	3b 04 cd 24 0d 00 00 	cmp    0xd24(,%ecx,8),%eax
  ee:	75 30                	jne    120 <pq_dequeue+0x50>
		priority++;
  f0:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && head_tail[priority][0] == head_tail[priority][1])	// queue is empty if head == tail
  f3:	83 f9 0a             	cmp    $0xa,%ecx
  f6:	75 e8                	jne    e0 <pq_dequeue+0x10>
		printf(1,"all queues are empty\n");
  f8:	83 ec 08             	sub    $0x8,%esp
		return NULL;
  fb:	be ff ff ff ff       	mov    $0xffffffff,%esi
		printf(1,"all queues are empty\n");
 100:	68 f8 08 00 00       	push   $0x8f8
 105:	6a 01                	push   $0x1
 107:	e8 94 04 00 00       	call   5a0 <printf>
		return NULL;
 10c:	83 c4 10             	add    $0x10,%esp
}
 10f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 112:	89 f0                	mov    %esi,%eax
 114:	5b                   	pop    %ebx
 115:	5e                   	pop    %esi
 116:	5d                   	pop    %ebp
 117:	c3                   	ret    
 118:	90                   	nop
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	struct myproc *p = pqueues[priority][head];
 120:	6b d1 64             	imul   $0x64,%ecx,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 123:	8d 58 01             	lea    0x1(%eax),%ebx
	struct myproc *p = pqueues[priority][head];
 126:	01 c2                	add    %eax,%edx
	head_tail[priority][0] = (head+1)%QSIZE;
 128:	89 d8                	mov    %ebx,%eax
	struct myproc *p = pqueues[priority][head];
 12a:	8b 34 95 80 0d 00 00 	mov    0xd80(,%edx,4),%esi
	head_tail[priority][0] = (head+1)%QSIZE;
 131:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 136:	f7 ea                	imul   %edx
 138:	89 d8                	mov    %ebx,%eax
 13a:	c1 f8 1f             	sar    $0x1f,%eax
 13d:	c1 fa 05             	sar    $0x5,%edx
 140:	29 c2                	sub    %eax,%edx
 142:	89 d8                	mov    %ebx,%eax
 144:	6b d2 64             	imul   $0x64,%edx,%edx
 147:	29 d0                	sub    %edx,%eax
 149:	89 04 cd 20 0d 00 00 	mov    %eax,0xd20(,%ecx,8)
}
 150:	8d 65 f8             	lea    -0x8(%ebp),%esp
 153:	89 f0                	mov    %esi,%eax
 155:	5b                   	pop    %ebx
 156:	5e                   	pop    %esi
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <mutex_create>:
	// 	printf(1,"DELETE SUCCESS\n");
	// 	exit();
	// }
}

int mutex_create(char *name){
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
	return mcreate(name);
}
 163:	5d                   	pop    %ebp
	return mcreate(name);
 164:	e9 49 03 00 00       	jmp    4b2 <mcreate>
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000170 <mutex_delete>:
int mutex_delete(int muxid){
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
	return mdelete(muxid);
}
 173:	5d                   	pop    %ebp
	return mdelete(muxid);
 174:	e9 41 03 00 00       	jmp    4ba <mdelete>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <mutex_lock>:
int mutex_lock(int muxid){
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
	return mlock(muxid);
}
 183:	5d                   	pop    %ebp
	return mlock(muxid);
 184:	e9 39 03 00 00       	jmp    4c2 <mlock>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <mutex_unlock>:
int mutex_unlock(int muxid){
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
	return munlock(muxid);
}
 193:	5d                   	pop    %ebp
	return munlock(muxid);
 194:	e9 31 03 00 00       	jmp    4ca <munlock>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001a0 <cv_wait>:

int cv_wait(int muxid){
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
	return waitcv(muxid);
}
 1a3:	5d                   	pop    %ebp
	return waitcv(muxid);
 1a4:	e9 29 03 00 00       	jmp    4d2 <waitcv>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <cv_signal>:
int cv_signal(int muxid){
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
	return signalcv(muxid);
 1b3:	5d                   	pop    %ebp
	return signalcv(muxid);
 1b4:	e9 21 03 00 00       	jmp    4da <signalcv>
 1b9:	66 90                	xchg   %ax,%ax
 1bb:	66 90                	xchg   %ax,%ax
 1bd:	66 90                	xchg   %ax,%ax
 1bf:	90                   	nop

000001c0 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 1ca:	89 c2                	mov    %eax,%edx
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	83 c1 01             	add    $0x1,%ecx
 1d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1d7:	83 c2 01             	add    $0x1,%edx
 1da:	84 db                	test   %bl,%bl
 1dc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1df:	75 ef                	jne    1d0 <strcpy+0x10>
		;
	return os;
}
 1e1:	5b                   	pop    %ebx
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    
 1e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 55 08             	mov    0x8(%ebp),%edx
 1f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 1fa:	0f b6 02             	movzbl (%edx),%eax
 1fd:	0f b6 19             	movzbl (%ecx),%ebx
 200:	84 c0                	test   %al,%al
 202:	75 1c                	jne    220 <strcmp+0x30>
 204:	eb 2a                	jmp    230 <strcmp+0x40>
 206:	8d 76 00             	lea    0x0(%esi),%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 210:	83 c2 01             	add    $0x1,%edx
 213:	0f b6 02             	movzbl (%edx),%eax
 216:	83 c1 01             	add    $0x1,%ecx
 219:	0f b6 19             	movzbl (%ecx),%ebx
 21c:	84 c0                	test   %al,%al
 21e:	74 10                	je     230 <strcmp+0x40>
 220:	38 d8                	cmp    %bl,%al
 222:	74 ec                	je     210 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 224:	29 d8                	sub    %ebx,%eax
}
 226:	5b                   	pop    %ebx
 227:	5d                   	pop    %ebp
 228:	c3                   	ret    
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 230:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 232:	29 d8                	sub    %ebx,%eax
}
 234:	5b                   	pop    %ebx
 235:	5d                   	pop    %ebp
 236:	c3                   	ret    
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <strlen>:

uint
strlen(char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 246:	80 39 00             	cmpb   $0x0,(%ecx)
 249:	74 15                	je     260 <strlen+0x20>
 24b:	31 d2                	xor    %edx,%edx
 24d:	8d 76 00             	lea    0x0(%esi),%esi
 250:	83 c2 01             	add    $0x1,%edx
 253:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 257:	89 d0                	mov    %edx,%eax
 259:	75 f5                	jne    250 <strlen+0x10>
		;
	return n;
}
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 260:	31 c0                	xor    %eax,%eax
}
 262:	5d                   	pop    %ebp
 263:	c3                   	ret    
 264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 26a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000270 <memset>:

void *
memset(void *dst, int c, uint n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 277:	8b 4d 10             	mov    0x10(%ebp),%ecx
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	89 d7                	mov    %edx,%edi
 27f:	fc                   	cld    
 280:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 282:	89 d0                	mov    %edx,%eax
 284:	5f                   	pop    %edi
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    
 287:	89 f6                	mov    %esi,%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <strchr>:

char *
strchr(const char *s, char c)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 29a:	0f b6 10             	movzbl (%eax),%edx
 29d:	84 d2                	test   %dl,%dl
 29f:	74 1d                	je     2be <strchr+0x2e>
		if (*s == c) return (char *)s;
 2a1:	38 d3                	cmp    %dl,%bl
 2a3:	89 d9                	mov    %ebx,%ecx
 2a5:	75 0d                	jne    2b4 <strchr+0x24>
 2a7:	eb 17                	jmp    2c0 <strchr+0x30>
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b0:	38 ca                	cmp    %cl,%dl
 2b2:	74 0c                	je     2c0 <strchr+0x30>
	for (; *s; s++)
 2b4:	83 c0 01             	add    $0x1,%eax
 2b7:	0f b6 10             	movzbl (%eax),%edx
 2ba:	84 d2                	test   %dl,%dl
 2bc:	75 f2                	jne    2b0 <strchr+0x20>
	return 0;
 2be:	31 c0                	xor    %eax,%eax
}
 2c0:	5b                   	pop    %ebx
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
 2c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <gets>:

char *
gets(char *buf, int max)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	56                   	push   %esi
 2d5:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 2d6:	31 f6                	xor    %esi,%esi
 2d8:	89 f3                	mov    %esi,%ebx
{
 2da:	83 ec 1c             	sub    $0x1c,%esp
 2dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 2e0:	eb 2f                	jmp    311 <gets+0x41>
 2e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 2e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2eb:	83 ec 04             	sub    $0x4,%esp
 2ee:	6a 01                	push   $0x1
 2f0:	50                   	push   %eax
 2f1:	6a 00                	push   $0x0
 2f3:	e8 32 01 00 00       	call   42a <read>
		if (cc < 1) break;
 2f8:	83 c4 10             	add    $0x10,%esp
 2fb:	85 c0                	test   %eax,%eax
 2fd:	7e 1c                	jle    31b <gets+0x4b>
		buf[i++] = c;
 2ff:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 303:	83 c7 01             	add    $0x1,%edi
 306:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 309:	3c 0a                	cmp    $0xa,%al
 30b:	74 23                	je     330 <gets+0x60>
 30d:	3c 0d                	cmp    $0xd,%al
 30f:	74 1f                	je     330 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 311:	83 c3 01             	add    $0x1,%ebx
 314:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 317:	89 fe                	mov    %edi,%esi
 319:	7c cd                	jl     2e8 <gets+0x18>
 31b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 320:	c6 03 00             	movb   $0x0,(%ebx)
}
 323:	8d 65 f4             	lea    -0xc(%ebp),%esp
 326:	5b                   	pop    %ebx
 327:	5e                   	pop    %esi
 328:	5f                   	pop    %edi
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    
 32b:	90                   	nop
 32c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 330:	8b 75 08             	mov    0x8(%ebp),%esi
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	01 de                	add    %ebx,%esi
 338:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 33a:	c6 03 00             	movb   $0x0,(%ebx)
}
 33d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 340:	5b                   	pop    %ebx
 341:	5e                   	pop    %esi
 342:	5f                   	pop    %edi
 343:	5d                   	pop    %ebp
 344:	c3                   	ret    
 345:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000350 <stat>:

int
stat(char *n, struct stat *st)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	56                   	push   %esi
 354:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 355:	83 ec 08             	sub    $0x8,%esp
 358:	6a 00                	push   $0x0
 35a:	ff 75 08             	pushl  0x8(%ebp)
 35d:	e8 f0 00 00 00       	call   452 <open>
	if (fd < 0) return -1;
 362:	83 c4 10             	add    $0x10,%esp
 365:	85 c0                	test   %eax,%eax
 367:	78 27                	js     390 <stat+0x40>
	r = fstat(fd, st);
 369:	83 ec 08             	sub    $0x8,%esp
 36c:	ff 75 0c             	pushl  0xc(%ebp)
 36f:	89 c3                	mov    %eax,%ebx
 371:	50                   	push   %eax
 372:	e8 f3 00 00 00       	call   46a <fstat>
	close(fd);
 377:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 37a:	89 c6                	mov    %eax,%esi
	close(fd);
 37c:	e8 b9 00 00 00       	call   43a <close>
	return r;
 381:	83 c4 10             	add    $0x10,%esp
}
 384:	8d 65 f8             	lea    -0x8(%ebp),%esp
 387:	89 f0                	mov    %esi,%eax
 389:	5b                   	pop    %ebx
 38a:	5e                   	pop    %esi
 38b:	5d                   	pop    %ebp
 38c:	c3                   	ret    
 38d:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 390:	be ff ff ff ff       	mov    $0xffffffff,%esi
 395:	eb ed                	jmp    384 <stat+0x34>
 397:	89 f6                	mov    %esi,%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <atoi>:

int
atoi(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	53                   	push   %ebx
 3a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 3a7:	0f be 11             	movsbl (%ecx),%edx
 3aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 3ad:	3c 09                	cmp    $0x9,%al
	n = 0;
 3af:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 3b4:	77 1f                	ja     3d5 <atoi+0x35>
 3b6:	8d 76 00             	lea    0x0(%esi),%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 3c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3c3:	83 c1 01             	add    $0x1,%ecx
 3c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 3ca:	0f be 11             	movsbl (%ecx),%edx
 3cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3d0:	80 fb 09             	cmp    $0x9,%bl
 3d3:	76 eb                	jbe    3c0 <atoi+0x20>
	return n;
}
 3d5:	5b                   	pop    %ebx
 3d6:	5d                   	pop    %ebp
 3d7:	c3                   	ret    
 3d8:	90                   	nop
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003e0 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
 3e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 3ee:	85 db                	test   %ebx,%ebx
 3f0:	7e 14                	jle    406 <memmove+0x26>
 3f2:	31 d2                	xor    %edx,%edx
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3ff:	83 c2 01             	add    $0x1,%edx
 402:	39 d3                	cmp    %edx,%ebx
 404:	75 f2                	jne    3f8 <memmove+0x18>
	return vdst;
}
 406:	5b                   	pop    %ebx
 407:	5e                   	pop    %esi
 408:	5d                   	pop    %ebp
 409:	c3                   	ret    

0000040a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40a:	b8 01 00 00 00       	mov    $0x1,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <exit>:
SYSCALL(exit)
 412:	b8 02 00 00 00       	mov    $0x2,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <wait>:
SYSCALL(wait)
 41a:	b8 03 00 00 00       	mov    $0x3,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <pipe>:
SYSCALL(pipe)
 422:	b8 04 00 00 00       	mov    $0x4,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <read>:
SYSCALL(read)
 42a:	b8 05 00 00 00       	mov    $0x5,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <write>:
SYSCALL(write)
 432:	b8 10 00 00 00       	mov    $0x10,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <close>:
SYSCALL(close)
 43a:	b8 15 00 00 00       	mov    $0x15,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <kill>:
SYSCALL(kill)
 442:	b8 06 00 00 00       	mov    $0x6,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <exec>:
SYSCALL(exec)
 44a:	b8 07 00 00 00       	mov    $0x7,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <open>:
SYSCALL(open)
 452:	b8 0f 00 00 00       	mov    $0xf,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <mknod>:
SYSCALL(mknod)
 45a:	b8 11 00 00 00       	mov    $0x11,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <unlink>:
SYSCALL(unlink)
 462:	b8 12 00 00 00       	mov    $0x12,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <fstat>:
SYSCALL(fstat)
 46a:	b8 08 00 00 00       	mov    $0x8,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <link>:
SYSCALL(link)
 472:	b8 13 00 00 00       	mov    $0x13,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mkdir>:
SYSCALL(mkdir)
 47a:	b8 14 00 00 00       	mov    $0x14,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <chdir>:
SYSCALL(chdir)
 482:	b8 09 00 00 00       	mov    $0x9,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <dup>:
SYSCALL(dup)
 48a:	b8 0a 00 00 00       	mov    $0xa,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <getpid>:
SYSCALL(getpid)
 492:	b8 0b 00 00 00       	mov    $0xb,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <sbrk>:
SYSCALL(sbrk)
 49a:	b8 0c 00 00 00       	mov    $0xc,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <sleep>:
SYSCALL(sleep)
 4a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <uptime>:
SYSCALL(uptime)
 4aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <mcreate>:
SYSCALL(mcreate)
 4b2:	b8 16 00 00 00       	mov    $0x16,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <mdelete>:
SYSCALL(mdelete)
 4ba:	b8 17 00 00 00       	mov    $0x17,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <mlock>:
SYSCALL(mlock)
 4c2:	b8 18 00 00 00       	mov    $0x18,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <munlock>:
SYSCALL(munlock)
 4ca:	b8 19 00 00 00       	mov    $0x19,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <waitcv>:
SYSCALL(waitcv)
 4d2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <signalcv>:
SYSCALL(signalcv)
 4da:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <prio_set>:
SYSCALL(prio_set)
 4e2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <testpqeq>:
SYSCALL(testpqeq)
 4ea:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <testpqdq>:
SYSCALL(testpqdq)
 4f2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    
 4fa:	66 90                	xchg   %ax,%ax
 4fc:	66 90                	xchg   %ax,%ax
 4fe:	66 90                	xchg   %ax,%ax

00000500 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 509:	85 d2                	test   %edx,%edx
{
 50b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 50e:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 510:	79 76                	jns    588 <printint+0x88>
 512:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 516:	74 70                	je     588 <printint+0x88>
		x   = -xx;
 518:	f7 d8                	neg    %eax
		neg = 1;
 51a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 521:	31 f6                	xor    %esi,%esi
 523:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 526:	eb 0a                	jmp    532 <printint+0x32>
 528:	90                   	nop
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 530:	89 fe                	mov    %edi,%esi
 532:	31 d2                	xor    %edx,%edx
 534:	8d 7e 01             	lea    0x1(%esi),%edi
 537:	f7 f1                	div    %ecx
 539:	0f b6 92 18 09 00 00 	movzbl 0x918(%edx),%edx
	} while ((x /= base) != 0);
 540:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 542:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 545:	75 e9                	jne    530 <printint+0x30>
	if (neg) buf[i++] = '-';
 547:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 54a:	85 c0                	test   %eax,%eax
 54c:	74 08                	je     556 <printint+0x56>
 54e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 553:	8d 7e 02             	lea    0x2(%esi),%edi
 556:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 55a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
 560:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 563:	83 ec 04             	sub    $0x4,%esp
 566:	83 ee 01             	sub    $0x1,%esi
 569:	6a 01                	push   $0x1
 56b:	53                   	push   %ebx
 56c:	57                   	push   %edi
 56d:	88 45 d7             	mov    %al,-0x29(%ebp)
 570:	e8 bd fe ff ff       	call   432 <write>

	while (--i >= 0) putc(fd, buf[i]);
 575:	83 c4 10             	add    $0x10,%esp
 578:	39 de                	cmp    %ebx,%esi
 57a:	75 e4                	jne    560 <printint+0x60>
}
 57c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 57f:	5b                   	pop    %ebx
 580:	5e                   	pop    %esi
 581:	5f                   	pop    %edi
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 588:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 58f:	eb 90                	jmp    521 <printint+0x21>
 591:	eb 0d                	jmp    5a0 <printf>
 593:	90                   	nop
 594:	90                   	nop
 595:	90                   	nop
 596:	90                   	nop
 597:	90                   	nop
 598:	90                   	nop
 599:	90                   	nop
 59a:	90                   	nop
 59b:	90                   	nop
 59c:	90                   	nop
 59d:	90                   	nop
 59e:	90                   	nop
 59f:	90                   	nop

000005a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
 5a6:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 5a9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5ac:	0f b6 1e             	movzbl (%esi),%ebx
 5af:	84 db                	test   %bl,%bl
 5b1:	0f 84 b3 00 00 00    	je     66a <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 5b7:	8d 45 10             	lea    0x10(%ebp),%eax
 5ba:	83 c6 01             	add    $0x1,%esi
	state = 0;
 5bd:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 5bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5c2:	eb 2f                	jmp    5f3 <printf+0x53>
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 5c8:	83 f8 25             	cmp    $0x25,%eax
 5cb:	0f 84 a7 00 00 00    	je     678 <printf+0xd8>
	write(fd, &c, 1);
 5d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5d4:	83 ec 04             	sub    $0x4,%esp
 5d7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5da:	6a 01                	push   $0x1
 5dc:	50                   	push   %eax
 5dd:	ff 75 08             	pushl  0x8(%ebp)
 5e0:	e8 4d fe ff ff       	call   432 <write>
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 5eb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5ef:	84 db                	test   %bl,%bl
 5f1:	74 77                	je     66a <printf+0xca>
		if (state == 0) {
 5f3:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 5f5:	0f be cb             	movsbl %bl,%ecx
 5f8:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 5fb:	74 cb                	je     5c8 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 5fd:	83 ff 25             	cmp    $0x25,%edi
 600:	75 e6                	jne    5e8 <printf+0x48>
			if (c == 'd') {
 602:	83 f8 64             	cmp    $0x64,%eax
 605:	0f 84 05 01 00 00    	je     710 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 60b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 611:	83 f9 70             	cmp    $0x70,%ecx
 614:	74 72                	je     688 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 616:	83 f8 73             	cmp    $0x73,%eax
 619:	0f 84 99 00 00 00    	je     6b8 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 61f:	83 f8 63             	cmp    $0x63,%eax
 622:	0f 84 08 01 00 00    	je     730 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 628:	83 f8 25             	cmp    $0x25,%eax
 62b:	0f 84 ef 00 00 00    	je     720 <printf+0x180>
	write(fd, &c, 1);
 631:	8d 45 e7             	lea    -0x19(%ebp),%eax
 634:	83 ec 04             	sub    $0x4,%esp
 637:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 63b:	6a 01                	push   $0x1
 63d:	50                   	push   %eax
 63e:	ff 75 08             	pushl  0x8(%ebp)
 641:	e8 ec fd ff ff       	call   432 <write>
 646:	83 c4 0c             	add    $0xc,%esp
 649:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 64c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 64f:	6a 01                	push   $0x1
 651:	50                   	push   %eax
 652:	ff 75 08             	pushl  0x8(%ebp)
 655:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 658:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 65a:	e8 d3 fd ff ff       	call   432 <write>
	for (i = 0; fmt[i]; i++) {
 65f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 663:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 666:	84 db                	test   %bl,%bl
 668:	75 89                	jne    5f3 <printf+0x53>
		}
	}
}
 66a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66d:	5b                   	pop    %ebx
 66e:	5e                   	pop    %esi
 66f:	5f                   	pop    %edi
 670:	5d                   	pop    %ebp
 671:	c3                   	ret    
 672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 678:	bf 25 00 00 00       	mov    $0x25,%edi
 67d:	e9 66 ff ff ff       	jmp    5e8 <printf+0x48>
 682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 688:	83 ec 0c             	sub    $0xc,%esp
 68b:	b9 10 00 00 00       	mov    $0x10,%ecx
 690:	6a 00                	push   $0x0
 692:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	8b 17                	mov    (%edi),%edx
 69a:	e8 61 fe ff ff       	call   500 <printint>
				ap++;
 69f:	89 f8                	mov    %edi,%eax
 6a1:	83 c4 10             	add    $0x10,%esp
			state = 0;
 6a4:	31 ff                	xor    %edi,%edi
				ap++;
 6a6:	83 c0 04             	add    $0x4,%eax
 6a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6ac:	e9 37 ff ff ff       	jmp    5e8 <printf+0x48>
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 6b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6bb:	8b 08                	mov    (%eax),%ecx
				ap++;
 6bd:	83 c0 04             	add    $0x4,%eax
 6c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 6c3:	85 c9                	test   %ecx,%ecx
 6c5:	0f 84 8e 00 00 00    	je     759 <printf+0x1b9>
				while (*s != 0) {
 6cb:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 6ce:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 6d0:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 6d2:	84 c0                	test   %al,%al
 6d4:	0f 84 0e ff ff ff    	je     5e8 <printf+0x48>
 6da:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6dd:	89 de                	mov    %ebx,%esi
 6df:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6e2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6e5:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 6e8:	83 ec 04             	sub    $0x4,%esp
					s++;
 6eb:	83 c6 01             	add    $0x1,%esi
 6ee:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 6f1:	6a 01                	push   $0x1
 6f3:	57                   	push   %edi
 6f4:	53                   	push   %ebx
 6f5:	e8 38 fd ff ff       	call   432 <write>
				while (*s != 0) {
 6fa:	0f b6 06             	movzbl (%esi),%eax
 6fd:	83 c4 10             	add    $0x10,%esp
 700:	84 c0                	test   %al,%al
 702:	75 e4                	jne    6e8 <printf+0x148>
 704:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 707:	31 ff                	xor    %edi,%edi
 709:	e9 da fe ff ff       	jmp    5e8 <printf+0x48>
 70e:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	b9 0a 00 00 00       	mov    $0xa,%ecx
 718:	6a 01                	push   $0x1
 71a:	e9 73 ff ff ff       	jmp    692 <printf+0xf2>
 71f:	90                   	nop
	write(fd, &c, 1);
 720:	83 ec 04             	sub    $0x4,%esp
 723:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 726:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 729:	6a 01                	push   $0x1
 72b:	e9 21 ff ff ff       	jmp    651 <printf+0xb1>
				putc(fd, *ap);
 730:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 736:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 738:	6a 01                	push   $0x1
				ap++;
 73a:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 73d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 740:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 743:	50                   	push   %eax
 744:	ff 75 08             	pushl  0x8(%ebp)
 747:	e8 e6 fc ff ff       	call   432 <write>
				ap++;
 74c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 74f:	83 c4 10             	add    $0x10,%esp
			state = 0;
 752:	31 ff                	xor    %edi,%edi
 754:	e9 8f fe ff ff       	jmp    5e8 <printf+0x48>
				if (s == 0) s = "(null)";
 759:	bb 0e 09 00 00       	mov    $0x90e,%ebx
				while (*s != 0) {
 75e:	b8 28 00 00 00       	mov    $0x28,%eax
 763:	e9 72 ff ff ff       	jmp    6da <printf+0x13a>
 768:	66 90                	xchg   %ax,%ax
 76a:	66 90                	xchg   %ax,%ax
 76c:	66 90                	xchg   %ax,%ax
 76e:	66 90                	xchg   %ax,%ax

00000770 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 770:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	a1 00 0d 00 00       	mov    0xd00,%eax
{
 776:	89 e5                	mov    %esp,%ebp
 778:	57                   	push   %edi
 779:	56                   	push   %esi
 77a:	53                   	push   %ebx
 77b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 77e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	39 c8                	cmp    %ecx,%eax
 78a:	8b 10                	mov    (%eax),%edx
 78c:	73 32                	jae    7c0 <free+0x50>
 78e:	39 d1                	cmp    %edx,%ecx
 790:	72 04                	jb     796 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 792:	39 d0                	cmp    %edx,%eax
 794:	72 32                	jb     7c8 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 796:	8b 73 fc             	mov    -0x4(%ebx),%esi
 799:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 79c:	39 fa                	cmp    %edi,%edx
 79e:	74 30                	je     7d0 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 7a0:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 7a3:	8b 50 04             	mov    0x4(%eax),%edx
 7a6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7a9:	39 f1                	cmp    %esi,%ecx
 7ab:	74 3a                	je     7e7 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 7ad:	89 08                	mov    %ecx,(%eax)
	freep = p;
 7af:	a3 00 0d 00 00       	mov    %eax,0xd00
}
 7b4:	5b                   	pop    %ebx
 7b5:	5e                   	pop    %esi
 7b6:	5f                   	pop    %edi
 7b7:	5d                   	pop    %ebp
 7b8:	c3                   	ret    
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7c0:	39 d0                	cmp    %edx,%eax
 7c2:	72 04                	jb     7c8 <free+0x58>
 7c4:	39 d1                	cmp    %edx,%ecx
 7c6:	72 ce                	jb     796 <free+0x26>
{
 7c8:	89 d0                	mov    %edx,%eax
 7ca:	eb bc                	jmp    788 <free+0x18>
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 7d0:	03 72 04             	add    0x4(%edx),%esi
 7d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	8b 10                	mov    (%eax),%edx
 7d8:	8b 12                	mov    (%edx),%edx
 7da:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 7dd:	8b 50 04             	mov    0x4(%eax),%edx
 7e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e3:	39 f1                	cmp    %esi,%ecx
 7e5:	75 c6                	jne    7ad <free+0x3d>
		p->s.size += bp->s.size;
 7e7:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 7ea:	a3 00 0d 00 00       	mov    %eax,0xd00
		p->s.size += bp->s.size;
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 7f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7f5:	89 10                	mov    %edx,(%eax)
}
 7f7:	5b                   	pop    %ebx
 7f8:	5e                   	pop    %esi
 7f9:	5f                   	pop    %edi
 7fa:	5d                   	pop    %ebp
 7fb:	c3                   	ret    
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000800 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 809:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 80c:	8b 15 00 0d 00 00    	mov    0xd00,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 812:	8d 78 07             	lea    0x7(%eax),%edi
 815:	c1 ef 03             	shr    $0x3,%edi
 818:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 81b:	85 d2                	test   %edx,%edx
 81d:	0f 84 9d 00 00 00    	je     8c0 <malloc+0xc0>
 823:	8b 02                	mov    (%edx),%eax
 825:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 828:	39 cf                	cmp    %ecx,%edi
 82a:	76 6c                	jbe    898 <malloc+0x98>
 82c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 832:	bb 00 10 00 00       	mov    $0x1000,%ebx
 837:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 83a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 841:	eb 0e                	jmp    851 <malloc+0x51>
 843:	90                   	nop
 844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 848:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 84a:	8b 48 04             	mov    0x4(%eax),%ecx
 84d:	39 f9                	cmp    %edi,%ecx
 84f:	73 47                	jae    898 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 851:	39 05 00 0d 00 00    	cmp    %eax,0xd00
 857:	89 c2                	mov    %eax,%edx
 859:	75 ed                	jne    848 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 85b:	83 ec 0c             	sub    $0xc,%esp
 85e:	56                   	push   %esi
 85f:	e8 36 fc ff ff       	call   49a <sbrk>
	if (p == (char *)-1) return 0;
 864:	83 c4 10             	add    $0x10,%esp
 867:	83 f8 ff             	cmp    $0xffffffff,%eax
 86a:	74 1c                	je     888 <malloc+0x88>
	hp->s.size = nu;
 86c:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 86f:	83 ec 0c             	sub    $0xc,%esp
 872:	83 c0 08             	add    $0x8,%eax
 875:	50                   	push   %eax
 876:	e8 f5 fe ff ff       	call   770 <free>
	return freep;
 87b:	8b 15 00 0d 00 00    	mov    0xd00,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 881:	83 c4 10             	add    $0x10,%esp
 884:	85 d2                	test   %edx,%edx
 886:	75 c0                	jne    848 <malloc+0x48>
	}
}
 888:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 88b:	31 c0                	xor    %eax,%eax
}
 88d:	5b                   	pop    %ebx
 88e:	5e                   	pop    %esi
 88f:	5f                   	pop    %edi
 890:	5d                   	pop    %ebp
 891:	c3                   	ret    
 892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 898:	39 cf                	cmp    %ecx,%edi
 89a:	74 54                	je     8f0 <malloc+0xf0>
				p->s.size -= nunits;
 89c:	29 f9                	sub    %edi,%ecx
 89e:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 8a1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 8a4:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 8a7:	89 15 00 0d 00 00    	mov    %edx,0xd00
}
 8ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 8b0:	83 c0 08             	add    $0x8,%eax
}
 8b3:	5b                   	pop    %ebx
 8b4:	5e                   	pop    %esi
 8b5:	5f                   	pop    %edi
 8b6:	5d                   	pop    %ebp
 8b7:	c3                   	ret    
 8b8:	90                   	nop
 8b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 8c0:	c7 05 00 0d 00 00 04 	movl   $0xd04,0xd00
 8c7:	0d 00 00 
 8ca:	c7 05 04 0d 00 00 04 	movl   $0xd04,0xd04
 8d1:	0d 00 00 
		base.s.size                = 0;
 8d4:	b8 04 0d 00 00       	mov    $0xd04,%eax
 8d9:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 8e0:	00 00 00 
 8e3:	e9 44 ff ff ff       	jmp    82c <malloc+0x2c>
 8e8:	90                   	nop
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 8f0:	8b 08                	mov    (%eax),%ecx
 8f2:	89 0a                	mov    %ecx,(%edx)
 8f4:	eb b1                	jmp    8a7 <malloc+0xa7>
