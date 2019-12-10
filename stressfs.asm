
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
	int  fd, i;
	char path[] = "stressfs0";
   7:	b8 30 00 00 00       	mov    $0x30,%eax
{
   c:	ff 71 fc             	pushl  -0x4(%ecx)
   f:	55                   	push   %ebp
  10:	89 e5                	mov    %esp,%ebp
  12:	57                   	push   %edi
  13:	56                   	push   %esi
  14:	53                   	push   %ebx
  15:	51                   	push   %ecx
	char data[512];

	printf(1, "stressfs starting\n");
	memset(data, 'a', sizeof(data));
  16:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi

	for (i = 0; i < 4; i++)
  1c:	31 db                	xor    %ebx,%ebx
{
  1e:	81 ec 20 02 00 00    	sub    $0x220,%esp
	char path[] = "stressfs0";
  24:	66 89 85 e6 fd ff ff 	mov    %ax,-0x21a(%ebp)
  2b:	c7 85 de fd ff ff 73 	movl   $0x65727473,-0x222(%ebp)
  32:	74 72 65 
	printf(1, "stressfs starting\n");
  35:	68 a8 08 00 00       	push   $0x8a8
  3a:	6a 01                	push   $0x1
	char path[] = "stressfs0";
  3c:	c7 85 e2 fd ff ff 73 	movl   $0x73667373,-0x21e(%ebp)
  43:	73 66 73 
	printf(1, "stressfs starting\n");
  46:	e8 05 05 00 00       	call   550 <printf>
	memset(data, 'a', sizeof(data));
  4b:	83 c4 0c             	add    $0xc,%esp
  4e:	68 00 02 00 00       	push   $0x200
  53:	6a 61                	push   $0x61
  55:	56                   	push   %esi
  56:	e8 95 01 00 00       	call   1f0 <memset>
  5b:	83 c4 10             	add    $0x10,%esp
		if (fork() > 0) break;
  5e:	e8 46 03 00 00       	call   3a9 <fork>
  63:	85 c0                	test   %eax,%eax
  65:	0f 8f bf 00 00 00    	jg     12a <main+0x12a>
	for (i = 0; i < 4; i++)
  6b:	83 c3 01             	add    $0x1,%ebx
  6e:	83 fb 04             	cmp    $0x4,%ebx
  71:	75 eb                	jne    5e <main+0x5e>
  73:	bf 04 00 00 00       	mov    $0x4,%edi

	printf(1, "write %d\n", i);
  78:	83 ec 04             	sub    $0x4,%esp
  7b:	53                   	push   %ebx
  7c:	68 bb 08 00 00       	push   $0x8bb

	path[8] += i;
	fd = open(path, O_CREATE | O_RDWR);
  81:	bb 14 00 00 00       	mov    $0x14,%ebx
	printf(1, "write %d\n", i);
  86:	6a 01                	push   $0x1
  88:	e8 c3 04 00 00       	call   550 <printf>
	path[8] += i;
  8d:	89 f8                	mov    %edi,%eax
  8f:	00 85 e6 fd ff ff    	add    %al,-0x21a(%ebp)
	fd = open(path, O_CREATE | O_RDWR);
  95:	5f                   	pop    %edi
  96:	58                   	pop    %eax
  97:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  9d:	68 02 02 00 00       	push   $0x202
  a2:	50                   	push   %eax
  a3:	e8 49 03 00 00       	call   3f1 <open>
  a8:	83 c4 10             	add    $0x10,%esp
  ab:	89 c7                	mov    %eax,%edi
  ad:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < 20; i++)
		//    printf(fd, "%d\n", i);
		write(fd, data, sizeof(data));
  b0:	83 ec 04             	sub    $0x4,%esp
  b3:	68 00 02 00 00       	push   $0x200
  b8:	56                   	push   %esi
  b9:	57                   	push   %edi
  ba:	e8 12 03 00 00       	call   3d1 <write>
	for (i = 0; i < 20; i++)
  bf:	83 c4 10             	add    $0x10,%esp
  c2:	83 eb 01             	sub    $0x1,%ebx
  c5:	75 e9                	jne    b0 <main+0xb0>
	close(fd);
  c7:	83 ec 0c             	sub    $0xc,%esp
  ca:	57                   	push   %edi
  cb:	e8 09 03 00 00       	call   3d9 <close>

	printf(1, "read\n");
  d0:	58                   	pop    %eax
  d1:	5a                   	pop    %edx
  d2:	68 c5 08 00 00       	push   $0x8c5
  d7:	6a 01                	push   $0x1
  d9:	e8 72 04 00 00       	call   550 <printf>

	fd = open(path, O_RDONLY);
  de:	59                   	pop    %ecx
  df:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  e5:	5b                   	pop    %ebx
  e6:	6a 00                	push   $0x0
  e8:	50                   	push   %eax
  e9:	bb 14 00 00 00       	mov    $0x14,%ebx
  ee:	e8 fe 02 00 00       	call   3f1 <open>
  f3:	83 c4 10             	add    $0x10,%esp
  f6:	89 c7                	mov    %eax,%edi
  f8:	90                   	nop
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (i = 0; i < 20; i++) read(fd, data, sizeof(data));
 100:	83 ec 04             	sub    $0x4,%esp
 103:	68 00 02 00 00       	push   $0x200
 108:	56                   	push   %esi
 109:	57                   	push   %edi
 10a:	e8 ba 02 00 00       	call   3c9 <read>
 10f:	83 c4 10             	add    $0x10,%esp
 112:	83 eb 01             	sub    $0x1,%ebx
 115:	75 e9                	jne    100 <main+0x100>
	close(fd);
 117:	83 ec 0c             	sub    $0xc,%esp
 11a:	57                   	push   %edi
 11b:	e8 b9 02 00 00       	call   3d9 <close>

	wait();
 120:	e8 94 02 00 00       	call   3b9 <wait>

	exit();
 125:	e8 87 02 00 00       	call   3b1 <exit>
 12a:	89 df                	mov    %ebx,%edi
 12c:	e9 47 ff ff ff       	jmp    78 <main+0x78>
 131:	66 90                	xchg   %ax,%ax
 133:	66 90                	xchg   %ax,%ax
 135:	66 90                	xchg   %ax,%ax
 137:	66 90                	xchg   %ax,%ax
 139:	66 90                	xchg   %ax,%ax
 13b:	66 90                	xchg   %ax,%ax
 13d:	66 90                	xchg   %ax,%ax
 13f:	90                   	nop

00000140 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 14a:	89 c2                	mov    %eax,%edx
 14c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 150:	83 c1 01             	add    $0x1,%ecx
 153:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 157:	83 c2 01             	add    $0x1,%edx
 15a:	84 db                	test   %bl,%bl
 15c:	88 5a ff             	mov    %bl,-0x1(%edx)
 15f:	75 ef                	jne    150 <strcpy+0x10>
		;
	return os;
}
 161:	5b                   	pop    %ebx
 162:	5d                   	pop    %ebp
 163:	c3                   	ret    
 164:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 16a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	8b 55 08             	mov    0x8(%ebp),%edx
 177:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 17a:	0f b6 02             	movzbl (%edx),%eax
 17d:	0f b6 19             	movzbl (%ecx),%ebx
 180:	84 c0                	test   %al,%al
 182:	75 1c                	jne    1a0 <strcmp+0x30>
 184:	eb 2a                	jmp    1b0 <strcmp+0x40>
 186:	8d 76 00             	lea    0x0(%esi),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 190:	83 c2 01             	add    $0x1,%edx
 193:	0f b6 02             	movzbl (%edx),%eax
 196:	83 c1 01             	add    $0x1,%ecx
 199:	0f b6 19             	movzbl (%ecx),%ebx
 19c:	84 c0                	test   %al,%al
 19e:	74 10                	je     1b0 <strcmp+0x40>
 1a0:	38 d8                	cmp    %bl,%al
 1a2:	74 ec                	je     190 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 1a4:	29 d8                	sub    %ebx,%eax
}
 1a6:	5b                   	pop    %ebx
 1a7:	5d                   	pop    %ebp
 1a8:	c3                   	ret    
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1b0:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 1b2:	29 d8                	sub    %ebx,%eax
}
 1b4:	5b                   	pop    %ebx
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	89 f6                	mov    %esi,%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <strlen>:

uint
strlen(char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 1c6:	80 39 00             	cmpb   $0x0,(%ecx)
 1c9:	74 15                	je     1e0 <strlen+0x20>
 1cb:	31 d2                	xor    %edx,%edx
 1cd:	8d 76 00             	lea    0x0(%esi),%esi
 1d0:	83 c2 01             	add    $0x1,%edx
 1d3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1d7:	89 d0                	mov    %edx,%eax
 1d9:	75 f5                	jne    1d0 <strlen+0x10>
		;
	return n;
}
 1db:	5d                   	pop    %ebp
 1dc:	c3                   	ret    
 1dd:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 1e0:	31 c0                	xor    %eax,%eax
}
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    
 1e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001f0 <memset>:

void *
memset(void *dst, int c, uint n)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 1f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	89 d7                	mov    %edx,%edi
 1ff:	fc                   	cld    
 200:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 202:	89 d0                	mov    %edx,%eax
 204:	5f                   	pop    %edi
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	89 f6                	mov    %esi,%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000210 <strchr>:

char *
strchr(const char *s, char c)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 21a:	0f b6 10             	movzbl (%eax),%edx
 21d:	84 d2                	test   %dl,%dl
 21f:	74 1d                	je     23e <strchr+0x2e>
		if (*s == c) return (char *)s;
 221:	38 d3                	cmp    %dl,%bl
 223:	89 d9                	mov    %ebx,%ecx
 225:	75 0d                	jne    234 <strchr+0x24>
 227:	eb 17                	jmp    240 <strchr+0x30>
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 230:	38 ca                	cmp    %cl,%dl
 232:	74 0c                	je     240 <strchr+0x30>
	for (; *s; s++)
 234:	83 c0 01             	add    $0x1,%eax
 237:	0f b6 10             	movzbl (%eax),%edx
 23a:	84 d2                	test   %dl,%dl
 23c:	75 f2                	jne    230 <strchr+0x20>
	return 0;
 23e:	31 c0                	xor    %eax,%eax
}
 240:	5b                   	pop    %ebx
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <gets>:

char *
gets(char *buf, int max)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	56                   	push   %esi
 255:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 256:	31 f6                	xor    %esi,%esi
 258:	89 f3                	mov    %esi,%ebx
{
 25a:	83 ec 1c             	sub    $0x1c,%esp
 25d:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 260:	eb 2f                	jmp    291 <gets+0x41>
 262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 268:	8d 45 e7             	lea    -0x19(%ebp),%eax
 26b:	83 ec 04             	sub    $0x4,%esp
 26e:	6a 01                	push   $0x1
 270:	50                   	push   %eax
 271:	6a 00                	push   $0x0
 273:	e8 51 01 00 00       	call   3c9 <read>
		if (cc < 1) break;
 278:	83 c4 10             	add    $0x10,%esp
 27b:	85 c0                	test   %eax,%eax
 27d:	7e 1c                	jle    29b <gets+0x4b>
		buf[i++] = c;
 27f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 283:	83 c7 01             	add    $0x1,%edi
 286:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 289:	3c 0a                	cmp    $0xa,%al
 28b:	74 23                	je     2b0 <gets+0x60>
 28d:	3c 0d                	cmp    $0xd,%al
 28f:	74 1f                	je     2b0 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 291:	83 c3 01             	add    $0x1,%ebx
 294:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 297:	89 fe                	mov    %edi,%esi
 299:	7c cd                	jl     268 <gets+0x18>
 29b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 2a0:	c6 03 00             	movb   $0x0,(%ebx)
}
 2a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2a6:	5b                   	pop    %ebx
 2a7:	5e                   	pop    %esi
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    
 2ab:	90                   	nop
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b0:	8b 75 08             	mov    0x8(%ebp),%esi
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	01 de                	add    %ebx,%esi
 2b8:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 2ba:	c6 03 00             	movb   $0x0,(%ebx)
}
 2bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2c0:	5b                   	pop    %ebx
 2c1:	5e                   	pop    %esi
 2c2:	5f                   	pop    %edi
 2c3:	5d                   	pop    %ebp
 2c4:	c3                   	ret    
 2c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <stat>:

int
stat(char *n, struct stat *st)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 2d5:	83 ec 08             	sub    $0x8,%esp
 2d8:	6a 00                	push   $0x0
 2da:	ff 75 08             	pushl  0x8(%ebp)
 2dd:	e8 0f 01 00 00       	call   3f1 <open>
	if (fd < 0) return -1;
 2e2:	83 c4 10             	add    $0x10,%esp
 2e5:	85 c0                	test   %eax,%eax
 2e7:	78 27                	js     310 <stat+0x40>
	r = fstat(fd, st);
 2e9:	83 ec 08             	sub    $0x8,%esp
 2ec:	ff 75 0c             	pushl  0xc(%ebp)
 2ef:	89 c3                	mov    %eax,%ebx
 2f1:	50                   	push   %eax
 2f2:	e8 12 01 00 00       	call   409 <fstat>
	close(fd);
 2f7:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 2fa:	89 c6                	mov    %eax,%esi
	close(fd);
 2fc:	e8 d8 00 00 00       	call   3d9 <close>
	return r;
 301:	83 c4 10             	add    $0x10,%esp
}
 304:	8d 65 f8             	lea    -0x8(%ebp),%esp
 307:	89 f0                	mov    %esi,%eax
 309:	5b                   	pop    %ebx
 30a:	5e                   	pop    %esi
 30b:	5d                   	pop    %ebp
 30c:	c3                   	ret    
 30d:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 310:	be ff ff ff ff       	mov    $0xffffffff,%esi
 315:	eb ed                	jmp    304 <stat+0x34>
 317:	89 f6                	mov    %esi,%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <atoi>:

int
atoi(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	53                   	push   %ebx
 324:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 327:	0f be 11             	movsbl (%ecx),%edx
 32a:	8d 42 d0             	lea    -0x30(%edx),%eax
 32d:	3c 09                	cmp    $0x9,%al
	n = 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 334:	77 1f                	ja     355 <atoi+0x35>
 336:	8d 76 00             	lea    0x0(%esi),%esi
 339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 340:	8d 04 80             	lea    (%eax,%eax,4),%eax
 343:	83 c1 01             	add    $0x1,%ecx
 346:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 34a:	0f be 11             	movsbl (%ecx),%edx
 34d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 350:	80 fb 09             	cmp    $0x9,%bl
 353:	76 eb                	jbe    340 <atoi+0x20>
	return n;
}
 355:	5b                   	pop    %ebx
 356:	5d                   	pop    %ebp
 357:	c3                   	ret    
 358:	90                   	nop
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000360 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
 365:	8b 5d 10             	mov    0x10(%ebp),%ebx
 368:	8b 45 08             	mov    0x8(%ebp),%eax
 36b:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 36e:	85 db                	test   %ebx,%ebx
 370:	7e 14                	jle    386 <memmove+0x26>
 372:	31 d2                	xor    %edx,%edx
 374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 378:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 37c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 37f:	83 c2 01             	add    $0x1,%edx
 382:	39 d3                	cmp    %edx,%ebx
 384:	75 f2                	jne    378 <memmove+0x18>
	return vdst;
}
 386:	5b                   	pop    %ebx
 387:	5e                   	pop    %esi
 388:	5d                   	pop    %ebp
 389:	c3                   	ret    
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000390 <shm_get>:

char*
shm_get(char* name)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
	return shmget(name);
}
 393:	5d                   	pop    %ebp
	return shmget(name);
 394:	e9 00 01 00 00       	jmp    499 <shmget>
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003a0 <shm_rem>:

int
shm_rem(char* name)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
	return shmrem(name);
}
 3a3:	5d                   	pop    %ebp
	return shmrem(name);
 3a4:	e9 f8 00 00 00       	jmp    4a1 <shmrem>

000003a9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a9:	b8 01 00 00 00       	mov    $0x1,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <exit>:
SYSCALL(exit)
 3b1:	b8 02 00 00 00       	mov    $0x2,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <wait>:
SYSCALL(wait)
 3b9:	b8 03 00 00 00       	mov    $0x3,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <pipe>:
SYSCALL(pipe)
 3c1:	b8 04 00 00 00       	mov    $0x4,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <read>:
SYSCALL(read)
 3c9:	b8 05 00 00 00       	mov    $0x5,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <write>:
SYSCALL(write)
 3d1:	b8 10 00 00 00       	mov    $0x10,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <close>:
SYSCALL(close)
 3d9:	b8 15 00 00 00       	mov    $0x15,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <kill>:
SYSCALL(kill)
 3e1:	b8 06 00 00 00       	mov    $0x6,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <exec>:
SYSCALL(exec)
 3e9:	b8 07 00 00 00       	mov    $0x7,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <open>:
SYSCALL(open)
 3f1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <mknod>:
SYSCALL(mknod)
 3f9:	b8 11 00 00 00       	mov    $0x11,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <unlink>:
SYSCALL(unlink)
 401:	b8 12 00 00 00       	mov    $0x12,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <fstat>:
SYSCALL(fstat)
 409:	b8 08 00 00 00       	mov    $0x8,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <link>:
SYSCALL(link)
 411:	b8 13 00 00 00       	mov    $0x13,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <mkdir>:
SYSCALL(mkdir)
 419:	b8 14 00 00 00       	mov    $0x14,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <chdir>:
SYSCALL(chdir)
 421:	b8 09 00 00 00       	mov    $0x9,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <dup>:
SYSCALL(dup)
 429:	b8 0a 00 00 00       	mov    $0xa,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <getpid>:
SYSCALL(getpid)
 431:	b8 0b 00 00 00       	mov    $0xb,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <sbrk>:
SYSCALL(sbrk)
 439:	b8 0c 00 00 00       	mov    $0xc,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <sleep>:
SYSCALL(sleep)
 441:	b8 0d 00 00 00       	mov    $0xd,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <uptime>:
SYSCALL(uptime)
 449:	b8 0e 00 00 00       	mov    $0xe,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <mcreate>:
SYSCALL(mcreate)
 451:	b8 16 00 00 00       	mov    $0x16,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <mdelete>:
SYSCALL(mdelete)
 459:	b8 17 00 00 00       	mov    $0x17,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <mlock>:
SYSCALL(mlock)
 461:	b8 18 00 00 00       	mov    $0x18,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <munlock>:
SYSCALL(munlock)
 469:	b8 19 00 00 00       	mov    $0x19,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <waitcv>:
SYSCALL(waitcv)
 471:	b8 1a 00 00 00       	mov    $0x1a,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <signalcv>:
SYSCALL(signalcv)
 479:	b8 1b 00 00 00       	mov    $0x1b,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <prio_set>:
SYSCALL(prio_set)
 481:	b8 1c 00 00 00       	mov    $0x1c,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <testpqeq>:
SYSCALL(testpqeq)
 489:	b8 1d 00 00 00       	mov    $0x1d,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <testpqdq>:
SYSCALL(testpqdq)
 491:	b8 1e 00 00 00       	mov    $0x1e,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <shmget>:
SYSCALL(shmget)
 499:	b8 1f 00 00 00       	mov    $0x1f,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <shmrem>:
 4a1:	b8 20 00 00 00       	mov    $0x20,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    
 4a9:	66 90                	xchg   %ax,%ax
 4ab:	66 90                	xchg   %ax,%ax
 4ad:	66 90                	xchg   %ax,%ax
 4af:	90                   	nop

000004b0 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 4b9:	85 d2                	test   %edx,%edx
{
 4bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 4be:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 4c0:	79 76                	jns    538 <printint+0x88>
 4c2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4c6:	74 70                	je     538 <printint+0x88>
		x   = -xx;
 4c8:	f7 d8                	neg    %eax
		neg = 1;
 4ca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 4d1:	31 f6                	xor    %esi,%esi
 4d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4d6:	eb 0a                	jmp    4e2 <printint+0x32>
 4d8:	90                   	nop
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 4e0:	89 fe                	mov    %edi,%esi
 4e2:	31 d2                	xor    %edx,%edx
 4e4:	8d 7e 01             	lea    0x1(%esi),%edi
 4e7:	f7 f1                	div    %ecx
 4e9:	0f b6 92 d4 08 00 00 	movzbl 0x8d4(%edx),%edx
	} while ((x /= base) != 0);
 4f0:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 4f2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 4f5:	75 e9                	jne    4e0 <printint+0x30>
	if (neg) buf[i++] = '-';
 4f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4fa:	85 c0                	test   %eax,%eax
 4fc:	74 08                	je     506 <printint+0x56>
 4fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 503:	8d 7e 02             	lea    0x2(%esi),%edi
 506:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 50a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 513:	83 ec 04             	sub    $0x4,%esp
 516:	83 ee 01             	sub    $0x1,%esi
 519:	6a 01                	push   $0x1
 51b:	53                   	push   %ebx
 51c:	57                   	push   %edi
 51d:	88 45 d7             	mov    %al,-0x29(%ebp)
 520:	e8 ac fe ff ff       	call   3d1 <write>

	while (--i >= 0) putc(fd, buf[i]);
 525:	83 c4 10             	add    $0x10,%esp
 528:	39 de                	cmp    %ebx,%esi
 52a:	75 e4                	jne    510 <printint+0x60>
}
 52c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52f:	5b                   	pop    %ebx
 530:	5e                   	pop    %esi
 531:	5f                   	pop    %edi
 532:	5d                   	pop    %ebp
 533:	c3                   	ret    
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 538:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 53f:	eb 90                	jmp    4d1 <printint+0x21>
 541:	eb 0d                	jmp    550 <printf>
 543:	90                   	nop
 544:	90                   	nop
 545:	90                   	nop
 546:	90                   	nop
 547:	90                   	nop
 548:	90                   	nop
 549:	90                   	nop
 54a:	90                   	nop
 54b:	90                   	nop
 54c:	90                   	nop
 54d:	90                   	nop
 54e:	90                   	nop
 54f:	90                   	nop

00000550 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 559:	8b 75 0c             	mov    0xc(%ebp),%esi
 55c:	0f b6 1e             	movzbl (%esi),%ebx
 55f:	84 db                	test   %bl,%bl
 561:	0f 84 b3 00 00 00    	je     61a <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 567:	8d 45 10             	lea    0x10(%ebp),%eax
 56a:	83 c6 01             	add    $0x1,%esi
	state = 0;
 56d:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 56f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 572:	eb 2f                	jmp    5a3 <printf+0x53>
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 578:	83 f8 25             	cmp    $0x25,%eax
 57b:	0f 84 a7 00 00 00    	je     628 <printf+0xd8>
	write(fd, &c, 1);
 581:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 584:	83 ec 04             	sub    $0x4,%esp
 587:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 58a:	6a 01                	push   $0x1
 58c:	50                   	push   %eax
 58d:	ff 75 08             	pushl  0x8(%ebp)
 590:	e8 3c fe ff ff       	call   3d1 <write>
 595:	83 c4 10             	add    $0x10,%esp
 598:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 59b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 59f:	84 db                	test   %bl,%bl
 5a1:	74 77                	je     61a <printf+0xca>
		if (state == 0) {
 5a3:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 5a5:	0f be cb             	movsbl %bl,%ecx
 5a8:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 5ab:	74 cb                	je     578 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 5ad:	83 ff 25             	cmp    $0x25,%edi
 5b0:	75 e6                	jne    598 <printf+0x48>
			if (c == 'd') {
 5b2:	83 f8 64             	cmp    $0x64,%eax
 5b5:	0f 84 05 01 00 00    	je     6c0 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 5bb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5c1:	83 f9 70             	cmp    $0x70,%ecx
 5c4:	74 72                	je     638 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 5c6:	83 f8 73             	cmp    $0x73,%eax
 5c9:	0f 84 99 00 00 00    	je     668 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 5cf:	83 f8 63             	cmp    $0x63,%eax
 5d2:	0f 84 08 01 00 00    	je     6e0 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 5d8:	83 f8 25             	cmp    $0x25,%eax
 5db:	0f 84 ef 00 00 00    	je     6d0 <printf+0x180>
	write(fd, &c, 1);
 5e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5e4:	83 ec 04             	sub    $0x4,%esp
 5e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5eb:	6a 01                	push   $0x1
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 db fd ff ff       	call   3d1 <write>
 5f6:	83 c4 0c             	add    $0xc,%esp
 5f9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5ff:	6a 01                	push   $0x1
 601:	50                   	push   %eax
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 608:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 60a:	e8 c2 fd ff ff       	call   3d1 <write>
	for (i = 0; fmt[i]; i++) {
 60f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 613:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 616:	84 db                	test   %bl,%bl
 618:	75 89                	jne    5a3 <printf+0x53>
		}
	}
}
 61a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61d:	5b                   	pop    %ebx
 61e:	5e                   	pop    %esi
 61f:	5f                   	pop    %edi
 620:	5d                   	pop    %ebp
 621:	c3                   	ret    
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 628:	bf 25 00 00 00       	mov    $0x25,%edi
 62d:	e9 66 ff ff ff       	jmp    598 <printf+0x48>
 632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 638:	83 ec 0c             	sub    $0xc,%esp
 63b:	b9 10 00 00 00       	mov    $0x10,%ecx
 640:	6a 00                	push   $0x0
 642:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	8b 17                	mov    (%edi),%edx
 64a:	e8 61 fe ff ff       	call   4b0 <printint>
				ap++;
 64f:	89 f8                	mov    %edi,%eax
 651:	83 c4 10             	add    $0x10,%esp
			state = 0;
 654:	31 ff                	xor    %edi,%edi
				ap++;
 656:	83 c0 04             	add    $0x4,%eax
 659:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 65c:	e9 37 ff ff ff       	jmp    598 <printf+0x48>
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 66b:	8b 08                	mov    (%eax),%ecx
				ap++;
 66d:	83 c0 04             	add    $0x4,%eax
 670:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 673:	85 c9                	test   %ecx,%ecx
 675:	0f 84 8e 00 00 00    	je     709 <printf+0x1b9>
				while (*s != 0) {
 67b:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 67e:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 680:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 682:	84 c0                	test   %al,%al
 684:	0f 84 0e ff ff ff    	je     598 <printf+0x48>
 68a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 68d:	89 de                	mov    %ebx,%esi
 68f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 692:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 695:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 698:	83 ec 04             	sub    $0x4,%esp
					s++;
 69b:	83 c6 01             	add    $0x1,%esi
 69e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 6a1:	6a 01                	push   $0x1
 6a3:	57                   	push   %edi
 6a4:	53                   	push   %ebx
 6a5:	e8 27 fd ff ff       	call   3d1 <write>
				while (*s != 0) {
 6aa:	0f b6 06             	movzbl (%esi),%eax
 6ad:	83 c4 10             	add    $0x10,%esp
 6b0:	84 c0                	test   %al,%al
 6b2:	75 e4                	jne    698 <printf+0x148>
 6b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 6b7:	31 ff                	xor    %edi,%edi
 6b9:	e9 da fe ff ff       	jmp    598 <printf+0x48>
 6be:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c8:	6a 01                	push   $0x1
 6ca:	e9 73 ff ff ff       	jmp    642 <printf+0xf2>
 6cf:	90                   	nop
	write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6d9:	6a 01                	push   $0x1
 6db:	e9 21 ff ff ff       	jmp    601 <printf+0xb1>
				putc(fd, *ap);
 6e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 6e6:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
				ap++;
 6ea:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 6ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 6f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6f3:	50                   	push   %eax
 6f4:	ff 75 08             	pushl  0x8(%ebp)
 6f7:	e8 d5 fc ff ff       	call   3d1 <write>
				ap++;
 6fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6ff:	83 c4 10             	add    $0x10,%esp
			state = 0;
 702:	31 ff                	xor    %edi,%edi
 704:	e9 8f fe ff ff       	jmp    598 <printf+0x48>
				if (s == 0) s = "(null)";
 709:	bb cb 08 00 00       	mov    $0x8cb,%ebx
				while (*s != 0) {
 70e:	b8 28 00 00 00       	mov    $0x28,%eax
 713:	e9 72 ff ff ff       	jmp    68a <printf+0x13a>
 718:	66 90                	xchg   %ax,%ax
 71a:	66 90                	xchg   %ax,%ax
 71c:	66 90                	xchg   %ax,%ax
 71e:	66 90                	xchg   %ax,%ax

00000720 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 c4 0b 00 00       	mov    0xbc4,%eax
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 72e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	39 c8                	cmp    %ecx,%eax
 73a:	8b 10                	mov    (%eax),%edx
 73c:	73 32                	jae    770 <free+0x50>
 73e:	39 d1                	cmp    %edx,%ecx
 740:	72 04                	jb     746 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 742:	39 d0                	cmp    %edx,%eax
 744:	72 32                	jb     778 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 746:	8b 73 fc             	mov    -0x4(%ebx),%esi
 749:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74c:	39 fa                	cmp    %edi,%edx
 74e:	74 30                	je     780 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 750:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 753:	8b 50 04             	mov    0x4(%eax),%edx
 756:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 759:	39 f1                	cmp    %esi,%ecx
 75b:	74 3a                	je     797 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 75d:	89 08                	mov    %ecx,(%eax)
	freep = p;
 75f:	a3 c4 0b 00 00       	mov    %eax,0xbc4
}
 764:	5b                   	pop    %ebx
 765:	5e                   	pop    %esi
 766:	5f                   	pop    %edi
 767:	5d                   	pop    %ebp
 768:	c3                   	ret    
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 770:	39 d0                	cmp    %edx,%eax
 772:	72 04                	jb     778 <free+0x58>
 774:	39 d1                	cmp    %edx,%ecx
 776:	72 ce                	jb     746 <free+0x26>
{
 778:	89 d0                	mov    %edx,%eax
 77a:	eb bc                	jmp    738 <free+0x18>
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 780:	03 72 04             	add    0x4(%edx),%esi
 783:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 12                	mov    (%edx),%edx
 78a:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 793:	39 f1                	cmp    %esi,%ecx
 795:	75 c6                	jne    75d <free+0x3d>
		p->s.size += bp->s.size;
 797:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 79a:	a3 c4 0b 00 00       	mov    %eax,0xbc4
		p->s.size += bp->s.size;
 79f:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 7a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7a5:	89 10                	mov    %edx,(%eax)
}
 7a7:	5b                   	pop    %ebx
 7a8:	5e                   	pop    %esi
 7a9:	5f                   	pop    %edi
 7aa:	5d                   	pop    %ebp
 7ab:	c3                   	ret    
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 7bc:	8b 15 c4 0b 00 00    	mov    0xbc4,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7c2:	8d 78 07             	lea    0x7(%eax),%edi
 7c5:	c1 ef 03             	shr    $0x3,%edi
 7c8:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 7cb:	85 d2                	test   %edx,%edx
 7cd:	0f 84 9d 00 00 00    	je     870 <malloc+0xc0>
 7d3:	8b 02                	mov    (%edx),%eax
 7d5:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 7d8:	39 cf                	cmp    %ecx,%edi
 7da:	76 6c                	jbe    848 <malloc+0x98>
 7dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7e7:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 7ea:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7f1:	eb 0e                	jmp    801 <malloc+0x51>
 7f3:	90                   	nop
 7f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7f8:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 7fa:	8b 48 04             	mov    0x4(%eax),%ecx
 7fd:	39 f9                	cmp    %edi,%ecx
 7ff:	73 47                	jae    848 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 801:	39 05 c4 0b 00 00    	cmp    %eax,0xbc4
 807:	89 c2                	mov    %eax,%edx
 809:	75 ed                	jne    7f8 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	56                   	push   %esi
 80f:	e8 25 fc ff ff       	call   439 <sbrk>
	if (p == (char *)-1) return 0;
 814:	83 c4 10             	add    $0x10,%esp
 817:	83 f8 ff             	cmp    $0xffffffff,%eax
 81a:	74 1c                	je     838 <malloc+0x88>
	hp->s.size = nu;
 81c:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 81f:	83 ec 0c             	sub    $0xc,%esp
 822:	83 c0 08             	add    $0x8,%eax
 825:	50                   	push   %eax
 826:	e8 f5 fe ff ff       	call   720 <free>
	return freep;
 82b:	8b 15 c4 0b 00 00    	mov    0xbc4,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 831:	83 c4 10             	add    $0x10,%esp
 834:	85 d2                	test   %edx,%edx
 836:	75 c0                	jne    7f8 <malloc+0x48>
	}
}
 838:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 83b:	31 c0                	xor    %eax,%eax
}
 83d:	5b                   	pop    %ebx
 83e:	5e                   	pop    %esi
 83f:	5f                   	pop    %edi
 840:	5d                   	pop    %ebp
 841:	c3                   	ret    
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 848:	39 cf                	cmp    %ecx,%edi
 84a:	74 54                	je     8a0 <malloc+0xf0>
				p->s.size -= nunits;
 84c:	29 f9                	sub    %edi,%ecx
 84e:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 851:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 854:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 857:	89 15 c4 0b 00 00    	mov    %edx,0xbc4
}
 85d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 860:	83 c0 08             	add    $0x8,%eax
}
 863:	5b                   	pop    %ebx
 864:	5e                   	pop    %esi
 865:	5f                   	pop    %edi
 866:	5d                   	pop    %ebp
 867:	c3                   	ret    
 868:	90                   	nop
 869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 870:	c7 05 c4 0b 00 00 c8 	movl   $0xbc8,0xbc4
 877:	0b 00 00 
 87a:	c7 05 c8 0b 00 00 c8 	movl   $0xbc8,0xbc8
 881:	0b 00 00 
		base.s.size                = 0;
 884:	b8 c8 0b 00 00       	mov    $0xbc8,%eax
 889:	c7 05 cc 0b 00 00 00 	movl   $0x0,0xbcc
 890:	00 00 00 
 893:	e9 44 ff ff ff       	jmp    7dc <malloc+0x2c>
 898:	90                   	nop
 899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 8a0:	8b 08                	mov    (%eax),%ecx
 8a2:	89 0a                	mov    %ecx,(%edx)
 8a4:	eb b1                	jmp    857 <malloc+0xa7>
