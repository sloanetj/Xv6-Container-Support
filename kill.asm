
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
	int i;

	if (argc < 2) {
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 2c                	jle    49 <main+0x49>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		printf(2, "usage: kill pid...\n");
		exit();
	}
	for (i = 1; i < argc; i++) kill(atoi(argv[i]));
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 0b 02 00 00       	call   240 <atoi>
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 c4 02 00 00       	call   301 <kill>
  3d:	83 c4 10             	add    $0x10,%esp
  40:	39 f3                	cmp    %esi,%ebx
  42:	75 e4                	jne    28 <main+0x28>
	exit();
  44:	e8 88 02 00 00       	call   2d1 <exit>
		printf(2, "usage: kill pid...\n");
  49:	50                   	push   %eax
  4a:	50                   	push   %eax
  4b:	68 c8 07 00 00       	push   $0x7c8
  50:	6a 02                	push   $0x2
  52:	e8 19 04 00 00       	call   470 <printf>
		exit();
  57:	e8 75 02 00 00       	call   2d1 <exit>
  5c:	66 90                	xchg   %ax,%ax
  5e:	66 90                	xchg   %ax,%ax

00000060 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	53                   	push   %ebx
  64:	8b 45 08             	mov    0x8(%ebp),%eax
  67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
  6a:	89 c2                	mov    %eax,%edx
  6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  70:	83 c1 01             	add    $0x1,%ecx
  73:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  77:	83 c2 01             	add    $0x1,%edx
  7a:	84 db                	test   %bl,%bl
  7c:	88 5a ff             	mov    %bl,-0x1(%edx)
  7f:	75 ef                	jne    70 <strcpy+0x10>
		;
	return os;
}
  81:	5b                   	pop    %ebx
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    
  84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
  9a:	0f b6 02             	movzbl (%edx),%eax
  9d:	0f b6 19             	movzbl (%ecx),%ebx
  a0:	84 c0                	test   %al,%al
  a2:	75 1c                	jne    c0 <strcmp+0x30>
  a4:	eb 2a                	jmp    d0 <strcmp+0x40>
  a6:	8d 76 00             	lea    0x0(%esi),%esi
  a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  b0:	83 c2 01             	add    $0x1,%edx
  b3:	0f b6 02             	movzbl (%edx),%eax
  b6:	83 c1 01             	add    $0x1,%ecx
  b9:	0f b6 19             	movzbl (%ecx),%ebx
  bc:	84 c0                	test   %al,%al
  be:	74 10                	je     d0 <strcmp+0x40>
  c0:	38 d8                	cmp    %bl,%al
  c2:	74 ec                	je     b0 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
  c4:	29 d8                	sub    %ebx,%eax
}
  c6:	5b                   	pop    %ebx
  c7:	5d                   	pop    %ebp
  c8:	c3                   	ret    
  c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d0:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
  d2:	29 d8                	sub    %ebx,%eax
}
  d4:	5b                   	pop    %ebx
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strlen>:

uint
strlen(char *s)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
  e6:	80 39 00             	cmpb   $0x0,(%ecx)
  e9:	74 15                	je     100 <strlen+0x20>
  eb:	31 d2                	xor    %edx,%edx
  ed:	8d 76 00             	lea    0x0(%esi),%esi
  f0:	83 c2 01             	add    $0x1,%edx
  f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  f7:	89 d0                	mov    %edx,%eax
  f9:	75 f5                	jne    f0 <strlen+0x10>
		;
	return n;
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    
  fd:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 100:	31 c0                	xor    %eax,%eax
}
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    
 104:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 10a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000110 <memset>:

void *
memset(void *dst, int c, uint n)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 117:	8b 4d 10             	mov    0x10(%ebp),%ecx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 d7                	mov    %edx,%edi
 11f:	fc                   	cld    
 120:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 122:	89 d0                	mov    %edx,%eax
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    
 127:	89 f6                	mov    %esi,%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <strchr>:

char *
strchr(const char *s, char c)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	53                   	push   %ebx
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 13a:	0f b6 10             	movzbl (%eax),%edx
 13d:	84 d2                	test   %dl,%dl
 13f:	74 1d                	je     15e <strchr+0x2e>
		if (*s == c) return (char *)s;
 141:	38 d3                	cmp    %dl,%bl
 143:	89 d9                	mov    %ebx,%ecx
 145:	75 0d                	jne    154 <strchr+0x24>
 147:	eb 17                	jmp    160 <strchr+0x30>
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 150:	38 ca                	cmp    %cl,%dl
 152:	74 0c                	je     160 <strchr+0x30>
	for (; *s; s++)
 154:	83 c0 01             	add    $0x1,%eax
 157:	0f b6 10             	movzbl (%eax),%edx
 15a:	84 d2                	test   %dl,%dl
 15c:	75 f2                	jne    150 <strchr+0x20>
	return 0;
 15e:	31 c0                	xor    %eax,%eax
}
 160:	5b                   	pop    %ebx
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    
 163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <gets>:

char *
gets(char *buf, int max)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 176:	31 f6                	xor    %esi,%esi
 178:	89 f3                	mov    %esi,%ebx
{
 17a:	83 ec 1c             	sub    $0x1c,%esp
 17d:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 180:	eb 2f                	jmp    1b1 <gets+0x41>
 182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 188:	8d 45 e7             	lea    -0x19(%ebp),%eax
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	50                   	push   %eax
 191:	6a 00                	push   $0x0
 193:	e8 51 01 00 00       	call   2e9 <read>
		if (cc < 1) break;
 198:	83 c4 10             	add    $0x10,%esp
 19b:	85 c0                	test   %eax,%eax
 19d:	7e 1c                	jle    1bb <gets+0x4b>
		buf[i++] = c;
 19f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1a3:	83 c7 01             	add    $0x1,%edi
 1a6:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 1a9:	3c 0a                	cmp    $0xa,%al
 1ab:	74 23                	je     1d0 <gets+0x60>
 1ad:	3c 0d                	cmp    $0xd,%al
 1af:	74 1f                	je     1d0 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 1b1:	83 c3 01             	add    $0x1,%ebx
 1b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b7:	89 fe                	mov    %edi,%esi
 1b9:	7c cd                	jl     188 <gets+0x18>
 1bb:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 1bd:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 1c0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5f                   	pop    %edi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    
 1cb:	90                   	nop
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1d0:	8b 75 08             	mov    0x8(%ebp),%esi
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	01 de                	add    %ebx,%esi
 1d8:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 1da:	c6 03 00             	movb   $0x0,(%ebx)
}
 1dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1e0:	5b                   	pop    %ebx
 1e1:	5e                   	pop    %esi
 1e2:	5f                   	pop    %edi
 1e3:	5d                   	pop    %ebp
 1e4:	c3                   	ret    
 1e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <stat>:

int
stat(char *n, struct stat *st)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	56                   	push   %esi
 1f4:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 1f5:	83 ec 08             	sub    $0x8,%esp
 1f8:	6a 00                	push   $0x0
 1fa:	ff 75 08             	pushl  0x8(%ebp)
 1fd:	e8 0f 01 00 00       	call   311 <open>
	if (fd < 0) return -1;
 202:	83 c4 10             	add    $0x10,%esp
 205:	85 c0                	test   %eax,%eax
 207:	78 27                	js     230 <stat+0x40>
	r = fstat(fd, st);
 209:	83 ec 08             	sub    $0x8,%esp
 20c:	ff 75 0c             	pushl  0xc(%ebp)
 20f:	89 c3                	mov    %eax,%ebx
 211:	50                   	push   %eax
 212:	e8 12 01 00 00       	call   329 <fstat>
	close(fd);
 217:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 21a:	89 c6                	mov    %eax,%esi
	close(fd);
 21c:	e8 d8 00 00 00       	call   2f9 <close>
	return r;
 221:	83 c4 10             	add    $0x10,%esp
}
 224:	8d 65 f8             	lea    -0x8(%ebp),%esp
 227:	89 f0                	mov    %esi,%eax
 229:	5b                   	pop    %ebx
 22a:	5e                   	pop    %esi
 22b:	5d                   	pop    %ebp
 22c:	c3                   	ret    
 22d:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 230:	be ff ff ff ff       	mov    $0xffffffff,%esi
 235:	eb ed                	jmp    224 <stat+0x34>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000240 <atoi>:

int
atoi(const char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 247:	0f be 11             	movsbl (%ecx),%edx
 24a:	8d 42 d0             	lea    -0x30(%edx),%eax
 24d:	3c 09                	cmp    $0x9,%al
	n = 0;
 24f:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 254:	77 1f                	ja     275 <atoi+0x35>
 256:	8d 76 00             	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 260:	8d 04 80             	lea    (%eax,%eax,4),%eax
 263:	83 c1 01             	add    $0x1,%ecx
 266:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 26a:	0f be 11             	movsbl (%ecx),%edx
 26d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 270:	80 fb 09             	cmp    $0x9,%bl
 273:	76 eb                	jbe    260 <atoi+0x20>
	return n;
}
 275:	5b                   	pop    %ebx
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    
 278:	90                   	nop
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	8b 5d 10             	mov    0x10(%ebp),%ebx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 28e:	85 db                	test   %ebx,%ebx
 290:	7e 14                	jle    2a6 <memmove+0x26>
 292:	31 d2                	xor    %edx,%edx
 294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 298:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 29c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 29f:	83 c2 01             	add    $0x1,%edx
 2a2:	39 d3                	cmp    %edx,%ebx
 2a4:	75 f2                	jne    298 <memmove+0x18>
	return vdst;
}
 2a6:	5b                   	pop    %ebx
 2a7:	5e                   	pop    %esi
 2a8:	5d                   	pop    %ebp
 2a9:	c3                   	ret    
 2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002b0 <shm_get>:

char*
shm_get(char* name)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
	return shmget(name);
}
 2b3:	5d                   	pop    %ebp
	return shmget(name);
 2b4:	e9 00 01 00 00       	jmp    3b9 <shmget>
 2b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002c0 <shm_rem>:

int
shm_rem(char* name)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
	return shmrem(name);
}
 2c3:	5d                   	pop    %ebp
	return shmrem(name);
 2c4:	e9 f8 00 00 00       	jmp    3c1 <shmrem>

000002c9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <exit>:
SYSCALL(exit)
 2d1:	b8 02 00 00 00       	mov    $0x2,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <wait>:
SYSCALL(wait)
 2d9:	b8 03 00 00 00       	mov    $0x3,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <pipe>:
SYSCALL(pipe)
 2e1:	b8 04 00 00 00       	mov    $0x4,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <read>:
SYSCALL(read)
 2e9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <write>:
SYSCALL(write)
 2f1:	b8 10 00 00 00       	mov    $0x10,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <close>:
SYSCALL(close)
 2f9:	b8 15 00 00 00       	mov    $0x15,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <kill>:
SYSCALL(kill)
 301:	b8 06 00 00 00       	mov    $0x6,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <exec>:
SYSCALL(exec)
 309:	b8 07 00 00 00       	mov    $0x7,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <open>:
SYSCALL(open)
 311:	b8 0f 00 00 00       	mov    $0xf,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <mknod>:
SYSCALL(mknod)
 319:	b8 11 00 00 00       	mov    $0x11,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <unlink>:
SYSCALL(unlink)
 321:	b8 12 00 00 00       	mov    $0x12,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <fstat>:
SYSCALL(fstat)
 329:	b8 08 00 00 00       	mov    $0x8,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <link>:
SYSCALL(link)
 331:	b8 13 00 00 00       	mov    $0x13,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <mkdir>:
SYSCALL(mkdir)
 339:	b8 14 00 00 00       	mov    $0x14,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <chdir>:
SYSCALL(chdir)
 341:	b8 09 00 00 00       	mov    $0x9,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <dup>:
SYSCALL(dup)
 349:	b8 0a 00 00 00       	mov    $0xa,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <getpid>:
SYSCALL(getpid)
 351:	b8 0b 00 00 00       	mov    $0xb,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sbrk>:
SYSCALL(sbrk)
 359:	b8 0c 00 00 00       	mov    $0xc,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <sleep>:
SYSCALL(sleep)
 361:	b8 0d 00 00 00       	mov    $0xd,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <uptime>:
SYSCALL(uptime)
 369:	b8 0e 00 00 00       	mov    $0xe,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <mcreate>:
SYSCALL(mcreate)
 371:	b8 16 00 00 00       	mov    $0x16,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <mdelete>:
SYSCALL(mdelete)
 379:	b8 17 00 00 00       	mov    $0x17,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <mlock>:
SYSCALL(mlock)
 381:	b8 18 00 00 00       	mov    $0x18,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <munlock>:
SYSCALL(munlock)
 389:	b8 19 00 00 00       	mov    $0x19,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <waitcv>:
SYSCALL(waitcv)
 391:	b8 1a 00 00 00       	mov    $0x1a,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <signalcv>:
SYSCALL(signalcv)
 399:	b8 1b 00 00 00       	mov    $0x1b,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <prio_set>:
SYSCALL(prio_set)
 3a1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <testpqeq>:
SYSCALL(testpqeq)
 3a9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <testpqdq>:
SYSCALL(testpqdq)
 3b1:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <shmget>:
SYSCALL(shmget)
 3b9:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <shmrem>:
 3c1:	b8 20 00 00 00       	mov    $0x20,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    
 3c9:	66 90                	xchg   %ax,%ax
 3cb:	66 90                	xchg   %ax,%ax
 3cd:	66 90                	xchg   %ax,%ax
 3cf:	90                   	nop

000003d0 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 3d9:	85 d2                	test   %edx,%edx
{
 3db:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 3de:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 3e0:	79 76                	jns    458 <printint+0x88>
 3e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3e6:	74 70                	je     458 <printint+0x88>
		x   = -xx;
 3e8:	f7 d8                	neg    %eax
		neg = 1;
 3ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 3f1:	31 f6                	xor    %esi,%esi
 3f3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3f6:	eb 0a                	jmp    402 <printint+0x32>
 3f8:	90                   	nop
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 400:	89 fe                	mov    %edi,%esi
 402:	31 d2                	xor    %edx,%edx
 404:	8d 7e 01             	lea    0x1(%esi),%edi
 407:	f7 f1                	div    %ecx
 409:	0f b6 92 e4 07 00 00 	movzbl 0x7e4(%edx),%edx
	} while ((x /= base) != 0);
 410:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 412:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 415:	75 e9                	jne    400 <printint+0x30>
	if (neg) buf[i++] = '-';
 417:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 41a:	85 c0                	test   %eax,%eax
 41c:	74 08                	je     426 <printint+0x56>
 41e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 423:	8d 7e 02             	lea    0x2(%esi),%edi
 426:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 42a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 42d:	8d 76 00             	lea    0x0(%esi),%esi
 430:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 433:	83 ec 04             	sub    $0x4,%esp
 436:	83 ee 01             	sub    $0x1,%esi
 439:	6a 01                	push   $0x1
 43b:	53                   	push   %ebx
 43c:	57                   	push   %edi
 43d:	88 45 d7             	mov    %al,-0x29(%ebp)
 440:	e8 ac fe ff ff       	call   2f1 <write>

	while (--i >= 0) putc(fd, buf[i]);
 445:	83 c4 10             	add    $0x10,%esp
 448:	39 de                	cmp    %ebx,%esi
 44a:	75 e4                	jne    430 <printint+0x60>
}
 44c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44f:	5b                   	pop    %ebx
 450:	5e                   	pop    %esi
 451:	5f                   	pop    %edi
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
 454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 458:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 45f:	eb 90                	jmp    3f1 <printint+0x21>
 461:	eb 0d                	jmp    470 <printf>
 463:	90                   	nop
 464:	90                   	nop
 465:	90                   	nop
 466:	90                   	nop
 467:	90                   	nop
 468:	90                   	nop
 469:	90                   	nop
 46a:	90                   	nop
 46b:	90                   	nop
 46c:	90                   	nop
 46d:	90                   	nop
 46e:	90                   	nop
 46f:	90                   	nop

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	57                   	push   %edi
 474:	56                   	push   %esi
 475:	53                   	push   %ebx
 476:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 479:	8b 75 0c             	mov    0xc(%ebp),%esi
 47c:	0f b6 1e             	movzbl (%esi),%ebx
 47f:	84 db                	test   %bl,%bl
 481:	0f 84 b3 00 00 00    	je     53a <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 487:	8d 45 10             	lea    0x10(%ebp),%eax
 48a:	83 c6 01             	add    $0x1,%esi
	state = 0;
 48d:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 48f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 492:	eb 2f                	jmp    4c3 <printf+0x53>
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 498:	83 f8 25             	cmp    $0x25,%eax
 49b:	0f 84 a7 00 00 00    	je     548 <printf+0xd8>
	write(fd, &c, 1);
 4a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4a4:	83 ec 04             	sub    $0x4,%esp
 4a7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4aa:	6a 01                	push   $0x1
 4ac:	50                   	push   %eax
 4ad:	ff 75 08             	pushl  0x8(%ebp)
 4b0:	e8 3c fe ff ff       	call   2f1 <write>
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 4bb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4bf:	84 db                	test   %bl,%bl
 4c1:	74 77                	je     53a <printf+0xca>
		if (state == 0) {
 4c3:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 4c5:	0f be cb             	movsbl %bl,%ecx
 4c8:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 4cb:	74 cb                	je     498 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 4cd:	83 ff 25             	cmp    $0x25,%edi
 4d0:	75 e6                	jne    4b8 <printf+0x48>
			if (c == 'd') {
 4d2:	83 f8 64             	cmp    $0x64,%eax
 4d5:	0f 84 05 01 00 00    	je     5e0 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 4db:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4e1:	83 f9 70             	cmp    $0x70,%ecx
 4e4:	74 72                	je     558 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 4e6:	83 f8 73             	cmp    $0x73,%eax
 4e9:	0f 84 99 00 00 00    	je     588 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 4ef:	83 f8 63             	cmp    $0x63,%eax
 4f2:	0f 84 08 01 00 00    	je     600 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 4f8:	83 f8 25             	cmp    $0x25,%eax
 4fb:	0f 84 ef 00 00 00    	je     5f0 <printf+0x180>
	write(fd, &c, 1);
 501:	8d 45 e7             	lea    -0x19(%ebp),%eax
 504:	83 ec 04             	sub    $0x4,%esp
 507:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 50b:	6a 01                	push   $0x1
 50d:	50                   	push   %eax
 50e:	ff 75 08             	pushl  0x8(%ebp)
 511:	e8 db fd ff ff       	call   2f1 <write>
 516:	83 c4 0c             	add    $0xc,%esp
 519:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 51c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 51f:	6a 01                	push   $0x1
 521:	50                   	push   %eax
 522:	ff 75 08             	pushl  0x8(%ebp)
 525:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 528:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 52a:	e8 c2 fd ff ff       	call   2f1 <write>
	for (i = 0; fmt[i]; i++) {
 52f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 533:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 536:	84 db                	test   %bl,%bl
 538:	75 89                	jne    4c3 <printf+0x53>
		}
	}
}
 53a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53d:	5b                   	pop    %ebx
 53e:	5e                   	pop    %esi
 53f:	5f                   	pop    %edi
 540:	5d                   	pop    %ebp
 541:	c3                   	ret    
 542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 548:	bf 25 00 00 00       	mov    $0x25,%edi
 54d:	e9 66 ff ff ff       	jmp    4b8 <printf+0x48>
 552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 558:	83 ec 0c             	sub    $0xc,%esp
 55b:	b9 10 00 00 00       	mov    $0x10,%ecx
 560:	6a 00                	push   $0x0
 562:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	8b 17                	mov    (%edi),%edx
 56a:	e8 61 fe ff ff       	call   3d0 <printint>
				ap++;
 56f:	89 f8                	mov    %edi,%eax
 571:	83 c4 10             	add    $0x10,%esp
			state = 0;
 574:	31 ff                	xor    %edi,%edi
				ap++;
 576:	83 c0 04             	add    $0x4,%eax
 579:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 57c:	e9 37 ff ff ff       	jmp    4b8 <printf+0x48>
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 58b:	8b 08                	mov    (%eax),%ecx
				ap++;
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 593:	85 c9                	test   %ecx,%ecx
 595:	0f 84 8e 00 00 00    	je     629 <printf+0x1b9>
				while (*s != 0) {
 59b:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 59e:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 5a0:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 5a2:	84 c0                	test   %al,%al
 5a4:	0f 84 0e ff ff ff    	je     4b8 <printf+0x48>
 5aa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5ad:	89 de                	mov    %ebx,%esi
 5af:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5b2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5b5:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 5b8:	83 ec 04             	sub    $0x4,%esp
					s++;
 5bb:	83 c6 01             	add    $0x1,%esi
 5be:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 5c1:	6a 01                	push   $0x1
 5c3:	57                   	push   %edi
 5c4:	53                   	push   %ebx
 5c5:	e8 27 fd ff ff       	call   2f1 <write>
				while (*s != 0) {
 5ca:	0f b6 06             	movzbl (%esi),%eax
 5cd:	83 c4 10             	add    $0x10,%esp
 5d0:	84 c0                	test   %al,%al
 5d2:	75 e4                	jne    5b8 <printf+0x148>
 5d4:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 5d7:	31 ff                	xor    %edi,%edi
 5d9:	e9 da fe ff ff       	jmp    4b8 <printf+0x48>
 5de:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	e9 73 ff ff ff       	jmp    562 <printf+0xf2>
 5ef:	90                   	nop
	write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
 5f3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5f6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5f9:	6a 01                	push   $0x1
 5fb:	e9 21 ff ff ff       	jmp    521 <printf+0xb1>
				putc(fd, *ap);
 600:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 606:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 608:	6a 01                	push   $0x1
				ap++;
 60a:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 60d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 610:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 613:	50                   	push   %eax
 614:	ff 75 08             	pushl  0x8(%ebp)
 617:	e8 d5 fc ff ff       	call   2f1 <write>
				ap++;
 61c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 61f:	83 c4 10             	add    $0x10,%esp
			state = 0;
 622:	31 ff                	xor    %edi,%edi
 624:	e9 8f fe ff ff       	jmp    4b8 <printf+0x48>
				if (s == 0) s = "(null)";
 629:	bb dc 07 00 00       	mov    $0x7dc,%ebx
				while (*s != 0) {
 62e:	b8 28 00 00 00       	mov    $0x28,%eax
 633:	e9 72 ff ff ff       	jmp    5aa <printf+0x13a>
 638:	66 90                	xchg   %ax,%ax
 63a:	66 90                	xchg   %ax,%ax
 63c:	66 90                	xchg   %ax,%ax
 63e:	66 90                	xchg   %ax,%ax

00000640 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 d0 0a 00 00       	mov    0xad0,%eax
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 64e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 658:	39 c8                	cmp    %ecx,%eax
 65a:	8b 10                	mov    (%eax),%edx
 65c:	73 32                	jae    690 <free+0x50>
 65e:	39 d1                	cmp    %edx,%ecx
 660:	72 04                	jb     666 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 662:	39 d0                	cmp    %edx,%eax
 664:	72 32                	jb     698 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 666:	8b 73 fc             	mov    -0x4(%ebx),%esi
 669:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 66c:	39 fa                	cmp    %edi,%edx
 66e:	74 30                	je     6a0 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 670:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 673:	8b 50 04             	mov    0x4(%eax),%edx
 676:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 679:	39 f1                	cmp    %esi,%ecx
 67b:	74 3a                	je     6b7 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 67d:	89 08                	mov    %ecx,(%eax)
	freep = p;
 67f:	a3 d0 0a 00 00       	mov    %eax,0xad0
}
 684:	5b                   	pop    %ebx
 685:	5e                   	pop    %esi
 686:	5f                   	pop    %edi
 687:	5d                   	pop    %ebp
 688:	c3                   	ret    
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 690:	39 d0                	cmp    %edx,%eax
 692:	72 04                	jb     698 <free+0x58>
 694:	39 d1                	cmp    %edx,%ecx
 696:	72 ce                	jb     666 <free+0x26>
{
 698:	89 d0                	mov    %edx,%eax
 69a:	eb bc                	jmp    658 <free+0x18>
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 6a0:	03 72 04             	add    0x4(%edx),%esi
 6a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 12                	mov    (%edx),%edx
 6aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 6ad:	8b 50 04             	mov    0x4(%eax),%edx
 6b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6b3:	39 f1                	cmp    %esi,%ecx
 6b5:	75 c6                	jne    67d <free+0x3d>
		p->s.size += bp->s.size;
 6b7:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 6ba:	a3 d0 0a 00 00       	mov    %eax,0xad0
		p->s.size += bp->s.size;
 6bf:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 6c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6c5:	89 10                	mov    %edx,(%eax)
}
 6c7:	5b                   	pop    %ebx
 6c8:	5e                   	pop    %esi
 6c9:	5f                   	pop    %edi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006d0 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 6dc:	8b 15 d0 0a 00 00    	mov    0xad0,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 6e2:	8d 78 07             	lea    0x7(%eax),%edi
 6e5:	c1 ef 03             	shr    $0x3,%edi
 6e8:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 6eb:	85 d2                	test   %edx,%edx
 6ed:	0f 84 9d 00 00 00    	je     790 <malloc+0xc0>
 6f3:	8b 02                	mov    (%edx),%eax
 6f5:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 6f8:	39 cf                	cmp    %ecx,%edi
 6fa:	76 6c                	jbe    768 <malloc+0x98>
 6fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 702:	bb 00 10 00 00       	mov    $0x1000,%ebx
 707:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 70a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 711:	eb 0e                	jmp    721 <malloc+0x51>
 713:	90                   	nop
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 718:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 71a:	8b 48 04             	mov    0x4(%eax),%ecx
 71d:	39 f9                	cmp    %edi,%ecx
 71f:	73 47                	jae    768 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 721:	39 05 d0 0a 00 00    	cmp    %eax,0xad0
 727:	89 c2                	mov    %eax,%edx
 729:	75 ed                	jne    718 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 72b:	83 ec 0c             	sub    $0xc,%esp
 72e:	56                   	push   %esi
 72f:	e8 25 fc ff ff       	call   359 <sbrk>
	if (p == (char *)-1) return 0;
 734:	83 c4 10             	add    $0x10,%esp
 737:	83 f8 ff             	cmp    $0xffffffff,%eax
 73a:	74 1c                	je     758 <malloc+0x88>
	hp->s.size = nu;
 73c:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 73f:	83 ec 0c             	sub    $0xc,%esp
 742:	83 c0 08             	add    $0x8,%eax
 745:	50                   	push   %eax
 746:	e8 f5 fe ff ff       	call   640 <free>
	return freep;
 74b:	8b 15 d0 0a 00 00    	mov    0xad0,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 751:	83 c4 10             	add    $0x10,%esp
 754:	85 d2                	test   %edx,%edx
 756:	75 c0                	jne    718 <malloc+0x48>
	}
}
 758:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 75b:	31 c0                	xor    %eax,%eax
}
 75d:	5b                   	pop    %ebx
 75e:	5e                   	pop    %esi
 75f:	5f                   	pop    %edi
 760:	5d                   	pop    %ebp
 761:	c3                   	ret    
 762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 768:	39 cf                	cmp    %ecx,%edi
 76a:	74 54                	je     7c0 <malloc+0xf0>
				p->s.size -= nunits;
 76c:	29 f9                	sub    %edi,%ecx
 76e:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 771:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 774:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 777:	89 15 d0 0a 00 00    	mov    %edx,0xad0
}
 77d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 780:	83 c0 08             	add    $0x8,%eax
}
 783:	5b                   	pop    %ebx
 784:	5e                   	pop    %esi
 785:	5f                   	pop    %edi
 786:	5d                   	pop    %ebp
 787:	c3                   	ret    
 788:	90                   	nop
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 790:	c7 05 d0 0a 00 00 d4 	movl   $0xad4,0xad0
 797:	0a 00 00 
 79a:	c7 05 d4 0a 00 00 d4 	movl   $0xad4,0xad4
 7a1:	0a 00 00 
		base.s.size                = 0;
 7a4:	b8 d4 0a 00 00       	mov    $0xad4,%eax
 7a9:	c7 05 d8 0a 00 00 00 	movl   $0x0,0xad8
 7b0:	00 00 00 
 7b3:	e9 44 ff ff ff       	jmp    6fc <malloc+0x2c>
 7b8:	90                   	nop
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 7c0:	8b 08                	mov    (%eax),%ecx
 7c2:	89 0a                	mov    %ecx,(%edx)
 7c4:	eb b1                	jmp    777 <malloc+0xa7>
