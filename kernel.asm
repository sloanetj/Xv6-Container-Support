
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2e 10 80       	mov    $0x80102ee0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
	struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

	// PAGEBREAK!
	// Create linked list of buffers
	bcache.head.prev = &bcache.head;
	bcache.head.next = &bcache.head;
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
	initlock(&bcache.lock, "bcache");
8010004c:	68 20 81 10 80       	push   $0x80108120
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 b5 49 00 00       	call   80104a10 <initlock>
	bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
80100062:	0c 11 80 
	bcache.head.next = &bcache.head;
80100065:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 0c 11 80       	mov    $0x80110cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
		b->next = bcache.head.next;
		b->prev = &bcache.head;
		initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
		b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
		b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
		initsleeplock(&b->lock, "buffer");
80100092:	68 27 81 10 80       	push   $0x80108127
80100097:	50                   	push   %eax
80100098:	e8 63 48 00 00       	call   80104900 <initsleeplock>
		bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
		bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
		bcache.head.next       = b;
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000b6:	3d dc 0c 11 80       	cmp    $0x80110cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
	}
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	acquire(&bcache.lock);
801000df:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e4:	e8 17 4a 00 00       	call   80104b00 <acquire>
	for (b = bcache.head.next; b != &bcache.head; b = b->next) {
801000e9:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
		if (b->dev == dev && b->blockno == blockno) {
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
			b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
		if (b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
			b->dev     = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
			b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
			b->flags   = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
			b->refcnt  = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
			release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 b9 4a 00 00       	call   80104c20 <release>
			acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 47 00 00       	call   80104940 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
	struct buf *b;

	b = bget(dev, blockno);
	if ((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
		iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 1f 00 00       	call   80102160 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
	}
	return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
	panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 81 10 80       	push   $0x8010812e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!holdingsleep(&b->lock)) panic("bwrite");
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 2d 48 00 00       	call   801049e0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
	b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
	iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
	iderw(b);
801001c4:	e9 97 1f 00 00       	jmp    80102160 <iderw>
	if (!holdingsleep(&b->lock)) panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 81 10 80       	push   $0x8010813f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!holdingsleep(&b->lock)) panic("brelse");
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ec 47 00 00       	call   801049e0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>

	releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 47 00 00       	call   801049a0 <releasesleep>

	acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 f0 48 00 00       	call   80104b00 <acquire>
	b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
	if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
	b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
	if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
	b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
	if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
		// no one is waiting for it.
		b->next->prev          = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
		b->prev->next          = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
		b->next                = bcache.head.next;
80100232:	a1 30 0d 11 80       	mov    0x80110d30,%eax
		b->prev                = &bcache.head;
80100237:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
		b->next                = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
		bcache.head.next->prev = b;
80100241:	a1 30 0d 11 80       	mov    0x80110d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
		bcache.head.next       = b;
80100249:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
	}

	release(&bcache.lock);
8010024f:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
	release(&bcache.lock);
8010025c:	e9 bf 49 00 00       	jmp    80104c20 <release>
	if (!holdingsleep(&b->lock)) panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 81 10 80       	push   $0x80108146
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
	}
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
	uint target;
	int  c;

	iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 15 00 00       	call   801017a0 <iunlock>
	target = n;
	acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 6f 48 00 00       	call   80104b00 <acquire>
	while (n > 0) {
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
		while (input.r == input.w) {
801002a1:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002a7:	39 15 c4 0f 11 80    	cmp    %edx,0x80110fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			if (myproc()->killed) {
				release(&cons.lock);
				ilock(ip);
				return -1;
			}
			sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 c0 0f 11 80       	push   $0x80110fc0
801002c5:	e8 e6 3f 00 00       	call   801042b0 <sleep>
		while (input.r == input.w) {
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
			if (myproc()->killed) {
801002db:	e8 30 36 00 00       	call   80103910 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
				release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 2c 49 00 00       	call   80104c20 <release>
				ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 13 00 00       	call   801016c0 <ilock>
				return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
	}
	release(&cons.lock);
	ilock(ip);

	return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
				return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 0f 11 80 	movsbl -0x7feef0c0(%eax),%eax
		if (c == C('D')) { // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
		*dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
		--n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
		if (c == '\n') break;
8010032f:	83 f8 0a             	cmp    $0xa,%eax
		*dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
		if (c == '\n') break;
80100335:	74 43                	je     8010037a <consoleread+0x10a>
	while (n > 0) {
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
	release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ce 48 00 00       	call   80104c20 <release>
	ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 13 00 00       	call   801016c0 <ilock>
	return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
			if (n < target) {
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
				input.r--;
80100372:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
	asm volatile("cli");
80100398:	fa                   	cli    
	cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
	getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
	cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 23 00 00       	call   80102770 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 81 10 80       	push   $0x8010814d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
	cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
	cprintf("\n");
801003c5:	c7 04 24 0f 8b 10 80 	movl   $0x80108b0f,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
	getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 46 00 00       	call   80104a30 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 10; i++) cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 81 10 80       	push   $0x80108161
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
	panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
	if (panicked) {
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
	if (c == BACKSPACE) {
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
		uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 81 66 00 00       	call   80106ac0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
	pos = inb(CRTPORT + 1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
	pos |= inb(CRTPORT + 1);
8010046d:	09 fb                	or     %edi,%ebx
	if (c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
	else if (c == BACKSPACE) {
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
		crt[pos++] = (c & 0xff) | 0x0700; // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
	if (pos < 0 || pos > 25 * 80) panic("pos under/overflow");
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
	if ((pos / 80) >= 24) { // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
	outb(CRTPORT + 1, pos >> 8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
	crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
		uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 cf 65 00 00       	call   80106ac0 <uartputc>
		uartputc(' ');
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 65 00 00       	call   80106ac0 <uartputc>
		uartputc('\b');
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 65 00 00       	call   80106ac0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
		memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
		pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
		memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 07 48 00 00       	call   80104d30 <memmove>
		memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 3a 47 00 00       	call   80104c80 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
	if (pos < 0 || pos > 25 * 80) panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 81 10 80       	push   $0x80108165
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
		if (pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
		pos += 80 - pos % 80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
	if (sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
	if (sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
		x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 81 10 80 	movzbl -0x7fef7e70(%edx),%edx
	} while ((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
		buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
	} while ((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
	if (sign) buf[i++] = '-';
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while (--i >= 0) consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
		x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
	int i;

	iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 8c 11 00 00       	call   801017a0 <iunlock>
	acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 e0 44 00 00       	call   80104b00 <acquire>
	for (i = 0; i < n; i++) consputc(buf[i] & 0xff);
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
	release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 d4 45 00 00       	call   80104c20 <release>
	ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 10 00 00       	call   801016c0 <ilock>

	return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
	locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
	if (locking) acquire(&cons.lock);
8010066e:	85 c0                	test   %eax,%eax
	locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (locking) acquire(&cons.lock);
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
	if (fmt == 0) panic("null fmt");
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100686:	0f b6 00             	movzbl (%eax),%eax
	argp = (uint *)(void *)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010068c:	31 db                	xor    %ebx,%ebx
	argp = (uint *)(void *)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
		if (c == 0) break;
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
		switch (c) {
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
			printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
		if (c != '%') {
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
			consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801006fe:	0f b6 06             	movzbl (%esi),%eax
			continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (locking) release(&cons.lock);
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 fc 44 00 00       	call   80104c20 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
		switch (c) {
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
			printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
			break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
			consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
			break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if ((s = (char *)*argp++) == 0) s = "(null)";
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
			for (; *s; s++) consputc(*s);
80100787:	0f be 02             	movsbl (%edx),%eax
			if ((s = (char *)*argp++) == 0) s = "(null)";
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
			for (; *s; s++) consputc(*s);
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
			if ((s = (char *)*argp++) == 0) s = "(null)";
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
			consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
			break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
			if ((s = (char *)*argp++) == 0) s = "(null)";
801007d0:	ba 78 81 10 80       	mov    $0x80108178,%edx
			for (; *s; s++) consputc(*s);
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (locking) acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 0b 43 00 00       	call   80104b00 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
	if (fmt == 0) panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 81 10 80       	push   $0x8010817f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
	int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 d8 42 00 00       	call   80104b00 <acquire>
	while ((c = getc()) >= 0) {
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
		switch (c) {
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
			if (input.e != input.w) {
80100851:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100856:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
				input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
				consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
	while ((c = getc()) >= 0) {
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 93 43 00 00       	call   80104c20 <release>
	if (doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
		switch (c) {
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
			if (c != 0 && input.e - input.r < INPUT_BUF) {
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
				c                                = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
				input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 0f 11 80    	mov    %edx,0x80110fc8
				c                                = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
				input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 0f 11 80    	mov    %cl,-0x7feef0c0(%eax)
				consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
				if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
					wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
					input.w = input.e;
8010090c:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
					wakeup(&input.r);
80100911:	68 c0 0f 11 80       	push   $0x80110fc0
80100916:	e8 55 3b 00 00       	call   80104470 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
80100938:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010093d:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				input.e--;
80100950:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
				consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
			while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
8010095f:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100964:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
80100978:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
		procdump(); // now call procdump() wo. cons.lock held
80100997:	e9 04 3c 00 00       	jmp    801045a0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
				consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
	initlock(&cons.lock, "console");
801009c6:	68 88 81 10 80       	push   $0x80108188
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 3b 40 00 00       	call   80104a10 <initlock>

	devsw[CONSOLE].write = consolewrite;
	devsw[CONSOLE].read  = consoleread;
	cons.locking         = 1;

	ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
	devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ec d6 12 80 00 	movl   $0x80100600,0x8012d6ec
801009e2:	06 10 80 
	devsw[CONSOLE].read  = consoleread;
801009e5:	c7 05 e8 d6 12 80 70 	movl   $0x80100270,0x8012d6e8
801009ec:	02 10 80 
	cons.locking         = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
	ioapicenable(IRQ_KBD, 0);
801009f9:	e8 12 19 00 00       	call   80102310 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	uint           argc, sz, sp, ustack[3 + MAXARG + 1];
	struct elfhdr  elf;
	struct inode * ip;
	struct proghdr ph;
	pde_t *        pgdir, *oldpgdir;
	struct proc *  curproc = myproc();
80100a1c:	e8 ef 2e 00 00       	call   80103910 <myproc>
80100a21:	89 c6                	mov    %eax,%esi

	begin_op();
80100a23:	e8 b8 21 00 00       	call   80102be0 <begin_op>
80100a28:	8d 86 d0 00 00 00    	lea    0xd0(%esi),%eax
80100a2e:	8d 96 50 01 00 00    	lea    0x150(%esi),%edx
80100a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  //initialize shared memory array in process
	int pg_num;
	for(pg_num = 0; pg_num < SHM_MAXNUM; pg_num++)
	{
		curproc->shmpgs[pg_num] = 0;
80100a38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80100a3e:	83 c0 04             	add    $0x4,%eax
	for(pg_num = 0; pg_num < SHM_MAXNUM; pg_num++)
80100a41:	39 d0                	cmp    %edx,%eax
80100a43:	75 f3                	jne    80100a38 <exec+0x28>
	}

	if ((ip = namei(path)) == 0) {
80100a45:	83 ec 0c             	sub    $0xc,%esp
80100a48:	ff 75 08             	pushl  0x8(%ebp)
80100a4b:	e8 d0 14 00 00       	call   80101f20 <namei>
80100a50:	83 c4 10             	add    $0x10,%esp
80100a53:	85 c0                	test   %eax,%eax
80100a55:	89 c3                	mov    %eax,%ebx
80100a57:	0f 84 a2 01 00 00    	je     80100bff <exec+0x1ef>
		end_op();
		cprintf("exec: fail\n");
		return -1;
	}
	ilock(ip);
80100a5d:	83 ec 0c             	sub    $0xc,%esp
80100a60:	50                   	push   %eax
80100a61:	e8 5a 0c 00 00       	call   801016c0 <ilock>
	pgdir = 0;

	// Check ELF header
	if (readi(ip, (char *)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
80100a66:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a6c:	6a 34                	push   $0x34
80100a6e:	6a 00                	push   $0x0
80100a70:	50                   	push   %eax
80100a71:	53                   	push   %ebx
80100a72:	e8 29 0f 00 00       	call   801019a0 <readi>
80100a77:	83 c4 20             	add    $0x20,%esp
80100a7a:	83 f8 34             	cmp    $0x34,%eax
80100a7d:	74 21                	je     80100aa0 <exec+0x90>
	return 0;

bad:
	if (pgdir) freevm(pgdir);
	if (ip) {
		iunlockput(ip);
80100a7f:	83 ec 0c             	sub    $0xc,%esp
80100a82:	53                   	push   %ebx
80100a83:	e8 c8 0e 00 00       	call   80101950 <iunlockput>
		end_op();
80100a88:	e8 c3 21 00 00       	call   80102c50 <end_op>
80100a8d:	83 c4 10             	add    $0x10,%esp
	}
	return -1;
80100a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a98:	5b                   	pop    %ebx
80100a99:	5e                   	pop    %esi
80100a9a:	5f                   	pop    %edi
80100a9b:	5d                   	pop    %ebp
80100a9c:	c3                   	ret    
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
	if (elf.magic != ELF_MAGIC) goto bad;
80100aa0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aa7:	45 4c 46 
80100aaa:	75 d3                	jne    80100a7f <exec+0x6f>
	if ((pgdir = setupkvm()) == 0) goto bad;
80100aac:	e8 af 71 00 00       	call   80107c60 <setupkvm>
80100ab1:	85 c0                	test   %eax,%eax
80100ab3:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ab9:	74 c4                	je     80100a7f <exec+0x6f>
	for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100abb:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ac2:	00 
80100ac3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ac9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100acf:	0f 84 9f 02 00 00    	je     80100d74 <exec+0x364>
	sz = 0;
80100ad5:	31 c0                	xor    %eax,%eax
80100ad7:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
	for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100add:	31 ff                	xor    %edi,%edi
80100adf:	89 c6                	mov    %eax,%esi
80100ae1:	eb 7f                	jmp    80100b62 <exec+0x152>
80100ae3:	90                   	nop
80100ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ph.type != ELF_PROG_LOAD) continue;
80100ae8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aef:	75 63                	jne    80100b54 <exec+0x144>
		if (ph.memsz < ph.filesz) goto bad;
80100af1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100af7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100afd:	0f 82 86 00 00 00    	jb     80100b89 <exec+0x179>
80100b03:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b09:	72 7e                	jb     80100b89 <exec+0x179>
		if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0) goto bad;
80100b0b:	83 ec 04             	sub    $0x4,%esp
80100b0e:	50                   	push   %eax
80100b0f:	56                   	push   %esi
80100b10:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b16:	e8 65 6f 00 00       	call   80107a80 <allocuvm>
80100b1b:	83 c4 10             	add    $0x10,%esp
80100b1e:	85 c0                	test   %eax,%eax
80100b20:	89 c6                	mov    %eax,%esi
80100b22:	74 65                	je     80100b89 <exec+0x179>
		if (ph.vaddr % PGSIZE != 0) goto bad;
80100b24:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b2a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b2f:	75 58                	jne    80100b89 <exec+0x179>
		if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
80100b31:	83 ec 0c             	sub    $0xc,%esp
80100b34:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b3a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b40:	53                   	push   %ebx
80100b41:	50                   	push   %eax
80100b42:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b48:	e8 73 6e 00 00       	call   801079c0 <loaduvm>
80100b4d:	83 c4 20             	add    $0x20,%esp
80100b50:	85 c0                	test   %eax,%eax
80100b52:	78 35                	js     80100b89 <exec+0x179>
	for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100b54:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b5b:	83 c7 01             	add    $0x1,%edi
80100b5e:	39 f8                	cmp    %edi,%eax
80100b60:	7e 3d                	jle    80100b9f <exec+0x18f>
		if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
80100b62:	89 f8                	mov    %edi,%eax
80100b64:	6a 20                	push   $0x20
80100b66:	c1 e0 05             	shl    $0x5,%eax
80100b69:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b6f:	50                   	push   %eax
80100b70:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b76:	50                   	push   %eax
80100b77:	53                   	push   %ebx
80100b78:	e8 23 0e 00 00       	call   801019a0 <readi>
80100b7d:	83 c4 10             	add    $0x10,%esp
80100b80:	83 f8 20             	cmp    $0x20,%eax
80100b83:	0f 84 5f ff ff ff    	je     80100ae8 <exec+0xd8>
	if (pgdir) freevm(pgdir);
80100b89:	83 ec 0c             	sub    $0xc,%esp
80100b8c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b92:	e8 49 70 00 00       	call   80107be0 <freevm>
80100b97:	83 c4 10             	add    $0x10,%esp
80100b9a:	e9 e0 fe ff ff       	jmp    80100a7f <exec+0x6f>
80100b9f:	89 f7                	mov    %esi,%edi
80100ba1:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
	iunlockput(ip);
80100ba7:	83 ec 0c             	sub    $0xc,%esp
80100baa:	53                   	push   %ebx
80100bab:	e8 a0 0d 00 00       	call   80101950 <iunlockput>
	end_op();
80100bb0:	e8 9b 20 00 00       	call   80102c50 <end_op>
	sz = PGROUNDUP(sz);
80100bb5:	89 f8                	mov    %edi,%eax
	if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) goto bad;
80100bb7:	83 c4 0c             	add    $0xc,%esp
	sz = PGROUNDUP(sz);
80100bba:	05 ff 0f 00 00       	add    $0xfff,%eax
80100bbf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) goto bad;
80100bc4:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100bca:	52                   	push   %edx
80100bcb:	50                   	push   %eax
80100bcc:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd2:	e8 a9 6e 00 00       	call   80107a80 <allocuvm>
80100bd7:	83 c4 10             	add    $0x10,%esp
80100bda:	85 c0                	test   %eax,%eax
80100bdc:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100be2:	75 3a                	jne    80100c1e <exec+0x20e>
	if (pgdir) freevm(pgdir);
80100be4:	83 ec 0c             	sub    $0xc,%esp
80100be7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bed:	e8 ee 6f 00 00       	call   80107be0 <freevm>
80100bf2:	83 c4 10             	add    $0x10,%esp
	return -1;
80100bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bfa:	e9 96 fe ff ff       	jmp    80100a95 <exec+0x85>
		end_op();
80100bff:	e8 4c 20 00 00       	call   80102c50 <end_op>
		cprintf("exec: fail\n");
80100c04:	83 ec 0c             	sub    $0xc,%esp
80100c07:	68 a1 81 10 80       	push   $0x801081a1
80100c0c:	e8 4f fa ff ff       	call   80100660 <cprintf>
		return -1;
80100c11:	83 c4 10             	add    $0x10,%esp
80100c14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c19:	e9 77 fe ff ff       	jmp    80100a95 <exec+0x85>
	clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c1e:	89 c7                	mov    %eax,%edi
80100c20:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100c26:	83 ec 08             	sub    $0x8,%esp
	for (argc = 0; argv[argc]; argc++) {
80100c29:	31 db                	xor    %ebx,%ebx
	clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100c2b:	50                   	push   %eax
80100c2c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c32:	e8 c9 70 00 00       	call   80107d00 <clearpteu>
	for (argc = 0; argv[argc]; argc++) {
80100c37:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c3a:	83 c4 10             	add    $0x10,%esp
80100c3d:	8b 00                	mov    (%eax),%eax
80100c3f:	85 c0                	test   %eax,%eax
80100c41:	75 12                	jne    80100c55 <exec+0x245>
80100c43:	e9 33 01 00 00       	jmp    80100d7b <exec+0x36b>
80100c48:	90                   	nop
80100c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (argc >= MAXARG) goto bad;
80100c50:	83 fb 20             	cmp    $0x20,%ebx
80100c53:	74 8f                	je     80100be4 <exec+0x1d4>
		sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c55:	83 ec 0c             	sub    $0xc,%esp
80100c58:	50                   	push   %eax
80100c59:	e8 42 42 00 00       	call   80104ea0 <strlen>
80100c5e:	f7 d0                	not    %eax
80100c60:	01 f8                	add    %edi,%eax
80100c62:	83 e0 fc             	and    $0xfffffffc,%eax
80100c65:	89 c7                	mov    %eax,%edi
		if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) goto bad;
80100c67:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c6a:	5a                   	pop    %edx
80100c6b:	ff 34 98             	pushl  (%eax,%ebx,4)
80100c6e:	e8 2d 42 00 00       	call   80104ea0 <strlen>
80100c73:	83 c0 01             	add    $0x1,%eax
80100c76:	50                   	push   %eax
80100c77:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c7a:	ff 34 98             	pushl  (%eax,%ebx,4)
80100c7d:	57                   	push   %edi
80100c7e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c84:	e8 c7 71 00 00       	call   80107e50 <copyout>
80100c89:	83 c4 20             	add    $0x20,%esp
80100c8c:	85 c0                	test   %eax,%eax
80100c8e:	0f 88 50 ff ff ff    	js     80100be4 <exec+0x1d4>
	for (argc = 0; argv[argc]; argc++) {
80100c94:	8b 45 0c             	mov    0xc(%ebp),%eax
		ustack[3 + argc] = sp;
80100c97:	89 bc 9d 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%ebx,4)
	for (argc = 0; argv[argc]; argc++) {
80100c9e:	83 c3 01             	add    $0x1,%ebx
		ustack[3 + argc] = sp;
80100ca1:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
	for (argc = 0; argv[argc]; argc++) {
80100ca7:	8b 04 98             	mov    (%eax,%ebx,4),%eax
80100caa:	85 c0                	test   %eax,%eax
80100cac:	75 a2                	jne    80100c50 <exec+0x240>
	ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100cae:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
80100cb5:	89 fa                	mov    %edi,%edx
	ustack[3 + argc] = 0;
80100cb7:	c7 84 9d 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%ebx,4)
80100cbe:	00 00 00 00 
	ustack[0] = 0xffffffff; // fake return PC
80100cc2:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100cc9:	ff ff ff 
	ustack[1] = argc;
80100ccc:	89 9d 5c ff ff ff    	mov    %ebx,-0xa4(%ebp)
	ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100cd2:	29 c2                	sub    %eax,%edx
	sp -= (3 + argc + 1) * 4;
80100cd4:	83 c0 0c             	add    $0xc,%eax
80100cd7:	29 c7                	sub    %eax,%edi
	if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) goto bad;
80100cd9:	50                   	push   %eax
80100cda:	51                   	push   %ecx
80100cdb:	57                   	push   %edi
80100cdc:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
	ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100ce2:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
	if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) goto bad;
80100ce8:	e8 63 71 00 00       	call   80107e50 <copyout>
80100ced:	83 c4 10             	add    $0x10,%esp
80100cf0:	85 c0                	test   %eax,%eax
80100cf2:	0f 88 ec fe ff ff    	js     80100be4 <exec+0x1d4>
	for (last = s = path; *s; s++)
80100cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80100cfb:	0f b6 00             	movzbl (%eax),%eax
80100cfe:	84 c0                	test   %al,%al
80100d00:	74 17                	je     80100d19 <exec+0x309>
80100d02:	8b 55 08             	mov    0x8(%ebp),%edx
80100d05:	89 d1                	mov    %edx,%ecx
80100d07:	83 c1 01             	add    $0x1,%ecx
80100d0a:	3c 2f                	cmp    $0x2f,%al
80100d0c:	0f b6 01             	movzbl (%ecx),%eax
80100d0f:	0f 44 d1             	cmove  %ecx,%edx
80100d12:	84 c0                	test   %al,%al
80100d14:	75 f1                	jne    80100d07 <exec+0x2f7>
80100d16:	89 55 08             	mov    %edx,0x8(%ebp)
	safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d19:	50                   	push   %eax
80100d1a:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d1d:	6a 10                	push   $0x10
80100d1f:	ff 75 08             	pushl  0x8(%ebp)
80100d22:	50                   	push   %eax
80100d23:	e8 38 41 00 00       	call   80104e60 <safestrcpy>
	oldpgdir         = curproc->pgdir;
80100d28:	8b 46 04             	mov    0x4(%esi),%eax
	curproc->tf->eip = elf.entry; // main
80100d2b:	8b 56 18             	mov    0x18(%esi),%edx
	oldpgdir         = curproc->pgdir;
80100d2e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
	curproc->pgdir   = pgdir;
80100d34:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100d3a:	89 46 04             	mov    %eax,0x4(%esi)
	curproc->sz      = sz;
80100d3d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d43:	89 06                	mov    %eax,(%esi)
	curproc->tf->eip = elf.entry; // main
80100d45:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100d4b:	89 4a 38             	mov    %ecx,0x38(%edx)
	curproc->tf->esp = sp;
80100d4e:	8b 56 18             	mov    0x18(%esi),%edx
80100d51:	89 7a 44             	mov    %edi,0x44(%edx)
	switchuvm(curproc);
80100d54:	89 34 24             	mov    %esi,(%esp)
80100d57:	e8 d4 6a 00 00       	call   80107830 <switchuvm>
	freevm(oldpgdir);
80100d5c:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d62:	89 04 24             	mov    %eax,(%esp)
80100d65:	e8 76 6e 00 00       	call   80107be0 <freevm>
	return 0;
80100d6a:	83 c4 10             	add    $0x10,%esp
80100d6d:	31 c0                	xor    %eax,%eax
80100d6f:	e9 21 fd ff ff       	jmp    80100a95 <exec+0x85>
	sz = 0;
80100d74:	31 ff                	xor    %edi,%edi
80100d76:	e9 2c fe ff ff       	jmp    80100ba7 <exec+0x197>
	for (argc = 0; argv[argc]; argc++) {
80100d7b:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d81:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d87:	e9 22 ff ff ff       	jmp    80100cae <exec+0x29e>
80100d8c:	66 90                	xchg   %ax,%ax
80100d8e:	66 90                	xchg   %ax,%ax

80100d90 <fileinit>:
	struct file     file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 10             	sub    $0x10,%esp
	initlock(&ftable.lock, "ftable");
80100d96:	68 ad 81 10 80       	push   $0x801081ad
80100d9b:	68 40 cd 12 80       	push   $0x8012cd40
80100da0:	e8 6b 3c 00 00       	call   80104a10 <initlock>
}
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	c9                   	leave  
80100da9:	c3                   	ret    
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
	struct file *f;

	acquire(&ftable.lock);
	for (f = ftable.file; f < ftable.file + NFILE; f++) {
80100db4:	bb 74 cd 12 80       	mov    $0x8012cd74,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
	acquire(&ftable.lock);
80100dbc:	68 40 cd 12 80       	push   $0x8012cd40
80100dc1:	e8 3a 3d 00 00       	call   80104b00 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (f = ftable.file; f < ftable.file + NFILE; f++) {
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb d4 d6 12 80    	cmp    $0x8012d6d4,%ebx
80100dd9:	73 25                	jae    80100e00 <filealloc+0x50>
		if (f->ref == 0) {
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
			f->ref = 1;
			release(&ftable.lock);
80100de2:	83 ec 0c             	sub    $0xc,%esp
			f->ref = 1;
80100de5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
			release(&ftable.lock);
80100dec:	68 40 cd 12 80       	push   $0x8012cd40
80100df1:	e8 2a 3e 00 00       	call   80104c20 <release>
			return f;
		}
	}
	release(&ftable.lock);
	return 0;
}
80100df6:	89 d8                	mov    %ebx,%eax
			return f;
80100df8:	83 c4 10             	add    $0x10,%esp
}
80100dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dfe:	c9                   	leave  
80100dff:	c3                   	ret    
	release(&ftable.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
	return 0;
80100e03:	31 db                	xor    %ebx,%ebx
	release(&ftable.lock);
80100e05:	68 40 cd 12 80       	push   $0x8012cd40
80100e0a:	e8 11 3e 00 00       	call   80104c20 <release>
}
80100e0f:	89 d8                	mov    %ebx,%eax
	return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
}
80100e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e17:	c9                   	leave  
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 10             	sub    $0x10,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ftable.lock);
80100e2a:	68 40 cd 12 80       	push   $0x8012cd40
80100e2f:	e8 cc 3c 00 00       	call   80104b00 <acquire>
	if (f->ref < 1) panic("filedup");
80100e34:	8b 43 04             	mov    0x4(%ebx),%eax
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	7e 1a                	jle    80100e58 <filedup+0x38>
	f->ref++;
80100e3e:	83 c0 01             	add    $0x1,%eax
	release(&ftable.lock);
80100e41:	83 ec 0c             	sub    $0xc,%esp
	f->ref++;
80100e44:	89 43 04             	mov    %eax,0x4(%ebx)
	release(&ftable.lock);
80100e47:	68 40 cd 12 80       	push   $0x8012cd40
80100e4c:	e8 cf 3d 00 00       	call   80104c20 <release>
	return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
	if (f->ref < 1) panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 b4 81 10 80       	push   $0x801081b4
80100e60:	e8 2b f5 ff ff       	call   80100390 <panic>
80100e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 28             	sub    $0x28,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct file ff;

	acquire(&ftable.lock);
80100e7c:	68 40 cd 12 80       	push   $0x8012cd40
80100e81:	e8 7a 3c 00 00       	call   80104b00 <acquire>
	if (f->ref < 1) panic("fileclose");
80100e86:	8b 43 04             	mov    0x4(%ebx),%eax
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	0f 8e 9b 00 00 00    	jle    80100f2f <fileclose+0xbf>
	if (--f->ref > 0) {
80100e94:	83 e8 01             	sub    $0x1,%eax
80100e97:	85 c0                	test   %eax,%eax
80100e99:	89 43 04             	mov    %eax,0x4(%ebx)
80100e9c:	74 1a                	je     80100eb8 <fileclose+0x48>
		release(&ftable.lock);
80100e9e:	c7 45 08 40 cd 12 80 	movl   $0x8012cd40,0x8(%ebp)
	else if (ff.type == FD_INODE) {
		begin_op();
		iput(ff.ip);
		end_op();
	}
}
80100ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5f                   	pop    %edi
80100eab:	5d                   	pop    %ebp
		release(&ftable.lock);
80100eac:	e9 6f 3d 00 00       	jmp    80104c20 <release>
80100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	ff      = *f;
80100eb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ebc:	8b 3b                	mov    (%ebx),%edi
	release(&ftable.lock);
80100ebe:	83 ec 0c             	sub    $0xc,%esp
	ff      = *f;
80100ec1:	8b 73 0c             	mov    0xc(%ebx),%esi
	f->type = FD_NONE;
80100ec4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	ff      = *f;
80100eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ecd:	8b 43 10             	mov    0x10(%ebx),%eax
	release(&ftable.lock);
80100ed0:	68 40 cd 12 80       	push   $0x8012cd40
	ff      = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	release(&ftable.lock);
80100ed8:	e8 43 3d 00 00       	call   80104c20 <release>
	if (ff.type == FD_PIPE)
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 ff 01             	cmp    $0x1,%edi
80100ee3:	74 13                	je     80100ef8 <fileclose+0x88>
	else if (ff.type == FD_INODE) {
80100ee5:	83 ff 02             	cmp    $0x2,%edi
80100ee8:	74 26                	je     80100f10 <fileclose+0xa0>
}
80100eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eed:	5b                   	pop    %ebx
80100eee:	5e                   	pop    %esi
80100eef:	5f                   	pop    %edi
80100ef0:	5d                   	pop    %ebp
80100ef1:	c3                   	ret    
80100ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		pipeclose(ff.pipe, ff.writable);
80100ef8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100efc:	83 ec 08             	sub    $0x8,%esp
80100eff:	53                   	push   %ebx
80100f00:	56                   	push   %esi
80100f01:	e8 8a 24 00 00       	call   80103390 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		begin_op();
80100f10:	e8 cb 1c 00 00       	call   80102be0 <begin_op>
		iput(ff.ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1b:	e8 d0 08 00 00       	call   801017f0 <iput>
		end_op();
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
		end_op();
80100f2a:	e9 21 1d 00 00       	jmp    80102c50 <end_op>
	if (f->ref < 1) panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 bc 81 10 80       	push   $0x801081bc
80100f37:	e8 54 f4 ff ff       	call   80100390 <panic>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (f->type == FD_INODE) {
80100f4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f4d:	75 31                	jne    80100f80 <filestat+0x40>
		ilock(f->ip);
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	ff 73 10             	pushl  0x10(%ebx)
80100f55:	e8 66 07 00 00       	call   801016c0 <ilock>
		stati(f->ip, st);
80100f5a:	58                   	pop    %eax
80100f5b:	5a                   	pop    %edx
80100f5c:	ff 75 0c             	pushl  0xc(%ebp)
80100f5f:	ff 73 10             	pushl  0x10(%ebx)
80100f62:	e8 09 0a 00 00       	call   80101970 <stati>
		iunlock(f->ip);
80100f67:	59                   	pop    %ecx
80100f68:	ff 73 10             	pushl  0x10(%ebx)
80100f6b:	e8 30 08 00 00       	call   801017a0 <iunlock>
		return 0;
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	31 c0                	xor    %eax,%eax
	}
	return -1;
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb ee                	jmp    80100f75 <filestat+0x35>
80100f87:	89 f6                	mov    %esi,%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	if (f->readable == 0) return -1;
80100fa2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fa6:	74 60                	je     80101008 <fileread+0x78>
	if (f->type == FD_PIPE) return piperead(f->pipe, addr, n);
80100fa8:	8b 03                	mov    (%ebx),%eax
80100faa:	83 f8 01             	cmp    $0x1,%eax
80100fad:	74 41                	je     80100ff0 <fileread+0x60>
	if (f->type == FD_INODE) {
80100faf:	83 f8 02             	cmp    $0x2,%eax
80100fb2:	75 5b                	jne    8010100f <fileread+0x7f>
		ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 73 10             	pushl  0x10(%ebx)
80100fba:	e8 01 07 00 00       	call   801016c0 <ilock>
		if ((r = readi(f->ip, addr, f->off, n)) > 0) f->off += r;
80100fbf:	57                   	push   %edi
80100fc0:	ff 73 14             	pushl  0x14(%ebx)
80100fc3:	56                   	push   %esi
80100fc4:	ff 73 10             	pushl  0x10(%ebx)
80100fc7:	e8 d4 09 00 00       	call   801019a0 <readi>
80100fcc:	83 c4 20             	add    $0x20,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	89 c6                	mov    %eax,%esi
80100fd3:	7e 03                	jle    80100fd8 <fileread+0x48>
80100fd5:	01 43 14             	add    %eax,0x14(%ebx)
		iunlock(f->ip);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 73 10             	pushl  0x10(%ebx)
80100fde:	e8 bd 07 00 00       	call   801017a0 <iunlock>
		return r;
80100fe3:	83 c4 10             	add    $0x10,%esp
	}
	panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	89 f0                	mov    %esi,%eax
80100feb:	5b                   	pop    %ebx
80100fec:	5e                   	pop    %esi
80100fed:	5f                   	pop    %edi
80100fee:	5d                   	pop    %ebp
80100fef:	c3                   	ret    
	if (f->type == FD_PIPE) return piperead(f->pipe, addr, n);
80100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ff3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	5b                   	pop    %ebx
80100ffa:	5e                   	pop    %esi
80100ffb:	5f                   	pop    %edi
80100ffc:	5d                   	pop    %ebp
	if (f->type == FD_PIPE) return piperead(f->pipe, addr, n);
80100ffd:	e9 3e 25 00 00       	jmp    80103540 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (f->readable == 0) return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
	panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 c6 81 10 80       	push   $0x801081c6
80101017:	e8 74 f3 ff ff       	call   80100390 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filewrite>:

// PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
80101029:	8b 75 08             	mov    0x8(%ebp),%esi
8010102c:	8b 45 0c             	mov    0xc(%ebp),%eax
	int r;

	if (f->writable == 0) return -1;
8010102f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101036:	8b 45 10             	mov    0x10(%ebp),%eax
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (f->writable == 0) return -1;
8010103c:	0f 84 aa 00 00 00    	je     801010ec <filewrite+0xcc>
	if (f->type == FD_PIPE) return pipewrite(f->pipe, addr, n);
80101042:	8b 06                	mov    (%esi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c3 00 00 00    	je     80101110 <filewrite+0xf0>
	if (f->type == FD_INODE) {
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d9 00 00 00    	jne    8010112f <filewrite+0x10f>
		// and 2 blocks of slop for non-aligned writes.
		// this really belongs lower down, since writei()
		// might be writing a device like the console.
		int max = ((LOGSIZE - 1 - 1 - 2) / 2) * 512;
		int i   = 0;
		while (i < n) {
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		int i   = 0;
80101059:	31 ff                	xor    %edi,%edi
		while (i < n) {
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 34                	jg     80101093 <filewrite+0x73>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			int n1 = n - i;
			if (n1 > max) n1= max;

			begin_op();
			ilock(f->ip);
			if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) f->off += r;
80101068:	01 46 14             	add    %eax,0x14(%esi)
			iunlock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
			if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) f->off += r;
80101071:	89 45 e0             	mov    %eax,-0x20(%ebp)
			iunlock(f->ip);
80101074:	e8 27 07 00 00       	call   801017a0 <iunlock>
			end_op();
80101079:	e8 d2 1b 00 00       	call   80102c50 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101081:	83 c4 10             	add    $0x10,%esp

			if (r < 0) break;
			if (r != n1) panic("short filewrite");
80101084:	39 c3                	cmp    %eax,%ebx
80101086:	0f 85 96 00 00 00    	jne    80101122 <filewrite+0x102>
			i += r;
8010108c:	01 df                	add    %ebx,%edi
		while (i < n) {
8010108e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101091:	7e 6d                	jle    80101100 <filewrite+0xe0>
			int n1 = n - i;
80101093:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101096:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010109b:	29 fb                	sub    %edi,%ebx
8010109d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
801010a3:	0f 4f d8             	cmovg  %eax,%ebx
			begin_op();
801010a6:	e8 35 1b 00 00       	call   80102be0 <begin_op>
			ilock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
801010b1:	e8 0a 06 00 00       	call   801016c0 <ilock>
			if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) f->off += r;
801010b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b9:	53                   	push   %ebx
801010ba:	ff 76 14             	pushl  0x14(%esi)
801010bd:	01 f8                	add    %edi,%eax
801010bf:	50                   	push   %eax
801010c0:	ff 76 10             	pushl  0x10(%esi)
801010c3:	e8 d8 09 00 00       	call   80101aa0 <writei>
801010c8:	83 c4 20             	add    $0x20,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 99                	jg     80101068 <filewrite+0x48>
			iunlock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 76 10             	pushl  0x10(%esi)
801010d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010d8:	e8 c3 06 00 00       	call   801017a0 <iunlock>
			end_op();
801010dd:	e8 6e 1b 00 00       	call   80102c50 <end_op>
			if (r < 0) break;
801010e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	85 c0                	test   %eax,%eax
801010ea:	74 98                	je     80101084 <filewrite+0x64>
		}
		return i == n ? n : -1;
	}
	panic("filewrite");
}
801010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
	if (f->writable == 0) return -1;
801010ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010f4:	89 f8                	mov    %edi,%eax
801010f6:	5b                   	pop    %ebx
801010f7:	5e                   	pop    %esi
801010f8:	5f                   	pop    %edi
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return i == n ? n : -1;
80101100:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101103:	75 e7                	jne    801010ec <filewrite+0xcc>
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	89 f8                	mov    %edi,%eax
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
8010110f:	90                   	nop
	if (f->type == FD_PIPE) return pipewrite(f->pipe, addr, n);
80101110:	8b 46 0c             	mov    0xc(%esi),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
	if (f->type == FD_PIPE) return pipewrite(f->pipe, addr, n);
8010111d:	e9 0e 23 00 00       	jmp    80103430 <pipewrite>
			if (r != n1) panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 cf 81 10 80       	push   $0x801081cf
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
	panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 d5 81 10 80       	push   $0x801081d5
80101137:	e8 54 f2 ff ff       	call   80100390 <panic>
8010113c:	66 90                	xchg   %ax,%ax
8010113e:	66 90                	xchg   %ax,%ax

80101140 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
	int         b, bi, m;
	struct buf *bp;

	bp = 0;
	for (b = 0; b < sb.size; b += BPB) {
80101149:	8b 0d 40 d7 12 80    	mov    0x8012d740,%ecx
{
8010114f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (b = 0; b < sb.size; b += BPB) {
80101152:	85 c9                	test   %ecx,%ecx
80101154:	0f 84 87 00 00 00    	je     801011e1 <balloc+0xa1>
8010115a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		bp = bread(dev, BBLOCK(b, sb));
80101161:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101164:	83 ec 08             	sub    $0x8,%esp
80101167:	89 f0                	mov    %esi,%eax
80101169:	c1 f8 0c             	sar    $0xc,%eax
8010116c:	03 05 58 d7 12 80    	add    0x8012d758,%eax
80101172:	50                   	push   %eax
80101173:	ff 75 d8             	pushl  -0x28(%ebp)
80101176:	e8 55 ef ff ff       	call   801000d0 <bread>
8010117b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010117e:	a1 40 d7 12 80       	mov    0x8012d740,%eax
80101183:	83 c4 10             	add    $0x10,%esp
80101186:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101189:	31 c0                	xor    %eax,%eax
8010118b:	eb 2f                	jmp    801011bc <balloc+0x7c>
8010118d:	8d 76 00             	lea    0x0(%esi),%esi
			m = 1 << (bi % 8);
80101190:	89 c1                	mov    %eax,%ecx
			if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101192:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			m = 1 << (bi % 8);
80101195:	bb 01 00 00 00       	mov    $0x1,%ebx
8010119a:	83 e1 07             	and    $0x7,%ecx
8010119d:	d3 e3                	shl    %cl,%ebx
			if ((bp->data[bi / 8] & m) == 0) { // Is block free?
8010119f:	89 c1                	mov    %eax,%ecx
801011a1:	c1 f9 03             	sar    $0x3,%ecx
801011a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011a9:	85 df                	test   %ebx,%edi
801011ab:	89 fa                	mov    %edi,%edx
801011ad:	74 41                	je     801011f0 <balloc+0xb0>
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
801011af:	83 c0 01             	add    $0x1,%eax
801011b2:	83 c6 01             	add    $0x1,%esi
801011b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011ba:	74 05                	je     801011c1 <balloc+0x81>
801011bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011bf:	77 cf                	ja     80101190 <balloc+0x50>
				brelse(bp);
				bzero(dev, b + bi);
				return b + bi;
			}
		}
		brelse(bp);
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801011c7:	e8 14 f0 ff ff       	call   801001e0 <brelse>
	for (b = 0; b < sb.size; b += BPB) {
801011cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011d3:	83 c4 10             	add    $0x10,%esp
801011d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d9:	39 05 40 d7 12 80    	cmp    %eax,0x8012d740
801011df:	77 80                	ja     80101161 <balloc+0x21>
	}
	panic("balloc: out of blocks");
801011e1:	83 ec 0c             	sub    $0xc,%esp
801011e4:	68 df 81 10 80       	push   $0x801081df
801011e9:	e8 a2 f1 ff ff       	call   80100390 <panic>
801011ee:	66 90                	xchg   %ax,%ax
				bp->data[bi / 8] |= m;     // Mark block in use.
801011f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
				log_write(bp);
801011f3:	83 ec 0c             	sub    $0xc,%esp
				bp->data[bi / 8] |= m;     // Mark block in use.
801011f6:	09 da                	or     %ebx,%edx
801011f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
				log_write(bp);
801011fc:	57                   	push   %edi
801011fd:	e8 ae 1b 00 00       	call   80102db0 <log_write>
				brelse(bp);
80101202:	89 3c 24             	mov    %edi,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
	bp = bread(dev, bno);
8010120a:	58                   	pop    %eax
8010120b:	5a                   	pop    %edx
8010120c:	56                   	push   %esi
8010120d:	ff 75 d8             	pushl  -0x28(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	89 c3                	mov    %eax,%ebx
	memset(bp->data, 0, BSIZE);
80101217:	8d 40 5c             	lea    0x5c(%eax),%eax
8010121a:	83 c4 0c             	add    $0xc,%esp
8010121d:	68 00 02 00 00       	push   $0x200
80101222:	6a 00                	push   $0x0
80101224:	50                   	push   %eax
80101225:	e8 56 3a 00 00       	call   80104c80 <memset>
	log_write(bp);
8010122a:	89 1c 24             	mov    %ebx,(%esp)
8010122d:	e8 7e 1b 00 00       	call   80102db0 <log_write>
	brelse(bp);
80101232:	89 1c 24             	mov    %ebx,(%esp)
80101235:	e8 a6 ef ff ff       	call   801001e0 <brelse>
}
8010123a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010123d:	89 f0                	mov    %esi,%eax
8010123f:	5b                   	pop    %ebx
80101240:	5e                   	pop    %esi
80101241:	5f                   	pop    %edi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
80101244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010124a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101250 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode *
iget(uint dev, uint inum)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	89 c7                	mov    %eax,%edi
	struct inode *ip, *empty;

	acquire(&icache.lock);

	// Is the inode already cached?
	empty = 0;
80101258:	31 f6                	xor    %esi,%esi
	for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
8010125a:	bb 94 d7 12 80       	mov    $0x8012d794,%ebx
{
8010125f:	83 ec 28             	sub    $0x28,%esp
80101262:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	acquire(&icache.lock);
80101265:	68 60 d7 12 80       	push   $0x8012d760
8010126a:	e8 91 38 00 00       	call   80104b00 <acquire>
8010126f:	83 c4 10             	add    $0x10,%esp
	for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101272:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101275:	eb 17                	jmp    8010128e <iget+0x3e>
80101277:	89 f6                	mov    %esi,%esi
80101279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101280:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101286:	81 fb b4 f3 12 80    	cmp    $0x8012f3b4,%ebx
8010128c:	73 22                	jae    801012b0 <iget+0x60>
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
8010128e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101291:	85 c9                	test   %ecx,%ecx
80101293:	7e 04                	jle    80101299 <iget+0x49>
80101295:	39 3b                	cmp    %edi,(%ebx)
80101297:	74 4f                	je     801012e8 <iget+0x98>
			ip->ref++;
			release(&icache.lock);
			return ip;
		}
		if (empty == 0 && ip->ref == 0) // Remember empty slot.
80101299:	85 f6                	test   %esi,%esi
8010129b:	75 e3                	jne    80101280 <iget+0x30>
8010129d:	85 c9                	test   %ecx,%ecx
8010129f:	0f 44 f3             	cmove  %ebx,%esi
	for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801012a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012a8:	81 fb b4 f3 12 80    	cmp    $0x8012f3b4,%ebx
801012ae:	72 de                	jb     8010128e <iget+0x3e>
			empty = ip;
	}

	// Recycle an inode cache entry.
	if (empty == 0) panic("iget: no inodes");
801012b0:	85 f6                	test   %esi,%esi
801012b2:	74 5b                	je     8010130f <iget+0xbf>
	ip        = empty;
	ip->dev   = dev;
	ip->inum  = inum;
	ip->ref   = 1;
	ip->valid = 0;
	release(&icache.lock);
801012b4:	83 ec 0c             	sub    $0xc,%esp
	ip->dev   = dev;
801012b7:	89 3e                	mov    %edi,(%esi)
	ip->inum  = inum;
801012b9:	89 56 04             	mov    %edx,0x4(%esi)
	ip->ref   = 1;
801012bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
	ip->valid = 0;
801012c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
	release(&icache.lock);
801012ca:	68 60 d7 12 80       	push   $0x8012d760
801012cf:	e8 4c 39 00 00       	call   80104c20 <release>

	return ip;
801012d4:	83 c4 10             	add    $0x10,%esp
}
801012d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012da:	89 f0                	mov    %esi,%eax
801012dc:	5b                   	pop    %ebx
801012dd:	5e                   	pop    %esi
801012de:	5f                   	pop    %edi
801012df:	5d                   	pop    %ebp
801012e0:	c3                   	ret    
801012e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
801012e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012eb:	75 ac                	jne    80101299 <iget+0x49>
			release(&icache.lock);
801012ed:	83 ec 0c             	sub    $0xc,%esp
			ip->ref++;
801012f0:	83 c1 01             	add    $0x1,%ecx
			return ip;
801012f3:	89 de                	mov    %ebx,%esi
			release(&icache.lock);
801012f5:	68 60 d7 12 80       	push   $0x8012d760
			ip->ref++;
801012fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
			release(&icache.lock);
801012fd:	e8 1e 39 00 00       	call   80104c20 <release>
			return ip;
80101302:	83 c4 10             	add    $0x10,%esp
}
80101305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101308:	89 f0                	mov    %esi,%eax
8010130a:	5b                   	pop    %ebx
8010130b:	5e                   	pop    %esi
8010130c:	5f                   	pop    %edi
8010130d:	5d                   	pop    %ebp
8010130e:	c3                   	ret    
	if (empty == 0) panic("iget: no inodes");
8010130f:	83 ec 0c             	sub    $0xc,%esp
80101312:	68 f5 81 10 80       	push   $0x801081f5
80101317:	e8 74 f0 ff ff       	call   80100390 <panic>
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101320 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	89 c6                	mov    %eax,%esi
80101328:	83 ec 1c             	sub    $0x1c,%esp
	uint        addr, *a;
	struct buf *bp;

	if (bn < NDIRECT) {
8010132b:	83 fa 0b             	cmp    $0xb,%edx
8010132e:	77 18                	ja     80101348 <bmap+0x28>
80101330:	8d 3c 90             	lea    (%eax,%edx,4),%edi
		if ((addr = ip->addrs[bn]) == 0) ip->addrs[bn] = addr = balloc(ip->dev);
80101333:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101336:	85 db                	test   %ebx,%ebx
80101338:	74 76                	je     801013b0 <bmap+0x90>
		brelse(bp);
		return addr;
	}

	panic("bmap: out of range");
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 d8                	mov    %ebx,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	bn -= NDIRECT;
80101348:	8d 5a f4             	lea    -0xc(%edx),%ebx
	if (bn < NINDIRECT) {
8010134b:	83 fb 7f             	cmp    $0x7f,%ebx
8010134e:	0f 87 90 00 00 00    	ja     801013e4 <bmap+0xc4>
		if ((addr = ip->addrs[NDIRECT]) == 0) ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101354:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010135a:	8b 00                	mov    (%eax),%eax
8010135c:	85 d2                	test   %edx,%edx
8010135e:	74 70                	je     801013d0 <bmap+0xb0>
		bp = bread(ip->dev, addr);
80101360:	83 ec 08             	sub    $0x8,%esp
80101363:	52                   	push   %edx
80101364:	50                   	push   %eax
80101365:	e8 66 ed ff ff       	call   801000d0 <bread>
		if ((addr = a[bn]) == 0) {
8010136a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010136e:	83 c4 10             	add    $0x10,%esp
		bp = bread(ip->dev, addr);
80101371:	89 c7                	mov    %eax,%edi
		if ((addr = a[bn]) == 0) {
80101373:	8b 1a                	mov    (%edx),%ebx
80101375:	85 db                	test   %ebx,%ebx
80101377:	75 1d                	jne    80101396 <bmap+0x76>
			a[bn] = addr = balloc(ip->dev);
80101379:	8b 06                	mov    (%esi),%eax
8010137b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010137e:	e8 bd fd ff ff       	call   80101140 <balloc>
80101383:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			log_write(bp);
80101386:	83 ec 0c             	sub    $0xc,%esp
			a[bn] = addr = balloc(ip->dev);
80101389:	89 c3                	mov    %eax,%ebx
8010138b:	89 02                	mov    %eax,(%edx)
			log_write(bp);
8010138d:	57                   	push   %edi
8010138e:	e8 1d 1a 00 00       	call   80102db0 <log_write>
80101393:	83 c4 10             	add    $0x10,%esp
		brelse(bp);
80101396:	83 ec 0c             	sub    $0xc,%esp
80101399:	57                   	push   %edi
8010139a:	e8 41 ee ff ff       	call   801001e0 <brelse>
8010139f:	83 c4 10             	add    $0x10,%esp
}
801013a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a5:	89 d8                	mov    %ebx,%eax
801013a7:	5b                   	pop    %ebx
801013a8:	5e                   	pop    %esi
801013a9:	5f                   	pop    %edi
801013aa:	5d                   	pop    %ebp
801013ab:	c3                   	ret    
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if ((addr = ip->addrs[bn]) == 0) ip->addrs[bn] = addr = balloc(ip->dev);
801013b0:	8b 00                	mov    (%eax),%eax
801013b2:	e8 89 fd ff ff       	call   80101140 <balloc>
801013b7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if ((addr = ip->addrs[bn]) == 0) ip->addrs[bn] = addr = balloc(ip->dev);
801013bd:	89 c3                	mov    %eax,%ebx
}
801013bf:	89 d8                	mov    %ebx,%eax
801013c1:	5b                   	pop    %ebx
801013c2:	5e                   	pop    %esi
801013c3:	5f                   	pop    %edi
801013c4:	5d                   	pop    %ebp
801013c5:	c3                   	ret    
801013c6:	8d 76 00             	lea    0x0(%esi),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if ((addr = ip->addrs[NDIRECT]) == 0) ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013d0:	e8 6b fd ff ff       	call   80101140 <balloc>
801013d5:	89 c2                	mov    %eax,%edx
801013d7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013dd:	8b 06                	mov    (%esi),%eax
801013df:	e9 7c ff ff ff       	jmp    80101360 <bmap+0x40>
	panic("bmap: out of range");
801013e4:	83 ec 0c             	sub    $0xc,%esp
801013e7:	68 05 82 10 80       	push   $0x80108205
801013ec:	e8 9f ef ff ff       	call   80100390 <panic>
801013f1:	eb 0d                	jmp    80101400 <readsb>
801013f3:	90                   	nop
801013f4:	90                   	nop
801013f5:	90                   	nop
801013f6:	90                   	nop
801013f7:	90                   	nop
801013f8:	90                   	nop
801013f9:	90                   	nop
801013fa:	90                   	nop
801013fb:	90                   	nop
801013fc:	90                   	nop
801013fd:	90                   	nop
801013fe:	90                   	nop
801013ff:	90                   	nop

80101400 <readsb>:
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	56                   	push   %esi
80101404:	53                   	push   %ebx
80101405:	8b 75 0c             	mov    0xc(%ebp),%esi
	bp = bread(dev, 1);
80101408:	83 ec 08             	sub    $0x8,%esp
8010140b:	6a 01                	push   $0x1
8010140d:	ff 75 08             	pushl  0x8(%ebp)
80101410:	e8 bb ec ff ff       	call   801000d0 <bread>
80101415:	89 c3                	mov    %eax,%ebx
	memmove(sb, bp->data, sizeof(*sb));
80101417:	8d 40 5c             	lea    0x5c(%eax),%eax
8010141a:	83 c4 0c             	add    $0xc,%esp
8010141d:	6a 1c                	push   $0x1c
8010141f:	50                   	push   %eax
80101420:	56                   	push   %esi
80101421:	e8 0a 39 00 00       	call   80104d30 <memmove>
	brelse(bp);
80101426:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101429:	83 c4 10             	add    $0x10,%esp
}
8010142c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010142f:	5b                   	pop    %ebx
80101430:	5e                   	pop    %esi
80101431:	5d                   	pop    %ebp
	brelse(bp);
80101432:	e9 a9 ed ff ff       	jmp    801001e0 <brelse>
80101437:	89 f6                	mov    %esi,%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101440 <bfree>:
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	89 d3                	mov    %edx,%ebx
80101447:	89 c6                	mov    %eax,%esi
	readsb(dev, &sb);
80101449:	83 ec 08             	sub    $0x8,%esp
8010144c:	68 40 d7 12 80       	push   $0x8012d740
80101451:	50                   	push   %eax
80101452:	e8 a9 ff ff ff       	call   80101400 <readsb>
	bp = bread(dev, BBLOCK(b, sb));
80101457:	58                   	pop    %eax
80101458:	5a                   	pop    %edx
80101459:	89 da                	mov    %ebx,%edx
8010145b:	c1 ea 0c             	shr    $0xc,%edx
8010145e:	03 15 58 d7 12 80    	add    0x8012d758,%edx
80101464:	52                   	push   %edx
80101465:	56                   	push   %esi
80101466:	e8 65 ec ff ff       	call   801000d0 <bread>
	m  = 1 << (bi % 8);
8010146b:	89 d9                	mov    %ebx,%ecx
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
8010146d:	c1 fb 03             	sar    $0x3,%ebx
	m  = 1 << (bi % 8);
80101470:	ba 01 00 00 00       	mov    $0x1,%edx
80101475:	83 e1 07             	and    $0x7,%ecx
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
80101478:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010147e:	83 c4 10             	add    $0x10,%esp
	m  = 1 << (bi % 8);
80101481:	d3 e2                	shl    %cl,%edx
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
80101483:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101488:	85 d1                	test   %edx,%ecx
8010148a:	74 25                	je     801014b1 <bfree+0x71>
	bp->data[bi / 8] &= ~m;
8010148c:	f7 d2                	not    %edx
8010148e:	89 c6                	mov    %eax,%esi
	log_write(bp);
80101490:	83 ec 0c             	sub    $0xc,%esp
	bp->data[bi / 8] &= ~m;
80101493:	21 ca                	and    %ecx,%edx
80101495:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
	log_write(bp);
80101499:	56                   	push   %esi
8010149a:	e8 11 19 00 00       	call   80102db0 <log_write>
	brelse(bp);
8010149f:	89 34 24             	mov    %esi,(%esp)
801014a2:	e8 39 ed ff ff       	call   801001e0 <brelse>
}
801014a7:	83 c4 10             	add    $0x10,%esp
801014aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ad:	5b                   	pop    %ebx
801014ae:	5e                   	pop    %esi
801014af:	5d                   	pop    %ebp
801014b0:	c3                   	ret    
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	68 18 82 10 80       	push   $0x80108218
801014b9:	e8 d2 ee ff ff       	call   80100390 <panic>
801014be:	66 90                	xchg   %ax,%ax

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb a0 d7 12 80       	mov    $0x8012d7a0,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
	initlock(&icache.lock, "icache");
801014cc:	68 2b 82 10 80       	push   $0x8010822b
801014d1:	68 60 d7 12 80       	push   $0x8012d760
801014d6:	e8 35 35 00 00       	call   80104a10 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
		initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 32 82 10 80       	push   $0x80108232
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 0c 34 00 00       	call   80104900 <initsleeplock>
	for (i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb c0 f3 12 80    	cmp    $0x8012f3c0,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
	readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 40 d7 12 80       	push   $0x8012d740
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 f1 fe ff ff       	call   80101400 <readsb>
	cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 58 d7 12 80    	pushl  0x8012d758
80101515:	ff 35 54 d7 12 80    	pushl  0x8012d754
8010151b:	ff 35 50 d7 12 80    	pushl  0x8012d750
80101521:	ff 35 4c d7 12 80    	pushl  0x8012d74c
80101527:	ff 35 48 d7 12 80    	pushl  0x8012d748
8010152d:	ff 35 44 d7 12 80    	pushl  0x8012d744
80101533:	ff 35 40 d7 12 80    	pushl  0x8012d740
80101539:	68 98 82 10 80       	push   $0x80108298
8010153e:	e8 1d f1 ff ff       	call   80100660 <cprintf>
}
80101543:	83 c4 30             	add    $0x30,%esp
80101546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101549:	c9                   	leave  
8010154a:	c3                   	ret    
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 1c             	sub    $0x1c,%esp
	for (inum = 1; inum < sb.ninodes; inum++) {
80101559:	83 3d 48 d7 12 80 01 	cmpl   $0x1,0x8012d748
{
80101560:	8b 45 0c             	mov    0xc(%ebp),%eax
80101563:	8b 75 08             	mov    0x8(%ebp),%esi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (inum = 1; inum < sb.ninodes; inum++) {
80101569:	0f 86 91 00 00 00    	jbe    80101600 <ialloc+0xb0>
8010156f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101574:	eb 21                	jmp    80101597 <ialloc+0x47>
80101576:	8d 76 00             	lea    0x0(%esi),%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		brelse(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
	for (inum = 1; inum < sb.ninodes; inum++) {
80101583:	83 c3 01             	add    $0x1,%ebx
		brelse(bp);
80101586:	57                   	push   %edi
80101587:	e8 54 ec ff ff       	call   801001e0 <brelse>
	for (inum = 1; inum < sb.ninodes; inum++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	39 1d 48 d7 12 80    	cmp    %ebx,0x8012d748
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
		bp  = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 54 d7 12 80    	add    0x8012d754,%eax
801015a5:	50                   	push   %eax
801015a6:	56                   	push   %esi
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c7                	mov    %eax,%edi
		dip = (struct dinode *)bp->data + inum % IPB;
801015ae:	89 d8                	mov    %ebx,%eax
		if (dip->type == 0) { // a free inode
801015b0:	83 c4 10             	add    $0x10,%esp
		dip = (struct dinode *)bp->data + inum % IPB;
801015b3:	83 e0 07             	and    $0x7,%eax
801015b6:	c1 e0 06             	shl    $0x6,%eax
801015b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
		if (dip->type == 0) { // a free inode
801015bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015c1:	75 bd                	jne    80101580 <ialloc+0x30>
			memset(dip, 0, sizeof(*dip));
801015c3:	83 ec 04             	sub    $0x4,%esp
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	6a 40                	push   $0x40
801015cb:	6a 00                	push   $0x0
801015cd:	51                   	push   %ecx
801015ce:	e8 ad 36 00 00       	call   80104c80 <memset>
			dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
			log_write(bp); // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 cb 17 00 00       	call   80102db0 <log_write>
			brelse(bp);
801015e5:	89 3c 24             	mov    %edi,(%esp)
801015e8:	e8 f3 eb ff ff       	call   801001e0 <brelse>
			return iget(dev, inum);
801015ed:	83 c4 10             	add    $0x10,%esp
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return iget(dev, inum);
801015f3:	89 da                	mov    %ebx,%edx
801015f5:	89 f0                	mov    %esi,%eax
}
801015f7:	5b                   	pop    %ebx
801015f8:	5e                   	pop    %esi
801015f9:	5f                   	pop    %edi
801015fa:	5d                   	pop    %ebp
			return iget(dev, inum);
801015fb:	e9 50 fc ff ff       	jmp    80101250 <iget>
	panic("ialloc: no inodes");
80101600:	83 ec 0c             	sub    $0xc,%esp
80101603:	68 38 82 10 80       	push   $0x80108238
80101608:	e8 83 ed ff ff       	call   80100390 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp         = bread(ip->dev, IBLOCK(ip->inum, sb));
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
	bp         = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 54 d7 12 80    	add    0x8012d754,%eax
8010162a:	50                   	push   %eax
8010162b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010162e:	e8 9d ea ff ff       	call   801000d0 <bread>
80101633:	89 c6                	mov    %eax,%esi
	dip        = (struct dinode *)bp->data + ip->inum % IPB;
80101635:	8b 43 a8             	mov    -0x58(%ebx),%eax
	dip->type  = ip->type;
80101638:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c4 0c             	add    $0xc,%esp
	dip        = (struct dinode *)bp->data + ip->inum % IPB;
8010163f:	83 e0 07             	and    $0x7,%eax
80101642:	c1 e0 06             	shl    $0x6,%eax
80101645:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
	dip->type  = ip->type;
80101649:	66 89 10             	mov    %dx,(%eax)
	dip->major = ip->major;
8010164c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101650:	83 c0 0c             	add    $0xc,%eax
	dip->major = ip->major;
80101653:	66 89 50 f6          	mov    %dx,-0xa(%eax)
	dip->minor = ip->minor;
80101657:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010165b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
	dip->nlink = ip->nlink;
8010165f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101663:	66 89 50 fa          	mov    %dx,-0x6(%eax)
	dip->size  = ip->size;
80101667:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010166a:	89 50 fc             	mov    %edx,-0x4(%eax)
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166d:	6a 34                	push   $0x34
8010166f:	53                   	push   %ebx
80101670:	50                   	push   %eax
80101671:	e8 ba 36 00 00       	call   80104d30 <memmove>
	log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 32 17 00 00       	call   80102db0 <log_write>
	brelse(bp);
8010167e:	89 75 08             	mov    %esi,0x8(%ebp)
80101681:	83 c4 10             	add    $0x10,%esp
}
80101684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5d                   	pop    %ebp
	brelse(bp);
8010168a:	e9 51 eb ff ff       	jmp    801001e0 <brelse>
8010168f:	90                   	nop

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 10             	sub    $0x10,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&icache.lock);
8010169a:	68 60 d7 12 80       	push   $0x8012d760
8010169f:	e8 5c 34 00 00       	call   80104b00 <acquire>
	ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
	release(&icache.lock);
801016a8:	c7 04 24 60 d7 12 80 	movl   $0x8012d760,(%esp)
801016af:	e8 6c 35 00 00       	call   80104c20 <release>
}
801016b4:	89 d8                	mov    %ebx,%eax
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (ip == 0 || ip->ref < 1) panic("ilock");
801016c8:	85 db                	test   %ebx,%ebx
801016ca:	0f 84 b7 00 00 00    	je     80101787 <ilock+0xc7>
801016d0:	8b 53 08             	mov    0x8(%ebx),%edx
801016d3:	85 d2                	test   %edx,%edx
801016d5:	0f 8e ac 00 00 00    	jle    80101787 <ilock+0xc7>
	acquiresleep(&ip->lock);
801016db:	8d 43 0c             	lea    0xc(%ebx),%eax
801016de:	83 ec 0c             	sub    $0xc,%esp
801016e1:	50                   	push   %eax
801016e2:	e8 59 32 00 00       	call   80104940 <acquiresleep>
	if (ip->valid == 0) {
801016e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ea:	83 c4 10             	add    $0x10,%esp
801016ed:	85 c0                	test   %eax,%eax
801016ef:	74 0f                	je     80101700 <ilock+0x40>
}
801016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5d                   	pop    %ebp
801016f7:	c3                   	ret    
801016f8:	90                   	nop
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		bp        = bread(ip->dev, IBLOCK(ip->inum, sb));
80101700:	8b 43 04             	mov    0x4(%ebx),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	c1 e8 03             	shr    $0x3,%eax
80101709:	03 05 54 d7 12 80    	add    0x8012d754,%eax
8010170f:	50                   	push   %eax
80101710:	ff 33                	pushl  (%ebx)
80101712:	e8 b9 e9 ff ff       	call   801000d0 <bread>
80101717:	89 c6                	mov    %eax,%esi
		dip       = (struct dinode *)bp->data + ip->inum % IPB;
80101719:	8b 43 04             	mov    0x4(%ebx),%eax
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c4 0c             	add    $0xc,%esp
		dip       = (struct dinode *)bp->data + ip->inum % IPB;
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
		ip->type  = dip->type;
80101729:	0f b7 10             	movzwl (%eax),%edx
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010172c:	83 c0 0c             	add    $0xc,%eax
		ip->type  = dip->type;
8010172f:	66 89 53 50          	mov    %dx,0x50(%ebx)
		ip->major = dip->major;
80101733:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101737:	66 89 53 52          	mov    %dx,0x52(%ebx)
		ip->minor = dip->minor;
8010173b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010173f:	66 89 53 54          	mov    %dx,0x54(%ebx)
		ip->nlink = dip->nlink;
80101743:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101747:	66 89 53 56          	mov    %dx,0x56(%ebx)
		ip->size  = dip->size;
8010174b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010174e:	89 53 58             	mov    %edx,0x58(%ebx)
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101751:	6a 34                	push   $0x34
80101753:	50                   	push   %eax
80101754:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101757:	50                   	push   %eax
80101758:	e8 d3 35 00 00       	call   80104d30 <memmove>
		brelse(bp);
8010175d:	89 34 24             	mov    %esi,(%esp)
80101760:	e8 7b ea ff ff       	call   801001e0 <brelse>
		if (ip->type == 0) panic("ilock: no type");
80101765:	83 c4 10             	add    $0x10,%esp
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
		ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
		if (ip->type == 0) panic("ilock: no type");
80101774:	0f 85 77 ff ff ff    	jne    801016f1 <ilock+0x31>
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	68 50 82 10 80       	push   $0x80108250
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
	if (ip == 0 || ip->ref < 1) panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 4a 82 10 80       	push   $0x8010824a
8010178f:	e8 fc eb ff ff       	call   80100390 <panic>
80101794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010179a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	74 28                	je     801017d4 <iunlock+0x34>
801017ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	56                   	push   %esi
801017b3:	e8 28 32 00 00       	call   801049e0 <holdingsleep>
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 c0                	test   %eax,%eax
801017bd:	74 15                	je     801017d4 <iunlock+0x34>
801017bf:	8b 43 08             	mov    0x8(%ebx),%eax
801017c2:	85 c0                	test   %eax,%eax
801017c4:	7e 0e                	jle    801017d4 <iunlock+0x34>
	releasesleep(&ip->lock);
801017c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cc:	5b                   	pop    %ebx
801017cd:	5e                   	pop    %esi
801017ce:	5d                   	pop    %ebp
	releasesleep(&ip->lock);
801017cf:	e9 cc 31 00 00       	jmp    801049a0 <releasesleep>
	if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 5f 82 10 80       	push   $0x8010825f
801017dc:	e8 af eb ff ff       	call   80100390 <panic>
801017e1:	eb 0d                	jmp    801017f0 <iput>
801017e3:	90                   	nop
801017e4:	90                   	nop
801017e5:	90                   	nop
801017e6:	90                   	nop
801017e7:	90                   	nop
801017e8:	90                   	nop
801017e9:	90                   	nop
801017ea:	90                   	nop
801017eb:	90                   	nop
801017ec:	90                   	nop
801017ed:	90                   	nop
801017ee:	90                   	nop
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 28             	sub    $0x28,%esp
801017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquiresleep(&ip->lock);
801017fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ff:	57                   	push   %edi
80101800:	e8 3b 31 00 00       	call   80104940 <acquiresleep>
	if (ip->valid && ip->nlink == 0) {
80101805:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 d2                	test   %edx,%edx
8010180d:	74 07                	je     80101816 <iput+0x26>
8010180f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101814:	74 32                	je     80101848 <iput+0x58>
	releasesleep(&ip->lock);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	57                   	push   %edi
8010181a:	e8 81 31 00 00       	call   801049a0 <releasesleep>
	acquire(&icache.lock);
8010181f:	c7 04 24 60 d7 12 80 	movl   $0x8012d760,(%esp)
80101826:	e8 d5 32 00 00       	call   80104b00 <acquire>
	ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
	release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 60 d7 12 80 	movl   $0x8012d760,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
	release(&icache.lock);
80101840:	e9 db 33 00 00       	jmp    80104c20 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
		acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 60 d7 12 80       	push   $0x8012d760
80101850:	e8 ab 32 00 00       	call   80104b00 <acquire>
		int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
		release(&icache.lock);
80101858:	c7 04 24 60 d7 12 80 	movl   $0x8012d760,(%esp)
8010185f:	e8 bc 33 00 00       	call   80104c20 <release>
		if (r == 1) {
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	83 fe 01             	cmp    $0x1,%esi
8010186a:	75 aa                	jne    80101816 <iput+0x26>
8010186c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101872:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101875:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x97>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c6 04             	add    $0x4,%esi
{
	int         i, j;
	struct buf *bp;
	uint *      a;

	for (i = 0; i < NDIRECT; i++) {
80101883:	39 fe                	cmp    %edi,%esi
80101885:	74 19                	je     801018a0 <iput+0xb0>
		if (ip->addrs[i]) {
80101887:	8b 16                	mov    (%esi),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x90>
			bfree(ip->dev, ip->addrs[i]);
8010188d:	8b 03                	mov    (%ebx),%eax
8010188f:	e8 ac fb ff ff       	call   80101440 <bfree>
			ip->addrs[i] = 0;
80101894:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010189a:	eb e4                	jmp    80101880 <iput+0x90>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		}
	}

	if (ip->addrs[NDIRECT]) {
801018a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 33                	jne    801018e0 <iput+0xf0>
		bfree(ip->dev, ip->addrs[NDIRECT]);
		ip->addrs[NDIRECT] = 0;
	}

	ip->size = 0;
	iupdate(ip);
801018ad:	83 ec 0c             	sub    $0xc,%esp
	ip->size = 0;
801018b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	iupdate(ip);
801018b7:	53                   	push   %ebx
801018b8:	e8 53 fd ff ff       	call   80101610 <iupdate>
			ip->type = 0;
801018bd:	31 c0                	xor    %eax,%eax
801018bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
			iupdate(ip);
801018c3:	89 1c 24             	mov    %ebx,(%esp)
801018c6:	e8 45 fd ff ff       	call   80101610 <iupdate>
			ip->valid = 0;
801018cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	e9 3c ff ff ff       	jmp    80101816 <iput+0x26>
801018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	ff 33                	pushl  (%ebx)
801018e6:	e8 e5 e7 ff ff       	call   801000d0 <bread>
801018eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018f1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		a  = (uint *)bp->data;
801018f7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	89 cf                	mov    %ecx,%edi
801018ff:	eb 0e                	jmp    8010190f <iput+0x11f>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	83 c6 04             	add    $0x4,%esi
		for (j = 0; j < NINDIRECT; j++) {
8010190b:	39 fe                	cmp    %edi,%esi
8010190d:	74 0f                	je     8010191e <iput+0x12e>
			if (a[j]) bfree(ip->dev, a[j]);
8010190f:	8b 16                	mov    (%esi),%edx
80101911:	85 d2                	test   %edx,%edx
80101913:	74 f3                	je     80101908 <iput+0x118>
80101915:	8b 03                	mov    (%ebx),%eax
80101917:	e8 24 fb ff ff       	call   80101440 <bfree>
8010191c:	eb ea                	jmp    80101908 <iput+0x118>
		brelse(bp);
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	ff 75 e4             	pushl  -0x1c(%ebp)
80101924:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101927:	e8 b4 e8 ff ff       	call   801001e0 <brelse>
		bfree(ip->dev, ip->addrs[NDIRECT]);
8010192c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101932:	8b 03                	mov    (%ebx),%eax
80101934:	e8 07 fb ff ff       	call   80101440 <bfree>
		ip->addrs[NDIRECT] = 0;
80101939:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101940:	00 00 00 
80101943:	83 c4 10             	add    $0x10,%esp
80101946:	e9 62 ff ff ff       	jmp    801018ad <iput+0xbd>
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlockput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 10             	sub    $0x10,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	iunlock(ip);
8010195a:	53                   	push   %ebx
8010195b:	e8 40 fe ff ff       	call   801017a0 <iunlock>
	iput(ip);
80101960:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101963:	83 c4 10             	add    $0x10,%esp
}
80101966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101969:	c9                   	leave  
	iput(ip);
8010196a:	e9 81 fe ff ff       	jmp    801017f0 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
	st->dev   = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
	st->ino   = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
	st->type  = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
	st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
	st->size  = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
// PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 1c             	sub    $0x1c,%esp
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801019af:	8b 7d 14             	mov    0x14(%ebp),%edi
	uint        tot, m;
	struct buf *bp;

	if (ip->type == T_DEV) {
801019b2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019b7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019bd:	8b 75 10             	mov    0x10(%ebp),%esi
801019c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (ip->type == T_DEV) {
801019c3:	0f 84 a7 00 00 00    	je     80101a70 <readi+0xd0>
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) return -1;
		return devsw[ip->major].read(ip, dst, n);
	}

	if (off > ip->size || off + n < off) return -1;
801019c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019cc:	8b 40 58             	mov    0x58(%eax),%eax
801019cf:	39 c6                	cmp    %eax,%esi
801019d1:	0f 87 ba 00 00 00    	ja     80101a91 <readi+0xf1>
801019d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019da:	89 f9                	mov    %edi,%ecx
801019dc:	01 f1                	add    %esi,%ecx
801019de:	0f 82 ad 00 00 00    	jb     80101a91 <readi+0xf1>
	if (off + n > ip->size) n = ip->size - off;
801019e4:	89 c2                	mov    %eax,%edx
801019e6:	29 f2                	sub    %esi,%edx
801019e8:	39 c8                	cmp    %ecx,%eax
801019ea:	0f 43 d7             	cmovae %edi,%edx

	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801019ed:	31 ff                	xor    %edi,%edi
801019ef:	85 d2                	test   %edx,%edx
	if (off + n > ip->size) n = ip->size - off;
801019f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801019f4:	74 6c                	je     80101a62 <readi+0xc2>
801019f6:	8d 76 00             	lea    0x0(%esi),%esi
801019f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101a00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a03:	89 f2                	mov    %esi,%edx
80101a05:	c1 ea 09             	shr    $0x9,%edx
80101a08:	89 d8                	mov    %ebx,%eax
80101a0a:	e8 11 f9 ff ff       	call   80101320 <bmap>
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	50                   	push   %eax
80101a13:	ff 33                	pushl  (%ebx)
80101a15:	e8 b6 e6 ff ff       	call   801000d0 <bread>
		m  = min(n - tot, BSIZE - off % BSIZE);
80101a1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101a1d:	89 c2                	mov    %eax,%edx
		m  = min(n - tot, BSIZE - off % BSIZE);
80101a1f:	89 f0                	mov    %esi,%eax
80101a21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a2b:	83 c4 0c             	add    $0xc,%esp
80101a2e:	29 c1                	sub    %eax,%ecx
		memmove(dst, bp->data + off % BSIZE, m);
80101a30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
		m  = min(n - tot, BSIZE - off % BSIZE);
80101a37:	29 fb                	sub    %edi,%ebx
80101a39:	39 d9                	cmp    %ebx,%ecx
80101a3b:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(dst, bp->data + off % BSIZE, m);
80101a3e:	53                   	push   %ebx
80101a3f:	50                   	push   %eax
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101a40:	01 df                	add    %ebx,%edi
		memmove(dst, bp->data + off % BSIZE, m);
80101a42:	ff 75 e0             	pushl  -0x20(%ebp)
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101a45:	01 de                	add    %ebx,%esi
		memmove(dst, bp->data + off % BSIZE, m);
80101a47:	e8 e4 32 00 00       	call   80104d30 <memmove>
		brelse(bp);
80101a4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a4f:	89 14 24             	mov    %edx,(%esp)
80101a52:	e8 89 e7 ff ff       	call   801001e0 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101a57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a60:	77 9e                	ja     80101a00 <readi+0x60>
	}
	return n;
80101a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5f                   	pop    %edi
80101a6b:	5d                   	pop    %ebp
80101a6c:	c3                   	ret    
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) return -1;
80101a70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a74:	66 83 f8 09          	cmp    $0x9,%ax
80101a78:	77 17                	ja     80101a91 <readi+0xf1>
80101a7a:	8b 04 c5 e0 d6 12 80 	mov    -0x7fed2920(,%eax,8),%eax
80101a81:	85 c0                	test   %eax,%eax
80101a83:	74 0c                	je     80101a91 <readi+0xf1>
		return devsw[ip->major].read(ip, dst, n);
80101a85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5f                   	pop    %edi
80101a8e:	5d                   	pop    %ebp
		return devsw[ip->major].read(ip, dst, n);
80101a8f:	ff e0                	jmp    *%eax
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) return -1;
80101a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a96:	eb cd                	jmp    80101a65 <readi+0xc5>
80101a98:	90                   	nop
80101a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
	uint        tot, m;
	struct buf *bp;

	if (ip->type == T_DEV) {
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101abd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac0:	89 7d e0             	mov    %edi,-0x20(%ebp)
	if (ip->type == T_DEV) {
80101ac3:	0f 84 b7 00 00 00    	je     80101b80 <writei+0xe0>
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) return -1;
		return devsw[ip->major].write(ip, src, n);
	}

	if (off > ip->size || off + n < off) return -1;
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	39 70 58             	cmp    %esi,0x58(%eax)
80101acf:	0f 82 eb 00 00 00    	jb     80101bc0 <writei+0x120>
80101ad5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ad8:	31 d2                	xor    %edx,%edx
80101ada:	89 f8                	mov    %edi,%eax
80101adc:	01 f0                	add    %esi,%eax
80101ade:	0f 92 c2             	setb   %dl
	if (off + n > MAXFILE * BSIZE) return -1;
80101ae1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ae6:	0f 87 d4 00 00 00    	ja     80101bc0 <writei+0x120>
80101aec:	85 d2                	test   %edx,%edx
80101aee:	0f 85 cc 00 00 00    	jne    80101bc0 <writei+0x120>

	for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101af4:	85 ff                	test   %edi,%edi
80101af6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101afd:	74 72                	je     80101b71 <writei+0xd1>
80101aff:	90                   	nop
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101b00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	e8 11 f8 ff ff       	call   80101320 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 37                	pushl  (%edi)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
		m  = min(n - tot, BSIZE - off % BSIZE);
80101b1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101b20:	89 c7                	mov    %eax,%edi
		m  = min(n - tot, BSIZE - off % BSIZE);
80101b22:	89 f0                	mov    %esi,%eax
80101b24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b29:	83 c4 0c             	add    $0xc,%esp
80101b2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b31:	29 c1                	sub    %eax,%ecx
		memmove(bp->data + off % BSIZE, src, m);
80101b33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
		m  = min(n - tot, BSIZE - off % BSIZE);
80101b37:	39 d9                	cmp    %ebx,%ecx
80101b39:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(bp->data + off % BSIZE, src, m);
80101b3c:	53                   	push   %ebx
80101b3d:	ff 75 dc             	pushl  -0x24(%ebp)
	for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101b40:	01 de                	add    %ebx,%esi
		memmove(bp->data + off % BSIZE, src, m);
80101b42:	50                   	push   %eax
80101b43:	e8 e8 31 00 00       	call   80104d30 <memmove>
		log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 60 12 00 00       	call   80102db0 <log_write>
		brelse(bp);
80101b50:	89 3c 24             	mov    %edi,(%esp)
80101b53:	e8 88 e6 ff ff       	call   801001e0 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101b58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b5e:	83 c4 10             	add    $0x10,%esp
80101b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b67:	77 97                	ja     80101b00 <writei+0x60>
	}

	if (n > 0 && off > ip->size) {
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b6f:	77 37                	ja     80101ba8 <writei+0x108>
		ip->size = off;
		iupdate(ip);
	}
	return n;
80101b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b77:	5b                   	pop    %ebx
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
80101b7b:	c3                   	ret    
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) return -1;
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 36                	ja     80101bc0 <writei+0x120>
80101b8a:	8b 04 c5 e4 d6 12 80 	mov    -0x7fed291c(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 2b                	je     80101bc0 <writei+0x120>
		return devsw[ip->major].write(ip, src, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
		return devsw[ip->major].write(ip, src, n);
80101b9f:	ff e0                	jmp    *%eax
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		ip->size = off;
80101ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
		iupdate(ip);
80101bab:	83 ec 0c             	sub    $0xc,%esp
		ip->size = off;
80101bae:	89 70 58             	mov    %esi,0x58(%eax)
		iupdate(ip);
80101bb1:	50                   	push   %eax
80101bb2:	e8 59 fa ff ff       	call   80101610 <iupdate>
80101bb7:	83 c4 10             	add    $0x10,%esp
80101bba:	eb b5                	jmp    80101b71 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) return -1;
80101bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc5:	eb ad                	jmp    80101b74 <writei+0xd4>
80101bc7:	89 f6                	mov    %esi,%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <namecmp>:
// PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	83 ec 0c             	sub    $0xc,%esp
	return strncmp(s, t, DIRSIZ);
80101bd6:	6a 0e                	push   $0xe
80101bd8:	ff 75 0c             	pushl  0xc(%ebp)
80101bdb:	ff 75 08             	pushl  0x8(%ebp)
80101bde:	e8 bd 31 00 00       	call   80104da0 <strncmp>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint          off, inum;
	struct dirent de;

	if (dp->type != T_DIR) panic("dirlookup not DIR");
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 85 00 00 00    	jne    80101c8c <dirlookup+0x9c>

	for (off = 0; off < dp->size; off += sizeof(de)) {
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	74 3e                	je     80101c51 <dirlookup+0x61>
80101c13:	90                   	nop
80101c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlookup read");
80101c18:	6a 10                	push   $0x10
80101c1a:	57                   	push   %edi
80101c1b:	56                   	push   %esi
80101c1c:	53                   	push   %ebx
80101c1d:	e8 7e fd ff ff       	call   801019a0 <readi>
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	83 f8 10             	cmp    $0x10,%eax
80101c28:	75 55                	jne    80101c7f <dirlookup+0x8f>
		if (de.inum == 0) continue;
80101c2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c2f:	74 18                	je     80101c49 <dirlookup+0x59>
	return strncmp(s, t, DIRSIZ);
80101c31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c34:	83 ec 04             	sub    $0x4,%esp
80101c37:	6a 0e                	push   $0xe
80101c39:	50                   	push   %eax
80101c3a:	ff 75 0c             	pushl  0xc(%ebp)
80101c3d:	e8 5e 31 00 00       	call   80104da0 <strncmp>
		if (namecmp(name, de.name) == 0) {
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 17                	je     80101c60 <dirlookup+0x70>
	for (off = 0; off < dp->size; off += sizeof(de)) {
80101c49:	83 c7 10             	add    $0x10,%edi
80101c4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c4f:	72 c7                	jb     80101c18 <dirlookup+0x28>
			return iget(dp->dev, inum);
		}
	}

	return 0;
}
80101c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80101c54:	31 c0                	xor    %eax,%eax
}
80101c56:	5b                   	pop    %ebx
80101c57:	5e                   	pop    %esi
80101c58:	5f                   	pop    %edi
80101c59:	5d                   	pop    %ebp
80101c5a:	c3                   	ret    
80101c5b:	90                   	nop
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if (poff) *poff = off;
80101c60:	8b 45 10             	mov    0x10(%ebp),%eax
80101c63:	85 c0                	test   %eax,%eax
80101c65:	74 05                	je     80101c6c <dirlookup+0x7c>
80101c67:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6a:	89 38                	mov    %edi,(%eax)
			inum = de.inum;
80101c6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
			return iget(dp->dev, inum);
80101c70:	8b 03                	mov    (%ebx),%eax
80101c72:	e8 d9 f5 ff ff       	call   80101250 <iget>
}
80101c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7a:	5b                   	pop    %ebx
80101c7b:	5e                   	pop    %esi
80101c7c:	5f                   	pop    %edi
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlookup read");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 79 82 10 80       	push   $0x80108279
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
	if (dp->type != T_DIR) panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 67 82 10 80       	push   $0x80108267
80101c94:	e8 f7 e6 ff ff       	call   80100390 <panic>
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	89 cf                	mov    %ecx,%edi
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 1c             	sub    $0x1c,%esp
	struct inode *ip, *next;

	if (*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
	if (*path == '/')
80101cb3:	0f 84 67 01 00 00    	je     80101e20 <namex+0x180>
		ip = iget(ROOTDEV, ROOTINO);
	else
		ip = idup(myproc()->cwd);
80101cb9:	e8 52 1c 00 00       	call   80103910 <myproc>
	acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
		ip = idup(myproc()->cwd);
80101cc1:	8b 70 68             	mov    0x68(%eax),%esi
	acquire(&icache.lock);
80101cc4:	68 60 d7 12 80       	push   $0x8012d760
80101cc9:	e8 32 2e 00 00       	call   80104b00 <acquire>
	ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
	release(&icache.lock);
80101cd2:	c7 04 24 60 d7 12 80 	movl   $0x8012d760,(%esp)
80101cd9:	e8 42 2f 00 00       	call   80104c20 <release>
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	eb 08                	jmp    80101ceb <namex+0x4b>
80101ce3:	90                   	nop
80101ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while (*path == '/') path++;
80101ce8:	83 c3 01             	add    $0x1,%ebx
80101ceb:	0f b6 03             	movzbl (%ebx),%eax
80101cee:	3c 2f                	cmp    $0x2f,%al
80101cf0:	74 f6                	je     80101ce8 <namex+0x48>
	if (*path == 0) return 0;
80101cf2:	84 c0                	test   %al,%al
80101cf4:	0f 84 ee 00 00 00    	je     80101de8 <namex+0x148>
	while (*path != '/' && *path != 0) path++;
80101cfa:	0f b6 03             	movzbl (%ebx),%eax
80101cfd:	3c 2f                	cmp    $0x2f,%al
80101cff:	0f 84 b3 00 00 00    	je     80101db8 <namex+0x118>
80101d05:	84 c0                	test   %al,%al
80101d07:	89 da                	mov    %ebx,%edx
80101d09:	75 09                	jne    80101d14 <namex+0x74>
80101d0b:	e9 a8 00 00 00       	jmp    80101db8 <namex+0x118>
80101d10:	84 c0                	test   %al,%al
80101d12:	74 0a                	je     80101d1e <namex+0x7e>
80101d14:	83 c2 01             	add    $0x1,%edx
80101d17:	0f b6 02             	movzbl (%edx),%eax
80101d1a:	3c 2f                	cmp    $0x2f,%al
80101d1c:	75 f2                	jne    80101d10 <namex+0x70>
80101d1e:	89 d1                	mov    %edx,%ecx
80101d20:	29 d9                	sub    %ebx,%ecx
	if (len >= DIRSIZ)
80101d22:	83 f9 0d             	cmp    $0xd,%ecx
80101d25:	0f 8e 91 00 00 00    	jle    80101dbc <namex+0x11c>
		memmove(name, s, DIRSIZ);
80101d2b:	83 ec 04             	sub    $0x4,%esp
80101d2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d31:	6a 0e                	push   $0xe
80101d33:	53                   	push   %ebx
80101d34:	57                   	push   %edi
80101d35:	e8 f6 2f 00 00       	call   80104d30 <memmove>
	while (*path != '/' && *path != 0) path++;
80101d3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
		memmove(name, s, DIRSIZ);
80101d3d:	83 c4 10             	add    $0x10,%esp
	while (*path != '/' && *path != 0) path++;
80101d40:	89 d3                	mov    %edx,%ebx
	while (*path == '/') path++;
80101d42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d45:	75 11                	jne    80101d58 <namex+0xb8>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101d50:	83 c3 01             	add    $0x1,%ebx
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

	while ((path = skipelem(path, name)) != 0) {
		ilock(ip);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	56                   	push   %esi
80101d5c:	e8 5f f9 ff ff       	call   801016c0 <ilock>
		if (ip->type != T_DIR) {
80101d61:	83 c4 10             	add    $0x10,%esp
80101d64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d69:	0f 85 91 00 00 00    	jne    80101e00 <namex+0x160>
			iunlockput(ip);
			return 0;
		}
		if (nameiparent && *path == '\0') {
80101d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d72:	85 d2                	test   %edx,%edx
80101d74:	74 09                	je     80101d7f <namex+0xdf>
80101d76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d79:	0f 84 b7 00 00 00    	je     80101e36 <namex+0x196>
			// Stop one level early.
			iunlock(ip);
			return ip;
		}
		if ((next = dirlookup(ip, name, 0)) == 0) {
80101d7f:	83 ec 04             	sub    $0x4,%esp
80101d82:	6a 00                	push   $0x0
80101d84:	57                   	push   %edi
80101d85:	56                   	push   %esi
80101d86:	e8 65 fe ff ff       	call   80101bf0 <dirlookup>
80101d8b:	83 c4 10             	add    $0x10,%esp
80101d8e:	85 c0                	test   %eax,%eax
80101d90:	74 6e                	je     80101e00 <namex+0x160>
	iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d98:	56                   	push   %esi
80101d99:	e8 02 fa ff ff       	call   801017a0 <iunlock>
	iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	83 c4 10             	add    $0x10,%esp
80101dac:	89 c6                	mov    %eax,%esi
80101dae:	e9 38 ff ff ff       	jmp    80101ceb <namex+0x4b>
80101db3:	90                   	nop
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while (*path != '/' && *path != 0) path++;
80101db8:	89 da                	mov    %ebx,%edx
80101dba:	31 c9                	xor    %ecx,%ecx
		memmove(name, s, len);
80101dbc:	83 ec 04             	sub    $0x4,%esp
80101dbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc5:	51                   	push   %ecx
80101dc6:	53                   	push   %ebx
80101dc7:	57                   	push   %edi
80101dc8:	e8 63 2f 00 00       	call   80104d30 <memmove>
		name[len] = 0;
80101dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dda:	89 d3                	mov    %edx,%ebx
80101ddc:	e9 61 ff ff ff       	jmp    80101d42 <namex+0xa2>
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			return 0;
		}
		iunlockput(ip);
		ip = next;
	}
	if (nameiparent) {
80101de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	75 5d                	jne    80101e4c <namex+0x1ac>
		iput(ip);
		return 0;
	}
	return ip;
}
80101def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df2:	89 f0                	mov    %esi,%eax
80101df4:	5b                   	pop    %ebx
80101df5:	5e                   	pop    %esi
80101df6:	5f                   	pop    %edi
80101df7:	5d                   	pop    %ebp
80101df8:	c3                   	ret    
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	iunlock(ip);
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	56                   	push   %esi
80101e04:	e8 97 f9 ff ff       	call   801017a0 <iunlock>
	iput(ip);
80101e09:	89 34 24             	mov    %esi,(%esp)
			return 0;
80101e0c:	31 f6                	xor    %esi,%esi
	iput(ip);
80101e0e:	e8 dd f9 ff ff       	call   801017f0 <iput>
			return 0;
80101e13:	83 c4 10             	add    $0x10,%esp
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	89 f0                	mov    %esi,%eax
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    
		ip = iget(ROOTDEV, ROOTINO);
80101e20:	ba 01 00 00 00       	mov    $0x1,%edx
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 21 f4 ff ff       	call   80101250 <iget>
80101e2f:	89 c6                	mov    %eax,%esi
80101e31:	e9 b5 fe ff ff       	jmp    80101ceb <namex+0x4b>
			iunlock(ip);
80101e36:	83 ec 0c             	sub    $0xc,%esp
80101e39:	56                   	push   %esi
80101e3a:	e8 61 f9 ff ff       	call   801017a0 <iunlock>
			return ip;
80101e3f:	83 c4 10             	add    $0x10,%esp
}
80101e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e45:	89 f0                	mov    %esi,%eax
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
		iput(ip);
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	56                   	push   %esi
		return 0;
80101e50:	31 f6                	xor    %esi,%esi
		iput(ip);
80101e52:	e8 99 f9 ff ff       	call   801017f0 <iput>
		return 0;
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb 93                	jmp    80101def <namex+0x14f>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e60 <dirlink>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 20             	sub    $0x20,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((ip = dirlookup(dp, name, 0)) != 0) {
80101e6c:	6a 00                	push   $0x0
80101e6e:	ff 75 0c             	pushl  0xc(%ebp)
80101e71:	53                   	push   %ebx
80101e72:	e8 79 fd ff ff       	call   80101bf0 <dirlookup>
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 67                	jne    80101ee5 <dirlink+0x85>
	for (off = 0; off < dp->size; off += sizeof(de)) {
80101e7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e84:	85 ff                	test   %edi,%edi
80101e86:	74 29                	je     80101eb1 <dirlink+0x51>
80101e88:	31 ff                	xor    %edi,%edi
80101e8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8d:	eb 09                	jmp    80101e98 <dirlink+0x38>
80101e8f:	90                   	nop
80101e90:	83 c7 10             	add    $0x10,%edi
80101e93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e96:	73 19                	jae    80101eb1 <dirlink+0x51>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink read");
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 fe fa ff ff       	call   801019a0 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 4e                	jne    80101ef8 <dirlink+0x98>
		if (de.inum == 0) break;
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	75 df                	jne    80101e90 <dirlink+0x30>
	strncpy(de.name, name, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	ff 75 0c             	pushl  0xc(%ebp)
80101ebc:	50                   	push   %eax
80101ebd:	e8 3e 2f 00 00       	call   80104e00 <strncpy>
	de.inum = inum;
80101ec2:	8b 45 10             	mov    0x10(%ebp),%eax
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink");
80101ec5:	6a 10                	push   $0x10
80101ec7:	57                   	push   %edi
80101ec8:	56                   	push   %esi
80101ec9:	53                   	push   %ebx
	de.inum = inum;
80101eca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink");
80101ece:	e8 cd fb ff ff       	call   80101aa0 <writei>
80101ed3:	83 c4 20             	add    $0x20,%esp
80101ed6:	83 f8 10             	cmp    $0x10,%eax
80101ed9:	75 2a                	jne    80101f05 <dirlink+0xa5>
	return 0;
80101edb:	31 c0                	xor    %eax,%eax
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
		iput(ip);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	50                   	push   %eax
80101ee9:	e8 02 f9 ff ff       	call   801017f0 <iput>
		return -1;
80101eee:	83 c4 10             	add    $0x10,%esp
80101ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef6:	eb e5                	jmp    80101edd <dirlink+0x7d>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink read");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 88 82 10 80       	push   $0x80108288
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 ea 88 10 80       	push   $0x801088ea
80101f0d:	e8 7e e4 ff ff       	call   80100390 <panic>
80101f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <namei>:

struct inode *
namei(char *path)
{
80101f20:	55                   	push   %ebp
	char name[DIRSIZ];
	return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
	return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
	return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
	return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
	return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	66 90                	xchg   %ax,%ax
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	66 90                	xchg   %ax,%ax
80101f5a:	66 90                	xchg   %ax,%ax
80101f5c:	66 90                	xchg   %ax,%ax
80101f5e:	66 90                	xchg   %ax,%ax

80101f60 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	57                   	push   %edi
80101f64:	56                   	push   %esi
80101f65:	53                   	push   %ebx
80101f66:	83 ec 0c             	sub    $0xc,%esp
	if (b == 0) panic("idestart");
80101f69:	85 c0                	test   %eax,%eax
80101f6b:	0f 84 b4 00 00 00    	je     80102025 <idestart+0xc5>
	if (b->blockno >= FSSIZE) panic("incorrect blockno");
80101f71:	8b 58 08             	mov    0x8(%eax),%ebx
80101f74:	89 c6                	mov    %eax,%esi
80101f76:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f7c:	0f 87 96 00 00 00    	ja     80102018 <idestart+0xb8>
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80101f82:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f87:	89 f6                	mov    %esi,%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f90:	89 ca                	mov    %ecx,%edx
80101f92:	ec                   	in     (%dx),%al
	while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80101f93:	83 e0 c0             	and    $0xffffffc0,%eax
80101f96:	3c 40                	cmp    $0x40,%al
80101f98:	75 f6                	jne    80101f90 <idestart+0x30>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80101f9a:	31 ff                	xor    %edi,%edi
80101f9c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fa1:	89 f8                	mov    %edi,%eax
80101fa3:	ee                   	out    %al,(%dx)
80101fa4:	b8 01 00 00 00       	mov    $0x1,%eax
80101fa9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fae:	ee                   	out    %al,(%dx)
80101faf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fb4:	89 d8                	mov    %ebx,%eax
80101fb6:	ee                   	out    %al,(%dx)

	idewait(0);
	outb(0x3f6, 0);                // generate interrupt
	outb(0x1f2, sector_per_block); // number of sectors
	outb(0x1f3, sector & 0xff);
	outb(0x1f4, (sector >> 8) & 0xff);
80101fb7:	89 d8                	mov    %ebx,%eax
80101fb9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fbe:	c1 f8 08             	sar    $0x8,%eax
80101fc1:	ee                   	out    %al,(%dx)
80101fc2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fc7:	89 f8                	mov    %edi,%eax
80101fc9:	ee                   	out    %al,(%dx)
	outb(0x1f5, (sector >> 16) & 0xff);
	outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
80101fca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fce:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fd3:	c1 e0 04             	shl    $0x4,%eax
80101fd6:	83 e0 10             	and    $0x10,%eax
80101fd9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fdc:	ee                   	out    %al,(%dx)
	if (b->flags & B_DIRTY) {
80101fdd:	f6 06 04             	testb  $0x4,(%esi)
80101fe0:	75 16                	jne    80101ff8 <idestart+0x98>
80101fe2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe7:	89 ca                	mov    %ecx,%edx
80101fe9:	ee                   	out    %al,(%dx)
		outb(0x1f7, write_cmd);
		outsl(0x1f0, b->data, BSIZE / 4);
	} else {
		outb(0x1f7, read_cmd);
	}
}
80101fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fed:	5b                   	pop    %ebx
80101fee:	5e                   	pop    %esi
80101fef:	5f                   	pop    %edi
80101ff0:	5d                   	pop    %ebp
80101ff1:	c3                   	ret    
80101ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ff8:	b8 30 00 00 00       	mov    $0x30,%eax
80101ffd:	89 ca                	mov    %ecx,%edx
80101fff:	ee                   	out    %al,(%dx)
	asm volatile("cld; rep outsl" : "=S"(addr), "=c"(cnt) : "d"(port), "0"(addr), "1"(cnt) : "cc");
80102000:	b9 80 00 00 00       	mov    $0x80,%ecx
		outsl(0x1f0, b->data, BSIZE / 4);
80102005:	83 c6 5c             	add    $0x5c,%esi
80102008:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010200d:	fc                   	cld    
8010200e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102013:	5b                   	pop    %ebx
80102014:	5e                   	pop    %esi
80102015:	5f                   	pop    %edi
80102016:	5d                   	pop    %ebp
80102017:	c3                   	ret    
	if (b->blockno >= FSSIZE) panic("incorrect blockno");
80102018:	83 ec 0c             	sub    $0xc,%esp
8010201b:	68 f4 82 10 80       	push   $0x801082f4
80102020:	e8 6b e3 ff ff       	call   80100390 <panic>
	if (b == 0) panic("idestart");
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	68 eb 82 10 80       	push   $0x801082eb
8010202d:	e8 5e e3 ff ff       	call   80100390 <panic>
80102032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102040 <ideinit>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	83 ec 10             	sub    $0x10,%esp
	initlock(&idelock, "ide");
80102046:	68 06 83 10 80       	push   $0x80108306
8010204b:	68 80 b5 10 80       	push   $0x8010b580
80102050:	e8 bb 29 00 00       	call   80104a10 <initlock>
	ioapicenable(IRQ_IDE, ncpu - 1);
80102055:	58                   	pop    %eax
80102056:	a1 80 fa 12 80       	mov    0x8012fa80,%eax
8010205b:	5a                   	pop    %edx
8010205c:	83 e8 01             	sub    $0x1,%eax
8010205f:	50                   	push   %eax
80102060:	6a 0e                	push   $0xe
80102062:	e8 a9 02 00 00       	call   80102310 <ioapicenable>
80102067:	83 c4 10             	add    $0x10,%esp
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010206a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010206f:	90                   	nop
80102070:	ec                   	in     (%dx),%al
	while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80102071:	83 e0 c0             	and    $0xffffffc0,%eax
80102074:	3c 40                	cmp    $0x40,%al
80102076:	75 f8                	jne    80102070 <ideinit+0x30>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102078:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010207d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102082:	ee                   	out    %al,(%dx)
80102083:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102088:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010208d:	eb 06                	jmp    80102095 <ideinit+0x55>
8010208f:	90                   	nop
	for (i = 0; i < 1000; i++) {
80102090:	83 e9 01             	sub    $0x1,%ecx
80102093:	74 0f                	je     801020a4 <ideinit+0x64>
80102095:	ec                   	in     (%dx),%al
		if (inb(0x1f7) != 0) {
80102096:	84 c0                	test   %al,%al
80102098:	74 f6                	je     80102090 <ideinit+0x50>
			havedisk1 = 1;
8010209a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801020a1:	00 00 00 
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801020a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020ae:	ee                   	out    %al,(%dx)
}
801020af:	c9                   	leave  
801020b0:	c3                   	ret    
801020b1:	eb 0d                	jmp    801020c0 <ideintr>
801020b3:	90                   	nop
801020b4:	90                   	nop
801020b5:	90                   	nop
801020b6:	90                   	nop
801020b7:	90                   	nop
801020b8:	90                   	nop
801020b9:	90                   	nop
801020ba:	90                   	nop
801020bb:	90                   	nop
801020bc:	90                   	nop
801020bd:	90                   	nop
801020be:	90                   	nop
801020bf:	90                   	nop

801020c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 18             	sub    $0x18,%esp
	struct buf *b;

	// First queued buffer is the active request.
	acquire(&idelock);
801020c9:	68 80 b5 10 80       	push   $0x8010b580
801020ce:	e8 2d 2a 00 00       	call   80104b00 <acquire>

	if ((b = idequeue) == 0) {
801020d3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020d9:	83 c4 10             	add    $0x10,%esp
801020dc:	85 db                	test   %ebx,%ebx
801020de:	74 67                	je     80102147 <ideintr+0x87>
		release(&idelock);
		return;
	}
	idequeue = b->qnext;
801020e0:	8b 43 58             	mov    0x58(%ebx),%eax
801020e3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

	// Read data if needed.
	if (!(b->flags & B_DIRTY) && idewait(1) >= 0) insl(0x1f0, b->data, BSIZE / 4);
801020e8:	8b 3b                	mov    (%ebx),%edi
801020ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020f0:	75 31                	jne    80102123 <ideintr+0x63>
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801020f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020f7:	89 f6                	mov    %esi,%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102100:	ec                   	in     (%dx),%al
	while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80102101:	89 c6                	mov    %eax,%esi
80102103:	83 e6 c0             	and    $0xffffffc0,%esi
80102106:	89 f1                	mov    %esi,%ecx
80102108:	80 f9 40             	cmp    $0x40,%cl
8010210b:	75 f3                	jne    80102100 <ideintr+0x40>
	if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0) return -1;
8010210d:	a8 21                	test   $0x21,%al
8010210f:	75 12                	jne    80102123 <ideintr+0x63>
	if (!(b->flags & B_DIRTY) && idewait(1) >= 0) insl(0x1f0, b->data, BSIZE / 4);
80102111:	8d 7b 5c             	lea    0x5c(%ebx),%edi
	asm volatile("cld; rep insl" : "=D"(addr), "=c"(cnt) : "d"(port), "0"(addr), "1"(cnt) : "memory", "cc");
80102114:	b9 80 00 00 00       	mov    $0x80,%ecx
80102119:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211e:	fc                   	cld    
8010211f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102121:	8b 3b                	mov    (%ebx),%edi

	// Wake process waiting for this buf.
	b->flags |= B_VALID;
	b->flags &= ~B_DIRTY;
80102123:	83 e7 fb             	and    $0xfffffffb,%edi
	wakeup(b);
80102126:	83 ec 0c             	sub    $0xc,%esp
	b->flags &= ~B_DIRTY;
80102129:	89 f9                	mov    %edi,%ecx
8010212b:	83 c9 02             	or     $0x2,%ecx
8010212e:	89 0b                	mov    %ecx,(%ebx)
	wakeup(b);
80102130:	53                   	push   %ebx
80102131:	e8 3a 23 00 00       	call   80104470 <wakeup>

	// Start disk on next buf in queue.
	if (idequeue != 0) idestart(idequeue);
80102136:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	85 c0                	test   %eax,%eax
80102140:	74 05                	je     80102147 <ideintr+0x87>
80102142:	e8 19 fe ff ff       	call   80101f60 <idestart>
		release(&idelock);
80102147:	83 ec 0c             	sub    $0xc,%esp
8010214a:	68 80 b5 10 80       	push   $0x8010b580
8010214f:	e8 cc 2a 00 00       	call   80104c20 <release>

	release(&idelock);
}
80102154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102157:	5b                   	pop    %ebx
80102158:	5e                   	pop    %esi
80102159:	5f                   	pop    %edi
8010215a:	5d                   	pop    %ebp
8010215b:	c3                   	ret    
8010215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102160 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	53                   	push   %ebx
80102164:	83 ec 10             	sub    $0x10,%esp
80102167:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct buf **pp;

	if (!holdingsleep(&b->lock)) panic("iderw: buf not locked");
8010216a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010216d:	50                   	push   %eax
8010216e:	e8 6d 28 00 00       	call   801049e0 <holdingsleep>
80102173:	83 c4 10             	add    $0x10,%esp
80102176:	85 c0                	test   %eax,%eax
80102178:	0f 84 c6 00 00 00    	je     80102244 <iderw+0xe4>
	if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) panic("iderw: nothing to do");
8010217e:	8b 03                	mov    (%ebx),%eax
80102180:	83 e0 06             	and    $0x6,%eax
80102183:	83 f8 02             	cmp    $0x2,%eax
80102186:	0f 84 ab 00 00 00    	je     80102237 <iderw+0xd7>
	if (b->dev != 0 && !havedisk1) panic("iderw: ide disk 1 not present");
8010218c:	8b 53 04             	mov    0x4(%ebx),%edx
8010218f:	85 d2                	test   %edx,%edx
80102191:	74 0d                	je     801021a0 <iderw+0x40>
80102193:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102198:	85 c0                	test   %eax,%eax
8010219a:	0f 84 b1 00 00 00    	je     80102251 <iderw+0xf1>

	acquire(&idelock); // DOC:acquire-lock
801021a0:	83 ec 0c             	sub    $0xc,%esp
801021a3:	68 80 b5 10 80       	push   $0x8010b580
801021a8:	e8 53 29 00 00       	call   80104b00 <acquire>

	// Append b to idequeue.
	b->qnext = 0;
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
801021ad:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801021b3:	83 c4 10             	add    $0x10,%esp
	b->qnext = 0;
801021b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
801021bd:	85 d2                	test   %edx,%edx
801021bf:	75 09                	jne    801021ca <iderw+0x6a>
801021c1:	eb 6d                	jmp    80102230 <iderw+0xd0>
801021c3:	90                   	nop
801021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021c8:	89 c2                	mov    %eax,%edx
801021ca:	8b 42 58             	mov    0x58(%edx),%eax
801021cd:	85 c0                	test   %eax,%eax
801021cf:	75 f7                	jne    801021c8 <iderw+0x68>
801021d1:	83 c2 58             	add    $0x58,%edx
		;
	*pp = b;
801021d4:	89 1a                	mov    %ebx,(%edx)

	// Start disk if necessary.
	if (idequeue == b) idestart(b);
801021d6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021dc:	74 42                	je     80102220 <iderw+0xc0>

	// Wait for request to finish.
	while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 e0 06             	and    $0x6,%eax
801021e3:	83 f8 02             	cmp    $0x2,%eax
801021e6:	74 23                	je     8010220b <iderw+0xab>
801021e8:	90                   	nop
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		sleep(b, &idelock);
801021f0:	83 ec 08             	sub    $0x8,%esp
801021f3:	68 80 b5 10 80       	push   $0x8010b580
801021f8:	53                   	push   %ebx
801021f9:	e8 b2 20 00 00       	call   801042b0 <sleep>
	while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
801021fe:	8b 03                	mov    (%ebx),%eax
80102200:	83 c4 10             	add    $0x10,%esp
80102203:	83 e0 06             	and    $0x6,%eax
80102206:	83 f8 02             	cmp    $0x2,%eax
80102209:	75 e5                	jne    801021f0 <iderw+0x90>
	}


	release(&idelock);
8010220b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102212:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102215:	c9                   	leave  
	release(&idelock);
80102216:	e9 05 2a 00 00       	jmp    80104c20 <release>
8010221b:	90                   	nop
8010221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (idequeue == b) idestart(b);
80102220:	89 d8                	mov    %ebx,%eax
80102222:	e8 39 fd ff ff       	call   80101f60 <idestart>
80102227:	eb b5                	jmp    801021de <iderw+0x7e>
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
80102230:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102235:	eb 9d                	jmp    801021d4 <iderw+0x74>
	if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) panic("iderw: nothing to do");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 20 83 10 80       	push   $0x80108320
8010223f:	e8 4c e1 ff ff       	call   80100390 <panic>
	if (!holdingsleep(&b->lock)) panic("iderw: buf not locked");
80102244:	83 ec 0c             	sub    $0xc,%esp
80102247:	68 0a 83 10 80       	push   $0x8010830a
8010224c:	e8 3f e1 ff ff       	call   80100390 <panic>
	if (b->dev != 0 && !havedisk1) panic("iderw: ide disk 1 not present");
80102251:	83 ec 0c             	sub    $0xc,%esp
80102254:	68 35 83 10 80       	push   $0x80108335
80102259:	e8 32 e1 ff ff       	call   80100390 <panic>
8010225e:	66 90                	xchg   %ax,%ax

80102260 <ioapicinit>:
	ioapic->data = data;
}

void
ioapicinit(void)
{
80102260:	55                   	push   %ebp
	int i, id, maxintr;

	ioapic  = (volatile struct ioapic *)IOAPIC;
80102261:	c7 05 b4 f3 12 80 00 	movl   $0xfec00000,0x8012f3b4
80102268:	00 c0 fe 
{
8010226b:	89 e5                	mov    %esp,%ebp
8010226d:	56                   	push   %esi
8010226e:	53                   	push   %ebx
	ioapic->reg = reg;
8010226f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102276:	00 00 00 
	return ioapic->data;
80102279:	a1 b4 f3 12 80       	mov    0x8012f3b4,%eax
8010227e:	8b 58 10             	mov    0x10(%eax),%ebx
	ioapic->reg = reg;
80102281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return ioapic->data;
80102287:	8b 0d b4 f3 12 80    	mov    0x8012f3b4,%ecx
	maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
	id      = ioapicread(REG_ID) >> 24;
	if (id != ioapicid) cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010228d:	0f b6 15 e0 f4 12 80 	movzbl 0x8012f4e0,%edx
	maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102294:	c1 eb 10             	shr    $0x10,%ebx
	return ioapic->data;
80102297:	8b 41 10             	mov    0x10(%ecx),%eax
	maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010229a:	0f b6 db             	movzbl %bl,%ebx
	id      = ioapicread(REG_ID) >> 24;
8010229d:	c1 e8 18             	shr    $0x18,%eax
	if (id != ioapicid) cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022a0:	39 c2                	cmp    %eax,%edx
801022a2:	74 16                	je     801022ba <ioapicinit+0x5a>
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 54 83 10 80       	push   $0x80108354
801022ac:	e8 af e3 ff ff       	call   80100660 <cprintf>
801022b1:	8b 0d b4 f3 12 80    	mov    0x8012f3b4,%ecx
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	83 c3 21             	add    $0x21,%ebx
{
801022bd:	ba 10 00 00 00       	mov    $0x10,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	89 f6                	mov    %esi,%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	ioapic->reg  = reg;
801022d0:	89 11                	mov    %edx,(%ecx)
	ioapic->data = data;
801022d2:	8b 0d b4 f3 12 80    	mov    0x8012f3b4,%ecx

	// Mark all interrupts edge-triggered, active high, disabled,
	// and not routed to any CPUs.
	for (i = 0; i <= maxintr; i++) {
		ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
801022d8:	89 c6                	mov    %eax,%esi
801022da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022e0:	83 c0 01             	add    $0x1,%eax
	ioapic->data = data;
801022e3:	89 71 10             	mov    %esi,0x10(%ecx)
801022e6:	8d 72 01             	lea    0x1(%edx),%esi
801022e9:	83 c2 02             	add    $0x2,%edx
	for (i = 0; i <= maxintr; i++) {
801022ec:	39 d8                	cmp    %ebx,%eax
	ioapic->reg  = reg;
801022ee:	89 31                	mov    %esi,(%ecx)
	ioapic->data = data;
801022f0:	8b 0d b4 f3 12 80    	mov    0x8012f3b4,%ecx
801022f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
	for (i = 0; i <= maxintr; i++) {
801022fd:	75 d1                	jne    801022d0 <ioapicinit+0x70>
		ioapicwrite(REG_TABLE + 2 * i + 1, 0);
	}
}
801022ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102302:	5b                   	pop    %ebx
80102303:	5e                   	pop    %esi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	8d 76 00             	lea    0x0(%esi),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102310:	55                   	push   %ebp
	ioapic->reg  = reg;
80102311:	8b 0d b4 f3 12 80    	mov    0x8012f3b4,%ecx
{
80102317:	89 e5                	mov    %esp,%ebp
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
	// Mark interrupt edge-triggered, active high,
	// enabled, and routed to the given cpunum,
	// which happens to be that cpu's APIC ID.
	ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
8010231c:	8d 50 20             	lea    0x20(%eax),%edx
8010231f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
	ioapic->reg  = reg;
80102323:	89 01                	mov    %eax,(%ecx)
	ioapic->data = data;
80102325:	8b 0d b4 f3 12 80    	mov    0x8012f3b4,%ecx
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
8010232b:	83 c0 01             	add    $0x1,%eax
	ioapic->data = data;
8010232e:	89 51 10             	mov    %edx,0x10(%ecx)
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102331:	8b 55 0c             	mov    0xc(%ebp),%edx
	ioapic->reg  = reg;
80102334:	89 01                	mov    %eax,(%ecx)
	ioapic->data = data;
80102336:	a1 b4 f3 12 80       	mov    0x8012f3b4,%eax
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
8010233b:	c1 e2 18             	shl    $0x18,%edx
	ioapic->data = data;
8010233e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102341:	5d                   	pop    %ebp
80102342:	c3                   	ret    
80102343:	66 90                	xchg   %ax,%ax
80102345:	66 90                	xchg   %ax,%ax
80102347:	66 90                	xchg   %ax,%ax
80102349:	66 90                	xchg   %ax,%ax
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 04             	sub    $0x4,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct run *r;

	if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) panic("kfree");
8010235a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102360:	75 70                	jne    801023d2 <kfree+0x82>
80102362:	81 fb 08 05 13 80    	cmp    $0x80130508,%ebx
80102368:	72 68                	jb     801023d2 <kfree+0x82>
8010236a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102370:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102375:	77 5b                	ja     801023d2 <kfree+0x82>

	// Fill with junk to catch dangling refs.
	memset(v, 1, PGSIZE);
80102377:	83 ec 04             	sub    $0x4,%esp
8010237a:	68 00 10 00 00       	push   $0x1000
8010237f:	6a 01                	push   $0x1
80102381:	53                   	push   %ebx
80102382:	e8 f9 28 00 00       	call   80104c80 <memset>

	if (kmem.use_lock) acquire(&kmem.lock);
80102387:	8b 15 f4 f3 12 80    	mov    0x8012f3f4,%edx
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	85 d2                	test   %edx,%edx
80102392:	75 2c                	jne    801023c0 <kfree+0x70>
	r             = (struct run *)v;
	r->next       = kmem.freelist;
80102394:	a1 f8 f3 12 80       	mov    0x8012f3f8,%eax
80102399:	89 03                	mov    %eax,(%ebx)
	kmem.freelist = r;
	if (kmem.use_lock) release(&kmem.lock);
8010239b:	a1 f4 f3 12 80       	mov    0x8012f3f4,%eax
	kmem.freelist = r;
801023a0:	89 1d f8 f3 12 80    	mov    %ebx,0x8012f3f8
	if (kmem.use_lock) release(&kmem.lock);
801023a6:	85 c0                	test   %eax,%eax
801023a8:	75 06                	jne    801023b0 <kfree+0x60>
}
801023aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ad:	c9                   	leave  
801023ae:	c3                   	ret    
801023af:	90                   	nop
	if (kmem.use_lock) release(&kmem.lock);
801023b0:	c7 45 08 c0 f3 12 80 	movl   $0x8012f3c0,0x8(%ebp)
}
801023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ba:	c9                   	leave  
	if (kmem.use_lock) release(&kmem.lock);
801023bb:	e9 60 28 00 00       	jmp    80104c20 <release>
	if (kmem.use_lock) acquire(&kmem.lock);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 c0 f3 12 80       	push   $0x8012f3c0
801023c8:	e8 33 27 00 00       	call   80104b00 <acquire>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	eb c2                	jmp    80102394 <kfree+0x44>
	if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) panic("kfree");
801023d2:	83 ec 0c             	sub    $0xc,%esp
801023d5:	68 86 83 10 80       	push   $0x80108386
801023da:	e8 b1 df ff ff       	call   80100390 <panic>
801023df:	90                   	nop

801023e0 <freerange>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
	p = (char *)PGROUNDUP((uint)vstart);
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
	p = (char *)PGROUNDUP((uint)vstart);
801023eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
801023f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fd:	39 de                	cmp    %ebx,%esi
801023ff:	72 23                	jb     80102424 <freerange+0x44>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102408:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010240e:	83 ec 0c             	sub    $0xc,%esp
80102411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102417:	50                   	push   %eax
80102418:	e8 33 ff ff ff       	call   80102350 <kfree>
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 f3                	cmp    %esi,%ebx
80102422:	76 e4                	jbe    80102408 <freerange+0x28>
}
80102424:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102427:	5b                   	pop    %ebx
80102428:	5e                   	pop    %esi
80102429:	5d                   	pop    %ebp
8010242a:	c3                   	ret    
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <kinit1>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	8b 75 0c             	mov    0xc(%ebp),%esi
	initlock(&kmem.lock, "kmem");
80102438:	83 ec 08             	sub    $0x8,%esp
8010243b:	68 8c 83 10 80       	push   $0x8010838c
80102440:	68 c0 f3 12 80       	push   $0x8012f3c0
80102445:	e8 c6 25 00 00       	call   80104a10 <initlock>
	p = (char *)PGROUNDUP((uint)vstart);
8010244a:	8b 45 08             	mov    0x8(%ebp),%eax
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
8010244d:	83 c4 10             	add    $0x10,%esp
	kmem.use_lock = 0;
80102450:	c7 05 f4 f3 12 80 00 	movl   $0x0,0x8012f3f4
80102457:	00 00 00 
	p = (char *)PGROUNDUP((uint)vstart);
8010245a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
80102466:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246c:	39 de                	cmp    %ebx,%esi
8010246e:	72 1c                	jb     8010248c <kinit1+0x5c>
80102470:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102476:	83 ec 0c             	sub    $0xc,%esp
80102479:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247f:	50                   	push   %eax
80102480:	e8 cb fe ff ff       	call   80102350 <kfree>
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	39 de                	cmp    %ebx,%esi
8010248a:	73 e4                	jae    80102470 <kinit1+0x40>
}
8010248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248f:	5b                   	pop    %ebx
80102490:	5e                   	pop    %esi
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
	p = (char *)PGROUNDUP((uint)vstart);
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	p = (char *)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <kinit2+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ce:	83 ec 0c             	sub    $0xc,%esp
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024d7:	50                   	push   %eax
801024d8:	e8 73 fe ff ff       	call   80102350 <kfree>
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 e4                	jae    801024c8 <kinit2+0x28>
	kmem.use_lock = 1;
801024e4:	c7 05 f4 f3 12 80 01 	movl   $0x1,0x8012f3f4
801024eb:	00 00 00 
}
801024ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
char *
kalloc(void)
{
	struct run *r;

	if (kmem.use_lock) acquire(&kmem.lock);
80102500:	a1 f4 f3 12 80       	mov    0x8012f3f4,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 1f                	jne    80102528 <kalloc+0x28>
	r = kmem.freelist;
80102509:	a1 f8 f3 12 80       	mov    0x8012f3f8,%eax
	if (r) kmem.freelist= r->next;
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 0e                	je     80102520 <kalloc+0x20>
80102512:	8b 10                	mov    (%eax),%edx
80102514:	89 15 f8 f3 12 80    	mov    %edx,0x8012f3f8
8010251a:	c3                   	ret    
8010251b:	90                   	nop
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (kmem.use_lock) release(&kmem.lock);
	return (char *)r;
}
80102520:	f3 c3                	repz ret 
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102528:	55                   	push   %ebp
80102529:	89 e5                	mov    %esp,%ebp
8010252b:	83 ec 24             	sub    $0x24,%esp
	if (kmem.use_lock) acquire(&kmem.lock);
8010252e:	68 c0 f3 12 80       	push   $0x8012f3c0
80102533:	e8 c8 25 00 00       	call   80104b00 <acquire>
	r = kmem.freelist;
80102538:	a1 f8 f3 12 80       	mov    0x8012f3f8,%eax
	if (r) kmem.freelist= r->next;
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	8b 15 f4 f3 12 80    	mov    0x8012f3f4,%edx
80102546:	85 c0                	test   %eax,%eax
80102548:	74 08                	je     80102552 <kalloc+0x52>
8010254a:	8b 08                	mov    (%eax),%ecx
8010254c:	89 0d f8 f3 12 80    	mov    %ecx,0x8012f3f8
	if (kmem.use_lock) release(&kmem.lock);
80102552:	85 d2                	test   %edx,%edx
80102554:	74 16                	je     8010256c <kalloc+0x6c>
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010255c:	68 c0 f3 12 80       	push   $0x8012f3c0
80102561:	e8 ba 26 00 00       	call   80104c20 <release>
	return (char *)r;
80102566:	8b 45 f4             	mov    -0xc(%ebp),%eax
	if (kmem.use_lock) release(&kmem.lock);
80102569:	83 c4 10             	add    $0x10,%esp
}
8010256c:	c9                   	leave  
8010256d:	c3                   	ret    
8010256e:	66 90                	xchg   %ax,%ax

80102570 <kbdgetc>:
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102570:	ba 64 00 00 00       	mov    $0x64,%edx
80102575:	ec                   	in     (%dx),%al
	static uint   shift;
	static uchar *charcode[4] = {normalmap, shiftmap, ctlmap, ctlmap};
	uint          st, data, c;

	st = inb(KBSTATP);
	if ((st & KBS_DIB) == 0) return -1;
80102576:	a8 01                	test   $0x1,%al
80102578:	0f 84 c2 00 00 00    	je     80102640 <kbdgetc+0xd0>
8010257e:	ba 60 00 00 00       	mov    $0x60,%edx
80102583:	ec                   	in     (%dx),%al
	data = inb(KBDATAP);
80102584:	0f b6 d0             	movzbl %al,%edx
80102587:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

	if (data == 0xE0) {
8010258d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102593:	0f 84 7f 00 00 00    	je     80102618 <kbdgetc+0xa8>
{
80102599:	55                   	push   %ebp
8010259a:	89 e5                	mov    %esp,%ebp
8010259c:	53                   	push   %ebx
8010259d:	89 cb                	mov    %ecx,%ebx
8010259f:	83 e3 40             	and    $0x40,%ebx
		shift |= E0ESC;
		return 0;
	} else if (data & 0x80) {
801025a2:	84 c0                	test   %al,%al
801025a4:	78 4a                	js     801025f0 <kbdgetc+0x80>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
		shift &= ~(shiftcode[data] | E0ESC);
		return 0;
	} else if (shift & E0ESC) {
801025a6:	85 db                	test   %ebx,%ebx
801025a8:	74 09                	je     801025b3 <kbdgetc+0x43>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
801025aa:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
801025ad:	83 e1 bf             	and    $0xffffffbf,%ecx
		data |= 0x80;
801025b0:	0f b6 d0             	movzbl %al,%edx
	}

	shift |= shiftcode[data];
801025b3:	0f b6 82 c0 84 10 80 	movzbl -0x7fef7b40(%edx),%eax
801025ba:	09 c1                	or     %eax,%ecx
	shift ^= togglecode[data];
801025bc:	0f b6 82 c0 83 10 80 	movzbl -0x7fef7c40(%edx),%eax
801025c3:	31 c1                	xor    %eax,%ecx
	c = charcode[shift & (CTL | SHIFT)][data];
801025c5:	89 c8                	mov    %ecx,%eax
	shift ^= togglecode[data];
801025c7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
	c = charcode[shift & (CTL | SHIFT)][data];
801025cd:	83 e0 03             	and    $0x3,%eax
	if (shift & CAPSLOCK) {
801025d0:	83 e1 08             	and    $0x8,%ecx
	c = charcode[shift & (CTL | SHIFT)][data];
801025d3:	8b 04 85 a0 83 10 80 	mov    -0x7fef7c60(,%eax,4),%eax
801025da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
	if (shift & CAPSLOCK) {
801025de:	74 31                	je     80102611 <kbdgetc+0xa1>
		if ('a' <= c && c <= 'z')
801025e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025e3:	83 fa 19             	cmp    $0x19,%edx
801025e6:	77 40                	ja     80102628 <kbdgetc+0xb8>
			c += 'A' - 'a';
801025e8:	83 e8 20             	sub    $0x20,%eax
		else if ('A' <= c && c <= 'Z')
			c += 'a' - 'A';
	}
	return c;
}
801025eb:	5b                   	pop    %ebx
801025ec:	5d                   	pop    %ebp
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax
		data = (shift & E0ESC ? data : data & 0x7F);
801025f0:	83 e0 7f             	and    $0x7f,%eax
801025f3:	85 db                	test   %ebx,%ebx
801025f5:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
801025f8:	0f b6 82 c0 84 10 80 	movzbl -0x7fef7b40(%edx),%eax
801025ff:	83 c8 40             	or     $0x40,%eax
80102602:	0f b6 c0             	movzbl %al,%eax
80102605:	f7 d0                	not    %eax
80102607:	21 c1                	and    %eax,%ecx
		return 0;
80102609:	31 c0                	xor    %eax,%eax
		shift &= ~(shiftcode[data] | E0ESC);
8010260b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102611:	5b                   	pop    %ebx
80102612:	5d                   	pop    %ebp
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		shift |= E0ESC;
80102618:	83 c9 40             	or     $0x40,%ecx
		return 0;
8010261b:	31 c0                	xor    %eax,%eax
		shift |= E0ESC;
8010261d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
		return 0;
80102623:	c3                   	ret    
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		else if ('A' <= c && c <= 'Z')
80102628:	8d 48 bf             	lea    -0x41(%eax),%ecx
			c += 'a' - 'A';
8010262b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010262e:	5b                   	pop    %ebx
			c += 'a' - 'A';
8010262f:	83 f9 1a             	cmp    $0x1a,%ecx
80102632:	0f 42 c2             	cmovb  %edx,%eax
}
80102635:	5d                   	pop    %ebp
80102636:	c3                   	ret    
80102637:	89 f6                	mov    %esi,%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if ((st & KBS_DIB) == 0) return -1;
80102640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102645:	c3                   	ret    
80102646:	8d 76 00             	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <kbdintr>:

void
kbdintr(void)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 14             	sub    $0x14,%esp
	consoleintr(kbdgetc);
80102656:	68 70 25 10 80       	push   $0x80102570
8010265b:	e8 b0 e1 ff ff       	call   80100810 <consoleintr>
}
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	c9                   	leave  
80102664:	c3                   	ret    
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <lapicinit>:
// PAGEBREAK!

void
lapicinit(void)
{
	if (!lapic) return;
80102670:	a1 fc f3 12 80       	mov    0x8012f3fc,%eax
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
	if (!lapic) return;
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c8 00 00 00    	je     80102748 <lapicinit+0xd8>
	lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
	lapic[ID]; // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
	lapic[ID]; // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
	lapic[ID]; // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
	lapic[ID]; // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
	lapic[ID]; // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
	lapicw(LINT0, MASKED);
	lapicw(LINT1, MASKED);

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER] >> 16) & 0xFF) >= 4) lapicw(PCINT, MASKED);
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 77                	ja     80102750 <lapicinit+0xe0>
	lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
	lapic[ID]; // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	lapicw(EOI, 0);

	// Send an Init Level De-Assert to synchronise arbitration ID's.
	lapicw(ICRHI, 0);
	lapicw(ICRLO, BCAST | INIT | LEVEL);
	while (lapic[ICRLO] & DELIVS)
80102730:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102736:	80 e6 10             	and    $0x10,%dh
80102739:	75 f5                	jne    80102730 <lapicinit+0xc0>
	lapic[index] = value;
8010273b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102742:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102745:	8b 40 20             	mov    0x20(%eax),%eax
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
}
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	lapic[index] = value;
80102750:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102757:	00 01 00 
	lapic[ID]; // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
8010275d:	e9 77 ff ff ff       	jmp    801026d9 <lapicinit+0x69>
80102762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:

int
lapicid(void)
{
	if (!lapic) return 0;
80102770:	8b 15 fc f3 12 80    	mov    0x8012f3fc,%edx
{
80102776:	55                   	push   %ebp
80102777:	31 c0                	xor    %eax,%eax
80102779:	89 e5                	mov    %esp,%ebp
	if (!lapic) return 0;
8010277b:	85 d2                	test   %edx,%edx
8010277d:	74 06                	je     80102785 <lapicid+0x15>
	return lapic[ID] >> 24;
8010277f:	8b 42 20             	mov    0x20(%edx),%eax
80102782:	c1 e8 18             	shr    $0x18,%eax
}
80102785:	5d                   	pop    %ebp
80102786:	c3                   	ret    
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
	if (lapic) lapicw(EOI, 0);
80102790:	a1 fc f3 12 80       	mov    0x8012f3fc,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
	if (lapic) lapicw(EOI, 0);
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
	lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801027c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027c6:	ba 70 00 00 00       	mov    $0x70,%edx
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	ba 71 00 00 00       	mov    $0x71,%edx
801027df:	ee                   	out    %al,(%dx)
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(CMOS_PORT, 0xF); // offset 0xF is shutdown code
	outb(CMOS_PORT + 1, 0x0A);
	wrv    = (ushort *)P2V((0x40 << 4 | 0x67)); // Warm reset vector
	wrv[0] = 0;
801027e0:	31 c0                	xor    %eax,%eax
	wrv[1] = addr >> 4;

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
801027e2:	c1 e3 18             	shl    $0x18,%ebx
	wrv[0] = 0;
801027e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
	wrv[1] = addr >> 4;
801027eb:	89 c8                	mov    %ecx,%eax
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
801027ed:	c1 e9 0c             	shr    $0xc,%ecx
	wrv[1] = addr >> 4;
801027f0:	c1 e8 04             	shr    $0x4,%eax
	lapicw(ICRHI, apicid << 24);
801027f3:	89 da                	mov    %ebx,%edx
		lapicw(ICRLO, STARTUP | (addr >> 12));
801027f5:	80 cd 06             	or     $0x6,%ch
	wrv[1] = addr >> 4;
801027f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
	lapic[index] = value;
801027fe:	a1 fc f3 12 80       	mov    0x8012f3fc,%eax
80102803:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
	lapic[ID]; // wait for write to finish, by reading
80102809:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
8010280c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102813:	c5 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102816:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
80102819:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102820:	85 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102823:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
80102826:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
	lapic[ID]; // wait for write to finish, by reading
8010282c:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
8010282f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
	lapic[ID]; // wait for write to finish, by reading
80102835:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
80102838:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
	lapic[ID]; // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
80102841:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
	lapic[ID]; // wait for write to finish, by reading
80102847:	8b 40 20             	mov    0x20(%eax),%eax
		microdelay(200);
	}
}
8010284a:	5b                   	pop    %ebx
8010284b:	5d                   	pop    %ebp
8010284c:	c3                   	ret    
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	b8 0b 00 00 00       	mov    $0xb,%eax
80102856:	ba 70 00 00 00       	mov    $0x70,%edx
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102864:	ba 71 00 00 00       	mov    $0x71,%edx
80102869:	ec                   	in     (%dx),%al
8010286a:	83 e0 04             	and    $0x4,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
8010286d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102872:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102875:	8d 76 00             	lea    0x0(%esi),%esi
80102878:	31 c0                	xor    %eax,%eax
8010287a:	89 da                	mov    %ebx,%edx
8010287c:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010287d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102882:	89 ca                	mov    %ecx,%edx
80102884:	ec                   	in     (%dx),%al
80102885:	88 45 b7             	mov    %al,-0x49(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102888:	89 da                	mov    %ebx,%edx
8010288a:	b8 02 00 00 00       	mov    $0x2,%eax
8010288f:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102890:	89 ca                	mov    %ecx,%edx
80102892:	ec                   	in     (%dx),%al
80102893:	88 45 b6             	mov    %al,-0x4a(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102896:	89 da                	mov    %ebx,%edx
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
801028a1:	88 45 b5             	mov    %al,-0x4b(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028a4:	89 da                	mov    %ebx,%edx
801028a6:	b8 07 00 00 00       	mov    $0x7,%eax
801028ab:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
801028af:	88 45 b4             	mov    %al,-0x4c(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028b2:	89 da                	mov    %ebx,%edx
801028b4:	b8 08 00 00 00       	mov    $0x8,%eax
801028b9:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028ba:	89 ca                	mov    %ecx,%edx
801028bc:	ec                   	in     (%dx),%al
801028bd:	89 c7                	mov    %eax,%edi
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028bf:	89 da                	mov    %ebx,%edx
801028c1:	b8 09 00 00 00       	mov    $0x9,%eax
801028c6:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028c7:	89 ca                	mov    %ecx,%edx
801028c9:	ec                   	in     (%dx),%al
801028ca:	89 c6                	mov    %eax,%esi
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	b8 0a 00 00 00       	mov    $0xa,%eax
801028d3:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028d4:	89 ca                	mov    %ecx,%edx
801028d6:	ec                   	in     (%dx),%al
	bcd = (sb & (1 << 2)) == 0;

	// make sure CMOS doesn't modify time while we read it
	for (;;) {
		fill_rtcdate(&t1);
		if (cmos_read(CMOS_STATA) & CMOS_UIP) continue;
801028d7:	84 c0                	test   %al,%al
801028d9:	78 9d                	js     80102878 <cmostime+0x28>
	return inb(CMOS_RETURN);
801028db:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028df:	89 fa                	mov    %edi,%edx
801028e1:	0f b6 fa             	movzbl %dl,%edi
801028e4:	89 f2                	mov    %esi,%edx
801028e6:	0f b6 f2             	movzbl %dl,%esi
801028e9:	89 7d c8             	mov    %edi,-0x38(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028ec:	89 da                	mov    %ebx,%edx
801028ee:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028f4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028fb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102902:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102906:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102909:	31 c0                	xor    %eax,%eax
8010290b:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
8010290f:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102912:	89 da                	mov    %ebx,%edx
80102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102917:	b8 02 00 00 00       	mov    $0x2,%eax
8010291c:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010291d:	89 ca                	mov    %ecx,%edx
8010291f:	ec                   	in     (%dx),%al
80102920:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102923:	89 da                	mov    %ebx,%edx
80102925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
80102931:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102934:	89 da                	mov    %ebx,%edx
80102936:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102939:	b8 07 00 00 00       	mov    $0x7,%eax
8010293e:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010293f:	89 ca                	mov    %ecx,%edx
80102941:	ec                   	in     (%dx),%al
80102942:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102945:	89 da                	mov    %ebx,%edx
80102947:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010294a:	b8 08 00 00 00       	mov    $0x8,%eax
8010294f:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
80102953:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102956:	89 da                	mov    %ebx,%edx
80102958:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010295b:	b8 09 00 00 00       	mov    $0x9,%eax
80102960:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102961:	89 ca                	mov    %ecx,%edx
80102963:	ec                   	in     (%dx),%al
80102964:	0f b6 c0             	movzbl %al,%eax
		fill_rtcdate(&t2);
		if (memcmp(&t1, &t2, sizeof(t1)) == 0) break;
80102967:	83 ec 04             	sub    $0x4,%esp
	return inb(CMOS_RETURN);
8010296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (memcmp(&t1, &t2, sizeof(t1)) == 0) break;
8010296d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102970:	6a 18                	push   $0x18
80102972:	50                   	push   %eax
80102973:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102976:	50                   	push   %eax
80102977:	e8 54 23 00 00       	call   80104cd0 <memcmp>
8010297c:	83 c4 10             	add    $0x10,%esp
8010297f:	85 c0                	test   %eax,%eax
80102981:	0f 85 f1 fe ff ff    	jne    80102878 <cmostime+0x28>
	}

	// convert
	if (bcd) {
80102987:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010298b:	75 78                	jne    80102a05 <cmostime+0x1b5>
#define CONV(x) (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
		CONV(second);
8010298d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102990:	89 c2                	mov    %eax,%edx
80102992:	83 e0 0f             	and    $0xf,%eax
80102995:	c1 ea 04             	shr    $0x4,%edx
80102998:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		CONV(minute);
801029a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a4:	89 c2                	mov    %eax,%edx
801029a6:	83 e0 0f             	and    $0xf,%eax
801029a9:	c1 ea 04             	shr    $0x4,%edx
801029ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
		CONV(hour);
801029b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b8:	89 c2                	mov    %eax,%edx
801029ba:	83 e0 0f             	and    $0xf,%eax
801029bd:	c1 ea 04             	shr    $0x4,%edx
801029c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
		CONV(day);
801029c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029cc:	89 c2                	mov    %eax,%edx
801029ce:	83 e0 0f             	and    $0xf,%eax
801029d1:	c1 ea 04             	shr    $0x4,%edx
801029d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		CONV(month);
801029dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e0:	89 c2                	mov    %eax,%edx
801029e2:	83 e0 0f             	and    $0xf,%eax
801029e5:	c1 ea 04             	shr    $0x4,%edx
801029e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029eb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
		CONV(year);
801029f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f4:	89 c2                	mov    %eax,%edx
801029f6:	83 e0 0f             	and    $0xf,%eax
801029f9:	c1 ea 04             	shr    $0x4,%edx
801029fc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef CONV
	}

	*r = t1;
80102a05:	8b 75 08             	mov    0x8(%ebp),%esi
80102a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a0b:	89 06                	mov    %eax,(%esi)
80102a0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a10:	89 46 04             	mov    %eax,0x4(%esi)
80102a13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a16:	89 46 08             	mov    %eax,0x8(%esi)
80102a19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a22:	89 46 10             	mov    %eax,0x10(%esi)
80102a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a28:	89 46 14             	mov    %eax,0x14(%esi)
	r->year += 2000;
80102a2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a35:	5b                   	pop    %ebx
80102a36:	5e                   	pop    %esi
80102a37:	5f                   	pop    %edi
80102a38:	5d                   	pop    %ebp
80102a39:	c3                   	ret    
80102a3a:	66 90                	xchg   %ax,%ax
80102a3c:	66 90                	xchg   %ax,%ax
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <install_trans>:
static void
install_trans(void)
{
	int tail;

	for (tail = 0; tail < log.lh.n; tail++) {
80102a40:	8b 0d 48 f4 12 80    	mov    0x8012f448,%ecx
80102a46:	85 c9                	test   %ecx,%ecx
80102a48:	0f 8e 8a 00 00 00    	jle    80102ad8 <install_trans+0x98>
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	57                   	push   %edi
80102a52:	56                   	push   %esi
80102a53:	53                   	push   %ebx
	for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	31 db                	xor    %ebx,%ebx
{
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
80102a60:	a1 34 f4 12 80       	mov    0x8012f434,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 44 f4 12 80    	pushl  0x8012f444
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
		struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d 4c f4 12 80 	pushl  -0x7fed0bb4(,%ebx,4)
80102a84:	ff 35 44 f4 12 80    	pushl  0x8012f444
	for (tail = 0; tail < log.lh.n; tail++) {
80102a8a:	83 c3 01             	add    $0x1,%ebx
		struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
80102a8d:	e8 3e d6 ff ff       	call   801000d0 <bread>
80102a92:	89 c6                	mov    %eax,%esi
		memmove(dbuf->data, lbuf->data, BSIZE);                  // copy block to dst
80102a94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	50                   	push   %eax
80102aa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa3:	50                   	push   %eax
80102aa4:	e8 87 22 00 00       	call   80104d30 <memmove>
		bwrite(dbuf);                                            // write dst to disk
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 ef d6 ff ff       	call   801001a0 <bwrite>
		brelse(lbuf);
80102ab1:	89 3c 24             	mov    %edi,(%esp)
80102ab4:	e8 27 d7 ff ff       	call   801001e0 <brelse>
		brelse(dbuf);
80102ab9:	89 34 24             	mov    %esi,(%esp)
80102abc:	e8 1f d7 ff ff       	call   801001e0 <brelse>
	for (tail = 0; tail < log.lh.n; tail++) {
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	39 1d 48 f4 12 80    	cmp    %ebx,0x8012f448
80102aca:	7f 94                	jg     80102a60 <install_trans+0x20>
	}
}
80102acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	f3 c3                	repz ret 
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
	struct buf *      buf = bread(log.dev, log.start);
80102ae5:	83 ec 08             	sub    $0x8,%esp
80102ae8:	ff 35 34 f4 12 80    	pushl  0x8012f434
80102aee:	ff 35 44 f4 12 80    	pushl  0x8012f444
80102af4:	e8 d7 d5 ff ff       	call   801000d0 <bread>
	struct logheader *hb  = (struct logheader *)(buf->data);
	int               i;
	hb->n = log.lh.n;
80102af9:	8b 1d 48 f4 12 80    	mov    0x8012f448,%ebx
	for (i = 0; i < log.lh.n; i++) {
80102aff:	83 c4 10             	add    $0x10,%esp
	struct buf *      buf = bread(log.dev, log.start);
80102b02:	89 c6                	mov    %eax,%esi
	for (i = 0; i < log.lh.n; i++) {
80102b04:	85 db                	test   %ebx,%ebx
	hb->n = log.lh.n;
80102b06:	89 58 5c             	mov    %ebx,0x5c(%eax)
	for (i = 0; i < log.lh.n; i++) {
80102b09:	7e 16                	jle    80102b21 <write_head+0x41>
80102b0b:	c1 e3 02             	shl    $0x2,%ebx
80102b0e:	31 d2                	xor    %edx,%edx
		hb->block[i] = log.lh.block[i];
80102b10:	8b 8a 4c f4 12 80    	mov    -0x7fed0bb4(%edx),%ecx
80102b16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b1a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <write_head+0x30>
	}
	bwrite(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	56                   	push   %esi
80102b25:	e8 76 d6 ff ff       	call   801001a0 <bwrite>
	brelse(buf);
80102b2a:	89 34 24             	mov    %esi,(%esp)
80102b2d:	e8 ae d6 ff ff       	call   801001e0 <brelse>
}
80102b32:	83 c4 10             	add    $0x10,%esp
80102b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b38:	5b                   	pop    %ebx
80102b39:	5e                   	pop    %esi
80102b3a:	5d                   	pop    %ebp
80102b3b:	c3                   	ret    
80102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b40 <initlog>:
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 2c             	sub    $0x2c,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&log.lock, "log");
80102b4a:	68 c0 85 10 80       	push   $0x801085c0
80102b4f:	68 00 f4 12 80       	push   $0x8012f400
80102b54:	e8 b7 1e 00 00       	call   80104a10 <initlock>
	readsb(dev, &sb);
80102b59:	58                   	pop    %eax
80102b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 9b e8 ff ff       	call   80101400 <readsb>
	log.size  = sb.nlog;
80102b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
	log.start = sb.logstart;
80102b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
	struct buf *      buf = bread(log.dev, log.start);
80102b6b:	59                   	pop    %ecx
	log.dev   = dev;
80102b6c:	89 1d 44 f4 12 80    	mov    %ebx,0x8012f444
	log.size  = sb.nlog;
80102b72:	89 15 38 f4 12 80    	mov    %edx,0x8012f438
	log.start = sb.logstart;
80102b78:	a3 34 f4 12 80       	mov    %eax,0x8012f434
	struct buf *      buf = bread(log.dev, log.start);
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 4b d5 ff ff       	call   801000d0 <bread>
	log.lh.n = lh->n;
80102b85:	8b 58 5c             	mov    0x5c(%eax),%ebx
	for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 db                	test   %ebx,%ebx
	log.lh.n = lh->n;
80102b8d:	89 1d 48 f4 12 80    	mov    %ebx,0x8012f448
	for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	c1 e3 02             	shl    $0x2,%ebx
80102b98:	31 d2                	xor    %edx,%edx
80102b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a 48 f4 12 80    	mov    %ecx,-0x7fed0bb8(%edx)
	for (i = 0; i < log.lh.n; i++) {
80102bad:	39 d3                	cmp    %edx,%ebx
80102baf:	75 ef                	jne    80102ba0 <initlog+0x60>
	brelse(buf);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	50                   	push   %eax
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
	read_head();
	install_trans(); // if committed, copy from log to disk
80102bba:	e8 81 fe ff ff       	call   80102a40 <install_trans>
	log.lh.n = 0;
80102bbf:	c7 05 48 f4 12 80 00 	movl   $0x0,0x8012f448
80102bc6:	00 00 00 
	write_head(); // clear the log
80102bc9:	e8 12 ff ff ff       	call   80102ae0 <write_head>
}
80102bce:	83 c4 10             	add    $0x10,%esp
80102bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    
80102bd6:	8d 76 00             	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 14             	sub    $0x14,%esp
	acquire(&log.lock);
80102be6:	68 00 f4 12 80       	push   $0x8012f400
80102beb:	e8 10 1f 00 00       	call   80104b00 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
	while (1) {
		if (log.committing) {
			sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 00 f4 12 80       	push   $0x8012f400
80102c00:	68 00 f4 12 80       	push   $0x8012f400
80102c05:	e8 a6 16 00 00       	call   801042b0 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
		if (log.committing) {
80102c0d:	a1 40 f4 12 80       	mov    0x8012f440,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
		} else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
80102c16:	a1 3c f4 12 80       	mov    0x8012f43c,%eax
80102c1b:	8b 15 48 f4 12 80    	mov    0x8012f448,%edx
80102c21:	83 c0 01             	add    $0x1,%eax
80102c24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c2a:	83 fa 1e             	cmp    $0x1e,%edx
80102c2d:	7f c9                	jg     80102bf8 <begin_op+0x18>
			// this op might exhaust log space; wait for commit.
			sleep(&log, &log.lock);
		} else {
			log.outstanding += 1;
			release(&log.lock);
80102c2f:	83 ec 0c             	sub    $0xc,%esp
			log.outstanding += 1;
80102c32:	a3 3c f4 12 80       	mov    %eax,0x8012f43c
			release(&log.lock);
80102c37:	68 00 f4 12 80       	push   $0x8012f400
80102c3c:	e8 df 1f 00 00       	call   80104c20 <release>
			break;
		}
	}
}
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	57                   	push   %edi
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 18             	sub    $0x18,%esp
	int do_commit = 0;

	acquire(&log.lock);
80102c59:	68 00 f4 12 80       	push   $0x8012f400
80102c5e:	e8 9d 1e 00 00       	call   80104b00 <acquire>
	log.outstanding -= 1;
80102c63:	a1 3c f4 12 80       	mov    0x8012f43c,%eax
	if (log.committing) panic("log.committing");
80102c68:	8b 35 40 f4 12 80    	mov    0x8012f440,%esi
80102c6e:	83 c4 10             	add    $0x10,%esp
	log.outstanding -= 1;
80102c71:	8d 58 ff             	lea    -0x1(%eax),%ebx
	if (log.committing) panic("log.committing");
80102c74:	85 f6                	test   %esi,%esi
	log.outstanding -= 1;
80102c76:	89 1d 3c f4 12 80    	mov    %ebx,0x8012f43c
	if (log.committing) panic("log.committing");
80102c7c:	0f 85 1a 01 00 00    	jne    80102d9c <end_op+0x14c>
	if (log.outstanding == 0) {
80102c82:	85 db                	test   %ebx,%ebx
80102c84:	0f 85 ee 00 00 00    	jne    80102d78 <end_op+0x128>
		// begin_op() may be waiting for log space,
		// and decrementing log.outstanding has decreased
		// the amount of reserved space.
		wakeup(&log);
	}
	release(&log.lock);
80102c8a:	83 ec 0c             	sub    $0xc,%esp
		log.committing = 1;
80102c8d:	c7 05 40 f4 12 80 01 	movl   $0x1,0x8012f440
80102c94:	00 00 00 
	release(&log.lock);
80102c97:	68 00 f4 12 80       	push   $0x8012f400
80102c9c:	e8 7f 1f 00 00       	call   80104c20 <release>
}

static void
commit()
{
	if (log.lh.n > 0) {
80102ca1:	8b 0d 48 f4 12 80    	mov    0x8012f448,%ecx
80102ca7:	83 c4 10             	add    $0x10,%esp
80102caa:	85 c9                	test   %ecx,%ecx
80102cac:	0f 8e 85 00 00 00    	jle    80102d37 <end_op+0xe7>
		struct buf *to   = bread(log.dev, log.start + tail + 1); // log block
80102cb2:	a1 34 f4 12 80       	mov    0x8012f434,%eax
80102cb7:	83 ec 08             	sub    $0x8,%esp
80102cba:	01 d8                	add    %ebx,%eax
80102cbc:	83 c0 01             	add    $0x1,%eax
80102cbf:	50                   	push   %eax
80102cc0:	ff 35 44 f4 12 80    	pushl  0x8012f444
80102cc6:	e8 05 d4 ff ff       	call   801000d0 <bread>
80102ccb:	89 c6                	mov    %eax,%esi
		struct buf *from = bread(log.dev, log.lh.block[tail]);   // cache block
80102ccd:	58                   	pop    %eax
80102cce:	5a                   	pop    %edx
80102ccf:	ff 34 9d 4c f4 12 80 	pushl  -0x7fed0bb4(,%ebx,4)
80102cd6:	ff 35 44 f4 12 80    	pushl  0x8012f444
	for (tail = 0; tail < log.lh.n; tail++) {
80102cdc:	83 c3 01             	add    $0x1,%ebx
		struct buf *from = bread(log.dev, log.lh.block[tail]);   // cache block
80102cdf:	e8 ec d3 ff ff       	call   801000d0 <bread>
80102ce4:	89 c7                	mov    %eax,%edi
		memmove(to->data, from->data, BSIZE);
80102ce6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ce9:	83 c4 0c             	add    $0xc,%esp
80102cec:	68 00 02 00 00       	push   $0x200
80102cf1:	50                   	push   %eax
80102cf2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cf5:	50                   	push   %eax
80102cf6:	e8 35 20 00 00       	call   80104d30 <memmove>
		bwrite(to); // write the log
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 9d d4 ff ff       	call   801001a0 <bwrite>
		brelse(from);
80102d03:	89 3c 24             	mov    %edi,(%esp)
80102d06:	e8 d5 d4 ff ff       	call   801001e0 <brelse>
		brelse(to);
80102d0b:	89 34 24             	mov    %esi,(%esp)
80102d0e:	e8 cd d4 ff ff       	call   801001e0 <brelse>
	for (tail = 0; tail < log.lh.n; tail++) {
80102d13:	83 c4 10             	add    $0x10,%esp
80102d16:	3b 1d 48 f4 12 80    	cmp    0x8012f448,%ebx
80102d1c:	7c 94                	jl     80102cb2 <end_op+0x62>
		write_log();     // Write modified blocks from cache to log
		write_head();    // Write header to disk -- the real commit
80102d1e:	e8 bd fd ff ff       	call   80102ae0 <write_head>
		install_trans(); // Now install writes to home locations
80102d23:	e8 18 fd ff ff       	call   80102a40 <install_trans>
		log.lh.n = 0;
80102d28:	c7 05 48 f4 12 80 00 	movl   $0x0,0x8012f448
80102d2f:	00 00 00 
		write_head(); // Erase the transaction from the log
80102d32:	e8 a9 fd ff ff       	call   80102ae0 <write_head>
		acquire(&log.lock);
80102d37:	83 ec 0c             	sub    $0xc,%esp
80102d3a:	68 00 f4 12 80       	push   $0x8012f400
80102d3f:	e8 bc 1d 00 00       	call   80104b00 <acquire>
		wakeup(&log);
80102d44:	c7 04 24 00 f4 12 80 	movl   $0x8012f400,(%esp)
		log.committing = 0;
80102d4b:	c7 05 40 f4 12 80 00 	movl   $0x0,0x8012f440
80102d52:	00 00 00 
		wakeup(&log);
80102d55:	e8 16 17 00 00       	call   80104470 <wakeup>
		release(&log.lock);
80102d5a:	c7 04 24 00 f4 12 80 	movl   $0x8012f400,(%esp)
80102d61:	e8 ba 1e 00 00       	call   80104c20 <release>
80102d66:	83 c4 10             	add    $0x10,%esp
}
80102d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6c:	5b                   	pop    %ebx
80102d6d:	5e                   	pop    %esi
80102d6e:	5f                   	pop    %edi
80102d6f:	5d                   	pop    %ebp
80102d70:	c3                   	ret    
80102d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		wakeup(&log);
80102d78:	83 ec 0c             	sub    $0xc,%esp
80102d7b:	68 00 f4 12 80       	push   $0x8012f400
80102d80:	e8 eb 16 00 00       	call   80104470 <wakeup>
	release(&log.lock);
80102d85:	c7 04 24 00 f4 12 80 	movl   $0x8012f400,(%esp)
80102d8c:	e8 8f 1e 00 00       	call   80104c20 <release>
80102d91:	83 c4 10             	add    $0x10,%esp
}
80102d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d97:	5b                   	pop    %ebx
80102d98:	5e                   	pop    %esi
80102d99:	5f                   	pop    %edi
80102d9a:	5d                   	pop    %ebp
80102d9b:	c3                   	ret    
	if (log.committing) panic("log.committing");
80102d9c:	83 ec 0c             	sub    $0xc,%esp
80102d9f:	68 c4 85 10 80       	push   $0x801085c4
80102da4:	e8 e7 d5 ff ff       	call   80100390 <panic>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102db0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 04             	sub    $0x4,%esp
	int i;

	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102db7:	8b 15 48 f4 12 80    	mov    0x8012f448,%edx
{
80102dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102dc0:	83 fa 1d             	cmp    $0x1d,%edx
80102dc3:	0f 8f 9d 00 00 00    	jg     80102e66 <log_write+0xb6>
80102dc9:	a1 38 f4 12 80       	mov    0x8012f438,%eax
80102dce:	83 e8 01             	sub    $0x1,%eax
80102dd1:	39 c2                	cmp    %eax,%edx
80102dd3:	0f 8d 8d 00 00 00    	jge    80102e66 <log_write+0xb6>
	if (log.outstanding < 1) panic("log_write outside of trans");
80102dd9:	a1 3c f4 12 80       	mov    0x8012f43c,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 8d 00 00 00    	jle    80102e73 <log_write+0xc3>

	acquire(&log.lock);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	68 00 f4 12 80       	push   $0x8012f400
80102dee:	e8 0d 1d 00 00       	call   80104b00 <acquire>
	for (i = 0; i < log.lh.n; i++) {
80102df3:	8b 0d 48 f4 12 80    	mov    0x8012f448,%ecx
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	83 f9 00             	cmp    $0x0,%ecx
80102dff:	7e 57                	jle    80102e58 <log_write+0xa8>
		if (log.lh.block[i] == b->blockno) // log absorbtion
80102e01:	8b 53 08             	mov    0x8(%ebx),%edx
	for (i = 0; i < log.lh.n; i++) {
80102e04:	31 c0                	xor    %eax,%eax
		if (log.lh.block[i] == b->blockno) // log absorbtion
80102e06:	3b 15 4c f4 12 80    	cmp    0x8012f44c,%edx
80102e0c:	75 0b                	jne    80102e19 <log_write+0x69>
80102e0e:	eb 38                	jmp    80102e48 <log_write+0x98>
80102e10:	39 14 85 4c f4 12 80 	cmp    %edx,-0x7fed0bb4(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
	for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 c1                	cmp    %eax,%ecx
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
			break;
	}
	log.lh.block[i] = b->blockno;
80102e20:	89 14 85 4c f4 12 80 	mov    %edx,-0x7fed0bb4(,%eax,4)
	if (i == log.lh.n) log.lh.n++;
80102e27:	83 c0 01             	add    $0x1,%eax
80102e2a:	a3 48 f4 12 80       	mov    %eax,0x8012f448
	b->flags |= B_DIRTY; // prevent eviction
80102e2f:	83 0b 04             	orl    $0x4,(%ebx)
	release(&log.lock);
80102e32:	c7 45 08 00 f4 12 80 	movl   $0x8012f400,0x8(%ebp)
}
80102e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3c:	c9                   	leave  
	release(&log.lock);
80102e3d:	e9 de 1d 00 00       	jmp    80104c20 <release>
80102e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	log.lh.block[i] = b->blockno;
80102e48:	89 14 85 4c f4 12 80 	mov    %edx,-0x7fed0bb4(,%eax,4)
80102e4f:	eb de                	jmp    80102e2f <log_write+0x7f>
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8b 43 08             	mov    0x8(%ebx),%eax
80102e5b:	a3 4c f4 12 80       	mov    %eax,0x8012f44c
	if (i == log.lh.n) log.lh.n++;
80102e60:	75 cd                	jne    80102e2f <log_write+0x7f>
80102e62:	31 c0                	xor    %eax,%eax
80102e64:	eb c1                	jmp    80102e27 <log_write+0x77>
	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	68 d3 85 10 80       	push   $0x801085d3
80102e6e:	e8 1d d5 ff ff       	call   80100390 <panic>
	if (log.outstanding < 1) panic("log_write outside of trans");
80102e73:	83 ec 0c             	sub    $0xc,%esp
80102e76:	68 e9 85 10 80       	push   $0x801085e9
80102e7b:	e8 10 d5 ff ff       	call   80100390 <panic>

80102e80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
	cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e87:	e8 64 0a 00 00       	call   801038f0 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 5d 0a 00 00       	call   801038f0 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 04 86 10 80       	push   $0x80108604
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
	idtinit();                    // load idt register
80102ea2:	e8 29 38 00 00       	call   801066d0 <idtinit>
	xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 c4 09 00 00       	call   80103870 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
	uint result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" : "+m"(*addr), "=a"(result) : "1"(newval) : "cc");
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
	scheduler();                  // start running processes
80102eba:	e8 41 0f 00 00       	call   80103e00 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
	switchkvm();
80102ec6:	e8 45 49 00 00       	call   80107810 <switchkvm>
	seginit();
80102ecb:	e8 b0 48 00 00       	call   80107780 <seginit>
	lapicinit();
80102ed0:	e8 9b f7 ff ff       	call   80102670 <lapicinit>
	mpmain();
80102ed5:	e8 a6 ff ff ff       	call   80102e80 <mpmain>
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <main>:
{
80102ee0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ee4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ee7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eea:	55                   	push   %ebp
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	53                   	push   %ebx
80102eee:	51                   	push   %ecx
	kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
80102eef:	83 ec 08             	sub    $0x8,%esp
80102ef2:	68 00 00 40 80       	push   $0x80400000
80102ef7:	68 08 05 13 80       	push   $0x80130508
80102efc:	e8 2f f5 ff ff       	call   80102430 <kinit1>
	kvmalloc();                                 // kernel page table
80102f01:	e8 da 4d 00 00       	call   80107ce0 <kvmalloc>
	mpinit();                                   // detect other processors
80102f06:	e8 75 01 00 00       	call   80103080 <mpinit>
	lapicinit();                                // interrupt controller
80102f0b:	e8 60 f7 ff ff       	call   80102670 <lapicinit>
	seginit();                                  // segment descriptors
80102f10:	e8 6b 48 00 00       	call   80107780 <seginit>
	picinit();                                  // disable pic
80102f15:	e8 46 03 00 00       	call   80103260 <picinit>
	ioapicinit();                               // another interrupt controller
80102f1a:	e8 41 f3 ff ff       	call   80102260 <ioapicinit>
	consoleinit();                              // console hardware
80102f1f:	e8 9c da ff ff       	call   801009c0 <consoleinit>
	uartinit();                                 // serial port
80102f24:	e8 d7 3a 00 00       	call   80106a00 <uartinit>
	pinit();                                    // process table
80102f29:	e8 22 09 00 00       	call   80103850 <pinit>
	tvinit();                                   // trap vectors
80102f2e:	e8 1d 37 00 00       	call   80106650 <tvinit>
	binit();                                    // buffer cache
80102f33:	e8 08 d1 ff ff       	call   80100040 <binit>
	fileinit();                                 // file table
80102f38:	e8 53 de ff ff       	call   80100d90 <fileinit>
	ideinit();                                  // disk
80102f3d:	e8 fe f0 ff ff       	call   80102040 <ideinit>

	// Write entry code to unused memory at 0x7000.
	// The linker has placed the image of entryother.S in
	// _binary_entryother_start.
	code = P2V(0x7000);
	memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f42:	83 c4 0c             	add    $0xc,%esp
80102f45:	68 8a 00 00 00       	push   $0x8a
80102f4a:	68 8c b4 10 80       	push   $0x8010b48c
80102f4f:	68 00 70 00 80       	push   $0x80007000
80102f54:	e8 d7 1d 00 00       	call   80104d30 <memmove>

	for (c = cpus; c < cpus + ncpu; c++) {
80102f59:	69 05 80 fa 12 80 b0 	imul   $0xb0,0x8012fa80,%eax
80102f60:	00 00 00 
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	05 00 f5 12 80       	add    $0x8012f500,%eax
80102f6b:	3d 00 f5 12 80       	cmp    $0x8012f500,%eax
80102f70:	76 71                	jbe    80102fe3 <main+0x103>
80102f72:	bb 00 f5 12 80       	mov    $0x8012f500,%ebx
80102f77:	89 f6                	mov    %esi,%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if (c == mycpu()) // We've started already.
80102f80:	e8 eb 08 00 00       	call   80103870 <mycpu>
80102f85:	39 d8                	cmp    %ebx,%eax
80102f87:	74 41                	je     80102fca <main+0xea>
			continue;

		// Tell entryother.S what stack to use, where to enter, and what
		// pgdir to use. We cannot use kpgdir yet, because the AP processor
		// is running in low  memory, so we use entrypgdir for the APs too.
		stack                = kalloc();
80102f89:	e8 72 f5 ff ff       	call   80102500 <kalloc>
		*(void **)(code - 4) = stack + KSTACKSIZE;
80102f8e:	05 00 10 00 00       	add    $0x1000,%eax
		*(void **)(code - 8) = mpenter;
80102f93:	c7 05 f8 6f 00 80 c0 	movl   $0x80102ec0,0x80006ff8
80102f9a:	2e 10 80 
		*(int **)(code - 12) = (void *)V2P(entrypgdir);
80102f9d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102fa4:	a0 10 00 
		*(void **)(code - 4) = stack + KSTACKSIZE;
80102fa7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

		lapicstartap(c->apicid, V2P(code));
80102fac:	0f b6 03             	movzbl (%ebx),%eax
80102faf:	83 ec 08             	sub    $0x8,%esp
80102fb2:	68 00 70 00 00       	push   $0x7000
80102fb7:	50                   	push   %eax
80102fb8:	e8 03 f8 ff ff       	call   801027c0 <lapicstartap>
80102fbd:	83 c4 10             	add    $0x10,%esp

		// wait for cpu to finish mpmain()
		while (c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0xe0>
	for (c = cpus; c < cpus + ncpu; c++) {
80102fca:	69 05 80 fa 12 80 b0 	imul   $0xb0,0x8012fa80,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fda:	05 00 f5 12 80       	add    $0x8012f500,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 9d                	jb     80102f80 <main+0xa0>
	kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 ab f4 ff ff       	call   801024a0 <kinit2>
	userinit();                                 // first user process
80102ff5:	e8 46 09 00 00       	call   80103940 <userinit>
	mpmain();                                   // finish this processor's setup
80102ffa:	e8 81 fe ff ff       	call   80102e80 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp *
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
	uchar *e, *p, *addr;

	addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010300b:	53                   	push   %ebx
	e    = addr + len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
	for (p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	72 10                	jb     80103026 <mpsearch1+0x26>
80103016:	eb 50                	jmp    80103068 <mpsearch1+0x68>
80103018:	90                   	nop
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	39 fb                	cmp    %edi,%ebx
80103022:	89 fe                	mov    %edi,%esi
80103024:	76 42                	jbe    80103068 <mpsearch1+0x68>
		if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) return (struct mp *)p;
80103026:	83 ec 04             	sub    $0x4,%esp
80103029:	8d 7e 10             	lea    0x10(%esi),%edi
8010302c:	6a 04                	push   $0x4
8010302e:	68 18 86 10 80       	push   $0x80108618
80103033:	56                   	push   %esi
80103034:	e8 97 1c 00 00       	call   80104cd0 <memcmp>
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 e0                	jne    80103020 <mpsearch1+0x20>
80103040:	89 f1                	mov    %esi,%ecx
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (i = 0; i < len; i++) sum += addr[i];
80103048:	0f b6 11             	movzbl (%ecx),%edx
8010304b:	83 c1 01             	add    $0x1,%ecx
8010304e:	01 d0                	add    %edx,%eax
80103050:	39 f9                	cmp    %edi,%ecx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
		if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) return (struct mp *)p;
80103054:	84 c0                	test   %al,%al
80103056:	75 c8                	jne    80103020 <mpsearch1+0x20>
	return 0;
}
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305b:	89 f0                	mov    %esi,%eax
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
8010306b:	31 f6                	xor    %esi,%esi
}
8010306d:	89 f0                	mov    %esi,%eax
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
80103074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010307a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103080 <mpinit>:
	return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
	if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
		p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024))) return mp;
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
		if ((mp = mpsearch1(p, 1024))) return mp;
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 3d 01 00 00    	je     80103210 <mpinit+0x190>
	if ((mp = mpsearch()) == 0 || mp->physaddr == 0) return 0;
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 4f 01 00 00    	je     80103230 <mpinit+0x1b0>
	conf = (struct mpconf *)P2V((uint)mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
	if (memcmp(conf, "PCMP", 4) != 0) return 0;
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 35 86 10 80       	push   $0x80108635
801030f1:	56                   	push   %esi
801030f2:	e8 d9 1b 00 00       	call   80104cd0 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 2e 01 00 00    	jne    80103230 <mpinit+0x1b0>
	if (conf->version != 1 && conf->version != 4) return 0;
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	0f 95 c2             	setne  %dl
8010310e:	3c 04                	cmp    $0x4,%al
80103110:	0f 95 c0             	setne  %al
80103113:	20 c2                	and    %al,%dl
80103115:	0f 85 15 01 00 00    	jne    80103230 <mpinit+0x1b0>
	if (sum((uchar *)conf, conf->length) != 0) return 0;
8010311b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
	for (i = 0; i < len; i++) sum += addr[i];
80103122:	66 85 ff             	test   %di,%di
80103125:	74 1a                	je     80103141 <mpinit+0xc1>
80103127:	89 f0                	mov    %esi,%eax
80103129:	01 f7                	add    %esi,%edi
	sum = 0;
8010312b:	31 d2                	xor    %edx,%edx
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < len; i++) sum += addr[i];
80103130:	0f b6 08             	movzbl (%eax),%ecx
80103133:	83 c0 01             	add    $0x1,%eax
80103136:	01 ca                	add    %ecx,%edx
80103138:	39 c7                	cmp    %eax,%edi
8010313a:	75 f4                	jne    80103130 <mpinit+0xb0>
8010313c:	84 d2                	test   %dl,%dl
8010313e:	0f 95 c2             	setne  %dl
	struct mp *      mp;
	struct mpconf *  conf;
	struct mpproc *  proc;
	struct mpioapic *ioapic;

	if ((conf = mpconfig(&mp)) == 0) panic("Expect to run on an SMP");
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 e7 00 00 00    	je     80103230 <mpinit+0x1b0>
80103149:	84 d2                	test   %dl,%dl
8010314b:	0f 85 df 00 00 00    	jne    80103230 <mpinit+0x1b0>
	ismp  = 1;
	lapic = (uint *)conf->lapicaddr;
80103151:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103157:	a3 fc f3 12 80       	mov    %eax,0x8012f3fc
	for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
8010315c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103163:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
	ismp  = 1;
80103169:	bb 01 00 00 00       	mov    $0x1,%ebx
	for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
8010316e:	01 d6                	add    %edx,%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
		switch (*p) {
80103174:	0f b6 10             	movzbl (%eax),%edx
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 ca 00 00 00    	ja     8010324a <mpinit+0x1ca>
80103180:	ff 24 95 5c 86 10 80 	jmp    *-0x7fef79a4(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			p += sizeof(struct mpioapic);
			continue;
		case MPBUS:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
80103190:	83 c0 08             	add    $0x8,%eax
	for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
		default:
			ismp = 0;
			break;
		}
	}
	if (!ismp) panic("Didn't find a suitable machine");
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 9e 00 00 00    	je     8010323d <mpinit+0x1bd>

	if (mp->imcrp) {
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801031a8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
		// Bochs doesn't support IMCR, so this doesn't run on Bochs.
		// But it would on real hardware.
		outb(0x22, 0x70);          // Select IMCR
		outb(0x23, inb(0x23) | 1); // Mask external interrupts.
801031b9:	83 c8 01             	or     $0x1,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801031bc:	ee                   	out    %al,(%dx)
	}
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
			if (ncpu < NCPU) {
801031c8:	8b 0d 80 fa 12 80    	mov    0x8012fa80,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
				cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
				ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 80 fa 12 80    	mov    %ecx,0x8012fa80
				cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
801031e6:	88 97 00 f5 12 80    	mov    %dl,-0x7fed0b00(%edi)
			p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
			continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
			p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
			ioapicid = ioapic->apicno;
801031ff:	88 15 e0 f4 12 80    	mov    %dl,0x8012f4e0
			continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
	if ((mp = mpsearch()) == 0 || mp->physaddr == 0) return 0;
8010321f:	85 c0                	test   %eax,%eax
	return mpsearch1(0xF0000, 0x10000);
80103221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0 || mp->physaddr == 0) return 0;
80103224:	0f 85 a9 fe ff ff    	jne    801030d3 <mpinit+0x53>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((conf = mpconfig(&mp)) == 0) panic("Expect to run on an SMP");
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 1d 86 10 80       	push   $0x8010861d
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
	if (!ismp) panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 3c 86 10 80       	push   $0x8010863c
80103245:	e8 46 d1 ff ff       	call   80100390 <panic>
			ismp = 0;
8010324a:	31 db                	xor    %ebx,%ebx
8010324c:	e9 26 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103251:	66 90                	xchg   %ax,%ax
80103253:	66 90                	xchg   %ax,%ax
80103255:	66 90                	xchg   %ax,%ax
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picinit>:
#define IO_PIC2 0xA0 // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	ba 21 00 00 00       	mov    $0x21,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	ee                   	out    %al,(%dx)
8010326e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103273:	ee                   	out    %al,(%dx)
	// mask all interrupts
	outb(IO_PIC1 + 1, 0xFF);
	outb(IO_PIC2 + 1, 0xFF);
}
80103274:	5d                   	pop    %ebp
80103275:	c3                   	ret    
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <pipealloc>:
	int             writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct pipe *p;

	p   = 0;
	*f0 = *f1 = 0;
8010328f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
8010329b:	e8 10 db ff ff       	call   80100db0 <filealloc>
801032a0:	85 c0                	test   %eax,%eax
801032a2:	89 03                	mov    %eax,(%ebx)
801032a4:	74 22                	je     801032c8 <pipealloc+0x48>
801032a6:	e8 05 db ff ff       	call   80100db0 <filealloc>
801032ab:	85 c0                	test   %eax,%eax
801032ad:	89 06                	mov    %eax,(%esi)
801032af:	74 3f                	je     801032f0 <pipealloc+0x70>
	if ((p = (struct pipe *)kalloc()) == 0) goto bad;
801032b1:	e8 4a f2 ff ff       	call   80102500 <kalloc>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 c7                	mov    %eax,%edi
801032ba:	75 54                	jne    80103310 <pipealloc+0x90>
	return 0;

// PAGEBREAK: 20
bad:
	if (p) kfree((char *)p);
	if (*f0) fileclose(*f0);
801032bc:	8b 03                	mov    (%ebx),%eax
801032be:	85 c0                	test   %eax,%eax
801032c0:	75 34                	jne    801032f6 <pipealloc+0x76>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (*f1) fileclose(*f1);
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 0c                	je     801032da <pipealloc+0x5a>
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	50                   	push   %eax
801032d2:	e8 99 db ff ff       	call   80100e70 <fileclose>
801032d7:	83 c4 10             	add    $0x10,%esp
	return -1;
}
801032da:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
801032dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (*f0) fileclose(*f0);
801032f0:	8b 03                	mov    (%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 e4                	je     801032da <pipealloc+0x5a>
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	50                   	push   %eax
801032fa:	e8 71 db ff ff       	call   80100e70 <fileclose>
	if (*f1) fileclose(*f1);
801032ff:	8b 06                	mov    (%esi),%eax
	if (*f0) fileclose(*f0);
80103301:	83 c4 10             	add    $0x10,%esp
	if (*f1) fileclose(*f1);
80103304:	85 c0                	test   %eax,%eax
80103306:	75 c6                	jne    801032ce <pipealloc+0x4e>
80103308:	eb d0                	jmp    801032da <pipealloc+0x5a>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	initlock(&p->lock, "pipe");
80103310:	83 ec 08             	sub    $0x8,%esp
	p->readopen  = 1;
80103313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331a:	00 00 00 
	p->writeopen = 1;
8010331d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103324:	00 00 00 
	p->nwrite    = 0;
80103327:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332e:	00 00 00 
	p->nread     = 0;
80103331:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103338:	00 00 00 
	initlock(&p->lock, "pipe");
8010333b:	68 70 86 10 80       	push   $0x80108670
80103340:	50                   	push   %eax
80103341:	e8 ca 16 00 00       	call   80104a10 <initlock>
	(*f0)->type     = FD_PIPE;
80103346:	8b 03                	mov    (%ebx),%eax
	return 0;
80103348:	83 c4 10             	add    $0x10,%esp
	(*f0)->type     = FD_PIPE;
8010334b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	(*f0)->readable = 1;
80103351:	8b 03                	mov    (%ebx),%eax
80103353:	c6 40 08 01          	movb   $0x1,0x8(%eax)
	(*f0)->writable = 0;
80103357:	8b 03                	mov    (%ebx),%eax
80103359:	c6 40 09 00          	movb   $0x0,0x9(%eax)
	(*f0)->pipe     = p;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	89 78 0c             	mov    %edi,0xc(%eax)
	(*f1)->type     = FD_PIPE;
80103362:	8b 06                	mov    (%esi),%eax
80103364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	(*f1)->readable = 0;
8010336a:	8b 06                	mov    (%esi),%eax
8010336c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
	(*f1)->writable = 1;
80103370:	8b 06                	mov    (%esi),%eax
80103372:	c6 40 09 01          	movb   $0x1,0x9(%eax)
	(*f1)->pipe     = p;
80103376:	8b 06                	mov    (%esi),%eax
80103378:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
8010337e:	31 c0                	xor    %eax,%eax
}
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	56                   	push   %esi
80103394:	53                   	push   %ebx
80103395:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103398:	8b 75 0c             	mov    0xc(%ebp),%esi
	acquire(&p->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	53                   	push   %ebx
8010339f:	e8 5c 17 00 00       	call   80104b00 <acquire>
	if (writable) {
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 f6                	test   %esi,%esi
801033a9:	74 45                	je     801033f0 <pipeclose+0x60>
		p->writeopen = 0;
		wakeup(&p->nread);
801033ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b1:	83 ec 0c             	sub    $0xc,%esp
		p->writeopen = 0;
801033b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033bb:	00 00 00 
		wakeup(&p->nread);
801033be:	50                   	push   %eax
801033bf:	e8 ac 10 00 00       	call   80104470 <wakeup>
801033c4:	83 c4 10             	add    $0x10,%esp
	} else {
		p->readopen = 0;
		wakeup(&p->nwrite);
	}
	if (p->readopen == 0 && p->writeopen == 0) {
801033c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cd:	85 d2                	test   %edx,%edx
801033cf:	75 0a                	jne    801033db <pipeclose+0x4b>
801033d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	74 35                	je     80103410 <pipeclose+0x80>
		release(&p->lock);
		kfree((char *)p);
	} else
		release(&p->lock);
801033db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e1:	5b                   	pop    %ebx
801033e2:	5e                   	pop    %esi
801033e3:	5d                   	pop    %ebp
		release(&p->lock);
801033e4:	e9 37 18 00 00       	jmp    80104c20 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
		p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
		wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 67 10 00 00       	call   80104470 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
		release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 07 18 00 00       	call   80104c20 <release>
		kfree((char *)p);
80103419:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010341c:	83 c4 10             	add    $0x10,%esp
}
8010341f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5d                   	pop    %ebp
		kfree((char *)p);
80103425:	e9 26 ef ff ff       	jmp    80102350 <kfree>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103430 <pipewrite>:

// PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 28             	sub    $0x28,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;

	acquire(&p->lock);
8010343c:	53                   	push   %ebx
8010343d:	e8 be 16 00 00       	call   80104b00 <acquire>
	for (i = 0; i < n; i++) {
80103442:	8b 45 10             	mov    0x10(%ebp),%eax
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 8e c9 00 00 00    	jle    80103519 <pipewrite+0xe9>
80103450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103453:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
			if (p->readopen == 0 || myproc()->killed) {
				release(&p->lock);
				return -1;
			}
			wakeup(&p->nread);
80103459:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010345f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103462:	03 4d 10             	add    0x10(%ebp),%ecx
80103465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
80103468:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010346e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103474:	39 d0                	cmp    %edx,%eax
80103476:	75 71                	jne    801034e9 <pipewrite+0xb9>
			if (p->readopen == 0 || myproc()->killed) {
80103478:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	74 4e                	je     801034d0 <pipewrite+0xa0>
			sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
80103482:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103488:	eb 3a                	jmp    801034c4 <pipewrite+0x94>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			wakeup(&p->nread);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	57                   	push   %edi
80103494:	e8 d7 0f 00 00       	call   80104470 <wakeup>
			sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 0e 0e 00 00       	call   801042b0 <sleep>
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
801034a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ae:	83 c4 10             	add    $0x10,%esp
801034b1:	05 00 02 00 00       	add    $0x200,%eax
801034b6:	39 c2                	cmp    %eax,%edx
801034b8:	75 36                	jne    801034f0 <pipewrite+0xc0>
			if (p->readopen == 0 || myproc()->killed) {
801034ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034c0:	85 c0                	test   %eax,%eax
801034c2:	74 0c                	je     801034d0 <pipewrite+0xa0>
801034c4:	e8 47 04 00 00       	call   80103910 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
				release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 47 17 00 00       	call   80104c20 <release>
				return -1;
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		p->data[p->nwrite++ % PIPESIZE] = addr[i];
	}
	wakeup(&p->nread); // DOC: pipewrite-wakeup1
	release(&p->lock);
	return n;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034f3:	8d 42 01             	lea    0x1(%edx),%eax
801034f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103502:	83 c6 01             	add    $0x1,%esi
80103505:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
	for (i = 0; i < n; i++) {
80103509:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010350c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
		p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010350f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
	for (i = 0; i < n; i++) {
80103513:	0f 85 4f ff ff ff    	jne    80103468 <pipewrite+0x38>
	wakeup(&p->nread); // DOC: pipewrite-wakeup1
80103519:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	50                   	push   %eax
80103523:	e8 48 0f 00 00       	call   80104470 <wakeup>
	release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 f0 16 00 00       	call   80104c20 <release>
	return n;
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	8b 45 10             	mov    0x10(%ebp),%eax
80103536:	eb a9                	jmp    801034e1 <pipewrite+0xb1>
80103538:	90                   	nop
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 18             	sub    $0x18,%esp
80103549:	8b 75 08             	mov    0x8(%ebp),%esi
8010354c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i;

	acquire(&p->lock);
8010354f:	56                   	push   %esi
80103550:	e8 ab 15 00 00       	call   80104b00 <acquire>
	while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010355e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103564:	75 6a                	jne    801035d0 <piperead+0x90>
80103566:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010356c:	85 db                	test   %ebx,%ebx
8010356e:	0f 84 c4 00 00 00    	je     80103638 <piperead+0xf8>
		if (myproc()->killed) {
			release(&p->lock);
			return -1;
		}
		sleep(&p->nread, &p->lock); // DOC: piperead-sleep
80103574:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010357a:	eb 2d                	jmp    801035a9 <piperead+0x69>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	e8 26 0d 00 00       	call   801042b0 <sleep>
	while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
		if (myproc()->killed) {
801035a9:	e8 62 03 00 00       	call   80103910 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
			release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
			return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
			release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 5d 16 00 00       	call   80104c20 <release>
			return -1;
801035c3:	83 c4 10             	add    $0x10,%esp
		addr[i] = p->data[p->nread++ % PIPESIZE];
	}
	wakeup(&p->nwrite); // DOC: piperead-wakeup
	release(&p->lock);
	return i;
}
801035c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c9:	89 d8                	mov    %ebx,%eax
801035cb:	5b                   	pop    %ebx
801035cc:	5e                   	pop    %esi
801035cd:	5f                   	pop    %edi
801035ce:	5d                   	pop    %ebp
801035cf:	c3                   	ret    
	for (i = 0; i < n; i++) { // DOC: piperead-copy
801035d0:	8b 45 10             	mov    0x10(%ebp),%eax
801035d3:	85 c0                	test   %eax,%eax
801035d5:	7e 61                	jle    80103638 <piperead+0xf8>
		if (p->nread == p->nwrite) break;
801035d7:	31 db                	xor    %ebx,%ebx
801035d9:	eb 13                	jmp    801035ee <piperead+0xae>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ec:	74 1f                	je     8010360d <piperead+0xcd>
		addr[i] = p->data[p->nread++ % PIPESIZE];
801035ee:	8d 41 01             	lea    0x1(%ecx),%eax
801035f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103602:	88 04 1f             	mov    %al,(%edi,%ebx,1)
	for (i = 0; i < n; i++) { // DOC: piperead-copy
80103605:	83 c3 01             	add    $0x1,%ebx
80103608:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010360b:	75 d3                	jne    801035e0 <piperead+0xa0>
	wakeup(&p->nwrite); // DOC: piperead-wakeup
8010360d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	50                   	push   %eax
80103617:	e8 54 0e 00 00       	call   80104470 <wakeup>
	release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 fc 15 00 00       	call   80104c20 <release>
	return i;
80103624:	83 c4 10             	add    $0x10,%esp
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	89 d8                	mov    %ebx,%eax
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	31 db                	xor    %ebx,%ebx
8010363a:	eb d1                	jmp    8010360d <piperead+0xcd>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <wakeup1>:
// PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103640:	55                   	push   %ebp
	struct proc *p;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103641:	b9 f4 1f 11 80       	mov    $0x80111ff4,%ecx
{
80103646:	89 e5                	mov    %esp,%ebp
80103648:	57                   	push   %edi
80103649:	56                   	push   %esi
8010364a:	53                   	push   %ebx
8010364b:	83 ec 1c             	sub    $0x1c,%esp
8010364e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103651:	eb 17                	jmp    8010366a <wakeup1+0x2a>
80103653:	90                   	nop
80103654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103658:	81 c1 50 01 00 00    	add    $0x150,%ecx
8010365e:	81 f9 f4 73 11 80    	cmp    $0x801173f4,%ecx
80103664:	0f 83 89 00 00 00    	jae    801036f3 <wakeup1+0xb3>
		if (p->state == SLEEPING && p->chan == chan){
8010366a:	83 79 0c 02          	cmpl   $0x2,0xc(%ecx)
8010366e:	75 e8                	jne    80103658 <wakeup1+0x18>
80103670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103673:	39 41 20             	cmp    %eax,0x20(%ecx)
80103676:	75 e0                	jne    80103658 <wakeup1+0x18>
	if (!(p->state == RUNNABLE)){
		// process must be runnable to be placed in queue
		return -1;
	}
	
	int priority = p->priority;
80103678:	8b b9 cc 00 00 00    	mov    0xcc(%ecx),%edi
			p->state = RUNNABLE;
8010367e:	c7 41 0c 03 00 00 00 	movl   $0x3,0xc(%ecx)
	int head = ptable.head_tail[priority][0];
	int tail = ptable.head_tail[priority][1];

	if (tail == (head-1)%QSIZE){
80103685:	8b 04 fd f4 73 11 80 	mov    -0x7fee8c0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
8010368c:	8b 1c fd f8 73 11 80 	mov    -0x7fee8c08(,%edi,8),%ebx
	if (tail == (head-1)%QSIZE){
80103693:	8d 70 ff             	lea    -0x1(%eax),%esi
80103696:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
8010369b:	f7 ee                	imul   %esi
8010369d:	89 f0                	mov    %esi,%eax
8010369f:	c1 f8 1f             	sar    $0x1f,%eax
801036a2:	c1 fa 05             	sar    $0x5,%edx
801036a5:	29 c2                	sub    %eax,%edx
801036a7:	6b d2 64             	imul   $0x64,%edx,%edx
801036aa:	29 d6                	sub    %edx,%esi
801036ac:	39 f3                	cmp    %esi,%ebx
801036ae:	74 4b                	je     801036fb <wakeup1+0xbb>
		// queue is full
		return -1;
	}

	//update tail
	ptable.pqueues[priority][tail] =  p;
801036b0:	6b c7 64             	imul   $0x64,%edi,%eax
801036b3:	8d 84 03 34 15 00 00 	lea    0x1534(%ebx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801036ba:	83 c3 01             	add    $0x1,%ebx
	ptable.pqueues[priority][tail] =  p;
801036bd:	89 0c 85 c4 1f 11 80 	mov    %ecx,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801036c4:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036c9:	81 c1 50 01 00 00    	add    $0x150,%ecx
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801036cf:	f7 eb                	imul   %ebx
801036d1:	89 d8                	mov    %ebx,%eax
801036d3:	c1 f8 1f             	sar    $0x1f,%eax
801036d6:	c1 fa 05             	sar    $0x5,%edx
801036d9:	29 c2                	sub    %eax,%edx
801036db:	6b d2 64             	imul   $0x64,%edx,%edx
801036de:	29 d3                	sub    %edx,%ebx
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036e0:	81 f9 f4 73 11 80    	cmp    $0x801173f4,%ecx
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801036e6:	89 1c fd f8 73 11 80 	mov    %ebx,-0x7fee8c08(,%edi,8)
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036ed:	0f 82 77 ff ff ff    	jb     8010366a <wakeup1+0x2a>
}
801036f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036f6:	5b                   	pop    %ebx
801036f7:	5e                   	pop    %esi
801036f8:	5f                   	pop    %edi
801036f9:	5d                   	pop    %ebp
801036fa:	c3                   	ret    
				panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	68 78 86 10 80       	push   $0x80108678
80103703:	e8 88 cc ff ff       	call   80100390 <panic>
80103708:	90                   	nop
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103710 <allocproc>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103714:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
{
80103719:	83 ec 10             	sub    $0x10,%esp
	acquire(&ptable.lock);
8010371c:	68 c0 1f 11 80       	push   $0x80111fc0
80103721:	e8 da 13 00 00       	call   80104b00 <acquire>
80103726:	83 c4 10             	add    $0x10,%esp
80103729:	eb 17                	jmp    80103742 <allocproc+0x32>
8010372b:	90                   	nop
8010372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103730:	81 c3 50 01 00 00    	add    $0x150,%ebx
80103736:	81 fb f4 73 11 80    	cmp    $0x801173f4,%ebx
8010373c:	0f 83 96 00 00 00    	jae    801037d8 <allocproc+0xc8>
		if (p->state == UNUSED) goto found;
80103742:	8b 43 0c             	mov    0xc(%ebx),%eax
80103745:	85 c0                	test   %eax,%eax
80103747:	75 e7                	jne    80103730 <allocproc+0x20>
	p->pid   = nextpid++;
80103749:	a1 08 b0 10 80       	mov    0x8010b008,%eax
	release(&ptable.lock);
8010374e:	83 ec 0c             	sub    $0xc,%esp
	p->state = EMBRYO;
80103751:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	p->pid   = nextpid++;
80103758:	8d 50 01             	lea    0x1(%eax),%edx
8010375b:	89 43 10             	mov    %eax,0x10(%ebx)
	release(&ptable.lock);
8010375e:	68 c0 1f 11 80       	push   $0x80111fc0
	p->pid   = nextpid++;
80103763:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
	release(&ptable.lock);
80103769:	e8 b2 14 00 00       	call   80104c20 <release>
	if ((p->kstack = kalloc()) == 0) {
8010376e:	e8 8d ed ff ff       	call   80102500 <kalloc>
80103773:	83 c4 10             	add    $0x10,%esp
80103776:	85 c0                	test   %eax,%eax
80103778:	89 43 08             	mov    %eax,0x8(%ebx)
8010377b:	74 74                	je     801037f1 <allocproc+0xe1>
	sp -= sizeof *p->tf;
8010377d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
	memset(p->context, 0, sizeof *p->context);
80103783:	83 ec 04             	sub    $0x4,%esp
	sp -= sizeof *p->context;
80103786:	05 9c 0f 00 00       	add    $0xf9c,%eax
	sp -= sizeof *p->tf;
8010378b:	89 53 18             	mov    %edx,0x18(%ebx)
	*(uint *)sp = (uint)trapret;
8010378e:	c7 40 14 3f 66 10 80 	movl   $0x8010663f,0x14(%eax)
	p->context = (struct context *)sp;
80103795:	89 43 1c             	mov    %eax,0x1c(%ebx)
	memset(p->context, 0, sizeof *p->context);
80103798:	6a 14                	push   $0x14
8010379a:	6a 00                	push   $0x0
8010379c:	50                   	push   %eax
8010379d:	e8 de 14 00 00       	call   80104c80 <memset>
	p->context->eip = (uint)forkret;
801037a2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037a5:	8d 93 cc 00 00 00    	lea    0xcc(%ebx),%edx
801037ab:	83 c4 10             	add    $0x10,%esp
801037ae:	c7 40 10 00 38 10 80 	movl   $0x80103800,0x10(%eax)
801037b5:	8d 43 7c             	lea    0x7c(%ebx),%eax
801037b8:	90                   	nop
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		p->mux_ptrs[i] = 0;
801037c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801037c6:	83 c0 04             	add    $0x4,%eax
	for (i=0; i<MUX_MAXNUM; i++){
801037c9:	39 c2                	cmp    %eax,%edx
801037cb:	75 f3                	jne    801037c0 <allocproc+0xb0>
}
801037cd:	89 d8                	mov    %ebx,%eax
801037cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037d2:	c9                   	leave  
801037d3:	c3                   	ret    
801037d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	release(&ptable.lock);
801037d8:	83 ec 0c             	sub    $0xc,%esp
	return 0;
801037db:	31 db                	xor    %ebx,%ebx
	release(&ptable.lock);
801037dd:	68 c0 1f 11 80       	push   $0x80111fc0
801037e2:	e8 39 14 00 00       	call   80104c20 <release>
}
801037e7:	89 d8                	mov    %ebx,%eax
	return 0;
801037e9:	83 c4 10             	add    $0x10,%esp
}
801037ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037ef:	c9                   	leave  
801037f0:	c3                   	ret    
		p->state = UNUSED;
801037f1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		return 0;
801037f8:	31 db                	xor    %ebx,%ebx
801037fa:	eb d1                	jmp    801037cd <allocproc+0xbd>
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103800 <forkret>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	83 ec 14             	sub    $0x14,%esp
	release(&ptable.lock);
80103806:	68 c0 1f 11 80       	push   $0x80111fc0
8010380b:	e8 10 14 00 00       	call   80104c20 <release>
	if (first) {
80103810:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103815:	83 c4 10             	add    $0x10,%esp
80103818:	85 c0                	test   %eax,%eax
8010381a:	75 04                	jne    80103820 <forkret+0x20>
}
8010381c:	c9                   	leave  
8010381d:	c3                   	ret    
8010381e:	66 90                	xchg   %ax,%ax
		iinit(ROOTDEV);
80103820:	83 ec 0c             	sub    $0xc,%esp
		first = 0;
80103823:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010382a:	00 00 00 
		iinit(ROOTDEV);
8010382d:	6a 01                	push   $0x1
8010382f:	e8 8c dc ff ff       	call   801014c0 <iinit>
		initlog(ROOTDEV);
80103834:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010383b:	e8 00 f3 ff ff       	call   80102b40 <initlog>
80103840:	83 c4 10             	add    $0x10,%esp
}
80103843:	c9                   	leave  
80103844:	c3                   	ret    
80103845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103850 <pinit>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	83 ec 10             	sub    $0x10,%esp
	initlock(&ptable.lock, "ptable");
80103856:	68 ce 86 10 80       	push   $0x801086ce
8010385b:	68 c0 1f 11 80       	push   $0x80111fc0
80103860:	e8 ab 11 00 00       	call   80104a10 <initlock>
}
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	c9                   	leave  
80103869:	c3                   	ret    
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103870 <mycpu>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80103875:	9c                   	pushf  
80103876:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("mycpu called with interrupts enabled\n");
80103877:	f6 c4 02             	test   $0x2,%ah
8010387a:	75 5e                	jne    801038da <mycpu+0x6a>
	apicid = lapicid();
8010387c:	e8 ef ee ff ff       	call   80102770 <lapicid>
	for (i = 0; i < ncpu; ++i) {
80103881:	8b 35 80 fa 12 80    	mov    0x8012fa80,%esi
80103887:	85 f6                	test   %esi,%esi
80103889:	7e 42                	jle    801038cd <mycpu+0x5d>
		if (cpus[i].apicid == apicid) return &cpus[i];
8010388b:	0f b6 15 00 f5 12 80 	movzbl 0x8012f500,%edx
80103892:	39 d0                	cmp    %edx,%eax
80103894:	74 30                	je     801038c6 <mycpu+0x56>
80103896:	b9 b0 f5 12 80       	mov    $0x8012f5b0,%ecx
	for (i = 0; i < ncpu; ++i) {
8010389b:	31 d2                	xor    %edx,%edx
8010389d:	8d 76 00             	lea    0x0(%esi),%esi
801038a0:	83 c2 01             	add    $0x1,%edx
801038a3:	39 f2                	cmp    %esi,%edx
801038a5:	74 26                	je     801038cd <mycpu+0x5d>
		if (cpus[i].apicid == apicid) return &cpus[i];
801038a7:	0f b6 19             	movzbl (%ecx),%ebx
801038aa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801038b0:	39 c3                	cmp    %eax,%ebx
801038b2:	75 ec                	jne    801038a0 <mycpu+0x30>
801038b4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801038ba:	05 00 f5 12 80       	add    $0x8012f500,%eax
}
801038bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038c2:	5b                   	pop    %ebx
801038c3:	5e                   	pop    %esi
801038c4:	5d                   	pop    %ebp
801038c5:	c3                   	ret    
		if (cpus[i].apicid == apicid) return &cpus[i];
801038c6:	b8 00 f5 12 80       	mov    $0x8012f500,%eax
801038cb:	eb f2                	jmp    801038bf <mycpu+0x4f>
	panic("unknown apicid\n");
801038cd:	83 ec 0c             	sub    $0xc,%esp
801038d0:	68 d5 86 10 80       	push   $0x801086d5
801038d5:	e8 b6 ca ff ff       	call   80100390 <panic>
	if (readeflags() & FL_IF) panic("mycpu called with interrupts enabled\n");
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	68 a8 86 10 80       	push   $0x801086a8
801038e2:	e8 a9 ca ff ff       	call   80100390 <panic>
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038f0 <cpuid>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 08             	sub    $0x8,%esp
	return mycpu() - cpus;
801038f6:	e8 75 ff ff ff       	call   80103870 <mycpu>
801038fb:	2d 00 f5 12 80       	sub    $0x8012f500,%eax
}
80103900:	c9                   	leave  
	return mycpu() - cpus;
80103901:	c1 f8 04             	sar    $0x4,%eax
80103904:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010390a:	c3                   	ret    
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103910 <myproc>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
80103914:	83 ec 04             	sub    $0x4,%esp
	pushcli();
80103917:	e8 a4 11 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
8010391c:	e8 4f ff ff ff       	call   80103870 <mycpu>
	p = c->proc;
80103921:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103927:	e8 94 12 00 00       	call   80104bc0 <popcli>
}
8010392c:	83 c4 04             	add    $0x4,%esp
8010392f:	89 d8                	mov    %ebx,%eax
80103931:	5b                   	pop    %ebx
80103932:	5d                   	pop    %ebp
80103933:	c3                   	ret    
80103934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010393a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103940 <userinit>:
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 0c             	sub    $0xc,%esp
	p = allocproc();
80103949:	e8 c2 fd ff ff       	call   80103710 <allocproc>
8010394e:	89 c3                	mov    %eax,%ebx
	initproc = p;
80103950:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
	if ((p->pgdir = setupkvm()) == 0) panic("userinit: out of memory?");
80103955:	e8 06 43 00 00       	call   80107c60 <setupkvm>
8010395a:	85 c0                	test   %eax,%eax
8010395c:	89 43 04             	mov    %eax,0x4(%ebx)
8010395f:	0f 84 ee 01 00 00    	je     80103b53 <userinit+0x213>
	inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103965:	83 ec 04             	sub    $0x4,%esp
	p->tf->ds     = (SEG_UDATA << 3) | DPL_USER;
80103968:	be 23 00 00 00       	mov    $0x23,%esi
	inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010396d:	68 2c 00 00 00       	push   $0x2c
80103972:	68 60 b4 10 80       	push   $0x8010b460
80103977:	50                   	push   %eax
80103978:	e8 c3 3f 00 00       	call   80107940 <inituvm>
	memset(p->tf, 0, sizeof(*p->tf));
8010397d:	83 c4 0c             	add    $0xc,%esp
	p->sz = PGSIZE;
80103980:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
	memset(p->tf, 0, sizeof(*p->tf));
80103986:	6a 4c                	push   $0x4c
80103988:	6a 00                	push   $0x0
8010398a:	ff 73 18             	pushl  0x18(%ebx)
8010398d:	e8 ee 12 00 00       	call   80104c80 <memset>
	p->tf->cs     = (SEG_UCODE << 3) | DPL_USER;
80103992:	8b 43 18             	mov    0x18(%ebx),%eax
80103995:	b9 1b 00 00 00       	mov    $0x1b,%ecx
	safestrcpy(p->name, "initcode", sizeof(p->name));
8010399a:	83 c4 0c             	add    $0xc,%esp
	p->tf->cs     = (SEG_UCODE << 3) | DPL_USER;
8010399d:	66 89 48 3c          	mov    %cx,0x3c(%eax)
	p->tf->ds     = (SEG_UDATA << 3) | DPL_USER;
801039a1:	8b 43 18             	mov    0x18(%ebx),%eax
801039a4:	66 89 70 2c          	mov    %si,0x2c(%eax)
	p->tf->es     = p->tf->ds;
801039a8:	8b 43 18             	mov    0x18(%ebx),%eax
801039ab:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039af:	66 89 50 28          	mov    %dx,0x28(%eax)
	p->tf->ss     = p->tf->ds;
801039b3:	8b 43 18             	mov    0x18(%ebx),%eax
801039b6:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039ba:	66 89 50 48          	mov    %dx,0x48(%eax)
	p->tf->eflags = FL_IF;
801039be:	8b 43 18             	mov    0x18(%ebx),%eax
801039c1:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	p->tf->esp    = PGSIZE;
801039c8:	8b 43 18             	mov    0x18(%ebx),%eax
801039cb:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
	p->tf->eip    = 0; // beginning of initcode.S
801039d2:	8b 43 18             	mov    0x18(%ebx),%eax
801039d5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	safestrcpy(p->name, "initcode", sizeof(p->name));
801039dc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039df:	6a 10                	push   $0x10
801039e1:	68 fe 86 10 80       	push   $0x801086fe
801039e6:	50                   	push   %eax
801039e7:	e8 74 14 00 00       	call   80104e60 <safestrcpy>
	p->cwd = namei("/");
801039ec:	c7 04 24 07 87 10 80 	movl   $0x80108707,(%esp)
801039f3:	e8 28 e5 ff ff       	call   80101f20 <namei>
801039f8:	89 43 68             	mov    %eax,0x68(%ebx)
	acquire(&ptable.lock);
801039fb:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80103a02:	e8 f9 10 00 00       	call   80104b00 <acquire>
	if (!pqueue_ready){
80103a07:	8b 3d b8 b5 10 80    	mov    0x8010b5b8,%edi
80103a0d:	83 c4 10             	add    $0x10,%esp
80103a10:	85 ff                	test   %edi,%edi
80103a12:	75 30                	jne    80103a44 <userinit+0x104>
		pqueue_ready = 1;
80103a14:	c7 05 b8 b5 10 80 01 	movl   $0x1,0x8010b5b8
80103a1b:	00 00 00 
		p->priority = 0;
80103a1e:	c7 83 cc 00 00 00 00 	movl   $0x0,0xcc(%ebx)
80103a25:	00 00 00 
80103a28:	b8 f4 73 11 80       	mov    $0x801173f4,%eax
				ptable.head_tail[m][n] = 0;
80103a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103a33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80103a3a:	83 c0 08             	add    $0x8,%eax
		for (m=0; m<PRIO_MAX; m++){
80103a3d:	3d 94 74 11 80       	cmp    $0x80117494,%eax
80103a42:	75 e9                	jne    80103a2d <userinit+0xed>
	int priority = p->priority;
80103a44:	8b bb cc 00 00 00    	mov    0xcc(%ebx),%edi
	p->state = RUNNABLE;
80103a4a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	if (tail == (head-1)%QSIZE){
80103a51:	8b 04 fd f4 73 11 80 	mov    -0x7fee8c0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
80103a58:	8b 0c fd f8 73 11 80 	mov    -0x7fee8c08(,%edi,8),%ecx
	if (tail == (head-1)%QSIZE){
80103a5f:	8d 70 ff             	lea    -0x1(%eax),%esi
80103a62:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103a67:	f7 ee                	imul   %esi
80103a69:	89 d0                	mov    %edx,%eax
80103a6b:	89 f2                	mov    %esi,%edx
80103a6d:	c1 f8 05             	sar    $0x5,%eax
80103a70:	c1 fa 1f             	sar    $0x1f,%edx
80103a73:	29 d0                	sub    %edx,%eax
80103a75:	6b c0 64             	imul   $0x64,%eax,%eax
80103a78:	29 c6                	sub    %eax,%esi
80103a7a:	39 f1                	cmp    %esi,%ecx
80103a7c:	0f 84 de 00 00 00    	je     80103b60 <userinit+0x220>
	ptable.pqueues[priority][tail] =  p;
80103a82:	6b c7 64             	imul   $0x64,%edi,%eax
	release(&ptable.lock);
80103a85:	83 ec 0c             	sub    $0xc,%esp
80103a88:	68 c0 1f 11 80       	push   $0x80111fc0
	ptable.pqueues[priority][tail] =  p;
80103a8d:	8d 84 01 34 15 00 00 	lea    0x1534(%ecx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103a94:	83 c1 01             	add    $0x1,%ecx
	ptable.pqueues[priority][tail] =  p;
80103a97:	89 1c 85 c4 1f 11 80 	mov    %ebx,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103a9e:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103aa3:	f7 e9                	imul   %ecx
80103aa5:	89 d0                	mov    %edx,%eax
80103aa7:	89 ca                	mov    %ecx,%edx
80103aa9:	c1 fa 1f             	sar    $0x1f,%edx
80103aac:	c1 f8 05             	sar    $0x5,%eax
80103aaf:	29 d0                	sub    %edx,%eax
80103ab1:	6b c0 64             	imul   $0x64,%eax,%eax
80103ab4:	29 c1                	sub    %eax,%ecx
80103ab6:	89 0c fd f8 73 11 80 	mov    %ecx,-0x7fee8c08(,%edi,8)
	release(&ptable.lock);
80103abd:	e8 5e 11 00 00       	call   80104c20 <release>
80103ac2:	b9 1c 94 11 80       	mov    $0x8011941c,%ecx
80103ac7:	83 c4 10             	add    $0x10,%esp
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ad0:	8d 91 a0 0f 00 00    	lea    0xfa0(%ecx),%edx
		MUTEXES.muxes[i].name = 0;
80103ad6:	c7 41 f8 00 00 00 00 	movl   $0x0,-0x8(%ecx)
		MUTEXES.muxes[i].state = -1;
80103add:	c7 41 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%ecx)
80103ae4:	89 c8                	mov    %ecx,%eax
80103ae6:	8d 76 00             	lea    0x0(%esi),%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			MUTEXES.muxes[i].cv[j] = 0;
80103af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103af6:	83 c0 04             	add    $0x4,%eax
		for (j=0; j<1000; j++){
80103af9:	39 d0                	cmp    %edx,%eax
80103afb:	75 f3                	jne    80103af0 <userinit+0x1b0>
80103afd:	81 c1 a8 0f 00 00    	add    $0xfa8,%ecx
	for(i=0; i<MUX_MAXNUM; i++){
80103b03:	81 f9 3c cd 12 80    	cmp    $0x8012cd3c,%ecx
80103b09:	75 c5                	jne    80103ad0 <userinit+0x190>
80103b0b:	b8 14 10 11 80       	mov    $0x80111014,%eax
80103b10:	ba b4 1f 11 80       	mov    $0x80111fb4,%edx
80103b15:	8d 76 00             	lea    0x0(%esi),%esi
		wqueue.queue[i] = 0;
80103b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103b1e:	83 c0 04             	add    $0x4,%eax
	for (i=0; i<1000; i++){
80103b21:	39 c2                	cmp    %eax,%edx
80103b23:	75 f3                	jne    80103b18 <userinit+0x1d8>
	initlock(&MUTEXES.lock, "mutex_table");
80103b25:	83 ec 08             	sub    $0x8,%esp
80103b28:	68 09 87 10 80       	push   $0x80108709
80103b2d:	68 e0 93 11 80       	push   $0x801193e0
80103b32:	e8 d9 0e 00 00       	call   80104a10 <initlock>
	initlock(&wqueue.lock, "wqueue");
80103b37:	58                   	pop    %eax
80103b38:	5a                   	pop    %edx
80103b39:	68 15 87 10 80       	push   $0x80108715
80103b3e:	68 e0 0f 11 80       	push   $0x80110fe0
80103b43:	e8 c8 0e 00 00       	call   80104a10 <initlock>
}
80103b48:	83 c4 10             	add    $0x10,%esp
80103b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b4e:	5b                   	pop    %ebx
80103b4f:	5e                   	pop    %esi
80103b50:	5f                   	pop    %edi
80103b51:	5d                   	pop    %ebp
80103b52:	c3                   	ret    
	if ((p->pgdir = setupkvm()) == 0) panic("userinit: out of memory?");
80103b53:	83 ec 0c             	sub    $0xc,%esp
80103b56:	68 e5 86 10 80       	push   $0x801086e5
80103b5b:	e8 30 c8 ff ff       	call   80100390 <panic>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	68 78 86 10 80       	push   $0x80108678
80103b68:	e8 23 c8 ff ff       	call   80100390 <panic>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi

80103b70 <growproc>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	8b 75 08             	mov    0x8(%ebp),%esi
	pushcli();
80103b78:	e8 43 0f 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
80103b7d:	e8 ee fc ff ff       	call   80103870 <mycpu>
	p = c->proc;
80103b82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103b88:	e8 33 10 00 00       	call   80104bc0 <popcli>
	if (n > 0) {
80103b8d:	83 fe 00             	cmp    $0x0,%esi
	sz = curproc->sz;
80103b90:	8b 03                	mov    (%ebx),%eax
	if (n > 0) {
80103b92:	7f 1c                	jg     80103bb0 <growproc+0x40>
	} else if (n < 0) {
80103b94:	75 3a                	jne    80103bd0 <growproc+0x60>
	switchuvm(curproc);
80103b96:	83 ec 0c             	sub    $0xc,%esp
	curproc->sz = sz;
80103b99:	89 03                	mov    %eax,(%ebx)
	switchuvm(curproc);
80103b9b:	53                   	push   %ebx
80103b9c:	e8 8f 3c 00 00       	call   80107830 <switchuvm>
	return 0;
80103ba1:	83 c4 10             	add    $0x10,%esp
80103ba4:	31 c0                	xor    %eax,%eax
}
80103ba6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ba9:	5b                   	pop    %ebx
80103baa:	5e                   	pop    %esi
80103bab:	5d                   	pop    %ebp
80103bac:	c3                   	ret    
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
		if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) return -1;
80103bb0:	83 ec 04             	sub    $0x4,%esp
80103bb3:	01 c6                	add    %eax,%esi
80103bb5:	56                   	push   %esi
80103bb6:	50                   	push   %eax
80103bb7:	ff 73 04             	pushl  0x4(%ebx)
80103bba:	e8 c1 3e 00 00       	call   80107a80 <allocuvm>
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 d0                	jne    80103b96 <growproc+0x26>
80103bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bcb:	eb d9                	jmp    80103ba6 <growproc+0x36>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
		if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) return -1;
80103bd0:	83 ec 04             	sub    $0x4,%esp
80103bd3:	01 c6                	add    %eax,%esi
80103bd5:	56                   	push   %esi
80103bd6:	50                   	push   %eax
80103bd7:	ff 73 04             	pushl  0x4(%ebx)
80103bda:	e8 d1 3f 00 00       	call   80107bb0 <deallocuvm>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	85 c0                	test   %eax,%eax
80103be4:	75 b0                	jne    80103b96 <growproc+0x26>
80103be6:	eb de                	jmp    80103bc6 <growproc+0x56>
80103be8:	90                   	nop
80103be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bf0 <fork>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 1c             	sub    $0x1c,%esp
	pushcli();
80103bf9:	e8 c2 0e 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
80103bfe:	e8 6d fc ff ff       	call   80103870 <mycpu>
	p = c->proc;
80103c03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103c09:	e8 b2 0f 00 00       	call   80104bc0 <popcli>
	if ((np = allocproc()) == 0) {
80103c0e:	e8 fd fa ff ff       	call   80103710 <allocproc>
80103c13:	85 c0                	test   %eax,%eax
80103c15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c18:	0f 84 9c 01 00 00    	je     80103dba <fork+0x1ca>
	if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103c1e:	83 ec 08             	sub    $0x8,%esp
80103c21:	ff 33                	pushl  (%ebx)
80103c23:	ff 73 04             	pushl  0x4(%ebx)
80103c26:	89 c6                	mov    %eax,%esi
80103c28:	e8 03 41 00 00       	call   80107d30 <copyuvm>
80103c2d:	83 c4 10             	add    $0x10,%esp
80103c30:	85 c0                	test   %eax,%eax
80103c32:	89 46 04             	mov    %eax,0x4(%esi)
80103c35:	0f 84 88 01 00 00    	je     80103dc3 <fork+0x1d3>
80103c3b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103c3e:	8d 83 d0 00 00 00    	lea    0xd0(%ebx),%eax
80103c44:	8d 96 d0 00 00 00    	lea    0xd0(%esi),%edx
80103c4a:	8d b3 50 01 00 00    	lea    0x150(%ebx),%esi
		if(curproc->shmpgs[pg_num] != 0)
80103c50:	8b 08                	mov    (%eax),%ecx
80103c52:	85 c9                	test   %ecx,%ecx
80103c54:	74 24                	je     80103c7a <fork+0x8a>
			np->shmpgs[pg_num]->allocated = curproc->shmpgs[pg_num]->allocated;
80103c56:	8b 3a                	mov    (%edx),%edi
80103c58:	8b 09                	mov    (%ecx),%ecx
80103c5a:	89 0f                	mov    %ecx,(%edi)
			np->shmpgs[pg_num]->name = curproc->shmpgs[pg_num]->name;
80103c5c:	8b 38                	mov    (%eax),%edi
80103c5e:	8b 0a                	mov    (%edx),%ecx
80103c60:	8b 7f 04             	mov    0x4(%edi),%edi
80103c63:	89 79 04             	mov    %edi,0x4(%ecx)
			np->shmpgs[pg_num]->pa = curproc->shmpgs[pg_num]->pa;
80103c66:	8b 38                	mov    (%eax),%edi
80103c68:	8b 0a                	mov    (%edx),%ecx
80103c6a:	8b 7f 08             	mov    0x8(%edi),%edi
80103c6d:	89 79 08             	mov    %edi,0x8(%ecx)
			np->shmpgs[pg_num]->ref_count = curproc->shmpgs[pg_num]->ref_count;
80103c70:	8b 38                	mov    (%eax),%edi
80103c72:	8b 0a                	mov    (%edx),%ecx
80103c74:	8b 7f 0c             	mov    0xc(%edi),%edi
80103c77:	89 79 0c             	mov    %edi,0xc(%ecx)
80103c7a:	83 c0 04             	add    $0x4,%eax
80103c7d:	83 c2 04             	add    $0x4,%edx
	for(pg_num = 0; pg_num < SHM_MAXNUM; pg_num++)
80103c80:	39 f0                	cmp    %esi,%eax
80103c82:	75 cc                	jne    80103c50 <fork+0x60>
	np->sz     = curproc->sz;
80103c84:	8b 03                	mov    (%ebx),%eax
80103c86:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	*np->tf    = *curproc->tf;
80103c89:	b9 13 00 00 00       	mov    $0x13,%ecx
	np->sz     = curproc->sz;
80103c8e:	89 06                	mov    %eax,(%esi)
	np->parent = curproc;
80103c90:	89 f0                	mov    %esi,%eax
80103c92:	89 5e 14             	mov    %ebx,0x14(%esi)
	*np->tf    = *curproc->tf;
80103c95:	8b 73 18             	mov    0x18(%ebx),%esi
80103c98:	8b 78 18             	mov    0x18(%eax),%edi
80103c9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	np->tf->eax = 0;
80103c9d:	89 c7                	mov    %eax,%edi
	for (i = 0; i < NOFILE; i++)
80103c9f:	31 f6                	xor    %esi,%esi
	np->tf->eax = 0;
80103ca1:	8b 40 18             	mov    0x18(%eax),%eax
80103ca4:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103cab:	90                   	nop
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (curproc->ofile[i]) np->ofile[i] = filedup(curproc->ofile[i]);
80103cb0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cb4:	85 c0                	test   %eax,%eax
80103cb6:	74 10                	je     80103cc8 <fork+0xd8>
80103cb8:	83 ec 0c             	sub    $0xc,%esp
80103cbb:	50                   	push   %eax
80103cbc:	e8 5f d1 ff ff       	call   80100e20 <filedup>
80103cc1:	83 c4 10             	add    $0x10,%esp
80103cc4:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
	for (i = 0; i < NOFILE; i++)
80103cc8:	83 c6 01             	add    $0x1,%esi
80103ccb:	83 fe 10             	cmp    $0x10,%esi
80103cce:	75 e0                	jne    80103cb0 <fork+0xc0>
	np->cwd = idup(curproc->cwd);
80103cd0:	83 ec 0c             	sub    $0xc,%esp
80103cd3:	ff 73 68             	pushl  0x68(%ebx)
80103cd6:	e8 b5 d9 ff ff       	call   80101690 <idup>
80103cdb:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cde:	83 c4 0c             	add    $0xc,%esp
	np->cwd = idup(curproc->cwd);
80103ce1:	89 46 68             	mov    %eax,0x68(%esi)
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ce4:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ce7:	6a 10                	push   $0x10
80103ce9:	50                   	push   %eax
80103cea:	8d 46 6c             	lea    0x6c(%esi),%eax
80103ced:	50                   	push   %eax
80103cee:	e8 6d 11 00 00       	call   80104e60 <safestrcpy>
	pid = np->pid;
80103cf3:	8b 46 10             	mov    0x10(%esi),%eax
	acquire(&ptable.lock);
80103cf6:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
	pid = np->pid;
80103cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
	acquire(&ptable.lock);
80103d00:	e8 fb 0d 00 00       	call   80104b00 <acquire>
	int priority = p->priority;
80103d05:	8b be cc 00 00 00    	mov    0xcc(%esi),%edi
	np->state = RUNNABLE;
80103d0b:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
	if (tail == (head-1)%QSIZE){
80103d12:	83 c4 10             	add    $0x10,%esp
	int priority = p->priority;
80103d15:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	if (tail == (head-1)%QSIZE){
80103d18:	8b 04 fd f4 73 11 80 	mov    -0x7fee8c0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
80103d1f:	8b 0c fd f8 73 11 80 	mov    -0x7fee8c08(,%edi,8),%ecx
	if (tail == (head-1)%QSIZE){
80103d26:	8d 70 ff             	lea    -0x1(%eax),%esi
80103d29:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103d2e:	f7 ee                	imul   %esi
80103d30:	89 f0                	mov    %esi,%eax
80103d32:	c1 f8 1f             	sar    $0x1f,%eax
80103d35:	c1 fa 05             	sar    $0x5,%edx
80103d38:	29 c2                	sub    %eax,%edx
80103d3a:	6b c2 64             	imul   $0x64,%edx,%eax
80103d3d:	29 c6                	sub    %eax,%esi
80103d3f:	39 f1                	cmp    %esi,%ecx
80103d41:	0f 84 a4 00 00 00    	je     80103deb <fork+0x1fb>
	ptable.pqueues[priority][tail] =  p;
80103d47:	6b c7 64             	imul   $0x64,%edi,%eax
80103d4a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	release(&ptable.lock);
80103d4d:	83 ec 0c             	sub    $0xc,%esp
80103d50:	68 c0 1f 11 80       	push   $0x80111fc0
	ptable.pqueues[priority][tail] =  p;
80103d55:	8d 84 01 34 15 00 00 	lea    0x1534(%ecx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103d5c:	83 c1 01             	add    $0x1,%ecx
	ptable.pqueues[priority][tail] =  p;
80103d5f:	89 34 85 c4 1f 11 80 	mov    %esi,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103d66:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103d6b:	f7 e9                	imul   %ecx
80103d6d:	89 c8                	mov    %ecx,%eax
80103d6f:	c1 f8 1f             	sar    $0x1f,%eax
80103d72:	c1 fa 05             	sar    $0x5,%edx
80103d75:	29 c2                	sub    %eax,%edx
80103d77:	6b c2 64             	imul   $0x64,%edx,%eax
80103d7a:	29 c1                	sub    %eax,%ecx
80103d7c:	89 0c fd f8 73 11 80 	mov    %ecx,-0x7fee8c08(,%edi,8)
	release(&ptable.lock);
80103d83:	e8 98 0e 00 00       	call   80104c20 <release>
80103d88:	83 c4 10             	add    $0x10,%esp
	for(i=0; i<MUX_MAXNUM; i++)
80103d8b:	31 c0                	xor    %eax,%eax
80103d8d:	89 f1                	mov    %esi,%ecx
80103d8f:	90                   	nop
		np->mux_ptrs[i] = curproc->mux_ptrs[i];
80103d90:	8b 54 83 7c          	mov    0x7c(%ebx,%eax,4),%edx
80103d94:	89 54 81 7c          	mov    %edx,0x7c(%ecx,%eax,4)
	for(i=0; i<MUX_MAXNUM; i++)
80103d98:	83 c0 01             	add    $0x1,%eax
80103d9b:	83 f8 14             	cmp    $0x14,%eax
80103d9e:	75 f0                	jne    80103d90 <fork+0x1a0>
	np->priority = curproc->priority;
80103da0:	8b 83 cc 00 00 00    	mov    0xcc(%ebx),%eax
80103da6:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103da9:	89 83 cc 00 00 00    	mov    %eax,0xcc(%ebx)
}
80103daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103db5:	5b                   	pop    %ebx
80103db6:	5e                   	pop    %esi
80103db7:	5f                   	pop    %edi
80103db8:	5d                   	pop    %ebp
80103db9:	c3                   	ret    
		return -1;
80103dba:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80103dc1:	eb ec                	jmp    80103daf <fork+0x1bf>
		kfree(np->kstack);
80103dc3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dc6:	83 ec 0c             	sub    $0xc,%esp
80103dc9:	ff 73 08             	pushl  0x8(%ebx)
80103dcc:	e8 7f e5 ff ff       	call   80102350 <kfree>
		np->kstack = 0;
80103dd1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
		np->state  = UNUSED;
80103dd8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		return -1;
80103ddf:	83 c4 10             	add    $0x10,%esp
80103de2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80103de9:	eb c4                	jmp    80103daf <fork+0x1bf>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
80103deb:	83 ec 0c             	sub    $0xc,%esp
80103dee:	68 78 86 10 80       	push   $0x80108678
80103df3:	e8 98 c5 ff ff       	call   80100390 <panic>
80103df8:	90                   	nop
80103df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e00 <scheduler>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
	struct cpu * c = mycpu();
80103e09:	e8 62 fa ff ff       	call   80103870 <mycpu>
80103e0e:	8d 70 04             	lea    0x4(%eax),%esi
80103e11:	89 c3                	mov    %eax,%ebx
	c->proc = 0;
80103e13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e1a:	00 00 00 
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
	asm volatile("sti");
80103e20:	fb                   	sti    
		acquire(&ptable.lock);
80103e21:	83 ec 0c             	sub    $0xc,%esp
80103e24:	68 c0 1f 11 80       	push   $0x80111fc0
80103e29:	e8 d2 0c 00 00       	call   80104b00 <acquire>
		if (first_time){
80103e2e:	8b 0d 04 b0 10 80    	mov    0x8010b004,%ecx
80103e34:	83 c4 10             	add    $0x10,%esp
80103e37:	85 c9                	test   %ecx,%ecx
80103e39:	74 7d                	je     80103eb8 <scheduler+0xb8>
			first_time = 0;
80103e3b:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80103e42:	00 00 00 
			for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e45:	bf f4 1f 11 80       	mov    $0x80111ff4,%edi
80103e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				if (p->state != RUNNABLE) continue;
80103e50:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103e54:	75 33                	jne    80103e89 <scheduler+0x89>
				switchuvm(p);
80103e56:	83 ec 0c             	sub    $0xc,%esp
				c->proc = p;
80103e59:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
				switchuvm(p);
80103e5f:	57                   	push   %edi
80103e60:	e8 cb 39 00 00       	call   80107830 <switchuvm>
				p->state = RUNNING;
80103e65:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
				swtch(&(c->scheduler), p->context);
80103e6c:	59                   	pop    %ecx
80103e6d:	58                   	pop    %eax
80103e6e:	ff 77 1c             	pushl  0x1c(%edi)
80103e71:	56                   	push   %esi
80103e72:	e8 44 10 00 00       	call   80104ebb <swtch>
				switchkvm();
80103e77:	e8 94 39 00 00       	call   80107810 <switchkvm>
				c->proc = 0;
80103e7c:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103e83:	00 00 00 
80103e86:	83 c4 10             	add    $0x10,%esp
			for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e89:	81 c7 50 01 00 00    	add    $0x150,%edi
80103e8f:	81 ff f4 73 11 80    	cmp    $0x801173f4,%edi
80103e95:	72 b9                	jb     80103e50 <scheduler+0x50>
		release(&ptable.lock);
80103e97:	83 ec 0c             	sub    $0xc,%esp
80103e9a:	68 c0 1f 11 80       	push   $0x80111fc0
80103e9f:	e8 7c 0d 00 00       	call   80104c20 <release>
		sti();
80103ea4:	83 c4 10             	add    $0x10,%esp
80103ea7:	e9 74 ff ff ff       	jmp    80103e20 <scheduler+0x20>
80103eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
pq_dequeue(){

	// go to highest priority, non-empty queue 
	int priority = 0;
	while (priority < PRIO_MAX && ptable.head_tail[priority][0] == ptable.head_tail[priority][1])	// queue is empty if head == tail
		priority++;
80103eb0:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && ptable.head_tail[priority][0] == ptable.head_tail[priority][1])	// queue is empty if head == tail
80103eb3:	83 f9 14             	cmp    $0x14,%ecx
80103eb6:	74 df                	je     80103e97 <scheduler+0x97>
80103eb8:	8b 04 cd f4 73 11 80 	mov    -0x7fee8c0c(,%ecx,8),%eax
80103ebf:	3b 04 cd f8 73 11 80 	cmp    -0x7fee8c08(,%ecx,8),%eax
80103ec6:	74 e8                	je     80103eb0 <scheduler+0xb0>
		return NULL;
	}

	// get proc
	int head = ptable.head_tail[priority][0];
	struct proc *p = ptable.pqueues[priority][head];
80103ec8:	6b d1 64             	imul   $0x64,%ecx,%edx
80103ecb:	8d 94 10 34 15 00 00 	lea    0x1534(%eax,%edx,1),%edx

	// update head
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103ed2:	83 c0 01             	add    $0x1,%eax
	struct proc *p = ptable.pqueues[priority][head];
80103ed5:	8b 3c 95 c4 1f 11 80 	mov    -0x7feee03c(,%edx,4),%edi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103edc:	89 c2                	mov    %eax,%edx
80103ede:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103ee3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103ee6:	f7 ea                	imul   %edx
80103ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103eeb:	c1 fa 05             	sar    $0x5,%edx
80103eee:	c1 f8 1f             	sar    $0x1f,%eax
80103ef1:	29 c2                	sub    %eax,%edx
80103ef3:	6b c2 64             	imul   $0x64,%edx,%eax
80103ef6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ef9:	29 c2                	sub    %eax,%edx
			if (p != NULL){
80103efb:	83 ff ff             	cmp    $0xffffffff,%edi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103efe:	89 14 cd f4 73 11 80 	mov    %edx,-0x7fee8c0c(,%ecx,8)
			if (p != NULL){
80103f05:	74 90                	je     80103e97 <scheduler+0x97>
				switchuvm(p);
80103f07:	83 ec 0c             	sub    $0xc,%esp
				c->proc = p;
80103f0a:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
				switchuvm(p);
80103f10:	57                   	push   %edi
80103f11:	e8 1a 39 00 00       	call   80107830 <switchuvm>
				p->state = RUNNING;
80103f16:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
				swtch(&(c->scheduler), p->context);
80103f1d:	58                   	pop    %eax
80103f1e:	5a                   	pop    %edx
80103f1f:	ff 77 1c             	pushl  0x1c(%edi)
80103f22:	56                   	push   %esi
80103f23:	e8 93 0f 00 00       	call   80104ebb <swtch>
				switchkvm();
80103f28:	e8 e3 38 00 00       	call   80107810 <switchkvm>
				c->proc = 0;
80103f2d:	83 c4 10             	add    $0x10,%esp
80103f30:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103f37:	00 00 00 
		release(&ptable.lock);
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 c0 1f 11 80       	push   $0x80111fc0
80103f42:	e8 d9 0c 00 00       	call   80104c20 <release>
		sti();
80103f47:	83 c4 10             	add    $0x10,%esp
80103f4a:	e9 d1 fe ff ff       	jmp    80103e20 <scheduler+0x20>
80103f4f:	90                   	nop

80103f50 <sched>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	56                   	push   %esi
80103f54:	53                   	push   %ebx
	pushcli();
80103f55:	e8 66 0b 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
80103f5a:	e8 11 f9 ff ff       	call   80103870 <mycpu>
	p = c->proc;
80103f5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103f65:	e8 56 0c 00 00       	call   80104bc0 <popcli>
	if (!holding(&ptable.lock)) panic("sched ptable.lock");
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 c0 1f 11 80       	push   $0x80111fc0
80103f72:	e8 09 0b 00 00       	call   80104a80 <holding>
80103f77:	83 c4 10             	add    $0x10,%esp
80103f7a:	85 c0                	test   %eax,%eax
80103f7c:	74 4f                	je     80103fcd <sched+0x7d>
	if (mycpu()->ncli != 1) panic("sched locks");
80103f7e:	e8 ed f8 ff ff       	call   80103870 <mycpu>
80103f83:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f8a:	75 68                	jne    80103ff4 <sched+0xa4>
	if (p->state == RUNNING) panic("sched running");
80103f8c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f90:	74 55                	je     80103fe7 <sched+0x97>
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80103f92:	9c                   	pushf  
80103f93:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("sched interruptible");
80103f94:	f6 c4 02             	test   $0x2,%ah
80103f97:	75 41                	jne    80103fda <sched+0x8a>
	intena = mycpu()->intena;
80103f99:	e8 d2 f8 ff ff       	call   80103870 <mycpu>
	swtch(&p->context, mycpu()->scheduler);
80103f9e:	83 c3 1c             	add    $0x1c,%ebx
	intena = mycpu()->intena;
80103fa1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
	swtch(&p->context, mycpu()->scheduler);
80103fa7:	e8 c4 f8 ff ff       	call   80103870 <mycpu>
80103fac:	83 ec 08             	sub    $0x8,%esp
80103faf:	ff 70 04             	pushl  0x4(%eax)
80103fb2:	53                   	push   %ebx
80103fb3:	e8 03 0f 00 00       	call   80104ebb <swtch>
	mycpu()->intena = intena;
80103fb8:	e8 b3 f8 ff ff       	call   80103870 <mycpu>
}
80103fbd:	83 c4 10             	add    $0x10,%esp
	mycpu()->intena = intena;
80103fc0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fc9:	5b                   	pop    %ebx
80103fca:	5e                   	pop    %esi
80103fcb:	5d                   	pop    %ebp
80103fcc:	c3                   	ret    
	if (!holding(&ptable.lock)) panic("sched ptable.lock");
80103fcd:	83 ec 0c             	sub    $0xc,%esp
80103fd0:	68 1c 87 10 80       	push   $0x8010871c
80103fd5:	e8 b6 c3 ff ff       	call   80100390 <panic>
	if (readeflags() & FL_IF) panic("sched interruptible");
80103fda:	83 ec 0c             	sub    $0xc,%esp
80103fdd:	68 48 87 10 80       	push   $0x80108748
80103fe2:	e8 a9 c3 ff ff       	call   80100390 <panic>
	if (p->state == RUNNING) panic("sched running");
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	68 3a 87 10 80       	push   $0x8010873a
80103fef:	e8 9c c3 ff ff       	call   80100390 <panic>
	if (mycpu()->ncli != 1) panic("sched locks");
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	68 2e 87 10 80       	push   $0x8010872e
80103ffc:	e8 8f c3 ff ff       	call   80100390 <panic>
80104001:	eb 0d                	jmp    80104010 <exit>
80104003:	90                   	nop
80104004:	90                   	nop
80104005:	90                   	nop
80104006:	90                   	nop
80104007:	90                   	nop
80104008:	90                   	nop
80104009:	90                   	nop
8010400a:	90                   	nop
8010400b:	90                   	nop
8010400c:	90                   	nop
8010400d:	90                   	nop
8010400e:	90                   	nop
8010400f:	90                   	nop

80104010 <exit>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	57                   	push   %edi
80104014:	56                   	push   %esi
80104015:	53                   	push   %ebx
80104016:	83 ec 1c             	sub    $0x1c,%esp
	pushcli();
80104019:	e8 a2 0a 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
8010401e:	e8 4d f8 ff ff       	call   80103870 <mycpu>
	p = c->proc;
80104023:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	popcli();
80104029:	e8 92 0b 00 00       	call   80104bc0 <popcli>
	if (curproc == initproc) panic("init exiting");
8010402e:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
80104034:	8d 5e 28             	lea    0x28(%esi),%ebx
80104037:	8d 7e 68             	lea    0x68(%esi),%edi
8010403a:	0f 84 79 01 00 00    	je     801041b9 <exit+0x1a9>
		if (curproc->ofile[fd]) {
80104040:	8b 03                	mov    (%ebx),%eax
80104042:	85 c0                	test   %eax,%eax
80104044:	74 12                	je     80104058 <exit+0x48>
			fileclose(curproc->ofile[fd]);
80104046:	83 ec 0c             	sub    $0xc,%esp
80104049:	50                   	push   %eax
8010404a:	e8 21 ce ff ff       	call   80100e70 <fileclose>
			curproc->ofile[fd] = 0;
8010404f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104055:	83 c4 10             	add    $0x10,%esp
80104058:	83 c3 04             	add    $0x4,%ebx
	for (fd = 0; fd < NOFILE; fd++) {
8010405b:	39 fb                	cmp    %edi,%ebx
8010405d:	75 e1                	jne    80104040 <exit+0x30>
	begin_op();
8010405f:	e8 7c eb ff ff       	call   80102be0 <begin_op>
	iput(curproc->cwd);
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	ff 76 68             	pushl  0x68(%esi)
	wakeup1(curproc->parent);
8010406a:	31 db                	xor    %ebx,%ebx
	iput(curproc->cwd);
8010406c:	e8 7f d7 ff ff       	call   801017f0 <iput>
	end_op();
80104071:	e8 da eb ff ff       	call   80102c50 <end_op>
	curproc->cwd = 0;
80104076:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
	acquire(&ptable.lock);
8010407d:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80104084:	e8 77 0a 00 00       	call   80104b00 <acquire>
	wakeup1(curproc->parent);
80104089:	8b 46 14             	mov    0x14(%esi),%eax
8010408c:	e8 af f5 ff ff       	call   80103640 <wakeup1>
80104091:	83 c4 10             	add    $0x10,%esp
80104094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(curproc->shmpgs[pg_num] != 0)
80104098:	8b 84 1e d0 00 00 00 	mov    0xd0(%esi,%ebx,1),%eax
8010409f:	85 c0                	test   %eax,%eax
801040a1:	74 1e                	je     801040c1 <exit+0xb1>
			deallocuvm(curproc->pgdir, *curproc->shmpgs[pg_num]->pa, *curproc->shmpgs[pg_num]->pa);
801040a3:	8b 40 08             	mov    0x8(%eax),%eax
801040a6:	83 ec 04             	sub    $0x4,%esp
801040a9:	0f be 00             	movsbl (%eax),%eax
801040ac:	50                   	push   %eax
801040ad:	50                   	push   %eax
801040ae:	ff 76 04             	pushl  0x4(%esi)
801040b1:	e8 fa 3a 00 00       	call   80107bb0 <deallocuvm>
			shmtable.pages[pg_num].ref_count--;
801040b6:	83 2c 9d b0 fa 12 80 	subl   $0x1,-0x7fed0550(,%ebx,4)
801040bd:	01 
801040be:	83 c4 10             	add    $0x10,%esp
801040c1:	83 c3 04             	add    $0x4,%ebx
	for(pg_num = 0; pg_num < SHM_MAXNUM; pg_num++)
801040c4:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801040ca:	75 cc                	jne    80104098 <exit+0x88>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040cc:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
801040d1:	eb 14                	jmp    801040e7 <exit+0xd7>
801040d3:	90                   	nop
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d8:	8d 83 50 01 00 00    	lea    0x150(%ebx),%eax
801040de:	3d f4 73 11 80       	cmp    $0x801173f4,%eax
801040e3:	73 27                	jae    8010410c <exit+0xfc>
801040e5:	89 c3                	mov    %eax,%ebx
		if (p->parent == curproc) {
801040e7:	39 73 14             	cmp    %esi,0x14(%ebx)
801040ea:	75 ec                	jne    801040d8 <exit+0xc8>
			if (p->state == ZOMBIE) wakeup1(initproc);
801040ec:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
			p->parent = initproc;
801040f0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801040f5:	89 43 14             	mov    %eax,0x14(%ebx)
			if (p->state == ZOMBIE) wakeup1(initproc);
801040f8:	75 de                	jne    801040d8 <exit+0xc8>
801040fa:	e8 41 f5 ff ff       	call   80103640 <wakeup1>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040ff:	8d 83 50 01 00 00    	lea    0x150(%ebx),%eax
80104105:	3d f4 73 11 80       	cmp    $0x801173f4,%eax
8010410a:	72 d9                	jb     801040e5 <exit+0xd5>
8010410c:	8d 86 cc 00 00 00    	lea    0xcc(%esi),%eax
80104112:	8d 7e 7c             	lea    0x7c(%esi),%edi
80104115:	81 c3 cc 01 00 00    	add    $0x1cc,%ebx
8010411b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010411e:	66 90                	xchg   %ax,%ax
		if (curproc->mux_ptrs[i] != 0){
80104120:	8b 07                	mov    (%edi),%eax
80104122:	85 c0                	test   %eax,%eax
80104124:	74 6f                	je     80104195 <exit+0x185>
			curproc->mux_ptrs[i]->name = 0;
80104126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			curproc->mux_ptrs[i]->state = 0;
8010412c:	8b 07                	mov    (%edi),%eax
8010412e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			for (j=0; j<1000; j++){
80104135:	31 c0                	xor    %eax,%eax
80104137:	eb 11                	jmp    8010414a <exit+0x13a>
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104140:	83 c0 01             	add    $0x1,%eax
80104143:	3d e8 03 00 00       	cmp    $0x3e8,%eax
80104148:	74 45                	je     8010418f <exit+0x17f>
				if (curproc->mux_ptrs[i]->cv[j] == curproc){
8010414a:	8b 17                	mov    (%edi),%edx
8010414c:	39 74 82 08          	cmp    %esi,0x8(%edx,%eax,4)
80104150:	75 ee                	jne    80104140 <exit+0x130>
					for (k=j; k<999; k++){
80104152:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80104157:	74 20                	je     80104179 <exit+0x169>
80104159:	89 c2                	mov    %eax,%edx
8010415b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010415e:	66 90                	xchg   %ax,%ax
80104160:	8b 0b                	mov    (%ebx),%ecx
80104162:	8d 0c 91             	lea    (%ecx,%edx,4),%ecx
80104165:	83 c2 01             	add    $0x1,%edx
80104168:	81 fa e7 03 00 00    	cmp    $0x3e7,%edx
						p->mux_ptrs[i]->cv[k] = p->mux_ptrs[i]->cv[k+1];
8010416e:	8b 41 0c             	mov    0xc(%ecx),%eax
80104171:	89 41 08             	mov    %eax,0x8(%ecx)
					for (k=j; k<999; k++){
80104174:	75 ea                	jne    80104160 <exit+0x150>
80104176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
					p->mux_ptrs[i]->cv[999] = 0;
80104179:	8b 13                	mov    (%ebx),%edx
			for (j=0; j<1000; j++){
8010417b:	83 c0 01             	add    $0x1,%eax
8010417e:	3d e8 03 00 00       	cmp    $0x3e8,%eax
					p->mux_ptrs[i]->cv[999] = 0;
80104183:	c7 82 a4 0f 00 00 00 	movl   $0x0,0xfa4(%edx)
8010418a:	00 00 00 
			for (j=0; j<1000; j++){
8010418d:	75 bb                	jne    8010414a <exit+0x13a>
			curproc->mux_ptrs[i] = 0;
8010418f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80104195:	83 c7 04             	add    $0x4,%edi
80104198:	83 c3 04             	add    $0x4,%ebx
	for(i=0;i<MUX_MAXNUM;i++){
8010419b:	39 7d e0             	cmp    %edi,-0x20(%ebp)
8010419e:	75 80                	jne    80104120 <exit+0x110>
	curproc->state = ZOMBIE;
801041a0:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
	sched();
801041a7:	e8 a4 fd ff ff       	call   80103f50 <sched>
	panic("zombie exit");
801041ac:	83 ec 0c             	sub    $0xc,%esp
801041af:	68 69 87 10 80       	push   $0x80108769
801041b4:	e8 d7 c1 ff ff       	call   80100390 <panic>
	if (curproc == initproc) panic("init exiting");
801041b9:	83 ec 0c             	sub    $0xc,%esp
801041bc:	68 5c 87 10 80       	push   $0x8010875c
801041c1:	e8 ca c1 ff ff       	call   80100390 <panic>
801041c6:	8d 76 00             	lea    0x0(%esi),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041d0 <yield>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 18             	sub    $0x18,%esp
	acquire(&ptable.lock); // DOC: yieldlock
801041d9:	68 c0 1f 11 80       	push   $0x80111fc0
801041de:	e8 1d 09 00 00       	call   80104b00 <acquire>
	pushcli();
801041e3:	e8 d8 08 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
801041e8:	e8 83 f6 ff ff       	call   80103870 <mycpu>
	p = c->proc;
801041ed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
801041f3:	e8 c8 09 00 00       	call   80104bc0 <popcli>
	myproc()->state = RUNNABLE;
801041f8:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	pushcli();
801041ff:	e8 bc 08 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
80104204:	e8 67 f6 ff ff       	call   80103870 <mycpu>
	p = c->proc;
80104209:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
	popcli();
8010420f:	e8 ac 09 00 00       	call   80104bc0 <popcli>
	if (!(p->state == RUNNABLE)){
80104214:	83 c4 10             	add    $0x10,%esp
80104217:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
8010421b:	75 7c                	jne    80104299 <yield+0xc9>
	int priority = p->priority;
8010421d:	8b b7 cc 00 00 00    	mov    0xcc(%edi),%esi
	if (tail == (head-1)%QSIZE){
80104223:	8b 04 f5 f4 73 11 80 	mov    -0x7fee8c0c(,%esi,8),%eax
	int tail = ptable.head_tail[priority][1];
8010422a:	8b 0c f5 f8 73 11 80 	mov    -0x7fee8c08(,%esi,8),%ecx
	if (tail == (head-1)%QSIZE){
80104231:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104234:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104239:	f7 eb                	imul   %ebx
8010423b:	89 d8                	mov    %ebx,%eax
8010423d:	c1 f8 1f             	sar    $0x1f,%eax
80104240:	c1 fa 05             	sar    $0x5,%edx
80104243:	29 c2                	sub    %eax,%edx
80104245:	6b d2 64             	imul   $0x64,%edx,%edx
80104248:	29 d3                	sub    %edx,%ebx
8010424a:	39 d9                	cmp    %ebx,%ecx
8010424c:	74 4b                	je     80104299 <yield+0xc9>
	ptable.pqueues[priority][tail] =  p;
8010424e:	6b c6 64             	imul   $0x64,%esi,%eax
80104251:	8d 84 01 34 15 00 00 	lea    0x1534(%ecx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104258:	83 c1 01             	add    $0x1,%ecx
	ptable.pqueues[priority][tail] =  p;
8010425b:	89 3c 85 c4 1f 11 80 	mov    %edi,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104262:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104267:	f7 e9                	imul   %ecx
80104269:	89 c8                	mov    %ecx,%eax
8010426b:	c1 f8 1f             	sar    $0x1f,%eax
8010426e:	c1 fa 05             	sar    $0x5,%edx
80104271:	29 c2                	sub    %eax,%edx
80104273:	6b d2 64             	imul   $0x64,%edx,%edx
80104276:	29 d1                	sub    %edx,%ecx
80104278:	89 0c f5 f8 73 11 80 	mov    %ecx,-0x7fee8c08(,%esi,8)
	sched();
8010427f:	e8 cc fc ff ff       	call   80103f50 <sched>
	release(&ptable.lock);
80104284:	83 ec 0c             	sub    $0xc,%esp
80104287:	68 c0 1f 11 80       	push   $0x80111fc0
8010428c:	e8 8f 09 00 00       	call   80104c20 <release>
}
80104291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104294:	5b                   	pop    %ebx
80104295:	5e                   	pop    %esi
80104296:	5f                   	pop    %edi
80104297:	5d                   	pop    %ebp
80104298:	c3                   	ret    
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
80104299:	83 ec 0c             	sub    $0xc,%esp
8010429c:	68 78 86 10 80       	push   $0x80108678
801042a1:	e8 ea c0 ff ff       	call   80100390 <panic>
801042a6:	8d 76 00             	lea    0x0(%esi),%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <sleep>:
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	57                   	push   %edi
801042b4:	56                   	push   %esi
801042b5:	53                   	push   %ebx
801042b6:	83 ec 0c             	sub    $0xc,%esp
801042b9:	8b 7d 08             	mov    0x8(%ebp),%edi
801042bc:	8b 75 0c             	mov    0xc(%ebp),%esi
	pushcli();
801042bf:	e8 fc 07 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
801042c4:	e8 a7 f5 ff ff       	call   80103870 <mycpu>
	p = c->proc;
801042c9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
801042cf:	e8 ec 08 00 00       	call   80104bc0 <popcli>
	if (p == 0) panic("sleep");
801042d4:	85 db                	test   %ebx,%ebx
801042d6:	0f 84 87 00 00 00    	je     80104363 <sleep+0xb3>
	if (lk == 0) panic("sleep without lk");
801042dc:	85 f6                	test   %esi,%esi
801042de:	74 76                	je     80104356 <sleep+0xa6>
	if (lk != &ptable.lock) {      // DOC: sleeplock0
801042e0:	81 fe c0 1f 11 80    	cmp    $0x80111fc0,%esi
801042e6:	74 50                	je     80104338 <sleep+0x88>
		acquire(&ptable.lock); // DOC: sleeplock1
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	68 c0 1f 11 80       	push   $0x80111fc0
801042f0:	e8 0b 08 00 00       	call   80104b00 <acquire>
		release(lk);
801042f5:	89 34 24             	mov    %esi,(%esp)
801042f8:	e8 23 09 00 00       	call   80104c20 <release>
	p->chan  = chan;
801042fd:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
80104300:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	sched();
80104307:	e8 44 fc ff ff       	call   80103f50 <sched>
	p->chan = 0;
8010430c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
		release(&ptable.lock);
80104313:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
8010431a:	e8 01 09 00 00       	call   80104c20 <release>
		acquire(lk);
8010431f:	89 75 08             	mov    %esi,0x8(%ebp)
80104322:	83 c4 10             	add    $0x10,%esp
}
80104325:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104328:	5b                   	pop    %ebx
80104329:	5e                   	pop    %esi
8010432a:	5f                   	pop    %edi
8010432b:	5d                   	pop    %ebp
		acquire(lk);
8010432c:	e9 cf 07 00 00       	jmp    80104b00 <acquire>
80104331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	p->chan  = chan;
80104338:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
8010433b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	sched();
80104342:	e8 09 fc ff ff       	call   80103f50 <sched>
	p->chan = 0;
80104347:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010434e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104351:	5b                   	pop    %ebx
80104352:	5e                   	pop    %esi
80104353:	5f                   	pop    %edi
80104354:	5d                   	pop    %ebp
80104355:	c3                   	ret    
	if (lk == 0) panic("sleep without lk");
80104356:	83 ec 0c             	sub    $0xc,%esp
80104359:	68 7b 87 10 80       	push   $0x8010877b
8010435e:	e8 2d c0 ff ff       	call   80100390 <panic>
	if (p == 0) panic("sleep");
80104363:	83 ec 0c             	sub    $0xc,%esp
80104366:	68 75 87 10 80       	push   $0x80108775
8010436b:	e8 20 c0 ff ff       	call   80100390 <panic>

80104370 <wait>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
	pushcli();
80104375:	e8 46 07 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
8010437a:	e8 f1 f4 ff ff       	call   80103870 <mycpu>
	p = c->proc;
8010437f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	popcli();
80104385:	e8 36 08 00 00       	call   80104bc0 <popcli>
	acquire(&ptable.lock);
8010438a:	83 ec 0c             	sub    $0xc,%esp
8010438d:	68 c0 1f 11 80       	push   $0x80111fc0
80104392:	e8 69 07 00 00       	call   80104b00 <acquire>
80104397:	83 c4 10             	add    $0x10,%esp
		havekids = 0;
8010439a:	31 c0                	xor    %eax,%eax
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010439c:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
801043a1:	eb 13                	jmp    801043b6 <wait+0x46>
801043a3:	90                   	nop
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043a8:	81 c3 50 01 00 00    	add    $0x150,%ebx
801043ae:	81 fb f4 73 11 80    	cmp    $0x801173f4,%ebx
801043b4:	73 1e                	jae    801043d4 <wait+0x64>
			if (p->parent != curproc) continue;
801043b6:	39 73 14             	cmp    %esi,0x14(%ebx)
801043b9:	75 ed                	jne    801043a8 <wait+0x38>
			if (p->state == ZOMBIE) {
801043bb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043bf:	74 37                	je     801043f8 <wait+0x88>
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043c1:	81 c3 50 01 00 00    	add    $0x150,%ebx
			havekids = 1;
801043c7:	b8 01 00 00 00       	mov    $0x1,%eax
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043cc:	81 fb f4 73 11 80    	cmp    $0x801173f4,%ebx
801043d2:	72 e2                	jb     801043b6 <wait+0x46>
		if (!havekids || curproc->killed) {
801043d4:	85 c0                	test   %eax,%eax
801043d6:	74 76                	je     8010444e <wait+0xde>
801043d8:	8b 46 24             	mov    0x24(%esi),%eax
801043db:	85 c0                	test   %eax,%eax
801043dd:	75 6f                	jne    8010444e <wait+0xde>
		sleep(curproc, &ptable.lock); // DOC: wait-sleep
801043df:	83 ec 08             	sub    $0x8,%esp
801043e2:	68 c0 1f 11 80       	push   $0x80111fc0
801043e7:	56                   	push   %esi
801043e8:	e8 c3 fe ff ff       	call   801042b0 <sleep>
		havekids = 0;
801043ed:	83 c4 10             	add    $0x10,%esp
801043f0:	eb a8                	jmp    8010439a <wait+0x2a>
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				kfree(p->kstack);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	ff 73 08             	pushl  0x8(%ebx)
				pid = p->pid;
801043fe:	8b 73 10             	mov    0x10(%ebx),%esi
				kfree(p->kstack);
80104401:	e8 4a df ff ff       	call   80102350 <kfree>
				freevm(p->pgdir);
80104406:	5a                   	pop    %edx
80104407:	ff 73 04             	pushl  0x4(%ebx)
				p->kstack = 0;
8010440a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
				freevm(p->pgdir);
80104411:	e8 ca 37 00 00       	call   80107be0 <freevm>
				release(&ptable.lock);
80104416:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
				p->pid     = 0;
8010441d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
				p->parent  = 0;
80104424:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
				p->name[0] = 0;
8010442b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
				p->killed  = 0;
8010442f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
				p->state   = UNUSED;
80104436:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
				release(&ptable.lock);
8010443d:	e8 de 07 00 00       	call   80104c20 <release>
				return pid;
80104442:	83 c4 10             	add    $0x10,%esp
}
80104445:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104448:	89 f0                	mov    %esi,%eax
8010444a:	5b                   	pop    %ebx
8010444b:	5e                   	pop    %esi
8010444c:	5d                   	pop    %ebp
8010444d:	c3                   	ret    
			release(&ptable.lock);
8010444e:	83 ec 0c             	sub    $0xc,%esp
			return -1;
80104451:	be ff ff ff ff       	mov    $0xffffffff,%esi
			release(&ptable.lock);
80104456:	68 c0 1f 11 80       	push   $0x80111fc0
8010445b:	e8 c0 07 00 00       	call   80104c20 <release>
			return -1;
80104460:	83 c4 10             	add    $0x10,%esp
80104463:	eb e0                	jmp    80104445 <wait+0xd5>
80104465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104470 <wakeup>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 10             	sub    $0x10,%esp
80104477:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
8010447a:	68 c0 1f 11 80       	push   $0x80111fc0
8010447f:	e8 7c 06 00 00       	call   80104b00 <acquire>
	wakeup1(chan);
80104484:	89 d8                	mov    %ebx,%eax
80104486:	e8 b5 f1 ff ff       	call   80103640 <wakeup1>
	release(&ptable.lock);
8010448b:	83 c4 10             	add    $0x10,%esp
8010448e:	c7 45 08 c0 1f 11 80 	movl   $0x80111fc0,0x8(%ebp)
}
80104495:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104498:	c9                   	leave  
	release(&ptable.lock);
80104499:	e9 82 07 00 00       	jmp    80104c20 <release>
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <kill>:
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	53                   	push   %ebx
801044a6:	83 ec 18             	sub    $0x18,%esp
801044a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
801044ac:	68 c0 1f 11 80       	push   $0x80111fc0
801044b1:	e8 4a 06 00 00       	call   80104b00 <acquire>
801044b6:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044b9:	b9 f4 1f 11 80       	mov    $0x80111ff4,%ecx
801044be:	eb 12                	jmp    801044d2 <kill+0x32>
801044c0:	81 c1 50 01 00 00    	add    $0x150,%ecx
801044c6:	81 f9 f4 73 11 80    	cmp    $0x801173f4,%ecx
801044cc:	0f 83 9e 00 00 00    	jae    80104570 <kill+0xd0>
		if (p->pid == pid) {
801044d2:	39 59 10             	cmp    %ebx,0x10(%ecx)
801044d5:	75 e9                	jne    801044c0 <kill+0x20>
			if (p->state == SLEEPING){
801044d7:	83 79 0c 02          	cmpl   $0x2,0xc(%ecx)
			p->killed = 1;
801044db:	c7 41 24 01 00 00 00 	movl   $0x1,0x24(%ecx)
			if (p->state == SLEEPING){
801044e2:	75 69                	jne    8010454d <kill+0xad>
	int priority = p->priority;
801044e4:	8b b9 cc 00 00 00    	mov    0xcc(%ecx),%edi
				p->state = RUNNABLE;
801044ea:	c7 41 0c 03 00 00 00 	movl   $0x3,0xc(%ecx)
	if (tail == (head-1)%QSIZE){
801044f1:	8b 04 fd f4 73 11 80 	mov    -0x7fee8c0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
801044f8:	8b 1c fd f8 73 11 80 	mov    -0x7fee8c08(,%edi,8),%ebx
	if (tail == (head-1)%QSIZE){
801044ff:	8d 70 ff             	lea    -0x1(%eax),%esi
80104502:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104507:	f7 ee                	imul   %esi
80104509:	89 f0                	mov    %esi,%eax
8010450b:	c1 f8 1f             	sar    $0x1f,%eax
8010450e:	c1 fa 05             	sar    $0x5,%edx
80104511:	29 c2                	sub    %eax,%edx
80104513:	6b c2 64             	imul   $0x64,%edx,%eax
80104516:	29 c6                	sub    %eax,%esi
80104518:	39 f3                	cmp    %esi,%ebx
8010451a:	74 71                	je     8010458d <kill+0xed>
	ptable.pqueues[priority][tail] =  p;
8010451c:	6b c7 64             	imul   $0x64,%edi,%eax
8010451f:	8d 84 03 34 15 00 00 	lea    0x1534(%ebx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104526:	83 c3 01             	add    $0x1,%ebx
	ptable.pqueues[priority][tail] =  p;
80104529:	89 0c 85 c4 1f 11 80 	mov    %ecx,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104530:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104535:	f7 eb                	imul   %ebx
80104537:	89 d8                	mov    %ebx,%eax
80104539:	c1 f8 1f             	sar    $0x1f,%eax
8010453c:	c1 fa 05             	sar    $0x5,%edx
8010453f:	29 c2                	sub    %eax,%edx
80104541:	6b c2 64             	imul   $0x64,%edx,%eax
80104544:	29 c3                	sub    %eax,%ebx
80104546:	89 1c fd f8 73 11 80 	mov    %ebx,-0x7fee8c08(,%edi,8)
			release(&ptable.lock);
8010454d:	83 ec 0c             	sub    $0xc,%esp
80104550:	68 c0 1f 11 80       	push   $0x80111fc0
80104555:	e8 c6 06 00 00       	call   80104c20 <release>
			return 0;
8010455a:	83 c4 10             	add    $0x10,%esp
}
8010455d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return 0;
80104560:	31 c0                	xor    %eax,%eax
}
80104562:	5b                   	pop    %ebx
80104563:	5e                   	pop    %esi
80104564:	5f                   	pop    %edi
80104565:	5d                   	pop    %ebp
80104566:	c3                   	ret    
80104567:	89 f6                	mov    %esi,%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	release(&ptable.lock);
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	68 c0 1f 11 80       	push   $0x80111fc0
80104578:	e8 a3 06 00 00       	call   80104c20 <release>
	return -1;
8010457d:	83 c4 10             	add    $0x10,%esp
}
80104580:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
80104583:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104588:	5b                   	pop    %ebx
80104589:	5e                   	pop    %esi
8010458a:	5f                   	pop    %edi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret    
					panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 78 86 10 80       	push   $0x80108678
80104595:	e8 f6 bd ff ff       	call   80100390 <panic>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <procdump>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045a9:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
{
801045ae:	83 ec 3c             	sub    $0x3c,%esp
801045b1:	eb 27                	jmp    801045da <procdump+0x3a>
801045b3:	90                   	nop
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("\n");
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 0f 8b 10 80       	push   $0x80108b0f
801045c0:	e8 9b c0 ff ff       	call   80100660 <cprintf>
801045c5:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045c8:	81 c3 50 01 00 00    	add    $0x150,%ebx
801045ce:	81 fb f4 73 11 80    	cmp    $0x801173f4,%ebx
801045d4:	0f 83 86 00 00 00    	jae    80104660 <procdump+0xc0>
		if (p->state == UNUSED) continue;
801045da:	8b 43 0c             	mov    0xc(%ebx),%eax
801045dd:	85 c0                	test   %eax,%eax
801045df:	74 e7                	je     801045c8 <procdump+0x28>
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045e1:	83 f8 05             	cmp    $0x5,%eax
			state = "???";
801045e4:	ba 8c 87 10 80       	mov    $0x8010878c,%edx
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801045e9:	77 11                	ja     801045fc <procdump+0x5c>
801045eb:	8b 14 85 c4 87 10 80 	mov    -0x7fef783c(,%eax,4),%edx
			state = "???";
801045f2:	b8 8c 87 10 80       	mov    $0x8010878c,%eax
801045f7:	85 d2                	test   %edx,%edx
801045f9:	0f 44 d0             	cmove  %eax,%edx
		cprintf("%d %s %s", p->pid, state, p->name);
801045fc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801045ff:	50                   	push   %eax
80104600:	52                   	push   %edx
80104601:	ff 73 10             	pushl  0x10(%ebx)
80104604:	68 90 87 10 80       	push   $0x80108790
80104609:	e8 52 c0 ff ff       	call   80100660 <cprintf>
		if (p->state == SLEEPING) {
8010460e:	83 c4 10             	add    $0x10,%esp
80104611:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104615:	75 a1                	jne    801045b8 <procdump+0x18>
			getcallerpcs((uint *)p->context->ebp + 2, pc);
80104617:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010461a:	83 ec 08             	sub    $0x8,%esp
8010461d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104620:	50                   	push   %eax
80104621:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104624:	8b 40 0c             	mov    0xc(%eax),%eax
80104627:	83 c0 08             	add    $0x8,%eax
8010462a:	50                   	push   %eax
8010462b:	e8 00 04 00 00       	call   80104a30 <getcallerpcs>
80104630:	83 c4 10             	add    $0x10,%esp
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			for (i = 0; i < 10 && pc[i] != 0; i++) cprintf(" %p", pc[i]);
80104638:	8b 17                	mov    (%edi),%edx
8010463a:	85 d2                	test   %edx,%edx
8010463c:	0f 84 76 ff ff ff    	je     801045b8 <procdump+0x18>
80104642:	83 ec 08             	sub    $0x8,%esp
80104645:	83 c7 04             	add    $0x4,%edi
80104648:	52                   	push   %edx
80104649:	68 61 81 10 80       	push   $0x80108161
8010464e:	e8 0d c0 ff ff       	call   80100660 <cprintf>
80104653:	83 c4 10             	add    $0x10,%esp
80104656:	39 fe                	cmp    %edi,%esi
80104658:	75 de                	jne    80104638 <procdump+0x98>
8010465a:	e9 59 ff ff ff       	jmp    801045b8 <procdump+0x18>
8010465f:	90                   	nop
}
80104660:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104663:	5b                   	pop    %ebx
80104664:	5e                   	pop    %esi
80104665:	5f                   	pop    %edi
80104666:	5d                   	pop    %ebp
80104667:	c3                   	ret    
80104668:	90                   	nop
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <pq_enqueue>:
pq_enqueue (struct proc *p){
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	56                   	push   %esi
	if (!(p->state == RUNNABLE)){
80104675:	8b 45 08             	mov    0x8(%ebp),%eax
pq_enqueue (struct proc *p){
80104678:	53                   	push   %ebx
	if (!(p->state == RUNNABLE)){
80104679:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010467d:	75 71                	jne    801046f0 <pq_enqueue+0x80>
	int priority = p->priority;
8010467f:	8b b8 cc 00 00 00    	mov    0xcc(%eax),%edi
	if (tail == (head-1)%QSIZE){
80104685:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
8010468a:	8b 04 fd f4 73 11 80 	mov    -0x7fee8c0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
80104691:	8b 1c fd f8 73 11 80 	mov    -0x7fee8c08(,%edi,8),%ebx
	if (tail == (head-1)%QSIZE){
80104698:	8d 70 ff             	lea    -0x1(%eax),%esi
8010469b:	89 f0                	mov    %esi,%eax
8010469d:	f7 e9                	imul   %ecx
8010469f:	89 f0                	mov    %esi,%eax
801046a1:	c1 f8 1f             	sar    $0x1f,%eax
801046a4:	c1 fa 05             	sar    $0x5,%edx
801046a7:	29 c2                	sub    %eax,%edx
801046a9:	6b d2 64             	imul   $0x64,%edx,%edx
801046ac:	29 d6                	sub    %edx,%esi
801046ae:	39 de                	cmp    %ebx,%esi
801046b0:	74 3e                	je     801046f0 <pq_enqueue+0x80>
	ptable.pqueues[priority][tail] =  p;
801046b2:	6b c7 64             	imul   $0x64,%edi,%eax
801046b5:	8b 75 08             	mov    0x8(%ebp),%esi
801046b8:	8d 84 03 34 15 00 00 	lea    0x1534(%ebx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801046bf:	83 c3 01             	add    $0x1,%ebx
	ptable.pqueues[priority][tail] =  p;
801046c2:	89 34 85 c4 1f 11 80 	mov    %esi,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801046c9:	89 d8                	mov    %ebx,%eax
801046cb:	f7 e9                	imul   %ecx
801046cd:	89 d8                	mov    %ebx,%eax
801046cf:	c1 f8 1f             	sar    $0x1f,%eax
801046d2:	89 d1                	mov    %edx,%ecx
801046d4:	c1 f9 05             	sar    $0x5,%ecx
801046d7:	29 c1                	sub    %eax,%ecx
	return 1;
801046d9:	b8 01 00 00 00       	mov    $0x1,%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801046de:	6b c9 64             	imul   $0x64,%ecx,%ecx
801046e1:	29 cb                	sub    %ecx,%ebx
801046e3:	89 1c fd f8 73 11 80 	mov    %ebx,-0x7fee8c08(,%edi,8)
}
801046ea:	5b                   	pop    %ebx
801046eb:	5e                   	pop    %esi
801046ec:	5f                   	pop    %edi
801046ed:	5d                   	pop    %ebp
801046ee:	c3                   	ret    
801046ef:	90                   	nop
		return -1;
801046f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f5:	eb f3                	jmp    801046ea <pq_enqueue+0x7a>
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <pq_dequeue>:
pq_dequeue(){
80104700:	55                   	push   %ebp
	int priority = 0;
80104701:	31 c9                	xor    %ecx,%ecx
pq_dequeue(){
80104703:	89 e5                	mov    %esp,%ebp
80104705:	56                   	push   %esi
80104706:	53                   	push   %ebx
80104707:	eb 0f                	jmp    80104718 <pq_dequeue+0x18>
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		priority++;
80104710:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && ptable.head_tail[priority][0] == ptable.head_tail[priority][1])	// queue is empty if head == tail
80104713:	83 f9 14             	cmp    $0x14,%ecx
80104716:	74 50                	je     80104768 <pq_dequeue+0x68>
80104718:	8b 04 cd f4 73 11 80 	mov    -0x7fee8c0c(,%ecx,8),%eax
8010471f:	3b 04 cd f8 73 11 80 	cmp    -0x7fee8c08(,%ecx,8),%eax
80104726:	74 e8                	je     80104710 <pq_dequeue+0x10>
	struct proc *p = ptable.pqueues[priority][head];
80104728:	6b d1 64             	imul   $0x64,%ecx,%edx
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
8010472b:	8d 58 01             	lea    0x1(%eax),%ebx
	struct proc *p = ptable.pqueues[priority][head];
8010472e:	8d 94 10 34 15 00 00 	lea    0x1534(%eax,%edx,1),%edx
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80104735:	89 d8                	mov    %ebx,%eax
	struct proc *p = ptable.pqueues[priority][head];
80104737:	8b 34 95 c4 1f 11 80 	mov    -0x7feee03c(,%edx,4),%esi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
8010473e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80104743:	f7 ea                	imul   %edx
80104745:	89 d8                	mov    %ebx,%eax
80104747:	c1 f8 1f             	sar    $0x1f,%eax
8010474a:	c1 fa 05             	sar    $0x5,%edx
8010474d:	29 c2                	sub    %eax,%edx
8010474f:	89 d8                	mov    %ebx,%eax
80104751:	6b d2 64             	imul   $0x64,%edx,%edx
	return p;
}
80104754:	5b                   	pop    %ebx
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80104755:	29 d0                	sub    %edx,%eax
80104757:	89 04 cd f4 73 11 80 	mov    %eax,-0x7fee8c0c(,%ecx,8)
}
8010475e:	89 f0                	mov    %esi,%eax
80104760:	5e                   	pop    %esi
80104761:	5d                   	pop    %ebp
80104762:	c3                   	ret    
80104763:	90                   	nop
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return NULL;
80104768:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
8010476d:	89 f0                	mov    %esi,%eax
8010476f:	5b                   	pop    %ebx
80104770:	5e                   	pop    %esi
80104771:	5d                   	pop    %ebp
80104772:	c3                   	ret    
80104773:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104780 <signalcv>:

int 
signalcv(int muxid){
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	53                   	push   %ebx

	argint(0,(int*)&muxid);
80104786:	8d 45 08             	lea    0x8(%ebp),%eax
signalcv(int muxid){
80104789:	83 ec 24             	sub    $0x24,%esp
	argint(0,(int*)&muxid);
8010478c:	50                   	push   %eax
8010478d:	6a 00                	push   $0x0
8010478f:	e8 ec 07 00 00       	call   80104f80 <argint>
	pushcli();
80104794:	e8 27 03 00 00       	call   80104ac0 <pushcli>
	c = mycpu();
80104799:	e8 d2 f0 ff ff       	call   80103870 <mycpu>
	p = c->proc;
8010479e:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	popcli();
801047a4:	e8 17 04 00 00       	call   80104bc0 <popcli>
	p = myproc();
	int i;

	/* verify this process has access to this mutex
	and make sure proc is currently holding this mutex*/
	if (p->mux_ptrs[muxid] == 0 || p->mux_ptrs[muxid]->state != 1){
801047a9:	8b 45 08             	mov    0x8(%ebp),%eax
801047ac:	83 c4 10             	add    $0x10,%esp
801047af:	8b 44 86 7c          	mov    0x7c(%esi,%eax,4),%eax
801047b3:	85 c0                	test   %eax,%eax
801047b5:	74 08                	je     801047bf <signalcv+0x3f>
801047b7:	8b 58 04             	mov    0x4(%eax),%ebx
801047ba:	83 fb 01             	cmp    $0x1,%ebx
801047bd:	74 11                	je     801047d0 <signalcv+0x50>
		return 0;
801047bf:	31 db                	xor    %ebx,%ebx
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
	}
	release(&ptable.lock);

	return 1;
}
801047c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c4:	89 d8                	mov    %ebx,%eax
801047c6:	5b                   	pop    %ebx
801047c7:	5e                   	pop    %esi
801047c8:	5f                   	pop    %edi
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
801047cb:	90                   	nop
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	acquire(&MUTEXES.lock);
801047d0:	83 ec 0c             	sub    $0xc,%esp
801047d3:	68 e0 93 11 80       	push   $0x801193e0
801047d8:	e8 23 03 00 00       	call   80104b00 <acquire>
801047dd:	8b 45 08             	mov    0x8(%ebp),%eax
	if (sleepy_proc == 0){
801047e0:	83 c4 10             	add    $0x10,%esp
801047e3:	8d 0c 86             	lea    (%esi,%eax,4),%ecx
	for (i=0; i<999; i++){
801047e6:	31 c0                	xor    %eax,%eax
	sleepy_proc = p->mux_ptrs[muxid]->cv[0];
801047e8:	8b 79 7c             	mov    0x7c(%ecx),%edi
801047eb:	8b 77 08             	mov    0x8(%edi),%esi
	if (sleepy_proc == 0){
801047ee:	85 f6                	test   %esi,%esi
801047f0:	75 13                	jne    80104805 <signalcv+0x85>
801047f2:	e9 d7 00 00 00       	jmp    801048ce <signalcv+0x14e>
801047f7:	89 f6                	mov    %esi,%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104800:	8b 79 7c             	mov    0x7c(%ecx),%edi
80104803:	89 d0                	mov    %edx,%eax
		p->mux_ptrs[muxid]->cv[i] = p->mux_ptrs[muxid]->cv[i+1];
80104805:	8d 50 01             	lea    0x1(%eax),%edx
80104808:	8d 04 87             	lea    (%edi,%eax,4),%eax
8010480b:	8b 78 0c             	mov    0xc(%eax),%edi
	for (i=0; i<999; i++){
8010480e:	81 fa e7 03 00 00    	cmp    $0x3e7,%edx
		p->mux_ptrs[muxid]->cv[i] = p->mux_ptrs[muxid]->cv[i+1];
80104814:	89 78 08             	mov    %edi,0x8(%eax)
	for (i=0; i<999; i++){
80104817:	75 e7                	jne    80104800 <signalcv+0x80>
	p->mux_ptrs[muxid]->cv[999] = 0;
80104819:	8b 41 7c             	mov    0x7c(%ecx),%eax
	release(&MUTEXES.lock);
8010481c:	83 ec 0c             	sub    $0xc,%esp
	p->mux_ptrs[muxid]->cv[999] = 0;
8010481f:	c7 80 a4 0f 00 00 00 	movl   $0x0,0xfa4(%eax)
80104826:	00 00 00 
	release(&MUTEXES.lock);
80104829:	68 e0 93 11 80       	push   $0x801193e0
8010482e:	e8 ed 03 00 00       	call   80104c20 <release>
	acquire(&ptable.lock);
80104833:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
8010483a:	e8 c1 02 00 00       	call   80104b00 <acquire>
	int priority = p->priority;
8010483f:	8b be cc 00 00 00    	mov    0xcc(%esi),%edi
	sleepy_proc->state = RUNNABLE;
80104845:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
	if (tail == (head-1)%QSIZE){
8010484c:	83 c4 10             	add    $0x10,%esp
8010484f:	8b 04 fd f4 73 11 80 	mov    -0x7fee8c0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
80104856:	8b 0c fd f8 73 11 80 	mov    -0x7fee8c08(,%edi,8),%ecx
	if (tail == (head-1)%QSIZE){
8010485d:	83 e8 01             	sub    $0x1,%eax
80104860:	89 c2                	mov    %eax,%edx
80104862:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104867:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010486a:	f7 ea                	imul   %edx
8010486c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010486f:	c1 fa 05             	sar    $0x5,%edx
80104872:	c1 f8 1f             	sar    $0x1f,%eax
80104875:	29 c2                	sub    %eax,%edx
80104877:	6b c2 64             	imul   $0x64,%edx,%eax
8010487a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010487d:	29 c2                	sub    %eax,%edx
8010487f:	39 d1                	cmp    %edx,%ecx
80104881:	74 62                	je     801048e5 <signalcv+0x165>
	ptable.pqueues[priority][tail] =  p;
80104883:	6b c7 64             	imul   $0x64,%edi,%eax
	release(&ptable.lock);
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	68 c0 1f 11 80       	push   $0x80111fc0
	ptable.pqueues[priority][tail] =  p;
8010488e:	8d 84 01 34 15 00 00 	lea    0x1534(%ecx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104895:	83 c1 01             	add    $0x1,%ecx
	ptable.pqueues[priority][tail] =  p;
80104898:	89 34 85 c4 1f 11 80 	mov    %esi,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
8010489f:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
801048a4:	f7 e9                	imul   %ecx
801048a6:	89 c8                	mov    %ecx,%eax
801048a8:	c1 f8 1f             	sar    $0x1f,%eax
801048ab:	c1 fa 05             	sar    $0x5,%edx
801048ae:	29 c2                	sub    %eax,%edx
801048b0:	6b c2 64             	imul   $0x64,%edx,%eax
801048b3:	29 c1                	sub    %eax,%ecx
801048b5:	89 0c fd f8 73 11 80 	mov    %ecx,-0x7fee8c08(,%edi,8)
	release(&ptable.lock);
801048bc:	e8 5f 03 00 00       	call   80104c20 <release>
	return 1;
801048c1:	83 c4 10             	add    $0x10,%esp
}
801048c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c7:	89 d8                	mov    %ebx,%eax
801048c9:	5b                   	pop    %ebx
801048ca:	5e                   	pop    %esi
801048cb:	5f                   	pop    %edi
801048cc:	5d                   	pop    %ebp
801048cd:	c3                   	ret    
		release(&MUTEXES.lock);
801048ce:	83 ec 0c             	sub    $0xc,%esp
		return 0;
801048d1:	31 db                	xor    %ebx,%ebx
		release(&MUTEXES.lock);
801048d3:	68 e0 93 11 80       	push   $0x801193e0
801048d8:	e8 43 03 00 00       	call   80104c20 <release>
		return 0;
801048dd:	83 c4 10             	add    $0x10,%esp
801048e0:	e9 dc fe ff ff       	jmp    801047c1 <signalcv+0x41>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801048e5:	83 ec 0c             	sub    $0xc,%esp
801048e8:	68 78 86 10 80       	push   $0x80108678
801048ed:	e8 9e ba ff ff       	call   80100390 <panic>
801048f2:	66 90                	xchg   %ax,%ax
801048f4:	66 90                	xchg   %ax,%ax
801048f6:	66 90                	xchg   %ax,%ax
801048f8:	66 90                	xchg   %ax,%ax
801048fa:	66 90                	xchg   %ax,%ax
801048fc:	66 90                	xchg   %ax,%ax
801048fe:	66 90                	xchg   %ax,%ax

80104900 <initsleeplock>:
// #include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&lk->lk, "sleep lock");
8010490a:	68 dc 87 10 80       	push   $0x801087dc
8010490f:	8d 43 04             	lea    0x4(%ebx),%eax
80104912:	50                   	push   %eax
80104913:	e8 f8 00 00 00       	call   80104a10 <initlock>
	lk->name   = name;
80104918:	8b 45 0c             	mov    0xc(%ebp),%eax
	lk->locked = 0;
8010491b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	lk->pid    = 0;
}
80104921:	83 c4 10             	add    $0x10,%esp
	lk->pid    = 0;
80104924:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
	lk->name   = name;
8010492b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010492e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104931:	c9                   	leave  
80104932:	c3                   	ret    
80104933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lk->lk);
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	8d 73 04             	lea    0x4(%ebx),%esi
8010494e:	56                   	push   %esi
8010494f:	e8 ac 01 00 00       	call   80104b00 <acquire>
	while (lk->locked) {
80104954:	8b 13                	mov    (%ebx),%edx
80104956:	83 c4 10             	add    $0x10,%esp
80104959:	85 d2                	test   %edx,%edx
8010495b:	74 16                	je     80104973 <acquiresleep+0x33>
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
		sleep(lk, &lk->lk);
80104960:	83 ec 08             	sub    $0x8,%esp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
80104965:	e8 46 f9 ff ff       	call   801042b0 <sleep>
	while (lk->locked) {
8010496a:	8b 03                	mov    (%ebx),%eax
8010496c:	83 c4 10             	add    $0x10,%esp
8010496f:	85 c0                	test   %eax,%eax
80104971:	75 ed                	jne    80104960 <acquiresleep+0x20>
	}
	lk->locked = 1;
80104973:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
	lk->pid    = myproc()->pid;
80104979:	e8 92 ef ff ff       	call   80103910 <myproc>
8010497e:	8b 40 10             	mov    0x10(%eax),%eax
80104981:	89 43 3c             	mov    %eax,0x3c(%ebx)
	release(&lk->lk);
80104984:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104987:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010498a:	5b                   	pop    %ebx
8010498b:	5e                   	pop    %esi
8010498c:	5d                   	pop    %ebp
	release(&lk->lk);
8010498d:	e9 8e 02 00 00       	jmp    80104c20 <release>
80104992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lk->lk);
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	8d 73 04             	lea    0x4(%ebx),%esi
801049ae:	56                   	push   %esi
801049af:	e8 4c 01 00 00       	call   80104b00 <acquire>
	lk->locked = 0;
801049b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	lk->pid    = 0;
801049ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
	wakeup(lk);
801049c1:	89 1c 24             	mov    %ebx,(%esp)
801049c4:	e8 a7 fa ff ff       	call   80104470 <wakeup>
	release(&lk->lk);
801049c9:	89 75 08             	mov    %esi,0x8(%ebp)
801049cc:	83 c4 10             	add    $0x10,%esp
}
801049cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d2:	5b                   	pop    %ebx
801049d3:	5e                   	pop    %esi
801049d4:	5d                   	pop    %ebp
	release(&lk->lk);
801049d5:	e9 46 02 00 00       	jmp    80104c20 <release>
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;

	acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 5e 04             	lea    0x4(%esi),%ebx
801049ee:	53                   	push   %ebx
801049ef:	e8 0c 01 00 00       	call   80104b00 <acquire>
	r = lk->locked;
801049f4:	8b 36                	mov    (%esi),%esi
	release(&lk->lk);
801049f6:	89 1c 24             	mov    %ebx,(%esp)
801049f9:	e8 22 02 00 00       	call   80104c20 <release>
	return r;
}
801049fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a01:	89 f0                	mov    %esi,%eax
80104a03:	5b                   	pop    %ebx
80104a04:	5e                   	pop    %esi
80104a05:	5d                   	pop    %ebp
80104a06:	c3                   	ret    
80104a07:	66 90                	xchg   %ax,%ax
80104a09:	66 90                	xchg   %ax,%ax
80104a0b:	66 90                	xchg   %ax,%ax
80104a0d:	66 90                	xchg   %ax,%ax
80104a0f:	90                   	nop

80104a10 <initlock>:
#include "proc.h"
// #include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->name   = name;
80104a16:	8b 55 0c             	mov    0xc(%ebp),%edx
	lk->locked = 0;
80104a19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	lk->name   = name;
80104a1f:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu    = 0;
80104a22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret    
80104a2b:	90                   	nop
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a30:	55                   	push   %ebp
	uint *ebp;
	int   i;

	ebp = (uint *)v - 2;
	for (i = 0; i < 10; i++) {
80104a31:	31 d2                	xor    %edx,%edx
{
80104a33:	89 e5                	mov    %esp,%ebp
80104a35:	53                   	push   %ebx
	ebp = (uint *)v - 2;
80104a36:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	ebp = (uint *)v - 2;
80104a3c:	83 e8 08             	sub    $0x8,%eax
80104a3f:	90                   	nop
		if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff) break;
80104a40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a4c:	77 1a                	ja     80104a68 <getcallerpcs+0x38>
		pcs[i] = ebp[1];         // saved %eip
80104a4e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a51:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
	for (i = 0; i < 10; i++) {
80104a54:	83 c2 01             	add    $0x1,%edx
		ebp    = (uint *)ebp[0]; // saved %ebp
80104a57:	8b 00                	mov    (%eax),%eax
	for (i = 0; i < 10; i++) {
80104a59:	83 fa 0a             	cmp    $0xa,%edx
80104a5c:	75 e2                	jne    80104a40 <getcallerpcs+0x10>
	}
	for (; i < 10; i++) pcs[i] = 0;
}
80104a5e:	5b                   	pop    %ebx
80104a5f:	5d                   	pop    %ebp
80104a60:	c3                   	ret    
80104a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a6b:	83 c1 28             	add    $0x28,%ecx
80104a6e:	66 90                	xchg   %ax,%ax
	for (; i < 10; i++) pcs[i] = 0;
80104a70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a76:	83 c0 04             	add    $0x4,%eax
80104a79:	39 c1                	cmp    %eax,%ecx
80104a7b:	75 f3                	jne    80104a70 <getcallerpcs+0x40>
}
80104a7d:	5b                   	pop    %ebx
80104a7e:	5d                   	pop    %ebp
80104a7f:	c3                   	ret    

80104a80 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
80104a87:	8b 55 08             	mov    0x8(%ebp),%edx
	return lock->locked && lock->cpu == mycpu();
80104a8a:	8b 02                	mov    (%edx),%eax
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	75 10                	jne    80104aa0 <holding+0x20>
}
80104a90:	83 c4 04             	add    $0x4,%esp
80104a93:	31 c0                	xor    %eax,%eax
80104a95:	5b                   	pop    %ebx
80104a96:	5d                   	pop    %ebp
80104a97:	c3                   	ret    
80104a98:	90                   	nop
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return lock->locked && lock->cpu == mycpu();
80104aa0:	8b 5a 08             	mov    0x8(%edx),%ebx
80104aa3:	e8 c8 ed ff ff       	call   80103870 <mycpu>
80104aa8:	39 c3                	cmp    %eax,%ebx
80104aaa:	0f 94 c0             	sete   %al
}
80104aad:	83 c4 04             	add    $0x4,%esp
	return lock->locked && lock->cpu == mycpu();
80104ab0:	0f b6 c0             	movzbl %al,%eax
}
80104ab3:	5b                   	pop    %ebx
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	9c                   	pushf  
80104ac8:	5b                   	pop    %ebx
	asm volatile("cli");
80104ac9:	fa                   	cli    
	int eflags;

	eflags = readeflags();
	cli();
	if (mycpu()->ncli == 0) mycpu()->intena = eflags & FL_IF;
80104aca:	e8 a1 ed ff ff       	call   80103870 <mycpu>
80104acf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ad5:	85 c0                	test   %eax,%eax
80104ad7:	75 11                	jne    80104aea <pushcli+0x2a>
80104ad9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104adf:	e8 8c ed ff ff       	call   80103870 <mycpu>
80104ae4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
	mycpu()->ncli += 1;
80104aea:	e8 81 ed ff ff       	call   80103870 <mycpu>
80104aef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104af6:	83 c4 04             	add    $0x4,%esp
80104af9:	5b                   	pop    %ebx
80104afa:	5d                   	pop    %ebp
80104afb:	c3                   	ret    
80104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b00 <acquire>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
	pushcli(); // disable interrupts to avoid deadlock.
80104b05:	e8 b6 ff ff ff       	call   80104ac0 <pushcli>
	if (holding(lk)) panic("acquire");
80104b0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == mycpu();
80104b0d:	8b 03                	mov    (%ebx),%eax
80104b0f:	85 c0                	test   %eax,%eax
80104b11:	0f 85 81 00 00 00    	jne    80104b98 <acquire+0x98>
	asm volatile("lock; xchgl %0, %1" : "+m"(*addr), "=a"(result) : "1"(newval) : "cc");
80104b17:	ba 01 00 00 00       	mov    $0x1,%edx
80104b1c:	eb 05                	jmp    80104b23 <acquire+0x23>
80104b1e:	66 90                	xchg   %ax,%ax
80104b20:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b23:	89 d0                	mov    %edx,%eax
80104b25:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
80104b28:	85 c0                	test   %eax,%eax
80104b2a:	75 f4                	jne    80104b20 <acquire+0x20>
	__sync_synchronize();
80104b2c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
	lk->cpu = mycpu();
80104b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b34:	e8 37 ed ff ff       	call   80103870 <mycpu>
	for (i = 0; i < 10; i++) {
80104b39:	31 d2                	xor    %edx,%edx
	getcallerpcs(&lk, lk->pcs);
80104b3b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
	lk->cpu = mycpu();
80104b3e:	89 43 08             	mov    %eax,0x8(%ebx)
	ebp = (uint *)v - 2;
80104b41:	89 e8                	mov    %ebp,%eax
80104b43:	90                   	nop
80104b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff) break;
80104b48:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104b4e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104b54:	77 1a                	ja     80104b70 <acquire+0x70>
		pcs[i] = ebp[1];         // saved %eip
80104b56:	8b 58 04             	mov    0x4(%eax),%ebx
80104b59:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
	for (i = 0; i < 10; i++) {
80104b5c:	83 c2 01             	add    $0x1,%edx
		ebp    = (uint *)ebp[0]; // saved %ebp
80104b5f:	8b 00                	mov    (%eax),%eax
	for (i = 0; i < 10; i++) {
80104b61:	83 fa 0a             	cmp    $0xa,%edx
80104b64:	75 e2                	jne    80104b48 <acquire+0x48>
}
80104b66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b69:	5b                   	pop    %ebx
80104b6a:	5e                   	pop    %esi
80104b6b:	5d                   	pop    %ebp
80104b6c:	c3                   	ret    
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
80104b70:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b73:	83 c1 28             	add    $0x28,%ecx
80104b76:	8d 76 00             	lea    0x0(%esi),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	for (; i < 10; i++) pcs[i] = 0;
80104b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b86:	83 c0 04             	add    $0x4,%eax
80104b89:	39 c8                	cmp    %ecx,%eax
80104b8b:	75 f3                	jne    80104b80 <acquire+0x80>
}
80104b8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b90:	5b                   	pop    %ebx
80104b91:	5e                   	pop    %esi
80104b92:	5d                   	pop    %ebp
80104b93:	c3                   	ret    
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return lock->locked && lock->cpu == mycpu();
80104b98:	8b 73 08             	mov    0x8(%ebx),%esi
80104b9b:	e8 d0 ec ff ff       	call   80103870 <mycpu>
80104ba0:	39 c6                	cmp    %eax,%esi
80104ba2:	0f 85 6f ff ff ff    	jne    80104b17 <acquire+0x17>
	if (holding(lk)) panic("acquire");
80104ba8:	83 ec 0c             	sub    $0xc,%esp
80104bab:	68 e7 87 10 80       	push   $0x801087e7
80104bb0:	e8 db b7 ff ff       	call   80100390 <panic>
80104bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <popcli>:

void
popcli(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	83 ec 08             	sub    $0x8,%esp
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80104bc6:	9c                   	pushf  
80104bc7:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("popcli - interruptible");
80104bc8:	f6 c4 02             	test   $0x2,%ah
80104bcb:	75 35                	jne    80104c02 <popcli+0x42>
	if (--mycpu()->ncli < 0) panic("popcli");
80104bcd:	e8 9e ec ff ff       	call   80103870 <mycpu>
80104bd2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104bd9:	78 34                	js     80104c0f <popcli+0x4f>
	if (mycpu()->ncli == 0 && mycpu()->intena) sti();
80104bdb:	e8 90 ec ff ff       	call   80103870 <mycpu>
80104be0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104be6:	85 d2                	test   %edx,%edx
80104be8:	74 06                	je     80104bf0 <popcli+0x30>
}
80104bea:	c9                   	leave  
80104beb:	c3                   	ret    
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (mycpu()->ncli == 0 && mycpu()->intena) sti();
80104bf0:	e8 7b ec ff ff       	call   80103870 <mycpu>
80104bf5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bfb:	85 c0                	test   %eax,%eax
80104bfd:	74 eb                	je     80104bea <popcli+0x2a>
	asm volatile("sti");
80104bff:	fb                   	sti    
}
80104c00:	c9                   	leave  
80104c01:	c3                   	ret    
	if (readeflags() & FL_IF) panic("popcli - interruptible");
80104c02:	83 ec 0c             	sub    $0xc,%esp
80104c05:	68 ef 87 10 80       	push   $0x801087ef
80104c0a:	e8 81 b7 ff ff       	call   80100390 <panic>
	if (--mycpu()->ncli < 0) panic("popcli");
80104c0f:	83 ec 0c             	sub    $0xc,%esp
80104c12:	68 06 88 10 80       	push   $0x80108806
80104c17:	e8 74 b7 ff ff       	call   80100390 <panic>
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c20 <release>:
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == mycpu();
80104c28:	8b 03                	mov    (%ebx),%eax
80104c2a:	85 c0                	test   %eax,%eax
80104c2c:	74 0c                	je     80104c3a <release+0x1a>
80104c2e:	8b 73 08             	mov    0x8(%ebx),%esi
80104c31:	e8 3a ec ff ff       	call   80103870 <mycpu>
80104c36:	39 c6                	cmp    %eax,%esi
80104c38:	74 16                	je     80104c50 <release+0x30>
	if (!holding(lk)) panic("release");
80104c3a:	83 ec 0c             	sub    $0xc,%esp
80104c3d:	68 0d 88 10 80       	push   $0x8010880d
80104c42:	e8 49 b7 ff ff       	call   80100390 <panic>
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	lk->pcs[0] = 0;
80104c50:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	lk->cpu    = 0;
80104c57:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	__sync_synchronize();
80104c5e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
	asm volatile("movl $0, %0" : "+m"(lk->locked) :);
80104c63:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c6c:	5b                   	pop    %ebx
80104c6d:	5e                   	pop    %esi
80104c6e:	5d                   	pop    %ebp
	popcli();
80104c6f:	e9 4c ff ff ff       	jmp    80104bc0 <popcli>
80104c74:	66 90                	xchg   %ax,%ax
80104c76:	66 90                	xchg   %ax,%ax
80104c78:	66 90                	xchg   %ax,%ax
80104c7a:	66 90                	xchg   %ax,%ax
80104c7c:	66 90                	xchg   %ax,%ax
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <memset>:
#include "types.h"
#include "x86.h"

void *
memset(void *dst, int c, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	53                   	push   %ebx
80104c85:	8b 55 08             	mov    0x8(%ebp),%edx
80104c88:	8b 4d 10             	mov    0x10(%ebp),%ecx
	if ((int)dst % 4 == 0 && n % 4 == 0) {
80104c8b:	f6 c2 03             	test   $0x3,%dl
80104c8e:	75 05                	jne    80104c95 <memset+0x15>
80104c90:	f6 c1 03             	test   $0x3,%cl
80104c93:	74 13                	je     80104ca8 <memset+0x28>
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
80104c95:	89 d7                	mov    %edx,%edi
80104c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9a:	fc                   	cld    
80104c9b:	f3 aa                	rep stos %al,%es:(%edi)
		c &= 0xFF;
		stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
	} else
		stosb(dst, c, n);
	return dst;
}
80104c9d:	5b                   	pop    %ebx
80104c9e:	89 d0                	mov    %edx,%eax
80104ca0:	5f                   	pop    %edi
80104ca1:	5d                   	pop    %ebp
80104ca2:	c3                   	ret    
80104ca3:	90                   	nop
80104ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c &= 0xFF;
80104ca8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
		stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
80104cac:	c1 e9 02             	shr    $0x2,%ecx
80104caf:	89 f8                	mov    %edi,%eax
80104cb1:	89 fb                	mov    %edi,%ebx
80104cb3:	c1 e0 18             	shl    $0x18,%eax
80104cb6:	c1 e3 10             	shl    $0x10,%ebx
80104cb9:	09 d8                	or     %ebx,%eax
80104cbb:	09 f8                	or     %edi,%eax
80104cbd:	c1 e7 08             	shl    $0x8,%edi
80104cc0:	09 f8                	or     %edi,%eax
	asm volatile("cld; rep stosl" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
80104cc2:	89 d7                	mov    %edx,%edi
80104cc4:	fc                   	cld    
80104cc5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104cc7:	5b                   	pop    %ebx
80104cc8:	89 d0                	mov    %edx,%eax
80104cca:	5f                   	pop    %edi
80104ccb:	5d                   	pop    %ebp
80104ccc:	c3                   	ret    
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi

80104cd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104cd9:	8b 75 08             	mov    0x8(%ebp),%esi
80104cdc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
80104cdf:	85 db                	test   %ebx,%ebx
80104ce1:	74 29                	je     80104d0c <memcmp+0x3c>
		if (*s1 != *s2) return *s1 - *s2;
80104ce3:	0f b6 16             	movzbl (%esi),%edx
80104ce6:	0f b6 0f             	movzbl (%edi),%ecx
80104ce9:	38 d1                	cmp    %dl,%cl
80104ceb:	75 2b                	jne    80104d18 <memcmp+0x48>
80104ced:	b8 01 00 00 00       	mov    $0x1,%eax
80104cf2:	eb 14                	jmp    80104d08 <memcmp+0x38>
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cf8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104cfc:	83 c0 01             	add    $0x1,%eax
80104cff:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d04:	38 ca                	cmp    %cl,%dl
80104d06:	75 10                	jne    80104d18 <memcmp+0x48>
	while (n-- > 0) {
80104d08:	39 d8                	cmp    %ebx,%eax
80104d0a:	75 ec                	jne    80104cf8 <memcmp+0x28>
		s1++, s2++;
	}

	return 0;
}
80104d0c:	5b                   	pop    %ebx
	return 0;
80104d0d:	31 c0                	xor    %eax,%eax
}
80104d0f:	5e                   	pop    %esi
80104d10:	5f                   	pop    %edi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret    
80104d13:	90                   	nop
80104d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (*s1 != *s2) return *s1 - *s2;
80104d18:	0f b6 c2             	movzbl %dl,%eax
}
80104d1b:	5b                   	pop    %ebx
		if (*s1 != *s2) return *s1 - *s2;
80104d1c:	29 c8                	sub    %ecx,%eax
}
80104d1e:	5e                   	pop    %esi
80104d1f:	5f                   	pop    %edi
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret    
80104d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	8b 45 08             	mov    0x8(%ebp),%eax
80104d38:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d3b:	8b 75 10             	mov    0x10(%ebp),%esi
	const char *s;
	char *      d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
80104d3e:	39 c3                	cmp    %eax,%ebx
80104d40:	73 26                	jae    80104d68 <memmove+0x38>
80104d42:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d45:	39 c8                	cmp    %ecx,%eax
80104d47:	73 1f                	jae    80104d68 <memmove+0x38>
		s += n;
		d += n;
		while (n-- > 0) *--d = *--s;
80104d49:	85 f6                	test   %esi,%esi
80104d4b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d4e:	74 0f                	je     80104d5f <memmove+0x2f>
80104d50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d57:	83 ea 01             	sub    $0x1,%edx
80104d5a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d5d:	75 f1                	jne    80104d50 <memmove+0x20>
	} else
		while (n-- > 0) *d++ = *s++;

	return dst;
}
80104d5f:	5b                   	pop    %ebx
80104d60:	5e                   	pop    %esi
80104d61:	5d                   	pop    %ebp
80104d62:	c3                   	ret    
80104d63:	90                   	nop
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		while (n-- > 0) *d++ = *s++;
80104d68:	31 d2                	xor    %edx,%edx
80104d6a:	85 f6                	test   %esi,%esi
80104d6c:	74 f1                	je     80104d5f <memmove+0x2f>
80104d6e:	66 90                	xchg   %ax,%ax
80104d70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d77:	83 c2 01             	add    $0x1,%edx
80104d7a:	39 d6                	cmp    %edx,%esi
80104d7c:	75 f2                	jne    80104d70 <memmove+0x40>
}
80104d7e:	5b                   	pop    %ebx
80104d7f:	5e                   	pop    %esi
80104d80:	5d                   	pop    %ebp
80104d81:	c3                   	ret    
80104d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
}
80104d93:	5d                   	pop    %ebp
	return memmove(dst, src, n);
80104d94:	eb 9a                	jmp    80104d30 <memmove>
80104d96:	8d 76 00             	lea    0x0(%esi),%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104da8:	53                   	push   %ebx
80104da9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dac:	8b 75 0c             	mov    0xc(%ebp),%esi
	while (n > 0 && *p && *p == *q) n--, p++, q++;
80104daf:	85 ff                	test   %edi,%edi
80104db1:	74 2f                	je     80104de2 <strncmp+0x42>
80104db3:	0f b6 01             	movzbl (%ecx),%eax
80104db6:	0f b6 1e             	movzbl (%esi),%ebx
80104db9:	84 c0                	test   %al,%al
80104dbb:	74 37                	je     80104df4 <strncmp+0x54>
80104dbd:	38 c3                	cmp    %al,%bl
80104dbf:	75 33                	jne    80104df4 <strncmp+0x54>
80104dc1:	01 f7                	add    %esi,%edi
80104dc3:	eb 13                	jmp    80104dd8 <strncmp+0x38>
80104dc5:	8d 76 00             	lea    0x0(%esi),%esi
80104dc8:	0f b6 01             	movzbl (%ecx),%eax
80104dcb:	84 c0                	test   %al,%al
80104dcd:	74 21                	je     80104df0 <strncmp+0x50>
80104dcf:	0f b6 1a             	movzbl (%edx),%ebx
80104dd2:	89 d6                	mov    %edx,%esi
80104dd4:	38 d8                	cmp    %bl,%al
80104dd6:	75 1c                	jne    80104df4 <strncmp+0x54>
80104dd8:	8d 56 01             	lea    0x1(%esi),%edx
80104ddb:	83 c1 01             	add    $0x1,%ecx
80104dde:	39 fa                	cmp    %edi,%edx
80104de0:	75 e6                	jne    80104dc8 <strncmp+0x28>
	if (n == 0) return 0;
	return (uchar)*p - (uchar)*q;
}
80104de2:	5b                   	pop    %ebx
	if (n == 0) return 0;
80104de3:	31 c0                	xor    %eax,%eax
}
80104de5:	5e                   	pop    %esi
80104de6:	5f                   	pop    %edi
80104de7:	5d                   	pop    %ebp
80104de8:	c3                   	ret    
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104df0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
	return (uchar)*p - (uchar)*q;
80104df4:	29 d8                	sub    %ebx,%eax
}
80104df6:	5b                   	pop    %ebx
80104df7:	5e                   	pop    %esi
80104df8:	5f                   	pop    %edi
80104df9:	5d                   	pop    %ebp
80104dfa:	c3                   	ret    
80104dfb:	90                   	nop
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e00 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	8b 45 08             	mov    0x8(%ebp),%eax
80104e08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e0b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
80104e0e:	89 c2                	mov    %eax,%edx
80104e10:	eb 19                	jmp    80104e2b <strncpy+0x2b>
80104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e18:	83 c3 01             	add    $0x1,%ebx
80104e1b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e1f:	83 c2 01             	add    $0x1,%edx
80104e22:	84 c9                	test   %cl,%cl
80104e24:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e27:	74 09                	je     80104e32 <strncpy+0x32>
80104e29:	89 f1                	mov    %esi,%ecx
80104e2b:	85 c9                	test   %ecx,%ecx
80104e2d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e30:	7f e6                	jg     80104e18 <strncpy+0x18>
		;
	while (n-- > 0) *s++ = 0;
80104e32:	31 c9                	xor    %ecx,%ecx
80104e34:	85 f6                	test   %esi,%esi
80104e36:	7e 17                	jle    80104e4f <strncpy+0x4f>
80104e38:	90                   	nop
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e40:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e44:	89 f3                	mov    %esi,%ebx
80104e46:	83 c1 01             	add    $0x1,%ecx
80104e49:	29 cb                	sub    %ecx,%ebx
80104e4b:	85 db                	test   %ebx,%ebx
80104e4d:	7f f1                	jg     80104e40 <strncpy+0x40>
	return os;
}
80104e4f:	5b                   	pop    %ebx
80104e50:	5e                   	pop    %esi
80104e51:	5d                   	pop    %ebp
80104e52:	c3                   	ret    
80104e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e68:	8b 45 08             	mov    0x8(%ebp),%eax
80104e6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *os;

	os = s;
	if (n <= 0) return os;
80104e6e:	85 c9                	test   %ecx,%ecx
80104e70:	7e 26                	jle    80104e98 <safestrcpy+0x38>
80104e72:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e76:	89 c1                	mov    %eax,%ecx
80104e78:	eb 17                	jmp    80104e91 <safestrcpy+0x31>
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while (--n > 0 && (*s++ = *t++) != 0)
80104e80:	83 c2 01             	add    $0x1,%edx
80104e83:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e87:	83 c1 01             	add    $0x1,%ecx
80104e8a:	84 db                	test   %bl,%bl
80104e8c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e8f:	74 04                	je     80104e95 <safestrcpy+0x35>
80104e91:	39 f2                	cmp    %esi,%edx
80104e93:	75 eb                	jne    80104e80 <safestrcpy+0x20>
		;
	*s = 0;
80104e95:	c6 01 00             	movb   $0x0,(%ecx)
	return os;
}
80104e98:	5b                   	pop    %ebx
80104e99:	5e                   	pop    %esi
80104e9a:	5d                   	pop    %ebp
80104e9b:	c3                   	ret    
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <strlen>:

int
strlen(const char *s)
{
80104ea0:	55                   	push   %ebp
	int n;

	for (n = 0; s[n]; n++)
80104ea1:	31 c0                	xor    %eax,%eax
{
80104ea3:	89 e5                	mov    %esp,%ebp
80104ea5:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; s[n]; n++)
80104ea8:	80 3a 00             	cmpb   $0x0,(%edx)
80104eab:	74 0c                	je     80104eb9 <strlen+0x19>
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
80104eb0:	83 c0 01             	add    $0x1,%eax
80104eb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104eb7:	75 f7                	jne    80104eb0 <strlen+0x10>
		;
	return n;
}
80104eb9:	5d                   	pop    %ebp
80104eba:	c3                   	ret    

80104ebb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104ebb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104ebf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104ec3:	55                   	push   %ebp
  pushl %ebx
80104ec4:	53                   	push   %ebx
  pushl %esi
80104ec5:	56                   	push   %esi
  pushl %edi
80104ec6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ec7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ec9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104ecb:	5f                   	pop    %edi
  popl %esi
80104ecc:	5e                   	pop    %esi
  popl %ebx
80104ecd:	5b                   	pop    %ebx
  popl %ebp
80104ece:	5d                   	pop    %ebp
  ret
80104ecf:	c3                   	ret    

80104ed0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	53                   	push   %ebx
80104ed4:	83 ec 04             	sub    $0x4,%esp
80104ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
80104eda:	e8 31 ea ff ff       	call   80103910 <myproc>

	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104edf:	8b 00                	mov    (%eax),%eax
80104ee1:	39 d8                	cmp    %ebx,%eax
80104ee3:	76 1b                	jbe    80104f00 <fetchint+0x30>
80104ee5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ee8:	39 d0                	cmp    %edx,%eax
80104eea:	72 14                	jb     80104f00 <fetchint+0x30>
	*ip = *(int *)(addr);
80104eec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eef:	8b 13                	mov    (%ebx),%edx
80104ef1:	89 10                	mov    %edx,(%eax)
	return 0;
80104ef3:	31 c0                	xor    %eax,%eax
}
80104ef5:	83 c4 04             	add    $0x4,%esp
80104ef8:	5b                   	pop    %ebx
80104ef9:	5d                   	pop    %ebp
80104efa:	c3                   	ret    
80104efb:	90                   	nop
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f05:	eb ee                	jmp    80104ef5 <fetchint+0x25>
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	53                   	push   %ebx
80104f14:	83 ec 04             	sub    $0x4,%esp
80104f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *       s, *ep;
	struct proc *curproc = myproc();
80104f1a:	e8 f1 e9 ff ff       	call   80103910 <myproc>

	if (addr >= curproc->sz) return -1;
80104f1f:	39 18                	cmp    %ebx,(%eax)
80104f21:	76 29                	jbe    80104f4c <fetchstr+0x3c>
	*pp = (char *)addr;
80104f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f26:	89 da                	mov    %ebx,%edx
80104f28:	89 19                	mov    %ebx,(%ecx)
	ep  = (char *)curproc->sz;
80104f2a:	8b 00                	mov    (%eax),%eax
	for (s = *pp; s < ep; s++) {
80104f2c:	39 c3                	cmp    %eax,%ebx
80104f2e:	73 1c                	jae    80104f4c <fetchstr+0x3c>
		if (*s == 0) return s - *pp;
80104f30:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f33:	75 10                	jne    80104f45 <fetchstr+0x35>
80104f35:	eb 39                	jmp    80104f70 <fetchstr+0x60>
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f40:	80 3a 00             	cmpb   $0x0,(%edx)
80104f43:	74 1b                	je     80104f60 <fetchstr+0x50>
	for (s = *pp; s < ep; s++) {
80104f45:	83 c2 01             	add    $0x1,%edx
80104f48:	39 d0                	cmp    %edx,%eax
80104f4a:	77 f4                	ja     80104f40 <fetchstr+0x30>
	if (addr >= curproc->sz) return -1;
80104f4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	return -1;
}
80104f51:	83 c4 04             	add    $0x4,%esp
80104f54:	5b                   	pop    %ebx
80104f55:	5d                   	pop    %ebp
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f60:	83 c4 04             	add    $0x4,%esp
80104f63:	89 d0                	mov    %edx,%eax
80104f65:	29 d8                	sub    %ebx,%eax
80104f67:	5b                   	pop    %ebx
80104f68:	5d                   	pop    %ebp
80104f69:	c3                   	ret    
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (*s == 0) return s - *pp;
80104f70:	31 c0                	xor    %eax,%eax
80104f72:	eb dd                	jmp    80104f51 <fetchstr+0x41>
80104f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104f85:	e8 86 e9 ff ff       	call   80103910 <myproc>
80104f8a:	8b 40 18             	mov    0x18(%eax),%eax
80104f8d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f90:	8b 40 44             	mov    0x44(%eax),%eax
80104f93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
	struct proc *curproc = myproc();
80104f96:	e8 75 e9 ff ff       	call   80103910 <myproc>
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104f9b:	8b 00                	mov    (%eax),%eax
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104f9d:	8d 73 04             	lea    0x4(%ebx),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104fa0:	39 c6                	cmp    %eax,%esi
80104fa2:	73 1c                	jae    80104fc0 <argint+0x40>
80104fa4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fa7:	39 d0                	cmp    %edx,%eax
80104fa9:	72 15                	jb     80104fc0 <argint+0x40>
	*ip = *(int *)(addr);
80104fab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fae:	8b 53 04             	mov    0x4(%ebx),%edx
80104fb1:	89 10                	mov    %edx,(%eax)
	return 0;
80104fb3:	31 c0                	xor    %eax,%eax
}
80104fb5:	5b                   	pop    %ebx
80104fb6:	5e                   	pop    %esi
80104fb7:	5d                   	pop    %ebp
80104fb8:	c3                   	ret    
80104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104fc5:	eb ee                	jmp    80104fb5 <argint+0x35>
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	83 ec 10             	sub    $0x10,%esp
80104fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int          i;
	struct proc *curproc = myproc();
80104fdb:	e8 30 e9 ff ff       	call   80103910 <myproc>
80104fe0:	89 c6                	mov    %eax,%esi

	if (argint(n, &i) < 0) return -1;
80104fe2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fe5:	83 ec 08             	sub    $0x8,%esp
80104fe8:	50                   	push   %eax
80104fe9:	ff 75 08             	pushl  0x8(%ebp)
80104fec:	e8 8f ff ff ff       	call   80104f80 <argint>
	if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) return -1;
80104ff1:	83 c4 10             	add    $0x10,%esp
80104ff4:	85 c0                	test   %eax,%eax
80104ff6:	78 28                	js     80105020 <argptr+0x50>
80104ff8:	85 db                	test   %ebx,%ebx
80104ffa:	78 24                	js     80105020 <argptr+0x50>
80104ffc:	8b 16                	mov    (%esi),%edx
80104ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105001:	39 c2                	cmp    %eax,%edx
80105003:	76 1b                	jbe    80105020 <argptr+0x50>
80105005:	01 c3                	add    %eax,%ebx
80105007:	39 da                	cmp    %ebx,%edx
80105009:	72 15                	jb     80105020 <argptr+0x50>
	*pp = (char *)i;
8010500b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010500e:	89 02                	mov    %eax,(%edx)
	return 0;
80105010:	31 c0                	xor    %eax,%eax
}
80105012:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105015:	5b                   	pop    %ebx
80105016:	5e                   	pop    %esi
80105017:	5d                   	pop    %ebp
80105018:	c3                   	ret    
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105025:	eb eb                	jmp    80105012 <argptr+0x42>
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 20             	sub    $0x20,%esp
	int addr;
	if (argint(n, &addr) < 0) return -1;
80105036:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105039:	50                   	push   %eax
8010503a:	ff 75 08             	pushl  0x8(%ebp)
8010503d:	e8 3e ff ff ff       	call   80104f80 <argint>
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	85 c0                	test   %eax,%eax
80105047:	78 17                	js     80105060 <argstr+0x30>
	return fetchstr(addr, pp);
80105049:	83 ec 08             	sub    $0x8,%esp
8010504c:	ff 75 0c             	pushl  0xc(%ebp)
8010504f:	ff 75 f4             	pushl  -0xc(%ebp)
80105052:	e8 b9 fe ff ff       	call   80104f10 <fetchstr>
80105057:	83 c4 10             	add    $0x10,%esp
}
8010505a:	c9                   	leave  
8010505b:	c3                   	ret    
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (argint(n, &addr) < 0) return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105065:	c9                   	leave  
80105066:	c3                   	ret    
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <syscall>:
  [SYS_close] sys_close, [SYS_shmget] sys_shmget, [SYS_shmrem] sys_shmrem,
};

void
syscall(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	53                   	push   %ebx
80105074:	83 ec 04             	sub    $0x4,%esp
	int          num;
	struct proc *curproc = myproc();
80105077:	e8 94 e8 ff ff       	call   80103910 <myproc>
8010507c:	89 c3                	mov    %eax,%ebx

	num = curproc->tf->eax;
8010507e:	8b 40 18             	mov    0x18(%eax),%eax
80105081:	8b 40 1c             	mov    0x1c(%eax),%eax
	if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105084:	8d 50 ff             	lea    -0x1(%eax),%edx
80105087:	83 fa 1f             	cmp    $0x1f,%edx
8010508a:	77 1c                	ja     801050a8 <syscall+0x38>
8010508c:	8b 14 85 40 88 10 80 	mov    -0x7fef77c0(,%eax,4),%edx
80105093:	85 d2                	test   %edx,%edx
80105095:	74 11                	je     801050a8 <syscall+0x38>
		curproc->tf->eax = syscalls[num]();
80105097:	ff d2                	call   *%edx
80105099:	8b 53 18             	mov    0x18(%ebx),%edx
8010509c:	89 42 1c             	mov    %eax,0x1c(%edx)
	} else {
		cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name, num);
		curproc->tf->eax = -1;
	}
}
8010509f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050a2:	c9                   	leave  
801050a3:	c3                   	ret    
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name, num);
801050a8:	50                   	push   %eax
801050a9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801050ac:	50                   	push   %eax
801050ad:	ff 73 10             	pushl  0x10(%ebx)
801050b0:	68 15 88 10 80       	push   $0x80108815
801050b5:	e8 a6 b5 ff ff       	call   80100660 <cprintf>
		curproc->tf->eax = -1;
801050ba:	8b 43 18             	mov    0x18(%ebx),%eax
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801050c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050ca:	c9                   	leave  
801050cb:	c3                   	ret    
801050cc:	66 90                	xchg   %ax,%ax
801050ce:	66 90                	xchg   %ax,%ax

801050d0 <create>:
	return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
801050d5:	53                   	push   %ebx
	uint          off;
	struct inode *ip, *dp;
	char          name[DIRSIZ];

	if ((dp = nameiparent(path, name)) == 0) return 0;
801050d6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801050d9:	83 ec 44             	sub    $0x44,%esp
801050dc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801050df:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if ((dp = nameiparent(path, name)) == 0) return 0;
801050e2:	56                   	push   %esi
801050e3:	50                   	push   %eax
{
801050e4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801050e7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
	if ((dp = nameiparent(path, name)) == 0) return 0;
801050ea:	e8 51 ce ff ff       	call   80101f40 <nameiparent>
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	85 c0                	test   %eax,%eax
801050f4:	0f 84 46 01 00 00    	je     80105240 <create+0x170>
	ilock(dp);
801050fa:	83 ec 0c             	sub    $0xc,%esp
801050fd:	89 c3                	mov    %eax,%ebx
801050ff:	50                   	push   %eax
80105100:	e8 bb c5 ff ff       	call   801016c0 <ilock>

	if ((ip = dirlookup(dp, name, &off)) != 0) {
80105105:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105108:	83 c4 0c             	add    $0xc,%esp
8010510b:	50                   	push   %eax
8010510c:	56                   	push   %esi
8010510d:	53                   	push   %ebx
8010510e:	e8 dd ca ff ff       	call   80101bf0 <dirlookup>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	89 c7                	mov    %eax,%edi
8010511a:	74 34                	je     80105150 <create+0x80>
		iunlockput(dp);
8010511c:	83 ec 0c             	sub    $0xc,%esp
8010511f:	53                   	push   %ebx
80105120:	e8 2b c8 ff ff       	call   80101950 <iunlockput>
		ilock(ip);
80105125:	89 3c 24             	mov    %edi,(%esp)
80105128:	e8 93 c5 ff ff       	call   801016c0 <ilock>
		if (type == T_FILE && ip->type == T_FILE) return ip;
8010512d:	83 c4 10             	add    $0x10,%esp
80105130:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80105135:	0f 85 95 00 00 00    	jne    801051d0 <create+0x100>
8010513b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105140:	0f 85 8a 00 00 00    	jne    801051d0 <create+0x100>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
80105146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105149:	89 f8                	mov    %edi,%eax
8010514b:	5b                   	pop    %ebx
8010514c:	5e                   	pop    %esi
8010514d:	5f                   	pop    %edi
8010514e:	5d                   	pop    %ebp
8010514f:	c3                   	ret    
	if ((ip = ialloc(dp->dev, type)) == 0) panic("create: ialloc");
80105150:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105154:	83 ec 08             	sub    $0x8,%esp
80105157:	50                   	push   %eax
80105158:	ff 33                	pushl  (%ebx)
8010515a:	e8 f1 c3 ff ff       	call   80101550 <ialloc>
8010515f:	83 c4 10             	add    $0x10,%esp
80105162:	85 c0                	test   %eax,%eax
80105164:	89 c7                	mov    %eax,%edi
80105166:	0f 84 e8 00 00 00    	je     80105254 <create+0x184>
	ilock(ip);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	50                   	push   %eax
80105170:	e8 4b c5 ff ff       	call   801016c0 <ilock>
	ip->major = major;
80105175:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105179:	66 89 47 52          	mov    %ax,0x52(%edi)
	ip->minor = minor;
8010517d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105181:	66 89 47 54          	mov    %ax,0x54(%edi)
	ip->nlink = 1;
80105185:	b8 01 00 00 00       	mov    $0x1,%eax
8010518a:	66 89 47 56          	mov    %ax,0x56(%edi)
	iupdate(ip);
8010518e:	89 3c 24             	mov    %edi,(%esp)
80105191:	e8 7a c4 ff ff       	call   80101610 <iupdate>
	if (type == T_DIR) { // Create . and .. entries.
80105196:	83 c4 10             	add    $0x10,%esp
80105199:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010519e:	74 50                	je     801051f0 <create+0x120>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");
801051a0:	83 ec 04             	sub    $0x4,%esp
801051a3:	ff 77 04             	pushl  0x4(%edi)
801051a6:	56                   	push   %esi
801051a7:	53                   	push   %ebx
801051a8:	e8 b3 cc ff ff       	call   80101e60 <dirlink>
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	85 c0                	test   %eax,%eax
801051b2:	0f 88 8f 00 00 00    	js     80105247 <create+0x177>
	iunlockput(dp);
801051b8:	83 ec 0c             	sub    $0xc,%esp
801051bb:	53                   	push   %ebx
801051bc:	e8 8f c7 ff ff       	call   80101950 <iunlockput>
	return ip;
801051c1:	83 c4 10             	add    $0x10,%esp
}
801051c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051c7:	89 f8                	mov    %edi,%eax
801051c9:	5b                   	pop    %ebx
801051ca:	5e                   	pop    %esi
801051cb:	5f                   	pop    %edi
801051cc:	5d                   	pop    %ebp
801051cd:	c3                   	ret    
801051ce:	66 90                	xchg   %ax,%ax
		iunlockput(ip);
801051d0:	83 ec 0c             	sub    $0xc,%esp
801051d3:	57                   	push   %edi
		return 0;
801051d4:	31 ff                	xor    %edi,%edi
		iunlockput(ip);
801051d6:	e8 75 c7 ff ff       	call   80101950 <iunlockput>
		return 0;
801051db:	83 c4 10             	add    $0x10,%esp
}
801051de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051e1:	89 f8                	mov    %edi,%eax
801051e3:	5b                   	pop    %ebx
801051e4:	5e                   	pop    %esi
801051e5:	5f                   	pop    %edi
801051e6:	5d                   	pop    %ebp
801051e7:	c3                   	ret    
801051e8:	90                   	nop
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		dp->nlink++; // for ".."
801051f0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
		iupdate(dp);
801051f5:	83 ec 0c             	sub    $0xc,%esp
801051f8:	53                   	push   %ebx
801051f9:	e8 12 c4 ff ff       	call   80101610 <iupdate>
		if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0) panic("create dots");
801051fe:	83 c4 0c             	add    $0xc,%esp
80105201:	ff 77 04             	pushl  0x4(%edi)
80105204:	68 e0 88 10 80       	push   $0x801088e0
80105209:	57                   	push   %edi
8010520a:	e8 51 cc ff ff       	call   80101e60 <dirlink>
8010520f:	83 c4 10             	add    $0x10,%esp
80105212:	85 c0                	test   %eax,%eax
80105214:	78 1c                	js     80105232 <create+0x162>
80105216:	83 ec 04             	sub    $0x4,%esp
80105219:	ff 73 04             	pushl  0x4(%ebx)
8010521c:	68 df 88 10 80       	push   $0x801088df
80105221:	57                   	push   %edi
80105222:	e8 39 cc ff ff       	call   80101e60 <dirlink>
80105227:	83 c4 10             	add    $0x10,%esp
8010522a:	85 c0                	test   %eax,%eax
8010522c:	0f 89 6e ff ff ff    	jns    801051a0 <create+0xd0>
80105232:	83 ec 0c             	sub    $0xc,%esp
80105235:	68 d3 88 10 80       	push   $0x801088d3
8010523a:	e8 51 b1 ff ff       	call   80100390 <panic>
8010523f:	90                   	nop
	if ((dp = nameiparent(path, name)) == 0) return 0;
80105240:	31 ff                	xor    %edi,%edi
80105242:	e9 ff fe ff ff       	jmp    80105146 <create+0x76>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");
80105247:	83 ec 0c             	sub    $0xc,%esp
8010524a:	68 e2 88 10 80       	push   $0x801088e2
8010524f:	e8 3c b1 ff ff       	call   80100390 <panic>
	if ((ip = ialloc(dp->dev, type)) == 0) panic("create: ialloc");
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	68 c4 88 10 80       	push   $0x801088c4
8010525c:	e8 2f b1 ff ff       	call   80100390 <panic>
80105261:	eb 0d                	jmp    80105270 <argfd.constprop.0>
80105263:	90                   	nop
80105264:	90                   	nop
80105265:	90                   	nop
80105266:	90                   	nop
80105267:	90                   	nop
80105268:	90                   	nop
80105269:	90                   	nop
8010526a:	90                   	nop
8010526b:	90                   	nop
8010526c:	90                   	nop
8010526d:	90                   	nop
8010526e:	90                   	nop
8010526f:	90                   	nop

80105270 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	89 c3                	mov    %eax,%ebx
	if (argint(n, &fd) < 0) return -1;
80105277:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010527a:	89 d6                	mov    %edx,%esi
8010527c:	83 ec 18             	sub    $0x18,%esp
	if (argint(n, &fd) < 0) return -1;
8010527f:	50                   	push   %eax
80105280:	6a 00                	push   $0x0
80105282:	e8 f9 fc ff ff       	call   80104f80 <argint>
80105287:	83 c4 10             	add    $0x10,%esp
8010528a:	85 c0                	test   %eax,%eax
8010528c:	78 2a                	js     801052b8 <argfd.constprop.0+0x48>
	if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
8010528e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105292:	77 24                	ja     801052b8 <argfd.constprop.0+0x48>
80105294:	e8 77 e6 ff ff       	call   80103910 <myproc>
80105299:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010529c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801052a0:	85 c0                	test   %eax,%eax
801052a2:	74 14                	je     801052b8 <argfd.constprop.0+0x48>
	if (pfd) *pfd = fd;
801052a4:	85 db                	test   %ebx,%ebx
801052a6:	74 02                	je     801052aa <argfd.constprop.0+0x3a>
801052a8:	89 13                	mov    %edx,(%ebx)
	if (pf) *pf = f;
801052aa:	89 06                	mov    %eax,(%esi)
	return 0;
801052ac:	31 c0                	xor    %eax,%eax
}
801052ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052b1:	5b                   	pop    %ebx
801052b2:	5e                   	pop    %esi
801052b3:	5d                   	pop    %ebp
801052b4:	c3                   	ret    
801052b5:	8d 76 00             	lea    0x0(%esi),%esi
	if (argint(n, &fd) < 0) return -1;
801052b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052bd:	eb ef                	jmp    801052ae <argfd.constprop.0+0x3e>
801052bf:	90                   	nop

801052c0 <sys_dup>:
{
801052c0:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0) return -1;
801052c1:	31 c0                	xor    %eax,%eax
{
801052c3:	89 e5                	mov    %esp,%ebp
801052c5:	56                   	push   %esi
801052c6:	53                   	push   %ebx
	if (argfd(0, 0, &f) < 0) return -1;
801052c7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801052ca:	83 ec 10             	sub    $0x10,%esp
	if (argfd(0, 0, &f) < 0) return -1;
801052cd:	e8 9e ff ff ff       	call   80105270 <argfd.constprop.0>
801052d2:	85 c0                	test   %eax,%eax
801052d4:	78 42                	js     80105318 <sys_dup+0x58>
	if ((fd = fdalloc(f)) < 0) return -1;
801052d6:	8b 75 f4             	mov    -0xc(%ebp),%esi
	for (fd = 0; fd < NOFILE; fd++) {
801052d9:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
801052db:	e8 30 e6 ff ff       	call   80103910 <myproc>
801052e0:	eb 0e                	jmp    801052f0 <sys_dup+0x30>
801052e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (fd = 0; fd < NOFILE; fd++) {
801052e8:	83 c3 01             	add    $0x1,%ebx
801052eb:	83 fb 10             	cmp    $0x10,%ebx
801052ee:	74 28                	je     80105318 <sys_dup+0x58>
		if (curproc->ofile[fd] == 0) {
801052f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052f4:	85 d2                	test   %edx,%edx
801052f6:	75 f0                	jne    801052e8 <sys_dup+0x28>
			curproc->ofile[fd] = f;
801052f8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
	filedup(f);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105302:	e8 19 bb ff ff       	call   80100e20 <filedup>
	return fd;
80105307:	83 c4 10             	add    $0x10,%esp
}
8010530a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010530d:	89 d8                	mov    %ebx,%eax
8010530f:	5b                   	pop    %ebx
80105310:	5e                   	pop    %esi
80105311:	5d                   	pop    %ebp
80105312:	c3                   	ret    
80105313:	90                   	nop
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105318:	8d 65 f8             	lea    -0x8(%ebp),%esp
	if (argfd(0, 0, &f) < 0) return -1;
8010531b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105320:	89 d8                	mov    %ebx,%eax
80105322:	5b                   	pop    %ebx
80105323:	5e                   	pop    %esi
80105324:	5d                   	pop    %ebp
80105325:	c3                   	ret    
80105326:	8d 76 00             	lea    0x0(%esi),%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_read>:
{
80105330:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80105331:	31 c0                	xor    %eax,%eax
{
80105333:	89 e5                	mov    %esp,%ebp
80105335:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80105338:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010533b:	e8 30 ff ff ff       	call   80105270 <argfd.constprop.0>
80105340:	85 c0                	test   %eax,%eax
80105342:	78 4c                	js     80105390 <sys_read+0x60>
80105344:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105347:	83 ec 08             	sub    $0x8,%esp
8010534a:	50                   	push   %eax
8010534b:	6a 02                	push   $0x2
8010534d:	e8 2e fc ff ff       	call   80104f80 <argint>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	85 c0                	test   %eax,%eax
80105357:	78 37                	js     80105390 <sys_read+0x60>
80105359:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535c:	83 ec 04             	sub    $0x4,%esp
8010535f:	ff 75 f0             	pushl  -0x10(%ebp)
80105362:	50                   	push   %eax
80105363:	6a 01                	push   $0x1
80105365:	e8 66 fc ff ff       	call   80104fd0 <argptr>
8010536a:	83 c4 10             	add    $0x10,%esp
8010536d:	85 c0                	test   %eax,%eax
8010536f:	78 1f                	js     80105390 <sys_read+0x60>
	return fileread(f, p, n);
80105371:	83 ec 04             	sub    $0x4,%esp
80105374:	ff 75 f0             	pushl  -0x10(%ebp)
80105377:	ff 75 f4             	pushl  -0xc(%ebp)
8010537a:	ff 75 ec             	pushl  -0x14(%ebp)
8010537d:	e8 0e bc ff ff       	call   80100f90 <fileread>
80105382:	83 c4 10             	add    $0x10,%esp
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80105390:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053a0 <sys_write>:
{
801053a0:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
801053a1:	31 c0                	xor    %eax,%eax
{
801053a3:	89 e5                	mov    %esp,%ebp
801053a5:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
801053a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053ab:	e8 c0 fe ff ff       	call   80105270 <argfd.constprop.0>
801053b0:	85 c0                	test   %eax,%eax
801053b2:	78 4c                	js     80105400 <sys_write+0x60>
801053b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053b7:	83 ec 08             	sub    $0x8,%esp
801053ba:	50                   	push   %eax
801053bb:	6a 02                	push   $0x2
801053bd:	e8 be fb ff ff       	call   80104f80 <argint>
801053c2:	83 c4 10             	add    $0x10,%esp
801053c5:	85 c0                	test   %eax,%eax
801053c7:	78 37                	js     80105400 <sys_write+0x60>
801053c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053cc:	83 ec 04             	sub    $0x4,%esp
801053cf:	ff 75 f0             	pushl  -0x10(%ebp)
801053d2:	50                   	push   %eax
801053d3:	6a 01                	push   $0x1
801053d5:	e8 f6 fb ff ff       	call   80104fd0 <argptr>
801053da:	83 c4 10             	add    $0x10,%esp
801053dd:	85 c0                	test   %eax,%eax
801053df:	78 1f                	js     80105400 <sys_write+0x60>
	return filewrite(f, p, n);
801053e1:	83 ec 04             	sub    $0x4,%esp
801053e4:	ff 75 f0             	pushl  -0x10(%ebp)
801053e7:	ff 75 f4             	pushl  -0xc(%ebp)
801053ea:	ff 75 ec             	pushl  -0x14(%ebp)
801053ed:	e8 2e bc ff ff       	call   80101020 <filewrite>
801053f2:	83 c4 10             	add    $0x10,%esp
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    
801053f7:	89 f6                	mov    %esi,%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80105400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_close>:
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, &fd, &f) < 0) return -1;
80105416:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105419:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010541c:	e8 4f fe ff ff       	call   80105270 <argfd.constprop.0>
80105421:	85 c0                	test   %eax,%eax
80105423:	78 2b                	js     80105450 <sys_close+0x40>
	myproc()->ofile[fd] = 0;
80105425:	e8 e6 e4 ff ff       	call   80103910 <myproc>
8010542a:	8b 55 f0             	mov    -0x10(%ebp),%edx
	fileclose(f);
8010542d:	83 ec 0c             	sub    $0xc,%esp
	myproc()->ofile[fd] = 0;
80105430:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105437:	00 
	fileclose(f);
80105438:	ff 75 f4             	pushl  -0xc(%ebp)
8010543b:	e8 30 ba ff ff       	call   80100e70 <fileclose>
	return 0;
80105440:	83 c4 10             	add    $0x10,%esp
80105443:	31 c0                	xor    %eax,%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, &fd, &f) < 0) return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105460 <sys_fstat>:
{
80105460:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80105461:	31 c0                	xor    %eax,%eax
{
80105463:	89 e5                	mov    %esp,%ebp
80105465:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80105468:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010546b:	e8 00 fe ff ff       	call   80105270 <argfd.constprop.0>
80105470:	85 c0                	test   %eax,%eax
80105472:	78 2c                	js     801054a0 <sys_fstat+0x40>
80105474:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105477:	83 ec 04             	sub    $0x4,%esp
8010547a:	6a 14                	push   $0x14
8010547c:	50                   	push   %eax
8010547d:	6a 01                	push   $0x1
8010547f:	e8 4c fb ff ff       	call   80104fd0 <argptr>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	78 15                	js     801054a0 <sys_fstat+0x40>
	return filestat(f, st);
8010548b:	83 ec 08             	sub    $0x8,%esp
8010548e:	ff 75 f4             	pushl  -0xc(%ebp)
80105491:	ff 75 f0             	pushl  -0x10(%ebp)
80105494:	e8 a7 ba ff ff       	call   80100f40 <filestat>
80105499:	83 c4 10             	add    $0x10,%esp
}
8010549c:	c9                   	leave  
8010549d:	c3                   	ret    
8010549e:	66 90                	xchg   %ax,%ax
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_link>:
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	57                   	push   %edi
801054b4:	56                   	push   %esi
801054b5:	53                   	push   %ebx
	if (argstr(0, &old) < 0 || argstr(1, &new) < 0) return -1;
801054b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801054b9:	83 ec 34             	sub    $0x34,%esp
	if (argstr(0, &old) < 0 || argstr(1, &new) < 0) return -1;
801054bc:	50                   	push   %eax
801054bd:	6a 00                	push   $0x0
801054bf:	e8 6c fb ff ff       	call   80105030 <argstr>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	0f 88 fb 00 00 00    	js     801055ca <sys_link+0x11a>
801054cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801054d2:	83 ec 08             	sub    $0x8,%esp
801054d5:	50                   	push   %eax
801054d6:	6a 01                	push   $0x1
801054d8:	e8 53 fb ff ff       	call   80105030 <argstr>
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	85 c0                	test   %eax,%eax
801054e2:	0f 88 e2 00 00 00    	js     801055ca <sys_link+0x11a>
	begin_op();
801054e8:	e8 f3 d6 ff ff       	call   80102be0 <begin_op>
	if ((ip = namei(old)) == 0) {
801054ed:	83 ec 0c             	sub    $0xc,%esp
801054f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801054f3:	e8 28 ca ff ff       	call   80101f20 <namei>
801054f8:	83 c4 10             	add    $0x10,%esp
801054fb:	85 c0                	test   %eax,%eax
801054fd:	89 c3                	mov    %eax,%ebx
801054ff:	0f 84 ea 00 00 00    	je     801055ef <sys_link+0x13f>
	ilock(ip);
80105505:	83 ec 0c             	sub    $0xc,%esp
80105508:	50                   	push   %eax
80105509:	e8 b2 c1 ff ff       	call   801016c0 <ilock>
	if (ip->type == T_DIR) {
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105516:	0f 84 bb 00 00 00    	je     801055d7 <sys_link+0x127>
	ip->nlink++;
8010551c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
	iupdate(ip);
80105521:	83 ec 0c             	sub    $0xc,%esp
	if ((dp = nameiparent(new, name)) == 0) goto bad;
80105524:	8d 7d da             	lea    -0x26(%ebp),%edi
	iupdate(ip);
80105527:	53                   	push   %ebx
80105528:	e8 e3 c0 ff ff       	call   80101610 <iupdate>
	iunlock(ip);
8010552d:	89 1c 24             	mov    %ebx,(%esp)
80105530:	e8 6b c2 ff ff       	call   801017a0 <iunlock>
	if ((dp = nameiparent(new, name)) == 0) goto bad;
80105535:	58                   	pop    %eax
80105536:	5a                   	pop    %edx
80105537:	57                   	push   %edi
80105538:	ff 75 d0             	pushl  -0x30(%ebp)
8010553b:	e8 00 ca ff ff       	call   80101f40 <nameiparent>
80105540:	83 c4 10             	add    $0x10,%esp
80105543:	85 c0                	test   %eax,%eax
80105545:	89 c6                	mov    %eax,%esi
80105547:	74 5b                	je     801055a4 <sys_link+0xf4>
	ilock(dp);
80105549:	83 ec 0c             	sub    $0xc,%esp
8010554c:	50                   	push   %eax
8010554d:	e8 6e c1 ff ff       	call   801016c0 <ilock>
	if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	8b 03                	mov    (%ebx),%eax
80105557:	39 06                	cmp    %eax,(%esi)
80105559:	75 3d                	jne    80105598 <sys_link+0xe8>
8010555b:	83 ec 04             	sub    $0x4,%esp
8010555e:	ff 73 04             	pushl  0x4(%ebx)
80105561:	57                   	push   %edi
80105562:	56                   	push   %esi
80105563:	e8 f8 c8 ff ff       	call   80101e60 <dirlink>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	85 c0                	test   %eax,%eax
8010556d:	78 29                	js     80105598 <sys_link+0xe8>
	iunlockput(dp);
8010556f:	83 ec 0c             	sub    $0xc,%esp
80105572:	56                   	push   %esi
80105573:	e8 d8 c3 ff ff       	call   80101950 <iunlockput>
	iput(ip);
80105578:	89 1c 24             	mov    %ebx,(%esp)
8010557b:	e8 70 c2 ff ff       	call   801017f0 <iput>
	end_op();
80105580:	e8 cb d6 ff ff       	call   80102c50 <end_op>
	return 0;
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	31 c0                	xor    %eax,%eax
}
8010558a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010558d:	5b                   	pop    %ebx
8010558e:	5e                   	pop    %esi
8010558f:	5f                   	pop    %edi
80105590:	5d                   	pop    %ebp
80105591:	c3                   	ret    
80105592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		iunlockput(dp);
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	56                   	push   %esi
8010559c:	e8 af c3 ff ff       	call   80101950 <iunlockput>
		goto bad;
801055a1:	83 c4 10             	add    $0x10,%esp
	ilock(ip);
801055a4:	83 ec 0c             	sub    $0xc,%esp
801055a7:	53                   	push   %ebx
801055a8:	e8 13 c1 ff ff       	call   801016c0 <ilock>
	ip->nlink--;
801055ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
801055b2:	89 1c 24             	mov    %ebx,(%esp)
801055b5:	e8 56 c0 ff ff       	call   80101610 <iupdate>
	iunlockput(ip);
801055ba:	89 1c 24             	mov    %ebx,(%esp)
801055bd:	e8 8e c3 ff ff       	call   80101950 <iunlockput>
	end_op();
801055c2:	e8 89 d6 ff ff       	call   80102c50 <end_op>
	return -1;
801055c7:	83 c4 10             	add    $0x10,%esp
}
801055ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
801055cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d2:	5b                   	pop    %ebx
801055d3:	5e                   	pop    %esi
801055d4:	5f                   	pop    %edi
801055d5:	5d                   	pop    %ebp
801055d6:	c3                   	ret    
		iunlockput(ip);
801055d7:	83 ec 0c             	sub    $0xc,%esp
801055da:	53                   	push   %ebx
801055db:	e8 70 c3 ff ff       	call   80101950 <iunlockput>
		end_op();
801055e0:	e8 6b d6 ff ff       	call   80102c50 <end_op>
		return -1;
801055e5:	83 c4 10             	add    $0x10,%esp
801055e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ed:	eb 9b                	jmp    8010558a <sys_link+0xda>
		end_op();
801055ef:	e8 5c d6 ff ff       	call   80102c50 <end_op>
		return -1;
801055f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f9:	eb 8f                	jmp    8010558a <sys_link+0xda>
801055fb:	90                   	nop
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_unlink>:
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	57                   	push   %edi
80105604:	56                   	push   %esi
80105605:	53                   	push   %ebx
	if (argstr(0, &path) < 0) return -1;
80105606:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105609:	83 ec 44             	sub    $0x44,%esp
	if (argstr(0, &path) < 0) return -1;
8010560c:	50                   	push   %eax
8010560d:	6a 00                	push   $0x0
8010560f:	e8 1c fa ff ff       	call   80105030 <argstr>
80105614:	83 c4 10             	add    $0x10,%esp
80105617:	85 c0                	test   %eax,%eax
80105619:	0f 88 77 01 00 00    	js     80105796 <sys_unlink+0x196>
	if ((dp = nameiparent(path, name)) == 0) {
8010561f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
	begin_op();
80105622:	e8 b9 d5 ff ff       	call   80102be0 <begin_op>
	if ((dp = nameiparent(path, name)) == 0) {
80105627:	83 ec 08             	sub    $0x8,%esp
8010562a:	53                   	push   %ebx
8010562b:	ff 75 c0             	pushl  -0x40(%ebp)
8010562e:	e8 0d c9 ff ff       	call   80101f40 <nameiparent>
80105633:	83 c4 10             	add    $0x10,%esp
80105636:	85 c0                	test   %eax,%eax
80105638:	89 c6                	mov    %eax,%esi
8010563a:	0f 84 60 01 00 00    	je     801057a0 <sys_unlink+0x1a0>
	ilock(dp);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	50                   	push   %eax
80105644:	e8 77 c0 ff ff       	call   801016c0 <ilock>
	if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
80105649:	58                   	pop    %eax
8010564a:	5a                   	pop    %edx
8010564b:	68 e0 88 10 80       	push   $0x801088e0
80105650:	53                   	push   %ebx
80105651:	e8 7a c5 ff ff       	call   80101bd0 <namecmp>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	0f 84 03 01 00 00    	je     80105764 <sys_unlink+0x164>
80105661:	83 ec 08             	sub    $0x8,%esp
80105664:	68 df 88 10 80       	push   $0x801088df
80105669:	53                   	push   %ebx
8010566a:	e8 61 c5 ff ff       	call   80101bd0 <namecmp>
8010566f:	83 c4 10             	add    $0x10,%esp
80105672:	85 c0                	test   %eax,%eax
80105674:	0f 84 ea 00 00 00    	je     80105764 <sys_unlink+0x164>
	if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
8010567a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010567d:	83 ec 04             	sub    $0x4,%esp
80105680:	50                   	push   %eax
80105681:	53                   	push   %ebx
80105682:	56                   	push   %esi
80105683:	e8 68 c5 ff ff       	call   80101bf0 <dirlookup>
80105688:	83 c4 10             	add    $0x10,%esp
8010568b:	85 c0                	test   %eax,%eax
8010568d:	89 c3                	mov    %eax,%ebx
8010568f:	0f 84 cf 00 00 00    	je     80105764 <sys_unlink+0x164>
	ilock(ip);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	50                   	push   %eax
80105699:	e8 22 c0 ff ff       	call   801016c0 <ilock>
	if (ip->nlink < 1) panic("unlink: nlink < 1");
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801056a6:	0f 8e 10 01 00 00    	jle    801057bc <sys_unlink+0x1bc>
	if (ip->type == T_DIR && !isdirempty(ip)) {
801056ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056b1:	74 6d                	je     80105720 <sys_unlink+0x120>
	memset(&de, 0, sizeof(de));
801056b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056b6:	83 ec 04             	sub    $0x4,%esp
801056b9:	6a 10                	push   $0x10
801056bb:	6a 00                	push   $0x0
801056bd:	50                   	push   %eax
801056be:	e8 bd f5 ff ff       	call   80104c80 <memset>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("unlink: writei");
801056c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056c6:	6a 10                	push   $0x10
801056c8:	ff 75 c4             	pushl  -0x3c(%ebp)
801056cb:	50                   	push   %eax
801056cc:	56                   	push   %esi
801056cd:	e8 ce c3 ff ff       	call   80101aa0 <writei>
801056d2:	83 c4 20             	add    $0x20,%esp
801056d5:	83 f8 10             	cmp    $0x10,%eax
801056d8:	0f 85 eb 00 00 00    	jne    801057c9 <sys_unlink+0x1c9>
	if (ip->type == T_DIR) {
801056de:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056e3:	0f 84 97 00 00 00    	je     80105780 <sys_unlink+0x180>
	iunlockput(dp);
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	56                   	push   %esi
801056ed:	e8 5e c2 ff ff       	call   80101950 <iunlockput>
	ip->nlink--;
801056f2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
801056f7:	89 1c 24             	mov    %ebx,(%esp)
801056fa:	e8 11 bf ff ff       	call   80101610 <iupdate>
	iunlockput(ip);
801056ff:	89 1c 24             	mov    %ebx,(%esp)
80105702:	e8 49 c2 ff ff       	call   80101950 <iunlockput>
	end_op();
80105707:	e8 44 d5 ff ff       	call   80102c50 <end_op>
	return 0;
8010570c:	83 c4 10             	add    $0x10,%esp
8010570f:	31 c0                	xor    %eax,%eax
}
80105711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105714:	5b                   	pop    %ebx
80105715:	5e                   	pop    %esi
80105716:	5f                   	pop    %edi
80105717:	5d                   	pop    %ebp
80105718:	c3                   	ret    
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
80105720:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105724:	76 8d                	jbe    801056b3 <sys_unlink+0xb3>
80105726:	bf 20 00 00 00       	mov    $0x20,%edi
8010572b:	eb 0f                	jmp    8010573c <sys_unlink+0x13c>
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
80105730:	83 c7 10             	add    $0x10,%edi
80105733:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105736:	0f 83 77 ff ff ff    	jae    801056b3 <sys_unlink+0xb3>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("isdirempty: readi");
8010573c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010573f:	6a 10                	push   $0x10
80105741:	57                   	push   %edi
80105742:	50                   	push   %eax
80105743:	53                   	push   %ebx
80105744:	e8 57 c2 ff ff       	call   801019a0 <readi>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	83 f8 10             	cmp    $0x10,%eax
8010574f:	75 5e                	jne    801057af <sys_unlink+0x1af>
		if (de.inum != 0) return 0;
80105751:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105756:	74 d8                	je     80105730 <sys_unlink+0x130>
		iunlockput(ip);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	53                   	push   %ebx
8010575c:	e8 ef c1 ff ff       	call   80101950 <iunlockput>
		goto bad;
80105761:	83 c4 10             	add    $0x10,%esp
	iunlockput(dp);
80105764:	83 ec 0c             	sub    $0xc,%esp
80105767:	56                   	push   %esi
80105768:	e8 e3 c1 ff ff       	call   80101950 <iunlockput>
	end_op();
8010576d:	e8 de d4 ff ff       	call   80102c50 <end_op>
	return -1;
80105772:	83 c4 10             	add    $0x10,%esp
80105775:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577a:	eb 95                	jmp    80105711 <sys_unlink+0x111>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		dp->nlink--;
80105780:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
		iupdate(dp);
80105785:	83 ec 0c             	sub    $0xc,%esp
80105788:	56                   	push   %esi
80105789:	e8 82 be ff ff       	call   80101610 <iupdate>
8010578e:	83 c4 10             	add    $0x10,%esp
80105791:	e9 53 ff ff ff       	jmp    801056e9 <sys_unlink+0xe9>
	if (argstr(0, &path) < 0) return -1;
80105796:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579b:	e9 71 ff ff ff       	jmp    80105711 <sys_unlink+0x111>
		end_op();
801057a0:	e8 ab d4 ff ff       	call   80102c50 <end_op>
		return -1;
801057a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057aa:	e9 62 ff ff ff       	jmp    80105711 <sys_unlink+0x111>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("isdirempty: readi");
801057af:	83 ec 0c             	sub    $0xc,%esp
801057b2:	68 04 89 10 80       	push   $0x80108904
801057b7:	e8 d4 ab ff ff       	call   80100390 <panic>
	if (ip->nlink < 1) panic("unlink: nlink < 1");
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	68 f2 88 10 80       	push   $0x801088f2
801057c4:	e8 c7 ab ff ff       	call   80100390 <panic>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("unlink: writei");
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	68 16 89 10 80       	push   $0x80108916
801057d1:	e8 ba ab ff ff       	call   80100390 <panic>
801057d6:	8d 76 00             	lea    0x0(%esi),%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057e0 <sys_open>:

int
sys_open(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	57                   	push   %edi
801057e4:	56                   	push   %esi
801057e5:	53                   	push   %ebx
	char *        path;
	int           fd, omode;
	struct file * f;
	struct inode *ip;

	if (argstr(0, &path) < 0 || argint(1, &omode) < 0) return -1;
801057e6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801057e9:	83 ec 24             	sub    $0x24,%esp
	if (argstr(0, &path) < 0 || argint(1, &omode) < 0) return -1;
801057ec:	50                   	push   %eax
801057ed:	6a 00                	push   $0x0
801057ef:	e8 3c f8 ff ff       	call   80105030 <argstr>
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	85 c0                	test   %eax,%eax
801057f9:	0f 88 1d 01 00 00    	js     8010591c <sys_open+0x13c>
801057ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105802:	83 ec 08             	sub    $0x8,%esp
80105805:	50                   	push   %eax
80105806:	6a 01                	push   $0x1
80105808:	e8 73 f7 ff ff       	call   80104f80 <argint>
8010580d:	83 c4 10             	add    $0x10,%esp
80105810:	85 c0                	test   %eax,%eax
80105812:	0f 88 04 01 00 00    	js     8010591c <sys_open+0x13c>

	begin_op();
80105818:	e8 c3 d3 ff ff       	call   80102be0 <begin_op>

	if (omode & O_CREATE) {
8010581d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105821:	0f 85 a9 00 00 00    	jne    801058d0 <sys_open+0xf0>
		if (ip == 0) {
			end_op();
			return -1;
		}
	} else {
		if ((ip = namei(path)) == 0) {
80105827:	83 ec 0c             	sub    $0xc,%esp
8010582a:	ff 75 e0             	pushl  -0x20(%ebp)
8010582d:	e8 ee c6 ff ff       	call   80101f20 <namei>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	89 c6                	mov    %eax,%esi
80105839:	0f 84 b2 00 00 00    	je     801058f1 <sys_open+0x111>
			end_op();
			return -1;
		}
		ilock(ip);
8010583f:	83 ec 0c             	sub    $0xc,%esp
80105842:	50                   	push   %eax
80105843:	e8 78 be ff ff       	call   801016c0 <ilock>
		if (ip->type == T_DIR && omode != O_RDONLY) {
80105848:	83 c4 10             	add    $0x10,%esp
8010584b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105850:	0f 84 aa 00 00 00    	je     80105900 <sys_open+0x120>
			end_op();
			return -1;
		}
	}

	if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
80105856:	e8 55 b5 ff ff       	call   80100db0 <filealloc>
8010585b:	85 c0                	test   %eax,%eax
8010585d:	89 c7                	mov    %eax,%edi
8010585f:	0f 84 a6 00 00 00    	je     8010590b <sys_open+0x12b>
	struct proc *curproc = myproc();
80105865:	e8 a6 e0 ff ff       	call   80103910 <myproc>
	for (fd = 0; fd < NOFILE; fd++) {
8010586a:	31 db                	xor    %ebx,%ebx
8010586c:	eb 0e                	jmp    8010587c <sys_open+0x9c>
8010586e:	66 90                	xchg   %ax,%ax
80105870:	83 c3 01             	add    $0x1,%ebx
80105873:	83 fb 10             	cmp    $0x10,%ebx
80105876:	0f 84 ac 00 00 00    	je     80105928 <sys_open+0x148>
		if (curproc->ofile[fd] == 0) {
8010587c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105880:	85 d2                	test   %edx,%edx
80105882:	75 ec                	jne    80105870 <sys_open+0x90>
		if (f) fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
80105884:	83 ec 0c             	sub    $0xc,%esp
			curproc->ofile[fd] = f;
80105887:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
	iunlock(ip);
8010588b:	56                   	push   %esi
8010588c:	e8 0f bf ff ff       	call   801017a0 <iunlock>
	end_op();
80105891:	e8 ba d3 ff ff       	call   80102c50 <end_op>

	f->type     = FD_INODE;
80105896:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
	f->ip       = ip;
	f->off      = 0;
	f->readable = !(omode & O_WRONLY);
8010589c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010589f:	83 c4 10             	add    $0x10,%esp
	f->ip       = ip;
801058a2:	89 77 10             	mov    %esi,0x10(%edi)
	f->off      = 0;
801058a5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
	f->readable = !(omode & O_WRONLY);
801058ac:	89 d0                	mov    %edx,%eax
801058ae:	f7 d0                	not    %eax
801058b0:	83 e0 01             	and    $0x1,%eax
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058b3:	83 e2 03             	and    $0x3,%edx
	f->readable = !(omode & O_WRONLY);
801058b6:	88 47 08             	mov    %al,0x8(%edi)
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801058b9:	0f 95 47 09          	setne  0x9(%edi)
	return fd;
}
801058bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c0:	89 d8                	mov    %ebx,%eax
801058c2:	5b                   	pop    %ebx
801058c3:	5e                   	pop    %esi
801058c4:	5f                   	pop    %edi
801058c5:	5d                   	pop    %ebp
801058c6:	c3                   	ret    
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		ip = create(path, T_FILE, 0, 0);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801058d6:	31 c9                	xor    %ecx,%ecx
801058d8:	6a 00                	push   $0x0
801058da:	ba 02 00 00 00       	mov    $0x2,%edx
801058df:	e8 ec f7 ff ff       	call   801050d0 <create>
		if (ip == 0) {
801058e4:	83 c4 10             	add    $0x10,%esp
801058e7:	85 c0                	test   %eax,%eax
		ip = create(path, T_FILE, 0, 0);
801058e9:	89 c6                	mov    %eax,%esi
		if (ip == 0) {
801058eb:	0f 85 65 ff ff ff    	jne    80105856 <sys_open+0x76>
			end_op();
801058f1:	e8 5a d3 ff ff       	call   80102c50 <end_op>
			return -1;
801058f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058fb:	eb c0                	jmp    801058bd <sys_open+0xdd>
801058fd:	8d 76 00             	lea    0x0(%esi),%esi
		if (ip->type == T_DIR && omode != O_RDONLY) {
80105900:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105903:	85 c9                	test   %ecx,%ecx
80105905:	0f 84 4b ff ff ff    	je     80105856 <sys_open+0x76>
		iunlockput(ip);
8010590b:	83 ec 0c             	sub    $0xc,%esp
8010590e:	56                   	push   %esi
8010590f:	e8 3c c0 ff ff       	call   80101950 <iunlockput>
		end_op();
80105914:	e8 37 d3 ff ff       	call   80102c50 <end_op>
		return -1;
80105919:	83 c4 10             	add    $0x10,%esp
8010591c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105921:	eb 9a                	jmp    801058bd <sys_open+0xdd>
80105923:	90                   	nop
80105924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (f) fileclose(f);
80105928:	83 ec 0c             	sub    $0xc,%esp
8010592b:	57                   	push   %edi
8010592c:	e8 3f b5 ff ff       	call   80100e70 <fileclose>
80105931:	83 c4 10             	add    $0x10,%esp
80105934:	eb d5                	jmp    8010590b <sys_open+0x12b>
80105936:	8d 76 00             	lea    0x0(%esi),%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <sys_mkdir>:

int
sys_mkdir(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 18             	sub    $0x18,%esp
	char *        path;
	struct inode *ip;

	begin_op();
80105946:	e8 95 d2 ff ff       	call   80102be0 <begin_op>
	if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
8010594b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594e:	83 ec 08             	sub    $0x8,%esp
80105951:	50                   	push   %eax
80105952:	6a 00                	push   $0x0
80105954:	e8 d7 f6 ff ff       	call   80105030 <argstr>
80105959:	83 c4 10             	add    $0x10,%esp
8010595c:	85 c0                	test   %eax,%eax
8010595e:	78 30                	js     80105990 <sys_mkdir+0x50>
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105966:	31 c9                	xor    %ecx,%ecx
80105968:	6a 00                	push   $0x0
8010596a:	ba 01 00 00 00       	mov    $0x1,%edx
8010596f:	e8 5c f7 ff ff       	call   801050d0 <create>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	74 15                	je     80105990 <sys_mkdir+0x50>
		end_op();
		return -1;
	}
	iunlockput(ip);
8010597b:	83 ec 0c             	sub    $0xc,%esp
8010597e:	50                   	push   %eax
8010597f:	e8 cc bf ff ff       	call   80101950 <iunlockput>
	end_op();
80105984:	e8 c7 d2 ff ff       	call   80102c50 <end_op>
	return 0;
80105989:	83 c4 10             	add    $0x10,%esp
8010598c:	31 c0                	xor    %eax,%eax
}
8010598e:	c9                   	leave  
8010598f:	c3                   	ret    
		end_op();
80105990:	e8 bb d2 ff ff       	call   80102c50 <end_op>
		return -1;
80105995:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010599a:	c9                   	leave  
8010599b:	c3                   	ret    
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_mknod>:

int
sys_mknod(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 18             	sub    $0x18,%esp
	struct inode *ip;
	char *        path;
	int           major, minor;

	begin_op();
801059a6:	e8 35 d2 ff ff       	call   80102be0 <begin_op>
	if ((argstr(0, &path)) < 0 || argint(1, &major) < 0 || argint(2, &minor) < 0
801059ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059ae:	83 ec 08             	sub    $0x8,%esp
801059b1:	50                   	push   %eax
801059b2:	6a 00                	push   $0x0
801059b4:	e8 77 f6 ff ff       	call   80105030 <argstr>
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	85 c0                	test   %eax,%eax
801059be:	78 60                	js     80105a20 <sys_mknod+0x80>
801059c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059c3:	83 ec 08             	sub    $0x8,%esp
801059c6:	50                   	push   %eax
801059c7:	6a 01                	push   $0x1
801059c9:	e8 b2 f5 ff ff       	call   80104f80 <argint>
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	78 4b                	js     80105a20 <sys_mknod+0x80>
801059d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d8:	83 ec 08             	sub    $0x8,%esp
801059db:	50                   	push   %eax
801059dc:	6a 02                	push   $0x2
801059de:	e8 9d f5 ff ff       	call   80104f80 <argint>
801059e3:	83 c4 10             	add    $0x10,%esp
801059e6:	85 c0                	test   %eax,%eax
801059e8:	78 36                	js     80105a20 <sys_mknod+0x80>
	    || (ip = create(path, T_DEV, major, minor)) == 0) {
801059ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801059ee:	83 ec 0c             	sub    $0xc,%esp
801059f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801059f5:	ba 03 00 00 00       	mov    $0x3,%edx
801059fa:	50                   	push   %eax
801059fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801059fe:	e8 cd f6 ff ff       	call   801050d0 <create>
80105a03:	83 c4 10             	add    $0x10,%esp
80105a06:	85 c0                	test   %eax,%eax
80105a08:	74 16                	je     80105a20 <sys_mknod+0x80>
		end_op();
		return -1;
	}
	iunlockput(ip);
80105a0a:	83 ec 0c             	sub    $0xc,%esp
80105a0d:	50                   	push   %eax
80105a0e:	e8 3d bf ff ff       	call   80101950 <iunlockput>
	end_op();
80105a13:	e8 38 d2 ff ff       	call   80102c50 <end_op>
	return 0;
80105a18:	83 c4 10             	add    $0x10,%esp
80105a1b:	31 c0                	xor    %eax,%eax
}
80105a1d:	c9                   	leave  
80105a1e:	c3                   	ret    
80105a1f:	90                   	nop
		end_op();
80105a20:	e8 2b d2 ff ff       	call   80102c50 <end_op>
		return -1;
80105a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a2a:	c9                   	leave  
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_chdir>:

int
sys_chdir(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	56                   	push   %esi
80105a34:	53                   	push   %ebx
80105a35:	83 ec 10             	sub    $0x10,%esp
	char *        path;
	struct inode *ip;
	struct proc * curproc = myproc();
80105a38:	e8 d3 de ff ff       	call   80103910 <myproc>
80105a3d:	89 c6                	mov    %eax,%esi

	begin_op();
80105a3f:	e8 9c d1 ff ff       	call   80102be0 <begin_op>
	if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
80105a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a47:	83 ec 08             	sub    $0x8,%esp
80105a4a:	50                   	push   %eax
80105a4b:	6a 00                	push   $0x0
80105a4d:	e8 de f5 ff ff       	call   80105030 <argstr>
80105a52:	83 c4 10             	add    $0x10,%esp
80105a55:	85 c0                	test   %eax,%eax
80105a57:	78 77                	js     80105ad0 <sys_chdir+0xa0>
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a5f:	e8 bc c4 ff ff       	call   80101f20 <namei>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	85 c0                	test   %eax,%eax
80105a69:	89 c3                	mov    %eax,%ebx
80105a6b:	74 63                	je     80105ad0 <sys_chdir+0xa0>
		end_op();
		return -1;
	}
	ilock(ip);
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	50                   	push   %eax
80105a71:	e8 4a bc ff ff       	call   801016c0 <ilock>
	if (ip->type != T_DIR) {
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a7e:	75 30                	jne    80105ab0 <sys_chdir+0x80>
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	53                   	push   %ebx
80105a84:	e8 17 bd ff ff       	call   801017a0 <iunlock>
	iput(curproc->cwd);
80105a89:	58                   	pop    %eax
80105a8a:	ff 76 68             	pushl  0x68(%esi)
80105a8d:	e8 5e bd ff ff       	call   801017f0 <iput>
	end_op();
80105a92:	e8 b9 d1 ff ff       	call   80102c50 <end_op>
	curproc->cwd = ip;
80105a97:	89 5e 68             	mov    %ebx,0x68(%esi)
	return 0;
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	31 c0                	xor    %eax,%eax
}
80105a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105aa2:	5b                   	pop    %ebx
80105aa3:	5e                   	pop    %esi
80105aa4:	5d                   	pop    %ebp
80105aa5:	c3                   	ret    
80105aa6:	8d 76 00             	lea    0x0(%esi),%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		iunlockput(ip);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	53                   	push   %ebx
80105ab4:	e8 97 be ff ff       	call   80101950 <iunlockput>
		end_op();
80105ab9:	e8 92 d1 ff ff       	call   80102c50 <end_op>
		return -1;
80105abe:	83 c4 10             	add    $0x10,%esp
80105ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac6:	eb d7                	jmp    80105a9f <sys_chdir+0x6f>
80105ac8:	90                   	nop
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		end_op();
80105ad0:	e8 7b d1 ff ff       	call   80102c50 <end_op>
		return -1;
80105ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ada:	eb c3                	jmp    80105a9f <sys_chdir+0x6f>
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_exec>:

int
sys_exec(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
80105ae5:	53                   	push   %ebx
	char *path, *argv[MAXARG];
	int   i;
	uint  uargv, uarg;

	if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0) {
80105ae6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105aec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0) {
80105af2:	50                   	push   %eax
80105af3:	6a 00                	push   $0x0
80105af5:	e8 36 f5 ff ff       	call   80105030 <argstr>
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	0f 88 87 00 00 00    	js     80105b8c <sys_exec+0xac>
80105b05:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b0b:	83 ec 08             	sub    $0x8,%esp
80105b0e:	50                   	push   %eax
80105b0f:	6a 01                	push   $0x1
80105b11:	e8 6a f4 ff ff       	call   80104f80 <argint>
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	85 c0                	test   %eax,%eax
80105b1b:	78 6f                	js     80105b8c <sys_exec+0xac>
		return -1;
	}
	memset(argv, 0, sizeof(argv));
80105b1d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b23:	83 ec 04             	sub    $0x4,%esp
	for (i = 0;; i++) {
80105b26:	31 db                	xor    %ebx,%ebx
	memset(argv, 0, sizeof(argv));
80105b28:	68 80 00 00 00       	push   $0x80
80105b2d:	6a 00                	push   $0x0
80105b2f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b35:	50                   	push   %eax
80105b36:	e8 45 f1 ff ff       	call   80104c80 <memset>
80105b3b:	83 c4 10             	add    $0x10,%esp
80105b3e:	eb 2c                	jmp    80105b6c <sys_exec+0x8c>
		if (i >= NELEM(argv)) return -1;
		if (fetchint(uargv + 4 * i, (int *)&uarg) < 0) return -1;
		if (uarg == 0) {
80105b40:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b46:	85 c0                	test   %eax,%eax
80105b48:	74 56                	je     80105ba0 <sys_exec+0xc0>
			argv[i] = 0;
			break;
		}
		if (fetchstr(uarg, &argv[i]) < 0) return -1;
80105b4a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105b50:	83 ec 08             	sub    $0x8,%esp
80105b53:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105b56:	52                   	push   %edx
80105b57:	50                   	push   %eax
80105b58:	e8 b3 f3 ff ff       	call   80104f10 <fetchstr>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	85 c0                	test   %eax,%eax
80105b62:	78 28                	js     80105b8c <sys_exec+0xac>
	for (i = 0;; i++) {
80105b64:	83 c3 01             	add    $0x1,%ebx
		if (i >= NELEM(argv)) return -1;
80105b67:	83 fb 20             	cmp    $0x20,%ebx
80105b6a:	74 20                	je     80105b8c <sys_exec+0xac>
		if (fetchint(uargv + 4 * i, (int *)&uarg) < 0) return -1;
80105b6c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b72:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b79:	83 ec 08             	sub    $0x8,%esp
80105b7c:	57                   	push   %edi
80105b7d:	01 f0                	add    %esi,%eax
80105b7f:	50                   	push   %eax
80105b80:	e8 4b f3 ff ff       	call   80104ed0 <fetchint>
80105b85:	83 c4 10             	add    $0x10,%esp
80105b88:	85 c0                	test   %eax,%eax
80105b8a:	79 b4                	jns    80105b40 <sys_exec+0x60>
	}
	return exec(path, argv);
}
80105b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
80105b8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b94:	5b                   	pop    %ebx
80105b95:	5e                   	pop    %esi
80105b96:	5f                   	pop    %edi
80105b97:	5d                   	pop    %ebp
80105b98:	c3                   	ret    
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return exec(path, argv);
80105ba0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ba6:	83 ec 08             	sub    $0x8,%esp
			argv[i] = 0;
80105ba9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105bb0:	00 00 00 00 
	return exec(path, argv);
80105bb4:	50                   	push   %eax
80105bb5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bbb:	e8 50 ae ff ff       	call   80100a10 <exec>
80105bc0:	83 c4 10             	add    $0x10,%esp
}
80105bc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc6:	5b                   	pop    %ebx
80105bc7:	5e                   	pop    %esi
80105bc8:	5f                   	pop    %edi
80105bc9:	5d                   	pop    %ebp
80105bca:	c3                   	ret    
80105bcb:	90                   	nop
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_pipe>:

int
sys_pipe(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
	int *        fd;
	struct file *rf, *wf;
	int          fd0, fd1;

	if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0) return -1;
80105bd6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105bd9:	83 ec 20             	sub    $0x20,%esp
	if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0) return -1;
80105bdc:	6a 08                	push   $0x8
80105bde:	50                   	push   %eax
80105bdf:	6a 00                	push   $0x0
80105be1:	e8 ea f3 ff ff       	call   80104fd0 <argptr>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	0f 88 ae 00 00 00    	js     80105c9f <sys_pipe+0xcf>
	if (pipealloc(&rf, &wf) < 0) return -1;
80105bf1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bf4:	83 ec 08             	sub    $0x8,%esp
80105bf7:	50                   	push   %eax
80105bf8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105bfb:	50                   	push   %eax
80105bfc:	e8 7f d6 ff ff       	call   80103280 <pipealloc>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	0f 88 93 00 00 00    	js     80105c9f <sys_pipe+0xcf>
	fd0 = -1;
	if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105c0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
	for (fd = 0; fd < NOFILE; fd++) {
80105c0f:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
80105c11:	e8 fa dc ff ff       	call   80103910 <myproc>
80105c16:	eb 10                	jmp    80105c28 <sys_pipe+0x58>
80105c18:	90                   	nop
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (fd = 0; fd < NOFILE; fd++) {
80105c20:	83 c3 01             	add    $0x1,%ebx
80105c23:	83 fb 10             	cmp    $0x10,%ebx
80105c26:	74 60                	je     80105c88 <sys_pipe+0xb8>
		if (curproc->ofile[fd] == 0) {
80105c28:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c2c:	85 f6                	test   %esi,%esi
80105c2e:	75 f0                	jne    80105c20 <sys_pipe+0x50>
			curproc->ofile[fd] = f;
80105c30:	8d 73 08             	lea    0x8(%ebx),%esi
80105c33:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
	if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105c37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	struct proc *curproc = myproc();
80105c3a:	e8 d1 dc ff ff       	call   80103910 <myproc>
	for (fd = 0; fd < NOFILE; fd++) {
80105c3f:	31 d2                	xor    %edx,%edx
80105c41:	eb 0d                	jmp    80105c50 <sys_pipe+0x80>
80105c43:	90                   	nop
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c48:	83 c2 01             	add    $0x1,%edx
80105c4b:	83 fa 10             	cmp    $0x10,%edx
80105c4e:	74 28                	je     80105c78 <sys_pipe+0xa8>
		if (curproc->ofile[fd] == 0) {
80105c50:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c54:	85 c9                	test   %ecx,%ecx
80105c56:	75 f0                	jne    80105c48 <sys_pipe+0x78>
			curproc->ofile[fd] = f;
80105c58:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
		if (fd0 >= 0) myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
80105c5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c5f:	89 18                	mov    %ebx,(%eax)
	fd[1] = fd1;
80105c61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c64:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
80105c67:	31 c0                	xor    %eax,%eax
}
80105c69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c6c:	5b                   	pop    %ebx
80105c6d:	5e                   	pop    %esi
80105c6e:	5f                   	pop    %edi
80105c6f:	5d                   	pop    %ebp
80105c70:	c3                   	ret    
80105c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (fd0 >= 0) myproc()->ofile[fd0] = 0;
80105c78:	e8 93 dc ff ff       	call   80103910 <myproc>
80105c7d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c84:	00 
80105c85:	8d 76 00             	lea    0x0(%esi),%esi
		fileclose(rf);
80105c88:	83 ec 0c             	sub    $0xc,%esp
80105c8b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c8e:	e8 dd b1 ff ff       	call   80100e70 <fileclose>
		fileclose(wf);
80105c93:	58                   	pop    %eax
80105c94:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c97:	e8 d4 b1 ff ff       	call   80100e70 <fileclose>
		return -1;
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca4:	eb c3                	jmp    80105c69 <sys_pipe+0x99>
80105ca6:	66 90                	xchg   %ax,%ax
80105ca8:	66 90                	xchg   %ax,%ax
80105caa:	66 90                	xchg   %ax,%ax
80105cac:	66 90                	xchg   %ax,%ax
80105cae:	66 90                	xchg   %ax,%ax

80105cb0 <sys_fork>:
int pq_enqueue(struct proc *p);
struct proc* pq_dequeue();

int
sys_fork(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
	return fork();
}
80105cb3:	5d                   	pop    %ebp
	return fork();
80105cb4:	e9 37 df ff ff       	jmp    80103bf0 <fork>
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_exit>:

int
sys_exit(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 08             	sub    $0x8,%esp
	exit();
80105cc6:	e8 45 e3 ff ff       	call   80104010 <exit>
	return 0; // not reached
}
80105ccb:	31 c0                	xor    %eax,%eax
80105ccd:	c9                   	leave  
80105cce:	c3                   	ret    
80105ccf:	90                   	nop

80105cd0 <sys_wait>:

int
sys_wait(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
	return wait();
}
80105cd3:	5d                   	pop    %ebp
	return wait();
80105cd4:	e9 97 e6 ff ff       	jmp    80104370 <wait>
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_kill>:

int
sys_kill(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 20             	sub    $0x20,%esp
	int pid;

	if (argint(0, &pid) < 0) return -1;
80105ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ce9:	50                   	push   %eax
80105cea:	6a 00                	push   $0x0
80105cec:	e8 8f f2 ff ff       	call   80104f80 <argint>
80105cf1:	83 c4 10             	add    $0x10,%esp
80105cf4:	85 c0                	test   %eax,%eax
80105cf6:	78 18                	js     80105d10 <sys_kill+0x30>
	return kill(pid);
80105cf8:	83 ec 0c             	sub    $0xc,%esp
80105cfb:	ff 75 f4             	pushl  -0xc(%ebp)
80105cfe:	e8 9d e7 ff ff       	call   801044a0 <kill>
80105d03:	83 c4 10             	add    $0x10,%esp
}
80105d06:	c9                   	leave  
80105d07:	c3                   	ret    
80105d08:	90                   	nop
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (argint(0, &pid) < 0) return -1;
80105d10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d20 <sys_getpid>:

int
sys_getpid(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	83 ec 08             	sub    $0x8,%esp
	return myproc()->pid;
80105d26:	e8 e5 db ff ff       	call   80103910 <myproc>
80105d2b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d2e:	c9                   	leave  
80105d2f:	c3                   	ret    

80105d30 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	53                   	push   %ebx
	int addr;
	int n;

	if (argint(0, &n) < 0) return -1;
80105d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d37:	83 ec 1c             	sub    $0x1c,%esp
	if (argint(0, &n) < 0) return -1;
80105d3a:	50                   	push   %eax
80105d3b:	6a 00                	push   $0x0
80105d3d:	e8 3e f2 ff ff       	call   80104f80 <argint>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	78 27                	js     80105d70 <sys_sbrk+0x40>
	addr = myproc()->sz;
80105d49:	e8 c2 db ff ff       	call   80103910 <myproc>
	if (growproc(n) < 0) return -1;
80105d4e:	83 ec 0c             	sub    $0xc,%esp
	addr = myproc()->sz;
80105d51:	8b 18                	mov    (%eax),%ebx
	if (growproc(n) < 0) return -1;
80105d53:	ff 75 f4             	pushl  -0xc(%ebp)
80105d56:	e8 15 de ff ff       	call   80103b70 <growproc>
80105d5b:	83 c4 10             	add    $0x10,%esp
80105d5e:	85 c0                	test   %eax,%eax
80105d60:	78 0e                	js     80105d70 <sys_sbrk+0x40>
	return addr;
}
80105d62:	89 d8                	mov    %ebx,%eax
80105d64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d67:	c9                   	leave  
80105d68:	c3                   	ret    
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (argint(0, &n) < 0) return -1;
80105d70:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d75:	eb eb                	jmp    80105d62 <sys_sbrk+0x32>
80105d77:	89 f6                	mov    %esi,%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d80 <sys_sleep>:

int
sys_sleep(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	53                   	push   %ebx
	int  n;
	uint ticks0;

	if (argint(0, &n) < 0) return -1;
80105d84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d87:	83 ec 1c             	sub    $0x1c,%esp
	if (argint(0, &n) < 0) return -1;
80105d8a:	50                   	push   %eax
80105d8b:	6a 00                	push   $0x0
80105d8d:	e8 ee f1 ff ff       	call   80104f80 <argint>
80105d92:	83 c4 10             	add    $0x10,%esp
80105d95:	85 c0                	test   %eax,%eax
80105d97:	0f 88 8a 00 00 00    	js     80105e27 <sys_sleep+0xa7>
	acquire(&tickslock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 c0 fc 12 80       	push   $0x8012fcc0
80105da5:	e8 56 ed ff ff       	call   80104b00 <acquire>
	ticks0 = ticks;
	while (ticks - ticks0 < n) {
80105daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dad:	83 c4 10             	add    $0x10,%esp
	ticks0 = ticks;
80105db0:	8b 1d 00 05 13 80    	mov    0x80130500,%ebx
	while (ticks - ticks0 < n) {
80105db6:	85 d2                	test   %edx,%edx
80105db8:	75 27                	jne    80105de1 <sys_sleep+0x61>
80105dba:	eb 54                	jmp    80105e10 <sys_sleep+0x90>
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (myproc()->killed) {
			release(&tickslock);
			return -1;
		}
		sleep(&ticks, &tickslock);
80105dc0:	83 ec 08             	sub    $0x8,%esp
80105dc3:	68 c0 fc 12 80       	push   $0x8012fcc0
80105dc8:	68 00 05 13 80       	push   $0x80130500
80105dcd:	e8 de e4 ff ff       	call   801042b0 <sleep>
	while (ticks - ticks0 < n) {
80105dd2:	a1 00 05 13 80       	mov    0x80130500,%eax
80105dd7:	83 c4 10             	add    $0x10,%esp
80105dda:	29 d8                	sub    %ebx,%eax
80105ddc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105ddf:	73 2f                	jae    80105e10 <sys_sleep+0x90>
		if (myproc()->killed) {
80105de1:	e8 2a db ff ff       	call   80103910 <myproc>
80105de6:	8b 40 24             	mov    0x24(%eax),%eax
80105de9:	85 c0                	test   %eax,%eax
80105deb:	74 d3                	je     80105dc0 <sys_sleep+0x40>
			release(&tickslock);
80105ded:	83 ec 0c             	sub    $0xc,%esp
80105df0:	68 c0 fc 12 80       	push   $0x8012fcc0
80105df5:	e8 26 ee ff ff       	call   80104c20 <release>
			return -1;
80105dfa:	83 c4 10             	add    $0x10,%esp
80105dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	release(&tickslock);
	return 0;
}
80105e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e05:	c9                   	leave  
80105e06:	c3                   	ret    
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	release(&tickslock);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	68 c0 fc 12 80       	push   $0x8012fcc0
80105e18:	e8 03 ee ff ff       	call   80104c20 <release>
	return 0;
80105e1d:	83 c4 10             	add    $0x10,%esp
80105e20:	31 c0                	xor    %eax,%eax
}
80105e22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e25:	c9                   	leave  
80105e26:	c3                   	ret    
	if (argint(0, &n) < 0) return -1;
80105e27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2c:	eb f4                	jmp    80105e22 <sys_sleep+0xa2>
80105e2e:	66 90                	xchg   %ax,%ax

80105e30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	53                   	push   %ebx
80105e34:	83 ec 10             	sub    $0x10,%esp
	uint xticks;

	acquire(&tickslock);
80105e37:	68 c0 fc 12 80       	push   $0x8012fcc0
80105e3c:	e8 bf ec ff ff       	call   80104b00 <acquire>
	xticks = ticks;
80105e41:	8b 1d 00 05 13 80    	mov    0x80130500,%ebx
	release(&tickslock);
80105e47:	c7 04 24 c0 fc 12 80 	movl   $0x8012fcc0,(%esp)
80105e4e:	e8 cd ed ff ff       	call   80104c20 <release>
	return xticks;
}
80105e53:	89 d8                	mov    %ebx,%eax
80105e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e58:	c9                   	leave  
80105e59:	c3                   	ret    
80105e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e60 <sys_mcreate>:
find the index of the first 'empty mutex' 
(mutex is available), set mutex fields, initialize 
this process's reference to the mutex, return 
index/mutexid or -1 if full */
int 
sys_mcreate(char *name){
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	56                   	push   %esi
80105e64:	53                   	push   %ebx

	argptr(0,(void*)&name,sizeof(*name));
80105e65:	8d 45 08             	lea    0x8(%ebp),%eax
	struct proc *p = myproc();
	int i;

	acquire(&MUTEXES.lock);
	for (i=0; i<MUX_MAXNUM; i++){
80105e68:	31 db                	xor    %ebx,%ebx
	argptr(0,(void*)&name,sizeof(*name));
80105e6a:	83 ec 04             	sub    $0x4,%esp
80105e6d:	6a 01                	push   $0x1
80105e6f:	50                   	push   %eax
80105e70:	6a 00                	push   $0x0
80105e72:	e8 59 f1 ff ff       	call   80104fd0 <argptr>
	struct proc *p = myproc();
80105e77:	e8 94 da ff ff       	call   80103910 <myproc>
	acquire(&MUTEXES.lock);
80105e7c:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
	struct proc *p = myproc();
80105e83:	89 c6                	mov    %eax,%esi
	acquire(&MUTEXES.lock);
80105e85:	e8 76 ec ff ff       	call   80104b00 <acquire>
80105e8a:	ba 14 94 11 80       	mov    $0x80119414,%edx
80105e8f:	83 c4 10             	add    $0x10,%esp
80105e92:	eb 12                	jmp    80105ea6 <sys_mcreate+0x46>
80105e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (i=0; i<MUX_MAXNUM; i++){
80105e98:	83 c3 01             	add    $0x1,%ebx
80105e9b:	81 c2 a8 0f 00 00    	add    $0xfa8,%edx
80105ea1:	83 fb 14             	cmp    $0x14,%ebx
80105ea4:	74 4a                	je     80105ef0 <sys_mcreate+0x90>
		if (MUTEXES.muxes[i].name == 0){
80105ea6:	8b 02                	mov    (%edx),%eax
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	75 ec                	jne    80105e98 <sys_mcreate+0x38>
			// set mutex fields
			MUTEXES.muxes[i].name = name;
80105eac:	69 d3 a8 0f 00 00    	imul   $0xfa8,%ebx,%edx
80105eb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
			MUTEXES.muxes[i].state = 0;

			// initialize process reference
			p->mux_ptrs[i] = &MUTEXES.muxes[i];

			release(&MUTEXES.lock);
80105eb5:	83 ec 0c             	sub    $0xc,%esp
			MUTEXES.muxes[i].name = name;
80105eb8:	89 8a 14 94 11 80    	mov    %ecx,-0x7fee6bec(%edx)
			MUTEXES.muxes[i].state = 0;
80105ebe:	c7 82 18 94 11 80 00 	movl   $0x0,-0x7fee6be8(%edx)
80105ec5:	00 00 00 
			p->mux_ptrs[i] = &MUTEXES.muxes[i];
80105ec8:	81 c2 14 94 11 80    	add    $0x80119414,%edx
80105ece:	89 54 9e 7c          	mov    %edx,0x7c(%esi,%ebx,4)
			release(&MUTEXES.lock);
80105ed2:	68 e0 93 11 80       	push   $0x801193e0
80105ed7:	e8 44 ed ff ff       	call   80104c20 <release>
			return i;
80105edc:	83 c4 10             	add    $0x10,%esp
		}
	}
	release(&MUTEXES.lock);
	return -1;
}
80105edf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ee2:	89 d8                	mov    %ebx,%eax
80105ee4:	5b                   	pop    %ebx
80105ee5:	5e                   	pop    %esi
80105ee6:	5d                   	pop    %ebp
80105ee7:	c3                   	ret    
80105ee8:	90                   	nop
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	release(&MUTEXES.lock);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
	return -1;
80105ef3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
	release(&MUTEXES.lock);
80105ef8:	68 e0 93 11 80       	push   $0x801193e0
80105efd:	e8 1e ed ff ff       	call   80104c20 <release>
	return -1;
80105f02:	83 c4 10             	add    $0x10,%esp
}
80105f05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f08:	89 d8                	mov    %ebx,%eax
80105f0a:	5b                   	pop    %ebx
80105f0b:	5e                   	pop    %esi
80105f0c:	5d                   	pop    %ebp
80105f0d:	c3                   	ret    
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <sys_mdelete>:

int
sys_mdelete(int muxid){
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	56                   	push   %esi
80105f14:	53                   	push   %ebx
	
	argint(0,(int*)&muxid);
80105f15:	8d 45 08             	lea    0x8(%ebp),%eax
80105f18:	83 ec 08             	sub    $0x8,%esp
80105f1b:	50                   	push   %eax
80105f1c:	6a 00                	push   $0x0
80105f1e:	e8 5d f0 ff ff       	call   80104f80 <argint>
	struct proc *curproc = myproc();
80105f23:	e8 e8 d9 ff ff       	call   80103910 <myproc>
80105f28:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105f2b:	89 c3                	mov    %eax,%ebx
	struct proc *p;

	// verify we have access to this mutex
	if (curproc->mux_ptrs[muxid] == 0){
80105f2d:	83 c4 10             	add    $0x10,%esp
80105f30:	8d 34 88             	lea    (%eax,%ecx,4),%esi
		return 0;
80105f33:	31 c0                	xor    %eax,%eax
	if (curproc->mux_ptrs[muxid] == 0){
80105f35:	8b 56 7c             	mov    0x7c(%esi),%edx
80105f38:	85 d2                	test   %edx,%edx
80105f3a:	74 32                	je     80105f6e <sys_mdelete+0x5e>
	}

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105f3c:	ba f4 1f 11 80       	mov    $0x80111ff4,%edx
80105f41:	eb 13                	jmp    80105f56 <sys_mdelete+0x46>
80105f43:	90                   	nop
80105f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f48:	81 c2 50 01 00 00    	add    $0x150,%edx
80105f4e:	81 fa f4 73 11 80    	cmp    $0x801173f4,%edx
80105f54:	73 22                	jae    80105f78 <sys_mdelete+0x68>
		if (p != curproc && p->mux_ptrs[muxid] != 0){
80105f56:	39 d3                	cmp    %edx,%ebx
80105f58:	74 ee                	je     80105f48 <sys_mdelete+0x38>
80105f5a:	8b 44 8a 7c          	mov    0x7c(%edx,%ecx,4),%eax
80105f5e:	85 c0                	test   %eax,%eax
80105f60:	74 e6                	je     80105f48 <sys_mdelete+0x38>
	return 1;


rmptr:
	// remove this process's reference to mutex
	curproc->mux_ptrs[muxid] = 0;
80105f62:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
	return 1;
80105f69:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f71:	5b                   	pop    %ebx
80105f72:	5e                   	pop    %esi
80105f73:	5d                   	pop    %ebp
80105f74:	c3                   	ret    
80105f75:	8d 76 00             	lea    0x0(%esi),%esi
	acquire(&MUTEXES.lock);
80105f78:	83 ec 0c             	sub    $0xc,%esp
80105f7b:	68 e0 93 11 80       	push   $0x801193e0
80105f80:	e8 7b eb ff ff       	call   80104b00 <acquire>
	curproc->mux_ptrs[muxid]->name = 0;
80105f85:	8b 45 08             	mov    0x8(%ebp),%eax
80105f88:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80105f8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	curproc->mux_ptrs[muxid]->state = -1;
80105f92:	8b 45 08             	mov    0x8(%ebp),%eax
80105f95:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80105f99:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
	release(&MUTEXES.lock);
80105fa0:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
80105fa7:	e8 74 ec ff ff       	call   80104c20 <release>
	curproc->mux_ptrs[muxid] = 0;
80105fac:	8b 45 08             	mov    0x8(%ebp),%eax
	return 1;
80105faf:	83 c4 10             	add    $0x10,%esp
	curproc->mux_ptrs[muxid] = 0;
80105fb2:	c7 44 83 7c 00 00 00 	movl   $0x0,0x7c(%ebx,%eax,4)
80105fb9:	00 
}
80105fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
	return 1;
80105fbd:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105fc2:	5b                   	pop    %ebx
80105fc3:	5e                   	pop    %esi
80105fc4:	5d                   	pop    %ebp
80105fc5:	c3                   	ret    
80105fc6:	8d 76 00             	lea    0x0(%esi),%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fd0 <sys_mlock>:


int
sys_mlock(int muxid){
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	53                   	push   %ebx

	argint(0,(int*)&muxid);
80105fd4:	8d 45 08             	lea    0x8(%ebp),%eax
sys_mlock(int muxid){
80105fd7:	83 ec 0c             	sub    $0xc,%esp
	argint(0,(int*)&muxid);
80105fda:	50                   	push   %eax
80105fdb:	6a 00                	push   $0x0
80105fdd:	e8 9e ef ff ff       	call   80104f80 <argint>
	struct proc *p = myproc();
80105fe2:	e8 29 d9 ff ff       	call   80103910 <myproc>
	int i;

	// verify this process has access to this mutex
	if (p->mux_ptrs[muxid] == 0){
80105fe7:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p = myproc();
80105fea:	89 c3                	mov    %eax,%ebx
	if (p->mux_ptrs[muxid] == 0){
80105fec:	83 c4 10             	add    $0x10,%esp
		return 0;
80105fef:	31 c0                	xor    %eax,%eax
	if (p->mux_ptrs[muxid] == 0){
80105ff1:	8b 54 93 7c          	mov    0x7c(%ebx,%edx,4),%edx
80105ff5:	85 d2                	test   %edx,%edx
80105ff7:	0f 84 c8 00 00 00    	je     801060c5 <sys_mlock+0xf5>
	}

	acquire(&MUTEXES.lock);
80105ffd:	83 ec 0c             	sub    $0xc,%esp
80106000:	68 e0 93 11 80       	push   $0x801193e0
80106005:	8d 76 00             	lea    0x0(%esi),%esi
80106008:	e8 f3 ea ff ff       	call   80104b00 <acquire>
	while (p->mux_ptrs[muxid]->state == 1){ // lock taken, block waiting for your turn
8010600d:	8b 45 08             	mov    0x8(%ebp),%eax
80106010:	83 c4 10             	add    $0x10,%esp
80106013:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80106017:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
8010601b:	0f 85 88 00 00 00    	jne    801060a9 <sys_mlock+0xd9>

		//cprintf("A\n");

		/* atomically enqueue myself into wait queue
		if this process is already on the wait queue, do not add it again */
		acquire(&wqueue.lock);
80106021:	83 ec 0c             	sub    $0xc,%esp
80106024:	68 e0 0f 11 80       	push   $0x80110fe0
80106029:	e8 d2 ea ff ff       	call   80104b00 <acquire>
8010602e:	83 c4 10             	add    $0x10,%esp
		for (i=0; i<1000; i++){
80106031:	31 d2                	xor    %edx,%edx
80106033:	eb 16                	jmp    8010604b <sys_mlock+0x7b>
80106035:	8d 76 00             	lea    0x0(%esi),%esi
			if (wqueue.queue[i] == p){
				break;
			}
			if (wqueue.queue[i] == 0){
80106038:	85 c9                	test   %ecx,%ecx
8010603a:	74 64                	je     801060a0 <sys_mlock+0xd0>
		for (i=0; i<1000; i++){
8010603c:	83 c2 01             	add    $0x1,%edx
8010603f:	81 fa e8 03 00 00    	cmp    $0x3e8,%edx
80106045:	0f 84 85 00 00 00    	je     801060d0 <sys_mlock+0x100>
			if (wqueue.queue[i] == p){
8010604b:	8b 0c 95 14 10 11 80 	mov    -0x7feeefec(,%edx,4),%ecx
80106052:	39 d9                	cmp    %ebx,%ecx
80106054:	75 e2                	jne    80106038 <sys_mlock+0x68>
				wqueue.queue[i] = p;
				break;
			}
		}
		release(&wqueue.lock);
80106056:	83 ec 0c             	sub    $0xc,%esp
80106059:	68 e0 0f 11 80       	push   $0x80110fe0
8010605e:	e8 bd eb ff ff       	call   80104c20 <release>
			// wait queue is full
			return 0;
		}
		
		// put myself to sleep and call scheduler
		release(&MUTEXES.lock);
80106063:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
8010606a:	e8 b1 eb ff ff       	call   80104c20 <release>
		acquire(&ptable.lock);
8010606f:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80106076:	e8 85 ea ff ff       	call   80104b00 <acquire>
		p->state = SLEEPING;
8010607b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
		sched();
80106082:	e8 c9 de ff ff       	call   80103f50 <sched>
		release(&ptable.lock);
80106087:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
8010608e:	e8 8d eb ff ff       	call   80104c20 <release>

		acquire(&MUTEXES.lock);
80106093:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
8010609a:	e9 69 ff ff ff       	jmp    80106008 <sys_mlock+0x38>
8010609f:	90                   	nop
				wqueue.queue[i] = p;
801060a0:	89 1c 95 14 10 11 80 	mov    %ebx,-0x7feeefec(,%edx,4)
				break;
801060a7:	eb ad                	jmp    80106056 <sys_mlock+0x86>
	}

	// lock available, take the lock
	p->mux_ptrs[muxid]->state = 1;
	release(&MUTEXES.lock);
801060a9:	83 ec 0c             	sub    $0xc,%esp
	p->mux_ptrs[muxid]->state = 1;
801060ac:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	release(&MUTEXES.lock);
801060b3:	68 e0 93 11 80       	push   $0x801193e0
801060b8:	e8 63 eb ff ff       	call   80104c20 <release>
	return 1;
801060bd:	83 c4 10             	add    $0x10,%esp
801060c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
801060c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060c8:	c9                   	leave  
801060c9:	c3                   	ret    
801060ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		release(&wqueue.lock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 e0 0f 11 80       	push   $0x80110fe0
801060d8:	e8 43 eb ff ff       	call   80104c20 <release>
801060dd:	83 c4 10             	add    $0x10,%esp
			return 0;
801060e0:	31 c0                	xor    %eax,%eax
}
801060e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
801060e7:	89 f6                	mov    %esi,%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060f0 <sys_munlock>:

int
sys_munlock(int muxid){
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	56                   	push   %esi
801060f4:	53                   	push   %ebx

	argint(0,(int*)&muxid);
801060f5:	8d 45 08             	lea    0x8(%ebp),%eax
sys_munlock(int muxid){
801060f8:	83 ec 18             	sub    $0x18,%esp
	argint(0,(int*)&muxid);
801060fb:	50                   	push   %eax
801060fc:	6a 00                	push   $0x0
801060fe:	e8 7d ee ff ff       	call   80104f80 <argint>
	struct proc *p, *sleepy_proc;
	p = myproc();
80106103:	e8 08 d8 ff ff       	call   80103910 <myproc>
	int i;


	/* verify this process has access to this mutex
	and make sure proc is currently holding this mutex*/
	if (p->mux_ptrs[muxid] == 0 || p->mux_ptrs[muxid]->state != 1){
80106108:	8b 55 08             	mov    0x8(%ebp),%edx
8010610b:	83 c4 10             	add    $0x10,%esp
8010610e:	8b 54 90 7c          	mov    0x7c(%eax,%edx,4),%edx
80106112:	85 d2                	test   %edx,%edx
80106114:	74 08                	je     8010611e <sys_munlock+0x2e>
80106116:	8b 5a 04             	mov    0x4(%edx),%ebx
80106119:	83 fb 01             	cmp    $0x1,%ebx
8010611c:	74 12                	je     80106130 <sys_munlock+0x40>
		return 0;
8010611e:	31 db                	xor    %ebx,%ebx
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
	}
	release(&ptable.lock);

	return 1;
}
80106120:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106123:	89 d8                	mov    %ebx,%eax
80106125:	5b                   	pop    %ebx
80106126:	5e                   	pop    %esi
80106127:	5d                   	pop    %ebp
80106128:	c3                   	ret    
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	acquire(&MUTEXES.lock);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106136:	68 e0 93 11 80       	push   $0x801193e0
8010613b:	e8 c0 e9 ff ff       	call   80104b00 <acquire>
	p->mux_ptrs[muxid]->state = 0;
80106140:	8b 55 08             	mov    0x8(%ebp),%edx
80106143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106146:	8b 44 90 7c          	mov    0x7c(%eax,%edx,4),%eax
8010614a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	release(&MUTEXES.lock);
80106151:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
80106158:	e8 c3 ea ff ff       	call   80104c20 <release>
	acquire(&wqueue.lock);
8010615d:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80106164:	e8 97 e9 ff ff       	call   80104b00 <acquire>
	sleepy_proc = wqueue.queue[0];
80106169:	8b 35 14 10 11 80    	mov    0x80111014,%esi
	if (sleepy_proc == 0){
8010616f:	83 c4 10             	add    $0x10,%esp
80106172:	b8 14 10 11 80       	mov    $0x80111014,%eax
80106177:	85 f6                	test   %esi,%esi
80106179:	74 67                	je     801061e2 <sys_munlock+0xf2>
8010617b:	90                   	nop
8010617c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		wqueue.queue[i] = wqueue.queue[i+1];
80106180:	8b 50 04             	mov    0x4(%eax),%edx
80106183:	83 c0 04             	add    $0x4,%eax
80106186:	89 50 fc             	mov    %edx,-0x4(%eax)
	for (i=0; i<999; i++){
80106189:	3d b0 1f 11 80       	cmp    $0x80111fb0,%eax
8010618e:	75 f0                	jne    80106180 <sys_munlock+0x90>
	release(&wqueue.lock);
80106190:	83 ec 0c             	sub    $0xc,%esp
	wqueue.queue[999] = 0;
80106193:	c7 05 b0 1f 11 80 00 	movl   $0x0,0x80111fb0
8010619a:	00 00 00 
	release(&wqueue.lock);
8010619d:	68 e0 0f 11 80       	push   $0x80110fe0
801061a2:	e8 79 ea ff ff       	call   80104c20 <release>
	acquire(&ptable.lock);
801061a7:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
801061ae:	e8 4d e9 ff ff       	call   80104b00 <acquire>
	sleepy_proc->state = RUNNABLE;
801061b3:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
	if (pq_enqueue(sleepy_proc) < 0){
801061ba:	89 34 24             	mov    %esi,(%esp)
801061bd:	e8 ae e4 ff ff       	call   80104670 <pq_enqueue>
801061c2:	83 c4 10             	add    $0x10,%esp
801061c5:	85 c0                	test   %eax,%eax
801061c7:	78 2e                	js     801061f7 <sys_munlock+0x107>
	release(&ptable.lock);
801061c9:	83 ec 0c             	sub    $0xc,%esp
801061cc:	68 c0 1f 11 80       	push   $0x80111fc0
801061d1:	e8 4a ea ff ff       	call   80104c20 <release>
	return 1;
801061d6:	83 c4 10             	add    $0x10,%esp
}
801061d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061dc:	89 d8                	mov    %ebx,%eax
801061de:	5b                   	pop    %ebx
801061df:	5e                   	pop    %esi
801061e0:	5d                   	pop    %ebp
801061e1:	c3                   	ret    
		release(&wqueue.lock);
801061e2:	83 ec 0c             	sub    $0xc,%esp
801061e5:	68 e0 0f 11 80       	push   $0x80110fe0
801061ea:	e8 31 ea ff ff       	call   80104c20 <release>
		return 1;
801061ef:	83 c4 10             	add    $0x10,%esp
801061f2:	e9 29 ff ff ff       	jmp    80106120 <sys_munlock+0x30>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801061f7:	83 ec 0c             	sub    $0xc,%esp
801061fa:	68 78 86 10 80       	push   $0x80108678
801061ff:	e8 8c a1 ff ff       	call   80100390 <panic>
80106204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010620a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106210 <sys_waitcv>:


int
sys_waitcv(int muxid){
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	53                   	push   %ebx

	argint(0,(int*)&muxid);
80106214:	8d 45 08             	lea    0x8(%ebp),%eax
sys_waitcv(int muxid){
80106217:	83 ec 0c             	sub    $0xc,%esp
	argint(0,(int*)&muxid);
8010621a:	50                   	push   %eax
8010621b:	6a 00                	push   $0x0
8010621d:	e8 5e ed ff ff       	call   80104f80 <argint>
	struct proc *p = myproc();
80106222:	e8 e9 d6 ff ff       	call   80103910 <myproc>
	int i;

	/* atomically enqueue proc to mux's cv wait queue if this 
	process is already on the wait queue, do not add it again */
	acquire(&MUTEXES.lock);
80106227:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
	struct proc *p = myproc();
8010622e:	89 c3                	mov    %eax,%ebx
	acquire(&MUTEXES.lock);
80106230:	e8 cb e8 ff ff       	call   80104b00 <acquire>
	for (i=0; i<1000; i++){
		if (p->mux_ptrs[muxid]->cv[i] == p){
80106235:	8b 45 08             	mov    0x8(%ebp),%eax
80106238:	83 c4 10             	add    $0x10,%esp
	for (i=0; i<1000; i++){
8010623b:	31 d2                	xor    %edx,%edx
		if (p->mux_ptrs[muxid]->cv[i] == p){
8010623d:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80106241:	eb 14                	jmp    80106257 <sys_waitcv+0x47>
80106243:	90                   	nop
80106244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			break;
		}
		if (p->mux_ptrs[muxid]->cv[i] == 0){
80106248:	85 c9                	test   %ecx,%ecx
8010624a:	74 4c                	je     80106298 <sys_waitcv+0x88>
	for (i=0; i<1000; i++){
8010624c:	83 c2 01             	add    $0x1,%edx
8010624f:	81 fa e8 03 00 00    	cmp    $0x3e8,%edx
80106255:	74 79                	je     801062d0 <sys_waitcv+0xc0>
		if (p->mux_ptrs[muxid]->cv[i] == p){
80106257:	8b 4c 90 08          	mov    0x8(%eax,%edx,4),%ecx
8010625b:	39 d9                	cmp    %ebx,%ecx
8010625d:	75 e9                	jne    80106248 <sys_waitcv+0x38>
			p->mux_ptrs[muxid]->cv[i] = p;
			break;
		}
	}
	release(&MUTEXES.lock);
8010625f:	83 ec 0c             	sub    $0xc,%esp
80106262:	68 e0 93 11 80       	push   $0x801193e0
80106267:	e8 b4 e9 ff ff       	call   80104c20 <release>
		// cv wait queue is full
		return 0;
	}
	
	// sleep self and call scheduler
	acquire(&ptable.lock);
8010626c:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80106273:	e8 88 e8 ff ff       	call   80104b00 <acquire>
	p->state = SLEEPING;
80106278:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	// release mutex
	if (!sys_munlock(muxid)){
8010627f:	58                   	pop    %eax
80106280:	ff 75 08             	pushl  0x8(%ebp)
80106283:	e8 68 fe ff ff       	call   801060f0 <sys_munlock>
80106288:	83 c4 10             	add    $0x10,%esp
8010628b:	85 c0                	test   %eax,%eax
8010628d:	75 11                	jne    801062a0 <sys_waitcv+0x90>
	if (!sys_mlock(muxid)){
		return 0;
	}
	return 1;

}
8010628f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106292:	c9                   	leave  
80106293:	c3                   	ret    
80106294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			p->mux_ptrs[muxid]->cv[i] = p;
80106298:	89 5c 90 08          	mov    %ebx,0x8(%eax,%edx,4)
			break;
8010629c:	eb c1                	jmp    8010625f <sys_waitcv+0x4f>
8010629e:	66 90                	xchg   %ax,%ax
	sched();
801062a0:	e8 ab dc ff ff       	call   80103f50 <sched>
	release(&ptable.lock);
801062a5:	83 ec 0c             	sub    $0xc,%esp
801062a8:	68 c0 1f 11 80       	push   $0x80111fc0
801062ad:	e8 6e e9 ff ff       	call   80104c20 <release>
	if (!sys_mlock(muxid)){
801062b2:	5a                   	pop    %edx
801062b3:	ff 75 08             	pushl  0x8(%ebp)
801062b6:	e8 15 fd ff ff       	call   80105fd0 <sys_mlock>
801062bb:	83 c4 10             	add    $0x10,%esp
801062be:	85 c0                	test   %eax,%eax
}
801062c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	if (!sys_mlock(muxid)){
801062c3:	0f 95 c0             	setne  %al
}
801062c6:	c9                   	leave  
	if (!sys_mlock(muxid)){
801062c7:	0f b6 c0             	movzbl %al,%eax
}
801062ca:	c3                   	ret    
801062cb:	90                   	nop
801062cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	release(&MUTEXES.lock);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	68 e0 93 11 80       	push   $0x801193e0
801062d8:	e8 43 e9 ff ff       	call   80104c20 <release>
801062dd:	83 c4 10             	add    $0x10,%esp
		return 0;
801062e0:	31 c0                	xor    %eax,%eax
801062e2:	eb ab                	jmp    8010628f <sys_waitcv+0x7f>
801062e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801062ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801062f0 <sys_signalcv>:
int 
sys_signalcv(int muxid){
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	57                   	push   %edi
801062f4:	56                   	push   %esi
801062f5:	53                   	push   %ebx

	argint(0,(int*)&muxid);
801062f6:	8d 45 08             	lea    0x8(%ebp),%eax
sys_signalcv(int muxid){
801062f9:	83 ec 24             	sub    $0x24,%esp
	argint(0,(int*)&muxid);
801062fc:	50                   	push   %eax
801062fd:	6a 00                	push   $0x0
801062ff:	e8 7c ec ff ff       	call   80104f80 <argint>
	struct proc *p, *sleepy_proc; 
	p = myproc();
80106304:	e8 07 d6 ff ff       	call   80103910 <myproc>
	int i;

	/* verify this process has access to this mutex
	and make sure proc is currently holding this mutex*/
	if (p->mux_ptrs[muxid] == 0 || p->mux_ptrs[muxid]->state != 1){
80106309:	8b 55 08             	mov    0x8(%ebp),%edx
8010630c:	83 c4 10             	add    $0x10,%esp
8010630f:	8b 54 90 7c          	mov    0x7c(%eax,%edx,4),%edx
80106313:	85 d2                	test   %edx,%edx
80106315:	74 08                	je     8010631f <sys_signalcv+0x2f>
80106317:	8b 5a 04             	mov    0x4(%edx),%ebx
8010631a:	83 fb 01             	cmp    $0x1,%ebx
8010631d:	74 11                	je     80106330 <sys_signalcv+0x40>
		return 0;
8010631f:	31 db                	xor    %ebx,%ebx
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
	}
	release(&ptable.lock);

	return 1;
}
80106321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106324:	89 d8                	mov    %ebx,%eax
80106326:	5b                   	pop    %ebx
80106327:	5e                   	pop    %esi
80106328:	5f                   	pop    %edi
80106329:	5d                   	pop    %ebp
8010632a:	c3                   	ret    
8010632b:	90                   	nop
8010632c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	acquire(&MUTEXES.lock);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106336:	68 e0 93 11 80       	push   $0x801193e0
8010633b:	e8 c0 e7 ff ff       	call   80104b00 <acquire>
80106340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106343:	8b 55 08             	mov    0x8(%ebp),%edx
	if (sleepy_proc == 0){
80106346:	83 c4 10             	add    $0x10,%esp
80106349:	8d 0c 90             	lea    (%eax,%edx,4),%ecx
	for (i=0; i<999; i++){
8010634c:	31 c0                	xor    %eax,%eax
	sleepy_proc = p->mux_ptrs[muxid]->cv[0];
8010634e:	8b 79 7c             	mov    0x7c(%ecx),%edi
80106351:	8b 77 08             	mov    0x8(%edi),%esi
	if (sleepy_proc == 0){
80106354:	85 f6                	test   %esi,%esi
80106356:	75 0d                	jne    80106365 <sys_signalcv+0x75>
80106358:	eb 75                	jmp    801063cf <sys_signalcv+0xdf>
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106360:	8b 79 7c             	mov    0x7c(%ecx),%edi
80106363:	89 d0                	mov    %edx,%eax
		p->mux_ptrs[muxid]->cv[i] = p->mux_ptrs[muxid]->cv[i+1];
80106365:	8d 50 01             	lea    0x1(%eax),%edx
80106368:	8d 04 87             	lea    (%edi,%eax,4),%eax
8010636b:	8b 78 0c             	mov    0xc(%eax),%edi
	for (i=0; i<999; i++){
8010636e:	81 fa e7 03 00 00    	cmp    $0x3e7,%edx
		p->mux_ptrs[muxid]->cv[i] = p->mux_ptrs[muxid]->cv[i+1];
80106374:	89 78 08             	mov    %edi,0x8(%eax)
	for (i=0; i<999; i++){
80106377:	75 e7                	jne    80106360 <sys_signalcv+0x70>
	p->mux_ptrs[muxid]->cv[999] = 0;
80106379:	8b 41 7c             	mov    0x7c(%ecx),%eax
	release(&MUTEXES.lock);
8010637c:	83 ec 0c             	sub    $0xc,%esp
	p->mux_ptrs[muxid]->cv[999] = 0;
8010637f:	c7 80 a4 0f 00 00 00 	movl   $0x0,0xfa4(%eax)
80106386:	00 00 00 
	release(&MUTEXES.lock);
80106389:	68 e0 93 11 80       	push   $0x801193e0
8010638e:	e8 8d e8 ff ff       	call   80104c20 <release>
	acquire(&ptable.lock);
80106393:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
8010639a:	e8 61 e7 ff ff       	call   80104b00 <acquire>
	sleepy_proc->state = RUNNABLE;
8010639f:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
	if (pq_enqueue(sleepy_proc) < 0){
801063a6:	89 34 24             	mov    %esi,(%esp)
801063a9:	e8 c2 e2 ff ff       	call   80104670 <pq_enqueue>
801063ae:	83 c4 10             	add    $0x10,%esp
801063b1:	85 c0                	test   %eax,%eax
801063b3:	78 31                	js     801063e6 <sys_signalcv+0xf6>
	release(&ptable.lock);
801063b5:	83 ec 0c             	sub    $0xc,%esp
801063b8:	68 c0 1f 11 80       	push   $0x80111fc0
801063bd:	e8 5e e8 ff ff       	call   80104c20 <release>
	return 1;
801063c2:	83 c4 10             	add    $0x10,%esp
}
801063c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063c8:	89 d8                	mov    %ebx,%eax
801063ca:	5b                   	pop    %ebx
801063cb:	5e                   	pop    %esi
801063cc:	5f                   	pop    %edi
801063cd:	5d                   	pop    %ebp
801063ce:	c3                   	ret    
		release(&MUTEXES.lock);
801063cf:	83 ec 0c             	sub    $0xc,%esp
		return 0;
801063d2:	31 db                	xor    %ebx,%ebx
		release(&MUTEXES.lock);
801063d4:	68 e0 93 11 80       	push   $0x801193e0
801063d9:	e8 42 e8 ff ff       	call   80104c20 <release>
		return 0;
801063de:	83 c4 10             	add    $0x10,%esp
801063e1:	e9 3b ff ff ff       	jmp    80106321 <sys_signalcv+0x31>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801063e6:	83 ec 0c             	sub    $0xc,%esp
801063e9:	68 78 86 10 80       	push   $0x80108678
801063ee:	e8 9d 9f ff ff       	call   80100390 <panic>
801063f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801063f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106400 <sys_prio_set>:

/* attempts to set the priority of the process identified by pid to priority. 
The priority of the initial process was already set to 0 (highest priority), 
and all child processes inherit the priority level of parent*/
int 
sys_prio_set(int pid, int priority){
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	53                   	push   %ebx

	argint(0,(int*)&pid);	
80106404:	8d 45 08             	lea    0x8(%ebp),%eax
sys_prio_set(int pid, int priority){
80106407:	83 ec 0c             	sub    $0xc,%esp
	argint(0,(int*)&pid);	
8010640a:	50                   	push   %eax
8010640b:	6a 00                	push   $0x0
8010640d:	e8 6e eb ff ff       	call   80104f80 <argint>
	argint(1,(int*)&priority);
80106412:	58                   	pop    %eax
80106413:	8d 45 0c             	lea    0xc(%ebp),%eax
80106416:	5a                   	pop    %edx
80106417:	50                   	push   %eax
80106418:	6a 01                	push   $0x1
8010641a:	e8 61 eb ff ff       	call   80104f80 <argint>
	struct proc *curproc = myproc();
8010641f:	e8 ec d4 ff ff       	call   80103910 <myproc>
80106424:	89 c3                	mov    %eax,%ebx
	struct proc *p;

	//temporarily
	//cprintf("%d\n", curproc->priority);

	if (priority >= PRIO_MAX){
80106426:	8b 45 0c             	mov    0xc(%ebp),%eax
80106429:	83 c4 10             	add    $0x10,%esp
8010642c:	83 f8 13             	cmp    $0x13,%eax
8010642f:	0f 8f c5 00 00 00    	jg     801064fa <sys_prio_set+0xfa>
		// invalid priority
		return -1;
	}

	// quick-exit case 1: process is trying to set priority above its own
	if (priority < curproc->priority){
80106435:	39 83 cc 00 00 00    	cmp    %eax,0xcc(%ebx)
8010643b:	0f 87 b9 00 00 00    	ja     801064fa <sys_prio_set+0xfa>
		return -1;
	}
	// quick-exit case 2: pid refers to this process
	if (curproc->pid == pid){
80106441:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106444:	39 4b 10             	cmp    %ecx,0x10(%ebx)
80106447:	0f 84 83 00 00 00    	je     801064d0 <sys_prio_set+0xd0>
	}


	// validate that the pid process is in ancestry of current process:
	// search through proc table until we find process with pid
	acquire(&ptable.lock);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	68 c0 1f 11 80       	push   $0x80111fc0
80106455:	e8 a6 e6 ff ff       	call   80104b00 <acquire>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		if (p != curproc && p->pid == pid){
8010645a:	8b 45 08             	mov    0x8(%ebp),%eax
8010645d:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80106460:	ba f4 1f 11 80       	mov    $0x80111ff4,%edx
80106465:	eb 17                	jmp    8010647e <sys_prio_set+0x7e>
80106467:	89 f6                	mov    %esi,%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106470:	81 c2 50 01 00 00    	add    $0x150,%edx
80106476:	81 fa f4 73 11 80    	cmp    $0x801173f4,%edx
8010647c:	73 62                	jae    801064e0 <sys_prio_set+0xe0>
		if (p != curproc && p->pid == pid){
8010647e:	39 d3                	cmp    %edx,%ebx
80106480:	74 ee                	je     80106470 <sys_prio_set+0x70>
80106482:	39 42 10             	cmp    %eax,0x10(%edx)
80106485:	75 e9                	jne    80106470 <sys_prio_set+0x70>
			break;
		}
	}
	if (p >= &ptable.proc[NPROC]){
80106487:	81 fa f4 73 11 80    	cmp    $0x801173f4,%edx
8010648d:	73 51                	jae    801064e0 <sys_prio_set+0xe0>
		release(&ptable.lock);
		return -1;
	}
	// search down it's parent links until we either find the current proc, or we reach pid <= 1
	int found = 0;
	struct proc *i = p->parent;
8010648f:	8b 42 14             	mov    0x14(%edx),%eax
	while (i->pid > 1){
80106492:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80106496:	7f 11                	jg     801064a9 <sys_prio_set+0xa9>
80106498:	eb 46                	jmp    801064e0 <sys_prio_set+0xe0>
8010649a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (i == curproc){
			found = 1;
			break;
		}
		i = i->parent;
801064a0:	8b 40 14             	mov    0x14(%eax),%eax
	while (i->pid > 1){
801064a3:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
801064a7:	7e 37                	jle    801064e0 <sys_prio_set+0xe0>
		if (i == curproc){
801064a9:	39 c3                	cmp    %eax,%ebx
801064ab:	75 f3                	jne    801064a0 <sys_prio_set+0xa0>
	}
	if (found){
		p->priority = priority;
801064ad:	8b 45 0c             	mov    0xc(%ebp),%eax
	} else{
		// this process is not in your ancestry
		release(&ptable.lock);
		return -1;
	}
	release(&ptable.lock);
801064b0:	83 ec 0c             	sub    $0xc,%esp
		p->priority = priority;
801064b3:	89 82 cc 00 00 00    	mov    %eax,0xcc(%edx)
	release(&ptable.lock);
801064b9:	68 c0 1f 11 80       	push   $0x80111fc0
801064be:	e8 5d e7 ff ff       	call   80104c20 <release>
	return 1;
801064c3:	83 c4 10             	add    $0x10,%esp
801064c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801064cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064ce:	c9                   	leave  
801064cf:	c3                   	ret    
		curproc->priority = priority;
801064d0:	89 83 cc 00 00 00    	mov    %eax,0xcc(%ebx)
		return 1;
801064d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801064db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064de:	c9                   	leave  
801064df:	c3                   	ret    
		release(&ptable.lock);
801064e0:	83 ec 0c             	sub    $0xc,%esp
801064e3:	68 c0 1f 11 80       	push   $0x80111fc0
801064e8:	e8 33 e7 ff ff       	call   80104c20 <release>
		return -1;
801064ed:	83 c4 10             	add    $0x10,%esp
801064f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064f8:	c9                   	leave  
801064f9:	c3                   	ret    
		return -1;
801064fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ff:	eb ca                	jmp    801064cb <sys_prio_set+0xcb>
80106501:	eb 0d                	jmp    80106510 <sys_testpqeq>
80106503:	90                   	nop
80106504:	90                   	nop
80106505:	90                   	nop
80106506:	90                   	nop
80106507:	90                   	nop
80106508:	90                   	nop
80106509:	90                   	nop
8010650a:	90                   	nop
8010650b:	90                   	nop
8010650c:	90                   	nop
8010650d:	90                   	nop
8010650e:	90                   	nop
8010650f:	90                   	nop

80106510 <sys_testpqeq>:

// user forks a bunch of children, sets varying priority levels, and calls this function for each of them
void
sys_testpqeq(){
80106510:	55                   	push   %ebp
80106511:	89 e5                	mov    %esp,%ebp
80106513:	83 ec 14             	sub    $0x14,%esp

	acquire(&ptable.lock);
80106516:	68 c0 1f 11 80       	push   $0x80111fc0
8010651b:	e8 e0 e5 ff ff       	call   80104b00 <acquire>
	struct proc *p = myproc();
80106520:	e8 eb d3 ff ff       	call   80103910 <myproc>
	
	int priority = p->priority;
	char prio_char = (char)(priority+47);
80106525:	0f b6 88 cc 00 00 00 	movzbl 0xcc(%eax),%ecx
	p->name[0] = prio_char; 
	p->name[1] = '\0';
8010652c:	c6 40 6d 00          	movb   $0x0,0x6d(%eax)
	char prio_char = (char)(priority+47);
80106530:	8d 51 2f             	lea    0x2f(%ecx),%edx
80106533:	88 50 6c             	mov    %dl,0x6c(%eax)

	// enqueue 
	pq_enqueue(p);
80106536:	89 04 24             	mov    %eax,(%esp)
80106539:	e8 32 e1 ff ff       	call   80104670 <pq_enqueue>
	release(&ptable.lock);
8010653e:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80106545:	e8 d6 e6 ff ff       	call   80104c20 <release>



}
8010654a:	83 c4 10             	add    $0x10,%esp
8010654d:	c9                   	leave  
8010654e:	c3                   	ret    
8010654f:	90                   	nop

80106550 <sys_testpqdq>:

// after user enqueued a bunch of procs using the above function, dequeue them all and observe the order
void
sys_testpqdq(){
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	53                   	push   %ebx

	struct proc *p = pq_dequeue();
	int count = 0;
80106554:	31 db                	xor    %ebx,%ebx
sys_testpqdq(){
80106556:	83 ec 04             	sub    $0x4,%esp
	struct proc *p = pq_dequeue();
80106559:	e8 a2 e1 ff ff       	call   80104700 <pq_dequeue>
8010655e:	eb 14                	jmp    80106574 <sys_testpqdq+0x24>

		if (p->name[0] == '1'){
			cprintf("%s\n", p->name);
			count++;
		}
		else if (p->name[0] == '2'){
80106560:	80 fa 32             	cmp    $0x32,%dl
80106563:	74 18                	je     8010657d <sys_testpqdq+0x2d>
			cprintf("%s\n", p->name);
			count++;
		}
		else if (p->name[0] == '3'){
80106565:	80 fa 33             	cmp    $0x33,%dl
80106568:	74 13                	je     8010657d <sys_testpqdq+0x2d>
			cprintf("%s\n", p->name);
			count++;
		}

		p = pq_dequeue();
8010656a:	e8 91 e1 ff ff       	call   80104700 <pq_dequeue>
	while (count < 3){
8010656f:	83 fb 03             	cmp    $0x3,%ebx
80106572:	74 2a                	je     8010659e <sys_testpqdq+0x4e>
		if (p->name[0] == '1'){
80106574:	0f b6 50 6c          	movzbl 0x6c(%eax),%edx
80106578:	80 fa 31             	cmp    $0x31,%dl
8010657b:	75 e3                	jne    80106560 <sys_testpqdq+0x10>
			cprintf("%s\n", p->name);
8010657d:	83 ec 08             	sub    $0x8,%esp
80106580:	83 c0 6c             	add    $0x6c,%eax
			count++;
80106583:	83 c3 01             	add    $0x1,%ebx
			cprintf("%s\n", p->name);
80106586:	50                   	push   %eax
80106587:	68 25 89 10 80       	push   $0x80108925
8010658c:	e8 cf a0 ff ff       	call   80100660 <cprintf>
			count++;
80106591:	83 c4 10             	add    $0x10,%esp
		p = pq_dequeue();
80106594:	e8 67 e1 ff ff       	call   80104700 <pq_dequeue>
	while (count < 3){
80106599:	83 fb 03             	cmp    $0x3,%ebx
8010659c:	75 d6                	jne    80106574 <sys_testpqdq+0x24>
	}
	
	
}
8010659e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801065a1:	c9                   	leave  
801065a2:	c3                   	ret    
801065a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065b0 <sys_shmget>:

char*
sys_shmget(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	83 ec 1c             	sub    $0x1c,%esp
	char* name;
	if(argptr(0, (void *)&name, sizeof(*name)) < 0) return "failed";
801065b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065b9:	6a 01                	push   $0x1
801065bb:	50                   	push   %eax
801065bc:	6a 00                	push   $0x0
801065be:	e8 0d ea ff ff       	call   80104fd0 <argptr>
801065c3:	83 c4 10             	add    $0x10,%esp
801065c6:	85 c0                	test   %eax,%eax
801065c8:	ba 29 89 10 80       	mov    $0x80108929,%edx
801065cd:	78 10                	js     801065df <sys_shmget+0x2f>

	return shmget(name);
801065cf:	83 ec 0c             	sub    $0xc,%esp
801065d2:	ff 75 f4             	pushl  -0xc(%ebp)
801065d5:	e8 16 19 00 00       	call   80107ef0 <shmget>
801065da:	83 c4 10             	add    $0x10,%esp
801065dd:	89 c2                	mov    %eax,%edx
}
801065df:	89 d0                	mov    %edx,%eax
801065e1:	c9                   	leave  
801065e2:	c3                   	ret    
801065e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065f0 <sys_shmrem>:

int
sys_shmrem(void)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	83 ec 1c             	sub    $0x1c,%esp
	char* name;
	if(argptr(0, (void *)&name, sizeof(*name)) < 0) return -1;
801065f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065f9:	6a 01                	push   $0x1
801065fb:	50                   	push   %eax
801065fc:	6a 00                	push   $0x0
801065fe:	e8 cd e9 ff ff       	call   80104fd0 <argptr>
80106603:	83 c4 10             	add    $0x10,%esp
80106606:	85 c0                	test   %eax,%eax
80106608:	78 16                	js     80106620 <sys_shmrem+0x30>

	return shmrem(name);
8010660a:	83 ec 0c             	sub    $0xc,%esp
8010660d:	ff 75 f4             	pushl  -0xc(%ebp)
80106610:	e8 7b 1a 00 00       	call   80108090 <shmrem>
80106615:	83 c4 10             	add    $0x10,%esp
}
80106618:	c9                   	leave  
80106619:	c3                   	ret    
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if(argptr(0, (void *)&name, sizeof(*name)) < 0) return -1;
80106620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106625:	c9                   	leave  
80106626:	c3                   	ret    

80106627 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106627:	1e                   	push   %ds
  pushl %es
80106628:	06                   	push   %es
  pushl %fs
80106629:	0f a0                	push   %fs
  pushl %gs
8010662b:	0f a8                	push   %gs
  pushal
8010662d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010662e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106632:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106634:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106636:	54                   	push   %esp
  call trap
80106637:	e8 c4 00 00 00       	call   80106700 <trap>
  addl $4, %esp
8010663c:	83 c4 04             	add    $0x4,%esp

8010663f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010663f:	61                   	popa   
  popl %gs
80106640:	0f a9                	pop    %gs
  popl %fs
80106642:	0f a1                	pop    %fs
  popl %es
80106644:	07                   	pop    %es
  popl %ds
80106645:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106646:	83 c4 08             	add    $0x8,%esp
  iret
80106649:	cf                   	iret   
8010664a:	66 90                	xchg   %ax,%ax
8010664c:	66 90                	xchg   %ax,%ax
8010664e:	66 90                	xchg   %ax,%ax

80106650 <tvinit>:
struct spinlock tickslock;
uint            ticks;

void
tvinit(void)
{
80106650:	55                   	push   %ebp
	int i;

	for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106651:	31 c0                	xor    %eax,%eax
{
80106653:	89 e5                	mov    %esp,%ebp
80106655:	83 ec 08             	sub    $0x8,%esp
80106658:	90                   	nop
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106660:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106667:	c7 04 c5 02 fd 12 80 	movl   $0x8e000008,-0x7fed02fe(,%eax,8)
8010666e:	08 00 00 8e 
80106672:	66 89 14 c5 00 fd 12 	mov    %dx,-0x7fed0300(,%eax,8)
80106679:	80 
8010667a:	c1 ea 10             	shr    $0x10,%edx
8010667d:	66 89 14 c5 06 fd 12 	mov    %dx,-0x7fed02fa(,%eax,8)
80106684:	80 
80106685:	83 c0 01             	add    $0x1,%eax
80106688:	3d 00 01 00 00       	cmp    $0x100,%eax
8010668d:	75 d1                	jne    80106660 <tvinit+0x10>
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010668f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

	initlock(&tickslock, "time");
80106694:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80106697:	c7 05 02 ff 12 80 08 	movl   $0xef000008,0x8012ff02
8010669e:	00 00 ef 
	initlock(&tickslock, "time");
801066a1:	68 30 89 10 80       	push   $0x80108930
801066a6:	68 c0 fc 12 80       	push   $0x8012fcc0
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801066ab:	66 a3 00 ff 12 80    	mov    %ax,0x8012ff00
801066b1:	c1 e8 10             	shr    $0x10,%eax
801066b4:	66 a3 06 ff 12 80    	mov    %ax,0x8012ff06
	initlock(&tickslock, "time");
801066ba:	e8 51 e3 ff ff       	call   80104a10 <initlock>
}
801066bf:	83 c4 10             	add    $0x10,%esp
801066c2:	c9                   	leave  
801066c3:	c3                   	ret    
801066c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801066ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801066d0 <idtinit>:

void
idtinit(void)
{
801066d0:	55                   	push   %ebp
	pd[0] = size - 1;
801066d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801066d6:	89 e5                	mov    %esp,%ebp
801066d8:	83 ec 10             	sub    $0x10,%esp
801066db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
	pd[1] = (uint)p;
801066df:	b8 00 fd 12 80       	mov    $0x8012fd00,%eax
801066e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	pd[2] = (uint)p >> 16;
801066e8:	c1 e8 10             	shr    $0x10,%eax
801066eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
	asm volatile("lidt (%0)" : : "r"(pd));
801066ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801066f2:	0f 01 18             	lidtl  (%eax)
	lidt(idt, sizeof(idt));
}
801066f5:	c9                   	leave  
801066f6:	c3                   	ret    
801066f7:	89 f6                	mov    %esi,%esi
801066f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106700 <trap>:

// PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	57                   	push   %edi
80106704:	56                   	push   %esi
80106705:	53                   	push   %ebx
80106706:	83 ec 1c             	sub    $0x1c,%esp
80106709:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (tf->trapno == T_SYSCALL) {
8010670c:	8b 47 30             	mov    0x30(%edi),%eax
8010670f:	83 f8 40             	cmp    $0x40,%eax
80106712:	0f 84 f0 00 00 00    	je     80106808 <trap+0x108>
		syscall();
		if (myproc()->killed) exit();
		return;
	}

	switch (tf->trapno) {
80106718:	83 e8 20             	sub    $0x20,%eax
8010671b:	83 f8 1f             	cmp    $0x1f,%eax
8010671e:	77 10                	ja     80106730 <trap+0x30>
80106720:	ff 24 85 d8 89 10 80 	jmp    *-0x7fef7628(,%eax,4)
80106727:	89 f6                	mov    %esi,%esi
80106729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		lapiceoi();
		break;

	// PAGEBREAK: 13
	default:
		if (myproc() == 0 || (tf->cs & 3) == 0) {
80106730:	e8 db d1 ff ff       	call   80103910 <myproc>
80106735:	85 c0                	test   %eax,%eax
80106737:	8b 5f 38             	mov    0x38(%edi),%ebx
8010673a:	0f 84 14 02 00 00    	je     80106954 <trap+0x254>
80106740:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106744:	0f 84 0a 02 00 00    	je     80106954 <trap+0x254>

static inline uint
rcr2(void)
{
	uint val;
	asm volatile("movl %%cr2,%0" : "=r"(val));
8010674a:	0f 20 d1             	mov    %cr2,%ecx
8010674d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno, cpuid(), tf->eip,
			        rcr2());
			panic("trap");
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106750:	e8 9b d1 ff ff       	call   801038f0 <cpuid>
80106755:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106758:	8b 47 34             	mov    0x34(%edi),%eax
8010675b:	8b 77 30             	mov    0x30(%edi),%esi
8010675e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		        "eip 0x%x addr 0x%x--kill proc\n",
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
80106761:	e8 aa d1 ff ff       	call   80103910 <myproc>
80106766:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106769:	e8 a2 d1 ff ff       	call   80103910 <myproc>
		cprintf("pid %d %s: trap %d err %d on cpu %d "
8010676e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106771:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106774:	51                   	push   %ecx
80106775:	53                   	push   %ebx
80106776:	52                   	push   %edx
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
80106777:	8b 55 e0             	mov    -0x20(%ebp),%edx
		cprintf("pid %d %s: trap %d err %d on cpu %d "
8010677a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010677d:	56                   	push   %esi
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
8010677e:	83 c2 6c             	add    $0x6c,%edx
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106781:	52                   	push   %edx
80106782:	ff 70 10             	pushl  0x10(%eax)
80106785:	68 94 89 10 80       	push   $0x80108994
8010678a:	e8 d1 9e ff ff       	call   80100660 <cprintf>
		myproc()->killed = 1;
8010678f:	83 c4 20             	add    $0x20,%esp
80106792:	e8 79 d1 ff ff       	call   80103910 <myproc>
80106797:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
	}

	// Force process exit if it has been killed and is in user space.
	// (If it is still executing in the kernel, let it keep running
	// until it gets to the regular system call return.)
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
8010679e:	e8 6d d1 ff ff       	call   80103910 <myproc>
801067a3:	85 c0                	test   %eax,%eax
801067a5:	74 1d                	je     801067c4 <trap+0xc4>
801067a7:	e8 64 d1 ff ff       	call   80103910 <myproc>
801067ac:	8b 50 24             	mov    0x24(%eax),%edx
801067af:	85 d2                	test   %edx,%edx
801067b1:	74 11                	je     801067c4 <trap+0xc4>
801067b3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801067b7:	83 e0 03             	and    $0x3,%eax
801067ba:	66 83 f8 03          	cmp    $0x3,%ax
801067be:	0f 84 4c 01 00 00    	je     80106910 <trap+0x210>

	// Force process to give up CPU on clock tick.
	// If interrupts were on while locks held, would need to check nlock.
	if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER) yield();
801067c4:	e8 47 d1 ff ff       	call   80103910 <myproc>
801067c9:	85 c0                	test   %eax,%eax
801067cb:	74 0b                	je     801067d8 <trap+0xd8>
801067cd:	e8 3e d1 ff ff       	call   80103910 <myproc>
801067d2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801067d6:	74 68                	je     80106840 <trap+0x140>

	// Check if the process has been killed since we yielded
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801067d8:	e8 33 d1 ff ff       	call   80103910 <myproc>
801067dd:	85 c0                	test   %eax,%eax
801067df:	74 19                	je     801067fa <trap+0xfa>
801067e1:	e8 2a d1 ff ff       	call   80103910 <myproc>
801067e6:	8b 40 24             	mov    0x24(%eax),%eax
801067e9:	85 c0                	test   %eax,%eax
801067eb:	74 0d                	je     801067fa <trap+0xfa>
801067ed:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801067f1:	83 e0 03             	and    $0x3,%eax
801067f4:	66 83 f8 03          	cmp    $0x3,%ax
801067f8:	74 37                	je     80106831 <trap+0x131>
}
801067fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067fd:	5b                   	pop    %ebx
801067fe:	5e                   	pop    %esi
801067ff:	5f                   	pop    %edi
80106800:	5d                   	pop    %ebp
80106801:	c3                   	ret    
80106802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (myproc()->killed) exit();
80106808:	e8 03 d1 ff ff       	call   80103910 <myproc>
8010680d:	8b 58 24             	mov    0x24(%eax),%ebx
80106810:	85 db                	test   %ebx,%ebx
80106812:	0f 85 e8 00 00 00    	jne    80106900 <trap+0x200>
		myproc()->tf = tf;
80106818:	e8 f3 d0 ff ff       	call   80103910 <myproc>
8010681d:	89 78 18             	mov    %edi,0x18(%eax)
		syscall();
80106820:	e8 4b e8 ff ff       	call   80105070 <syscall>
		if (myproc()->killed) exit();
80106825:	e8 e6 d0 ff ff       	call   80103910 <myproc>
8010682a:	8b 48 24             	mov    0x24(%eax),%ecx
8010682d:	85 c9                	test   %ecx,%ecx
8010682f:	74 c9                	je     801067fa <trap+0xfa>
}
80106831:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106834:	5b                   	pop    %ebx
80106835:	5e                   	pop    %esi
80106836:	5f                   	pop    %edi
80106837:	5d                   	pop    %ebp
		if (myproc()->killed) exit();
80106838:	e9 d3 d7 ff ff       	jmp    80104010 <exit>
8010683d:	8d 76 00             	lea    0x0(%esi),%esi
	if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER) yield();
80106840:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106844:	75 92                	jne    801067d8 <trap+0xd8>
80106846:	e8 85 d9 ff ff       	call   801041d0 <yield>
8010684b:	eb 8b                	jmp    801067d8 <trap+0xd8>
8010684d:	8d 76 00             	lea    0x0(%esi),%esi
		if (cpuid() == 0) {
80106850:	e8 9b d0 ff ff       	call   801038f0 <cpuid>
80106855:	85 c0                	test   %eax,%eax
80106857:	0f 84 c3 00 00 00    	je     80106920 <trap+0x220>
		lapiceoi();
8010685d:	e8 2e bf ff ff       	call   80102790 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80106862:	e8 a9 d0 ff ff       	call   80103910 <myproc>
80106867:	85 c0                	test   %eax,%eax
80106869:	0f 85 38 ff ff ff    	jne    801067a7 <trap+0xa7>
8010686f:	e9 50 ff ff ff       	jmp    801067c4 <trap+0xc4>
80106874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		kbdintr();
80106878:	e8 d3 bd ff ff       	call   80102650 <kbdintr>
		lapiceoi();
8010687d:	e8 0e bf ff ff       	call   80102790 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80106882:	e8 89 d0 ff ff       	call   80103910 <myproc>
80106887:	85 c0                	test   %eax,%eax
80106889:	0f 85 18 ff ff ff    	jne    801067a7 <trap+0xa7>
8010688f:	e9 30 ff ff ff       	jmp    801067c4 <trap+0xc4>
80106894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		uartintr();
80106898:	e8 53 02 00 00       	call   80106af0 <uartintr>
		lapiceoi();
8010689d:	e8 ee be ff ff       	call   80102790 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801068a2:	e8 69 d0 ff ff       	call   80103910 <myproc>
801068a7:	85 c0                	test   %eax,%eax
801068a9:	0f 85 f8 fe ff ff    	jne    801067a7 <trap+0xa7>
801068af:	e9 10 ff ff ff       	jmp    801067c4 <trap+0xc4>
801068b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("cpu%d: spurious interrupt at %x:%x\n", cpuid(), tf->cs, tf->eip);
801068b8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801068bc:	8b 77 38             	mov    0x38(%edi),%esi
801068bf:	e8 2c d0 ff ff       	call   801038f0 <cpuid>
801068c4:	56                   	push   %esi
801068c5:	53                   	push   %ebx
801068c6:	50                   	push   %eax
801068c7:	68 3c 89 10 80       	push   $0x8010893c
801068cc:	e8 8f 9d ff ff       	call   80100660 <cprintf>
		lapiceoi();
801068d1:	e8 ba be ff ff       	call   80102790 <lapiceoi>
		break;
801068d6:	83 c4 10             	add    $0x10,%esp
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801068d9:	e8 32 d0 ff ff       	call   80103910 <myproc>
801068de:	85 c0                	test   %eax,%eax
801068e0:	0f 85 c1 fe ff ff    	jne    801067a7 <trap+0xa7>
801068e6:	e9 d9 fe ff ff       	jmp    801067c4 <trap+0xc4>
801068eb:	90                   	nop
801068ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		ideintr();
801068f0:	e8 cb b7 ff ff       	call   801020c0 <ideintr>
801068f5:	e9 63 ff ff ff       	jmp    8010685d <trap+0x15d>
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (myproc()->killed) exit();
80106900:	e8 0b d7 ff ff       	call   80104010 <exit>
80106905:	e9 0e ff ff ff       	jmp    80106818 <trap+0x118>
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80106910:	e8 fb d6 ff ff       	call   80104010 <exit>
80106915:	e9 aa fe ff ff       	jmp    801067c4 <trap+0xc4>
8010691a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			acquire(&tickslock);
80106920:	83 ec 0c             	sub    $0xc,%esp
80106923:	68 c0 fc 12 80       	push   $0x8012fcc0
80106928:	e8 d3 e1 ff ff       	call   80104b00 <acquire>
			wakeup(&ticks);
8010692d:	c7 04 24 00 05 13 80 	movl   $0x80130500,(%esp)
			ticks++;
80106934:	83 05 00 05 13 80 01 	addl   $0x1,0x80130500
			wakeup(&ticks);
8010693b:	e8 30 db ff ff       	call   80104470 <wakeup>
			release(&tickslock);
80106940:	c7 04 24 c0 fc 12 80 	movl   $0x8012fcc0,(%esp)
80106947:	e8 d4 e2 ff ff       	call   80104c20 <release>
8010694c:	83 c4 10             	add    $0x10,%esp
8010694f:	e9 09 ff ff ff       	jmp    8010685d <trap+0x15d>
80106954:	0f 20 d6             	mov    %cr2,%esi
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno, cpuid(), tf->eip,
80106957:	e8 94 cf ff ff       	call   801038f0 <cpuid>
8010695c:	83 ec 0c             	sub    $0xc,%esp
8010695f:	56                   	push   %esi
80106960:	53                   	push   %ebx
80106961:	50                   	push   %eax
80106962:	ff 77 30             	pushl  0x30(%edi)
80106965:	68 60 89 10 80       	push   $0x80108960
8010696a:	e8 f1 9c ff ff       	call   80100660 <cprintf>
			panic("trap");
8010696f:	83 c4 14             	add    $0x14,%esp
80106972:	68 35 89 10 80       	push   $0x80108935
80106977:	e8 14 9a ff ff       	call   80100390 <panic>
8010697c:	66 90                	xchg   %ax,%ax
8010697e:	66 90                	xchg   %ax,%ax

80106980 <uartgetc>:
}

static int
uartgetc(void)
{
	if (!uart) return -1;
80106980:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
{
80106985:	55                   	push   %ebp
80106986:	89 e5                	mov    %esp,%ebp
	if (!uart) return -1;
80106988:	85 c0                	test   %eax,%eax
8010698a:	74 1c                	je     801069a8 <uartgetc+0x28>
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010698c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106991:	ec                   	in     (%dx),%al
	if (!(inb(COM1 + 5) & 0x01)) return -1;
80106992:	a8 01                	test   $0x1,%al
80106994:	74 12                	je     801069a8 <uartgetc+0x28>
80106996:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010699b:	ec                   	in     (%dx),%al
	return inb(COM1 + 0);
8010699c:	0f b6 c0             	movzbl %al,%eax
}
8010699f:	5d                   	pop    %ebp
801069a0:	c3                   	ret    
801069a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (!uart) return -1;
801069a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801069ad:	5d                   	pop    %ebp
801069ae:	c3                   	ret    
801069af:	90                   	nop

801069b0 <uartputc.part.0>:
uartputc(int c)
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
801069b6:	89 c7                	mov    %eax,%edi
801069b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801069bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801069c2:	83 ec 0c             	sub    $0xc,%esp
801069c5:	eb 1b                	jmp    801069e2 <uartputc.part.0+0x32>
801069c7:	89 f6                	mov    %esi,%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) microdelay(10);
801069d0:	83 ec 0c             	sub    $0xc,%esp
801069d3:	6a 0a                	push   $0xa
801069d5:	e8 d6 bd ff ff       	call   801027b0 <microdelay>
801069da:	83 c4 10             	add    $0x10,%esp
801069dd:	83 eb 01             	sub    $0x1,%ebx
801069e0:	74 07                	je     801069e9 <uartputc.part.0+0x39>
801069e2:	89 f2                	mov    %esi,%edx
801069e4:	ec                   	in     (%dx),%al
801069e5:	a8 20                	test   $0x20,%al
801069e7:	74 e7                	je     801069d0 <uartputc.part.0+0x20>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801069e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069ee:	89 f8                	mov    %edi,%eax
801069f0:	ee                   	out    %al,(%dx)
}
801069f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f4:	5b                   	pop    %ebx
801069f5:	5e                   	pop    %esi
801069f6:	5f                   	pop    %edi
801069f7:	5d                   	pop    %ebp
801069f8:	c3                   	ret    
801069f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a00 <uartinit>:
{
80106a00:	55                   	push   %ebp
80106a01:	31 c9                	xor    %ecx,%ecx
80106a03:	89 c8                	mov    %ecx,%eax
80106a05:	89 e5                	mov    %esp,%ebp
80106a07:	57                   	push   %edi
80106a08:	56                   	push   %esi
80106a09:	53                   	push   %ebx
80106a0a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106a0f:	89 da                	mov    %ebx,%edx
80106a11:	83 ec 0c             	sub    $0xc,%esp
80106a14:	ee                   	out    %al,(%dx)
80106a15:	bf fb 03 00 00       	mov    $0x3fb,%edi
80106a1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106a1f:	89 fa                	mov    %edi,%edx
80106a21:	ee                   	out    %al,(%dx)
80106a22:	b8 0c 00 00 00       	mov    $0xc,%eax
80106a27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a2c:	ee                   	out    %al,(%dx)
80106a2d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106a32:	89 c8                	mov    %ecx,%eax
80106a34:	89 f2                	mov    %esi,%edx
80106a36:	ee                   	out    %al,(%dx)
80106a37:	b8 03 00 00 00       	mov    $0x3,%eax
80106a3c:	89 fa                	mov    %edi,%edx
80106a3e:	ee                   	out    %al,(%dx)
80106a3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106a44:	89 c8                	mov    %ecx,%eax
80106a46:	ee                   	out    %al,(%dx)
80106a47:	b8 01 00 00 00       	mov    $0x1,%eax
80106a4c:	89 f2                	mov    %esi,%edx
80106a4e:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80106a4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106a54:	ec                   	in     (%dx),%al
	if (inb(COM1 + 5) == 0xFF) return;
80106a55:	3c ff                	cmp    $0xff,%al
80106a57:	74 5a                	je     80106ab3 <uartinit+0xb3>
	uart = 1;
80106a59:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106a60:	00 00 00 
80106a63:	89 da                	mov    %ebx,%edx
80106a65:	ec                   	in     (%dx),%al
80106a66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106a6b:	ec                   	in     (%dx),%al
	ioapicenable(IRQ_COM1, 0);
80106a6c:	83 ec 08             	sub    $0x8,%esp
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
80106a6f:	bb 58 8a 10 80       	mov    $0x80108a58,%ebx
	ioapicenable(IRQ_COM1, 0);
80106a74:	6a 00                	push   $0x0
80106a76:	6a 04                	push   $0x4
80106a78:	e8 93 b8 ff ff       	call   80102310 <ioapicenable>
80106a7d:	83 c4 10             	add    $0x10,%esp
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
80106a80:	b8 78 00 00 00       	mov    $0x78,%eax
80106a85:	eb 13                	jmp    80106a9a <uartinit+0x9a>
80106a87:	89 f6                	mov    %esi,%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a90:	83 c3 01             	add    $0x1,%ebx
80106a93:	0f be 03             	movsbl (%ebx),%eax
80106a96:	84 c0                	test   %al,%al
80106a98:	74 19                	je     80106ab3 <uartinit+0xb3>
	if (!uart) return;
80106a9a:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80106aa0:	85 d2                	test   %edx,%edx
80106aa2:	74 ec                	je     80106a90 <uartinit+0x90>
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
80106aa4:	83 c3 01             	add    $0x1,%ebx
80106aa7:	e8 04 ff ff ff       	call   801069b0 <uartputc.part.0>
80106aac:	0f be 03             	movsbl (%ebx),%eax
80106aaf:	84 c0                	test   %al,%al
80106ab1:	75 e7                	jne    80106a9a <uartinit+0x9a>
}
80106ab3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ab6:	5b                   	pop    %ebx
80106ab7:	5e                   	pop    %esi
80106ab8:	5f                   	pop    %edi
80106ab9:	5d                   	pop    %ebp
80106aba:	c3                   	ret    
80106abb:	90                   	nop
80106abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <uartputc>:
	if (!uart) return;
80106ac0:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
80106ac6:	55                   	push   %ebp
80106ac7:	89 e5                	mov    %esp,%ebp
	if (!uart) return;
80106ac9:	85 d2                	test   %edx,%edx
{
80106acb:	8b 45 08             	mov    0x8(%ebp),%eax
	if (!uart) return;
80106ace:	74 10                	je     80106ae0 <uartputc+0x20>
}
80106ad0:	5d                   	pop    %ebp
80106ad1:	e9 da fe ff ff       	jmp    801069b0 <uartputc.part.0>
80106ad6:	8d 76 00             	lea    0x0(%esi),%esi
80106ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106ae0:	5d                   	pop    %ebp
80106ae1:	c3                   	ret    
80106ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106af0 <uartintr>:

void
uartintr(void)
{
80106af0:	55                   	push   %ebp
80106af1:	89 e5                	mov    %esp,%ebp
80106af3:	83 ec 14             	sub    $0x14,%esp
	consoleintr(uartgetc);
80106af6:	68 80 69 10 80       	push   $0x80106980
80106afb:	e8 10 9d ff ff       	call   80100810 <consoleintr>
}
80106b00:	83 c4 10             	add    $0x10,%esp
80106b03:	c9                   	leave  
80106b04:	c3                   	ret    

80106b05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106b05:	6a 00                	push   $0x0
  pushl $0
80106b07:	6a 00                	push   $0x0
  jmp alltraps
80106b09:	e9 19 fb ff ff       	jmp    80106627 <alltraps>

80106b0e <vector1>:
.globl vector1
vector1:
  pushl $0
80106b0e:	6a 00                	push   $0x0
  pushl $1
80106b10:	6a 01                	push   $0x1
  jmp alltraps
80106b12:	e9 10 fb ff ff       	jmp    80106627 <alltraps>

80106b17 <vector2>:
.globl vector2
vector2:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $2
80106b19:	6a 02                	push   $0x2
  jmp alltraps
80106b1b:	e9 07 fb ff ff       	jmp    80106627 <alltraps>

80106b20 <vector3>:
.globl vector3
vector3:
  pushl $0
80106b20:	6a 00                	push   $0x0
  pushl $3
80106b22:	6a 03                	push   $0x3
  jmp alltraps
80106b24:	e9 fe fa ff ff       	jmp    80106627 <alltraps>

80106b29 <vector4>:
.globl vector4
vector4:
  pushl $0
80106b29:	6a 00                	push   $0x0
  pushl $4
80106b2b:	6a 04                	push   $0x4
  jmp alltraps
80106b2d:	e9 f5 fa ff ff       	jmp    80106627 <alltraps>

80106b32 <vector5>:
.globl vector5
vector5:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $5
80106b34:	6a 05                	push   $0x5
  jmp alltraps
80106b36:	e9 ec fa ff ff       	jmp    80106627 <alltraps>

80106b3b <vector6>:
.globl vector6
vector6:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $6
80106b3d:	6a 06                	push   $0x6
  jmp alltraps
80106b3f:	e9 e3 fa ff ff       	jmp    80106627 <alltraps>

80106b44 <vector7>:
.globl vector7
vector7:
  pushl $0
80106b44:	6a 00                	push   $0x0
  pushl $7
80106b46:	6a 07                	push   $0x7
  jmp alltraps
80106b48:	e9 da fa ff ff       	jmp    80106627 <alltraps>

80106b4d <vector8>:
.globl vector8
vector8:
  pushl $8
80106b4d:	6a 08                	push   $0x8
  jmp alltraps
80106b4f:	e9 d3 fa ff ff       	jmp    80106627 <alltraps>

80106b54 <vector9>:
.globl vector9
vector9:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $9
80106b56:	6a 09                	push   $0x9
  jmp alltraps
80106b58:	e9 ca fa ff ff       	jmp    80106627 <alltraps>

80106b5d <vector10>:
.globl vector10
vector10:
  pushl $10
80106b5d:	6a 0a                	push   $0xa
  jmp alltraps
80106b5f:	e9 c3 fa ff ff       	jmp    80106627 <alltraps>

80106b64 <vector11>:
.globl vector11
vector11:
  pushl $11
80106b64:	6a 0b                	push   $0xb
  jmp alltraps
80106b66:	e9 bc fa ff ff       	jmp    80106627 <alltraps>

80106b6b <vector12>:
.globl vector12
vector12:
  pushl $12
80106b6b:	6a 0c                	push   $0xc
  jmp alltraps
80106b6d:	e9 b5 fa ff ff       	jmp    80106627 <alltraps>

80106b72 <vector13>:
.globl vector13
vector13:
  pushl $13
80106b72:	6a 0d                	push   $0xd
  jmp alltraps
80106b74:	e9 ae fa ff ff       	jmp    80106627 <alltraps>

80106b79 <vector14>:
.globl vector14
vector14:
  pushl $14
80106b79:	6a 0e                	push   $0xe
  jmp alltraps
80106b7b:	e9 a7 fa ff ff       	jmp    80106627 <alltraps>

80106b80 <vector15>:
.globl vector15
vector15:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $15
80106b82:	6a 0f                	push   $0xf
  jmp alltraps
80106b84:	e9 9e fa ff ff       	jmp    80106627 <alltraps>

80106b89 <vector16>:
.globl vector16
vector16:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $16
80106b8b:	6a 10                	push   $0x10
  jmp alltraps
80106b8d:	e9 95 fa ff ff       	jmp    80106627 <alltraps>

80106b92 <vector17>:
.globl vector17
vector17:
  pushl $17
80106b92:	6a 11                	push   $0x11
  jmp alltraps
80106b94:	e9 8e fa ff ff       	jmp    80106627 <alltraps>

80106b99 <vector18>:
.globl vector18
vector18:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $18
80106b9b:	6a 12                	push   $0x12
  jmp alltraps
80106b9d:	e9 85 fa ff ff       	jmp    80106627 <alltraps>

80106ba2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $19
80106ba4:	6a 13                	push   $0x13
  jmp alltraps
80106ba6:	e9 7c fa ff ff       	jmp    80106627 <alltraps>

80106bab <vector20>:
.globl vector20
vector20:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $20
80106bad:	6a 14                	push   $0x14
  jmp alltraps
80106baf:	e9 73 fa ff ff       	jmp    80106627 <alltraps>

80106bb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $21
80106bb6:	6a 15                	push   $0x15
  jmp alltraps
80106bb8:	e9 6a fa ff ff       	jmp    80106627 <alltraps>

80106bbd <vector22>:
.globl vector22
vector22:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $22
80106bbf:	6a 16                	push   $0x16
  jmp alltraps
80106bc1:	e9 61 fa ff ff       	jmp    80106627 <alltraps>

80106bc6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $23
80106bc8:	6a 17                	push   $0x17
  jmp alltraps
80106bca:	e9 58 fa ff ff       	jmp    80106627 <alltraps>

80106bcf <vector24>:
.globl vector24
vector24:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $24
80106bd1:	6a 18                	push   $0x18
  jmp alltraps
80106bd3:	e9 4f fa ff ff       	jmp    80106627 <alltraps>

80106bd8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $25
80106bda:	6a 19                	push   $0x19
  jmp alltraps
80106bdc:	e9 46 fa ff ff       	jmp    80106627 <alltraps>

80106be1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $26
80106be3:	6a 1a                	push   $0x1a
  jmp alltraps
80106be5:	e9 3d fa ff ff       	jmp    80106627 <alltraps>

80106bea <vector27>:
.globl vector27
vector27:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $27
80106bec:	6a 1b                	push   $0x1b
  jmp alltraps
80106bee:	e9 34 fa ff ff       	jmp    80106627 <alltraps>

80106bf3 <vector28>:
.globl vector28
vector28:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $28
80106bf5:	6a 1c                	push   $0x1c
  jmp alltraps
80106bf7:	e9 2b fa ff ff       	jmp    80106627 <alltraps>

80106bfc <vector29>:
.globl vector29
vector29:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $29
80106bfe:	6a 1d                	push   $0x1d
  jmp alltraps
80106c00:	e9 22 fa ff ff       	jmp    80106627 <alltraps>

80106c05 <vector30>:
.globl vector30
vector30:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $30
80106c07:	6a 1e                	push   $0x1e
  jmp alltraps
80106c09:	e9 19 fa ff ff       	jmp    80106627 <alltraps>

80106c0e <vector31>:
.globl vector31
vector31:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $31
80106c10:	6a 1f                	push   $0x1f
  jmp alltraps
80106c12:	e9 10 fa ff ff       	jmp    80106627 <alltraps>

80106c17 <vector32>:
.globl vector32
vector32:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $32
80106c19:	6a 20                	push   $0x20
  jmp alltraps
80106c1b:	e9 07 fa ff ff       	jmp    80106627 <alltraps>

80106c20 <vector33>:
.globl vector33
vector33:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $33
80106c22:	6a 21                	push   $0x21
  jmp alltraps
80106c24:	e9 fe f9 ff ff       	jmp    80106627 <alltraps>

80106c29 <vector34>:
.globl vector34
vector34:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $34
80106c2b:	6a 22                	push   $0x22
  jmp alltraps
80106c2d:	e9 f5 f9 ff ff       	jmp    80106627 <alltraps>

80106c32 <vector35>:
.globl vector35
vector35:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $35
80106c34:	6a 23                	push   $0x23
  jmp alltraps
80106c36:	e9 ec f9 ff ff       	jmp    80106627 <alltraps>

80106c3b <vector36>:
.globl vector36
vector36:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $36
80106c3d:	6a 24                	push   $0x24
  jmp alltraps
80106c3f:	e9 e3 f9 ff ff       	jmp    80106627 <alltraps>

80106c44 <vector37>:
.globl vector37
vector37:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $37
80106c46:	6a 25                	push   $0x25
  jmp alltraps
80106c48:	e9 da f9 ff ff       	jmp    80106627 <alltraps>

80106c4d <vector38>:
.globl vector38
vector38:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $38
80106c4f:	6a 26                	push   $0x26
  jmp alltraps
80106c51:	e9 d1 f9 ff ff       	jmp    80106627 <alltraps>

80106c56 <vector39>:
.globl vector39
vector39:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $39
80106c58:	6a 27                	push   $0x27
  jmp alltraps
80106c5a:	e9 c8 f9 ff ff       	jmp    80106627 <alltraps>

80106c5f <vector40>:
.globl vector40
vector40:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $40
80106c61:	6a 28                	push   $0x28
  jmp alltraps
80106c63:	e9 bf f9 ff ff       	jmp    80106627 <alltraps>

80106c68 <vector41>:
.globl vector41
vector41:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $41
80106c6a:	6a 29                	push   $0x29
  jmp alltraps
80106c6c:	e9 b6 f9 ff ff       	jmp    80106627 <alltraps>

80106c71 <vector42>:
.globl vector42
vector42:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $42
80106c73:	6a 2a                	push   $0x2a
  jmp alltraps
80106c75:	e9 ad f9 ff ff       	jmp    80106627 <alltraps>

80106c7a <vector43>:
.globl vector43
vector43:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $43
80106c7c:	6a 2b                	push   $0x2b
  jmp alltraps
80106c7e:	e9 a4 f9 ff ff       	jmp    80106627 <alltraps>

80106c83 <vector44>:
.globl vector44
vector44:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $44
80106c85:	6a 2c                	push   $0x2c
  jmp alltraps
80106c87:	e9 9b f9 ff ff       	jmp    80106627 <alltraps>

80106c8c <vector45>:
.globl vector45
vector45:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $45
80106c8e:	6a 2d                	push   $0x2d
  jmp alltraps
80106c90:	e9 92 f9 ff ff       	jmp    80106627 <alltraps>

80106c95 <vector46>:
.globl vector46
vector46:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $46
80106c97:	6a 2e                	push   $0x2e
  jmp alltraps
80106c99:	e9 89 f9 ff ff       	jmp    80106627 <alltraps>

80106c9e <vector47>:
.globl vector47
vector47:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $47
80106ca0:	6a 2f                	push   $0x2f
  jmp alltraps
80106ca2:	e9 80 f9 ff ff       	jmp    80106627 <alltraps>

80106ca7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $48
80106ca9:	6a 30                	push   $0x30
  jmp alltraps
80106cab:	e9 77 f9 ff ff       	jmp    80106627 <alltraps>

80106cb0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $49
80106cb2:	6a 31                	push   $0x31
  jmp alltraps
80106cb4:	e9 6e f9 ff ff       	jmp    80106627 <alltraps>

80106cb9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $50
80106cbb:	6a 32                	push   $0x32
  jmp alltraps
80106cbd:	e9 65 f9 ff ff       	jmp    80106627 <alltraps>

80106cc2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $51
80106cc4:	6a 33                	push   $0x33
  jmp alltraps
80106cc6:	e9 5c f9 ff ff       	jmp    80106627 <alltraps>

80106ccb <vector52>:
.globl vector52
vector52:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $52
80106ccd:	6a 34                	push   $0x34
  jmp alltraps
80106ccf:	e9 53 f9 ff ff       	jmp    80106627 <alltraps>

80106cd4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $53
80106cd6:	6a 35                	push   $0x35
  jmp alltraps
80106cd8:	e9 4a f9 ff ff       	jmp    80106627 <alltraps>

80106cdd <vector54>:
.globl vector54
vector54:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $54
80106cdf:	6a 36                	push   $0x36
  jmp alltraps
80106ce1:	e9 41 f9 ff ff       	jmp    80106627 <alltraps>

80106ce6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $55
80106ce8:	6a 37                	push   $0x37
  jmp alltraps
80106cea:	e9 38 f9 ff ff       	jmp    80106627 <alltraps>

80106cef <vector56>:
.globl vector56
vector56:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $56
80106cf1:	6a 38                	push   $0x38
  jmp alltraps
80106cf3:	e9 2f f9 ff ff       	jmp    80106627 <alltraps>

80106cf8 <vector57>:
.globl vector57
vector57:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $57
80106cfa:	6a 39                	push   $0x39
  jmp alltraps
80106cfc:	e9 26 f9 ff ff       	jmp    80106627 <alltraps>

80106d01 <vector58>:
.globl vector58
vector58:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $58
80106d03:	6a 3a                	push   $0x3a
  jmp alltraps
80106d05:	e9 1d f9 ff ff       	jmp    80106627 <alltraps>

80106d0a <vector59>:
.globl vector59
vector59:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $59
80106d0c:	6a 3b                	push   $0x3b
  jmp alltraps
80106d0e:	e9 14 f9 ff ff       	jmp    80106627 <alltraps>

80106d13 <vector60>:
.globl vector60
vector60:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $60
80106d15:	6a 3c                	push   $0x3c
  jmp alltraps
80106d17:	e9 0b f9 ff ff       	jmp    80106627 <alltraps>

80106d1c <vector61>:
.globl vector61
vector61:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $61
80106d1e:	6a 3d                	push   $0x3d
  jmp alltraps
80106d20:	e9 02 f9 ff ff       	jmp    80106627 <alltraps>

80106d25 <vector62>:
.globl vector62
vector62:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $62
80106d27:	6a 3e                	push   $0x3e
  jmp alltraps
80106d29:	e9 f9 f8 ff ff       	jmp    80106627 <alltraps>

80106d2e <vector63>:
.globl vector63
vector63:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $63
80106d30:	6a 3f                	push   $0x3f
  jmp alltraps
80106d32:	e9 f0 f8 ff ff       	jmp    80106627 <alltraps>

80106d37 <vector64>:
.globl vector64
vector64:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $64
80106d39:	6a 40                	push   $0x40
  jmp alltraps
80106d3b:	e9 e7 f8 ff ff       	jmp    80106627 <alltraps>

80106d40 <vector65>:
.globl vector65
vector65:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $65
80106d42:	6a 41                	push   $0x41
  jmp alltraps
80106d44:	e9 de f8 ff ff       	jmp    80106627 <alltraps>

80106d49 <vector66>:
.globl vector66
vector66:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $66
80106d4b:	6a 42                	push   $0x42
  jmp alltraps
80106d4d:	e9 d5 f8 ff ff       	jmp    80106627 <alltraps>

80106d52 <vector67>:
.globl vector67
vector67:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $67
80106d54:	6a 43                	push   $0x43
  jmp alltraps
80106d56:	e9 cc f8 ff ff       	jmp    80106627 <alltraps>

80106d5b <vector68>:
.globl vector68
vector68:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $68
80106d5d:	6a 44                	push   $0x44
  jmp alltraps
80106d5f:	e9 c3 f8 ff ff       	jmp    80106627 <alltraps>

80106d64 <vector69>:
.globl vector69
vector69:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $69
80106d66:	6a 45                	push   $0x45
  jmp alltraps
80106d68:	e9 ba f8 ff ff       	jmp    80106627 <alltraps>

80106d6d <vector70>:
.globl vector70
vector70:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $70
80106d6f:	6a 46                	push   $0x46
  jmp alltraps
80106d71:	e9 b1 f8 ff ff       	jmp    80106627 <alltraps>

80106d76 <vector71>:
.globl vector71
vector71:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $71
80106d78:	6a 47                	push   $0x47
  jmp alltraps
80106d7a:	e9 a8 f8 ff ff       	jmp    80106627 <alltraps>

80106d7f <vector72>:
.globl vector72
vector72:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $72
80106d81:	6a 48                	push   $0x48
  jmp alltraps
80106d83:	e9 9f f8 ff ff       	jmp    80106627 <alltraps>

80106d88 <vector73>:
.globl vector73
vector73:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $73
80106d8a:	6a 49                	push   $0x49
  jmp alltraps
80106d8c:	e9 96 f8 ff ff       	jmp    80106627 <alltraps>

80106d91 <vector74>:
.globl vector74
vector74:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $74
80106d93:	6a 4a                	push   $0x4a
  jmp alltraps
80106d95:	e9 8d f8 ff ff       	jmp    80106627 <alltraps>

80106d9a <vector75>:
.globl vector75
vector75:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $75
80106d9c:	6a 4b                	push   $0x4b
  jmp alltraps
80106d9e:	e9 84 f8 ff ff       	jmp    80106627 <alltraps>

80106da3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $76
80106da5:	6a 4c                	push   $0x4c
  jmp alltraps
80106da7:	e9 7b f8 ff ff       	jmp    80106627 <alltraps>

80106dac <vector77>:
.globl vector77
vector77:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $77
80106dae:	6a 4d                	push   $0x4d
  jmp alltraps
80106db0:	e9 72 f8 ff ff       	jmp    80106627 <alltraps>

80106db5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $78
80106db7:	6a 4e                	push   $0x4e
  jmp alltraps
80106db9:	e9 69 f8 ff ff       	jmp    80106627 <alltraps>

80106dbe <vector79>:
.globl vector79
vector79:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $79
80106dc0:	6a 4f                	push   $0x4f
  jmp alltraps
80106dc2:	e9 60 f8 ff ff       	jmp    80106627 <alltraps>

80106dc7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $80
80106dc9:	6a 50                	push   $0x50
  jmp alltraps
80106dcb:	e9 57 f8 ff ff       	jmp    80106627 <alltraps>

80106dd0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $81
80106dd2:	6a 51                	push   $0x51
  jmp alltraps
80106dd4:	e9 4e f8 ff ff       	jmp    80106627 <alltraps>

80106dd9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $82
80106ddb:	6a 52                	push   $0x52
  jmp alltraps
80106ddd:	e9 45 f8 ff ff       	jmp    80106627 <alltraps>

80106de2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $83
80106de4:	6a 53                	push   $0x53
  jmp alltraps
80106de6:	e9 3c f8 ff ff       	jmp    80106627 <alltraps>

80106deb <vector84>:
.globl vector84
vector84:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $84
80106ded:	6a 54                	push   $0x54
  jmp alltraps
80106def:	e9 33 f8 ff ff       	jmp    80106627 <alltraps>

80106df4 <vector85>:
.globl vector85
vector85:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $85
80106df6:	6a 55                	push   $0x55
  jmp alltraps
80106df8:	e9 2a f8 ff ff       	jmp    80106627 <alltraps>

80106dfd <vector86>:
.globl vector86
vector86:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $86
80106dff:	6a 56                	push   $0x56
  jmp alltraps
80106e01:	e9 21 f8 ff ff       	jmp    80106627 <alltraps>

80106e06 <vector87>:
.globl vector87
vector87:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $87
80106e08:	6a 57                	push   $0x57
  jmp alltraps
80106e0a:	e9 18 f8 ff ff       	jmp    80106627 <alltraps>

80106e0f <vector88>:
.globl vector88
vector88:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $88
80106e11:	6a 58                	push   $0x58
  jmp alltraps
80106e13:	e9 0f f8 ff ff       	jmp    80106627 <alltraps>

80106e18 <vector89>:
.globl vector89
vector89:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $89
80106e1a:	6a 59                	push   $0x59
  jmp alltraps
80106e1c:	e9 06 f8 ff ff       	jmp    80106627 <alltraps>

80106e21 <vector90>:
.globl vector90
vector90:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $90
80106e23:	6a 5a                	push   $0x5a
  jmp alltraps
80106e25:	e9 fd f7 ff ff       	jmp    80106627 <alltraps>

80106e2a <vector91>:
.globl vector91
vector91:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $91
80106e2c:	6a 5b                	push   $0x5b
  jmp alltraps
80106e2e:	e9 f4 f7 ff ff       	jmp    80106627 <alltraps>

80106e33 <vector92>:
.globl vector92
vector92:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $92
80106e35:	6a 5c                	push   $0x5c
  jmp alltraps
80106e37:	e9 eb f7 ff ff       	jmp    80106627 <alltraps>

80106e3c <vector93>:
.globl vector93
vector93:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $93
80106e3e:	6a 5d                	push   $0x5d
  jmp alltraps
80106e40:	e9 e2 f7 ff ff       	jmp    80106627 <alltraps>

80106e45 <vector94>:
.globl vector94
vector94:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $94
80106e47:	6a 5e                	push   $0x5e
  jmp alltraps
80106e49:	e9 d9 f7 ff ff       	jmp    80106627 <alltraps>

80106e4e <vector95>:
.globl vector95
vector95:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $95
80106e50:	6a 5f                	push   $0x5f
  jmp alltraps
80106e52:	e9 d0 f7 ff ff       	jmp    80106627 <alltraps>

80106e57 <vector96>:
.globl vector96
vector96:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $96
80106e59:	6a 60                	push   $0x60
  jmp alltraps
80106e5b:	e9 c7 f7 ff ff       	jmp    80106627 <alltraps>

80106e60 <vector97>:
.globl vector97
vector97:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $97
80106e62:	6a 61                	push   $0x61
  jmp alltraps
80106e64:	e9 be f7 ff ff       	jmp    80106627 <alltraps>

80106e69 <vector98>:
.globl vector98
vector98:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $98
80106e6b:	6a 62                	push   $0x62
  jmp alltraps
80106e6d:	e9 b5 f7 ff ff       	jmp    80106627 <alltraps>

80106e72 <vector99>:
.globl vector99
vector99:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $99
80106e74:	6a 63                	push   $0x63
  jmp alltraps
80106e76:	e9 ac f7 ff ff       	jmp    80106627 <alltraps>

80106e7b <vector100>:
.globl vector100
vector100:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $100
80106e7d:	6a 64                	push   $0x64
  jmp alltraps
80106e7f:	e9 a3 f7 ff ff       	jmp    80106627 <alltraps>

80106e84 <vector101>:
.globl vector101
vector101:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $101
80106e86:	6a 65                	push   $0x65
  jmp alltraps
80106e88:	e9 9a f7 ff ff       	jmp    80106627 <alltraps>

80106e8d <vector102>:
.globl vector102
vector102:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $102
80106e8f:	6a 66                	push   $0x66
  jmp alltraps
80106e91:	e9 91 f7 ff ff       	jmp    80106627 <alltraps>

80106e96 <vector103>:
.globl vector103
vector103:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $103
80106e98:	6a 67                	push   $0x67
  jmp alltraps
80106e9a:	e9 88 f7 ff ff       	jmp    80106627 <alltraps>

80106e9f <vector104>:
.globl vector104
vector104:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $104
80106ea1:	6a 68                	push   $0x68
  jmp alltraps
80106ea3:	e9 7f f7 ff ff       	jmp    80106627 <alltraps>

80106ea8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $105
80106eaa:	6a 69                	push   $0x69
  jmp alltraps
80106eac:	e9 76 f7 ff ff       	jmp    80106627 <alltraps>

80106eb1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $106
80106eb3:	6a 6a                	push   $0x6a
  jmp alltraps
80106eb5:	e9 6d f7 ff ff       	jmp    80106627 <alltraps>

80106eba <vector107>:
.globl vector107
vector107:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $107
80106ebc:	6a 6b                	push   $0x6b
  jmp alltraps
80106ebe:	e9 64 f7 ff ff       	jmp    80106627 <alltraps>

80106ec3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $108
80106ec5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ec7:	e9 5b f7 ff ff       	jmp    80106627 <alltraps>

80106ecc <vector109>:
.globl vector109
vector109:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $109
80106ece:	6a 6d                	push   $0x6d
  jmp alltraps
80106ed0:	e9 52 f7 ff ff       	jmp    80106627 <alltraps>

80106ed5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $110
80106ed7:	6a 6e                	push   $0x6e
  jmp alltraps
80106ed9:	e9 49 f7 ff ff       	jmp    80106627 <alltraps>

80106ede <vector111>:
.globl vector111
vector111:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $111
80106ee0:	6a 6f                	push   $0x6f
  jmp alltraps
80106ee2:	e9 40 f7 ff ff       	jmp    80106627 <alltraps>

80106ee7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $112
80106ee9:	6a 70                	push   $0x70
  jmp alltraps
80106eeb:	e9 37 f7 ff ff       	jmp    80106627 <alltraps>

80106ef0 <vector113>:
.globl vector113
vector113:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $113
80106ef2:	6a 71                	push   $0x71
  jmp alltraps
80106ef4:	e9 2e f7 ff ff       	jmp    80106627 <alltraps>

80106ef9 <vector114>:
.globl vector114
vector114:
  pushl $0
80106ef9:	6a 00                	push   $0x0
  pushl $114
80106efb:	6a 72                	push   $0x72
  jmp alltraps
80106efd:	e9 25 f7 ff ff       	jmp    80106627 <alltraps>

80106f02 <vector115>:
.globl vector115
vector115:
  pushl $0
80106f02:	6a 00                	push   $0x0
  pushl $115
80106f04:	6a 73                	push   $0x73
  jmp alltraps
80106f06:	e9 1c f7 ff ff       	jmp    80106627 <alltraps>

80106f0b <vector116>:
.globl vector116
vector116:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $116
80106f0d:	6a 74                	push   $0x74
  jmp alltraps
80106f0f:	e9 13 f7 ff ff       	jmp    80106627 <alltraps>

80106f14 <vector117>:
.globl vector117
vector117:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $117
80106f16:	6a 75                	push   $0x75
  jmp alltraps
80106f18:	e9 0a f7 ff ff       	jmp    80106627 <alltraps>

80106f1d <vector118>:
.globl vector118
vector118:
  pushl $0
80106f1d:	6a 00                	push   $0x0
  pushl $118
80106f1f:	6a 76                	push   $0x76
  jmp alltraps
80106f21:	e9 01 f7 ff ff       	jmp    80106627 <alltraps>

80106f26 <vector119>:
.globl vector119
vector119:
  pushl $0
80106f26:	6a 00                	push   $0x0
  pushl $119
80106f28:	6a 77                	push   $0x77
  jmp alltraps
80106f2a:	e9 f8 f6 ff ff       	jmp    80106627 <alltraps>

80106f2f <vector120>:
.globl vector120
vector120:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $120
80106f31:	6a 78                	push   $0x78
  jmp alltraps
80106f33:	e9 ef f6 ff ff       	jmp    80106627 <alltraps>

80106f38 <vector121>:
.globl vector121
vector121:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $121
80106f3a:	6a 79                	push   $0x79
  jmp alltraps
80106f3c:	e9 e6 f6 ff ff       	jmp    80106627 <alltraps>

80106f41 <vector122>:
.globl vector122
vector122:
  pushl $0
80106f41:	6a 00                	push   $0x0
  pushl $122
80106f43:	6a 7a                	push   $0x7a
  jmp alltraps
80106f45:	e9 dd f6 ff ff       	jmp    80106627 <alltraps>

80106f4a <vector123>:
.globl vector123
vector123:
  pushl $0
80106f4a:	6a 00                	push   $0x0
  pushl $123
80106f4c:	6a 7b                	push   $0x7b
  jmp alltraps
80106f4e:	e9 d4 f6 ff ff       	jmp    80106627 <alltraps>

80106f53 <vector124>:
.globl vector124
vector124:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $124
80106f55:	6a 7c                	push   $0x7c
  jmp alltraps
80106f57:	e9 cb f6 ff ff       	jmp    80106627 <alltraps>

80106f5c <vector125>:
.globl vector125
vector125:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $125
80106f5e:	6a 7d                	push   $0x7d
  jmp alltraps
80106f60:	e9 c2 f6 ff ff       	jmp    80106627 <alltraps>

80106f65 <vector126>:
.globl vector126
vector126:
  pushl $0
80106f65:	6a 00                	push   $0x0
  pushl $126
80106f67:	6a 7e                	push   $0x7e
  jmp alltraps
80106f69:	e9 b9 f6 ff ff       	jmp    80106627 <alltraps>

80106f6e <vector127>:
.globl vector127
vector127:
  pushl $0
80106f6e:	6a 00                	push   $0x0
  pushl $127
80106f70:	6a 7f                	push   $0x7f
  jmp alltraps
80106f72:	e9 b0 f6 ff ff       	jmp    80106627 <alltraps>

80106f77 <vector128>:
.globl vector128
vector128:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $128
80106f79:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106f7e:	e9 a4 f6 ff ff       	jmp    80106627 <alltraps>

80106f83 <vector129>:
.globl vector129
vector129:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $129
80106f85:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106f8a:	e9 98 f6 ff ff       	jmp    80106627 <alltraps>

80106f8f <vector130>:
.globl vector130
vector130:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $130
80106f91:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106f96:	e9 8c f6 ff ff       	jmp    80106627 <alltraps>

80106f9b <vector131>:
.globl vector131
vector131:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $131
80106f9d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106fa2:	e9 80 f6 ff ff       	jmp    80106627 <alltraps>

80106fa7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $132
80106fa9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106fae:	e9 74 f6 ff ff       	jmp    80106627 <alltraps>

80106fb3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $133
80106fb5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106fba:	e9 68 f6 ff ff       	jmp    80106627 <alltraps>

80106fbf <vector134>:
.globl vector134
vector134:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $134
80106fc1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106fc6:	e9 5c f6 ff ff       	jmp    80106627 <alltraps>

80106fcb <vector135>:
.globl vector135
vector135:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $135
80106fcd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106fd2:	e9 50 f6 ff ff       	jmp    80106627 <alltraps>

80106fd7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $136
80106fd9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106fde:	e9 44 f6 ff ff       	jmp    80106627 <alltraps>

80106fe3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $137
80106fe5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106fea:	e9 38 f6 ff ff       	jmp    80106627 <alltraps>

80106fef <vector138>:
.globl vector138
vector138:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $138
80106ff1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ff6:	e9 2c f6 ff ff       	jmp    80106627 <alltraps>

80106ffb <vector139>:
.globl vector139
vector139:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $139
80106ffd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107002:	e9 20 f6 ff ff       	jmp    80106627 <alltraps>

80107007 <vector140>:
.globl vector140
vector140:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $140
80107009:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010700e:	e9 14 f6 ff ff       	jmp    80106627 <alltraps>

80107013 <vector141>:
.globl vector141
vector141:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $141
80107015:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010701a:	e9 08 f6 ff ff       	jmp    80106627 <alltraps>

8010701f <vector142>:
.globl vector142
vector142:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $142
80107021:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107026:	e9 fc f5 ff ff       	jmp    80106627 <alltraps>

8010702b <vector143>:
.globl vector143
vector143:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $143
8010702d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107032:	e9 f0 f5 ff ff       	jmp    80106627 <alltraps>

80107037 <vector144>:
.globl vector144
vector144:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $144
80107039:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010703e:	e9 e4 f5 ff ff       	jmp    80106627 <alltraps>

80107043 <vector145>:
.globl vector145
vector145:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $145
80107045:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010704a:	e9 d8 f5 ff ff       	jmp    80106627 <alltraps>

8010704f <vector146>:
.globl vector146
vector146:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $146
80107051:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107056:	e9 cc f5 ff ff       	jmp    80106627 <alltraps>

8010705b <vector147>:
.globl vector147
vector147:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $147
8010705d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107062:	e9 c0 f5 ff ff       	jmp    80106627 <alltraps>

80107067 <vector148>:
.globl vector148
vector148:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $148
80107069:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010706e:	e9 b4 f5 ff ff       	jmp    80106627 <alltraps>

80107073 <vector149>:
.globl vector149
vector149:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $149
80107075:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010707a:	e9 a8 f5 ff ff       	jmp    80106627 <alltraps>

8010707f <vector150>:
.globl vector150
vector150:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $150
80107081:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107086:	e9 9c f5 ff ff       	jmp    80106627 <alltraps>

8010708b <vector151>:
.globl vector151
vector151:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $151
8010708d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107092:	e9 90 f5 ff ff       	jmp    80106627 <alltraps>

80107097 <vector152>:
.globl vector152
vector152:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $152
80107099:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010709e:	e9 84 f5 ff ff       	jmp    80106627 <alltraps>

801070a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $153
801070a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801070aa:	e9 78 f5 ff ff       	jmp    80106627 <alltraps>

801070af <vector154>:
.globl vector154
vector154:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $154
801070b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801070b6:	e9 6c f5 ff ff       	jmp    80106627 <alltraps>

801070bb <vector155>:
.globl vector155
vector155:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $155
801070bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801070c2:	e9 60 f5 ff ff       	jmp    80106627 <alltraps>

801070c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $156
801070c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801070ce:	e9 54 f5 ff ff       	jmp    80106627 <alltraps>

801070d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $157
801070d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801070da:	e9 48 f5 ff ff       	jmp    80106627 <alltraps>

801070df <vector158>:
.globl vector158
vector158:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $158
801070e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801070e6:	e9 3c f5 ff ff       	jmp    80106627 <alltraps>

801070eb <vector159>:
.globl vector159
vector159:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $159
801070ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801070f2:	e9 30 f5 ff ff       	jmp    80106627 <alltraps>

801070f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $160
801070f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801070fe:	e9 24 f5 ff ff       	jmp    80106627 <alltraps>

80107103 <vector161>:
.globl vector161
vector161:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $161
80107105:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010710a:	e9 18 f5 ff ff       	jmp    80106627 <alltraps>

8010710f <vector162>:
.globl vector162
vector162:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $162
80107111:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107116:	e9 0c f5 ff ff       	jmp    80106627 <alltraps>

8010711b <vector163>:
.globl vector163
vector163:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $163
8010711d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107122:	e9 00 f5 ff ff       	jmp    80106627 <alltraps>

80107127 <vector164>:
.globl vector164
vector164:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $164
80107129:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010712e:	e9 f4 f4 ff ff       	jmp    80106627 <alltraps>

80107133 <vector165>:
.globl vector165
vector165:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $165
80107135:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010713a:	e9 e8 f4 ff ff       	jmp    80106627 <alltraps>

8010713f <vector166>:
.globl vector166
vector166:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $166
80107141:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107146:	e9 dc f4 ff ff       	jmp    80106627 <alltraps>

8010714b <vector167>:
.globl vector167
vector167:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $167
8010714d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107152:	e9 d0 f4 ff ff       	jmp    80106627 <alltraps>

80107157 <vector168>:
.globl vector168
vector168:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $168
80107159:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010715e:	e9 c4 f4 ff ff       	jmp    80106627 <alltraps>

80107163 <vector169>:
.globl vector169
vector169:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $169
80107165:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010716a:	e9 b8 f4 ff ff       	jmp    80106627 <alltraps>

8010716f <vector170>:
.globl vector170
vector170:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $170
80107171:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107176:	e9 ac f4 ff ff       	jmp    80106627 <alltraps>

8010717b <vector171>:
.globl vector171
vector171:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $171
8010717d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107182:	e9 a0 f4 ff ff       	jmp    80106627 <alltraps>

80107187 <vector172>:
.globl vector172
vector172:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $172
80107189:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010718e:	e9 94 f4 ff ff       	jmp    80106627 <alltraps>

80107193 <vector173>:
.globl vector173
vector173:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $173
80107195:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010719a:	e9 88 f4 ff ff       	jmp    80106627 <alltraps>

8010719f <vector174>:
.globl vector174
vector174:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $174
801071a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801071a6:	e9 7c f4 ff ff       	jmp    80106627 <alltraps>

801071ab <vector175>:
.globl vector175
vector175:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $175
801071ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801071b2:	e9 70 f4 ff ff       	jmp    80106627 <alltraps>

801071b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $176
801071b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801071be:	e9 64 f4 ff ff       	jmp    80106627 <alltraps>

801071c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $177
801071c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801071ca:	e9 58 f4 ff ff       	jmp    80106627 <alltraps>

801071cf <vector178>:
.globl vector178
vector178:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $178
801071d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801071d6:	e9 4c f4 ff ff       	jmp    80106627 <alltraps>

801071db <vector179>:
.globl vector179
vector179:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $179
801071dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801071e2:	e9 40 f4 ff ff       	jmp    80106627 <alltraps>

801071e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $180
801071e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801071ee:	e9 34 f4 ff ff       	jmp    80106627 <alltraps>

801071f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $181
801071f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801071fa:	e9 28 f4 ff ff       	jmp    80106627 <alltraps>

801071ff <vector182>:
.globl vector182
vector182:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $182
80107201:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107206:	e9 1c f4 ff ff       	jmp    80106627 <alltraps>

8010720b <vector183>:
.globl vector183
vector183:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $183
8010720d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107212:	e9 10 f4 ff ff       	jmp    80106627 <alltraps>

80107217 <vector184>:
.globl vector184
vector184:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $184
80107219:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010721e:	e9 04 f4 ff ff       	jmp    80106627 <alltraps>

80107223 <vector185>:
.globl vector185
vector185:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $185
80107225:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010722a:	e9 f8 f3 ff ff       	jmp    80106627 <alltraps>

8010722f <vector186>:
.globl vector186
vector186:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $186
80107231:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107236:	e9 ec f3 ff ff       	jmp    80106627 <alltraps>

8010723b <vector187>:
.globl vector187
vector187:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $187
8010723d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107242:	e9 e0 f3 ff ff       	jmp    80106627 <alltraps>

80107247 <vector188>:
.globl vector188
vector188:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $188
80107249:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010724e:	e9 d4 f3 ff ff       	jmp    80106627 <alltraps>

80107253 <vector189>:
.globl vector189
vector189:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $189
80107255:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010725a:	e9 c8 f3 ff ff       	jmp    80106627 <alltraps>

8010725f <vector190>:
.globl vector190
vector190:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $190
80107261:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107266:	e9 bc f3 ff ff       	jmp    80106627 <alltraps>

8010726b <vector191>:
.globl vector191
vector191:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $191
8010726d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107272:	e9 b0 f3 ff ff       	jmp    80106627 <alltraps>

80107277 <vector192>:
.globl vector192
vector192:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $192
80107279:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010727e:	e9 a4 f3 ff ff       	jmp    80106627 <alltraps>

80107283 <vector193>:
.globl vector193
vector193:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $193
80107285:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010728a:	e9 98 f3 ff ff       	jmp    80106627 <alltraps>

8010728f <vector194>:
.globl vector194
vector194:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $194
80107291:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107296:	e9 8c f3 ff ff       	jmp    80106627 <alltraps>

8010729b <vector195>:
.globl vector195
vector195:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $195
8010729d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801072a2:	e9 80 f3 ff ff       	jmp    80106627 <alltraps>

801072a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $196
801072a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801072ae:	e9 74 f3 ff ff       	jmp    80106627 <alltraps>

801072b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $197
801072b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801072ba:	e9 68 f3 ff ff       	jmp    80106627 <alltraps>

801072bf <vector198>:
.globl vector198
vector198:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $198
801072c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801072c6:	e9 5c f3 ff ff       	jmp    80106627 <alltraps>

801072cb <vector199>:
.globl vector199
vector199:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $199
801072cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801072d2:	e9 50 f3 ff ff       	jmp    80106627 <alltraps>

801072d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $200
801072d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801072de:	e9 44 f3 ff ff       	jmp    80106627 <alltraps>

801072e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $201
801072e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801072ea:	e9 38 f3 ff ff       	jmp    80106627 <alltraps>

801072ef <vector202>:
.globl vector202
vector202:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $202
801072f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801072f6:	e9 2c f3 ff ff       	jmp    80106627 <alltraps>

801072fb <vector203>:
.globl vector203
vector203:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $203
801072fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107302:	e9 20 f3 ff ff       	jmp    80106627 <alltraps>

80107307 <vector204>:
.globl vector204
vector204:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $204
80107309:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010730e:	e9 14 f3 ff ff       	jmp    80106627 <alltraps>

80107313 <vector205>:
.globl vector205
vector205:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $205
80107315:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010731a:	e9 08 f3 ff ff       	jmp    80106627 <alltraps>

8010731f <vector206>:
.globl vector206
vector206:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $206
80107321:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107326:	e9 fc f2 ff ff       	jmp    80106627 <alltraps>

8010732b <vector207>:
.globl vector207
vector207:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $207
8010732d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107332:	e9 f0 f2 ff ff       	jmp    80106627 <alltraps>

80107337 <vector208>:
.globl vector208
vector208:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $208
80107339:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010733e:	e9 e4 f2 ff ff       	jmp    80106627 <alltraps>

80107343 <vector209>:
.globl vector209
vector209:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $209
80107345:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010734a:	e9 d8 f2 ff ff       	jmp    80106627 <alltraps>

8010734f <vector210>:
.globl vector210
vector210:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $210
80107351:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107356:	e9 cc f2 ff ff       	jmp    80106627 <alltraps>

8010735b <vector211>:
.globl vector211
vector211:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $211
8010735d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107362:	e9 c0 f2 ff ff       	jmp    80106627 <alltraps>

80107367 <vector212>:
.globl vector212
vector212:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $212
80107369:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010736e:	e9 b4 f2 ff ff       	jmp    80106627 <alltraps>

80107373 <vector213>:
.globl vector213
vector213:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $213
80107375:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010737a:	e9 a8 f2 ff ff       	jmp    80106627 <alltraps>

8010737f <vector214>:
.globl vector214
vector214:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $214
80107381:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107386:	e9 9c f2 ff ff       	jmp    80106627 <alltraps>

8010738b <vector215>:
.globl vector215
vector215:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $215
8010738d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107392:	e9 90 f2 ff ff       	jmp    80106627 <alltraps>

80107397 <vector216>:
.globl vector216
vector216:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $216
80107399:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010739e:	e9 84 f2 ff ff       	jmp    80106627 <alltraps>

801073a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $217
801073a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801073aa:	e9 78 f2 ff ff       	jmp    80106627 <alltraps>

801073af <vector218>:
.globl vector218
vector218:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $218
801073b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801073b6:	e9 6c f2 ff ff       	jmp    80106627 <alltraps>

801073bb <vector219>:
.globl vector219
vector219:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $219
801073bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801073c2:	e9 60 f2 ff ff       	jmp    80106627 <alltraps>

801073c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $220
801073c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801073ce:	e9 54 f2 ff ff       	jmp    80106627 <alltraps>

801073d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $221
801073d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801073da:	e9 48 f2 ff ff       	jmp    80106627 <alltraps>

801073df <vector222>:
.globl vector222
vector222:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $222
801073e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801073e6:	e9 3c f2 ff ff       	jmp    80106627 <alltraps>

801073eb <vector223>:
.globl vector223
vector223:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $223
801073ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801073f2:	e9 30 f2 ff ff       	jmp    80106627 <alltraps>

801073f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $224
801073f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801073fe:	e9 24 f2 ff ff       	jmp    80106627 <alltraps>

80107403 <vector225>:
.globl vector225
vector225:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $225
80107405:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010740a:	e9 18 f2 ff ff       	jmp    80106627 <alltraps>

8010740f <vector226>:
.globl vector226
vector226:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $226
80107411:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107416:	e9 0c f2 ff ff       	jmp    80106627 <alltraps>

8010741b <vector227>:
.globl vector227
vector227:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $227
8010741d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107422:	e9 00 f2 ff ff       	jmp    80106627 <alltraps>

80107427 <vector228>:
.globl vector228
vector228:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $228
80107429:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010742e:	e9 f4 f1 ff ff       	jmp    80106627 <alltraps>

80107433 <vector229>:
.globl vector229
vector229:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $229
80107435:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010743a:	e9 e8 f1 ff ff       	jmp    80106627 <alltraps>

8010743f <vector230>:
.globl vector230
vector230:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $230
80107441:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107446:	e9 dc f1 ff ff       	jmp    80106627 <alltraps>

8010744b <vector231>:
.globl vector231
vector231:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $231
8010744d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107452:	e9 d0 f1 ff ff       	jmp    80106627 <alltraps>

80107457 <vector232>:
.globl vector232
vector232:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $232
80107459:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010745e:	e9 c4 f1 ff ff       	jmp    80106627 <alltraps>

80107463 <vector233>:
.globl vector233
vector233:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $233
80107465:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010746a:	e9 b8 f1 ff ff       	jmp    80106627 <alltraps>

8010746f <vector234>:
.globl vector234
vector234:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $234
80107471:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107476:	e9 ac f1 ff ff       	jmp    80106627 <alltraps>

8010747b <vector235>:
.globl vector235
vector235:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $235
8010747d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107482:	e9 a0 f1 ff ff       	jmp    80106627 <alltraps>

80107487 <vector236>:
.globl vector236
vector236:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $236
80107489:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010748e:	e9 94 f1 ff ff       	jmp    80106627 <alltraps>

80107493 <vector237>:
.globl vector237
vector237:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $237
80107495:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010749a:	e9 88 f1 ff ff       	jmp    80106627 <alltraps>

8010749f <vector238>:
.globl vector238
vector238:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $238
801074a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801074a6:	e9 7c f1 ff ff       	jmp    80106627 <alltraps>

801074ab <vector239>:
.globl vector239
vector239:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $239
801074ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801074b2:	e9 70 f1 ff ff       	jmp    80106627 <alltraps>

801074b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $240
801074b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801074be:	e9 64 f1 ff ff       	jmp    80106627 <alltraps>

801074c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $241
801074c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801074ca:	e9 58 f1 ff ff       	jmp    80106627 <alltraps>

801074cf <vector242>:
.globl vector242
vector242:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $242
801074d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801074d6:	e9 4c f1 ff ff       	jmp    80106627 <alltraps>

801074db <vector243>:
.globl vector243
vector243:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $243
801074dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801074e2:	e9 40 f1 ff ff       	jmp    80106627 <alltraps>

801074e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801074e7:	6a 00                	push   $0x0
  pushl $244
801074e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801074ee:	e9 34 f1 ff ff       	jmp    80106627 <alltraps>

801074f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $245
801074f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801074fa:	e9 28 f1 ff ff       	jmp    80106627 <alltraps>

801074ff <vector246>:
.globl vector246
vector246:
  pushl $0
801074ff:	6a 00                	push   $0x0
  pushl $246
80107501:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107506:	e9 1c f1 ff ff       	jmp    80106627 <alltraps>

8010750b <vector247>:
.globl vector247
vector247:
  pushl $0
8010750b:	6a 00                	push   $0x0
  pushl $247
8010750d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107512:	e9 10 f1 ff ff       	jmp    80106627 <alltraps>

80107517 <vector248>:
.globl vector248
vector248:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $248
80107519:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010751e:	e9 04 f1 ff ff       	jmp    80106627 <alltraps>

80107523 <vector249>:
.globl vector249
vector249:
  pushl $0
80107523:	6a 00                	push   $0x0
  pushl $249
80107525:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010752a:	e9 f8 f0 ff ff       	jmp    80106627 <alltraps>

8010752f <vector250>:
.globl vector250
vector250:
  pushl $0
8010752f:	6a 00                	push   $0x0
  pushl $250
80107531:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107536:	e9 ec f0 ff ff       	jmp    80106627 <alltraps>

8010753b <vector251>:
.globl vector251
vector251:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $251
8010753d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107542:	e9 e0 f0 ff ff       	jmp    80106627 <alltraps>

80107547 <vector252>:
.globl vector252
vector252:
  pushl $0
80107547:	6a 00                	push   $0x0
  pushl $252
80107549:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010754e:	e9 d4 f0 ff ff       	jmp    80106627 <alltraps>

80107553 <vector253>:
.globl vector253
vector253:
  pushl $0
80107553:	6a 00                	push   $0x0
  pushl $253
80107555:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010755a:	e9 c8 f0 ff ff       	jmp    80106627 <alltraps>

8010755f <vector254>:
.globl vector254
vector254:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $254
80107561:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107566:	e9 bc f0 ff ff       	jmp    80106627 <alltraps>

8010756b <vector255>:
.globl vector255
vector255:
  pushl $0
8010756b:	6a 00                	push   $0x0
  pushl $255
8010756d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107572:	e9 b0 f0 ff ff       	jmp    80106627 <alltraps>
80107577:	66 90                	xchg   %ax,%ax
80107579:	66 90                	xchg   %ax,%ax
8010757b:	66 90                	xchg   %ax,%ax
8010757d:	66 90                	xchg   %ax,%ax
8010757f:	90                   	nop

80107580 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
	pde_t *pde;
	pte_t *pgtab;

	pde = &pgdir[PDX(va)];
80107586:	89 d3                	mov    %edx,%ebx
{
80107588:	89 d7                	mov    %edx,%edi
	pde = &pgdir[PDX(va)];
8010758a:	c1 eb 16             	shr    $0x16,%ebx
8010758d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107590:	83 ec 0c             	sub    $0xc,%esp
	if (*pde & PTE_P) {
80107593:	8b 06                	mov    (%esi),%eax
80107595:	a8 01                	test   $0x1,%al
80107597:	74 27                	je     801075c0 <walkpgdir+0x40>
		pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80107599:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010759e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
		// The permissions here are overly generous, but they can
		// be further restricted by the permissions in the page table
		// entries, if necessary.
		*pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
	}
	return &pgtab[PTX(va)];
801075a4:	c1 ef 0a             	shr    $0xa,%edi
}
801075a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return &pgtab[PTX(va)];
801075aa:	89 fa                	mov    %edi,%edx
801075ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801075b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801075b5:	5b                   	pop    %ebx
801075b6:	5e                   	pop    %esi
801075b7:	5f                   	pop    %edi
801075b8:	5d                   	pop    %ebp
801075b9:	c3                   	ret    
801075ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (!alloc || (pgtab = (pte_t *)kalloc()) == 0) return 0;
801075c0:	85 c9                	test   %ecx,%ecx
801075c2:	74 2c                	je     801075f0 <walkpgdir+0x70>
801075c4:	e8 37 af ff ff       	call   80102500 <kalloc>
801075c9:	85 c0                	test   %eax,%eax
801075cb:	89 c3                	mov    %eax,%ebx
801075cd:	74 21                	je     801075f0 <walkpgdir+0x70>
		memset(pgtab, 0, PGSIZE);
801075cf:	83 ec 04             	sub    $0x4,%esp
801075d2:	68 00 10 00 00       	push   $0x1000
801075d7:	6a 00                	push   $0x0
801075d9:	50                   	push   %eax
801075da:	e8 a1 d6 ff ff       	call   80104c80 <memset>
		*pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801075df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075e5:	83 c4 10             	add    $0x10,%esp
801075e8:	83 c8 07             	or     $0x7,%eax
801075eb:	89 06                	mov    %eax,(%esi)
801075ed:	eb b5                	jmp    801075a4 <walkpgdir+0x24>
801075ef:	90                   	nop
}
801075f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (!alloc || (pgtab = (pte_t *)kalloc()) == 0) return 0;
801075f3:	31 c0                	xor    %eax,%eax
}
801075f5:	5b                   	pop    %ebx
801075f6:	5e                   	pop    %esi
801075f7:	5f                   	pop    %edi
801075f8:	5d                   	pop    %ebp
801075f9:	c3                   	ret    
801075fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107600 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
	char * a, *last;
	pte_t *pte;

	a    = (char *)PGROUNDDOWN((uint)va);
80107606:	89 d3                	mov    %edx,%ebx
80107608:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010760e:	83 ec 1c             	sub    $0x1c,%esp
80107611:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107614:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107618:	8b 7d 08             	mov    0x8(%ebp),%edi
8010761b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107620:	89 45 e0             	mov    %eax,-0x20(%ebp)
	for (;;) {
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
		if (*pte & PTE_P) panic("remap");
		*pte = pa | perm | PTE_P;
80107623:	8b 45 0c             	mov    0xc(%ebp),%eax
80107626:	29 df                	sub    %ebx,%edi
80107628:	83 c8 01             	or     $0x1,%eax
8010762b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010762e:	eb 15                	jmp    80107645 <mappages+0x45>
		if (*pte & PTE_P) panic("remap");
80107630:	f6 00 01             	testb  $0x1,(%eax)
80107633:	75 45                	jne    8010767a <mappages+0x7a>
		*pte = pa | perm | PTE_P;
80107635:	0b 75 dc             	or     -0x24(%ebp),%esi
		if (a == last) break;
80107638:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
		*pte = pa | perm | PTE_P;
8010763b:	89 30                	mov    %esi,(%eax)
		if (a == last) break;
8010763d:	74 31                	je     80107670 <mappages+0x70>
		a += PGSIZE;
8010763f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
80107645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107648:	b9 01 00 00 00       	mov    $0x1,%ecx
8010764d:	89 da                	mov    %ebx,%edx
8010764f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107652:	e8 29 ff ff ff       	call   80107580 <walkpgdir>
80107657:	85 c0                	test   %eax,%eax
80107659:	75 d5                	jne    80107630 <mappages+0x30>
		pa += PGSIZE;
	}
	return 0;
}
8010765b:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
8010765e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107663:	5b                   	pop    %ebx
80107664:	5e                   	pop    %esi
80107665:	5f                   	pop    %edi
80107666:	5d                   	pop    %ebp
80107667:	c3                   	ret    
80107668:	90                   	nop
80107669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107670:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80107673:	31 c0                	xor    %eax,%eax
}
80107675:	5b                   	pop    %ebx
80107676:	5e                   	pop    %esi
80107677:	5f                   	pop    %edi
80107678:	5d                   	pop    %ebp
80107679:	c3                   	ret    
		if (*pte & PTE_P) panic("remap");
8010767a:	83 ec 0c             	sub    $0xc,%esp
8010767d:	68 60 8a 10 80       	push   $0x80108a60
80107682:	e8 09 8d ff ff       	call   80100390 <panic>
80107687:	89 f6                	mov    %esi,%esi
80107689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107690 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	57                   	push   %edi
80107694:	56                   	push   %esi
80107695:	53                   	push   %ebx
	pte_t *pte;
	uint   a, pa;

	if (newsz >= oldsz) return oldsz;

	a = PGROUNDUP(newsz);
80107696:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010769c:	89 c7                	mov    %eax,%edi
	a = PGROUNDUP(newsz);
8010769e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801076a4:	83 ec 1c             	sub    $0x1c,%esp
801076a7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	for (; a < oldsz; a += PGSIZE) {
801076aa:	39 d3                	cmp    %edx,%ebx
801076ac:	73 66                	jae    80107714 <deallocuvm.part.0+0x84>
801076ae:	89 d6                	mov    %edx,%esi
801076b0:	eb 3d                	jmp    801076ef <deallocuvm.part.0+0x5f>
801076b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		pte = walkpgdir(pgdir, (char *)a, 0);
		if (!pte)
			a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
		else if ((*pte & PTE_P) != 0) {
801076b8:	8b 10                	mov    (%eax),%edx
801076ba:	f6 c2 01             	test   $0x1,%dl
801076bd:	74 26                	je     801076e5 <deallocuvm.part.0+0x55>
			pa = PTE_ADDR(*pte);
			if (pa == 0) panic("kfree");
801076bf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801076c5:	74 58                	je     8010771f <deallocuvm.part.0+0x8f>
			char *v = P2V(pa);
			kfree(v);
801076c7:	83 ec 0c             	sub    $0xc,%esp
			char *v = P2V(pa);
801076ca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801076d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			kfree(v);
801076d3:	52                   	push   %edx
801076d4:	e8 77 ac ff ff       	call   80102350 <kfree>
			*pte = 0;
801076d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076dc:	83 c4 10             	add    $0x10,%esp
801076df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (; a < oldsz; a += PGSIZE) {
801076e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076eb:	39 f3                	cmp    %esi,%ebx
801076ed:	73 25                	jae    80107714 <deallocuvm.part.0+0x84>
		pte = walkpgdir(pgdir, (char *)a, 0);
801076ef:	31 c9                	xor    %ecx,%ecx
801076f1:	89 da                	mov    %ebx,%edx
801076f3:	89 f8                	mov    %edi,%eax
801076f5:	e8 86 fe ff ff       	call   80107580 <walkpgdir>
		if (!pte)
801076fa:	85 c0                	test   %eax,%eax
801076fc:	75 ba                	jne    801076b8 <deallocuvm.part.0+0x28>
			a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801076fe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107704:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
	for (; a < oldsz; a += PGSIZE) {
8010770a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107710:	39 f3                	cmp    %esi,%ebx
80107712:	72 db                	jb     801076ef <deallocuvm.part.0+0x5f>
		}
	}
	return newsz;
}
80107714:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107717:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010771a:	5b                   	pop    %ebx
8010771b:	5e                   	pop    %esi
8010771c:	5f                   	pop    %edi
8010771d:	5d                   	pop    %ebp
8010771e:	c3                   	ret    
			if (pa == 0) panic("kfree");
8010771f:	83 ec 0c             	sub    $0xc,%esp
80107722:	68 86 83 10 80       	push   $0x80108386
80107727:	e8 64 8c ff ff       	call   80100390 <panic>
8010772c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107730 <shminit>:
{
80107730:	55                   	push   %ebp
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++)
80107731:	b8 a4 fa 12 80       	mov    $0x8012faa4,%eax
{
80107736:	89 e5                	mov    %esp,%ebp
80107738:	90                   	nop
80107739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		pg->allocated = 0;
80107740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		pg->name = 0;
80107746:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++)
8010774d:	83 c0 10             	add    $0x10,%eax
		pg->pa = 0;
80107750:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
		pg->ref_count = 0;
80107757:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++)
8010775e:	3d a4 fc 12 80       	cmp    $0x8012fca4,%eax
80107763:	72 db                	jb     80107740 <shminit+0x10>
	shmtable.initialized = 1;
80107765:	c7 05 a0 fa 12 80 01 	movl   $0x1,0x8012faa0
8010776c:	00 00 00 
}
8010776f:	5d                   	pop    %ebp
80107770:	c3                   	ret    
80107771:	eb 0d                	jmp    80107780 <seginit>
80107773:	90                   	nop
80107774:	90                   	nop
80107775:	90                   	nop
80107776:	90                   	nop
80107777:	90                   	nop
80107778:	90                   	nop
80107779:	90                   	nop
8010777a:	90                   	nop
8010777b:	90                   	nop
8010777c:	90                   	nop
8010777d:	90                   	nop
8010777e:	90                   	nop
8010777f:	90                   	nop

80107780 <seginit>:
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	83 ec 18             	sub    $0x18,%esp
	c                 = &cpus[cpuid()];
80107786:	e8 65 c1 ff ff       	call   801038f0 <cpuid>
8010778b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
	pd[0] = size - 1;
80107791:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107796:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
	c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010779a:	c7 80 78 f5 12 80 ff 	movl   $0xffff,-0x7fed0a88(%eax)
801077a1:	ff 00 00 
801077a4:	c7 80 7c f5 12 80 00 	movl   $0xcf9a00,-0x7fed0a84(%eax)
801077ab:	9a cf 00 
	c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801077ae:	c7 80 80 f5 12 80 ff 	movl   $0xffff,-0x7fed0a80(%eax)
801077b5:	ff 00 00 
801077b8:	c7 80 84 f5 12 80 00 	movl   $0xcf9200,-0x7fed0a7c(%eax)
801077bf:	92 cf 00 
	c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
801077c2:	c7 80 88 f5 12 80 ff 	movl   $0xffff,-0x7fed0a78(%eax)
801077c9:	ff 00 00 
801077cc:	c7 80 8c f5 12 80 00 	movl   $0xcffa00,-0x7fed0a74(%eax)
801077d3:	fa cf 00 
	c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801077d6:	c7 80 90 f5 12 80 ff 	movl   $0xffff,-0x7fed0a70(%eax)
801077dd:	ff 00 00 
801077e0:	c7 80 94 f5 12 80 00 	movl   $0xcff200,-0x7fed0a6c(%eax)
801077e7:	f2 cf 00 
	lgdt(c->gdt, sizeof(c->gdt));
801077ea:	05 70 f5 12 80       	add    $0x8012f570,%eax
	pd[1] = (uint)p;
801077ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
	pd[2] = (uint)p >> 16;
801077f3:	c1 e8 10             	shr    $0x10,%eax
801077f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
	asm volatile("lgdt (%0)" : : "r"(pd));
801077fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077fd:	0f 01 10             	lgdtl  (%eax)
}
80107800:	c9                   	leave  
80107801:	c3                   	ret    
80107802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107810 <switchkvm>:
	lcr3(V2P(kpgdir)); // switch to the kernel page table
80107810:	a1 04 05 13 80       	mov    0x80130504,%eax
{
80107815:	55                   	push   %ebp
80107816:	89 e5                	mov    %esp,%ebp
	lcr3(V2P(kpgdir)); // switch to the kernel page table
80107818:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
	asm volatile("movl %0,%%cr3" : : "r"(val));
8010781d:	0f 22 d8             	mov    %eax,%cr3
}
80107820:	5d                   	pop    %ebp
80107821:	c3                   	ret    
80107822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107830 <switchuvm>:
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	57                   	push   %edi
80107834:	56                   	push   %esi
80107835:	53                   	push   %ebx
80107836:	83 ec 1c             	sub    $0x1c,%esp
80107839:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (p == 0) panic("switchuvm: no process");
8010783c:	85 db                	test   %ebx,%ebx
8010783e:	0f 84 cb 00 00 00    	je     8010790f <switchuvm+0xdf>
	if (p->kstack == 0) panic("switchuvm: no kstack");
80107844:	8b 43 08             	mov    0x8(%ebx),%eax
80107847:	85 c0                	test   %eax,%eax
80107849:	0f 84 da 00 00 00    	je     80107929 <switchuvm+0xf9>
	if (p->pgdir == 0) panic("switchuvm: no pgdir");
8010784f:	8b 43 04             	mov    0x4(%ebx),%eax
80107852:	85 c0                	test   %eax,%eax
80107854:	0f 84 c2 00 00 00    	je     8010791c <switchuvm+0xec>
	pushcli();
8010785a:	e8 61 d2 ff ff       	call   80104ac0 <pushcli>
	mycpu()->gdt[SEG_TSS]   = SEG16(STS_T32A, &mycpu()->ts, sizeof(mycpu()->ts) - 1, 0);
8010785f:	e8 0c c0 ff ff       	call   80103870 <mycpu>
80107864:	89 c6                	mov    %eax,%esi
80107866:	e8 05 c0 ff ff       	call   80103870 <mycpu>
8010786b:	89 c7                	mov    %eax,%edi
8010786d:	e8 fe bf ff ff       	call   80103870 <mycpu>
80107872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107875:	83 c7 08             	add    $0x8,%edi
80107878:	e8 f3 bf ff ff       	call   80103870 <mycpu>
8010787d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107880:	83 c0 08             	add    $0x8,%eax
80107883:	ba 67 00 00 00       	mov    $0x67,%edx
80107888:	c1 e8 18             	shr    $0x18,%eax
8010788b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107892:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107899:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
	mycpu()->ts.iomb = (ushort)0xFFFF;
8010789f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	mycpu()->gdt[SEG_TSS]   = SEG16(STS_T32A, &mycpu()->ts, sizeof(mycpu()->ts) - 1, 0);
801078a4:	83 c1 08             	add    $0x8,%ecx
801078a7:	c1 e9 10             	shr    $0x10,%ecx
801078aa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801078b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801078b5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
	mycpu()->ts.ss0         = SEG_KDATA << 3;
801078bc:	be 10 00 00 00       	mov    $0x10,%esi
	mycpu()->gdt[SEG_TSS].s = 0;
801078c1:	e8 aa bf ff ff       	call   80103870 <mycpu>
801078c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
	mycpu()->ts.ss0         = SEG_KDATA << 3;
801078cd:	e8 9e bf ff ff       	call   80103870 <mycpu>
801078d2:	66 89 70 10          	mov    %si,0x10(%eax)
	mycpu()->ts.esp0        = (uint)p->kstack + KSTACKSIZE;
801078d6:	8b 73 08             	mov    0x8(%ebx),%esi
801078d9:	e8 92 bf ff ff       	call   80103870 <mycpu>
801078de:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078e4:	89 70 0c             	mov    %esi,0xc(%eax)
	mycpu()->ts.iomb = (ushort)0xFFFF;
801078e7:	e8 84 bf ff ff       	call   80103870 <mycpu>
801078ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
	asm volatile("ltr %0" : : "r"(sel));
801078f0:	b8 28 00 00 00       	mov    $0x28,%eax
801078f5:	0f 00 d8             	ltr    %ax
	lcr3(V2P(p->pgdir)); // switch to process's address space
801078f8:	8b 43 04             	mov    0x4(%ebx),%eax
801078fb:	05 00 00 00 80       	add    $0x80000000,%eax
	asm volatile("movl %0,%%cr3" : : "r"(val));
80107900:	0f 22 d8             	mov    %eax,%cr3
}
80107903:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107906:	5b                   	pop    %ebx
80107907:	5e                   	pop    %esi
80107908:	5f                   	pop    %edi
80107909:	5d                   	pop    %ebp
	popcli();
8010790a:	e9 b1 d2 ff ff       	jmp    80104bc0 <popcli>
	if (p == 0) panic("switchuvm: no process");
8010790f:	83 ec 0c             	sub    $0xc,%esp
80107912:	68 66 8a 10 80       	push   $0x80108a66
80107917:	e8 74 8a ff ff       	call   80100390 <panic>
	if (p->pgdir == 0) panic("switchuvm: no pgdir");
8010791c:	83 ec 0c             	sub    $0xc,%esp
8010791f:	68 91 8a 10 80       	push   $0x80108a91
80107924:	e8 67 8a ff ff       	call   80100390 <panic>
	if (p->kstack == 0) panic("switchuvm: no kstack");
80107929:	83 ec 0c             	sub    $0xc,%esp
8010792c:	68 7c 8a 10 80       	push   $0x80108a7c
80107931:	e8 5a 8a ff ff       	call   80100390 <panic>
80107936:	8d 76 00             	lea    0x0(%esi),%esi
80107939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107940 <inituvm>:
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	53                   	push   %ebx
80107946:	83 ec 1c             	sub    $0x1c,%esp
80107949:	8b 75 10             	mov    0x10(%ebp),%esi
8010794c:	8b 45 08             	mov    0x8(%ebp),%eax
8010794f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (sz >= PGSIZE) panic("inituvm: more than a page");
80107952:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107958:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (sz >= PGSIZE) panic("inituvm: more than a page");
8010795b:	77 49                	ja     801079a6 <inituvm+0x66>
	mem = kalloc();
8010795d:	e8 9e ab ff ff       	call   80102500 <kalloc>
	memset(mem, 0, PGSIZE);
80107962:	83 ec 04             	sub    $0x4,%esp
	mem = kalloc();
80107965:	89 c3                	mov    %eax,%ebx
	memset(mem, 0, PGSIZE);
80107967:	68 00 10 00 00       	push   $0x1000
8010796c:	6a 00                	push   $0x0
8010796e:	50                   	push   %eax
8010796f:	e8 0c d3 ff ff       	call   80104c80 <memset>
	mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107974:	58                   	pop    %eax
80107975:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010797b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107980:	5a                   	pop    %edx
80107981:	6a 06                	push   $0x6
80107983:	50                   	push   %eax
80107984:	31 d2                	xor    %edx,%edx
80107986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107989:	e8 72 fc ff ff       	call   80107600 <mappages>
	memmove(mem, init, sz);
8010798e:	89 75 10             	mov    %esi,0x10(%ebp)
80107991:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107994:	83 c4 10             	add    $0x10,%esp
80107997:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010799a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010799d:	5b                   	pop    %ebx
8010799e:	5e                   	pop    %esi
8010799f:	5f                   	pop    %edi
801079a0:	5d                   	pop    %ebp
	memmove(mem, init, sz);
801079a1:	e9 8a d3 ff ff       	jmp    80104d30 <memmove>
	if (sz >= PGSIZE) panic("inituvm: more than a page");
801079a6:	83 ec 0c             	sub    $0xc,%esp
801079a9:	68 a5 8a 10 80       	push   $0x80108aa5
801079ae:	e8 dd 89 ff ff       	call   80100390 <panic>
801079b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <loaduvm>:
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 0c             	sub    $0xc,%esp
	if ((uint)addr % PGSIZE != 0) panic("loaduvm: addr must be page aligned");
801079c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801079d0:	0f 85 91 00 00 00    	jne    80107a67 <loaduvm+0xa7>
	for (i = 0; i < sz; i += PGSIZE) {
801079d6:	8b 75 18             	mov    0x18(%ebp),%esi
801079d9:	31 db                	xor    %ebx,%ebx
801079db:	85 f6                	test   %esi,%esi
801079dd:	75 1a                	jne    801079f9 <loaduvm+0x39>
801079df:	eb 6f                	jmp    80107a50 <loaduvm+0x90>
801079e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801079ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801079f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801079f7:	76 57                	jbe    80107a50 <loaduvm+0x90>
		if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) panic("loaduvm: address should exist");
801079f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801079fc:	8b 45 08             	mov    0x8(%ebp),%eax
801079ff:	31 c9                	xor    %ecx,%ecx
80107a01:	01 da                	add    %ebx,%edx
80107a03:	e8 78 fb ff ff       	call   80107580 <walkpgdir>
80107a08:	85 c0                	test   %eax,%eax
80107a0a:	74 4e                	je     80107a5a <loaduvm+0x9a>
		pa = PTE_ADDR(*pte);
80107a0c:	8b 00                	mov    (%eax),%eax
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80107a0e:	8b 4d 14             	mov    0x14(%ebp),%ecx
		if (sz - i < PGSIZE)
80107a11:	bf 00 10 00 00       	mov    $0x1000,%edi
		pa = PTE_ADDR(*pte);
80107a16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		if (sz - i < PGSIZE)
80107a1b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107a21:	0f 46 fe             	cmovbe %esi,%edi
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80107a24:	01 d9                	add    %ebx,%ecx
80107a26:	05 00 00 00 80       	add    $0x80000000,%eax
80107a2b:	57                   	push   %edi
80107a2c:	51                   	push   %ecx
80107a2d:	50                   	push   %eax
80107a2e:	ff 75 10             	pushl  0x10(%ebp)
80107a31:	e8 6a 9f ff ff       	call   801019a0 <readi>
80107a36:	83 c4 10             	add    $0x10,%esp
80107a39:	39 f8                	cmp    %edi,%eax
80107a3b:	74 ab                	je     801079e8 <loaduvm+0x28>
}
80107a3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80107a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a45:	5b                   	pop    %ebx
80107a46:	5e                   	pop    %esi
80107a47:	5f                   	pop    %edi
80107a48:	5d                   	pop    %ebp
80107a49:	c3                   	ret    
80107a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80107a53:	31 c0                	xor    %eax,%eax
}
80107a55:	5b                   	pop    %ebx
80107a56:	5e                   	pop    %esi
80107a57:	5f                   	pop    %edi
80107a58:	5d                   	pop    %ebp
80107a59:	c3                   	ret    
		if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) panic("loaduvm: address should exist");
80107a5a:	83 ec 0c             	sub    $0xc,%esp
80107a5d:	68 bf 8a 10 80       	push   $0x80108abf
80107a62:	e8 29 89 ff ff       	call   80100390 <panic>
	if ((uint)addr % PGSIZE != 0) panic("loaduvm: addr must be page aligned");
80107a67:	83 ec 0c             	sub    $0xc,%esp
80107a6a:	68 60 8b 10 80       	push   $0x80108b60
80107a6f:	e8 1c 89 ff ff       	call   80100390 <panic>
80107a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a80 <allocuvm>:
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	57                   	push   %edi
80107a84:	56                   	push   %esi
80107a85:	53                   	push   %ebx
80107a86:	83 ec 1c             	sub    $0x1c,%esp
	if (newsz >= KERNBASE) return 0;
80107a89:	8b 7d 10             	mov    0x10(%ebp),%edi
80107a8c:	85 ff                	test   %edi,%edi
80107a8e:	0f 88 8e 00 00 00    	js     80107b22 <allocuvm+0xa2>
	if (newsz < oldsz) return oldsz;
80107a94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107a97:	0f 82 93 00 00 00    	jb     80107b30 <allocuvm+0xb0>
	a = PGROUNDUP(oldsz);
80107a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aa0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107aa6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; a < newsz; a += PGSIZE) {
80107aac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107aaf:	0f 86 7e 00 00 00    	jbe    80107b33 <allocuvm+0xb3>
80107ab5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107ab8:	8b 7d 08             	mov    0x8(%ebp),%edi
80107abb:	eb 42                	jmp    80107aff <allocuvm+0x7f>
80107abd:	8d 76 00             	lea    0x0(%esi),%esi
		memset(mem, 0, PGSIZE);
80107ac0:	83 ec 04             	sub    $0x4,%esp
80107ac3:	68 00 10 00 00       	push   $0x1000
80107ac8:	6a 00                	push   $0x0
80107aca:	50                   	push   %eax
80107acb:	e8 b0 d1 ff ff       	call   80104c80 <memset>
		if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80107ad0:	58                   	pop    %eax
80107ad1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ad7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107adc:	5a                   	pop    %edx
80107add:	6a 06                	push   $0x6
80107adf:	50                   	push   %eax
80107ae0:	89 da                	mov    %ebx,%edx
80107ae2:	89 f8                	mov    %edi,%eax
80107ae4:	e8 17 fb ff ff       	call   80107600 <mappages>
80107ae9:	83 c4 10             	add    $0x10,%esp
80107aec:	85 c0                	test   %eax,%eax
80107aee:	78 50                	js     80107b40 <allocuvm+0xc0>
	for (; a < newsz; a += PGSIZE) {
80107af0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107af6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107af9:	0f 86 81 00 00 00    	jbe    80107b80 <allocuvm+0x100>
		mem = kalloc();
80107aff:	e8 fc a9 ff ff       	call   80102500 <kalloc>
		if (mem == 0) {
80107b04:	85 c0                	test   %eax,%eax
		mem = kalloc();
80107b06:	89 c6                	mov    %eax,%esi
		if (mem == 0) {
80107b08:	75 b6                	jne    80107ac0 <allocuvm+0x40>
			cprintf("allocuvm out of memory\n");
80107b0a:	83 ec 0c             	sub    $0xc,%esp
80107b0d:	68 dd 8a 10 80       	push   $0x80108add
80107b12:	e8 49 8b ff ff       	call   80100660 <cprintf>
	if (newsz >= oldsz) return oldsz;
80107b17:	83 c4 10             	add    $0x10,%esp
80107b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b1d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b20:	77 6e                	ja     80107b90 <allocuvm+0x110>
}
80107b22:	8d 65 f4             	lea    -0xc(%ebp),%esp
	if (newsz >= KERNBASE) return 0;
80107b25:	31 ff                	xor    %edi,%edi
}
80107b27:	89 f8                	mov    %edi,%eax
80107b29:	5b                   	pop    %ebx
80107b2a:	5e                   	pop    %esi
80107b2b:	5f                   	pop    %edi
80107b2c:	5d                   	pop    %ebp
80107b2d:	c3                   	ret    
80107b2e:	66 90                	xchg   %ax,%ax
	if (newsz < oldsz) return oldsz;
80107b30:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107b33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b36:	89 f8                	mov    %edi,%eax
80107b38:	5b                   	pop    %ebx
80107b39:	5e                   	pop    %esi
80107b3a:	5f                   	pop    %edi
80107b3b:	5d                   	pop    %ebp
80107b3c:	c3                   	ret    
80107b3d:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("allocuvm out of memory (2)\n");
80107b40:	83 ec 0c             	sub    $0xc,%esp
80107b43:	68 f5 8a 10 80       	push   $0x80108af5
80107b48:	e8 13 8b ff ff       	call   80100660 <cprintf>
	if (newsz >= oldsz) return oldsz;
80107b4d:	83 c4 10             	add    $0x10,%esp
80107b50:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b53:	39 45 10             	cmp    %eax,0x10(%ebp)
80107b56:	76 0d                	jbe    80107b65 <allocuvm+0xe5>
80107b58:	89 c1                	mov    %eax,%ecx
80107b5a:	8b 55 10             	mov    0x10(%ebp),%edx
80107b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80107b60:	e8 2b fb ff ff       	call   80107690 <deallocuvm.part.0>
			kfree(mem);
80107b65:	83 ec 0c             	sub    $0xc,%esp
			return 0;
80107b68:	31 ff                	xor    %edi,%edi
			kfree(mem);
80107b6a:	56                   	push   %esi
80107b6b:	e8 e0 a7 ff ff       	call   80102350 <kfree>
			return 0;
80107b70:	83 c4 10             	add    $0x10,%esp
}
80107b73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b76:	89 f8                	mov    %edi,%eax
80107b78:	5b                   	pop    %ebx
80107b79:	5e                   	pop    %esi
80107b7a:	5f                   	pop    %edi
80107b7b:	5d                   	pop    %ebp
80107b7c:	c3                   	ret    
80107b7d:	8d 76 00             	lea    0x0(%esi),%esi
80107b80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107b83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b86:	5b                   	pop    %ebx
80107b87:	89 f8                	mov    %edi,%eax
80107b89:	5e                   	pop    %esi
80107b8a:	5f                   	pop    %edi
80107b8b:	5d                   	pop    %ebp
80107b8c:	c3                   	ret    
80107b8d:	8d 76 00             	lea    0x0(%esi),%esi
80107b90:	89 c1                	mov    %eax,%ecx
80107b92:	8b 55 10             	mov    0x10(%ebp),%edx
80107b95:	8b 45 08             	mov    0x8(%ebp),%eax
			return 0;
80107b98:	31 ff                	xor    %edi,%edi
80107b9a:	e8 f1 fa ff ff       	call   80107690 <deallocuvm.part.0>
80107b9f:	eb 92                	jmp    80107b33 <allocuvm+0xb3>
80107ba1:	eb 0d                	jmp    80107bb0 <deallocuvm>
80107ba3:	90                   	nop
80107ba4:	90                   	nop
80107ba5:	90                   	nop
80107ba6:	90                   	nop
80107ba7:	90                   	nop
80107ba8:	90                   	nop
80107ba9:	90                   	nop
80107baa:	90                   	nop
80107bab:	90                   	nop
80107bac:	90                   	nop
80107bad:	90                   	nop
80107bae:	90                   	nop
80107baf:	90                   	nop

80107bb0 <deallocuvm>:
{
80107bb0:	55                   	push   %ebp
80107bb1:	89 e5                	mov    %esp,%ebp
80107bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bb6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107bb9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (newsz >= oldsz) return oldsz;
80107bbc:	39 d1                	cmp    %edx,%ecx
80107bbe:	73 10                	jae    80107bd0 <deallocuvm+0x20>
}
80107bc0:	5d                   	pop    %ebp
80107bc1:	e9 ca fa ff ff       	jmp    80107690 <deallocuvm.part.0>
80107bc6:	8d 76 00             	lea    0x0(%esi),%esi
80107bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107bd0:	89 d0                	mov    %edx,%eax
80107bd2:	5d                   	pop    %ebp
80107bd3:	c3                   	ret    
80107bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107be0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107be0:	55                   	push   %ebp
80107be1:	89 e5                	mov    %esp,%ebp
80107be3:	57                   	push   %edi
80107be4:	56                   	push   %esi
80107be5:	53                   	push   %ebx
80107be6:	83 ec 0c             	sub    $0xc,%esp
80107be9:	8b 75 08             	mov    0x8(%ebp),%esi
	uint i;

	if (pgdir == 0) panic("freevm: no pgdir");
80107bec:	85 f6                	test   %esi,%esi
80107bee:	74 59                	je     80107c49 <freevm+0x69>
80107bf0:	31 c9                	xor    %ecx,%ecx
80107bf2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107bf7:	89 f0                	mov    %esi,%eax
80107bf9:	e8 92 fa ff ff       	call   80107690 <deallocuvm.part.0>
80107bfe:	89 f3                	mov    %esi,%ebx
80107c00:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107c06:	eb 0f                	jmp    80107c17 <freevm+0x37>
80107c08:	90                   	nop
80107c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c10:	83 c3 04             	add    $0x4,%ebx
	deallocuvm(pgdir, KERNBASE, 0);
	for (i = 0; i < NPDENTRIES; i++) {
80107c13:	39 fb                	cmp    %edi,%ebx
80107c15:	74 23                	je     80107c3a <freevm+0x5a>
		if (pgdir[i] & PTE_P) {
80107c17:	8b 03                	mov    (%ebx),%eax
80107c19:	a8 01                	test   $0x1,%al
80107c1b:	74 f3                	je     80107c10 <freevm+0x30>
			char *v = P2V(PTE_ADDR(pgdir[i]));
80107c1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
			kfree(v);
80107c22:	83 ec 0c             	sub    $0xc,%esp
80107c25:	83 c3 04             	add    $0x4,%ebx
			char *v = P2V(PTE_ADDR(pgdir[i]));
80107c28:	05 00 00 00 80       	add    $0x80000000,%eax
			kfree(v);
80107c2d:	50                   	push   %eax
80107c2e:	e8 1d a7 ff ff       	call   80102350 <kfree>
80107c33:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPDENTRIES; i++) {
80107c36:	39 fb                	cmp    %edi,%ebx
80107c38:	75 dd                	jne    80107c17 <freevm+0x37>
		}
	}
	kfree((char *)pgdir);
80107c3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c40:	5b                   	pop    %ebx
80107c41:	5e                   	pop    %esi
80107c42:	5f                   	pop    %edi
80107c43:	5d                   	pop    %ebp
	kfree((char *)pgdir);
80107c44:	e9 07 a7 ff ff       	jmp    80102350 <kfree>
	if (pgdir == 0) panic("freevm: no pgdir");
80107c49:	83 ec 0c             	sub    $0xc,%esp
80107c4c:	68 11 8b 10 80       	push   $0x80108b11
80107c51:	e8 3a 87 ff ff       	call   80100390 <panic>
80107c56:	8d 76 00             	lea    0x0(%esi),%esi
80107c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c60 <setupkvm>:
{
80107c60:	55                   	push   %ebp
80107c61:	89 e5                	mov    %esp,%ebp
80107c63:	56                   	push   %esi
80107c64:	53                   	push   %ebx
	if ((pgdir = (pde_t *)kalloc()) == 0) return 0;
80107c65:	e8 96 a8 ff ff       	call   80102500 <kalloc>
80107c6a:	85 c0                	test   %eax,%eax
80107c6c:	89 c6                	mov    %eax,%esi
80107c6e:	74 42                	je     80107cb2 <setupkvm+0x52>
	memset(pgdir, 0, PGSIZE);
80107c70:	83 ec 04             	sub    $0x4,%esp
	for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c73:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
	memset(pgdir, 0, PGSIZE);
80107c78:	68 00 10 00 00       	push   $0x1000
80107c7d:	6a 00                	push   $0x0
80107c7f:	50                   	push   %eax
80107c80:	e8 fb cf ff ff       	call   80104c80 <memset>
80107c85:	83 c4 10             	add    $0x10,%esp
		if (mappages(pgdir, k->virt, k->phys_end - k->phys_start, (uint)k->phys_start, k->perm) < 0) {
80107c88:	8b 43 04             	mov    0x4(%ebx),%eax
80107c8b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107c8e:	83 ec 08             	sub    $0x8,%esp
80107c91:	8b 13                	mov    (%ebx),%edx
80107c93:	ff 73 0c             	pushl  0xc(%ebx)
80107c96:	50                   	push   %eax
80107c97:	29 c1                	sub    %eax,%ecx
80107c99:	89 f0                	mov    %esi,%eax
80107c9b:	e8 60 f9 ff ff       	call   80107600 <mappages>
80107ca0:	83 c4 10             	add    $0x10,%esp
80107ca3:	85 c0                	test   %eax,%eax
80107ca5:	78 19                	js     80107cc0 <setupkvm+0x60>
	for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ca7:	83 c3 10             	add    $0x10,%ebx
80107caa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107cb0:	75 d6                	jne    80107c88 <setupkvm+0x28>
}
80107cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107cb5:	89 f0                	mov    %esi,%eax
80107cb7:	5b                   	pop    %ebx
80107cb8:	5e                   	pop    %esi
80107cb9:	5d                   	pop    %ebp
80107cba:	c3                   	ret    
80107cbb:	90                   	nop
80107cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			freevm(pgdir);
80107cc0:	83 ec 0c             	sub    $0xc,%esp
80107cc3:	56                   	push   %esi
			return 0;
80107cc4:	31 f6                	xor    %esi,%esi
			freevm(pgdir);
80107cc6:	e8 15 ff ff ff       	call   80107be0 <freevm>
			return 0;
80107ccb:	83 c4 10             	add    $0x10,%esp
}
80107cce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107cd1:	89 f0                	mov    %esi,%eax
80107cd3:	5b                   	pop    %ebx
80107cd4:	5e                   	pop    %esi
80107cd5:	5d                   	pop    %ebp
80107cd6:	c3                   	ret    
80107cd7:	89 f6                	mov    %esi,%esi
80107cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ce0 <kvmalloc>:
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	83 ec 08             	sub    $0x8,%esp
	kpgdir = setupkvm();
80107ce6:	e8 75 ff ff ff       	call   80107c60 <setupkvm>
80107ceb:	a3 04 05 13 80       	mov    %eax,0x80130504
	lcr3(V2P(kpgdir)); // switch to the kernel page table
80107cf0:	05 00 00 00 80       	add    $0x80000000,%eax
80107cf5:	0f 22 d8             	mov    %eax,%cr3
}
80107cf8:	c9                   	leave  
80107cf9:	c3                   	ret    
80107cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107d00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107d00:	55                   	push   %ebp
	pte_t *pte;

	pte = walkpgdir(pgdir, uva, 0);
80107d01:	31 c9                	xor    %ecx,%ecx
{
80107d03:	89 e5                	mov    %esp,%ebp
80107d05:	83 ec 08             	sub    $0x8,%esp
	pte = walkpgdir(pgdir, uva, 0);
80107d08:	8b 55 0c             	mov    0xc(%ebp),%edx
80107d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107d0e:	e8 6d f8 ff ff       	call   80107580 <walkpgdir>
	if (pte == 0) panic("clearpteu");
80107d13:	85 c0                	test   %eax,%eax
80107d15:	74 05                	je     80107d1c <clearpteu+0x1c>
	*pte &= ~PTE_U;
80107d17:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107d1a:	c9                   	leave  
80107d1b:	c3                   	ret    
	if (pte == 0) panic("clearpteu");
80107d1c:	83 ec 0c             	sub    $0xc,%esp
80107d1f:	68 22 8b 10 80       	push   $0x80108b22
80107d24:	e8 67 86 ff ff       	call   80100390 <panic>
80107d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d30 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz)
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	57                   	push   %edi
80107d34:	56                   	push   %esi
80107d35:	53                   	push   %ebx
80107d36:	83 ec 1c             	sub    $0x1c,%esp
	pde_t *d;
	pte_t *pte;
	uint   pa, i, flags;
	char * mem;

	if ((d = setupkvm()) == 0) return 0;
80107d39:	e8 22 ff ff ff       	call   80107c60 <setupkvm>
80107d3e:	85 c0                	test   %eax,%eax
80107d40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d43:	0f 84 a0 00 00 00    	je     80107de9 <copyuvm+0xb9>
	for (i = 0; i < sz; i += PGSIZE) {
80107d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107d4c:	85 c9                	test   %ecx,%ecx
80107d4e:	0f 84 95 00 00 00    	je     80107de9 <copyuvm+0xb9>
80107d54:	31 f6                	xor    %esi,%esi
80107d56:	eb 4e                	jmp    80107da6 <copyuvm+0x76>
80107d58:	90                   	nop
80107d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
		pa    = PTE_ADDR(*pte);
		flags = PTE_FLAGS(*pte);
		if ((mem = kalloc()) == 0) goto bad;
		memmove(mem, (char *)P2V(pa), PGSIZE);
80107d60:	83 ec 04             	sub    $0x4,%esp
80107d63:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107d69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d6c:	68 00 10 00 00       	push   $0x1000
80107d71:	57                   	push   %edi
80107d72:	50                   	push   %eax
80107d73:	e8 b8 cf ff ff       	call   80104d30 <memmove>
		if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0) goto bad;
80107d78:	58                   	pop    %eax
80107d79:	5a                   	pop    %edx
80107d7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107d80:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d85:	53                   	push   %ebx
80107d86:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107d8c:	52                   	push   %edx
80107d8d:	89 f2                	mov    %esi,%edx
80107d8f:	e8 6c f8 ff ff       	call   80107600 <mappages>
80107d94:	83 c4 10             	add    $0x10,%esp
80107d97:	85 c0                	test   %eax,%eax
80107d99:	78 39                	js     80107dd4 <copyuvm+0xa4>
	for (i = 0; i < sz; i += PGSIZE) {
80107d9b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107da1:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107da4:	76 43                	jbe    80107de9 <copyuvm+0xb9>
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
80107da6:	8b 45 08             	mov    0x8(%ebp),%eax
80107da9:	31 c9                	xor    %ecx,%ecx
80107dab:	89 f2                	mov    %esi,%edx
80107dad:	e8 ce f7 ff ff       	call   80107580 <walkpgdir>
80107db2:	85 c0                	test   %eax,%eax
80107db4:	74 3e                	je     80107df4 <copyuvm+0xc4>
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
80107db6:	8b 18                	mov    (%eax),%ebx
80107db8:	f6 c3 01             	test   $0x1,%bl
80107dbb:	74 44                	je     80107e01 <copyuvm+0xd1>
		pa    = PTE_ADDR(*pte);
80107dbd:	89 df                	mov    %ebx,%edi
		flags = PTE_FLAGS(*pte);
80107dbf:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
		pa    = PTE_ADDR(*pte);
80107dc5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
		if ((mem = kalloc()) == 0) goto bad;
80107dcb:	e8 30 a7 ff ff       	call   80102500 <kalloc>
80107dd0:	85 c0                	test   %eax,%eax
80107dd2:	75 8c                	jne    80107d60 <copyuvm+0x30>
	}
	return d;

bad:
	freevm(d);
80107dd4:	83 ec 0c             	sub    $0xc,%esp
80107dd7:	ff 75 e0             	pushl  -0x20(%ebp)
80107dda:	e8 01 fe ff ff       	call   80107be0 <freevm>
	return 0;
80107ddf:	83 c4 10             	add    $0x10,%esp
80107de2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107def:	5b                   	pop    %ebx
80107df0:	5e                   	pop    %esi
80107df1:	5f                   	pop    %edi
80107df2:	5d                   	pop    %ebp
80107df3:	c3                   	ret    
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
80107df4:	83 ec 0c             	sub    $0xc,%esp
80107df7:	68 2c 8b 10 80       	push   $0x80108b2c
80107dfc:	e8 8f 85 ff ff       	call   80100390 <panic>
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
80107e01:	83 ec 0c             	sub    $0xc,%esp
80107e04:	68 46 8b 10 80       	push   $0x80108b46
80107e09:	e8 82 85 ff ff       	call   80100390 <panic>
80107e0e:	66 90                	xchg   %ax,%ax

80107e10 <uva2ka>:

// PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80107e10:	55                   	push   %ebp
	pte_t *pte;

	pte = walkpgdir(pgdir, uva, 0);
80107e11:	31 c9                	xor    %ecx,%ecx
{
80107e13:	89 e5                	mov    %esp,%ebp
80107e15:	83 ec 08             	sub    $0x8,%esp
	pte = walkpgdir(pgdir, uva, 0);
80107e18:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e1e:	e8 5d f7 ff ff       	call   80107580 <walkpgdir>
	if ((*pte & PTE_P) == 0) return 0;
80107e23:	8b 00                	mov    (%eax),%eax
	if ((*pte & PTE_U) == 0) return 0;
	return (char *)P2V(PTE_ADDR(*pte));
}
80107e25:	c9                   	leave  
	if ((*pte & PTE_U) == 0) return 0;
80107e26:	89 c2                	mov    %eax,%edx
	return (char *)P2V(PTE_ADDR(*pte));
80107e28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if ((*pte & PTE_U) == 0) return 0;
80107e2d:	83 e2 05             	and    $0x5,%edx
	return (char *)P2V(PTE_ADDR(*pte));
80107e30:	05 00 00 00 80       	add    $0x80000000,%eax
80107e35:	83 fa 05             	cmp    $0x5,%edx
80107e38:	ba 00 00 00 00       	mov    $0x0,%edx
80107e3d:	0f 45 c2             	cmovne %edx,%eax
}
80107e40:	c3                   	ret    
80107e41:	eb 0d                	jmp    80107e50 <copyout>
80107e43:	90                   	nop
80107e44:	90                   	nop
80107e45:	90                   	nop
80107e46:	90                   	nop
80107e47:	90                   	nop
80107e48:	90                   	nop
80107e49:	90                   	nop
80107e4a:	90                   	nop
80107e4b:	90                   	nop
80107e4c:	90                   	nop
80107e4d:	90                   	nop
80107e4e:	90                   	nop
80107e4f:	90                   	nop

80107e50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107e50:	55                   	push   %ebp
80107e51:	89 e5                	mov    %esp,%ebp
80107e53:	57                   	push   %edi
80107e54:	56                   	push   %esi
80107e55:	53                   	push   %ebx
80107e56:	83 ec 1c             	sub    $0x1c,%esp
80107e59:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e5f:	8b 7d 10             	mov    0x10(%ebp),%edi
	char *buf, *pa0;
	uint  n, va0;

	buf = (char *)p;
	while (len > 0) {
80107e62:	85 db                	test   %ebx,%ebx
80107e64:	75 40                	jne    80107ea6 <copyout+0x56>
80107e66:	eb 70                	jmp    80107ed8 <copyout+0x88>
80107e68:	90                   	nop
80107e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		va0 = (uint)PGROUNDDOWN(va);
		pa0 = uva2ka(pgdir, (char *)va0);
		if (pa0 == 0) return -1;
		n = PGSIZE - (va - va0);
80107e70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107e73:	89 f1                	mov    %esi,%ecx
80107e75:	29 d1                	sub    %edx,%ecx
80107e77:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107e7d:	39 d9                	cmp    %ebx,%ecx
80107e7f:	0f 47 cb             	cmova  %ebx,%ecx
		if (n > len) n= len;
		memmove(pa0 + (va - va0), buf, n);
80107e82:	29 f2                	sub    %esi,%edx
80107e84:	83 ec 04             	sub    $0x4,%esp
80107e87:	01 d0                	add    %edx,%eax
80107e89:	51                   	push   %ecx
80107e8a:	57                   	push   %edi
80107e8b:	50                   	push   %eax
80107e8c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107e8f:	e8 9c ce ff ff       	call   80104d30 <memmove>
		len -= n;
		buf += n;
80107e94:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	while (len > 0) {
80107e97:	83 c4 10             	add    $0x10,%esp
		va = va0 + PGSIZE;
80107e9a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
		buf += n;
80107ea0:	01 cf                	add    %ecx,%edi
	while (len > 0) {
80107ea2:	29 cb                	sub    %ecx,%ebx
80107ea4:	74 32                	je     80107ed8 <copyout+0x88>
		va0 = (uint)PGROUNDDOWN(va);
80107ea6:	89 d6                	mov    %edx,%esi
		pa0 = uva2ka(pgdir, (char *)va0);
80107ea8:	83 ec 08             	sub    $0x8,%esp
		va0 = (uint)PGROUNDDOWN(va);
80107eab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107eae:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		pa0 = uva2ka(pgdir, (char *)va0);
80107eb4:	56                   	push   %esi
80107eb5:	ff 75 08             	pushl  0x8(%ebp)
80107eb8:	e8 53 ff ff ff       	call   80107e10 <uva2ka>
		if (pa0 == 0) return -1;
80107ebd:	83 c4 10             	add    $0x10,%esp
80107ec0:	85 c0                	test   %eax,%eax
80107ec2:	75 ac                	jne    80107e70 <copyout+0x20>
	}
	return 0;
}
80107ec4:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (pa0 == 0) return -1;
80107ec7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ecc:	5b                   	pop    %ebx
80107ecd:	5e                   	pop    %esi
80107ece:	5f                   	pop    %edi
80107ecf:	5d                   	pop    %ebp
80107ed0:	c3                   	ret    
80107ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80107edb:	31 c0                	xor    %eax,%eax
}
80107edd:	5b                   	pop    %ebx
80107ede:	5e                   	pop    %esi
80107edf:	5f                   	pop    %edi
80107ee0:	5d                   	pop    %ebp
80107ee1:	c3                   	ret    
80107ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ef0 <shmget>:


//Map a 4096 page into the calling process’s virtual address space
char*
shmget(char* name)
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	57                   	push   %edi
80107ef4:	56                   	push   %esi
80107ef5:	53                   	push   %ebx
80107ef6:	83 ec 1c             	sub    $0x1c,%esp
80107ef9:	8b 55 08             	mov    0x8(%ebp),%edx
	if(name == 0)
80107efc:	85 d2                	test   %edx,%edx
80107efe:	0f 84 ec 00 00 00    	je     80107ff0 <shmget+0x100>
	{
		return NULL;
	}

	if(shmtable.initialized == 0)
80107f04:	a1 a0 fa 12 80       	mov    0x8012faa0,%eax
80107f09:	85 c0                	test   %eax,%eax
80107f0b:	0f 84 9f 00 00 00    	je     80107fb0 <shmget+0xc0>
		shminit();
	}

	struct shm_pg *pg;
	char* vas = NULL;
	int pg_num = 0;
80107f11:	31 f6                	xor    %esi,%esi

	//see if the name already exists in the table
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++, pg_num++)
80107f13:	bb a4 fa 12 80       	mov    $0x8012faa4,%ebx
80107f18:	eb 18                	jmp    80107f32 <shmget+0x42>
80107f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107f20:	83 c3 10             	add    $0x10,%ebx
80107f23:	83 c6 01             	add    $0x1,%esi
80107f26:	81 fb a4 fc 12 80    	cmp    $0x8012fca4,%ebx
80107f2c:	0f 83 ce 00 00 00    	jae    80108000 <shmget+0x110>
	{

		if(pg->name == name)
80107f32:	39 53 04             	cmp    %edx,0x4(%ebx)
80107f35:	75 e9                	jne    80107f20 <shmget+0x30>
		{
			mappages(myproc()->pgdir, (void*)PGROUNDUP(myproc()->sz), PGSIZE, V2P(pg->pa), PTE_W | PTE_U);
80107f37:	8b 43 08             	mov    0x8(%ebx),%eax
80107f3a:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107f40:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107f43:	e8 c8 b9 ff ff       	call   80103910 <myproc>
80107f48:	8b 38                	mov    (%eax),%edi
80107f4a:	e8 c1 b9 ff ff       	call   80103910 <myproc>
80107f4f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107f52:	8b 40 04             	mov    0x4(%eax),%eax
80107f55:	83 ec 08             	sub    $0x8,%esp
80107f58:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80107f5e:	6a 06                	push   $0x6
80107f60:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80107f66:	51                   	push   %ecx
80107f67:	89 fa                	mov    %edi,%edx
80107f69:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f6e:	e8 8d f6 ff ff       	call   80107600 <mappages>
			pg->ref_count++;
80107f73:	83 43 0c 01          	addl   $0x1,0xc(%ebx)
			pg->allocated = 1;
			pg->pa = kalloc();
			pg->ref_count = 1;
			memset(pg->pa, 0, PGSIZE);
			mappages(myproc()->pgdir, (void*)PGROUNDUP(myproc()->sz), PGSIZE, V2P(pg->pa), PTE_W | PTE_U);
			vas = (char*)PGROUNDUP(myproc()->sz);
80107f77:	e8 94 b9 ff ff       	call   80103910 <myproc>
80107f7c:	8b 38                	mov    (%eax),%edi
			myproc()->sz += PGSIZE;
80107f7e:	e8 8d b9 ff ff       	call   80103910 <myproc>
80107f83:	81 00 00 10 00 00    	addl   $0x1000,(%eax)
			vas = (char*)PGROUNDUP(myproc()->sz);
80107f89:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80107f8f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
			myproc()->shmpgs[pg_num] = pg;
80107f95:	e8 76 b9 ff ff       	call   80103910 <myproc>

			return vas;
80107f9a:	83 c4 10             	add    $0x10,%esp
			myproc()->shmpgs[pg_num] = pg;
80107f9d:	89 9c b0 d0 00 00 00 	mov    %ebx,0xd0(%eax,%esi,4)
		}
	}

	return NULL;
}
80107fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fa7:	89 f8                	mov    %edi,%eax
80107fa9:	5b                   	pop    %ebx
80107faa:	5e                   	pop    %esi
80107fab:	5f                   	pop    %edi
80107fac:	5d                   	pop    %ebp
80107fad:	c3                   	ret    
80107fae:	66 90                	xchg   %ax,%ax
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++)
80107fb0:	b8 a4 fa 12 80       	mov    $0x8012faa4,%eax
80107fb5:	8d 76 00             	lea    0x0(%esi),%esi
		pg->allocated = 0;
80107fb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		pg->name = 0;
80107fbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++)
80107fc5:	83 c0 10             	add    $0x10,%eax
		pg->pa = 0;
80107fc8:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
		pg->ref_count = 0;
80107fcf:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++)
80107fd6:	3d a4 fc 12 80       	cmp    $0x8012fca4,%eax
80107fdb:	72 db                	jb     80107fb8 <shmget+0xc8>
	shmtable.initialized = 1;
80107fdd:	c7 05 a0 fa 12 80 01 	movl   $0x1,0x8012faa0
80107fe4:	00 00 00 
80107fe7:	e9 25 ff ff ff       	jmp    80107f11 <shmget+0x21>
80107fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80107ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return NULL;
80107ff3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80107ff8:	89 f8                	mov    %edi,%eax
80107ffa:	5b                   	pop    %ebx
80107ffb:	5e                   	pop    %esi
80107ffc:	5f                   	pop    %edi
80107ffd:	5d                   	pop    %ebp
80107ffe:	c3                   	ret    
80107fff:	90                   	nop
	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++, pg_num++)
80108000:	bb a4 fa 12 80       	mov    $0x8012faa4,%ebx
80108005:	eb 17                	jmp    8010801e <shmget+0x12e>
80108007:	89 f6                	mov    %esi,%esi
80108009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108010:	83 c3 10             	add    $0x10,%ebx
80108013:	83 c6 01             	add    $0x1,%esi
80108016:	81 fb a4 fc 12 80    	cmp    $0x8012fca4,%ebx
8010801c:	73 d2                	jae    80107ff0 <shmget+0x100>
		if(pg->name == 0)
8010801e:	8b 7b 04             	mov    0x4(%ebx),%edi
80108021:	85 ff                	test   %edi,%edi
80108023:	75 eb                	jne    80108010 <shmget+0x120>
			pg->name = name;
80108025:	89 53 04             	mov    %edx,0x4(%ebx)
			pg->allocated = 1;
80108028:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
			pg->pa = kalloc();
8010802e:	e8 cd a4 ff ff       	call   80102500 <kalloc>
			memset(pg->pa, 0, PGSIZE);
80108033:	83 ec 04             	sub    $0x4,%esp
			pg->pa = kalloc();
80108036:	89 43 08             	mov    %eax,0x8(%ebx)
			pg->ref_count = 1;
80108039:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
			memset(pg->pa, 0, PGSIZE);
80108040:	68 00 10 00 00       	push   $0x1000
80108045:	6a 00                	push   $0x0
80108047:	50                   	push   %eax
80108048:	e8 33 cc ff ff       	call   80104c80 <memset>
			mappages(myproc()->pgdir, (void*)PGROUNDUP(myproc()->sz), PGSIZE, V2P(pg->pa), PTE_W | PTE_U);
8010804d:	8b 43 08             	mov    0x8(%ebx),%eax
80108050:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80108056:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108059:	e8 b2 b8 ff ff       	call   80103910 <myproc>
8010805e:	8b 38                	mov    (%eax),%edi
80108060:	e8 ab b8 ff ff       	call   80103910 <myproc>
80108065:	5a                   	pop    %edx
80108066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108069:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
8010806f:	8b 40 04             	mov    0x4(%eax),%eax
80108072:	59                   	pop    %ecx
80108073:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80108079:	6a 06                	push   $0x6
8010807b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108080:	52                   	push   %edx
80108081:	89 fa                	mov    %edi,%edx
80108083:	e8 78 f5 ff ff       	call   80107600 <mappages>
80108088:	e9 ea fe ff ff       	jmp    80107f77 <shmget+0x87>
8010808d:	8d 76 00             	lea    0x0(%esi),%esi

80108090 <shmrem>:


//This removes a mapping of the shared page from the calling process’s virtual address space
int
shmrem(char* name)
{
80108090:	55                   	push   %ebp
80108091:	89 e5                	mov    %esp,%ebp
80108093:	56                   	push   %esi
80108094:	53                   	push   %ebx
80108095:	8b 55 08             	mov    0x8(%ebp),%edx
	if(name == 0)
80108098:	85 d2                	test   %edx,%edx
8010809a:	74 64                	je     80108100 <shmrem+0x70>
		return -1;
	}

	struct shm_pg *pg;

	int pg_num = 0;
8010809c:	31 f6                	xor    %esi,%esi

	for(pg = shmtable.pages; pg < &shmtable.pages[SHM_MAXNUM]; pg++, pg_num++)
8010809e:	bb a4 fa 12 80       	mov    $0x8012faa4,%ebx
801080a3:	eb 11                	jmp    801080b6 <shmrem+0x26>
801080a5:	8d 76 00             	lea    0x0(%esi),%esi
801080a8:	83 c3 10             	add    $0x10,%ebx
801080ab:	83 c6 01             	add    $0x1,%esi
801080ae:	81 fb a4 fc 12 80    	cmp    $0x8012fca4,%ebx
801080b4:	73 4a                	jae    80108100 <shmrem+0x70>
	{

		if(pg->name == name)
801080b6:	39 53 04             	cmp    %edx,0x4(%ebx)
801080b9:	75 ed                	jne    801080a8 <shmrem+0x18>
		{
			pg->ref_count--;

			if(pg->ref_count == 0)
801080bb:	83 6b 0c 01          	subl   $0x1,0xc(%ebx)
801080bf:	75 e7                	jne    801080a8 <shmrem+0x18>
			{
				myproc()->shmpgs[pg_num] = 0;
801080c1:	e8 4a b8 ff ff       	call   80103910 <myproc>
				kfree(pg->pa);
801080c6:	83 ec 0c             	sub    $0xc,%esp
				myproc()->shmpgs[pg_num] = 0;
801080c9:	c7 84 b0 d0 00 00 00 	movl   $0x0,0xd0(%eax,%esi,4)
801080d0:	00 00 00 00 
				kfree(pg->pa);
801080d4:	ff 73 08             	pushl  0x8(%ebx)
801080d7:	e8 74 a2 ff ff       	call   80102350 <kfree>
				pg->allocated = 0;
				pg->pa = 0;
				pg->name = 0;
				return pg->ref_count;
801080dc:	8b 43 0c             	mov    0xc(%ebx),%eax
				pg->allocated = 0;
801080df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
				return pg->ref_count;
801080e5:	83 c4 10             	add    $0x10,%esp
				pg->pa = 0;
801080e8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
				pg->name = 0;
801080ef:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
		}
	}


	return -1;
}
801080f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080f9:	5b                   	pop    %ebx
801080fa:	5e                   	pop    %esi
801080fb:	5d                   	pop    %ebp
801080fc:	c3                   	ret    
801080fd:	8d 76 00             	lea    0x0(%esi),%esi
80108100:	8d 65 f8             	lea    -0x8(%ebp),%esp
		return -1;
80108103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108108:	5b                   	pop    %ebx
80108109:	5e                   	pop    %esi
8010810a:	5d                   	pop    %ebp
8010810b:	c3                   	ret    
