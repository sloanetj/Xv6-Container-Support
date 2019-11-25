
_tester:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "printf.h"
#include "mutex.h"
#include "cv.h"

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx

	// set my priority to a lower value - should work
	if (prio_set(getpid(), 10) > 0){
   f:	e8 6e 04 00 00       	call   482 <getpid>
  14:	83 ec 08             	sub    $0x8,%esp
  17:	6a 0a                	push   $0xa
  19:	50                   	push   %eax
  1a:	e8 b3 04 00 00       	call   4d2 <prio_set>
  1f:	83 c4 10             	add    $0x10,%esp
  22:	85 c0                	test   %eax,%eax
  24:	0f 8e d6 00 00 00    	jle    100 <main+0x100>
		printf(1,"decrease priority: PASSED, should pass\n");
  2a:	83 ec 08             	sub    $0x8,%esp
  2d:	68 d8 08 00 00       	push   $0x8d8
  32:	6a 01                	push   $0x1
  34:	e8 47 05 00 00       	call   580 <printf>
  39:	83 c4 10             	add    $0x10,%esp
	} else {
		printf(1,"decrease priority: FAILED, should pass\n");
	}
	// try and set by priority to higher value - should fail
	if (prio_set(getpid(), 0) > 0){
  3c:	e8 41 04 00 00       	call   482 <getpid>
  41:	83 ec 08             	sub    $0x8,%esp
  44:	6a 00                	push   $0x0
  46:	50                   	push   %eax
  47:	e8 86 04 00 00       	call   4d2 <prio_set>
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	85 c0                	test   %eax,%eax
  51:	7e 25                	jle    78 <main+0x78>
		printf(1,"increase priority: PASSED, should fail\n");
  53:	83 ec 08             	sub    $0x8,%esp
  56:	68 28 09 00 00       	push   $0x928
  5b:	6a 01                	push   $0x1
  5d:	e8 1e 05 00 00       	call   580 <printf>
  62:	83 c4 10             	add    $0x10,%esp
	} else {
		printf(1,"increase priority: FAILED, should fail\n");
	}
	
	int pid = fork();
  65:	e8 90 03 00 00       	call   3fa <fork>
	if (pid == 0){
  6a:	85 c0                	test   %eax,%eax
	int pid = fork();
  6c:	89 c3                	mov    %eax,%ebx
	if (pid == 0){
  6e:	75 25                	jne    95 <main+0x95>
  70:	eb fe                	jmp    70 <main+0x70>
  72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		printf(1,"increase priority: FAILED, should fail\n");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 50 09 00 00       	push   $0x950
  80:	6a 01                	push   $0x1
  82:	e8 f9 04 00 00       	call   580 <printf>
  87:	83 c4 10             	add    $0x10,%esp
	int pid = fork();
  8a:	e8 6b 03 00 00       	call   3fa <fork>
	if (pid == 0){
  8f:	85 c0                	test   %eax,%eax
	int pid = fork();
  91:	89 c3                	mov    %eax,%ebx
	if (pid == 0){
  93:	74 db                	je     70 <main+0x70>
		while(1);
	} else {
		// fork a child and have parent set the childs priority to be lower - should work
		if (prio_set(pid, 15) > 0){
  95:	50                   	push   %eax
  96:	50                   	push   %eax
  97:	6a 0f                	push   $0xf
  99:	53                   	push   %ebx
  9a:	e8 33 04 00 00       	call   4d2 <prio_set>
  9f:	83 c4 10             	add    $0x10,%esp
  a2:	85 c0                	test   %eax,%eax
  a4:	7e 71                	jle    117 <main+0x117>
			printf(1,"decrease child priority: PASSED, should pass\n");
  a6:	50                   	push   %eax
  a7:	50                   	push   %eax
  a8:	68 78 09 00 00       	push   $0x978
  ad:	6a 01                	push   $0x1
  af:	e8 cc 04 00 00       	call   580 <printf>
  b4:	83 c4 10             	add    $0x10,%esp
		} else {
			printf(1,"decrease child priority: FAILED, should pass\n");
		}
		// set the child's priority to be equal to parent - should work
		if (prio_set(pid, 10) > 0){
  b7:	50                   	push   %eax
  b8:	50                   	push   %eax
  b9:	6a 0a                	push   $0xa
  bb:	53                   	push   %ebx
  bc:	e8 11 04 00 00       	call   4d2 <prio_set>
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	85 c0                	test   %eax,%eax
  c6:	7e 75                	jle    13d <main+0x13d>
			printf(1,"set child priority to parent priority: PASSED, should pass\n");
  c8:	50                   	push   %eax
  c9:	50                   	push   %eax
  ca:	68 d8 09 00 00       	push   $0x9d8
  cf:	6a 01                	push   $0x1
  d1:	e8 aa 04 00 00       	call   580 <printf>
  d6:	83 c4 10             	add    $0x10,%esp
		} else {
			printf(1,"set child priority to parent priority: FAILED, should pass\n");
		}
		// set the child's priority to be greater than parent - should fail
		if (prio_set(pid, 1) > 0){
  d9:	51                   	push   %ecx
  da:	51                   	push   %ecx
  db:	6a 01                	push   $0x1
  dd:	53                   	push   %ebx
  de:	e8 ef 03 00 00       	call   4d2 <prio_set>
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	85 c0                	test   %eax,%eax
  e8:	7e 40                	jle    12a <main+0x12a>
			printf(1,"set child priority above parent: PASSED, should fail\n");
  ea:	52                   	push   %edx
  eb:	52                   	push   %edx
  ec:	68 50 0a 00 00       	push   $0xa50
  f1:	6a 01                	push   $0x1
  f3:	e8 88 04 00 00       	call   580 <printf>
  f8:	83 c4 10             	add    $0x10,%esp
	// 	exit();
	// }
	// wait();
	// printf(1,"CV SUCCESS\n");

	exit();
  fb:	e8 02 03 00 00       	call   402 <exit>
		printf(1,"decrease priority: FAILED, should pass\n");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 00 09 00 00       	push   $0x900
 108:	6a 01                	push   $0x1
 10a:	e8 71 04 00 00       	call   580 <printf>
 10f:	83 c4 10             	add    $0x10,%esp
 112:	e9 25 ff ff ff       	jmp    3c <main+0x3c>
			printf(1,"decrease child priority: FAILED, should pass\n");
 117:	50                   	push   %eax
 118:	50                   	push   %eax
 119:	68 a8 09 00 00       	push   $0x9a8
 11e:	6a 01                	push   $0x1
 120:	e8 5b 04 00 00       	call   580 <printf>
 125:	83 c4 10             	add    $0x10,%esp
 128:	eb 8d                	jmp    b7 <main+0xb7>
			printf(1,"set child priority above parent: FAILED, should fail\n");
 12a:	50                   	push   %eax
 12b:	50                   	push   %eax
 12c:	68 88 0a 00 00       	push   $0xa88
 131:	6a 01                	push   $0x1
 133:	e8 48 04 00 00       	call   580 <printf>
 138:	83 c4 10             	add    $0x10,%esp
 13b:	eb be                	jmp    fb <main+0xfb>
			printf(1,"set child priority to parent priority: FAILED, should pass\n");
 13d:	50                   	push   %eax
 13e:	50                   	push   %eax
 13f:	68 14 0a 00 00       	push   $0xa14
 144:	6a 01                	push   $0x1
 146:	e8 35 04 00 00       	call   580 <printf>
 14b:	83 c4 10             	add    $0x10,%esp
 14e:	eb 89                	jmp    d9 <main+0xd9>

00000150 <mutex_create>:
}

int mutex_create(char *name){
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
	return mcreate(name);
}
 153:	5d                   	pop    %ebp
	return mcreate(name);
 154:	e9 49 03 00 00       	jmp    4a2 <mcreate>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <mutex_delete>:
int mutex_delete(int muxid){
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
	return mdelete(muxid);
}
 163:	5d                   	pop    %ebp
	return mdelete(muxid);
 164:	e9 41 03 00 00       	jmp    4aa <mdelete>
 169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000170 <mutex_lock>:
int mutex_lock(int muxid){
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
	return mlock(muxid);
}
 173:	5d                   	pop    %ebp
	return mlock(muxid);
 174:	e9 39 03 00 00       	jmp    4b2 <mlock>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000180 <mutex_unlock>:
int mutex_unlock(int muxid){
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
	return munlock(muxid);
}
 183:	5d                   	pop    %ebp
	return munlock(muxid);
 184:	e9 31 03 00 00       	jmp    4ba <munlock>
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <cv_wait>:

int cv_wait(int muxid){
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
	return waitcv(muxid);
}
 193:	5d                   	pop    %ebp
	return waitcv(muxid);
 194:	e9 29 03 00 00       	jmp    4c2 <waitcv>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001a0 <cv_signal>:
int cv_signal(int muxid){
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
	return signalcv(muxid);
 1a3:	5d                   	pop    %ebp
	return signalcv(muxid);
 1a4:	e9 21 03 00 00       	jmp    4ca <signalcv>
 1a9:	66 90                	xchg   %ax,%ax
 1ab:	66 90                	xchg   %ax,%ax
 1ad:	66 90                	xchg   %ax,%ax
 1af:	90                   	nop

000001b0 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	53                   	push   %ebx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 1ba:	89 c2                	mov    %eax,%edx
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1c0:	83 c1 01             	add    $0x1,%ecx
 1c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1c7:	83 c2 01             	add    $0x1,%edx
 1ca:	84 db                	test   %bl,%bl
 1cc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1cf:	75 ef                	jne    1c0 <strcpy+0x10>
		;
	return os;
}
 1d1:	5b                   	pop    %ebx
 1d2:	5d                   	pop    %ebp
 1d3:	c3                   	ret    
 1d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 55 08             	mov    0x8(%ebp),%edx
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 1ea:	0f b6 02             	movzbl (%edx),%eax
 1ed:	0f b6 19             	movzbl (%ecx),%ebx
 1f0:	84 c0                	test   %al,%al
 1f2:	75 1c                	jne    210 <strcmp+0x30>
 1f4:	eb 2a                	jmp    220 <strcmp+0x40>
 1f6:	8d 76 00             	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 200:	83 c2 01             	add    $0x1,%edx
 203:	0f b6 02             	movzbl (%edx),%eax
 206:	83 c1 01             	add    $0x1,%ecx
 209:	0f b6 19             	movzbl (%ecx),%ebx
 20c:	84 c0                	test   %al,%al
 20e:	74 10                	je     220 <strcmp+0x40>
 210:	38 d8                	cmp    %bl,%al
 212:	74 ec                	je     200 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 214:	29 d8                	sub    %ebx,%eax
}
 216:	5b                   	pop    %ebx
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 220:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 222:	29 d8                	sub    %ebx,%eax
}
 224:	5b                   	pop    %ebx
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strlen>:

uint
strlen(char *s)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 236:	80 39 00             	cmpb   $0x0,(%ecx)
 239:	74 15                	je     250 <strlen+0x20>
 23b:	31 d2                	xor    %edx,%edx
 23d:	8d 76 00             	lea    0x0(%esi),%esi
 240:	83 c2 01             	add    $0x1,%edx
 243:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 247:	89 d0                	mov    %edx,%eax
 249:	75 f5                	jne    240 <strlen+0x10>
		;
	return n;
}
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 250:	31 c0                	xor    %eax,%eax
}
 252:	5d                   	pop    %ebp
 253:	c3                   	ret    
 254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 25a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000260 <memset>:

void *
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 267:	8b 4d 10             	mov    0x10(%ebp),%ecx
 26a:	8b 45 0c             	mov    0xc(%ebp),%eax
 26d:	89 d7                	mov    %edx,%edi
 26f:	fc                   	cld    
 270:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 272:	89 d0                	mov    %edx,%eax
 274:	5f                   	pop    %edi
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <strchr>:

char *
strchr(const char *s, char c)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 28a:	0f b6 10             	movzbl (%eax),%edx
 28d:	84 d2                	test   %dl,%dl
 28f:	74 1d                	je     2ae <strchr+0x2e>
		if (*s == c) return (char *)s;
 291:	38 d3                	cmp    %dl,%bl
 293:	89 d9                	mov    %ebx,%ecx
 295:	75 0d                	jne    2a4 <strchr+0x24>
 297:	eb 17                	jmp    2b0 <strchr+0x30>
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2a0:	38 ca                	cmp    %cl,%dl
 2a2:	74 0c                	je     2b0 <strchr+0x30>
	for (; *s; s++)
 2a4:	83 c0 01             	add    $0x1,%eax
 2a7:	0f b6 10             	movzbl (%eax),%edx
 2aa:	84 d2                	test   %dl,%dl
 2ac:	75 f2                	jne    2a0 <strchr+0x20>
	return 0;
 2ae:	31 c0                	xor    %eax,%eax
}
 2b0:	5b                   	pop    %ebx
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    
 2b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <gets>:

char *
gets(char *buf, int max)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	56                   	push   %esi
 2c5:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 2c6:	31 f6                	xor    %esi,%esi
 2c8:	89 f3                	mov    %esi,%ebx
{
 2ca:	83 ec 1c             	sub    $0x1c,%esp
 2cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 2d0:	eb 2f                	jmp    301 <gets+0x41>
 2d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 2d8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2db:	83 ec 04             	sub    $0x4,%esp
 2de:	6a 01                	push   $0x1
 2e0:	50                   	push   %eax
 2e1:	6a 00                	push   $0x0
 2e3:	e8 32 01 00 00       	call   41a <read>
		if (cc < 1) break;
 2e8:	83 c4 10             	add    $0x10,%esp
 2eb:	85 c0                	test   %eax,%eax
 2ed:	7e 1c                	jle    30b <gets+0x4b>
		buf[i++] = c;
 2ef:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2f3:	83 c7 01             	add    $0x1,%edi
 2f6:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 2f9:	3c 0a                	cmp    $0xa,%al
 2fb:	74 23                	je     320 <gets+0x60>
 2fd:	3c 0d                	cmp    $0xd,%al
 2ff:	74 1f                	je     320 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 301:	83 c3 01             	add    $0x1,%ebx
 304:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 307:	89 fe                	mov    %edi,%esi
 309:	7c cd                	jl     2d8 <gets+0x18>
 30b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 310:	c6 03 00             	movb   $0x0,(%ebx)
}
 313:	8d 65 f4             	lea    -0xc(%ebp),%esp
 316:	5b                   	pop    %ebx
 317:	5e                   	pop    %esi
 318:	5f                   	pop    %edi
 319:	5d                   	pop    %ebp
 31a:	c3                   	ret    
 31b:	90                   	nop
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 320:	8b 75 08             	mov    0x8(%ebp),%esi
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	01 de                	add    %ebx,%esi
 328:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 32a:	c6 03 00             	movb   $0x0,(%ebx)
}
 32d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 330:	5b                   	pop    %ebx
 331:	5e                   	pop    %esi
 332:	5f                   	pop    %edi
 333:	5d                   	pop    %ebp
 334:	c3                   	ret    
 335:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000340 <stat>:

int
stat(char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 345:	83 ec 08             	sub    $0x8,%esp
 348:	6a 00                	push   $0x0
 34a:	ff 75 08             	pushl  0x8(%ebp)
 34d:	e8 f0 00 00 00       	call   442 <open>
	if (fd < 0) return -1;
 352:	83 c4 10             	add    $0x10,%esp
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <stat+0x40>
	r = fstat(fd, st);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	ff 75 0c             	pushl  0xc(%ebp)
 35f:	89 c3                	mov    %eax,%ebx
 361:	50                   	push   %eax
 362:	e8 f3 00 00 00       	call   45a <fstat>
	close(fd);
 367:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 36a:	89 c6                	mov    %eax,%esi
	close(fd);
 36c:	e8 b9 00 00 00       	call   42a <close>
	return r;
 371:	83 c4 10             	add    $0x10,%esp
}
 374:	8d 65 f8             	lea    -0x8(%ebp),%esp
 377:	89 f0                	mov    %esi,%eax
 379:	5b                   	pop    %ebx
 37a:	5e                   	pop    %esi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 380:	be ff ff ff ff       	mov    $0xffffffff,%esi
 385:	eb ed                	jmp    374 <stat+0x34>
 387:	89 f6                	mov    %esi,%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <atoi>:

int
atoi(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 397:	0f be 11             	movsbl (%ecx),%edx
 39a:	8d 42 d0             	lea    -0x30(%edx),%eax
 39d:	3c 09                	cmp    $0x9,%al
	n = 0;
 39f:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 3a4:	77 1f                	ja     3c5 <atoi+0x35>
 3a6:	8d 76 00             	lea    0x0(%esi),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 3b0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3b3:	83 c1 01             	add    $0x1,%ecx
 3b6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 3ba:	0f be 11             	movsbl (%ecx),%edx
 3bd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3c0:	80 fb 09             	cmp    $0x9,%bl
 3c3:	76 eb                	jbe    3b0 <atoi+0x20>
	return n;
}
 3c5:	5b                   	pop    %ebx
 3c6:	5d                   	pop    %ebp
 3c7:	c3                   	ret    
 3c8:	90                   	nop
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	56                   	push   %esi
 3d4:	53                   	push   %ebx
 3d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 3de:	85 db                	test   %ebx,%ebx
 3e0:	7e 14                	jle    3f6 <memmove+0x26>
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3ef:	83 c2 01             	add    $0x1,%edx
 3f2:	39 d3                	cmp    %edx,%ebx
 3f4:	75 f2                	jne    3e8 <memmove+0x18>
	return vdst;
}
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    

000003fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3fa:	b8 01 00 00 00       	mov    $0x1,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <exit>:
SYSCALL(exit)
 402:	b8 02 00 00 00       	mov    $0x2,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <wait>:
SYSCALL(wait)
 40a:	b8 03 00 00 00       	mov    $0x3,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <pipe>:
SYSCALL(pipe)
 412:	b8 04 00 00 00       	mov    $0x4,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <read>:
SYSCALL(read)
 41a:	b8 05 00 00 00       	mov    $0x5,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <write>:
SYSCALL(write)
 422:	b8 10 00 00 00       	mov    $0x10,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <close>:
SYSCALL(close)
 42a:	b8 15 00 00 00       	mov    $0x15,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <kill>:
SYSCALL(kill)
 432:	b8 06 00 00 00       	mov    $0x6,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <exec>:
SYSCALL(exec)
 43a:	b8 07 00 00 00       	mov    $0x7,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <open>:
SYSCALL(open)
 442:	b8 0f 00 00 00       	mov    $0xf,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <mknod>:
SYSCALL(mknod)
 44a:	b8 11 00 00 00       	mov    $0x11,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <unlink>:
SYSCALL(unlink)
 452:	b8 12 00 00 00       	mov    $0x12,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <fstat>:
SYSCALL(fstat)
 45a:	b8 08 00 00 00       	mov    $0x8,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <link>:
SYSCALL(link)
 462:	b8 13 00 00 00       	mov    $0x13,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <mkdir>:
SYSCALL(mkdir)
 46a:	b8 14 00 00 00       	mov    $0x14,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <chdir>:
SYSCALL(chdir)
 472:	b8 09 00 00 00       	mov    $0x9,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <dup>:
SYSCALL(dup)
 47a:	b8 0a 00 00 00       	mov    $0xa,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <getpid>:
SYSCALL(getpid)
 482:	b8 0b 00 00 00       	mov    $0xb,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <sbrk>:
SYSCALL(sbrk)
 48a:	b8 0c 00 00 00       	mov    $0xc,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <sleep>:
SYSCALL(sleep)
 492:	b8 0d 00 00 00       	mov    $0xd,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <uptime>:
SYSCALL(uptime)
 49a:	b8 0e 00 00 00       	mov    $0xe,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <mcreate>:
SYSCALL(mcreate)
 4a2:	b8 16 00 00 00       	mov    $0x16,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <mdelete>:
SYSCALL(mdelete)
 4aa:	b8 17 00 00 00       	mov    $0x17,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <mlock>:
SYSCALL(mlock)
 4b2:	b8 18 00 00 00       	mov    $0x18,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <munlock>:
SYSCALL(munlock)
 4ba:	b8 19 00 00 00       	mov    $0x19,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <waitcv>:
SYSCALL(waitcv)
 4c2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <signalcv>:
SYSCALL(signalcv)
 4ca:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <prio_set>:
SYSCALL(prio_set)
 4d2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    
 4da:	66 90                	xchg   %ax,%ax
 4dc:	66 90                	xchg   %ax,%ax
 4de:	66 90                	xchg   %ax,%ax

000004e0 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 4e9:	85 d2                	test   %edx,%edx
{
 4eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 4ee:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 4f0:	79 76                	jns    568 <printint+0x88>
 4f2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4f6:	74 70                	je     568 <printint+0x88>
		x   = -xx;
 4f8:	f7 d8                	neg    %eax
		neg = 1;
 4fa:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 501:	31 f6                	xor    %esi,%esi
 503:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 506:	eb 0a                	jmp    512 <printint+0x32>
 508:	90                   	nop
 509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 510:	89 fe                	mov    %edi,%esi
 512:	31 d2                	xor    %edx,%edx
 514:	8d 7e 01             	lea    0x1(%esi),%edi
 517:	f7 f1                	div    %ecx
 519:	0f b6 92 c8 0a 00 00 	movzbl 0xac8(%edx),%edx
	} while ((x /= base) != 0);
 520:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 522:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 525:	75 e9                	jne    510 <printint+0x30>
	if (neg) buf[i++] = '-';
 527:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 52a:	85 c0                	test   %eax,%eax
 52c:	74 08                	je     536 <printint+0x56>
 52e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 533:	8d 7e 02             	lea    0x2(%esi),%edi
 536:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 53a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 53d:	8d 76 00             	lea    0x0(%esi),%esi
 540:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 543:	83 ec 04             	sub    $0x4,%esp
 546:	83 ee 01             	sub    $0x1,%esi
 549:	6a 01                	push   $0x1
 54b:	53                   	push   %ebx
 54c:	57                   	push   %edi
 54d:	88 45 d7             	mov    %al,-0x29(%ebp)
 550:	e8 cd fe ff ff       	call   422 <write>

	while (--i >= 0) putc(fd, buf[i]);
 555:	83 c4 10             	add    $0x10,%esp
 558:	39 de                	cmp    %ebx,%esi
 55a:	75 e4                	jne    540 <printint+0x60>
}
 55c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55f:	5b                   	pop    %ebx
 560:	5e                   	pop    %esi
 561:	5f                   	pop    %edi
 562:	5d                   	pop    %ebp
 563:	c3                   	ret    
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 568:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 56f:	eb 90                	jmp    501 <printint+0x21>
 571:	eb 0d                	jmp    580 <printf>
 573:	90                   	nop
 574:	90                   	nop
 575:	90                   	nop
 576:	90                   	nop
 577:	90                   	nop
 578:	90                   	nop
 579:	90                   	nop
 57a:	90                   	nop
 57b:	90                   	nop
 57c:	90                   	nop
 57d:	90                   	nop
 57e:	90                   	nop
 57f:	90                   	nop

00000580 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 589:	8b 75 0c             	mov    0xc(%ebp),%esi
 58c:	0f b6 1e             	movzbl (%esi),%ebx
 58f:	84 db                	test   %bl,%bl
 591:	0f 84 b3 00 00 00    	je     64a <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 597:	8d 45 10             	lea    0x10(%ebp),%eax
 59a:	83 c6 01             	add    $0x1,%esi
	state = 0;
 59d:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 59f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5a2:	eb 2f                	jmp    5d3 <printf+0x53>
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 5a8:	83 f8 25             	cmp    $0x25,%eax
 5ab:	0f 84 a7 00 00 00    	je     658 <printf+0xd8>
	write(fd, &c, 1);
 5b1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5b4:	83 ec 04             	sub    $0x4,%esp
 5b7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5ba:	6a 01                	push   $0x1
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 5d fe ff ff       	call   422 <write>
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 5cb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5cf:	84 db                	test   %bl,%bl
 5d1:	74 77                	je     64a <printf+0xca>
		if (state == 0) {
 5d3:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 5d5:	0f be cb             	movsbl %bl,%ecx
 5d8:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 5db:	74 cb                	je     5a8 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 5dd:	83 ff 25             	cmp    $0x25,%edi
 5e0:	75 e6                	jne    5c8 <printf+0x48>
			if (c == 'd') {
 5e2:	83 f8 64             	cmp    $0x64,%eax
 5e5:	0f 84 05 01 00 00    	je     6f0 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 5eb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5f1:	83 f9 70             	cmp    $0x70,%ecx
 5f4:	74 72                	je     668 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 5f6:	83 f8 73             	cmp    $0x73,%eax
 5f9:	0f 84 99 00 00 00    	je     698 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 5ff:	83 f8 63             	cmp    $0x63,%eax
 602:	0f 84 08 01 00 00    	je     710 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 608:	83 f8 25             	cmp    $0x25,%eax
 60b:	0f 84 ef 00 00 00    	je     700 <printf+0x180>
	write(fd, &c, 1);
 611:	8d 45 e7             	lea    -0x19(%ebp),%eax
 614:	83 ec 04             	sub    $0x4,%esp
 617:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 61b:	6a 01                	push   $0x1
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 fc fd ff ff       	call   422 <write>
 626:	83 c4 0c             	add    $0xc,%esp
 629:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 62c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 62f:	6a 01                	push   $0x1
 631:	50                   	push   %eax
 632:	ff 75 08             	pushl  0x8(%ebp)
 635:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 638:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 63a:	e8 e3 fd ff ff       	call   422 <write>
	for (i = 0; fmt[i]; i++) {
 63f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 643:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 646:	84 db                	test   %bl,%bl
 648:	75 89                	jne    5d3 <printf+0x53>
		}
	}
}
 64a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 64d:	5b                   	pop    %ebx
 64e:	5e                   	pop    %esi
 64f:	5f                   	pop    %edi
 650:	5d                   	pop    %ebp
 651:	c3                   	ret    
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 658:	bf 25 00 00 00       	mov    $0x25,%edi
 65d:	e9 66 ff ff ff       	jmp    5c8 <printf+0x48>
 662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 668:	83 ec 0c             	sub    $0xc,%esp
 66b:	b9 10 00 00 00       	mov    $0x10,%ecx
 670:	6a 00                	push   $0x0
 672:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	8b 17                	mov    (%edi),%edx
 67a:	e8 61 fe ff ff       	call   4e0 <printint>
				ap++;
 67f:	89 f8                	mov    %edi,%eax
 681:	83 c4 10             	add    $0x10,%esp
			state = 0;
 684:	31 ff                	xor    %edi,%edi
				ap++;
 686:	83 c0 04             	add    $0x4,%eax
 689:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 68c:	e9 37 ff ff ff       	jmp    5c8 <printf+0x48>
 691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 698:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 69b:	8b 08                	mov    (%eax),%ecx
				ap++;
 69d:	83 c0 04             	add    $0x4,%eax
 6a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 6a3:	85 c9                	test   %ecx,%ecx
 6a5:	0f 84 8e 00 00 00    	je     739 <printf+0x1b9>
				while (*s != 0) {
 6ab:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 6ae:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 6b0:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 6b2:	84 c0                	test   %al,%al
 6b4:	0f 84 0e ff ff ff    	je     5c8 <printf+0x48>
 6ba:	89 75 d0             	mov    %esi,-0x30(%ebp)
 6bd:	89 de                	mov    %ebx,%esi
 6bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 6c2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 6c5:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 6c8:	83 ec 04             	sub    $0x4,%esp
					s++;
 6cb:	83 c6 01             	add    $0x1,%esi
 6ce:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 6d1:	6a 01                	push   $0x1
 6d3:	57                   	push   %edi
 6d4:	53                   	push   %ebx
 6d5:	e8 48 fd ff ff       	call   422 <write>
				while (*s != 0) {
 6da:	0f b6 06             	movzbl (%esi),%eax
 6dd:	83 c4 10             	add    $0x10,%esp
 6e0:	84 c0                	test   %al,%al
 6e2:	75 e4                	jne    6c8 <printf+0x148>
 6e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 6e7:	31 ff                	xor    %edi,%edi
 6e9:	e9 da fe ff ff       	jmp    5c8 <printf+0x48>
 6ee:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f8:	6a 01                	push   $0x1
 6fa:	e9 73 ff ff ff       	jmp    672 <printf+0xf2>
 6ff:	90                   	nop
	write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 706:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 709:	6a 01                	push   $0x1
 70b:	e9 21 ff ff ff       	jmp    631 <printf+0xb1>
				putc(fd, *ap);
 710:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 713:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 716:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 718:	6a 01                	push   $0x1
				ap++;
 71a:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 71d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 720:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 723:	50                   	push   %eax
 724:	ff 75 08             	pushl  0x8(%ebp)
 727:	e8 f6 fc ff ff       	call   422 <write>
				ap++;
 72c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 72f:	83 c4 10             	add    $0x10,%esp
			state = 0;
 732:	31 ff                	xor    %edi,%edi
 734:	e9 8f fe ff ff       	jmp    5c8 <printf+0x48>
				if (s == 0) s = "(null)";
 739:	bb c0 0a 00 00       	mov    $0xac0,%ebx
				while (*s != 0) {
 73e:	b8 28 00 00 00       	mov    $0x28,%eax
 743:	e9 72 ff ff ff       	jmp    6ba <printf+0x13a>
 748:	66 90                	xchg   %ax,%ax
 74a:	66 90                	xchg   %ax,%ax
 74c:	66 90                	xchg   %ax,%ax
 74e:	66 90                	xchg   %ax,%ax

00000750 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 750:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 751:	a1 30 0e 00 00       	mov    0xe30,%eax
{
 756:	89 e5                	mov    %esp,%ebp
 758:	57                   	push   %edi
 759:	56                   	push   %esi
 75a:	53                   	push   %ebx
 75b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 75e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	39 c8                	cmp    %ecx,%eax
 76a:	8b 10                	mov    (%eax),%edx
 76c:	73 32                	jae    7a0 <free+0x50>
 76e:	39 d1                	cmp    %edx,%ecx
 770:	72 04                	jb     776 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 772:	39 d0                	cmp    %edx,%eax
 774:	72 32                	jb     7a8 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 776:	8b 73 fc             	mov    -0x4(%ebx),%esi
 779:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 77c:	39 fa                	cmp    %edi,%edx
 77e:	74 30                	je     7b0 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 780:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 783:	8b 50 04             	mov    0x4(%eax),%edx
 786:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 789:	39 f1                	cmp    %esi,%ecx
 78b:	74 3a                	je     7c7 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 78d:	89 08                	mov    %ecx,(%eax)
	freep = p;
 78f:	a3 30 0e 00 00       	mov    %eax,0xe30
}
 794:	5b                   	pop    %ebx
 795:	5e                   	pop    %esi
 796:	5f                   	pop    %edi
 797:	5d                   	pop    %ebp
 798:	c3                   	ret    
 799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7a0:	39 d0                	cmp    %edx,%eax
 7a2:	72 04                	jb     7a8 <free+0x58>
 7a4:	39 d1                	cmp    %edx,%ecx
 7a6:	72 ce                	jb     776 <free+0x26>
{
 7a8:	89 d0                	mov    %edx,%eax
 7aa:	eb bc                	jmp    768 <free+0x18>
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 7b0:	03 72 04             	add    0x4(%edx),%esi
 7b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	8b 10                	mov    (%eax),%edx
 7b8:	8b 12                	mov    (%edx),%edx
 7ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 7bd:	8b 50 04             	mov    0x4(%eax),%edx
 7c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7c3:	39 f1                	cmp    %esi,%ecx
 7c5:	75 c6                	jne    78d <free+0x3d>
		p->s.size += bp->s.size;
 7c7:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 7ca:	a3 30 0e 00 00       	mov    %eax,0xe30
		p->s.size += bp->s.size;
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 7d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7d5:	89 10                	mov    %edx,(%eax)
}
 7d7:	5b                   	pop    %ebx
 7d8:	5e                   	pop    %esi
 7d9:	5f                   	pop    %edi
 7da:	5d                   	pop    %ebp
 7db:	c3                   	ret    
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007e0 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	57                   	push   %edi
 7e4:	56                   	push   %esi
 7e5:	53                   	push   %ebx
 7e6:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7e9:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 7ec:	8b 15 30 0e 00 00    	mov    0xe30,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7f2:	8d 78 07             	lea    0x7(%eax),%edi
 7f5:	c1 ef 03             	shr    $0x3,%edi
 7f8:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 7fb:	85 d2                	test   %edx,%edx
 7fd:	0f 84 9d 00 00 00    	je     8a0 <malloc+0xc0>
 803:	8b 02                	mov    (%edx),%eax
 805:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 808:	39 cf                	cmp    %ecx,%edi
 80a:	76 6c                	jbe    878 <malloc+0x98>
 80c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 812:	bb 00 10 00 00       	mov    $0x1000,%ebx
 817:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 81a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 821:	eb 0e                	jmp    831 <malloc+0x51>
 823:	90                   	nop
 824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 828:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 82a:	8b 48 04             	mov    0x4(%eax),%ecx
 82d:	39 f9                	cmp    %edi,%ecx
 82f:	73 47                	jae    878 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 831:	39 05 30 0e 00 00    	cmp    %eax,0xe30
 837:	89 c2                	mov    %eax,%edx
 839:	75 ed                	jne    828 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	56                   	push   %esi
 83f:	e8 46 fc ff ff       	call   48a <sbrk>
	if (p == (char *)-1) return 0;
 844:	83 c4 10             	add    $0x10,%esp
 847:	83 f8 ff             	cmp    $0xffffffff,%eax
 84a:	74 1c                	je     868 <malloc+0x88>
	hp->s.size = nu;
 84c:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 84f:	83 ec 0c             	sub    $0xc,%esp
 852:	83 c0 08             	add    $0x8,%eax
 855:	50                   	push   %eax
 856:	e8 f5 fe ff ff       	call   750 <free>
	return freep;
 85b:	8b 15 30 0e 00 00    	mov    0xe30,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 861:	83 c4 10             	add    $0x10,%esp
 864:	85 d2                	test   %edx,%edx
 866:	75 c0                	jne    828 <malloc+0x48>
	}
}
 868:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 86b:	31 c0                	xor    %eax,%eax
}
 86d:	5b                   	pop    %ebx
 86e:	5e                   	pop    %esi
 86f:	5f                   	pop    %edi
 870:	5d                   	pop    %ebp
 871:	c3                   	ret    
 872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 878:	39 cf                	cmp    %ecx,%edi
 87a:	74 54                	je     8d0 <malloc+0xf0>
				p->s.size -= nunits;
 87c:	29 f9                	sub    %edi,%ecx
 87e:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 881:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 884:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 887:	89 15 30 0e 00 00    	mov    %edx,0xe30
}
 88d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 890:	83 c0 08             	add    $0x8,%eax
}
 893:	5b                   	pop    %ebx
 894:	5e                   	pop    %esi
 895:	5f                   	pop    %edi
 896:	5d                   	pop    %ebp
 897:	c3                   	ret    
 898:	90                   	nop
 899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 8a0:	c7 05 30 0e 00 00 34 	movl   $0xe34,0xe30
 8a7:	0e 00 00 
 8aa:	c7 05 34 0e 00 00 34 	movl   $0xe34,0xe34
 8b1:	0e 00 00 
		base.s.size                = 0;
 8b4:	b8 34 0e 00 00       	mov    $0xe34,%eax
 8b9:	c7 05 38 0e 00 00 00 	movl   $0x0,0xe38
 8c0:	00 00 00 
 8c3:	e9 44 ff ff ff       	jmp    80c <malloc+0x2c>
 8c8:	90                   	nop
 8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 8d0:	8b 08                	mov    (%eax),%ecx
 8d2:	89 0a                	mov    %ecx,(%edx)
 8d4:	eb b1                	jmp    887 <malloc+0xa7>
