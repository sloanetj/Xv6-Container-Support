
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	close(fd);
}

int
main(int argc, char *argv[])
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
  1b:	7e 24                	jle    41 <main+0x41>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	90                   	nop
  24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		ls(".");
		exit();
	}
	for (i = 1; i < argc; i++) ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 cb 00 00 00       	call   100 <ls>
  35:	83 c4 10             	add    $0x10,%esp
  38:	39 f3                	cmp    %esi,%ebx
  3a:	75 ec                	jne    28 <main+0x28>
	exit();
  3c:	e8 60 05 00 00       	call   5a1 <exit>
		ls(".");
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	68 e0 0a 00 00       	push   $0xae0
  49:	e8 b2 00 00 00       	call   100 <ls>
		exit();
  4e:	e8 4e 05 00 00       	call   5a1 <exit>
  53:	66 90                	xchg   %ax,%ax
  55:	66 90                	xchg   %ax,%ax
  57:	66 90                	xchg   %ax,%ax
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	for (p = path + strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	53                   	push   %ebx
  6c:	e8 3f 03 00 00       	call   3b0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 d8                	add    %ebx,%eax
  76:	73 0f                	jae    87 <fmtname+0x27>
  78:	eb 12                	jmp    8c <fmtname+0x2c>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	83 e8 01             	sub    $0x1,%eax
  83:	39 c3                	cmp    %eax,%ebx
  85:	77 05                	ja     8c <fmtname+0x2c>
  87:	80 38 2f             	cmpb   $0x2f,(%eax)
  8a:	75 f4                	jne    80 <fmtname+0x20>
	p++;
  8c:	8d 58 01             	lea    0x1(%eax),%ebx
	if (strlen(p) >= DIRSIZ) return p;
  8f:	83 ec 0c             	sub    $0xc,%esp
  92:	53                   	push   %ebx
  93:	e8 18 03 00 00       	call   3b0 <strlen>
  98:	83 c4 10             	add    $0x10,%esp
  9b:	83 f8 0d             	cmp    $0xd,%eax
  9e:	77 4a                	ja     ea <fmtname+0x8a>
	memmove(buf, p, strlen(p));
  a0:	83 ec 0c             	sub    $0xc,%esp
  a3:	53                   	push   %ebx
  a4:	e8 07 03 00 00       	call   3b0 <strlen>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	50                   	push   %eax
  ad:	53                   	push   %ebx
  ae:	68 4c 0e 00 00       	push   $0xe4c
  b3:	e8 98 04 00 00       	call   550 <memmove>
	memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  b8:	89 1c 24             	mov    %ebx,(%esp)
  bb:	e8 f0 02 00 00       	call   3b0 <strlen>
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	89 c6                	mov    %eax,%esi
	return buf;
  c5:	bb 4c 0e 00 00       	mov    $0xe4c,%ebx
	memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  ca:	e8 e1 02 00 00       	call   3b0 <strlen>
  cf:	ba 0e 00 00 00       	mov    $0xe,%edx
  d4:	83 c4 0c             	add    $0xc,%esp
  d7:	05 4c 0e 00 00       	add    $0xe4c,%eax
  dc:	29 f2                	sub    %esi,%edx
  de:	52                   	push   %edx
  df:	6a 20                	push   $0x20
  e1:	50                   	push   %eax
  e2:	e8 f9 02 00 00       	call   3e0 <memset>
	return buf;
  e7:	83 c4 10             	add    $0x10,%esp
}
  ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ed:	89 d8                	mov    %ebx,%eax
  ef:	5b                   	pop    %ebx
  f0:	5e                   	pop    %esi
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    
  f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000100 <ls>:
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	81 ec 64 02 00 00    	sub    $0x264,%esp
 10c:	8b 7d 08             	mov    0x8(%ebp),%edi
	if ((fd = open(path, 0)) < 0) {
 10f:	6a 00                	push   $0x0
 111:	57                   	push   %edi
 112:	e8 ca 04 00 00       	call   5e1 <open>
 117:	83 c4 10             	add    $0x10,%esp
 11a:	85 c0                	test   %eax,%eax
 11c:	78 52                	js     170 <ls+0x70>
	if (fstat(fd, &st) < 0) {
 11e:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 124:	83 ec 08             	sub    $0x8,%esp
 127:	89 c3                	mov    %eax,%ebx
 129:	56                   	push   %esi
 12a:	50                   	push   %eax
 12b:	e8 c9 04 00 00       	call   5f9 <fstat>
 130:	83 c4 10             	add    $0x10,%esp
 133:	85 c0                	test   %eax,%eax
 135:	0f 88 c5 00 00 00    	js     200 <ls+0x100>
	switch (st.type) {
 13b:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 142:	66 83 f8 01          	cmp    $0x1,%ax
 146:	0f 84 84 00 00 00    	je     1d0 <ls+0xd0>
 14c:	66 83 f8 02          	cmp    $0x2,%ax
 150:	74 3e                	je     190 <ls+0x90>
	close(fd);
 152:	83 ec 0c             	sub    $0xc,%esp
 155:	53                   	push   %ebx
 156:	e8 6e 04 00 00       	call   5c9 <close>
 15b:	83 c4 10             	add    $0x10,%esp
}
 15e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 161:	5b                   	pop    %ebx
 162:	5e                   	pop    %esi
 163:	5f                   	pop    %edi
 164:	5d                   	pop    %ebp
 165:	c3                   	ret    
 166:	8d 76 00             	lea    0x0(%esi),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		printf(2, "ls: cannot open %s\n", path);
 170:	83 ec 04             	sub    $0x4,%esp
 173:	57                   	push   %edi
 174:	68 98 0a 00 00       	push   $0xa98
 179:	6a 02                	push   $0x2
 17b:	e8 c0 05 00 00       	call   740 <printf>
		return;
 180:	83 c4 10             	add    $0x10,%esp
}
 183:	8d 65 f4             	lea    -0xc(%ebp),%esp
 186:	5b                   	pop    %ebx
 187:	5e                   	pop    %esi
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    
 18b:	90                   	nop
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 190:	83 ec 0c             	sub    $0xc,%esp
 193:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 199:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 19f:	57                   	push   %edi
 1a0:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 1a6:	e8 b5 fe ff ff       	call   60 <fmtname>
 1ab:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1b1:	59                   	pop    %ecx
 1b2:	5f                   	pop    %edi
 1b3:	52                   	push   %edx
 1b4:	56                   	push   %esi
 1b5:	6a 02                	push   $0x2
 1b7:	50                   	push   %eax
 1b8:	68 c0 0a 00 00       	push   $0xac0
 1bd:	6a 01                	push   $0x1
 1bf:	e8 7c 05 00 00       	call   740 <printf>
		break;
 1c4:	83 c4 20             	add    $0x20,%esp
 1c7:	eb 89                	jmp    152 <ls+0x52>
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 1d0:	83 ec 0c             	sub    $0xc,%esp
 1d3:	57                   	push   %edi
 1d4:	e8 d7 01 00 00       	call   3b0 <strlen>
 1d9:	83 c0 10             	add    $0x10,%eax
 1dc:	83 c4 10             	add    $0x10,%esp
 1df:	3d 00 02 00 00       	cmp    $0x200,%eax
 1e4:	76 42                	jbe    228 <ls+0x128>
			printf(1, "ls: path too long\n");
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	68 cd 0a 00 00       	push   $0xacd
 1ee:	6a 01                	push   $0x1
 1f0:	e8 4b 05 00 00       	call   740 <printf>
			break;
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	e9 55 ff ff ff       	jmp    152 <ls+0x52>
 1fd:	8d 76 00             	lea    0x0(%esi),%esi
		printf(2, "ls: cannot stat %s\n", path);
 200:	83 ec 04             	sub    $0x4,%esp
 203:	57                   	push   %edi
 204:	68 ac 0a 00 00       	push   $0xaac
 209:	6a 02                	push   $0x2
 20b:	e8 30 05 00 00       	call   740 <printf>
		close(fd);
 210:	89 1c 24             	mov    %ebx,(%esp)
 213:	e8 b1 03 00 00       	call   5c9 <close>
		return;
 218:	83 c4 10             	add    $0x10,%esp
}
 21b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5f                   	pop    %edi
 221:	5d                   	pop    %ebp
 222:	c3                   	ret    
 223:	90                   	nop
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		strcpy(buf, path);
 228:	83 ec 08             	sub    $0x8,%esp
 22b:	57                   	push   %edi
 22c:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 232:	57                   	push   %edi
 233:	e8 f8 00 00 00       	call   330 <strcpy>
		p    = buf + strlen(buf);
 238:	89 3c 24             	mov    %edi,(%esp)
 23b:	e8 70 01 00 00       	call   3b0 <strlen>
 240:	01 f8                	add    %edi,%eax
		while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 242:	83 c4 10             	add    $0x10,%esp
		*p++ = '/';
 245:	8d 48 01             	lea    0x1(%eax),%ecx
		p    = buf + strlen(buf);
 248:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
		*p++ = '/';
 24e:	c6 00 2f             	movb   $0x2f,(%eax)
 251:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 257:	89 f6                	mov    %esi,%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 260:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 266:	83 ec 04             	sub    $0x4,%esp
 269:	6a 10                	push   $0x10
 26b:	50                   	push   %eax
 26c:	53                   	push   %ebx
 26d:	e8 47 03 00 00       	call   5b9 <read>
 272:	83 c4 10             	add    $0x10,%esp
 275:	83 f8 10             	cmp    $0x10,%eax
 278:	0f 85 d4 fe ff ff    	jne    152 <ls+0x52>
			if (de.inum == 0) continue;
 27e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 285:	00 
 286:	74 d8                	je     260 <ls+0x160>
			memmove(p, de.name, DIRSIZ);
 288:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 28e:	83 ec 04             	sub    $0x4,%esp
 291:	6a 0e                	push   $0xe
 293:	50                   	push   %eax
 294:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 29a:	e8 b1 02 00 00       	call   550 <memmove>
			p[DIRSIZ] = 0;
 29f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 2a5:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
			if (stat(buf, &st) < 0) {
 2a9:	58                   	pop    %eax
 2aa:	5a                   	pop    %edx
 2ab:	56                   	push   %esi
 2ac:	57                   	push   %edi
 2ad:	e8 0e 02 00 00       	call   4c0 <stat>
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	85 c0                	test   %eax,%eax
 2b7:	78 5f                	js     318 <ls+0x218>
			printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 2b9:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 2c0:	83 ec 0c             	sub    $0xc,%esp
 2c3:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 2c9:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 2cf:	57                   	push   %edi
 2d0:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 2d6:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 2dc:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 2e2:	e8 79 fd ff ff       	call   60 <fmtname>
 2e7:	5a                   	pop    %edx
 2e8:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 2ee:	59                   	pop    %ecx
 2ef:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 2f5:	51                   	push   %ecx
 2f6:	52                   	push   %edx
 2f7:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2fd:	50                   	push   %eax
 2fe:	68 c0 0a 00 00       	push   $0xac0
 303:	6a 01                	push   $0x1
 305:	e8 36 04 00 00       	call   740 <printf>
 30a:	83 c4 20             	add    $0x20,%esp
 30d:	e9 4e ff ff ff       	jmp    260 <ls+0x160>
 312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printf(1, "ls: cannot stat %s\n", buf);
 318:	83 ec 04             	sub    $0x4,%esp
 31b:	57                   	push   %edi
 31c:	68 ac 0a 00 00       	push   $0xaac
 321:	6a 01                	push   $0x1
 323:	e8 18 04 00 00       	call   740 <printf>
				continue;
 328:	83 c4 10             	add    $0x10,%esp
 32b:	e9 30 ff ff ff       	jmp    260 <ls+0x160>

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char *
strcpy(char *s, char *t)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *os;

	os = s;
	while ((*s++ = *t++) != 0)
 33a:	89 c2                	mov    %eax,%edx
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 340:	83 c1 01             	add    $0x1,%ecx
 343:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 347:	83 c2 01             	add    $0x1,%edx
 34a:	84 db                	test   %bl,%bl
 34c:	88 5a ff             	mov    %bl,-0x1(%edx)
 34f:	75 ef                	jne    340 <strcpy+0x10>
		;
	return os;
}
 351:	5b                   	pop    %ebx
 352:	5d                   	pop    %ebp
 353:	c3                   	ret    
 354:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 35a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
 367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q) p++, q++;
 36a:	0f b6 02             	movzbl (%edx),%eax
 36d:	0f b6 19             	movzbl (%ecx),%ebx
 370:	84 c0                	test   %al,%al
 372:	75 1c                	jne    390 <strcmp+0x30>
 374:	eb 2a                	jmp    3a0 <strcmp+0x40>
 376:	8d 76 00             	lea    0x0(%esi),%esi
 379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 380:	83 c2 01             	add    $0x1,%edx
 383:	0f b6 02             	movzbl (%edx),%eax
 386:	83 c1 01             	add    $0x1,%ecx
 389:	0f b6 19             	movzbl (%ecx),%ebx
 38c:	84 c0                	test   %al,%al
 38e:	74 10                	je     3a0 <strcmp+0x40>
 390:	38 d8                	cmp    %bl,%al
 392:	74 ec                	je     380 <strcmp+0x20>
	return (uchar)*p - (uchar)*q;
 394:	29 d8                	sub    %ebx,%eax
}
 396:	5b                   	pop    %ebx
 397:	5d                   	pop    %ebp
 398:	c3                   	ret    
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3a0:	31 c0                	xor    %eax,%eax
	return (uchar)*p - (uchar)*q;
 3a2:	29 d8                	sub    %ebx,%eax
}
 3a4:	5b                   	pop    %ebx
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    
 3a7:	89 f6                	mov    %esi,%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <strlen>:

uint
strlen(char *s)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	for (n = 0; s[n]; n++)
 3b6:	80 39 00             	cmpb   $0x0,(%ecx)
 3b9:	74 15                	je     3d0 <strlen+0x20>
 3bb:	31 d2                	xor    %edx,%edx
 3bd:	8d 76 00             	lea    0x0(%esi),%esi
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3c7:	89 d0                	mov    %edx,%eax
 3c9:	75 f5                	jne    3c0 <strlen+0x10>
		;
	return n;
}
 3cb:	5d                   	pop    %ebp
 3cc:	c3                   	ret    
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
	for (n = 0; s[n]; n++)
 3d0:	31 c0                	xor    %eax,%eax
}
 3d2:	5d                   	pop    %ebp
 3d3:	c3                   	ret    
 3d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003e0 <memset>:

void *
memset(void *dst, int c, uint n)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
 3e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ed:	89 d7                	mov    %edx,%edi
 3ef:	fc                   	cld    
 3f0:	f3 aa                	rep stos %al,%es:(%edi)
	stosb(dst, c, n);
	return dst;
}
 3f2:	89 d0                	mov    %edx,%eax
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    
 3f7:	89 f6                	mov    %esi,%esi
 3f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000400 <strchr>:

char *
strchr(const char *s, char c)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	53                   	push   %ebx
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	for (; *s; s++)
 40a:	0f b6 10             	movzbl (%eax),%edx
 40d:	84 d2                	test   %dl,%dl
 40f:	74 1d                	je     42e <strchr+0x2e>
		if (*s == c) return (char *)s;
 411:	38 d3                	cmp    %dl,%bl
 413:	89 d9                	mov    %ebx,%ecx
 415:	75 0d                	jne    424 <strchr+0x24>
 417:	eb 17                	jmp    430 <strchr+0x30>
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 420:	38 ca                	cmp    %cl,%dl
 422:	74 0c                	je     430 <strchr+0x30>
	for (; *s; s++)
 424:	83 c0 01             	add    $0x1,%eax
 427:	0f b6 10             	movzbl (%eax),%edx
 42a:	84 d2                	test   %dl,%dl
 42c:	75 f2                	jne    420 <strchr+0x20>
	return 0;
 42e:	31 c0                	xor    %eax,%eax
}
 430:	5b                   	pop    %ebx
 431:	5d                   	pop    %ebp
 432:	c3                   	ret    
 433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <gets>:

char *
gets(char *buf, int max)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
	int  i, cc;
	char c;

	for (i = 0; i + 1 < max;) {
 446:	31 f6                	xor    %esi,%esi
 448:	89 f3                	mov    %esi,%ebx
{
 44a:	83 ec 1c             	sub    $0x1c,%esp
 44d:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i + 1 < max;) {
 450:	eb 2f                	jmp    481 <gets+0x41>
 452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		cc = read(0, &c, 1);
 458:	8d 45 e7             	lea    -0x19(%ebp),%eax
 45b:	83 ec 04             	sub    $0x4,%esp
 45e:	6a 01                	push   $0x1
 460:	50                   	push   %eax
 461:	6a 00                	push   $0x0
 463:	e8 51 01 00 00       	call   5b9 <read>
		if (cc < 1) break;
 468:	83 c4 10             	add    $0x10,%esp
 46b:	85 c0                	test   %eax,%eax
 46d:	7e 1c                	jle    48b <gets+0x4b>
		buf[i++] = c;
 46f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 473:	83 c7 01             	add    $0x1,%edi
 476:	88 47 ff             	mov    %al,-0x1(%edi)
		if (c == '\n' || c == '\r') break;
 479:	3c 0a                	cmp    $0xa,%al
 47b:	74 23                	je     4a0 <gets+0x60>
 47d:	3c 0d                	cmp    $0xd,%al
 47f:	74 1f                	je     4a0 <gets+0x60>
	for (i = 0; i + 1 < max;) {
 481:	83 c3 01             	add    $0x1,%ebx
 484:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 487:	89 fe                	mov    %edi,%esi
 489:	7c cd                	jl     458 <gets+0x18>
 48b:	89 f3                	mov    %esi,%ebx
	}
	buf[i] = '\0';
	return buf;
}
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
	buf[i] = '\0';
 490:	c6 03 00             	movb   $0x0,(%ebx)
}
 493:	8d 65 f4             	lea    -0xc(%ebp),%esp
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5f                   	pop    %edi
 499:	5d                   	pop    %ebp
 49a:	c3                   	ret    
 49b:	90                   	nop
 49c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4a0:	8b 75 08             	mov    0x8(%ebp),%esi
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	01 de                	add    %ebx,%esi
 4a8:	89 f3                	mov    %esi,%ebx
	buf[i] = '\0';
 4aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 4ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b0:	5b                   	pop    %ebx
 4b1:	5e                   	pop    %esi
 4b2:	5f                   	pop    %edi
 4b3:	5d                   	pop    %ebp
 4b4:	c3                   	ret    
 4b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004c0 <stat>:

int
stat(char *n, struct stat *st)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
	int fd;
	int r;

	fd = open(n, O_RDONLY);
 4c5:	83 ec 08             	sub    $0x8,%esp
 4c8:	6a 00                	push   $0x0
 4ca:	ff 75 08             	pushl  0x8(%ebp)
 4cd:	e8 0f 01 00 00       	call   5e1 <open>
	if (fd < 0) return -1;
 4d2:	83 c4 10             	add    $0x10,%esp
 4d5:	85 c0                	test   %eax,%eax
 4d7:	78 27                	js     500 <stat+0x40>
	r = fstat(fd, st);
 4d9:	83 ec 08             	sub    $0x8,%esp
 4dc:	ff 75 0c             	pushl  0xc(%ebp)
 4df:	89 c3                	mov    %eax,%ebx
 4e1:	50                   	push   %eax
 4e2:	e8 12 01 00 00       	call   5f9 <fstat>
	close(fd);
 4e7:	89 1c 24             	mov    %ebx,(%esp)
	r = fstat(fd, st);
 4ea:	89 c6                	mov    %eax,%esi
	close(fd);
 4ec:	e8 d8 00 00 00       	call   5c9 <close>
	return r;
 4f1:	83 c4 10             	add    $0x10,%esp
}
 4f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f7:	89 f0                	mov    %esi,%eax
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret    
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
	if (fd < 0) return -1;
 500:	be ff ff ff ff       	mov    $0xffffffff,%esi
 505:	eb ed                	jmp    4f4 <stat+0x34>
 507:	89 f6                	mov    %esi,%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000510 <atoi>:

int
atoi(const char *s)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int n;

	n = 0;
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 517:	0f be 11             	movsbl (%ecx),%edx
 51a:	8d 42 d0             	lea    -0x30(%edx),%eax
 51d:	3c 09                	cmp    $0x9,%al
	n = 0;
 51f:	b8 00 00 00 00       	mov    $0x0,%eax
	while ('0' <= *s && *s <= '9') n= n * 10 + *s++ - '0';
 524:	77 1f                	ja     545 <atoi+0x35>
 526:	8d 76 00             	lea    0x0(%esi),%esi
 529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 530:	8d 04 80             	lea    (%eax,%eax,4),%eax
 533:	83 c1 01             	add    $0x1,%ecx
 536:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
 53a:	0f be 11             	movsbl (%ecx),%edx
 53d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 540:	80 fb 09             	cmp    $0x9,%bl
 543:	76 eb                	jbe    530 <atoi+0x20>
	return n;
}
 545:	5b                   	pop    %ebx
 546:	5d                   	pop    %ebp
 547:	c3                   	ret    
 548:	90                   	nop
 549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000550 <memmove>:

void *
memmove(void *vdst, void *vsrc, int n)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	56                   	push   %esi
 554:	53                   	push   %ebx
 555:	8b 5d 10             	mov    0x10(%ebp),%ebx
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *dst, *src;

	dst = vdst;
	src = vsrc;
	while (n-- > 0) *dst++= *src++;
 55e:	85 db                	test   %ebx,%ebx
 560:	7e 14                	jle    576 <memmove+0x26>
 562:	31 d2                	xor    %edx,%edx
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 568:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 56c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 56f:	83 c2 01             	add    $0x1,%edx
 572:	39 d3                	cmp    %edx,%ebx
 574:	75 f2                	jne    568 <memmove+0x18>
	return vdst;
}
 576:	5b                   	pop    %ebx
 577:	5e                   	pop    %esi
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000580 <shm_get>:

char*
shm_get(char* name)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
	return shmget(name);
}
 583:	5d                   	pop    %ebp
	return shmget(name);
 584:	e9 00 01 00 00       	jmp    689 <shmget>
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000590 <shm_rem>:

int
shm_rem(char* name)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
	return shmrem(name);
}
 593:	5d                   	pop    %ebp
	return shmrem(name);
 594:	e9 f8 00 00 00       	jmp    691 <shmrem>

00000599 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 599:	b8 01 00 00 00       	mov    $0x1,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <exit>:
SYSCALL(exit)
 5a1:	b8 02 00 00 00       	mov    $0x2,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <wait>:
SYSCALL(wait)
 5a9:	b8 03 00 00 00       	mov    $0x3,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <pipe>:
SYSCALL(pipe)
 5b1:	b8 04 00 00 00       	mov    $0x4,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <read>:
SYSCALL(read)
 5b9:	b8 05 00 00 00       	mov    $0x5,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <write>:
SYSCALL(write)
 5c1:	b8 10 00 00 00       	mov    $0x10,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <close>:
SYSCALL(close)
 5c9:	b8 15 00 00 00       	mov    $0x15,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <kill>:
SYSCALL(kill)
 5d1:	b8 06 00 00 00       	mov    $0x6,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <exec>:
SYSCALL(exec)
 5d9:	b8 07 00 00 00       	mov    $0x7,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <open>:
SYSCALL(open)
 5e1:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <mknod>:
SYSCALL(mknod)
 5e9:	b8 11 00 00 00       	mov    $0x11,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <unlink>:
SYSCALL(unlink)
 5f1:	b8 12 00 00 00       	mov    $0x12,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <fstat>:
SYSCALL(fstat)
 5f9:	b8 08 00 00 00       	mov    $0x8,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <link>:
SYSCALL(link)
 601:	b8 13 00 00 00       	mov    $0x13,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <mkdir>:
SYSCALL(mkdir)
 609:	b8 14 00 00 00       	mov    $0x14,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <chdir>:
SYSCALL(chdir)
 611:	b8 09 00 00 00       	mov    $0x9,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <dup>:
SYSCALL(dup)
 619:	b8 0a 00 00 00       	mov    $0xa,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <getpid>:
SYSCALL(getpid)
 621:	b8 0b 00 00 00       	mov    $0xb,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <sbrk>:
SYSCALL(sbrk)
 629:	b8 0c 00 00 00       	mov    $0xc,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <sleep>:
SYSCALL(sleep)
 631:	b8 0d 00 00 00       	mov    $0xd,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <uptime>:
SYSCALL(uptime)
 639:	b8 0e 00 00 00       	mov    $0xe,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <mcreate>:
SYSCALL(mcreate)
 641:	b8 16 00 00 00       	mov    $0x16,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <mdelete>:
SYSCALL(mdelete)
 649:	b8 17 00 00 00       	mov    $0x17,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <mlock>:
SYSCALL(mlock)
 651:	b8 18 00 00 00       	mov    $0x18,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <munlock>:
SYSCALL(munlock)
 659:	b8 19 00 00 00       	mov    $0x19,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    

00000661 <waitcv>:
SYSCALL(waitcv)
 661:	b8 1a 00 00 00       	mov    $0x1a,%eax
 666:	cd 40                	int    $0x40
 668:	c3                   	ret    

00000669 <signalcv>:
SYSCALL(signalcv)
 669:	b8 1b 00 00 00       	mov    $0x1b,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <prio_set>:
SYSCALL(prio_set)
 671:	b8 1c 00 00 00       	mov    $0x1c,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <testpqeq>:
SYSCALL(testpqeq)
 679:	b8 1d 00 00 00       	mov    $0x1d,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <testpqdq>:
SYSCALL(testpqdq)
 681:	b8 1e 00 00 00       	mov    $0x1e,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <shmget>:
SYSCALL(shmget)
 689:	b8 1f 00 00 00       	mov    $0x1f,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <shmrem>:
 691:	b8 20 00 00 00       	mov    $0x20,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    
 699:	66 90                	xchg   %ax,%ax
 69b:	66 90                	xchg   %ax,%ax
 69d:	66 90                	xchg   %ax,%ax
 69f:	90                   	nop

000006a0 <printint>:
	write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 3c             	sub    $0x3c,%esp
	char        buf[16];
	int         i, neg;
	uint        x;

	neg = 0;
	if (sgn && xx < 0) {
 6a9:	85 d2                	test   %edx,%edx
{
 6ab:	89 45 c0             	mov    %eax,-0x40(%ebp)
		neg = 1;
		x   = -xx;
 6ae:	89 d0                	mov    %edx,%eax
	if (sgn && xx < 0) {
 6b0:	79 76                	jns    728 <printint+0x88>
 6b2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6b6:	74 70                	je     728 <printint+0x88>
		x   = -xx;
 6b8:	f7 d8                	neg    %eax
		neg = 1;
 6ba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
	} else {
		x = xx;
	}

	i = 0;
 6c1:	31 f6                	xor    %esi,%esi
 6c3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6c6:	eb 0a                	jmp    6d2 <printint+0x32>
 6c8:	90                   	nop
 6c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	do {
		buf[i++] = digits[x % base];
 6d0:	89 fe                	mov    %edi,%esi
 6d2:	31 d2                	xor    %edx,%edx
 6d4:	8d 7e 01             	lea    0x1(%esi),%edi
 6d7:	f7 f1                	div    %ecx
 6d9:	0f b6 92 ec 0a 00 00 	movzbl 0xaec(%edx),%edx
	} while ((x /= base) != 0);
 6e0:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
 6e2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
	} while ((x /= base) != 0);
 6e5:	75 e9                	jne    6d0 <printint+0x30>
	if (neg) buf[i++] = '-';
 6e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6ea:	85 c0                	test   %eax,%eax
 6ec:	74 08                	je     6f6 <printint+0x56>
 6ee:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 6f3:	8d 7e 02             	lea    0x2(%esi),%edi
 6f6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 6fa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
 700:	0f b6 06             	movzbl (%esi),%eax
	write(fd, &c, 1);
 703:	83 ec 04             	sub    $0x4,%esp
 706:	83 ee 01             	sub    $0x1,%esi
 709:	6a 01                	push   $0x1
 70b:	53                   	push   %ebx
 70c:	57                   	push   %edi
 70d:	88 45 d7             	mov    %al,-0x29(%ebp)
 710:	e8 ac fe ff ff       	call   5c1 <write>

	while (--i >= 0) putc(fd, buf[i]);
 715:	83 c4 10             	add    $0x10,%esp
 718:	39 de                	cmp    %ebx,%esi
 71a:	75 e4                	jne    700 <printint+0x60>
}
 71c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 71f:	5b                   	pop    %ebx
 720:	5e                   	pop    %esi
 721:	5f                   	pop    %edi
 722:	5d                   	pop    %ebp
 723:	c3                   	ret    
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	neg = 0;
 728:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 72f:	eb 90                	jmp    6c1 <printint+0x21>
 731:	eb 0d                	jmp    740 <printf>
 733:	90                   	nop
 734:	90                   	nop
 735:	90                   	nop
 736:	90                   	nop
 737:	90                   	nop
 738:	90                   	nop
 739:	90                   	nop
 73a:	90                   	nop
 73b:	90                   	nop
 73c:	90                   	nop
 73d:	90                   	nop
 73e:	90                   	nop
 73f:	90                   	nop

00000740 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	57                   	push   %edi
 744:	56                   	push   %esi
 745:	53                   	push   %ebx
 746:	83 ec 2c             	sub    $0x2c,%esp
	int   c, i, state;
	uint *ap;

	state = 0;
	ap    = (uint *)(void *)&fmt + 1;
	for (i = 0; fmt[i]; i++) {
 749:	8b 75 0c             	mov    0xc(%ebp),%esi
 74c:	0f b6 1e             	movzbl (%esi),%ebx
 74f:	84 db                	test   %bl,%bl
 751:	0f 84 b3 00 00 00    	je     80a <printf+0xca>
	ap    = (uint *)(void *)&fmt + 1;
 757:	8d 45 10             	lea    0x10(%ebp),%eax
 75a:	83 c6 01             	add    $0x1,%esi
	state = 0;
 75d:	31 ff                	xor    %edi,%edi
	ap    = (uint *)(void *)&fmt + 1;
 75f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 762:	eb 2f                	jmp    793 <printf+0x53>
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = fmt[i] & 0xff;
		if (state == 0) {
			if (c == '%') {
 768:	83 f8 25             	cmp    $0x25,%eax
 76b:	0f 84 a7 00 00 00    	je     818 <printf+0xd8>
	write(fd, &c, 1);
 771:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 774:	83 ec 04             	sub    $0x4,%esp
 777:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 77a:	6a 01                	push   $0x1
 77c:	50                   	push   %eax
 77d:	ff 75 08             	pushl  0x8(%ebp)
 780:	e8 3c fe ff ff       	call   5c1 <write>
 785:	83 c4 10             	add    $0x10,%esp
 788:	83 c6 01             	add    $0x1,%esi
	for (i = 0; fmt[i]; i++) {
 78b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 78f:	84 db                	test   %bl,%bl
 791:	74 77                	je     80a <printf+0xca>
		if (state == 0) {
 793:	85 ff                	test   %edi,%edi
		c = fmt[i] & 0xff;
 795:	0f be cb             	movsbl %bl,%ecx
 798:	0f b6 c3             	movzbl %bl,%eax
		if (state == 0) {
 79b:	74 cb                	je     768 <printf+0x28>
				state = '%';
			} else {
				putc(fd, c);
			}
		} else if (state == '%') {
 79d:	83 ff 25             	cmp    $0x25,%edi
 7a0:	75 e6                	jne    788 <printf+0x48>
			if (c == 'd') {
 7a2:	83 f8 64             	cmp    $0x64,%eax
 7a5:	0f 84 05 01 00 00    	je     8b0 <printf+0x170>
				printint(fd, *ap, 10, 1);
				ap++;
			} else if (c == 'x' || c == 'p') {
 7ab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7b1:	83 f9 70             	cmp    $0x70,%ecx
 7b4:	74 72                	je     828 <printf+0xe8>
				printint(fd, *ap, 16, 0);
				ap++;
			} else if (c == 's') {
 7b6:	83 f8 73             	cmp    $0x73,%eax
 7b9:	0f 84 99 00 00 00    	je     858 <printf+0x118>
				if (s == 0) s = "(null)";
				while (*s != 0) {
					putc(fd, *s);
					s++;
				}
			} else if (c == 'c') {
 7bf:	83 f8 63             	cmp    $0x63,%eax
 7c2:	0f 84 08 01 00 00    	je     8d0 <printf+0x190>
				putc(fd, *ap);
				ap++;
			} else if (c == '%') {
 7c8:	83 f8 25             	cmp    $0x25,%eax
 7cb:	0f 84 ef 00 00 00    	je     8c0 <printf+0x180>
	write(fd, &c, 1);
 7d1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7d4:	83 ec 04             	sub    $0x4,%esp
 7d7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7db:	6a 01                	push   $0x1
 7dd:	50                   	push   %eax
 7de:	ff 75 08             	pushl  0x8(%ebp)
 7e1:	e8 db fd ff ff       	call   5c1 <write>
 7e6:	83 c4 0c             	add    $0xc,%esp
 7e9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 7ec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 7ef:	6a 01                	push   $0x1
 7f1:	50                   	push   %eax
 7f2:	ff 75 08             	pushl  0x8(%ebp)
 7f5:	83 c6 01             	add    $0x1,%esi
			} else {
				// Unknown % sequence.  Print it to draw attention.
				putc(fd, '%');
				putc(fd, c);
			}
			state = 0;
 7f8:	31 ff                	xor    %edi,%edi
	write(fd, &c, 1);
 7fa:	e8 c2 fd ff ff       	call   5c1 <write>
	for (i = 0; fmt[i]; i++) {
 7ff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
	write(fd, &c, 1);
 803:	83 c4 10             	add    $0x10,%esp
	for (i = 0; fmt[i]; i++) {
 806:	84 db                	test   %bl,%bl
 808:	75 89                	jne    793 <printf+0x53>
		}
	}
}
 80a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 80d:	5b                   	pop    %ebx
 80e:	5e                   	pop    %esi
 80f:	5f                   	pop    %edi
 810:	5d                   	pop    %ebp
 811:	c3                   	ret    
 812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				state = '%';
 818:	bf 25 00 00 00       	mov    $0x25,%edi
 81d:	e9 66 ff ff ff       	jmp    788 <printf+0x48>
 822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				printint(fd, *ap, 16, 0);
 828:	83 ec 0c             	sub    $0xc,%esp
 82b:	b9 10 00 00 00       	mov    $0x10,%ecx
 830:	6a 00                	push   $0x0
 832:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 835:	8b 45 08             	mov    0x8(%ebp),%eax
 838:	8b 17                	mov    (%edi),%edx
 83a:	e8 61 fe ff ff       	call   6a0 <printint>
				ap++;
 83f:	89 f8                	mov    %edi,%eax
 841:	83 c4 10             	add    $0x10,%esp
			state = 0;
 844:	31 ff                	xor    %edi,%edi
				ap++;
 846:	83 c0 04             	add    $0x4,%eax
 849:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 84c:	e9 37 ff ff ff       	jmp    788 <printf+0x48>
 851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				s = (char *)*ap;
 858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 85b:	8b 08                	mov    (%eax),%ecx
				ap++;
 85d:	83 c0 04             	add    $0x4,%eax
 860:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if (s == 0) s = "(null)";
 863:	85 c9                	test   %ecx,%ecx
 865:	0f 84 8e 00 00 00    	je     8f9 <printf+0x1b9>
				while (*s != 0) {
 86b:	0f b6 01             	movzbl (%ecx),%eax
			state = 0;
 86e:	31 ff                	xor    %edi,%edi
				s = (char *)*ap;
 870:	89 cb                	mov    %ecx,%ebx
				while (*s != 0) {
 872:	84 c0                	test   %al,%al
 874:	0f 84 0e ff ff ff    	je     788 <printf+0x48>
 87a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 87d:	89 de                	mov    %ebx,%esi
 87f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 882:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 885:	8d 76 00             	lea    0x0(%esi),%esi
	write(fd, &c, 1);
 888:	83 ec 04             	sub    $0x4,%esp
					s++;
 88b:	83 c6 01             	add    $0x1,%esi
 88e:	88 45 e3             	mov    %al,-0x1d(%ebp)
	write(fd, &c, 1);
 891:	6a 01                	push   $0x1
 893:	57                   	push   %edi
 894:	53                   	push   %ebx
 895:	e8 27 fd ff ff       	call   5c1 <write>
				while (*s != 0) {
 89a:	0f b6 06             	movzbl (%esi),%eax
 89d:	83 c4 10             	add    $0x10,%esp
 8a0:	84 c0                	test   %al,%al
 8a2:	75 e4                	jne    888 <printf+0x148>
 8a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
			state = 0;
 8a7:	31 ff                	xor    %edi,%edi
 8a9:	e9 da fe ff ff       	jmp    788 <printf+0x48>
 8ae:	66 90                	xchg   %ax,%ax
				printint(fd, *ap, 10, 1);
 8b0:	83 ec 0c             	sub    $0xc,%esp
 8b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8b8:	6a 01                	push   $0x1
 8ba:	e9 73 ff ff ff       	jmp    832 <printf+0xf2>
 8bf:	90                   	nop
	write(fd, &c, 1);
 8c0:	83 ec 04             	sub    $0x4,%esp
 8c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8c9:	6a 01                	push   $0x1
 8cb:	e9 21 ff ff ff       	jmp    7f1 <printf+0xb1>
				putc(fd, *ap);
 8d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	write(fd, &c, 1);
 8d3:	83 ec 04             	sub    $0x4,%esp
				putc(fd, *ap);
 8d6:	8b 07                	mov    (%edi),%eax
	write(fd, &c, 1);
 8d8:	6a 01                	push   $0x1
				ap++;
 8da:	83 c7 04             	add    $0x4,%edi
				putc(fd, *ap);
 8dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
	write(fd, &c, 1);
 8e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 8e3:	50                   	push   %eax
 8e4:	ff 75 08             	pushl  0x8(%ebp)
 8e7:	e8 d5 fc ff ff       	call   5c1 <write>
				ap++;
 8ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 8ef:	83 c4 10             	add    $0x10,%esp
			state = 0;
 8f2:	31 ff                	xor    %edi,%edi
 8f4:	e9 8f fe ff ff       	jmp    788 <printf+0x48>
				if (s == 0) s = "(null)";
 8f9:	bb e2 0a 00 00       	mov    $0xae2,%ebx
				while (*s != 0) {
 8fe:	b8 28 00 00 00       	mov    $0x28,%eax
 903:	e9 72 ff ff ff       	jmp    87a <printf+0x13a>
 908:	66 90                	xchg   %ax,%ax
 90a:	66 90                	xchg   %ax,%ax
 90c:	66 90                	xchg   %ax,%ax
 90e:	66 90                	xchg   %ax,%ax

00000910 <free>:
static Header  base;
static Header *freep;

void
free(void *ap)
{
 910:	55                   	push   %ebp
	Header *bp, *p;

	bp = (Header *)ap - 1;
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 911:	a1 5c 0e 00 00       	mov    0xe5c,%eax
{
 916:	89 e5                	mov    %esp,%ebp
 918:	57                   	push   %edi
 919:	56                   	push   %esi
 91a:	53                   	push   %ebx
 91b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp = (Header *)ap - 1;
 91e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 928:	39 c8                	cmp    %ecx,%eax
 92a:	8b 10                	mov    (%eax),%edx
 92c:	73 32                	jae    960 <free+0x50>
 92e:	39 d1                	cmp    %edx,%ecx
 930:	72 04                	jb     936 <free+0x26>
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 932:	39 d0                	cmp    %edx,%eax
 934:	72 32                	jb     968 <free+0x58>
	if (bp + bp->s.size == p->s.ptr) {
 936:	8b 73 fc             	mov    -0x4(%ebx),%esi
 939:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 93c:	39 fa                	cmp    %edi,%edx
 93e:	74 30                	je     970 <free+0x60>
		bp->s.size += p->s.ptr->s.size;
		bp->s.ptr = p->s.ptr->s.ptr;
	} else
		bp->s.ptr = p->s.ptr;
 940:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 943:	8b 50 04             	mov    0x4(%eax),%edx
 946:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 949:	39 f1                	cmp    %esi,%ecx
 94b:	74 3a                	je     987 <free+0x77>
		p->s.size += bp->s.size;
		p->s.ptr = bp->s.ptr;
	} else
		p->s.ptr = bp;
 94d:	89 08                	mov    %ecx,(%eax)
	freep = p;
 94f:	a3 5c 0e 00 00       	mov    %eax,0xe5c
}
 954:	5b                   	pop    %ebx
 955:	5e                   	pop    %esi
 956:	5f                   	pop    %edi
 957:	5d                   	pop    %ebp
 958:	c3                   	ret    
 959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (p >= p->s.ptr && (bp > p || bp < p->s.ptr)) break;
 960:	39 d0                	cmp    %edx,%eax
 962:	72 04                	jb     968 <free+0x58>
 964:	39 d1                	cmp    %edx,%ecx
 966:	72 ce                	jb     936 <free+0x26>
{
 968:	89 d0                	mov    %edx,%eax
 96a:	eb bc                	jmp    928 <free+0x18>
 96c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		bp->s.size += p->s.ptr->s.size;
 970:	03 72 04             	add    0x4(%edx),%esi
 973:	89 73 fc             	mov    %esi,-0x4(%ebx)
		bp->s.ptr = p->s.ptr->s.ptr;
 976:	8b 10                	mov    (%eax),%edx
 978:	8b 12                	mov    (%edx),%edx
 97a:	89 53 f8             	mov    %edx,-0x8(%ebx)
	if (p + p->s.size == bp) {
 97d:	8b 50 04             	mov    0x4(%eax),%edx
 980:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 983:	39 f1                	cmp    %esi,%ecx
 985:	75 c6                	jne    94d <free+0x3d>
		p->s.size += bp->s.size;
 987:	03 53 fc             	add    -0x4(%ebx),%edx
	freep = p;
 98a:	a3 5c 0e 00 00       	mov    %eax,0xe5c
		p->s.size += bp->s.size;
 98f:	89 50 04             	mov    %edx,0x4(%eax)
		p->s.ptr = bp->s.ptr;
 992:	8b 53 f8             	mov    -0x8(%ebx),%edx
 995:	89 10                	mov    %edx,(%eax)
}
 997:	5b                   	pop    %ebx
 998:	5e                   	pop    %esi
 999:	5f                   	pop    %edi
 99a:	5d                   	pop    %ebp
 99b:	c3                   	ret    
 99c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009a0 <malloc>:
	return freep;
}

void *
malloc(uint nbytes)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	57                   	push   %edi
 9a4:	56                   	push   %esi
 9a5:	53                   	push   %ebx
 9a6:	83 ec 0c             	sub    $0xc,%esp
	Header *p, *prevp;
	uint    nunits;

	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9a9:	8b 45 08             	mov    0x8(%ebp),%eax
	if ((prevp = freep) == 0) {
 9ac:	8b 15 5c 0e 00 00    	mov    0xe5c,%edx
	nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9b2:	8d 78 07             	lea    0x7(%eax),%edi
 9b5:	c1 ef 03             	shr    $0x3,%edi
 9b8:	83 c7 01             	add    $0x1,%edi
	if ((prevp = freep) == 0) {
 9bb:	85 d2                	test   %edx,%edx
 9bd:	0f 84 9d 00 00 00    	je     a60 <malloc+0xc0>
 9c3:	8b 02                	mov    (%edx),%eax
 9c5:	8b 48 04             	mov    0x4(%eax),%ecx
		base.s.ptr = freep = prevp = &base;
		base.s.size                = 0;
	}
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
		if (p->s.size >= nunits) {
 9c8:	39 cf                	cmp    %ecx,%edi
 9ca:	76 6c                	jbe    a38 <malloc+0x98>
 9cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9d7:	0f 43 df             	cmovae %edi,%ebx
	p = sbrk(nu * sizeof(Header));
 9da:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 9e1:	eb 0e                	jmp    9f1 <malloc+0x51>
 9e3:	90                   	nop
 9e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9e8:	8b 02                	mov    (%edx),%eax
		if (p->s.size >= nunits) {
 9ea:	8b 48 04             	mov    0x4(%eax),%ecx
 9ed:	39 f9                	cmp    %edi,%ecx
 9ef:	73 47                	jae    a38 <malloc+0x98>
				p->s.size = nunits;
			}
			freep = prevp;
			return (void *)(p + 1);
		}
		if (p == freep)
 9f1:	39 05 5c 0e 00 00    	cmp    %eax,0xe5c
 9f7:	89 c2                	mov    %eax,%edx
 9f9:	75 ed                	jne    9e8 <malloc+0x48>
	p = sbrk(nu * sizeof(Header));
 9fb:	83 ec 0c             	sub    $0xc,%esp
 9fe:	56                   	push   %esi
 9ff:	e8 25 fc ff ff       	call   629 <sbrk>
	if (p == (char *)-1) return 0;
 a04:	83 c4 10             	add    $0x10,%esp
 a07:	83 f8 ff             	cmp    $0xffffffff,%eax
 a0a:	74 1c                	je     a28 <malloc+0x88>
	hp->s.size = nu;
 a0c:	89 58 04             	mov    %ebx,0x4(%eax)
	free((void *)(hp + 1));
 a0f:	83 ec 0c             	sub    $0xc,%esp
 a12:	83 c0 08             	add    $0x8,%eax
 a15:	50                   	push   %eax
 a16:	e8 f5 fe ff ff       	call   910 <free>
	return freep;
 a1b:	8b 15 5c 0e 00 00    	mov    0xe5c,%edx
			if ((p = morecore(nunits)) == 0) return 0;
 a21:	83 c4 10             	add    $0x10,%esp
 a24:	85 d2                	test   %edx,%edx
 a26:	75 c0                	jne    9e8 <malloc+0x48>
	}
}
 a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
			if ((p = morecore(nunits)) == 0) return 0;
 a2b:	31 c0                	xor    %eax,%eax
}
 a2d:	5b                   	pop    %ebx
 a2e:	5e                   	pop    %esi
 a2f:	5f                   	pop    %edi
 a30:	5d                   	pop    %ebp
 a31:	c3                   	ret    
 a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			if (p->s.size == nunits)
 a38:	39 cf                	cmp    %ecx,%edi
 a3a:	74 54                	je     a90 <malloc+0xf0>
				p->s.size -= nunits;
 a3c:	29 f9                	sub    %edi,%ecx
 a3e:	89 48 04             	mov    %ecx,0x4(%eax)
				p += p->s.size;
 a41:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
				p->s.size = nunits;
 a44:	89 78 04             	mov    %edi,0x4(%eax)
			freep = prevp;
 a47:	89 15 5c 0e 00 00    	mov    %edx,0xe5c
}
 a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return (void *)(p + 1);
 a50:	83 c0 08             	add    $0x8,%eax
}
 a53:	5b                   	pop    %ebx
 a54:	5e                   	pop    %esi
 a55:	5f                   	pop    %edi
 a56:	5d                   	pop    %ebp
 a57:	c3                   	ret    
 a58:	90                   	nop
 a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		base.s.ptr = freep = prevp = &base;
 a60:	c7 05 5c 0e 00 00 60 	movl   $0xe60,0xe5c
 a67:	0e 00 00 
 a6a:	c7 05 60 0e 00 00 60 	movl   $0xe60,0xe60
 a71:	0e 00 00 
		base.s.size                = 0;
 a74:	b8 60 0e 00 00       	mov    $0xe60,%eax
 a79:	c7 05 64 0e 00 00 00 	movl   $0x0,0xe64
 a80:	00 00 00 
 a83:	e9 44 ff ff ff       	jmp    9cc <malloc+0x2c>
 a88:	90                   	nop
 a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
				prevp->s.ptr = p->s.ptr;
 a90:	8b 08                	mov    (%eax),%ecx
 a92:	89 0a                	mov    %ecx,(%edx)
 a94:	eb b1                	jmp    a47 <malloc+0xa7>
