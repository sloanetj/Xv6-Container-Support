
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
  18:	68 28 09 00 00       	push   $0x928
  1d:	e8 d0 04 00 00       	call   4f2 <mcreate>
  22:	83 c4 10             	add    $0x10,%esp
  25:	89 c6                	mov    %eax,%esi
		if (fork() == 0){
  27:	e8 1e 04 00 00       	call   44a <fork>
  2c:	85 c0                	test   %eax,%eax
  2e:	0f 84 ba 00 00 00    	je     ee <main+0xee>
	for(i=0; i<5; i++){
  34:	83 eb 01             	sub    $0x1,%ebx
  37:	75 ee                	jne    27 <main+0x27>
  39:	bb 0a 00 00 00       	mov    $0xa,%ebx
  3e:	66 90                	xchg   %ax,%ax
		wait();
  40:	e8 15 04 00 00       	call   45a <wait>
	for(i=0; i<10; i++){
  45:	83 eb 01             	sub    $0x1,%ebx
  48:	75 f6                	jne    40 <main+0x40>
	return mcreate(name);
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	68 31 09 00 00       	push   $0x931
  52:	e8 9b 04 00 00       	call   4f2 <mcreate>
  57:	89 c3                	mov    %eax,%ebx
	if (fork() == 0){
  59:	e8 ec 03 00 00       	call   44a <fork>
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
  69:	e8 94 04 00 00       	call   502 <mlock>
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
  84:	e8 91 04 00 00       	call   51a <signalcv>
		while (!cv_signal(muxid)){
  89:	83 c4 10             	add    $0x10,%esp
  8c:	85 c0                	test   %eax,%eax
  8e:	74 f0                	je     80 <main+0x80>
	return munlock(muxid);
  90:	83 ec 0c             	sub    $0xc,%esp
  93:	53                   	push   %ebx
  94:	e8 71 04 00 00       	call   50a <munlock>
		if (!mutex_unlock(muxid)){
  99:	83 c4 10             	add    $0x10,%esp
  9c:	85 c0                	test   %eax,%eax
  9e:	0f 85 cc 00 00 00    	jne    170 <main+0x170>
			printf(1,"SIGNAL UNLOCK FAILURE\n");
  a4:	51                   	push   %ecx
  a5:	51                   	push   %ecx
  a6:	68 4e 09 00 00       	push   $0x94e
  ab:	6a 01                	push   $0x1
  ad:	e8 1e 05 00 00       	call   5d0 <printf>
			exit();
  b2:	e8 9b 03 00 00       	call   452 <exit>
	return mlock(muxid);
  b7:	83 ec 0c             	sub    $0xc,%esp
  ba:	53                   	push   %ebx
  bb:	e8 42 04 00 00       	call   502 <mlock>
	if (!mutex_lock(muxid)){
  c0:	83 c4 10             	add    $0x10,%esp
  c3:	85 c0                	test   %eax,%eax
  c5:	74 37                	je     fe <main+0xfe>
	return waitcv(muxid);
  c7:	83 ec 0c             	sub    $0xc,%esp
  ca:	53                   	push   %ebx
  cb:	e8 42 04 00 00       	call   512 <waitcv>
	if (!cv_wait(muxid)){
  d0:	83 c4 10             	add    $0x10,%esp
  d3:	85 c0                	test   %eax,%eax
  d5:	0f 85 ad 00 00 00    	jne    188 <main+0x188>
		printf(1,"CV WAIT FAILURE\n");
  db:	52                   	push   %edx
  dc:	52                   	push   %edx
  dd:	68 65 09 00 00       	push   $0x965
  e2:	6a 01                	push   $0x1
  e4:	e8 e7 04 00 00       	call   5d0 <printf>
		exit();
  e9:	e8 64 03 00 00       	call   452 <exit>
	return mlock(muxid);
  ee:	83 ec 0c             	sub    $0xc,%esp
  f1:	56                   	push   %esi
  f2:	e8 0b 04 00 00       	call   502 <mlock>
			if (!mutex_lock(id)){
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	85 c0                	test   %eax,%eax
  fc:	75 13                	jne    111 <main+0x111>
				printf(1,"LOCK FAILURE\n");
  fe:	51                   	push   %ecx
  ff:	51                   	push   %ecx
 100:	68 40 09 00 00       	push   $0x940
 105:	6a 01                	push   $0x1
 107:	e8 c4 04 00 00       	call   5d0 <printf>
				exit();
 10c:	e8 41 03 00 00       	call   452 <exit>
				printf(1,"%d\n", j);
 111:	50                   	push   %eax
 112:	6a 01                	push   $0x1
 114:	68 2d 09 00 00       	push   $0x92d
 119:	6a 01                	push   $0x1
 11b:	e8 b0 04 00 00       	call   5d0 <printf>
 120:	83 c4 0c             	add    $0xc,%esp
 123:	6a 02                	push   $0x2
 125:	68 2d 09 00 00       	push   $0x92d
 12a:	6a 01                	push   $0x1
 12c:	e8 9f 04 00 00       	call   5d0 <printf>
 131:	83 c4 0c             	add    $0xc,%esp
 134:	6a 03                	push   $0x3
 136:	68 2d 09 00 00       	push   $0x92d
 13b:	6a 01                	push   $0x1
 13d:	e8 8e 04 00 00       	call   5d0 <printf>
			printf(1,"\n");
 142:	58                   	pop    %eax
 143:	5a                   	pop    %edx
 144:	68 4c 09 00 00       	push   $0x94c
 149:	6a 01                	push   $0x1
 14b:	e8 80 04 00 00       	call   5d0 <printf>
	return munlock(muxid);
 150:	89 34 24             	mov    %esi,(%esp)
 153:	e8 b2 03 00 00       	call   50a <munlock>
			if (!mutex_unlock(id)){
 158:	83 c4 10             	add    $0x10,%esp
 15b:	85 c0                	test   %eax,%eax
 15d:	75 11                	jne    170 <main+0x170>
				printf(1,"UNLOCK FAILURE\n");
 15f:	56                   	push   %esi
 160:	56                   	push   %esi
 161:	68 55 09 00 00       	push   $0x955
 166:	6a 01                	push   $0x1
 168:	e8 63 04 00 00       	call   5d0 <printf>
 16d:	83 c4 10             	add    $0x10,%esp
			exit();
 170:	e8 dd 02 00 00       	call   452 <exit>
			printf(1,"SIGNAL LOCK FAILURE\n");
 175:	53                   	push   %ebx
 176:	53                   	push   %ebx
 177:	68 39 09 00 00       	push   $0x939
 17c:	6a 01                	push   $0x1
 17e:	e8 4d 04 00 00       	call   5d0 <printf>
			exit();
 183:	e8 ca 02 00 00       	call   452 <exit>
	wait();
 188:	e8 cd 02 00 00       	call   45a <wait>
	printf(1,"CV SUCCESS\n");
 18d:	50                   	push   %eax
 18e:	50                   	push   %eax
 18f:	68 76 09 00 00       	push   $0x976
 194:	6a 01                	push   $0x1
 196:	e8 35 04 00 00       	call   5d0 <printf>
	exit();
 19b:	e8 b2 02 00 00       	call   452 <exit>

000001a0 <mutex_create>:
int mutex_create(char *name){
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
}
 1a3:	5d                   	pop    %ebp
	return mcreate(name);
 1a4:	e9 49 03 00 00       	jmp    4f2 <mcreate>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001b0 <mutex_delete>:
int mutex_delete(int muxid){
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
}
 1b3:	5d                   	pop    %ebp
	return mdelete(muxid);
 1b4:	e9 41 03 00 00       	jmp    4fa <mdelete>
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001c0 <mutex_lock>:
int mutex_lock(int muxid){
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
}
 1c3:	5d                   	pop    %ebp
	return mlock(muxid);
 1c4:	e9 39 03 00 00       	jmp    502 <mlock>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001d0 <mutex_unlock>:
int mutex_unlock(int muxid){
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
}
 1d3:	5d                   	pop    %ebp
	return munlock(muxid);
 1d4:	e9 31 03 00 00       	jmp    50a <munlock>
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <cv_wait>:
int cv_wait(int muxid){
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
}
 1e3:	5d                   	pop    %ebp
	return waitcv(muxid);
 1e4:	e9 29 03 00 00       	jmp    512 <waitcv>
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001f0 <cv_signal>:
int cv_signal(int muxid){
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	5d                   	pop    %ebp
	return signalcv(muxid);
 1f4:	e9 21 03 00 00       	jmp    51a <signalcv>
 1f9:	66 90                	xchg   %ax,%ax
 1fb:	66 90                	xchg   %ax,%ax
 1fd:	66 90                	xchg   %ax,%ax
 1ff:	90                   	nop

00000200 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 20a:	89 c2                	mov    %eax,%edx
 20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 210:	83 c1 01             	add    $0x1,%ecx
 213:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 217:	83 c2 01             	add    $0x1,%edx
 21a:	84 db                	test   %bl,%bl
 21c:	88 5a ff             	mov    %bl,-0x1(%edx)
 21f:	75 ef                	jne    210 <strcpy+0x10>
		;
	return os;
}
 221:	5b                   	pop    %ebx
 222:	5d                   	pop    %ebp
 223:	c3                   	ret    
 224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 22a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000230 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 55 08             	mov    0x8(%ebp),%edx
 237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 23a:	0f b6 02             	movzbl (%edx),%eax
 23d:	0f b6 19             	movzbl (%ecx),%ebx
 240:	84 c0                	test   %al,%al
 242:	75 1c                	jne    260 <strcmp+0x30>
 244:	eb 2a                	jmp    270 <strcmp+0x40>
 246:	8d 76 00             	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 250:	83 c2 01             	add    $0x1,%edx
 253:	0f b6 02             	movzbl (%edx),%eax
 256:	83 c1 01             	add    $0x1,%ecx
 259:	0f b6 19             	movzbl (%ecx),%ebx
 25c:	84 c0                	test   %al,%al
 25e:	74 10                	je     270 <strcmp+0x40>
 260:	38 d8                	cmp    %bl,%al
 262:	74 ec                	je     250 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 264:	29 d8                	sub    %ebx,%eax
}
 266:	5b                   	pop    %ebx
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 270:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 272:	29 d8                	sub    %ebx,%eax
}
 274:	5b                   	pop    %ebx
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	89 f6                	mov    %esi,%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <strlen>:

uint
strlen(char *s)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 286:	80 39 00             	cmpb   $0x0,(%ecx)
 289:	74 15                	je     2a0 <strlen+0x20>
 28b:	31 d2                	xor    %edx,%edx
 28d:	8d 76 00             	lea    0x0(%esi),%esi
 290:	83 c2 01             	add    $0x1,%edx
 293:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 297:	89 d0                	mov    %edx,%eax
 299:	75 f5                	jne    290 <strlen+0x10>
		;
	return n;
}
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 2a0:	31 c0                	xor    %eax,%eax
}
 2a2:	5d                   	pop    %ebp
 2a3:	c3                   	ret    
 2a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002b0 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 2b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 d7                	mov    %edx,%edi
 2bf:	fc                   	cld    
 2c0:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 2c2:	89 d0                	mov    %edx,%eax
 2c4:	5f                   	pop    %edi
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <strchr>:

char *
strchr(const char *s, char c)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 2da:	0f b6 10             	movzbl (%eax),%edx
 2dd:	84 d2                	test   %dl,%dl
 2df:	74 1d                	je     2fe <strchr+0x2e>
		if (*s == c) return (char *)s;
 2e1:	38 d3                	cmp    %dl,%bl
 2e3:	89 d9                	mov    %ebx,%ecx
 2e5:	75 0d                	jne    2f4 <strchr+0x24>
 2e7:	eb 17                	jmp    300 <strchr+0x30>
 2e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2f0:	38 ca                	cmp    %cl,%dl
 2f2:	74 0c                	je     300 <strchr+0x30>
	for (; *s; s++)
 2f4:	83 c0 01             	add    $0x1,%eax
 2f7:	0f b6 10             	movzbl (%eax),%edx
 2fa:	84 d2                	test   %dl,%dl
 2fc:	75 f2                	jne    2f0 <strchr+0x20>
	return 0;
 2fe:	31 c0                	xor    %eax,%eax
}
 300:	5b                   	pop    %ebx
 301:	5d                   	pop    %ebp
 302:	c3                   	ret    
 303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <gets>:

char *
gets(char *buf, int max)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 316:	31 f6                	xor    %esi,%esi
 318:	89 f3                	mov    %esi,%ebx
{
 31a:	83 ec 1c             	sub    $0x1c,%esp
 31d:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 320:	eb 2f                	jmp    351 <gets+0x41>
 322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 328:	8d 45 e7             	lea    -0x19(%ebp),%eax
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	6a 01                	push   $0x1
 330:	50                   	push   %eax
 331:	6a 00                	push   $0x0
 333:	e8 32 01 00 00       	call   46a <read>
		if (cc < 1) break;
 338:	83 c4 10             	add    $0x10,%esp
 33b:	85 c0                	test   %eax,%eax
 33d:	7e 1c                	jle    35b <gets+0x4b>
		buf[i++] = c;
 33f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 343:	83 c7 01             	add    $0x1,%edi
 346:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 349:	3c 0a                	cmp    $0xa,%al
 34b:	74 23                	je     370 <gets+0x60>
 34d:	3c 0d                	cmp    $0xd,%al
 34f:	74 1f                	je     370 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 351:	83 c3 01             	add    $0x1,%ebx
 354:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 357:	89 fe                	mov    %edi,%esi
 359:	7c cd                	jl     328 <gets+0x18>
 35b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 360:	c6 03 00             	movb   $0x0,(%ebx)
}
 363:	8d 65 f4             	lea    -0xc(%ebp),%esp
 366:	5b                   	pop    %ebx
 367:	5e                   	pop    %esi
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    
 36b:	90                   	nop
 36c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 370:	8b 75 08             	mov    0x8(%ebp),%esi
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	01 de                	add    %ebx,%esi
 378:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 37a:	c6 03 00             	movb   $0x0,(%ebx)
}
 37d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 380:	5b                   	pop    %ebx
 381:	5e                   	pop    %esi
 382:	5f                   	pop    %edi
 383:	5d                   	pop    %ebp
 384:	c3                   	ret    
 385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <stat>:

int
stat(char *n, struct stat *st)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	56                   	push   %esi
 394:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 395:	83 ec 08             	sub    $0x8,%esp
 398:	6a 00                	push   $0x0
 39a:	ff 75 08             	pushl  0x8(%ebp)
 39d:	e8 f0 00 00 00       	call   492 <open>
	if (fd < 0) return -1;
 3a2:	83 c4 10             	add    $0x10,%esp
 3a5:	85 c0                	test   %eax,%eax
 3a7:	78 27                	js     3d0 <stat+0x40>
	r = fstat(fd, st);
 3a9:	83 ec 08             	sub    $0x8,%esp
 3ac:	ff 75 0c             	pushl  0xc(%ebp)
 3af:	89 c3                	mov    %eax,%ebx
 3b1:	50                   	push   %eax
 3b2:	e8 f3 00 00 00       	call   4aa <fstat>
	close(fd);
 3b7:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 3ba:	89 c6                	mov    %eax,%esi
	close(fd);
 3bc:	e8 b9 00 00 00       	call   47a <close>
	return r;
 3c1:	83 c4 10             	add    $0x10,%esp
}
 3c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3c7:	89 f0                	mov    %esi,%eax
 3c9:	5b                   	pop    %ebx
 3ca:	5e                   	pop    %esi
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 3d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3d5:	eb ed                	jmp    3c4 <stat+0x34>
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <atoi>:

int
atoi(const char *s)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 3e7:	0f be 11             	movsbl (%ecx),%edx
 3ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 3ed:	3c 09                	cmp    $0x9,%al
	n = 0;
 3ef:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 3f4:	77 1f                	ja     415 <atoi+0x35>
 3f6:	8d 76 00             	lea    0x0(%esi),%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 400:	8d 04 80             	lea    (%eax,%eax,4),%eax
 403:	83 c1 01             	add    $0x1,%ecx
 406:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 40a:	0f be 11             	movsbl (%ecx),%edx
 40d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 410:	80 fb 09             	cmp    $0x9,%bl
 413:	76 eb                	jbe    400 <atoi+0x20>
	return n;
}
 415:	5b                   	pop    %ebx
 416:	5d                   	pop    %ebp
 417:	c3                   	ret    
 418:	90                   	nop
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000420 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
 425:	8b 5d 10             	mov    0x10(%ebp),%ebx
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 42e:	85 db                	test   %ebx,%ebx
 430:	7e 14                	jle    446 <memmove+0x26>
 432:	31 d2                	xor    %edx,%edx
 434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 438:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 43c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 43f:	83 c2 01             	add    $0x1,%edx
 442:	39 d3                	cmp    %edx,%ebx
 444:	75 f2                	jne    438 <memmove+0x18>
	return vdst;
}
 446:	5b                   	pop    %ebx
 447:	5e                   	pop    %esi
 448:	5d                   	pop    %ebp
 449:	c3                   	ret    

0000044a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44a:	b8 01 00 00 00       	mov    $0x1,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <exit>:
SYSCALL(exit)
 452:	b8 02 00 00 00       	mov    $0x2,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <wait>:
SYSCALL(wait)
 45a:	b8 03 00 00 00       	mov    $0x3,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <pipe>:
SYSCALL(pipe)
 462:	b8 04 00 00 00       	mov    $0x4,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <read>:
SYSCALL(read)
 46a:	b8 05 00 00 00       	mov    $0x5,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <write>:
SYSCALL(write)
 472:	b8 10 00 00 00       	mov    $0x10,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <close>:
SYSCALL(close)
 47a:	b8 15 00 00 00       	mov    $0x15,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <kill>:
SYSCALL(kill)
 482:	b8 06 00 00 00       	mov    $0x6,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <exec>:
SYSCALL(exec)
 48a:	b8 07 00 00 00       	mov    $0x7,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <open>:
SYSCALL(open)
 492:	b8 0f 00 00 00       	mov    $0xf,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mknod>:
SYSCALL(mknod)
 49a:	b8 11 00 00 00       	mov    $0x11,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <unlink>:
SYSCALL(unlink)
 4a2:	b8 12 00 00 00       	mov    $0x12,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <fstat>:
SYSCALL(fstat)
 4aa:	b8 08 00 00 00       	mov    $0x8,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <link>:
SYSCALL(link)
 4b2:	b8 13 00 00 00       	mov    $0x13,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <mkdir>:
SYSCALL(mkdir)
 4ba:	b8 14 00 00 00       	mov    $0x14,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <chdir>:
SYSCALL(chdir)
 4c2:	b8 09 00 00 00       	mov    $0x9,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <dup>:
SYSCALL(dup)
 4ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <getpid>:
SYSCALL(getpid)
 4d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <sbrk>:
SYSCALL(sbrk)
 4da:	b8 0c 00 00 00       	mov    $0xc,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <sleep>:
SYSCALL(sleep)
 4e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <uptime>:
SYSCALL(uptime)
 4ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <mcreate>:
SYSCALL(mcreate)
 4f2:	b8 16 00 00 00       	mov    $0x16,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <mdelete>:
SYSCALL(mdelete)
 4fa:	b8 17 00 00 00       	mov    $0x17,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <mlock>:
SYSCALL(mlock)
 502:	b8 18 00 00 00       	mov    $0x18,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <munlock>:
SYSCALL(munlock)
 50a:	b8 19 00 00 00       	mov    $0x19,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <waitcv>:
SYSCALL(waitcv)
 512:	b8 1a 00 00 00       	mov    $0x1a,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <signalcv>:
SYSCALL(signalcv)
 51a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    
 522:	66 90                	xchg   %ax,%ax
 524:	66 90                	xchg   %ax,%ax
 526:	66 90                	xchg   %ax,%ax
 528:	66 90                	xchg   %ax,%ax
 52a:	66 90                	xchg   %ax,%ax
 52c:	66 90                	xchg   %ax,%ax
 52e:	66 90                	xchg   %ax,%ax

00000530 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 539:	85 d2                	test   %edx,%edx
{
 53b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 53e:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 540:	79 76                	jns    5b8 <printint+0x88>
 542:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 546:	74 70                	je     5b8 <printint+0x88>
		x   = -xx;
 548:	f7 d8                	neg    %eax
		neg = 1;
 54a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 551:	31 f6                	xor    %esi,%esi
 553:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 556:	eb 0a                	jmp    562 <printint+0x32>
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 560:	89 fe                	mov    %edi,%esi
 562:	31 d2                	xor    %edx,%edx
 564:	8d 7e 01             	lea    0x1(%esi),%edi
 567:	f7 f1                	div    %ecx
 569:	0f b6 92 8c 09 00 00 	movzbl 0x98c(%edx),%edx
	} while ((x /= base) != 0);
 570:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 572:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 575:	75 e9                	jne    560 <printint+0x30>
	if (neg) buf[i++] = '-';
 577:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 57a:	85 c0                	test   %eax,%eax
 57c:	74 08                	je     586 <printint+0x56>
 57e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 583:	8d 7e 02             	lea    0x2(%esi),%edi
 586:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 58a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
 596:	83 ee 01             	sub    $0x1,%esi
 599:	6a 01                	push   $0x1
 59b:	53                   	push   %ebx
 59c:	57                   	push   %edi
 59d:	88 45 d7             	mov    %al,-0x29(%ebp)
 5a0:	e8 cd fe ff ff       	call   472 <write>

	while (--i >= 0) putc(fd, buf[i]);
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	39 de                	cmp    %ebx,%esi
 5aa:	75 e4                	jne    590 <printint+0x60>
}
 5ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 5b8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5bf:	eb 90                	jmp    551 <printint+0x21>
 5c1:	eb 0d                	jmp    5d0 <printf>
 5c3:	90                   	nop
 5c4:	90                   	nop
 5c5:	90                   	nop
 5c6:	90                   	nop
 5c7:	90                   	nop
 5c8:	90                   	nop
 5c9:	90                   	nop
 5ca:	90                   	nop
 5cb:	90                   	nop
 5cc:	90                   	nop
 5cd:	90                   	nop
 5ce:	90                   	nop
 5cf:	90                   	nop

000005d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 5d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5dc:	0f b6 1e             	movzbl (%esi),%ebx
 5df:	84 db                	test   %bl,%bl
 5e1:	0f 84 b3 00 00 00    	je     69a <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 5e7:	8d 45 10             	lea    0x10(%ebp),%eax
 5ea:	83 c6 01             	add    $0x1,%esi
	state = 0;
 5ed:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 5ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5f2:	eb 2f                	jmp    623 <printf+0x53>
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	0f 84 a7 00 00 00    	je     6a8 <printf+0xd8>
	write(fd, &c, 1);
 601:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 604:	83 ec 04             	sub    $0x4,%esp
 607:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 60a:	6a 01                	push   $0x1
 60c:	50                   	push   %eax
 60d:	ff 75 08             	pushl  0x8(%ebp)
 610:	e8 5d fe ff ff       	call   472 <write>
 615:	83 c4 10             	add    $0x10,%esp
 618:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 61b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 61f:	84 db                	test   %bl,%bl
 621:	74 77                	je     69a <printf+0xca>
		if (state == 0) {
 623:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 625:	0f be cb             	movsbl %bl,%ecx
 628:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 62b:	74 cb                	je     5f8 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 62d:	83 ff 25             	cmp    $0x25,%edi
 630:	75 e6                	jne    618 <printf+0x48>
			if (c == 'd') {
 632:	83 f8 64             	cmp    $0x64,%eax
 635:	0f 84 05 01 00 00    	je     740 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 63b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 641:	83 f9 70             	cmp    $0x70,%ecx
 644:	74 72                	je     6b8 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 646:	83 f8 73             	cmp    $0x73,%eax
 649:	0f 84 99 00 00 00    	je     6e8 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 64f:	83 f8 63             	cmp    $0x63,%eax
 652:	0f 84 08 01 00 00    	je     760 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 658:	83 f8 25             	cmp    $0x25,%eax
 65b:	0f 84 ef 00 00 00    	je     750 <printf+0x180>
	write(fd, &c, 1);
 661:	8d 45 e7             	lea    -0x19(%ebp),%eax
 664:	83 ec 04             	sub    $0x4,%esp
 667:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 66b:	6a 01                	push   $0x1
 66d:	50                   	push   %eax
 66e:	ff 75 08             	pushl  0x8(%ebp)
 671:	e8 fc fd ff ff       	call   472 <write>
 676:	83 c4 0c             	add    $0xc,%esp
 679:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 67c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 67f:	6a 01                	push   $0x1
 681:	50                   	push   %eax
 682:	ff 75 08             	pushl  0x8(%ebp)
 685:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 688:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 68a:	e8 e3 fd ff ff       	call   472 <write>
	for (i = 0; fmt[i]; i++) {
 68f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 693:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 696:	84 db                	test   %bl,%bl
 698:	75 89                	jne    623 <printf+0x53>
		}
	}
}
 69a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret    
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 6a8:	bf 25 00 00 00       	mov    $0x25,%edi
 6ad:	e9 66 ff ff ff       	jmp    618 <printf+0x48>
 6b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 6b8:	83 ec 0c             	sub    $0xc,%esp
 6bb:	b9 10 00 00 00       	mov    $0x10,%ecx
 6c0:	6a 00                	push   $0x0
 6c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	8b 17                	mov    (%edi),%edx
 6ca:	e8 61 fe ff ff       	call   530 <printint>
				ap++;
 6cf:	89 f8                	mov    %edi,%eax
 6d1:	83 c4 10             	add    $0x10,%esp
			state = 0;
 6d4:	31 ff                	xor    %edi,%edi
				ap++;
 6d6:	83 c0 04             	add    $0x4,%eax
 6d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6dc:	e9 37 ff ff ff       	jmp    618 <printf+0x48>
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 6e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6eb:	8b 08                	mov    (%eax),%ecx
				ap++;
 6ed:	83 c0 04             	add    $0x4,%eax
 6f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 6f3:	85 c9                	test   %ecx,%ecx
 6f5:	0f 84 8e 00 00 00    	je     789 <printf+0x1b9>
				while (*s != 0) {
 6fb:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 6fe:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 700:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 702:	84 c0                	test   %al,%al
 704:	0f 84 0e ff ff ff    	je     618 <printf+0x48>
 70a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 70d:	89 de                	mov    %ebx,%esi
 70f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 712:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 715:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 718:	83 ec 04             	sub    $0x4,%esp
					s++;
 71b:	83 c6 01             	add    $0x1,%esi
 71e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 721:	6a 01                	push   $0x1
 723:	57                   	push   %edi
 724:	53                   	push   %ebx
 725:	e8 48 fd ff ff       	call   472 <write>
				while (*s != 0) {
 72a:	0f b6 06             	movzbl (%esi),%eax
 72d:	83 c4 10             	add    $0x10,%esp
 730:	84 c0                	test   %al,%al
 732:	75 e4                	jne    718 <printf+0x148>
 734:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 737:	31 ff                	xor    %edi,%edi
 739:	e9 da fe ff ff       	jmp    618 <printf+0x48>
 73e:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 740:	83 ec 0c             	sub    $0xc,%esp
 743:	b9 0a 00 00 00       	mov    $0xa,%ecx
 748:	6a 01                	push   $0x1
 74a:	e9 73 ff ff ff       	jmp    6c2 <printf+0xf2>
 74f:	90                   	nop
	write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 756:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 759:	6a 01                	push   $0x1
 75b:	e9 21 ff ff ff       	jmp    681 <printf+0xb1>
				putc(fd, *ap);
 760:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 763:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 766:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 768:	6a 01                	push   $0x1
				ap++;
 76a:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 76d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 770:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 773:	50                   	push   %eax
 774:	ff 75 08             	pushl  0x8(%ebp)
 777:	e8 f6 fc ff ff       	call   472 <write>
				ap++;
 77c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 77f:	83 c4 10             	add    $0x10,%esp
			state = 0;
 782:	31 ff                	xor    %edi,%edi
 784:	e9 8f fe ff ff       	jmp    618 <printf+0x48>
				if (s == 0) s = "(null)";
 789:	bb 82 09 00 00       	mov    $0x982,%ebx
				while (*s != 0) {
 78e:	b8 28 00 00 00       	mov    $0x28,%eax
 793:	e9 72 ff ff ff       	jmp    70a <printf+0x13a>
 798:	66 90                	xchg   %ax,%ax
 79a:	66 90                	xchg   %ax,%ax
 79c:	66 90                	xchg   %ax,%ax
 79e:	66 90                	xchg   %ax,%ax

000007a0 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 7a0:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a1:	a1 f8 0c 00 00       	mov    0xcf8,%eax
{
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	57                   	push   %edi
 7a9:	56                   	push   %esi
 7aa:	53                   	push   %ebx
 7ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 7ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	39 c8                	cmp    %ecx,%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	73 32                	jae    7f0 <free+0x50>
 7be:	39 d1                	cmp    %edx,%ecx
 7c0:	72 04                	jb     7c6 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7c2:	39 d0                	cmp    %edx,%eax
 7c4:	72 32                	jb     7f8 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 7c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7cc:	39 fa                	cmp    %edi,%edx
 7ce:	74 30                	je     800 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 7d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 7d3:	8b 50 04             	mov    0x4(%eax),%edx
 7d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7d9:	39 f1                	cmp    %esi,%ecx
 7db:	74 3a                	je     817 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 7dd:	89 08                	mov    %ecx,(%eax)
	freep = p;
 7df:	a3 f8 0c 00 00       	mov    %eax,0xcf8
}
 7e4:	5b                   	pop    %ebx
 7e5:	5e                   	pop    %esi
 7e6:	5f                   	pop    %edi
 7e7:	5d                   	pop    %ebp
 7e8:	c3                   	ret    
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 7f0:	39 d0                	cmp    %edx,%eax
 7f2:	72 04                	jb     7f8 <free+0x58>
 7f4:	39 d1                	cmp    %edx,%ecx
 7f6:	72 ce                	jb     7c6 <free+0x26>
{
 7f8:	89 d0                	mov    %edx,%eax
 7fa:	eb bc                	jmp    7b8 <free+0x18>
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 800:	03 72 04             	add    0x4(%edx),%esi
 803:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 806:	8b 10                	mov    (%eax),%edx
 808:	8b 12                	mov    (%edx),%edx
 80a:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 80d:	8b 50 04             	mov    0x4(%eax),%edx
 810:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 813:	39 f1                	cmp    %esi,%ecx
 815:	75 c6                	jne    7dd <free+0x3d>
		p->s.size += bp->s.size;
 817:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 81a:	a3 f8 0c 00 00       	mov    %eax,0xcf8
		p->s.size += bp->s.size;
 81f:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 822:	8b 53 f8             	mov    -0x8(%ebx),%edx
 825:	89 10                	mov    %edx,(%eax)
}
 827:	5b                   	pop    %ebx
 828:	5e                   	pop    %esi
 829:	5f                   	pop    %edi
 82a:	5d                   	pop    %ebp
 82b:	c3                   	ret    
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000830 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 839:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 83c:	8b 15 f8 0c 00 00    	mov    0xcf8,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 842:	8d 78 07             	lea    0x7(%eax),%edi
 845:	c1 ef 03             	shr    $0x3,%edi
 848:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 84b:	85 d2                	test   %edx,%edx
 84d:	0f 84 9d 00 00 00    	je     8f0 <malloc+0xc0>
 853:	8b 02                	mov    (%edx),%eax
 855:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 858:	39 cf                	cmp    %ecx,%edi
 85a:	76 6c                	jbe    8c8 <malloc+0x98>
 85c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 862:	bb 00 10 00 00       	mov    $0x1000,%ebx
 867:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 86a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 871:	eb 0e                	jmp    881 <malloc+0x51>
 873:	90                   	nop
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 878:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 87a:	8b 48 04             	mov    0x4(%eax),%ecx
 87d:	39 f9                	cmp    %edi,%ecx
 87f:	73 47                	jae    8c8 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 881:	39 05 f8 0c 00 00    	cmp    %eax,0xcf8
 887:	89 c2                	mov    %eax,%edx
 889:	75 ed                	jne    878 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 88b:	83 ec 0c             	sub    $0xc,%esp
 88e:	56                   	push   %esi
 88f:	e8 46 fc ff ff       	call   4da <sbrk>
	if (p == (char *)-1) return 0;
 894:	83 c4 10             	add    $0x10,%esp
 897:	83 f8 ff             	cmp    $0xffffffff,%eax
 89a:	74 1c                	je     8b8 <malloc+0x88>
	hp->s.size = nu;
 89c:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 89f:	83 ec 0c             	sub    $0xc,%esp
 8a2:	83 c0 08             	add    $0x8,%eax
 8a5:	50                   	push   %eax
 8a6:	e8 f5 fe ff ff       	call   7a0 <free>
	return freep;
 8ab:	8b 15 f8 0c 00 00    	mov    0xcf8,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 8b1:	83 c4 10             	add    $0x10,%esp
 8b4:	85 d2                	test   %edx,%edx
 8b6:	75 c0                	jne    878 <malloc+0x48>
	}
}
 8b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 8bb:	31 c0                	xor    %eax,%eax
}
 8bd:	5b                   	pop    %ebx
 8be:	5e                   	pop    %esi
 8bf:	5f                   	pop    %edi
 8c0:	5d                   	pop    %ebp
 8c1:	c3                   	ret    
 8c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 8c8:	39 cf                	cmp    %ecx,%edi
 8ca:	74 54                	je     920 <malloc+0xf0>
				p->s.size -= nunits;
 8cc:	29 f9                	sub    %edi,%ecx
 8ce:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 8d1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 8d4:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 8d7:	89 15 f8 0c 00 00    	mov    %edx,0xcf8
}
 8dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 8e0:	83 c0 08             	add    $0x8,%eax
}
 8e3:	5b                   	pop    %ebx
 8e4:	5e                   	pop    %esi
 8e5:	5f                   	pop    %edi
 8e6:	5d                   	pop    %ebp
 8e7:	c3                   	ret    
 8e8:	90                   	nop
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 8f0:	c7 05 f8 0c 00 00 fc 	movl   $0xcfc,0xcf8
 8f7:	0c 00 00 
 8fa:	c7 05 fc 0c 00 00 fc 	movl   $0xcfc,0xcfc
 901:	0c 00 00 
		base.s.size                = 0;
 904:	b8 fc 0c 00 00       	mov    $0xcfc,%eax
 909:	c7 05 00 0d 00 00 00 	movl   $0x0,0xd00
 910:	00 00 00 
 913:	e9 44 ff ff ff       	jmp    85c <malloc+0x2c>
 918:	90                   	nop
 919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 920:	8b 08                	mov    (%eax),%ecx
 922:	89 0a                	mov    %ecx,(%edx)
 924:	eb b1                	jmp    8d7 <malloc+0xa7>
