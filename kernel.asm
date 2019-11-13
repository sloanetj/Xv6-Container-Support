
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2e 10 80       	mov    $0x80102eb0,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
	initlock(&bcache.lock, "bcache");
8010004c:	68 a0 6f 10 80       	push   $0x80106fa0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 f5 41 00 00       	call   80104250 <initlock>
	bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
	bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
		initsleeplock(&b->lock, "buffer");
80100092:	68 a7 6f 10 80       	push   $0x80106fa7
80100097:	50                   	push   %eax
80100098:	e8 a3 40 00 00       	call   80104140 <initsleeplock>
		bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
		bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
		bcache.head.next       = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
	for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 57 42 00 00       	call   80104340 <acquire>
	for (b = bcache.head.next; b != &bcache.head; b = b->next) {
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 f9 42 00 00       	call   80104460 <release>
			acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 40 00 00       	call   80104180 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
	struct buf *b;

	b = bget(dev, blockno);
	if ((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
		iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
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
80100193:	68 ae 6f 10 80       	push   $0x80106fae
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
801001ae:	e8 6d 40 00 00       	call   80104220 <holdingsleep>
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
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
	if (!holdingsleep(&b->lock)) panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 6f 10 80       	push   $0x80106fbf
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
801001ef:	e8 2c 40 00 00       	call   80104220 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>

	releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 3f 00 00       	call   801041e0 <releasesleep>

	acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 30 41 00 00       	call   80104340 <acquire>
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
		b->prev                = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
		b->next                = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
		bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
		bcache.head.next       = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
	}

	release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
	release(&bcache.lock);
8010025c:	e9 ff 41 00 00       	jmp    80104460 <release>
	if (!holdingsleep(&b->lock)) panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 6f 10 80       	push   $0x80106fc6
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
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
	target = n;
	acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 af 40 00 00       	call   80104340 <acquire>
	while (n > 0) {
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
		while (input.r == input.w) {
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
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
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 06 3b 00 00       	call   80103dd0 <sleep>
		while (input.r == input.w) {
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
			if (myproc()->killed) {
801002db:	e8 30 35 00 00       	call   80103810 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
				release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 6c 41 00 00       	call   80104460 <release>
				ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
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
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
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
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 0e 41 00 00       	call   80104460 <release>
	ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
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
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
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
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
	getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
	cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 6f 10 80       	push   $0x80106fcd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
	cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
	cprintf("\n");
801003c5:	c7 04 24 27 79 10 80 	movl   $0x80107927,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
	getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 93 3e 00 00       	call   80104270 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 10; i++) cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 6f 10 80       	push   $0x80106fe1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
	panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
	if (panicked) {
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010043a:	e8 81 57 00 00       	call   80105bc0 <uartputc>
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
801004ec:	e8 cf 56 00 00       	call   80105bc0 <uartputc>
		uartputc(' ');
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 56 00 00       	call   80105bc0 <uartputc>
		uartputc('\b');
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 56 00 00       	call   80105bc0 <uartputc>
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
80100524:	e8 47 40 00 00       	call   80104570 <memmove>
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
80100541:	e8 7a 3f 00 00       	call   801044c0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
	if (pos < 0 || pos > 25 * 80) panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 6f 10 80       	push   $0x80106fe5
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
801005b1:	0f b6 92 10 70 10 80 	movzbl -0x7fef8ff0(%edx),%edx
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
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
	acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 20 3d 00 00       	call   80104340 <acquire>
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
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 14 3e 00 00       	call   80104460 <release>
	ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

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
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 3c 3d 00 00       	call   80104460 <release>
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
801007d0:	ba f8 6f 10 80       	mov    $0x80106ff8,%edx
			for (; *s; s++) consputc(*s);
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (locking) acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 4b 3b 00 00       	call   80104340 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
	if (fmt == 0) panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 6f 10 80       	push   $0x80106fff
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
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 18 3b 00 00       	call   80104340 <acquire>
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
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
				input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
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
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 d3 3b 00 00       	call   80104460 <release>
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
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
				c                                = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
				input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
				c                                = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
				input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
				consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
				if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
					wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
					input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
					wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 75 36 00 00       	call   80103f90 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
				consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
			while (input.e != input.w && input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
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
80100997:	e9 d4 36 00 00       	jmp    80104070 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
				consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
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
801009c6:	68 08 70 10 80       	push   $0x80107008
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 7b 38 00 00       	call   80104250 <initlock>

	devsw[CONSOLE].write = consolewrite;
	devsw[CONSOLE].read  = consoleread;
	cons.locking         = 1;

	ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
	devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 2c 0e 11 80 00 	movl   $0x80100600,0x80110e2c
801009e2:	06 10 80 
	devsw[CONSOLE].read  = consoleread;
801009e5:	c7 05 28 0e 11 80 70 	movl   $0x80100270,0x80110e28
801009ec:	02 10 80 
	cons.locking         = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
	ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
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
80100a1c:	e8 ef 2d 00 00       	call   80103810 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

	begin_op();
80100a27:	e8 84 21 00 00       	call   80102bb0 <begin_op>

	if ((ip = namei(path)) == 0) {
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
		end_op();
		cprintf("exec: fail\n");
		return -1;
	}
	ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
	pgdir = 0;

	// Check ELF header
	if (readi(ip, (char *)&elf, 0, sizeof(elf)) != sizeof(elf)) goto bad;
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>
	return 0;

bad:
	if (pgdir) freevm(pgdir);
	if (ip) {
		iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
		end_op();
80100a6f:	e8 ac 21 00 00       	call   80102c20 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
	}
	return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (elf.magic != ELF_MAGIC) goto bad;
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
	if ((pgdir = setupkvm()) == 0) goto bad;
80100a94:	e8 77 62 00 00       	call   80106d10 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
	sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
	for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ph.type != ELF_PROG_LOAD) continue;
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
		if (ph.memsz < ph.filesz) goto bad;
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
		if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0) goto bad;
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 35 60 00 00       	call   80106b30 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
		if (ph.vaddr % PGSIZE != 0) goto bad;
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
		if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0) goto bad;
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 43 5f 00 00       	call   80106a70 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
	for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
		if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph)) goto bad;
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
	if (pgdir) freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 19 61 00 00       	call   80106c90 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
	iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
	end_op();
80100b9a:	e8 81 20 00 00       	call   80102c20 <end_op>
	if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) goto bad;
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 81 5f 00 00       	call   80106b30 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
	if (pgdir) freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ca 60 00 00       	call   80106c90 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
	return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
		end_op();
80100bd3:	e8 48 20 00 00       	call   80102c20 <end_op>
		cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 70 10 80       	push   $0x80107021
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
		return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
	clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
	for (argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
	clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 a5 61 00 00       	call   80106db0 <clearpteu>
	for (argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (argc >= MAXARG) goto bad;
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
		sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 a2 3a 00 00       	call   801046e0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
		if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) goto bad;
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
		sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
		if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) goto bad;
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 8f 3a 00 00       	call   801046e0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 9e 62 00 00       	call   80106f00 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
	for (argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
		ustack[3 + argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
	for (argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
		ustack[3 + argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
	for (argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
	ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
	ustack[3 + argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
	ustack[0] = 0xffffffff; // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
	ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
	ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
	sp -= (3 + argc + 1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
	if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) goto bad;
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
	ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
	if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) goto bad;
80100cc7:	e8 34 62 00 00       	call   80106f00 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
	for (last = s = path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
	safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 91 39 00 00       	call   801046a0 <safestrcpy>
	curproc->pgdir   = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
	oldpgdir         = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
	curproc->tf->eip = elf.entry; // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
	curproc->sz      = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
	curproc->pgdir   = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
	curproc->tf->eip = elf.entry; // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
	curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
	switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 a7 5b 00 00       	call   801068e0 <switchuvm>
	freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 4f 5f 00 00       	call   80106c90 <freevm>
	return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
	for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
	struct file     file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
	initlock(&ftable.lock, "ftable");
80100d66:	68 2d 70 10 80       	push   $0x8010702d
80100d6b:	68 80 04 11 80       	push   $0x80110480
80100d70:	e8 db 34 00 00       	call   80104250 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
	struct file *f;

	acquire(&ftable.lock);
	for (f = ftable.file; f < ftable.file + NFILE; f++) {
80100d84:	bb b4 04 11 80       	mov    $0x801104b4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
	acquire(&ftable.lock);
80100d8c:	68 80 04 11 80       	push   $0x80110480
80100d91:	e8 aa 35 00 00       	call   80104340 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (f = ftable.file; f < ftable.file + NFILE; f++) {
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 14 0e 11 80    	cmp    $0x80110e14,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
		if (f->ref == 0) {
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
			f->ref = 1;
			release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
			f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
			release(&ftable.lock);
80100dbc:	68 80 04 11 80       	push   $0x80110480
80100dc1:	e8 9a 36 00 00       	call   80104460 <release>
			return f;
		}
	}
	release(&ftable.lock);
	return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
			return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
	release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
	return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
	release(&ftable.lock);
80100dd5:	68 80 04 11 80       	push   $0x80110480
80100dda:	e8 81 36 00 00       	call   80104460 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
	return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ftable.lock);
80100dfa:	68 80 04 11 80       	push   $0x80110480
80100dff:	e8 3c 35 00 00       	call   80104340 <acquire>
	if (f->ref < 1) panic("filedup");
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
	f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
	release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
	f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
	release(&ftable.lock);
80100e17:	68 80 04 11 80       	push   $0x80110480
80100e1c:	e8 3f 36 00 00       	call   80104460 <release>
	return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
	if (f->ref < 1) panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 34 70 10 80       	push   $0x80107034
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct file ff;

	acquire(&ftable.lock);
80100e4c:	68 80 04 11 80       	push   $0x80110480
80100e51:	e8 ea 34 00 00       	call   80104340 <acquire>
	if (f->ref < 1) panic("fileclose");
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
	if (--f->ref > 0) {
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
		release(&ftable.lock);
80100e6e:	c7 45 08 80 04 11 80 	movl   $0x80110480,0x8(%ebp)
	else if (ff.type == FD_INODE) {
		begin_op();
		iput(ff.ip);
		end_op();
	}
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
		release(&ftable.lock);
80100e7c:	e9 df 35 00 00       	jmp    80104460 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	ff      = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
	release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
	ff      = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
	f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	ff      = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
	release(&ftable.lock);
80100ea0:	68 80 04 11 80       	push   $0x80110480
	ff      = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	release(&ftable.lock);
80100ea8:	e8 b3 35 00 00       	call   80104460 <release>
	if (ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
	else if (ff.type == FD_INODE) {
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 8a 24 00 00       	call   80103360 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		begin_op();
80100ee0:	e8 cb 1c 00 00       	call   80102bb0 <begin_op>
		iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
		end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
		end_op();
80100efa:	e9 21 1d 00 00       	jmp    80102c20 <end_op>
	if (f->ref < 1) panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 3c 70 10 80       	push   $0x8010703c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (f->type == FD_INODE) {
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
		ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
		stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
		iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
		return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
	}
	return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	if (f->readable == 0) return -1;
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
	if (f->type == FD_PIPE) return piperead(f->pipe, addr, n);
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
	if (f->type == FD_INODE) {
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
		ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
		if ((r = readi(f->ip, addr, f->off, n)) > 0) f->off += r;
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
		iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
		return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
	}
	panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
	if (f->type == FD_PIPE) return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
	if (f->type == FD_PIPE) return piperead(f->pipe, addr, n);
80100fcd:	e9 3e 25 00 00       	jmp    80103510 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (f->readable == 0) return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
	panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 46 70 10 80       	push   $0x80107046
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

// PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int r;

	if (f->writable == 0) return -1;
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (f->writable == 0) return -1;
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
	if (f->type == FD_PIPE) return pipewrite(f->pipe, addr, n);
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
	if (f->type == FD_INODE) {
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
		// and 2 blocks of slop for non-aligned writes.
		// this really belongs lower down, since writei()
		// might be writing a device like the console.
		int max = ((LOGSIZE - 1 - 1 - 2) / 2) * 512;
		int i   = 0;
		while (i < n) {
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
		int i   = 0;
80101029:	31 ff                	xor    %edi,%edi
		while (i < n) {
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			int n1 = n - i;
			if (n1 > max) n1= max;

			begin_op();
			ilock(f->ip);
			if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
			iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
			if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
			iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
			end_op();
80101049:	e8 d2 1b 00 00       	call   80102c20 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

			if (r < 0) break;
			if (r != n1) panic("short filewrite");
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
			i += r;
8010105c:	01 df                	add    %ebx,%edi
		while (i < n) {
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
			int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
			begin_op();
80101076:	e8 35 1b 00 00       	call   80102bb0 <begin_op>
			ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
			if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) f->off += r;
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
			iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
			end_op();
801010ad:	e8 6e 1b 00 00       	call   80102c20 <end_op>
			if (r < 0) break;
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
		}
		return i == n ? n : -1;
	}
	panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
	if (f->writable == 0) return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
	if (f->type == FD_PIPE) return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
	if (f->type == FD_PIPE) return pipewrite(f->pipe, addr, n);
801010ed:	e9 0e 23 00 00       	jmp    80103400 <pipewrite>
			if (r != n1) panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 4f 70 10 80       	push   $0x8010704f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
	panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 55 70 10 80       	push   $0x80107055
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
	int         b, bi, m;
	struct buf *bp;

	bp = 0;
	for (b = 0; b < sb.size; b += BPB) {
80101119:	8b 0d 80 0e 11 80    	mov    0x80110e80,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (b = 0; b < sb.size; b += BPB) {
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 98 0e 11 80    	add    0x80110e98,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010114e:	a1 80 0e 11 80       	mov    0x80110e80,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
			m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
			if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
			if ((bp->data[bi / 8] & m) == 0) { // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
				brelse(bp);
				bzero(dev, b + bi);
				return b + bi;
			}
		}
		brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
	for (b = 0; b < sb.size; b += BPB) {
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 80 0e 11 80    	cmp    %eax,0x80110e80
801011af:	77 80                	ja     80101131 <balloc+0x21>
	}
	panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 5f 70 10 80       	push   $0x8010705f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
				bp->data[bi / 8] |= m;     // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
				log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
				bp->data[bi / 8] |= m;     // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
				log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 ae 1b 00 00       	call   80102d80 <log_write>
				brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
	bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
	memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 c6 32 00 00       	call   801044c0 <memset>
	log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 7e 1b 00 00       	call   80102d80 <log_write>
	brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode *
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
	struct inode *ip, *empty;

	acquire(&icache.lock);

	// Is the inode already cached?
	empty = 0;
80101228:	31 f6                	xor    %esi,%esi
	for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
8010122a:	bb d4 0e 11 80       	mov    $0x80110ed4,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	acquire(&icache.lock);
80101235:	68 a0 0e 11 80       	push   $0x80110ea0
8010123a:	e8 01 31 00 00       	call   80104340 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
	for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb f4 2a 11 80    	cmp    $0x80112af4,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
			ip->ref++;
			release(&icache.lock);
			return ip;
		}
		if (empty == 0 && ip->ref == 0) // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
	for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb f4 2a 11 80    	cmp    $0x80112af4,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
			empty = ip;
	}

	// Recycle an inode cache entry.
	if (empty == 0) panic("iget: no inodes");
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
	ip        = empty;
	ip->dev   = dev;
	ip->inum  = inum;
	ip->ref   = 1;
	ip->valid = 0;
	release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
	ip->dev   = dev;
80101287:	89 3e                	mov    %edi,(%esi)
	ip->inum  = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
	ip->ref   = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
	ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
	release(&icache.lock);
8010129a:	68 a0 0e 11 80       	push   $0x80110ea0
8010129f:	e8 bc 31 00 00       	call   80104460 <release>

	return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
			release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
			ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
			return ip;
801012c3:	89 de                	mov    %ebx,%esi
			release(&icache.lock);
801012c5:	68 a0 0e 11 80       	push   $0x80110ea0
			ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
			release(&icache.lock);
801012cd:	e8 8e 31 00 00       	call   80104460 <release>
			return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
	if (empty == 0) panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 75 70 10 80       	push   $0x80107075
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
	uint        addr, *a;
	struct buf *bp;

	if (bn < NDIRECT) {
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
		if ((addr = ip->addrs[bn]) == 0) ip->addrs[bn] = addr = balloc(ip->dev);
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
		brelse(bp);
		return addr;
	}

	panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
	if (bn < NINDIRECT) {
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
		if ((addr = ip->addrs[NDIRECT]) == 0) ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
		bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
		if ((addr = a[bn]) == 0) {
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
		bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
		if ((addr = a[bn]) == 0) {
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
			a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
			a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
			log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 1d 1a 00 00       	call   80102d80 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
		brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if ((addr = ip->addrs[bn]) == 0) ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if ((addr = ip->addrs[bn]) == 0) ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if ((addr = ip->addrs[NDIRECT]) == 0) ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
	panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 85 70 10 80       	push   $0x80107085
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
	bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
	memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 7a 31 00 00       	call   80104570 <memmove>
	brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
	brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
	readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 80 0e 11 80       	push   $0x80110e80
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
	bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 98 0e 11 80    	add    0x80110e98,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
	m  = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
8010143d:	c1 fb 03             	sar    $0x3,%ebx
	m  = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
	m  = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
	bp->data[bi / 8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
	log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
	bp->data[bi / 8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
	log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 11 19 00 00       	call   80102d80 <log_write>
	brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
	if ((bp->data[bi / 8] & m) == 0) panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 98 70 10 80       	push   $0x80107098
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb e0 0e 11 80       	mov    $0x80110ee0,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
	initlock(&icache.lock, "icache");
8010149c:	68 ab 70 10 80       	push   $0x801070ab
801014a1:	68 a0 0e 11 80       	push   $0x80110ea0
801014a6:	e8 a5 2d 00 00       	call   80104250 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
		initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 b2 70 10 80       	push   $0x801070b2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 7c 2c 00 00       	call   80104140 <initsleeplock>
	for (i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 00 2b 11 80    	cmp    $0x80112b00,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
	readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 80 0e 11 80       	push   $0x80110e80
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
	cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 98 0e 11 80    	pushl  0x80110e98
801014e5:	ff 35 94 0e 11 80    	pushl  0x80110e94
801014eb:	ff 35 90 0e 11 80    	pushl  0x80110e90
801014f1:	ff 35 8c 0e 11 80    	pushl  0x80110e8c
801014f7:	ff 35 88 0e 11 80    	pushl  0x80110e88
801014fd:	ff 35 84 0e 11 80    	pushl  0x80110e84
80101503:	ff 35 80 0e 11 80    	pushl  0x80110e80
80101509:	68 18 71 10 80       	push   $0x80107118
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
	for (inum = 1; inum < sb.ninodes; inum++) {
80101529:	83 3d 88 0e 11 80 01 	cmpl   $0x1,0x80110e88
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (inum = 1; inum < sb.ninodes; inum++) {
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
	for (inum = 1; inum < sb.ninodes; inum++) {
80101553:	83 c3 01             	add    $0x1,%ebx
		brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
	for (inum = 1; inum < sb.ninodes; inum++) {
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d 88 0e 11 80    	cmp    %ebx,0x80110e88
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
		bp  = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 94 0e 11 80    	add    0x80110e94,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
		dip = (struct dinode *)bp->data + inum % IPB;
8010157e:	89 d8                	mov    %ebx,%eax
		if (dip->type == 0) { // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
		dip = (struct dinode *)bp->data + inum % IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
		if (dip->type == 0) { // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
			memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 1d 2f 00 00       	call   801044c0 <memset>
			dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
			log_write(bp); // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 cb 17 00 00       	call   80102d80 <log_write>
			brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
			return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
			return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
	panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 b8 70 10 80       	push   $0x801070b8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	bp         = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
	bp         = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 94 0e 11 80    	add    0x80110e94,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
	dip        = (struct dinode *)bp->data + ip->inum % IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
	dip->type  = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
	dip        = (struct dinode *)bp->data + ip->inum % IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
	dip->type  = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
	dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
	dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
	dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
	dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
	dip->size  = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
	memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 2a 2f 00 00       	call   80104570 <memmove>
	log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 32 17 00 00       	call   80102d80 <log_write>
	brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
	brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&icache.lock);
8010166a:	68 a0 0e 11 80       	push   $0x80110ea0
8010166f:	e8 cc 2c 00 00       	call   80104340 <acquire>
	ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
	release(&icache.lock);
80101678:	c7 04 24 a0 0e 11 80 	movl   $0x80110ea0,(%esp)
8010167f:	e8 dc 2d 00 00       	call   80104460 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (ip == 0 || ip->ref < 1) panic("ilock");
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
	acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 c9 2a 00 00       	call   80104180 <acquiresleep>
	if (ip->valid == 0) {
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		bp        = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 94 0e 11 80    	add    0x80110e94,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
		dip       = (struct dinode *)bp->data + ip->inum % IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
		dip       = (struct dinode *)bp->data + ip->inum % IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
		ip->type  = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
		ip->type  = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
		ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
		ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
		ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
		ip->size  = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
		memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 43 2e 00 00       	call   80104570 <memmove>
		brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
		if (ip->type == 0) panic("ilock: no type");
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
		ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
		if (ip->type == 0) panic("ilock: no type");
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 d0 70 10 80       	push   $0x801070d0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
	if (ip == 0 || ip->ref < 1) panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ca 70 10 80       	push   $0x801070ca
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 98 2a 00 00       	call   80104220 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
	releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
	releasesleep(&ip->lock);
8010179f:	e9 3c 2a 00 00       	jmp    801041e0 <releasesleep>
	if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 df 70 10 80       	push   $0x801070df
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 ab 29 00 00       	call   80104180 <acquiresleep>
	if (ip->valid && ip->nlink == 0) {
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
	releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 f1 29 00 00       	call   801041e0 <releasesleep>
	acquire(&icache.lock);
801017ef:	c7 04 24 a0 0e 11 80 	movl   $0x80110ea0,(%esp)
801017f6:	e8 45 2b 00 00       	call   80104340 <acquire>
	ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
	release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 a0 0e 11 80 	movl   $0x80110ea0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
	release(&icache.lock);
80101810:	e9 4b 2c 00 00       	jmp    80104460 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
		acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 a0 0e 11 80       	push   $0x80110ea0
80101820:	e8 1b 2b 00 00       	call   80104340 <acquire>
		int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
		release(&icache.lock);
80101828:	c7 04 24 a0 0e 11 80 	movl   $0x80110ea0,(%esp)
8010182f:	e8 2c 2c 00 00       	call   80104460 <release>
		if (r == 1) {
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
	int         i, j;
	struct buf *bp;
	uint *      a;

	for (i = 0; i < NDIRECT; i++) {
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
		if (ip->addrs[i]) {
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
			bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
			ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		}
	}

	if (ip->addrs[NDIRECT]) {
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
		bfree(ip->dev, ip->addrs[NDIRECT]);
		ip->addrs[NDIRECT] = 0;
	}

	ip->size = 0;
	iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
	ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
			ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
			iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
			ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		a  = (uint *)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
		for (j = 0; j < NINDIRECT; j++) {
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
			if (a[j]) bfree(ip->dev, a[j]);
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
		brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
		bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
		ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
	iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
	iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
	iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
	st->dev   = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
	st->ino   = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
	st->type  = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
	st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
	st->size  = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
// PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
	uint        tot, m;
	struct buf *bp;

	if (ip->type == T_DEV) {
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (ip->type == T_DEV) {
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) return -1;
		return devsw[ip->major].read(ip, dst, n);
	}

	if (off > ip->size || off + n < off) return -1;
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
	if (off + n > ip->size) n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
	if (off + n > ip->size) n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
		m  = min(n - tot, BSIZE - off % BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
		m  = min(n - tot, BSIZE - off % BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
		memmove(dst, bp->data + off % BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
		m  = min(n - tot, BSIZE - off % BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(dst, bp->data + off % BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101a10:	01 df                	add    %ebx,%edi
		memmove(dst, bp->data + off % BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101a15:	01 de                	add    %ebx,%esi
		memmove(dst, bp->data + off % BSIZE, m);
80101a17:	e8 54 2b 00 00       	call   80104570 <memmove>
		brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
	}
	return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) return -1;
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 20 0e 11 80 	mov    -0x7feef1e0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
		return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
		return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
	uint        tot, m;
	struct buf *bp;

	if (ip->type == T_DEV) {
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
	if (ip->type == T_DEV) {
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) return -1;
		return devsw[ip->major].write(ip, src, n);
	}

	if (off > ip->size || off + n < off) return -1;
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
	if (off + n > MAXFILE * BSIZE) return -1;
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>

	for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
		m  = min(n - tot, BSIZE - off % BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
		bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
		m  = min(n - tot, BSIZE - off % BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
		memmove(bp->data + off % BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
		m  = min(n - tot, BSIZE - off % BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
		memmove(bp->data + off % BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
	for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101b10:	01 de                	add    %ebx,%esi
		memmove(bp->data + off % BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 58 2a 00 00       	call   80104570 <memmove>
		log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 60 12 00 00       	call   80102d80 <log_write>
		brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
	for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
	}

	if (n > 0 && off > ip->size) {
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
		ip->size = off;
		iupdate(ip);
	}
	return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) return -1;
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 24 0e 11 80 	mov    -0x7feef1dc(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
		return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
		return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
		iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
		ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
		iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
// PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
	return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 2d 2a 00 00       	call   801045e0 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint          off, inum;
	struct dirent de;

	if (dp->type != T_DIR) panic("dirlookup not DIR");
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>

	for (off = 0; off < dp->size; off += sizeof(de)) {
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlookup read");
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
		if (de.inum == 0) continue;
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
	return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 ce 29 00 00       	call   801045e0 <strncmp>
		if (namecmp(name, de.name) == 0) {
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
	for (off = 0; off < dp->size; off += sizeof(de)) {
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
			return iget(dp->dev, inum);
		}
	}

	return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if (poff) *poff = off;
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
			inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
			return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 f9 70 10 80       	push   $0x801070f9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
	if (dp->type != T_DIR) panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 e7 70 10 80       	push   $0x801070e7
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
	struct inode *ip, *next;

	if (*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
	if (*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
		ip = iget(ROOTDEV, ROOTINO);
	else
		ip = idup(myproc()->cwd);
80101c89:	e8 82 1b 00 00       	call   80103810 <myproc>
	acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
		ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
	acquire(&icache.lock);
80101c94:	68 a0 0e 11 80       	push   $0x80110ea0
80101c99:	e8 a2 26 00 00       	call   80104340 <acquire>
	ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
	release(&icache.lock);
80101ca2:	c7 04 24 a0 0e 11 80 	movl   $0x80110ea0,(%esp)
80101ca9:	e8 b2 27 00 00       	call   80104460 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while (*path == '/') path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
	if (*path == 0) return 0;
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
	while (*path != '/' && *path != 0) path++;
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
80101ce4:	83 c2 01             	add    $0x1,%edx
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
	if (len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
		memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 66 28 00 00       	call   80104570 <memmove>
	while (*path != '/' && *path != 0) path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
		memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
	while (*path != '/' && *path != 0) path++;
80101d10:	89 d3                	mov    %edx,%ebx
	while (*path == '/') path++;
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101d20:	83 c3 01             	add    $0x1,%ebx
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

	while ((path = skipelem(path, name)) != 0) {
		ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
		if (ip->type != T_DIR) {
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
			iunlockput(ip);
			return 0;
		}
		if (nameiparent && *path == '\0') {
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
			// Stop one level early.
			iunlock(ip);
			return ip;
		}
		if ((next = dirlookup(ip, name, 0)) == 0) {
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
	iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
	iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while (*path != '/' && *path != 0) path++;
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
		memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 d3 27 00 00       	call   80104570 <memmove>
		name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			return 0;
		}
		iunlockput(ip);
		ip = next;
	}
	if (nameiparent) {
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
		iput(ip);
		return 0;
	}
	return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
	iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
			return 0;
80101ddc:	31 f6                	xor    %esi,%esi
	iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
			return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
		ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
			iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
			return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
		iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
		return 0;
80101e20:	31 f6                	xor    %esi,%esi
		iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
		return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if ((ip = dirlookup(dp, name, 0)) != 0) {
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
	for (off = 0; off < dp->size; off += sizeof(de)) {
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink read");
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
		if (de.inum == 0) break;
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
	strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 ae 27 00 00       	call   80104640 <strncpy>
	de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink");
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
	de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink");
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
	return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
		iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
		return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 08 71 10 80       	push   $0x80107108
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 0e 77 10 80       	push   $0x8010770e
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode *
namei(char *path)
{
80101ef0:	55                   	push   %ebp
	char name[DIRSIZ];
	return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
	return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
	return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
	return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
	return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
	if (b == 0) panic("idestart");
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
	if (b->blockno >= FSSIZE) panic("incorrect blockno");
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
	while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

	idewait(0);
	outb(0x3f6, 0);                // generate interrupt
	outb(0x1f2, sector_per_block); // number of sectors
	outb(0x1f3, sector & 0xff);
	outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
	outb(0x1f5, (sector >> 16) & 0xff);
	outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
	if (b->flags & B_DIRTY) {
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
		outb(0x1f7, write_cmd);
		outsl(0x1f0, b->data, BSIZE / 4);
	} else {
		outb(0x1f7, read_cmd);
	}
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
	asm volatile("cld; rep outsl" : "=S"(addr), "=c"(cnt) : "d"(port), "0"(addr), "1"(cnt) : "cc");
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
		outsl(0x1f0, b->data, BSIZE / 4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
	if (b->blockno >= FSSIZE) panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 74 71 10 80       	push   $0x80107174
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
	if (b == 0) panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 6b 71 10 80       	push   $0x8010716b
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
	initlock(&idelock, "ide");
80102016:	68 86 71 10 80       	push   $0x80107186
8010201b:	68 80 a5 10 80       	push   $0x8010a580
80102020:	e8 2b 22 00 00       	call   80104250 <initlock>
	ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 c0 31 11 80       	mov    0x801131c0,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
	while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
	for (i = 0; i < 1000; i++) {
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
		if (inb(0x1f7) != 0) {
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
			havedisk1 = 1;
8010206a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102071:	00 00 00 
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
	struct buf *b;

	// First queued buffer is the active request.
	acquire(&idelock);
80102099:	68 80 a5 10 80       	push   $0x8010a580
8010209e:	e8 9d 22 00 00       	call   80104340 <acquire>

	if ((b = idequeue) == 0) {
801020a3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
		release(&idelock);
		return;
	}
	idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

	// Read data if needed.
	if (!(b->flags & B_DIRTY) && idewait(1) >= 0) insl(0x1f0, b->data, BSIZE / 4);
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
	while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
	if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0) return -1;
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
	if (!(b->flags & B_DIRTY) && idewait(1) >= 0) insl(0x1f0, b->data, BSIZE / 4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
	asm volatile("cld; rep insl" : "=D"(addr), "=c"(cnt) : "d"(port), "0"(addr), "1"(cnt) : "memory", "cc");
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

	// Wake process waiting for this buf.
	b->flags |= B_VALID;
	b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
	wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
	b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
	wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 8a 1e 00 00       	call   80103f90 <wakeup>

	// Start disk on next buf in queue.
	if (idequeue != 0) idestart(idequeue);
80102106:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
		release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 a5 10 80       	push   $0x8010a580
8010211f:	e8 3c 23 00 00       	call   80104460 <release>

	release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct buf **pp;

	if (!holdingsleep(&b->lock)) panic("iderw: buf not locked");
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 dd 20 00 00       	call   80104220 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
	if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) panic("iderw: nothing to do");
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
	if (b->dev != 0 && !havedisk1) panic("iderw: ide disk 1 not present");
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>

	acquire(&idelock); // DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	e8 c3 21 00 00       	call   80104340 <acquire>

	// Append b to idequeue.
	b->qnext = 0;
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
8010217d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102183:	83 c4 10             	add    $0x10,%esp
	b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
		;
	*pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

	// Start disk if necessary.
	if (idequeue == b) idestart(b);
801021a6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021ac:	74 42                	je     801021f0 <iderw+0xc0>

	// Wait for request to finish.
	while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 a5 10 80       	push   $0x8010a580
801021c8:	53                   	push   %ebx
801021c9:	e8 02 1c 00 00       	call   80103dd0 <sleep>
	while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
	}


	release(&idelock);
801021db:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
	release(&idelock);
801021e6:	e9 75 22 00 00       	jmp    80104460 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (idequeue == b) idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
80102200:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
	if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 a0 71 10 80       	push   $0x801071a0
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
	if (!holdingsleep(&b->lock)) panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 8a 71 10 80       	push   $0x8010718a
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
	if (b->dev != 0 && !havedisk1) panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 b5 71 10 80       	push   $0x801071b5
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
	ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
	int i, id, maxintr;

	ioapic  = (volatile struct ioapic *)IOAPIC;
80102231:	c7 05 f4 2a 11 80 00 	movl   $0xfec00000,0x80112af4
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
	ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
	return ioapic->data;
80102249:	a1 f4 2a 11 80       	mov    0x80112af4,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
	ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return ioapic->data;
80102257:	8b 0d f4 2a 11 80    	mov    0x80112af4,%ecx
	maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
	id      = ioapicread(REG_ID) >> 24;
	if (id != ioapicid) cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010225d:	0f b6 15 20 2c 11 80 	movzbl 0x80112c20,%edx
	maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
	return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
	maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
	id      = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
	if (id != ioapicid) cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 d4 71 10 80       	push   $0x801071d4
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d f4 2a 11 80    	mov    0x80112af4,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	ioapic->reg  = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
	ioapic->data = data;
801022a2:	8b 0d f4 2a 11 80    	mov    0x80112af4,%ecx

	// Mark all interrupts edge-triggered, active high, disabled,
	// and not routed to any CPUs.
	for (i = 0; i <= maxintr; i++) {
		ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
	ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
	for (i = 0; i <= maxintr; i++) {
801022bc:	39 d8                	cmp    %ebx,%eax
	ioapic->reg  = reg;
801022be:	89 31                	mov    %esi,(%ecx)
	ioapic->data = data;
801022c0:	8b 0d f4 2a 11 80    	mov    0x80112af4,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
	for (i = 0; i <= maxintr; i++) {
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
		ioapicwrite(REG_TABLE + 2 * i + 1, 0);
	}
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
	ioapic->reg  = reg;
801022e1:	8b 0d f4 2a 11 80    	mov    0x80112af4,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
	// Mark interrupt edge-triggered, active high,
	// enabled, and routed to the given cpunum,
	// which happens to be that cpu's APIC ID.
	ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
	ioapic->reg  = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
	ioapic->data = data;
801022f5:	8b 0d f4 2a 11 80    	mov    0x80112af4,%ecx
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
	ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
	ioapic->reg  = reg;
80102304:	89 01                	mov    %eax,(%ecx)
	ioapic->data = data;
80102306:	a1 f4 2a 11 80       	mov    0x80112af4,%eax
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
	ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct run *r;

	if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) panic("kfree");
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb 68 6d 11 80    	cmp    $0x80116d68,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>

	// Fill with junk to catch dangling refs.
	memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 69 21 00 00       	call   801044c0 <memset>

	if (kmem.use_lock) acquire(&kmem.lock);
80102357:	8b 15 34 2b 11 80    	mov    0x80112b34,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
	r             = (struct run *)v;
	r->next       = kmem.freelist;
80102364:	a1 38 2b 11 80       	mov    0x80112b38,%eax
80102369:	89 03                	mov    %eax,(%ebx)
	kmem.freelist = r;
	if (kmem.use_lock) release(&kmem.lock);
8010236b:	a1 34 2b 11 80       	mov    0x80112b34,%eax
	kmem.freelist = r;
80102370:	89 1d 38 2b 11 80    	mov    %ebx,0x80112b38
	if (kmem.use_lock) release(&kmem.lock);
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
	if (kmem.use_lock) release(&kmem.lock);
80102380:	c7 45 08 00 2b 11 80 	movl   $0x80112b00,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
	if (kmem.use_lock) release(&kmem.lock);
8010238b:	e9 d0 20 00 00       	jmp    80104460 <release>
	if (kmem.use_lock) acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 00 2b 11 80       	push   $0x80112b00
80102398:	e8 a3 1f 00 00       	call   80104340 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
	if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 06 72 10 80       	push   $0x80107206
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
	p = (char *)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
	p = (char *)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
	initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 0c 72 10 80       	push   $0x8010720c
80102410:	68 00 2b 11 80       	push   $0x80112b00
80102415:	e8 36 1e 00 00       	call   80104250 <initlock>
	p = (char *)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
8010241d:	83 c4 10             	add    $0x10,%esp
	kmem.use_lock = 0;
80102420:	c7 05 34 2b 11 80 00 	movl   $0x0,0x80112b34
80102427:	00 00 00 
	p = (char *)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
	p = (char *)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
	p = (char *)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
	kmem.use_lock = 1;
801024b4:	c7 05 34 2b 11 80 01 	movl   $0x1,0x80112b34
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char *
kalloc(void)
{
	struct run *r;

	if (kmem.use_lock) acquire(&kmem.lock);
801024d0:	a1 34 2b 11 80       	mov    0x80112b34,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
	r = kmem.freelist;
801024d9:	a1 38 2b 11 80       	mov    0x80112b38,%eax
	if (r) kmem.freelist= r->next;
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 38 2b 11 80    	mov    %edx,0x80112b38
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (kmem.use_lock) release(&kmem.lock);
	return (char *)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
	if (kmem.use_lock) acquire(&kmem.lock);
801024fe:	68 00 2b 11 80       	push   $0x80112b00
80102503:	e8 38 1e 00 00       	call   80104340 <acquire>
	r = kmem.freelist;
80102508:	a1 38 2b 11 80       	mov    0x80112b38,%eax
	if (r) kmem.freelist= r->next;
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 34 2b 11 80    	mov    0x80112b34,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 38 2b 11 80    	mov    %ecx,0x80112b38
	if (kmem.use_lock) release(&kmem.lock);
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 00 2b 11 80       	push   $0x80112b00
80102531:	e8 2a 1f 00 00       	call   80104460 <release>
	return (char *)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
	if (kmem.use_lock) release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <kbdgetc>:
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
	static uint   shift;
	static uchar *charcode[4] = {normalmap, shiftmap, ctlmap, ctlmap};
	uint          st, data, c;

	st = inb(KBSTATP);
	if ((st & KBS_DIB) == 0) return -1;
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 c2 00 00 00    	je     80102610 <kbdgetc+0xd0>
8010254e:	ba 60 00 00 00       	mov    $0x60,%edx
80102553:	ec                   	in     (%dx),%al
	data = inb(KBDATAP);
80102554:	0f b6 d0             	movzbl %al,%edx
80102557:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

	if (data == 0xE0) {
8010255d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102563:	0f 84 7f 00 00 00    	je     801025e8 <kbdgetc+0xa8>
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	53                   	push   %ebx
8010256d:	89 cb                	mov    %ecx,%ebx
8010256f:	83 e3 40             	and    $0x40,%ebx
		shift |= E0ESC;
		return 0;
	} else if (data & 0x80) {
80102572:	84 c0                	test   %al,%al
80102574:	78 4a                	js     801025c0 <kbdgetc+0x80>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
		shift &= ~(shiftcode[data] | E0ESC);
		return 0;
	} else if (shift & E0ESC) {
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 09                	je     80102583 <kbdgetc+0x43>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
8010257a:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
8010257d:	83 e1 bf             	and    $0xffffffbf,%ecx
		data |= 0x80;
80102580:	0f b6 d0             	movzbl %al,%edx
	}

	shift |= shiftcode[data];
80102583:	0f b6 82 40 73 10 80 	movzbl -0x7fef8cc0(%edx),%eax
8010258a:	09 c1                	or     %eax,%ecx
	shift ^= togglecode[data];
8010258c:	0f b6 82 40 72 10 80 	movzbl -0x7fef8dc0(%edx),%eax
80102593:	31 c1                	xor    %eax,%ecx
	c = charcode[shift & (CTL | SHIFT)][data];
80102595:	89 c8                	mov    %ecx,%eax
	shift ^= togglecode[data];
80102597:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
	c = charcode[shift & (CTL | SHIFT)][data];
8010259d:	83 e0 03             	and    $0x3,%eax
	if (shift & CAPSLOCK) {
801025a0:	83 e1 08             	and    $0x8,%ecx
	c = charcode[shift & (CTL | SHIFT)][data];
801025a3:	8b 04 85 20 72 10 80 	mov    -0x7fef8de0(,%eax,4),%eax
801025aa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
	if (shift & CAPSLOCK) {
801025ae:	74 31                	je     801025e1 <kbdgetc+0xa1>
		if ('a' <= c && c <= 'z')
801025b0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b3:	83 fa 19             	cmp    $0x19,%edx
801025b6:	77 40                	ja     801025f8 <kbdgetc+0xb8>
			c += 'A' - 'a';
801025b8:	83 e8 20             	sub    $0x20,%eax
		else if ('A' <= c && c <= 'Z')
			c += 'a' - 'A';
	}
	return c;
}
801025bb:	5b                   	pop    %ebx
801025bc:	5d                   	pop    %ebp
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
		data = (shift & E0ESC ? data : data & 0x7F);
801025c0:	83 e0 7f             	and    $0x7f,%eax
801025c3:	85 db                	test   %ebx,%ebx
801025c5:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
801025c8:	0f b6 82 40 73 10 80 	movzbl -0x7fef8cc0(%edx),%eax
801025cf:	83 c8 40             	or     $0x40,%eax
801025d2:	0f b6 c0             	movzbl %al,%eax
801025d5:	f7 d0                	not    %eax
801025d7:	21 c1                	and    %eax,%ecx
		return 0;
801025d9:	31 c0                	xor    %eax,%eax
		shift &= ~(shiftcode[data] | E0ESC);
801025db:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025e1:	5b                   	pop    %ebx
801025e2:	5d                   	pop    %ebp
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		shift |= E0ESC;
801025e8:	83 c9 40             	or     $0x40,%ecx
		return 0;
801025eb:	31 c0                	xor    %eax,%eax
		shift |= E0ESC;
801025ed:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
		return 0;
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		else if ('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
			c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025fe:	5b                   	pop    %ebx
			c += 'a' - 'A';
801025ff:	83 f9 1a             	cmp    $0x1a,%ecx
80102602:	0f 42 c2             	cmovb  %edx,%eax
}
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if ((st & KBS_DIB) == 0) return -1;
80102610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102615:	c3                   	ret    
80102616:	8d 76 00             	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 14             	sub    $0x14,%esp
	consoleintr(kbdgetc);
80102626:	68 40 25 10 80       	push   $0x80102540
8010262b:	e8 e0 e1 ff ff       	call   80100810 <consoleintr>
}
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	c9                   	leave  
80102634:	c3                   	ret    
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <lapicinit>:
// PAGEBREAK!

void
lapicinit(void)
{
	if (!lapic) return;
80102640:	a1 3c 2b 11 80       	mov    0x80112b3c,%eax
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
	if (!lapic) return;
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c8 00 00 00    	je     80102718 <lapicinit+0xd8>
	lapic[index] = value;
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
	lapic[ID]; // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
	lapic[ID]; // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
	lapic[ID]; // wait for write to finish, by reading
80102681:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
	lapic[ID]; // wait for write to finish, by reading
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
	lapic[ID]; // wait for write to finish, by reading
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
	lapicw(LINT0, MASKED);
	lapicw(LINT1, MASKED);

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER] >> 16) & 0xFF) >= 4) lapicw(PCINT, MASKED);
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 77                	ja     80102720 <lapicinit+0xe0>
	lapic[index] = value;
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
	lapic[ID]; // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	lapicw(EOI, 0);

	// Send an Init Level De-Assert to synchronise arbitration ID's.
	lapicw(ICRHI, 0);
	lapicw(ICRLO, BCAST | INIT | LEVEL);
	while (lapic[ICRLO] & DELIVS)
80102700:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102706:	80 e6 10             	and    $0x10,%dh
80102709:	75 f5                	jne    80102700 <lapicinit+0xc0>
	lapic[index] = value;
8010270b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102712:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102715:	8b 40 20             	mov    0x20(%eax),%eax
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
}
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	lapic[index] = value;
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
	lapic[ID]; // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
8010272d:	e9 77 ff ff ff       	jmp    801026a9 <lapicinit+0x69>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:

int
lapicid(void)
{
	if (!lapic) return 0;
80102740:	8b 15 3c 2b 11 80    	mov    0x80112b3c,%edx
{
80102746:	55                   	push   %ebp
80102747:	31 c0                	xor    %eax,%eax
80102749:	89 e5                	mov    %esp,%ebp
	if (!lapic) return 0;
8010274b:	85 d2                	test   %edx,%edx
8010274d:	74 06                	je     80102755 <lapicid+0x15>
	return lapic[ID] >> 24;
8010274f:	8b 42 20             	mov    0x20(%edx),%eax
80102752:	c1 e8 18             	shr    $0x18,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
	if (lapic) lapicw(EOI, 0);
80102760:	a1 3c 2b 11 80       	mov    0x80112b3c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
	if (lapic) lapicw(EOI, 0);
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
	lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
	lapic[ID]; // wait for write to finish, by reading
80102776:	8b 40 20             	mov    0x20(%eax),%eax
}
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102790:	55                   	push   %ebp
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102791:	b8 0f 00 00 00       	mov    $0xf,%eax
80102796:	ba 70 00 00 00       	mov    $0x70,%edx
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027aa:	ba 71 00 00 00       	mov    $0x71,%edx
801027af:	ee                   	out    %al,(%dx)
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(CMOS_PORT, 0xF); // offset 0xF is shutdown code
	outb(CMOS_PORT + 1, 0x0A);
	wrv    = (ushort *)P2V((0x40 << 4 | 0x67)); // Warm reset vector
	wrv[0] = 0;
801027b0:	31 c0                	xor    %eax,%eax
	wrv[1] = addr >> 4;

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
801027b2:	c1 e3 18             	shl    $0x18,%ebx
	wrv[0] = 0;
801027b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
	wrv[1] = addr >> 4;
801027bb:	89 c8                	mov    %ecx,%eax
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
801027bd:	c1 e9 0c             	shr    $0xc,%ecx
	wrv[1] = addr >> 4;
801027c0:	c1 e8 04             	shr    $0x4,%eax
	lapicw(ICRHI, apicid << 24);
801027c3:	89 da                	mov    %ebx,%edx
		lapicw(ICRLO, STARTUP | (addr >> 12));
801027c5:	80 cd 06             	or     $0x6,%ch
	wrv[1] = addr >> 4;
801027c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
	lapic[index] = value;
801027ce:	a1 3c 2b 11 80       	mov    0x80112b3c,%eax
801027d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
	lapic[ID]; // wait for write to finish, by reading
801027d9:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
801027dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e3:	c5 00 00 
	lapic[ID]; // wait for write to finish, by reading
801027e6:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
801027e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f0:	85 00 00 
	lapic[ID]; // wait for write to finish, by reading
801027f3:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
801027f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
	lapic[ID]; // wait for write to finish, by reading
801027fc:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
801027ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
	lapic[ID]; // wait for write to finish, by reading
80102805:	8b 58 20             	mov    0x20(%eax),%ebx
	lapic[index] = value;
80102808:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
	lapic[ID]; // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
	lapic[index] = value;
80102811:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
	lapic[ID]; // wait for write to finish, by reading
80102817:	8b 40 20             	mov    0x20(%eax),%eax
		microdelay(200);
	}
}
8010281a:	5b                   	pop    %ebx
8010281b:	5d                   	pop    %ebp
8010281c:	c3                   	ret    
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102820:	55                   	push   %ebp
80102821:	b8 0b 00 00 00       	mov    $0xb,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102834:	ba 71 00 00 00       	mov    $0x71,%edx
80102839:	ec                   	in     (%dx),%al
8010283a:	83 e0 04             	and    $0x4,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
8010283d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102842:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102845:	8d 76 00             	lea    0x0(%esi),%esi
80102848:	31 c0                	xor    %eax,%eax
8010284a:	89 da                	mov    %ebx,%edx
8010284c:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010284d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102852:	89 ca                	mov    %ecx,%edx
80102854:	ec                   	in     (%dx),%al
80102855:	88 45 b7             	mov    %al,-0x49(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	b8 02 00 00 00       	mov    $0x2,%eax
8010285f:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
80102863:	88 45 b6             	mov    %al,-0x4a(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102866:	89 da                	mov    %ebx,%edx
80102868:	b8 04 00 00 00       	mov    $0x4,%eax
8010286d:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010286e:	89 ca                	mov    %ecx,%edx
80102870:	ec                   	in     (%dx),%al
80102871:	88 45 b5             	mov    %al,-0x4b(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102874:	89 da                	mov    %ebx,%edx
80102876:	b8 07 00 00 00       	mov    $0x7,%eax
8010287b:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
8010287f:	88 45 b4             	mov    %al,-0x4c(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102882:	89 da                	mov    %ebx,%edx
80102884:	b8 08 00 00 00       	mov    $0x8,%eax
80102889:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	89 c7                	mov    %eax,%edi
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
8010288f:	89 da                	mov    %ebx,%edx
80102891:	b8 09 00 00 00       	mov    $0x9,%eax
80102896:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102897:	89 ca                	mov    %ecx,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	89 c6                	mov    %eax,%esi
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
8010289c:	89 da                	mov    %ebx,%edx
8010289e:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a3:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028a4:	89 ca                	mov    %ecx,%edx
801028a6:	ec                   	in     (%dx),%al
	bcd = (sb & (1 << 2)) == 0;

	// make sure CMOS doesn't modify time while we read it
	for (;;) {
		fill_rtcdate(&t1);
		if (cmos_read(CMOS_STATA) & CMOS_UIP) continue;
801028a7:	84 c0                	test   %al,%al
801028a9:	78 9d                	js     80102848 <cmostime+0x28>
	return inb(CMOS_RETURN);
801028ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028af:	89 fa                	mov    %edi,%edx
801028b1:	0f b6 fa             	movzbl %dl,%edi
801028b4:	89 f2                	mov    %esi,%edx
801028b6:	0f b6 f2             	movzbl %dl,%esi
801028b9:	89 7d c8             	mov    %edi,-0x38(%ebp)
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028c4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028cb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d9:	31 c0                	xor    %eax,%eax
801028db:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
801028f0:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
801028f3:	89 da                	mov    %ebx,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
80102912:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102915:	89 da                	mov    %ebx,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
80102923:	0f b6 c0             	movzbl %al,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80102926:	89 da                	mov    %ebx,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
80102934:	0f b6 c0             	movzbl %al,%eax
		fill_rtcdate(&t2);
		if (memcmp(&t1, &t2, sizeof(t1)) == 0) break;
80102937:	83 ec 04             	sub    $0x4,%esp
	return inb(CMOS_RETURN);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (memcmp(&t1, &t2, sizeof(t1)) == 0) break;
8010293d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	50                   	push   %eax
80102943:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102946:	50                   	push   %eax
80102947:	e8 c4 1b 00 00       	call   80104510 <memcmp>
8010294c:	83 c4 10             	add    $0x10,%esp
8010294f:	85 c0                	test   %eax,%eax
80102951:	0f 85 f1 fe ff ff    	jne    80102848 <cmostime+0x28>
	}

	// convert
	if (bcd) {
80102957:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010295b:	75 78                	jne    801029d5 <cmostime+0x1b5>
#define CONV(x) (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
		CONV(second);
8010295d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102960:	89 c2                	mov    %eax,%edx
80102962:	83 e0 0f             	and    $0xf,%eax
80102965:	c1 ea 04             	shr    $0x4,%edx
80102968:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296e:	89 45 b8             	mov    %eax,-0x48(%ebp)
		CONV(minute);
80102971:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102974:	89 c2                	mov    %eax,%edx
80102976:	83 e0 0f             	and    $0xf,%eax
80102979:	c1 ea 04             	shr    $0x4,%edx
8010297c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102982:	89 45 bc             	mov    %eax,-0x44(%ebp)
		CONV(hour);
80102985:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102988:	89 c2                	mov    %eax,%edx
8010298a:	83 e0 0f             	and    $0xf,%eax
8010298d:	c1 ea 04             	shr    $0x4,%edx
80102990:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102993:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102996:	89 45 c0             	mov    %eax,-0x40(%ebp)
		CONV(day);
80102999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299c:	89 c2                	mov    %eax,%edx
8010299e:	83 e0 0f             	and    $0xf,%eax
801029a1:	c1 ea 04             	shr    $0x4,%edx
801029a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		CONV(month);
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 c2                	mov    %eax,%edx
801029b2:	83 e0 0f             	and    $0xf,%eax
801029b5:	c1 ea 04             	shr    $0x4,%edx
801029b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029be:	89 45 c8             	mov    %eax,-0x38(%ebp)
		CONV(year);
801029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c4:	89 c2                	mov    %eax,%edx
801029c6:	83 e0 0f             	and    $0xf,%eax
801029c9:	c1 ea 04             	shr    $0x4,%edx
801029cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef CONV
	}

	*r = t1;
801029d5:	8b 75 08             	mov    0x8(%ebp),%esi
801029d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029db:	89 06                	mov    %eax,(%esi)
801029dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e0:	89 46 04             	mov    %eax,0x4(%esi)
801029e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e6:	89 46 08             	mov    %eax,0x8(%esi)
801029e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ec:	89 46 0c             	mov    %eax,0xc(%esi)
801029ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029f2:	89 46 10             	mov    %eax,0x10(%esi)
801029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f8:	89 46 14             	mov    %eax,0x14(%esi)
	r->year += 2000;
801029fb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a05:	5b                   	pop    %ebx
80102a06:	5e                   	pop    %esi
80102a07:	5f                   	pop    %edi
80102a08:	5d                   	pop    %ebp
80102a09:	c3                   	ret    
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <install_trans>:
static void
install_trans(void)
{
	int tail;

	for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d 88 2b 11 80    	mov    0x80112b88,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 8a 00 00 00    	jle    80102aa8 <install_trans+0x98>
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
	for (tail = 0; tail < log.lh.n; tail++) {
80102a24:	31 db                	xor    %ebx,%ebx
{
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
80102a30:	a1 74 2b 11 80       	mov    0x80112b74,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 84 2b 11 80    	pushl  0x80112b84
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
		struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d 8c 2b 11 80 	pushl  -0x7feed474(,%ebx,4)
80102a54:	ff 35 84 2b 11 80    	pushl  0x80112b84
	for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
		struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
		memmove(dbuf->data, lbuf->data, BSIZE);                  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 f7 1a 00 00       	call   80104570 <memmove>
		bwrite(dbuf);                                            // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
		brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
		brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
	for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d 88 2b 11 80    	cmp    %ebx,0x80112b88
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
	}
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa8:	f3 c3                	repz ret 
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
	struct buf *      buf = bread(log.dev, log.start);
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	ff 35 74 2b 11 80    	pushl  0x80112b74
80102abe:	ff 35 84 2b 11 80    	pushl  0x80112b84
80102ac4:	e8 07 d6 ff ff       	call   801000d0 <bread>
	struct logheader *hb  = (struct logheader *)(buf->data);
	int               i;
	hb->n = log.lh.n;
80102ac9:	8b 1d 88 2b 11 80    	mov    0x80112b88,%ebx
	for (i = 0; i < log.lh.n; i++) {
80102acf:	83 c4 10             	add    $0x10,%esp
	struct buf *      buf = bread(log.dev, log.start);
80102ad2:	89 c6                	mov    %eax,%esi
	for (i = 0; i < log.lh.n; i++) {
80102ad4:	85 db                	test   %ebx,%ebx
	hb->n = log.lh.n;
80102ad6:	89 58 5c             	mov    %ebx,0x5c(%eax)
	for (i = 0; i < log.lh.n; i++) {
80102ad9:	7e 16                	jle    80102af1 <write_head+0x41>
80102adb:	c1 e3 02             	shl    $0x2,%ebx
80102ade:	31 d2                	xor    %edx,%edx
		hb->block[i] = log.lh.block[i];
80102ae0:	8b 8a 8c 2b 11 80    	mov    -0x7feed474(%edx),%ecx
80102ae6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102aea:	83 c2 04             	add    $0x4,%edx
	for (i = 0; i < log.lh.n; i++) {
80102aed:	39 da                	cmp    %ebx,%edx
80102aef:	75 ef                	jne    80102ae0 <write_head+0x30>
	}
	bwrite(buf);
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	56                   	push   %esi
80102af5:	e8 a6 d6 ff ff       	call   801001a0 <bwrite>
	brelse(buf);
80102afa:	89 34 24             	mov    %esi,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>
}
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b08:	5b                   	pop    %ebx
80102b09:	5e                   	pop    %esi
80102b0a:	5d                   	pop    %ebp
80102b0b:	c3                   	ret    
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <initlog>:
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&log.lock, "log");
80102b1a:	68 40 74 10 80       	push   $0x80107440
80102b1f:	68 40 2b 11 80       	push   $0x80112b40
80102b24:	e8 27 17 00 00       	call   80104250 <initlock>
	readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 9b e8 ff ff       	call   801013d0 <readsb>
	log.size  = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
	log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
	struct buf *      buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
	log.dev   = dev;
80102b3c:	89 1d 84 2b 11 80    	mov    %ebx,0x80112b84
	log.size  = sb.nlog;
80102b42:	89 15 78 2b 11 80    	mov    %edx,0x80112b78
	log.start = sb.logstart;
80102b48:	a3 74 2b 11 80       	mov    %eax,0x80112b74
	struct buf *      buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
	log.lh.n = lh->n;
80102b55:	8b 58 5c             	mov    0x5c(%eax),%ebx
	for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 db                	test   %ebx,%ebx
	log.lh.n = lh->n;
80102b5d:	89 1d 88 2b 11 80    	mov    %ebx,0x80112b88
	for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	c1 e3 02             	shl    $0x2,%ebx
80102b68:	31 d2                	xor    %edx,%edx
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a 88 2b 11 80    	mov    %ecx,-0x7feed478(%edx)
	for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 d3                	cmp    %edx,%ebx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
	brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
	read_head();
	install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
	log.lh.n = 0;
80102b8f:	c7 05 88 2b 11 80 00 	movl   $0x0,0x80112b88
80102b96:	00 00 00 
	write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
}
80102b9e:	83 c4 10             	add    $0x10,%esp
80102ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
	acquire(&log.lock);
80102bb6:	68 40 2b 11 80       	push   $0x80112b40
80102bbb:	e8 80 17 00 00       	call   80104340 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
	while (1) {
		if (log.committing) {
			sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 40 2b 11 80       	push   $0x80112b40
80102bd0:	68 40 2b 11 80       	push   $0x80112b40
80102bd5:	e8 f6 11 00 00       	call   80103dd0 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
		if (log.committing) {
80102bdd:	a1 80 2b 11 80       	mov    0x80112b80,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
		} else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
80102be6:	a1 7c 2b 11 80       	mov    0x80112b7c,%eax
80102beb:	8b 15 88 2b 11 80    	mov    0x80112b88,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
			// this op might exhaust log space; wait for commit.
			sleep(&log, &log.lock);
		} else {
			log.outstanding += 1;
			release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
			log.outstanding += 1;
80102c02:	a3 7c 2b 11 80       	mov    %eax,0x80112b7c
			release(&log.lock);
80102c07:	68 40 2b 11 80       	push   $0x80112b40
80102c0c:	e8 4f 18 00 00       	call   80104460 <release>
			break;
		}
	}
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
	int do_commit = 0;

	acquire(&log.lock);
80102c29:	68 40 2b 11 80       	push   $0x80112b40
80102c2e:	e8 0d 17 00 00       	call   80104340 <acquire>
	log.outstanding -= 1;
80102c33:	a1 7c 2b 11 80       	mov    0x80112b7c,%eax
	if (log.committing) panic("log.committing");
80102c38:	8b 35 80 2b 11 80    	mov    0x80112b80,%esi
80102c3e:	83 c4 10             	add    $0x10,%esp
	log.outstanding -= 1;
80102c41:	8d 58 ff             	lea    -0x1(%eax),%ebx
	if (log.committing) panic("log.committing");
80102c44:	85 f6                	test   %esi,%esi
	log.outstanding -= 1;
80102c46:	89 1d 7c 2b 11 80    	mov    %ebx,0x80112b7c
	if (log.committing) panic("log.committing");
80102c4c:	0f 85 1a 01 00 00    	jne    80102d6c <end_op+0x14c>
	if (log.outstanding == 0) {
80102c52:	85 db                	test   %ebx,%ebx
80102c54:	0f 85 ee 00 00 00    	jne    80102d48 <end_op+0x128>
		// begin_op() may be waiting for log space,
		// and decrementing log.outstanding has decreased
		// the amount of reserved space.
		wakeup(&log);
	}
	release(&log.lock);
80102c5a:	83 ec 0c             	sub    $0xc,%esp
		log.committing = 1;
80102c5d:	c7 05 80 2b 11 80 01 	movl   $0x1,0x80112b80
80102c64:	00 00 00 
	release(&log.lock);
80102c67:	68 40 2b 11 80       	push   $0x80112b40
80102c6c:	e8 ef 17 00 00       	call   80104460 <release>
}

static void
commit()
{
	if (log.lh.n > 0) {
80102c71:	8b 0d 88 2b 11 80    	mov    0x80112b88,%ecx
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	85 c9                	test   %ecx,%ecx
80102c7c:	0f 8e 85 00 00 00    	jle    80102d07 <end_op+0xe7>
		struct buf *to   = bread(log.dev, log.start + tail + 1); // log block
80102c82:	a1 74 2b 11 80       	mov    0x80112b74,%eax
80102c87:	83 ec 08             	sub    $0x8,%esp
80102c8a:	01 d8                	add    %ebx,%eax
80102c8c:	83 c0 01             	add    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	ff 35 84 2b 11 80    	pushl  0x80112b84
80102c96:	e8 35 d4 ff ff       	call   801000d0 <bread>
80102c9b:	89 c6                	mov    %eax,%esi
		struct buf *from = bread(log.dev, log.lh.block[tail]);   // cache block
80102c9d:	58                   	pop    %eax
80102c9e:	5a                   	pop    %edx
80102c9f:	ff 34 9d 8c 2b 11 80 	pushl  -0x7feed474(,%ebx,4)
80102ca6:	ff 35 84 2b 11 80    	pushl  0x80112b84
	for (tail = 0; tail < log.lh.n; tail++) {
80102cac:	83 c3 01             	add    $0x1,%ebx
		struct buf *from = bread(log.dev, log.lh.block[tail]);   // cache block
80102caf:	e8 1c d4 ff ff       	call   801000d0 <bread>
80102cb4:	89 c7                	mov    %eax,%edi
		memmove(to->data, from->data, BSIZE);
80102cb6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cb9:	83 c4 0c             	add    $0xc,%esp
80102cbc:	68 00 02 00 00       	push   $0x200
80102cc1:	50                   	push   %eax
80102cc2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cc5:	50                   	push   %eax
80102cc6:	e8 a5 18 00 00       	call   80104570 <memmove>
		bwrite(to); // write the log
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 cd d4 ff ff       	call   801001a0 <bwrite>
		brelse(from);
80102cd3:	89 3c 24             	mov    %edi,(%esp)
80102cd6:	e8 05 d5 ff ff       	call   801001e0 <brelse>
		brelse(to);
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 fd d4 ff ff       	call   801001e0 <brelse>
	for (tail = 0; tail < log.lh.n; tail++) {
80102ce3:	83 c4 10             	add    $0x10,%esp
80102ce6:	3b 1d 88 2b 11 80    	cmp    0x80112b88,%ebx
80102cec:	7c 94                	jl     80102c82 <end_op+0x62>
		write_log();     // Write modified blocks from cache to log
		write_head();    // Write header to disk -- the real commit
80102cee:	e8 bd fd ff ff       	call   80102ab0 <write_head>
		install_trans(); // Now install writes to home locations
80102cf3:	e8 18 fd ff ff       	call   80102a10 <install_trans>
		log.lh.n = 0;
80102cf8:	c7 05 88 2b 11 80 00 	movl   $0x0,0x80112b88
80102cff:	00 00 00 
		write_head(); // Erase the transaction from the log
80102d02:	e8 a9 fd ff ff       	call   80102ab0 <write_head>
		acquire(&log.lock);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 40 2b 11 80       	push   $0x80112b40
80102d0f:	e8 2c 16 00 00       	call   80104340 <acquire>
		wakeup(&log);
80102d14:	c7 04 24 40 2b 11 80 	movl   $0x80112b40,(%esp)
		log.committing = 0;
80102d1b:	c7 05 80 2b 11 80 00 	movl   $0x0,0x80112b80
80102d22:	00 00 00 
		wakeup(&log);
80102d25:	e8 66 12 00 00       	call   80103f90 <wakeup>
		release(&log.lock);
80102d2a:	c7 04 24 40 2b 11 80 	movl   $0x80112b40,(%esp)
80102d31:	e8 2a 17 00 00       	call   80104460 <release>
80102d36:	83 c4 10             	add    $0x10,%esp
}
80102d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3c:	5b                   	pop    %ebx
80102d3d:	5e                   	pop    %esi
80102d3e:	5f                   	pop    %edi
80102d3f:	5d                   	pop    %ebp
80102d40:	c3                   	ret    
80102d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		wakeup(&log);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 40 2b 11 80       	push   $0x80112b40
80102d50:	e8 3b 12 00 00       	call   80103f90 <wakeup>
	release(&log.lock);
80102d55:	c7 04 24 40 2b 11 80 	movl   $0x80112b40,(%esp)
80102d5c:	e8 ff 16 00 00       	call   80104460 <release>
80102d61:	83 c4 10             	add    $0x10,%esp
}
80102d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d67:	5b                   	pop    %ebx
80102d68:	5e                   	pop    %esi
80102d69:	5f                   	pop    %edi
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    
	if (log.committing) panic("log.committing");
80102d6c:	83 ec 0c             	sub    $0xc,%esp
80102d6f:	68 44 74 10 80       	push   $0x80107444
80102d74:	e8 17 d6 ff ff       	call   80100390 <panic>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 04             	sub    $0x4,%esp
	int i;

	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102d87:	8b 15 88 2b 11 80    	mov    0x80112b88,%edx
{
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 9d 00 00 00    	jg     80102e36 <log_write+0xb6>
80102d99:	a1 78 2b 11 80       	mov    0x80112b78,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 8d 00 00 00    	jge    80102e36 <log_write+0xb6>
	if (log.outstanding < 1) panic("log_write outside of trans");
80102da9:	a1 7c 2b 11 80       	mov    0x80112b7c,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 8d 00 00 00    	jle    80102e43 <log_write+0xc3>

	acquire(&log.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 40 2b 11 80       	push   $0x80112b40
80102dbe:	e8 7d 15 00 00       	call   80104340 <acquire>
	for (i = 0; i < log.lh.n; i++) {
80102dc3:	8b 0d 88 2b 11 80    	mov    0x80112b88,%ecx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 f9 00             	cmp    $0x0,%ecx
80102dcf:	7e 57                	jle    80102e28 <log_write+0xa8>
		if (log.lh.block[i] == b->blockno) // log absorbtion
80102dd1:	8b 53 08             	mov    0x8(%ebx),%edx
	for (i = 0; i < log.lh.n; i++) {
80102dd4:	31 c0                	xor    %eax,%eax
		if (log.lh.block[i] == b->blockno) // log absorbtion
80102dd6:	3b 15 8c 2b 11 80    	cmp    0x80112b8c,%edx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 14 85 8c 2b 11 80 	cmp    %edx,-0x7feed474(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
	for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 c1                	cmp    %eax,%ecx
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
			break;
	}
	log.lh.block[i] = b->blockno;
80102df0:	89 14 85 8c 2b 11 80 	mov    %edx,-0x7feed474(,%eax,4)
	if (i == log.lh.n) log.lh.n++;
80102df7:	83 c0 01             	add    $0x1,%eax
80102dfa:	a3 88 2b 11 80       	mov    %eax,0x80112b88
	b->flags |= B_DIRTY; // prevent eviction
80102dff:	83 0b 04             	orl    $0x4,(%ebx)
	release(&log.lock);
80102e02:	c7 45 08 40 2b 11 80 	movl   $0x80112b40,0x8(%ebp)
}
80102e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0c:	c9                   	leave  
	release(&log.lock);
80102e0d:	e9 4e 16 00 00       	jmp    80104460 <release>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	log.lh.block[i] = b->blockno;
80102e18:	89 14 85 8c 2b 11 80 	mov    %edx,-0x7feed474(,%eax,4)
80102e1f:	eb de                	jmp    80102dff <log_write+0x7f>
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 43 08             	mov    0x8(%ebx),%eax
80102e2b:	a3 8c 2b 11 80       	mov    %eax,0x80112b8c
	if (i == log.lh.n) log.lh.n++;
80102e30:	75 cd                	jne    80102dff <log_write+0x7f>
80102e32:	31 c0                	xor    %eax,%eax
80102e34:	eb c1                	jmp    80102df7 <log_write+0x77>
	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 53 74 10 80       	push   $0x80107453
80102e3e:	e8 4d d5 ff ff       	call   80100390 <panic>
	if (log.outstanding < 1) panic("log_write outside of trans");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 69 74 10 80       	push   $0x80107469
80102e4b:	e8 40 d5 ff ff       	call   80100390 <panic>

80102e50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
	cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e57:	e8 94 09 00 00       	call   801037f0 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 8d 09 00 00       	call   801037f0 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 84 74 10 80       	push   $0x80107484
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
	idtinit();                    // load idt register
80102e72:	e8 59 29 00 00       	call   801057d0 <idtinit>
	xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e77:	e8 f4 08 00 00       	call   80103770 <mycpu>
80102e7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
	uint result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" : "+m"(*addr), "=a"(result) : "1"(newval) : "cc");
80102e7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
	scheduler();                  // start running processes
80102e8a:	e8 61 0c 00 00       	call   80103af0 <scheduler>
80102e8f:	90                   	nop

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
	switchkvm();
80102e96:	e8 25 3a 00 00       	call   801068c0 <switchkvm>
	seginit();
80102e9b:	e8 90 39 00 00       	call   80106830 <seginit>
	lapicinit();
80102ea0:	e8 9b f7 ff ff       	call   80102640 <lapicinit>
	mpmain();
80102ea5:	e8 a6 ff ff ff       	call   80102e50 <mpmain>
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <main>:
{
80102eb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102eb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102eb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eba:	55                   	push   %ebp
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	53                   	push   %ebx
80102ebe:	51                   	push   %ecx
	kinit1(end, P2V(4 * 1024 * 1024));          // phys page allocator
80102ebf:	83 ec 08             	sub    $0x8,%esp
80102ec2:	68 00 00 40 80       	push   $0x80400000
80102ec7:	68 68 6d 11 80       	push   $0x80116d68
80102ecc:	e8 2f f5 ff ff       	call   80102400 <kinit1>
	kvmalloc();                                 // kernel page table
80102ed1:	e8 ba 3e 00 00       	call   80106d90 <kvmalloc>
	mpinit();                                   // detect other processors
80102ed6:	e8 75 01 00 00       	call   80103050 <mpinit>
	lapicinit();                                // interrupt controller
80102edb:	e8 60 f7 ff ff       	call   80102640 <lapicinit>
	seginit();                                  // segment descriptors
80102ee0:	e8 4b 39 00 00       	call   80106830 <seginit>
	picinit();                                  // disable pic
80102ee5:	e8 46 03 00 00       	call   80103230 <picinit>
	ioapicinit();                               // another interrupt controller
80102eea:	e8 41 f3 ff ff       	call   80102230 <ioapicinit>
	consoleinit();                              // console hardware
80102eef:	e8 cc da ff ff       	call   801009c0 <consoleinit>
	uartinit();                                 // serial port
80102ef4:	e8 07 2c 00 00       	call   80105b00 <uartinit>
	pinit();                                    // process table
80102ef9:	e8 52 08 00 00       	call   80103750 <pinit>
	tvinit();                                   // trap vectors
80102efe:	e8 4d 28 00 00       	call   80105750 <tvinit>
	binit();                                    // buffer cache
80102f03:	e8 38 d1 ff ff       	call   80100040 <binit>
	fileinit();                                 // file table
80102f08:	e8 53 de ff ff       	call   80100d60 <fileinit>
	ideinit();                                  // disk
80102f0d:	e8 fe f0 ff ff       	call   80102010 <ideinit>

	// Write entry code to unused memory at 0x7000.
	// The linker has placed the image of entryother.S in
	// _binary_entryother_start.
	code = P2V(0x7000);
	memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f12:	83 c4 0c             	add    $0xc,%esp
80102f15:	68 8a 00 00 00       	push   $0x8a
80102f1a:	68 8c a4 10 80       	push   $0x8010a48c
80102f1f:	68 00 70 00 80       	push   $0x80007000
80102f24:	e8 47 16 00 00       	call   80104570 <memmove>

	for (c = cpus; c < cpus + ncpu; c++) {
80102f29:	69 05 c0 31 11 80 b0 	imul   $0xb0,0x801131c0,%eax
80102f30:	00 00 00 
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	05 40 2c 11 80       	add    $0x80112c40,%eax
80102f3b:	3d 40 2c 11 80       	cmp    $0x80112c40,%eax
80102f40:	76 71                	jbe    80102fb3 <main+0x103>
80102f42:	bb 40 2c 11 80       	mov    $0x80112c40,%ebx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if (c == mycpu()) // We've started already.
80102f50:	e8 1b 08 00 00       	call   80103770 <mycpu>
80102f55:	39 d8                	cmp    %ebx,%eax
80102f57:	74 41                	je     80102f9a <main+0xea>
			continue;

		// Tell entryother.S what stack to use, where to enter, and what
		// pgdir to use. We cannot use kpgdir yet, because the AP processor
		// is running in low  memory, so we use entrypgdir for the APs too.
		stack                = kalloc();
80102f59:	e8 72 f5 ff ff       	call   801024d0 <kalloc>
		*(void **)(code - 4) = stack + KSTACKSIZE;
80102f5e:	05 00 10 00 00       	add    $0x1000,%eax
		*(void **)(code - 8) = mpenter;
80102f63:	c7 05 f8 6f 00 80 90 	movl   $0x80102e90,0x80006ff8
80102f6a:	2e 10 80 
		*(int **)(code - 12) = (void *)V2P(entrypgdir);
80102f6d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f74:	90 10 00 
		*(void **)(code - 4) = stack + KSTACKSIZE;
80102f77:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

		lapicstartap(c->apicid, V2P(code));
80102f7c:	0f b6 03             	movzbl (%ebx),%eax
80102f7f:	83 ec 08             	sub    $0x8,%esp
80102f82:	68 00 70 00 00       	push   $0x7000
80102f87:	50                   	push   %eax
80102f88:	e8 03 f8 ff ff       	call   80102790 <lapicstartap>
80102f8d:	83 c4 10             	add    $0x10,%esp

		// wait for cpu to finish mpmain()
		while (c->started == 0)
80102f90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	74 f6                	je     80102f90 <main+0xe0>
	for (c = cpus; c < cpus + ncpu; c++) {
80102f9a:	69 05 c0 31 11 80 b0 	imul   $0xb0,0x801131c0,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102faa:	05 40 2c 11 80       	add    $0x80112c40,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
	kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	83 ec 08             	sub    $0x8,%esp
80102fb6:	68 00 00 00 8e       	push   $0x8e000000
80102fbb:	68 00 00 40 80       	push   $0x80400000
80102fc0:	e8 ab f4 ff ff       	call   80102470 <kinit2>
	userinit();                                 // first user process
80102fc5:	e8 76 08 00 00       	call   80103840 <userinit>
	mpmain();                                   // finish this processor's setup
80102fca:	e8 81 fe ff ff       	call   80102e50 <mpmain>
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp *
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
	uchar *e, *p, *addr;

	addr = P2V(a);
80102fd5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fdb:	53                   	push   %ebx
	e    = addr + len;
80102fdc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fdf:	83 ec 0c             	sub    $0xc,%esp
	for (p = addr; p < e; p += sizeof(struct mp))
80102fe2:	39 de                	cmp    %ebx,%esi
80102fe4:	72 10                	jb     80102ff6 <mpsearch1+0x26>
80102fe6:	eb 50                	jmp    80103038 <mpsearch1+0x68>
80102fe8:	90                   	nop
80102fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	76 42                	jbe    80103038 <mpsearch1+0x68>
		if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) return (struct mp *)p;
80102ff6:	83 ec 04             	sub    $0x4,%esp
80102ff9:	8d 7e 10             	lea    0x10(%esi),%edi
80102ffc:	6a 04                	push   $0x4
80102ffe:	68 98 74 10 80       	push   $0x80107498
80103003:	56                   	push   %esi
80103004:	e8 07 15 00 00       	call   80104510 <memcmp>
80103009:	83 c4 10             	add    $0x10,%esp
8010300c:	85 c0                	test   %eax,%eax
8010300e:	75 e0                	jne    80102ff0 <mpsearch1+0x20>
80103010:	89 f1                	mov    %esi,%ecx
80103012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (i = 0; i < len; i++) sum += addr[i];
80103018:	0f b6 11             	movzbl (%ecx),%edx
8010301b:	83 c1 01             	add    $0x1,%ecx
8010301e:	01 d0                	add    %edx,%eax
80103020:	39 f9                	cmp    %edi,%ecx
80103022:	75 f4                	jne    80103018 <mpsearch1+0x48>
		if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) return (struct mp *)p;
80103024:	84 c0                	test   %al,%al
80103026:	75 c8                	jne    80102ff0 <mpsearch1+0x20>
	return 0;
}
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	89 f0                	mov    %esi,%eax
8010302d:	5b                   	pop    %ebx
8010302e:	5e                   	pop    %esi
8010302f:	5f                   	pop    %edi
80103030:	5d                   	pop    %ebp
80103031:	c3                   	ret    
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
8010303b:	31 f6                	xor    %esi,%esi
}
8010303d:	89 f0                	mov    %esi,%eax
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5f                   	pop    %edi
80103042:	5d                   	pop    %ebp
80103043:	c3                   	ret    
80103044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010304a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103050 <mpinit>:
	return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
	if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
		p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024))) return mp;
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
		if ((mp = mpsearch1(p, 1024))) return mp;
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 38 ff ff ff       	call   80102fd0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010309d:	0f 84 3d 01 00 00    	je     801031e0 <mpinit+0x190>
	if ((mp = mpsearch()) == 0 || mp->physaddr == 0) return 0;
801030a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a6:	8b 58 04             	mov    0x4(%eax),%ebx
801030a9:	85 db                	test   %ebx,%ebx
801030ab:	0f 84 4f 01 00 00    	je     80103200 <mpinit+0x1b0>
	conf = (struct mpconf *)P2V((uint)mp->physaddr);
801030b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
	if (memcmp(conf, "PCMP", 4) != 0) return 0;
801030b7:	83 ec 04             	sub    $0x4,%esp
801030ba:	6a 04                	push   $0x4
801030bc:	68 b5 74 10 80       	push   $0x801074b5
801030c1:	56                   	push   %esi
801030c2:	e8 49 14 00 00       	call   80104510 <memcmp>
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c0                	test   %eax,%eax
801030cc:	0f 85 2e 01 00 00    	jne    80103200 <mpinit+0x1b0>
	if (conf->version != 1 && conf->version != 4) return 0;
801030d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030d9:	3c 01                	cmp    $0x1,%al
801030db:	0f 95 c2             	setne  %dl
801030de:	3c 04                	cmp    $0x4,%al
801030e0:	0f 95 c0             	setne  %al
801030e3:	20 c2                	and    %al,%dl
801030e5:	0f 85 15 01 00 00    	jne    80103200 <mpinit+0x1b0>
	if (sum((uchar *)conf, conf->length) != 0) return 0;
801030eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
	for (i = 0; i < len; i++) sum += addr[i];
801030f2:	66 85 ff             	test   %di,%di
801030f5:	74 1a                	je     80103111 <mpinit+0xc1>
801030f7:	89 f0                	mov    %esi,%eax
801030f9:	01 f7                	add    %esi,%edi
	sum = 0;
801030fb:	31 d2                	xor    %edx,%edx
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
	for (i = 0; i < len; i++) sum += addr[i];
80103100:	0f b6 08             	movzbl (%eax),%ecx
80103103:	83 c0 01             	add    $0x1,%eax
80103106:	01 ca                	add    %ecx,%edx
80103108:	39 c7                	cmp    %eax,%edi
8010310a:	75 f4                	jne    80103100 <mpinit+0xb0>
8010310c:	84 d2                	test   %dl,%dl
8010310e:	0f 95 c2             	setne  %dl
	struct mp *      mp;
	struct mpconf *  conf;
	struct mpproc *  proc;
	struct mpioapic *ioapic;

	if ((conf = mpconfig(&mp)) == 0) panic("Expect to run on an SMP");
80103111:	85 f6                	test   %esi,%esi
80103113:	0f 84 e7 00 00 00    	je     80103200 <mpinit+0x1b0>
80103119:	84 d2                	test   %dl,%dl
8010311b:	0f 85 df 00 00 00    	jne    80103200 <mpinit+0x1b0>
	ismp  = 1;
	lapic = (uint *)conf->lapicaddr;
80103121:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103127:	a3 3c 2b 11 80       	mov    %eax,0x80112b3c
	for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
8010312c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103133:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
	ismp  = 1;
80103139:	bb 01 00 00 00       	mov    $0x1,%ebx
	for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
8010313e:	01 d6                	add    %edx,%esi
80103140:	39 c6                	cmp    %eax,%esi
80103142:	76 23                	jbe    80103167 <mpinit+0x117>
		switch (*p) {
80103144:	0f b6 10             	movzbl (%eax),%edx
80103147:	80 fa 04             	cmp    $0x4,%dl
8010314a:	0f 87 ca 00 00 00    	ja     8010321a <mpinit+0x1ca>
80103150:	ff 24 95 dc 74 10 80 	jmp    *-0x7fef8b24(,%edx,4)
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			p += sizeof(struct mpioapic);
			continue;
		case MPBUS:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
80103160:	83 c0 08             	add    $0x8,%eax
	for (p = (uchar *)(conf + 1), e = (uchar *)conf + conf->length; p < e;) {
80103163:	39 c6                	cmp    %eax,%esi
80103165:	77 dd                	ja     80103144 <mpinit+0xf4>
		default:
			ismp = 0;
			break;
		}
	}
	if (!ismp) panic("Didn't find a suitable machine");
80103167:	85 db                	test   %ebx,%ebx
80103169:	0f 84 9e 00 00 00    	je     8010320d <mpinit+0x1bd>

	if (mp->imcrp) {
8010316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103172:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103176:	74 15                	je     8010318d <mpinit+0x13d>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80103178:	b8 70 00 00 00       	mov    $0x70,%eax
8010317d:	ba 22 00 00 00       	mov    $0x22,%edx
80103182:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80103183:	ba 23 00 00 00       	mov    $0x23,%edx
80103188:	ec                   	in     (%dx),%al
		// Bochs doesn't support IMCR, so this doesn't run on Bochs.
		// But it would on real hardware.
		outb(0x22, 0x70);          // Select IMCR
		outb(0x23, inb(0x23) | 1); // Mask external interrupts.
80103189:	83 c8 01             	or     $0x1,%eax
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
8010318c:	ee                   	out    %al,(%dx)
	}
}
8010318d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103190:	5b                   	pop    %ebx
80103191:	5e                   	pop    %esi
80103192:	5f                   	pop    %edi
80103193:	5d                   	pop    %ebp
80103194:	c3                   	ret    
80103195:	8d 76 00             	lea    0x0(%esi),%esi
			if (ncpu < NCPU) {
80103198:	8b 0d c0 31 11 80    	mov    0x801131c0,%ecx
8010319e:	83 f9 07             	cmp    $0x7,%ecx
801031a1:	7f 19                	jg     801031bc <mpinit+0x16c>
				cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
801031a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
				ncpu++;
801031ad:	83 c1 01             	add    $0x1,%ecx
801031b0:	89 0d c0 31 11 80    	mov    %ecx,0x801131c0
				cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
801031b6:	88 97 40 2c 11 80    	mov    %dl,-0x7feed3c0(%edi)
			p += sizeof(struct mpproc);
801031bc:	83 c0 14             	add    $0x14,%eax
			continue;
801031bf:	e9 7c ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			ioapicid = ioapic->apicno;
801031c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
			p += sizeof(struct mpioapic);
801031cc:	83 c0 08             	add    $0x8,%eax
			ioapicid = ioapic->apicno;
801031cf:	88 15 20 2c 11 80    	mov    %dl,0x80112c20
			continue;
801031d5:	e9 66 ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	return mpsearch1(0xF0000, 0x10000);
801031e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ea:	e8 e1 fd ff ff       	call   80102fd0 <mpsearch1>
	if ((mp = mpsearch()) == 0 || mp->physaddr == 0) return 0;
801031ef:	85 c0                	test   %eax,%eax
	return mpsearch1(0xF0000, 0x10000);
801031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if ((mp = mpsearch()) == 0 || mp->physaddr == 0) return 0;
801031f4:	0f 85 a9 fe ff ff    	jne    801030a3 <mpinit+0x53>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if ((conf = mpconfig(&mp)) == 0) panic("Expect to run on an SMP");
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 9d 74 10 80       	push   $0x8010749d
80103208:	e8 83 d1 ff ff       	call   80100390 <panic>
	if (!ismp) panic("Didn't find a suitable machine");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 bc 74 10 80       	push   $0x801074bc
80103215:	e8 76 d1 ff ff       	call   80100390 <panic>
			ismp = 0;
8010321a:	31 db                	xor    %ebx,%ebx
8010321c:	e9 26 ff ff ff       	jmp    80103147 <mpinit+0xf7>
80103221:	66 90                	xchg   %ax,%ax
80103223:	66 90                	xchg   %ax,%ax
80103225:	66 90                	xchg   %ax,%ax
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
#define IO_PIC2 0xA0 // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103230:	55                   	push   %ebp
80103231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103236:	ba 21 00 00 00       	mov    $0x21,%edx
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
	// mask all interrupts
	outb(IO_PIC1 + 1, 0xFF);
	outb(IO_PIC2 + 1, 0xFF);
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
	int             writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct pipe *p;

	p   = 0;
	*f0 = *f1 = 0;
8010325f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) goto bad;
8010326b:	e8 10 db ff ff       	call   80100d80 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 03                	mov    %eax,(%ebx)
80103274:	74 22                	je     80103298 <pipealloc+0x48>
80103276:	e8 05 db ff ff       	call   80100d80 <filealloc>
8010327b:	85 c0                	test   %eax,%eax
8010327d:	89 06                	mov    %eax,(%esi)
8010327f:	74 3f                	je     801032c0 <pipealloc+0x70>
	if ((p = (struct pipe *)kalloc()) == 0) goto bad;
80103281:	e8 4a f2 ff ff       	call   801024d0 <kalloc>
80103286:	85 c0                	test   %eax,%eax
80103288:	89 c7                	mov    %eax,%edi
8010328a:	75 54                	jne    801032e0 <pipealloc+0x90>
	return 0;

// PAGEBREAK: 20
bad:
	if (p) kfree((char *)p);
	if (*f0) fileclose(*f0);
8010328c:	8b 03                	mov    (%ebx),%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	75 34                	jne    801032c6 <pipealloc+0x76>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (*f1) fileclose(*f1);
80103298:	8b 06                	mov    (%esi),%eax
8010329a:	85 c0                	test   %eax,%eax
8010329c:	74 0c                	je     801032aa <pipealloc+0x5a>
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	50                   	push   %eax
801032a2:	e8 99 db ff ff       	call   80100e40 <fileclose>
801032a7:	83 c4 10             	add    $0x10,%esp
	return -1;
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
801032ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032b2:	5b                   	pop    %ebx
801032b3:	5e                   	pop    %esi
801032b4:	5f                   	pop    %edi
801032b5:	5d                   	pop    %ebp
801032b6:	c3                   	ret    
801032b7:	89 f6                	mov    %esi,%esi
801032b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (*f0) fileclose(*f0);
801032c0:	8b 03                	mov    (%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 e4                	je     801032aa <pipealloc+0x5a>
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 71 db ff ff       	call   80100e40 <fileclose>
	if (*f1) fileclose(*f1);
801032cf:	8b 06                	mov    (%esi),%eax
	if (*f0) fileclose(*f0);
801032d1:	83 c4 10             	add    $0x10,%esp
	if (*f1) fileclose(*f1);
801032d4:	85 c0                	test   %eax,%eax
801032d6:	75 c6                	jne    8010329e <pipealloc+0x4e>
801032d8:	eb d0                	jmp    801032aa <pipealloc+0x5a>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	initlock(&p->lock, "pipe");
801032e0:	83 ec 08             	sub    $0x8,%esp
	p->readopen  = 1;
801032e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032ea:	00 00 00 
	p->writeopen = 1;
801032ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032f4:	00 00 00 
	p->nwrite    = 0;
801032f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032fe:	00 00 00 
	p->nread     = 0;
80103301:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103308:	00 00 00 
	initlock(&p->lock, "pipe");
8010330b:	68 f0 74 10 80       	push   $0x801074f0
80103310:	50                   	push   %eax
80103311:	e8 3a 0f 00 00       	call   80104250 <initlock>
	(*f0)->type     = FD_PIPE;
80103316:	8b 03                	mov    (%ebx),%eax
	return 0;
80103318:	83 c4 10             	add    $0x10,%esp
	(*f0)->type     = FD_PIPE;
8010331b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	(*f0)->readable = 1;
80103321:	8b 03                	mov    (%ebx),%eax
80103323:	c6 40 08 01          	movb   $0x1,0x8(%eax)
	(*f0)->writable = 0;
80103327:	8b 03                	mov    (%ebx),%eax
80103329:	c6 40 09 00          	movb   $0x0,0x9(%eax)
	(*f0)->pipe     = p;
8010332d:	8b 03                	mov    (%ebx),%eax
8010332f:	89 78 0c             	mov    %edi,0xc(%eax)
	(*f1)->type     = FD_PIPE;
80103332:	8b 06                	mov    (%esi),%eax
80103334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	(*f1)->readable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
	(*f1)->writable = 1;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	c6 40 09 01          	movb   $0x1,0x9(%eax)
	(*f1)->pipe     = p;
80103346:	8b 06                	mov    (%esi),%eax
80103348:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010334b:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
8010334e:	31 c0                	xor    %eax,%eax
}
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103368:	8b 75 0c             	mov    0xc(%ebp),%esi
	acquire(&p->lock);
8010336b:	83 ec 0c             	sub    $0xc,%esp
8010336e:	53                   	push   %ebx
8010336f:	e8 cc 0f 00 00       	call   80104340 <acquire>
	if (writable) {
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 f6                	test   %esi,%esi
80103379:	74 45                	je     801033c0 <pipeclose+0x60>
		p->writeopen = 0;
		wakeup(&p->nread);
8010337b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103381:	83 ec 0c             	sub    $0xc,%esp
		p->writeopen = 0;
80103384:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010338b:	00 00 00 
		wakeup(&p->nread);
8010338e:	50                   	push   %eax
8010338f:	e8 fc 0b 00 00       	call   80103f90 <wakeup>
80103394:	83 c4 10             	add    $0x10,%esp
	} else {
		p->readopen = 0;
		wakeup(&p->nwrite);
	}
	if (p->readopen == 0 && p->writeopen == 0) {
80103397:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339d:	85 d2                	test   %edx,%edx
8010339f:	75 0a                	jne    801033ab <pipeclose+0x4b>
801033a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 35                	je     801033e0 <pipeclose+0x80>
		release(&p->lock);
		kfree((char *)p);
	} else
		release(&p->lock);
801033ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b1:	5b                   	pop    %ebx
801033b2:	5e                   	pop    %esi
801033b3:	5d                   	pop    %ebp
		release(&p->lock);
801033b4:	e9 a7 10 00 00       	jmp    80104460 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
		p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
		wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 b7 0b 00 00       	call   80103f90 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
		release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 77 10 00 00       	call   80104460 <release>
		kfree((char *)p);
801033e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033ec:	83 c4 10             	add    $0x10,%esp
}
801033ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033f2:	5b                   	pop    %ebx
801033f3:	5e                   	pop    %esi
801033f4:	5d                   	pop    %ebp
		kfree((char *)p);
801033f5:	e9 26 ef ff ff       	jmp    80102320 <kfree>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103400 <pipewrite>:

// PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 28             	sub    $0x28,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;

	acquire(&p->lock);
8010340c:	53                   	push   %ebx
8010340d:	e8 2e 0f 00 00       	call   80104340 <acquire>
	for (i = 0; i < n; i++) {
80103412:	8b 45 10             	mov    0x10(%ebp),%eax
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 8e c9 00 00 00    	jle    801034e9 <pipewrite+0xe9>
80103420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103423:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
			if (p->readopen == 0 || myproc()->killed) {
				release(&p->lock);
				return -1;
			}
			wakeup(&p->nread);
80103429:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010342f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103432:	03 4d 10             	add    0x10(%ebp),%ecx
80103435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
80103438:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010343e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103444:	39 d0                	cmp    %edx,%eax
80103446:	75 71                	jne    801034b9 <pipewrite+0xb9>
			if (p->readopen == 0 || myproc()->killed) {
80103448:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 4e                	je     801034a0 <pipewrite+0xa0>
			sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
80103452:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103458:	eb 3a                	jmp    80103494 <pipewrite+0x94>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			wakeup(&p->nread);
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	57                   	push   %edi
80103464:	e8 27 0b 00 00       	call   80103f90 <wakeup>
			sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 5e 09 00 00       	call   80103dd0 <sleep>
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
80103472:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103478:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	05 00 02 00 00       	add    $0x200,%eax
80103486:	39 c2                	cmp    %eax,%edx
80103488:	75 36                	jne    801034c0 <pipewrite+0xc0>
			if (p->readopen == 0 || myproc()->killed) {
8010348a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103490:	85 c0                	test   %eax,%eax
80103492:	74 0c                	je     801034a0 <pipewrite+0xa0>
80103494:	e8 77 03 00 00       	call   80103810 <myproc>
80103499:	8b 40 24             	mov    0x24(%eax),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	74 c0                	je     80103460 <pipewrite+0x60>
				release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 b7 0f 00 00       	call   80104460 <release>
				return -1;
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		p->data[p->nwrite++ % PIPESIZE] = addr[i];
	}
	wakeup(&p->nread); // DOC: pipewrite-wakeup1
	release(&p->lock);
	return n;
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
		while (p->nwrite == p->nread + PIPESIZE) { // DOC: pipewrite-full
801034b9:	89 c2                	mov    %eax,%edx
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d2:	83 c6 01             	add    $0x1,%esi
801034d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
	for (i = 0; i < n; i++) {
801034d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
		p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
	for (i = 0; i < n; i++) {
801034e3:	0f 85 4f ff ff ff    	jne    80103438 <pipewrite+0x38>
	wakeup(&p->nread); // DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 98 0a 00 00       	call   80103f90 <wakeup>
	release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 60 0f 00 00       	call   80104460 <release>
	return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb a9                	jmp    801034b1 <pipewrite+0xb1>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 75 08             	mov    0x8(%ebp),%esi
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i;

	acquire(&p->lock);
8010351f:	56                   	push   %esi
80103520:	e8 1b 0e 00 00       	call   80104340 <acquire>
	while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010352e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103534:	75 6a                	jne    801035a0 <piperead+0x90>
80103536:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	0f 84 c4 00 00 00    	je     80103608 <piperead+0xf8>
		if (myproc()->killed) {
			release(&p->lock);
			return -1;
		}
		sleep(&p->nread, &p->lock); // DOC: piperead-sleep
80103544:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	e8 76 08 00 00       	call   80103dd0 <sleep>
	while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 8f 00 00 00    	je     80103608 <piperead+0xf8>
		if (myproc()->killed) {
80103579:	e8 92 02 00 00       	call   80103810 <myproc>
8010357e:	8b 48 24             	mov    0x24(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
			release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
			return -1;
80103588:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
			release(&p->lock);
8010358d:	56                   	push   %esi
8010358e:	e8 cd 0e 00 00       	call   80104460 <release>
			return -1;
80103593:	83 c4 10             	add    $0x10,%esp
		addr[i] = p->data[p->nread++ % PIPESIZE];
	}
	wakeup(&p->nwrite); // DOC: piperead-wakeup
	release(&p->lock);
	return i;
}
80103596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103599:	89 d8                	mov    %ebx,%eax
8010359b:	5b                   	pop    %ebx
8010359c:	5e                   	pop    %esi
8010359d:	5f                   	pop    %edi
8010359e:	5d                   	pop    %ebp
8010359f:	c3                   	ret    
	for (i = 0; i < n; i++) { // DOC: piperead-copy
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	7e 61                	jle    80103608 <piperead+0xf8>
		if (p->nread == p->nwrite) break;
801035a7:	31 db                	xor    %ebx,%ebx
801035a9:	eb 13                	jmp    801035be <piperead+0xae>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035bc:	74 1f                	je     801035dd <piperead+0xcd>
		addr[i] = p->data[p->nread++ % PIPESIZE];
801035be:	8d 41 01             	lea    0x1(%ecx),%eax
801035c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
	for (i = 0; i < n; i++) { // DOC: piperead-copy
801035d5:	83 c3 01             	add    $0x1,%ebx
801035d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035db:	75 d3                	jne    801035b0 <piperead+0xa0>
	wakeup(&p->nwrite); // DOC: piperead-wakeup
801035dd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	50                   	push   %eax
801035e7:	e8 a4 09 00 00       	call   80103f90 <wakeup>
	release(&p->lock);
801035ec:	89 34 24             	mov    %esi,(%esp)
801035ef:	e8 6c 0e 00 00       	call   80104460 <release>
	return i;
801035f4:	83 c4 10             	add    $0x10,%esp
}
801035f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fa:	89 d8                	mov    %ebx,%eax
801035fc:	5b                   	pop    %ebx
801035fd:	5e                   	pop    %esi
801035fe:	5f                   	pop    %edi
801035ff:	5d                   	pop    %ebp
80103600:	c3                   	ret    
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	31 db                	xor    %ebx,%ebx
8010360a:	eb d1                	jmp    801035dd <piperead+0xcd>
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <allocproc>:
// Otherwise return 0.

// MODIFIED TO INITIALIZE THE MUTEX-REFERENCE TABLE TO NULL
static struct proc *
allocproc(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
	struct proc *p;
	char *       sp;

	acquire(&ptable.lock);

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103614:	bb 14 32 11 80       	mov    $0x80113214,%ebx
{
80103619:	83 ec 10             	sub    $0x10,%esp
	acquire(&ptable.lock);
8010361c:	68 e0 31 11 80       	push   $0x801131e0
80103621:	e8 1a 0d 00 00       	call   80104340 <acquire>
80103626:	83 c4 10             	add    $0x10,%esp
80103629:	eb 17                	jmp    80103642 <allocproc+0x32>
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103630:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80103636:	81 fb 14 65 11 80    	cmp    $0x80116514,%ebx
8010363c:	0f 83 96 00 00 00    	jae    801036d8 <allocproc+0xc8>
		if (p->state == UNUSED) goto found;
80103642:	8b 43 0c             	mov    0xc(%ebx),%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	75 e7                	jne    80103630 <allocproc+0x20>
	release(&ptable.lock);
	return 0;

found:
	p->state = EMBRYO;
	p->pid   = nextpid++;
80103649:	a1 04 a0 10 80       	mov    0x8010a004,%eax

	release(&ptable.lock);
8010364e:	83 ec 0c             	sub    $0xc,%esp
	p->state = EMBRYO;
80103651:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	p->pid   = nextpid++;
80103658:	8d 50 01             	lea    0x1(%eax),%edx
8010365b:	89 43 10             	mov    %eax,0x10(%ebx)
	release(&ptable.lock);
8010365e:	68 e0 31 11 80       	push   $0x801131e0
	p->pid   = nextpid++;
80103663:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
	release(&ptable.lock);
80103669:	e8 f2 0d 00 00       	call   80104460 <release>

	// Allocate kernel stack.
	if ((p->kstack = kalloc()) == 0) {
8010366e:	e8 5d ee ff ff       	call   801024d0 <kalloc>
80103673:	83 c4 10             	add    $0x10,%esp
80103676:	85 c0                	test   %eax,%eax
80103678:	89 43 08             	mov    %eax,0x8(%ebx)
8010367b:	74 74                	je     801036f1 <allocproc+0xe1>
		return 0;
	}
	sp = p->kstack + KSTACKSIZE;

	// Leave room for trap frame.
	sp -= sizeof *p->tf;
8010367d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
	sp -= 4;
	*(uint *)sp = (uint)trapret;

	sp -= sizeof *p->context;
	p->context = (struct context *)sp;
	memset(p->context, 0, sizeof *p->context);
80103683:	83 ec 04             	sub    $0x4,%esp
	sp -= sizeof *p->context;
80103686:	05 9c 0f 00 00       	add    $0xf9c,%eax
	sp -= sizeof *p->tf;
8010368b:	89 53 18             	mov    %edx,0x18(%ebx)
	*(uint *)sp = (uint)trapret;
8010368e:	c7 40 14 42 57 10 80 	movl   $0x80105742,0x14(%eax)
	p->context = (struct context *)sp;
80103695:	89 43 1c             	mov    %eax,0x1c(%ebx)
	memset(p->context, 0, sizeof *p->context);
80103698:	6a 14                	push   $0x14
8010369a:	6a 00                	push   $0x0
8010369c:	50                   	push   %eax
8010369d:	e8 1e 0e 00 00       	call   801044c0 <memset>
	p->context->eip = (uint)forkret;
801036a2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036a5:	8d 93 cc 00 00 00    	lea    0xcc(%ebx),%edx
801036ab:	83 c4 10             	add    $0x10,%esp
801036ae:	c7 40 10 00 37 10 80 	movl   $0x80103700,0x10(%eax)
801036b5:	8d 43 7c             	lea    0x7c(%ebx),%eax
801036b8:	90                   	nop
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi


	// initialize the mutex-reference table to null
	int i;
	for (i=0; i<MUX_MAXNUM; i++){
		p->muxes[i] = 0;
801036c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801036c6:	83 c0 04             	add    $0x4,%eax
	for (i=0; i<MUX_MAXNUM; i++){
801036c9:	39 c2                	cmp    %eax,%edx
801036cb:	75 f3                	jne    801036c0 <allocproc+0xb0>
	}


	return p;
}
801036cd:	89 d8                	mov    %ebx,%eax
801036cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036d2:	c9                   	leave  
801036d3:	c3                   	ret    
801036d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	release(&ptable.lock);
801036d8:	83 ec 0c             	sub    $0xc,%esp
	return 0;
801036db:	31 db                	xor    %ebx,%ebx
	release(&ptable.lock);
801036dd:	68 e0 31 11 80       	push   $0x801131e0
801036e2:	e8 79 0d 00 00       	call   80104460 <release>
}
801036e7:	89 d8                	mov    %ebx,%eax
	return 0;
801036e9:	83 c4 10             	add    $0x10,%esp
}
801036ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036ef:	c9                   	leave  
801036f0:	c3                   	ret    
		p->state = UNUSED;
801036f1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		return 0;
801036f8:	31 db                	xor    %ebx,%ebx
801036fa:	eb d1                	jmp    801036cd <allocproc+0xbd>
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103700 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	83 ec 14             	sub    $0x14,%esp
	static int first = 1;
	// Still holding ptable.lock from scheduler.
	release(&ptable.lock);
80103706:	68 e0 31 11 80       	push   $0x801131e0
8010370b:	e8 50 0d 00 00       	call   80104460 <release>

	if (first) {
80103710:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	85 c0                	test   %eax,%eax
8010371a:	75 04                	jne    80103720 <forkret+0x20>
		iinit(ROOTDEV);
		initlog(ROOTDEV);
	}

	// Return to "caller", actually trapret (see allocproc).
}
8010371c:	c9                   	leave  
8010371d:	c3                   	ret    
8010371e:	66 90                	xchg   %ax,%ax
		iinit(ROOTDEV);
80103720:	83 ec 0c             	sub    $0xc,%esp
		first = 0;
80103723:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010372a:	00 00 00 
		iinit(ROOTDEV);
8010372d:	6a 01                	push   $0x1
8010372f:	e8 5c dd ff ff       	call   80101490 <iinit>
		initlog(ROOTDEV);
80103734:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010373b:	e8 d0 f3 ff ff       	call   80102b10 <initlog>
80103740:	83 c4 10             	add    $0x10,%esp
}
80103743:	c9                   	leave  
80103744:	c3                   	ret    
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <pinit>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	83 ec 10             	sub    $0x10,%esp
	initlock(&ptable.lock, "ptable");
80103756:	68 f5 74 10 80       	push   $0x801074f5
8010375b:	68 e0 31 11 80       	push   $0x801131e0
80103760:	e8 eb 0a 00 00       	call   80104250 <initlock>
}
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	c9                   	leave  
80103769:	c3                   	ret    
8010376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103770 <mycpu>:
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80103775:	9c                   	pushf  
80103776:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("mycpu called with interrupts enabled\n");
80103777:	f6 c4 02             	test   $0x2,%ah
8010377a:	75 5e                	jne    801037da <mycpu+0x6a>
	apicid = lapicid();
8010377c:	e8 bf ef ff ff       	call   80102740 <lapicid>
	for (i = 0; i < ncpu; ++i) {
80103781:	8b 35 c0 31 11 80    	mov    0x801131c0,%esi
80103787:	85 f6                	test   %esi,%esi
80103789:	7e 42                	jle    801037cd <mycpu+0x5d>
		if (cpus[i].apicid == apicid) return &cpus[i];
8010378b:	0f b6 15 40 2c 11 80 	movzbl 0x80112c40,%edx
80103792:	39 d0                	cmp    %edx,%eax
80103794:	74 30                	je     801037c6 <mycpu+0x56>
80103796:	b9 f0 2c 11 80       	mov    $0x80112cf0,%ecx
	for (i = 0; i < ncpu; ++i) {
8010379b:	31 d2                	xor    %edx,%edx
8010379d:	8d 76 00             	lea    0x0(%esi),%esi
801037a0:	83 c2 01             	add    $0x1,%edx
801037a3:	39 f2                	cmp    %esi,%edx
801037a5:	74 26                	je     801037cd <mycpu+0x5d>
		if (cpus[i].apicid == apicid) return &cpus[i];
801037a7:	0f b6 19             	movzbl (%ecx),%ebx
801037aa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037b0:	39 c3                	cmp    %eax,%ebx
801037b2:	75 ec                	jne    801037a0 <mycpu+0x30>
801037b4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037ba:	05 40 2c 11 80       	add    $0x80112c40,%eax
}
801037bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037c2:	5b                   	pop    %ebx
801037c3:	5e                   	pop    %esi
801037c4:	5d                   	pop    %ebp
801037c5:	c3                   	ret    
		if (cpus[i].apicid == apicid) return &cpus[i];
801037c6:	b8 40 2c 11 80       	mov    $0x80112c40,%eax
801037cb:	eb f2                	jmp    801037bf <mycpu+0x4f>
	panic("unknown apicid\n");
801037cd:	83 ec 0c             	sub    $0xc,%esp
801037d0:	68 fc 74 10 80       	push   $0x801074fc
801037d5:	e8 b6 cb ff ff       	call   80100390 <panic>
	if (readeflags() & FL_IF) panic("mycpu called with interrupts enabled\n");
801037da:	83 ec 0c             	sub    $0xc,%esp
801037dd:	68 d8 75 10 80       	push   $0x801075d8
801037e2:	e8 a9 cb ff ff       	call   80100390 <panic>
801037e7:	89 f6                	mov    %esi,%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037f0 <cpuid>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	83 ec 08             	sub    $0x8,%esp
	return mycpu() - cpus;
801037f6:	e8 75 ff ff ff       	call   80103770 <mycpu>
801037fb:	2d 40 2c 11 80       	sub    $0x80112c40,%eax
}
80103800:	c9                   	leave  
	return mycpu() - cpus;
80103801:	c1 f8 04             	sar    $0x4,%eax
80103804:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010380a:	c3                   	ret    
8010380b:	90                   	nop
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103810 <myproc>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
80103814:	83 ec 04             	sub    $0x4,%esp
	pushcli();
80103817:	e8 e4 0a 00 00       	call   80104300 <pushcli>
	c = mycpu();
8010381c:	e8 4f ff ff ff       	call   80103770 <mycpu>
	p = c->proc;
80103821:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103827:	e8 d4 0b 00 00       	call   80104400 <popcli>
}
8010382c:	83 c4 04             	add    $0x4,%esp
8010382f:	89 d8                	mov    %ebx,%eax
80103831:	5b                   	pop    %ebx
80103832:	5d                   	pop    %ebp
80103833:	c3                   	ret    
80103834:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010383a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103840 <userinit>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	53                   	push   %ebx
80103844:	83 ec 04             	sub    $0x4,%esp
	p = allocproc();
80103847:	e8 c4 fd ff ff       	call   80103610 <allocproc>
8010384c:	89 c3                	mov    %eax,%ebx
	initproc = p;
8010384e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
	if ((p->pgdir = setupkvm()) == 0) panic("userinit: out of memory?");
80103853:	e8 b8 34 00 00       	call   80106d10 <setupkvm>
80103858:	85 c0                	test   %eax,%eax
8010385a:	89 43 04             	mov    %eax,0x4(%ebx)
8010385d:	0f 84 d9 00 00 00    	je     8010393c <userinit+0xfc>
	inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103863:	83 ec 04             	sub    $0x4,%esp
80103866:	68 2c 00 00 00       	push   $0x2c
8010386b:	68 60 a4 10 80       	push   $0x8010a460
80103870:	50                   	push   %eax
80103871:	e8 7a 31 00 00       	call   801069f0 <inituvm>
	memset(p->tf, 0, sizeof(*p->tf));
80103876:	83 c4 0c             	add    $0xc,%esp
	p->sz = PGSIZE;
80103879:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
	memset(p->tf, 0, sizeof(*p->tf));
8010387f:	6a 4c                	push   $0x4c
80103881:	6a 00                	push   $0x0
80103883:	ff 73 18             	pushl  0x18(%ebx)
80103886:	e8 35 0c 00 00       	call   801044c0 <memset>
	p->tf->cs     = (SEG_UCODE << 3) | DPL_USER;
8010388b:	8b 43 18             	mov    0x18(%ebx),%eax
8010388e:	ba 1b 00 00 00       	mov    $0x1b,%edx
	p->tf->ds     = (SEG_UDATA << 3) | DPL_USER;
80103893:	b9 23 00 00 00       	mov    $0x23,%ecx
	safestrcpy(p->name, "initcode", sizeof(p->name));
80103898:	83 c4 0c             	add    $0xc,%esp
	p->tf->cs     = (SEG_UCODE << 3) | DPL_USER;
8010389b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
	p->tf->ds     = (SEG_UDATA << 3) | DPL_USER;
8010389f:	8b 43 18             	mov    0x18(%ebx),%eax
801038a2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
	p->tf->es     = p->tf->ds;
801038a6:	8b 43 18             	mov    0x18(%ebx),%eax
801038a9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ad:	66 89 50 28          	mov    %dx,0x28(%eax)
	p->tf->ss     = p->tf->ds;
801038b1:	8b 43 18             	mov    0x18(%ebx),%eax
801038b4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038b8:	66 89 50 48          	mov    %dx,0x48(%eax)
	p->tf->eflags = FL_IF;
801038bc:	8b 43 18             	mov    0x18(%ebx),%eax
801038bf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	p->tf->esp    = PGSIZE;
801038c6:	8b 43 18             	mov    0x18(%ebx),%eax
801038c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
	p->tf->eip    = 0; // beginning of initcode.S
801038d0:	8b 43 18             	mov    0x18(%ebx),%eax
801038d3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	safestrcpy(p->name, "initcode", sizeof(p->name));
801038da:	8d 43 6c             	lea    0x6c(%ebx),%eax
801038dd:	6a 10                	push   $0x10
801038df:	68 25 75 10 80       	push   $0x80107525
801038e4:	50                   	push   %eax
801038e5:	e8 b6 0d 00 00       	call   801046a0 <safestrcpy>
	p->cwd = namei("/");
801038ea:	c7 04 24 2e 75 10 80 	movl   $0x8010752e,(%esp)
801038f1:	e8 fa e5 ff ff       	call   80101ef0 <namei>
801038f6:	89 43 68             	mov    %eax,0x68(%ebx)
	acquire(&ptable.lock);
801038f9:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
80103900:	e8 3b 0a 00 00       	call   80104340 <acquire>
	p->state = RUNNABLE;
80103905:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	release(&ptable.lock);
8010390c:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
80103913:	e8 48 0b 00 00       	call   80104460 <release>
80103918:	b8 f4 ff 10 80       	mov    $0x8010fff4,%eax
8010391d:	83 c4 10             	add    $0x10,%esp
		MUTEXES[i].name = 0;
80103920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		MUTEXES[i].state = -1;
80103926:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
8010392d:	83 c0 3c             	add    $0x3c,%eax
	for(i=0; i<MUX_MAXNUM; i++){
80103930:	3d a4 04 11 80       	cmp    $0x801104a4,%eax
80103935:	75 e9                	jne    80103920 <userinit+0xe0>
}
80103937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010393a:	c9                   	leave  
8010393b:	c3                   	ret    
	if ((p->pgdir = setupkvm()) == 0) panic("userinit: out of memory?");
8010393c:	83 ec 0c             	sub    $0xc,%esp
8010393f:	68 0c 75 10 80       	push   $0x8010750c
80103944:	e8 47 ca ff ff       	call   80100390 <panic>
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103950 <growproc>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx
80103955:	8b 75 08             	mov    0x8(%ebp),%esi
	pushcli();
80103958:	e8 a3 09 00 00       	call   80104300 <pushcli>
	c = mycpu();
8010395d:	e8 0e fe ff ff       	call   80103770 <mycpu>
	p = c->proc;
80103962:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103968:	e8 93 0a 00 00       	call   80104400 <popcli>
	if (n > 0) {
8010396d:	83 fe 00             	cmp    $0x0,%esi
	sz = curproc->sz;
80103970:	8b 03                	mov    (%ebx),%eax
	if (n > 0) {
80103972:	7f 1c                	jg     80103990 <growproc+0x40>
	} else if (n < 0) {
80103974:	75 3a                	jne    801039b0 <growproc+0x60>
	switchuvm(curproc);
80103976:	83 ec 0c             	sub    $0xc,%esp
	curproc->sz = sz;
80103979:	89 03                	mov    %eax,(%ebx)
	switchuvm(curproc);
8010397b:	53                   	push   %ebx
8010397c:	e8 5f 2f 00 00       	call   801068e0 <switchuvm>
	return 0;
80103981:	83 c4 10             	add    $0x10,%esp
80103984:	31 c0                	xor    %eax,%eax
}
80103986:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103989:	5b                   	pop    %ebx
8010398a:	5e                   	pop    %esi
8010398b:	5d                   	pop    %ebp
8010398c:	c3                   	ret    
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
		if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) return -1;
80103990:	83 ec 04             	sub    $0x4,%esp
80103993:	01 c6                	add    %eax,%esi
80103995:	56                   	push   %esi
80103996:	50                   	push   %eax
80103997:	ff 73 04             	pushl  0x4(%ebx)
8010399a:	e8 91 31 00 00       	call   80106b30 <allocuvm>
8010399f:	83 c4 10             	add    $0x10,%esp
801039a2:	85 c0                	test   %eax,%eax
801039a4:	75 d0                	jne    80103976 <growproc+0x26>
801039a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039ab:	eb d9                	jmp    80103986 <growproc+0x36>
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
		if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) return -1;
801039b0:	83 ec 04             	sub    $0x4,%esp
801039b3:	01 c6                	add    %eax,%esi
801039b5:	56                   	push   %esi
801039b6:	50                   	push   %eax
801039b7:	ff 73 04             	pushl  0x4(%ebx)
801039ba:	e8 a1 32 00 00       	call   80106c60 <deallocuvm>
801039bf:	83 c4 10             	add    $0x10,%esp
801039c2:	85 c0                	test   %eax,%eax
801039c4:	75 b0                	jne    80103976 <growproc+0x26>
801039c6:	eb de                	jmp    801039a6 <growproc+0x56>
801039c8:	90                   	nop
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039d0 <fork>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
801039d5:	53                   	push   %ebx
801039d6:	83 ec 1c             	sub    $0x1c,%esp
	pushcli();
801039d9:	e8 22 09 00 00       	call   80104300 <pushcli>
	c = mycpu();
801039de:	e8 8d fd ff ff       	call   80103770 <mycpu>
	p = c->proc;
801039e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
801039e9:	e8 12 0a 00 00       	call   80104400 <popcli>
	if ((np = allocproc()) == 0) {
801039ee:	e8 1d fc ff ff       	call   80103610 <allocproc>
801039f3:	85 c0                	test   %eax,%eax
801039f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039f8:	0f 84 b7 00 00 00    	je     80103ab5 <fork+0xe5>
	if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
801039fe:	83 ec 08             	sub    $0x8,%esp
80103a01:	ff 33                	pushl  (%ebx)
80103a03:	ff 73 04             	pushl  0x4(%ebx)
80103a06:	89 c7                	mov    %eax,%edi
80103a08:	e8 d3 33 00 00       	call   80106de0 <copyuvm>
80103a0d:	83 c4 10             	add    $0x10,%esp
80103a10:	85 c0                	test   %eax,%eax
80103a12:	89 47 04             	mov    %eax,0x4(%edi)
80103a15:	0f 84 a1 00 00 00    	je     80103abc <fork+0xec>
	np->sz     = curproc->sz;
80103a1b:	8b 03                	mov    (%ebx),%eax
80103a1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a20:	89 01                	mov    %eax,(%ecx)
	np->parent = curproc;
80103a22:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a25:	89 c8                	mov    %ecx,%eax
	*np->tf    = *curproc->tf;
80103a27:	8b 79 18             	mov    0x18(%ecx),%edi
80103a2a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a2d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	for (i = 0; i < NOFILE; i++)
80103a34:	31 f6                	xor    %esi,%esi
	np->tf->eax = 0;
80103a36:	8b 40 18             	mov    0x18(%eax),%eax
80103a39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
		if (curproc->ofile[i]) np->ofile[i] = filedup(curproc->ofile[i]);
80103a40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a44:	85 c0                	test   %eax,%eax
80103a46:	74 13                	je     80103a5b <fork+0x8b>
80103a48:	83 ec 0c             	sub    $0xc,%esp
80103a4b:	50                   	push   %eax
80103a4c:	e8 9f d3 ff ff       	call   80100df0 <filedup>
80103a51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a54:	83 c4 10             	add    $0x10,%esp
80103a57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
	for (i = 0; i < NOFILE; i++)
80103a5b:	83 c6 01             	add    $0x1,%esi
80103a5e:	83 fe 10             	cmp    $0x10,%esi
80103a61:	75 dd                	jne    80103a40 <fork+0x70>
	np->cwd = idup(curproc->cwd);
80103a63:	83 ec 0c             	sub    $0xc,%esp
80103a66:	ff 73 68             	pushl  0x68(%ebx)
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a69:	83 c3 6c             	add    $0x6c,%ebx
	np->cwd = idup(curproc->cwd);
80103a6c:	e8 ef db ff ff       	call   80101660 <idup>
80103a71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a74:	83 c4 0c             	add    $0xc,%esp
	np->cwd = idup(curproc->cwd);
80103a77:	89 47 68             	mov    %eax,0x68(%edi)
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a7d:	6a 10                	push   $0x10
80103a7f:	53                   	push   %ebx
80103a80:	50                   	push   %eax
80103a81:	e8 1a 0c 00 00       	call   801046a0 <safestrcpy>
	pid = np->pid;
80103a86:	8b 5f 10             	mov    0x10(%edi),%ebx
	acquire(&ptable.lock);
80103a89:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
80103a90:	e8 ab 08 00 00       	call   80104340 <acquire>
	np->state = RUNNABLE;
80103a95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
	release(&ptable.lock);
80103a9c:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
80103aa3:	e8 b8 09 00 00       	call   80104460 <release>
	return pid;
80103aa8:	83 c4 10             	add    $0x10,%esp
}
80103aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aae:	89 d8                	mov    %ebx,%eax
80103ab0:	5b                   	pop    %ebx
80103ab1:	5e                   	pop    %esi
80103ab2:	5f                   	pop    %edi
80103ab3:	5d                   	pop    %ebp
80103ab4:	c3                   	ret    
		return -1;
80103ab5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103aba:	eb ef                	jmp    80103aab <fork+0xdb>
		kfree(np->kstack);
80103abc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103abf:	83 ec 0c             	sub    $0xc,%esp
80103ac2:	ff 73 08             	pushl  0x8(%ebx)
80103ac5:	e8 56 e8 ff ff       	call   80102320 <kfree>
		np->kstack = 0;
80103aca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
		np->state  = UNUSED;
80103ad1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		return -1;
80103ad8:	83 c4 10             	add    $0x10,%esp
80103adb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ae0:	eb c9                	jmp    80103aab <fork+0xdb>
80103ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103af0 <scheduler>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
80103af5:	53                   	push   %ebx
80103af6:	83 ec 0c             	sub    $0xc,%esp
	struct cpu * c = mycpu();
80103af9:	e8 72 fc ff ff       	call   80103770 <mycpu>
80103afe:	8d 78 04             	lea    0x4(%eax),%edi
80103b01:	89 c6                	mov    %eax,%esi
	c->proc        = 0;
80103b03:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b0a:	00 00 00 
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
	asm volatile("sti");
80103b10:	fb                   	sti    
		acquire(&ptable.lock);
80103b11:	83 ec 0c             	sub    $0xc,%esp
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b14:	bb 14 32 11 80       	mov    $0x80113214,%ebx
		acquire(&ptable.lock);
80103b19:	68 e0 31 11 80       	push   $0x801131e0
80103b1e:	e8 1d 08 00 00       	call   80104340 <acquire>
80103b23:	83 c4 10             	add    $0x10,%esp
80103b26:	8d 76 00             	lea    0x0(%esi),%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			if (p->state != RUNNABLE) continue;
80103b30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b34:	75 33                	jne    80103b69 <scheduler+0x79>
			switchuvm(p);
80103b36:	83 ec 0c             	sub    $0xc,%esp
			c->proc = p;
80103b39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
			switchuvm(p);
80103b3f:	53                   	push   %ebx
80103b40:	e8 9b 2d 00 00       	call   801068e0 <switchuvm>
			swtch(&(c->scheduler), p->context);
80103b45:	58                   	pop    %eax
80103b46:	5a                   	pop    %edx
80103b47:	ff 73 1c             	pushl  0x1c(%ebx)
80103b4a:	57                   	push   %edi
			p->state = RUNNING;
80103b4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
			swtch(&(c->scheduler), p->context);
80103b52:	e8 a4 0b 00 00       	call   801046fb <swtch>
			switchkvm();
80103b57:	e8 64 2d 00 00       	call   801068c0 <switchkvm>
			c->proc = 0;
80103b5c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b63:	00 00 00 
80103b66:	83 c4 10             	add    $0x10,%esp
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b69:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80103b6f:	81 fb 14 65 11 80    	cmp    $0x80116514,%ebx
80103b75:	72 b9                	jb     80103b30 <scheduler+0x40>
		release(&ptable.lock);
80103b77:	83 ec 0c             	sub    $0xc,%esp
80103b7a:	68 e0 31 11 80       	push   $0x801131e0
80103b7f:	e8 dc 08 00 00       	call   80104460 <release>
		sti();
80103b84:	83 c4 10             	add    $0x10,%esp
80103b87:	eb 87                	jmp    80103b10 <scheduler+0x20>
80103b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b90 <sched>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
	pushcli();
80103b95:	e8 66 07 00 00       	call   80104300 <pushcli>
	c = mycpu();
80103b9a:	e8 d1 fb ff ff       	call   80103770 <mycpu>
	p = c->proc;
80103b9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103ba5:	e8 56 08 00 00       	call   80104400 <popcli>
	if (!holding(&ptable.lock)) panic("sched ptable.lock");
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 e0 31 11 80       	push   $0x801131e0
80103bb2:	e8 09 07 00 00       	call   801042c0 <holding>
80103bb7:	83 c4 10             	add    $0x10,%esp
80103bba:	85 c0                	test   %eax,%eax
80103bbc:	74 4f                	je     80103c0d <sched+0x7d>
	if (mycpu()->ncli != 1) panic("sched locks");
80103bbe:	e8 ad fb ff ff       	call   80103770 <mycpu>
80103bc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bca:	75 68                	jne    80103c34 <sched+0xa4>
	if (p->state == RUNNING) panic("sched running");
80103bcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103bd0:	74 55                	je     80103c27 <sched+0x97>
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80103bd2:	9c                   	pushf  
80103bd3:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("sched interruptible");
80103bd4:	f6 c4 02             	test   $0x2,%ah
80103bd7:	75 41                	jne    80103c1a <sched+0x8a>
	intena = mycpu()->intena;
80103bd9:	e8 92 fb ff ff       	call   80103770 <mycpu>
	swtch(&p->context, mycpu()->scheduler);
80103bde:	83 c3 1c             	add    $0x1c,%ebx
	intena = mycpu()->intena;
80103be1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
	swtch(&p->context, mycpu()->scheduler);
80103be7:	e8 84 fb ff ff       	call   80103770 <mycpu>
80103bec:	83 ec 08             	sub    $0x8,%esp
80103bef:	ff 70 04             	pushl  0x4(%eax)
80103bf2:	53                   	push   %ebx
80103bf3:	e8 03 0b 00 00       	call   801046fb <swtch>
	mycpu()->intena = intena;
80103bf8:	e8 73 fb ff ff       	call   80103770 <mycpu>
}
80103bfd:	83 c4 10             	add    $0x10,%esp
	mycpu()->intena = intena;
80103c00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c09:	5b                   	pop    %ebx
80103c0a:	5e                   	pop    %esi
80103c0b:	5d                   	pop    %ebp
80103c0c:	c3                   	ret    
	if (!holding(&ptable.lock)) panic("sched ptable.lock");
80103c0d:	83 ec 0c             	sub    $0xc,%esp
80103c10:	68 30 75 10 80       	push   $0x80107530
80103c15:	e8 76 c7 ff ff       	call   80100390 <panic>
	if (readeflags() & FL_IF) panic("sched interruptible");
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 5c 75 10 80       	push   $0x8010755c
80103c22:	e8 69 c7 ff ff       	call   80100390 <panic>
	if (p->state == RUNNING) panic("sched running");
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	68 4e 75 10 80       	push   $0x8010754e
80103c2f:	e8 5c c7 ff ff       	call   80100390 <panic>
	if (mycpu()->ncli != 1) panic("sched locks");
80103c34:	83 ec 0c             	sub    $0xc,%esp
80103c37:	68 42 75 10 80       	push   $0x80107542
80103c3c:	e8 4f c7 ff ff       	call   80100390 <panic>
80103c41:	eb 0d                	jmp    80103c50 <exit>
80103c43:	90                   	nop
80103c44:	90                   	nop
80103c45:	90                   	nop
80103c46:	90                   	nop
80103c47:	90                   	nop
80103c48:	90                   	nop
80103c49:	90                   	nop
80103c4a:	90                   	nop
80103c4b:	90                   	nop
80103c4c:	90                   	nop
80103c4d:	90                   	nop
80103c4e:	90                   	nop
80103c4f:	90                   	nop

80103c50 <exit>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 0c             	sub    $0xc,%esp
	pushcli();
80103c59:	e8 a2 06 00 00       	call   80104300 <pushcli>
	c = mycpu();
80103c5e:	e8 0d fb ff ff       	call   80103770 <mycpu>
	p = c->proc;
80103c63:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	popcli();
80103c69:	e8 92 07 00 00       	call   80104400 <popcli>
	if (curproc == initproc) panic("init exiting");
80103c6e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c74:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c77:	8d 7e 68             	lea    0x68(%esi),%edi
80103c7a:	0f 84 f1 00 00 00    	je     80103d71 <exit+0x121>
		if (curproc->ofile[fd]) {
80103c80:	8b 03                	mov    (%ebx),%eax
80103c82:	85 c0                	test   %eax,%eax
80103c84:	74 12                	je     80103c98 <exit+0x48>
			fileclose(curproc->ofile[fd]);
80103c86:	83 ec 0c             	sub    $0xc,%esp
80103c89:	50                   	push   %eax
80103c8a:	e8 b1 d1 ff ff       	call   80100e40 <fileclose>
			curproc->ofile[fd] = 0;
80103c8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c95:	83 c4 10             	add    $0x10,%esp
80103c98:	83 c3 04             	add    $0x4,%ebx
	for (fd = 0; fd < NOFILE; fd++) {
80103c9b:	39 fb                	cmp    %edi,%ebx
80103c9d:	75 e1                	jne    80103c80 <exit+0x30>
	begin_op();
80103c9f:	e8 0c ef ff ff       	call   80102bb0 <begin_op>
	iput(curproc->cwd);
80103ca4:	83 ec 0c             	sub    $0xc,%esp
80103ca7:	ff 76 68             	pushl  0x68(%esi)
80103caa:	e8 11 db ff ff       	call   801017c0 <iput>
	end_op();
80103caf:	e8 6c ef ff ff       	call   80102c20 <end_op>
	curproc->cwd = 0;
80103cb4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
	acquire(&ptable.lock);
80103cbb:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
80103cc2:	e8 79 06 00 00       	call   80104340 <acquire>
	wakeup1(curproc->parent);
80103cc7:	8b 56 14             	mov    0x14(%esi),%edx
80103cca:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
	struct proc *p;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ccd:	b8 14 32 11 80       	mov    $0x80113214,%eax
80103cd2:	eb 10                	jmp    80103ce4 <exit+0x94>
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cd8:	05 cc 00 00 00       	add    $0xcc,%eax
80103cdd:	3d 14 65 11 80       	cmp    $0x80116514,%eax
80103ce2:	73 1e                	jae    80103d02 <exit+0xb2>
		if (p->state == SLEEPING && p->chan == chan) p->state = RUNNABLE;
80103ce4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ce8:	75 ee                	jne    80103cd8 <exit+0x88>
80103cea:	3b 50 20             	cmp    0x20(%eax),%edx
80103ced:	75 e9                	jne    80103cd8 <exit+0x88>
80103cef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf6:	05 cc 00 00 00       	add    $0xcc,%eax
80103cfb:	3d 14 65 11 80       	cmp    $0x80116514,%eax
80103d00:	72 e2                	jb     80103ce4 <exit+0x94>
			p->parent = initproc;
80103d02:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d08:	ba 14 32 11 80       	mov    $0x80113214,%edx
80103d0d:	eb 0f                	jmp    80103d1e <exit+0xce>
80103d0f:	90                   	nop
80103d10:	81 c2 cc 00 00 00    	add    $0xcc,%edx
80103d16:	81 fa 14 65 11 80    	cmp    $0x80116514,%edx
80103d1c:	73 3a                	jae    80103d58 <exit+0x108>
		if (p->parent == curproc) {
80103d1e:	39 72 14             	cmp    %esi,0x14(%edx)
80103d21:	75 ed                	jne    80103d10 <exit+0xc0>
			if (p->state == ZOMBIE) wakeup1(initproc);
80103d23:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
			p->parent = initproc;
80103d27:	89 4a 14             	mov    %ecx,0x14(%edx)
			if (p->state == ZOMBIE) wakeup1(initproc);
80103d2a:	75 e4                	jne    80103d10 <exit+0xc0>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d2c:	b8 14 32 11 80       	mov    $0x80113214,%eax
80103d31:	eb 11                	jmp    80103d44 <exit+0xf4>
80103d33:	90                   	nop
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d38:	05 cc 00 00 00       	add    $0xcc,%eax
80103d3d:	3d 14 65 11 80       	cmp    $0x80116514,%eax
80103d42:	73 cc                	jae    80103d10 <exit+0xc0>
		if (p->state == SLEEPING && p->chan == chan) p->state = RUNNABLE;
80103d44:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d48:	75 ee                	jne    80103d38 <exit+0xe8>
80103d4a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d4d:	75 e9                	jne    80103d38 <exit+0xe8>
80103d4f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d56:	eb e0                	jmp    80103d38 <exit+0xe8>
	curproc->state = ZOMBIE;
80103d58:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
	sched();
80103d5f:	e8 2c fe ff ff       	call   80103b90 <sched>
	panic("zombie exit");
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	68 7d 75 10 80       	push   $0x8010757d
80103d6c:	e8 1f c6 ff ff       	call   80100390 <panic>
	if (curproc == initproc) panic("init exiting");
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	68 70 75 10 80       	push   $0x80107570
80103d79:	e8 12 c6 ff ff       	call   80100390 <panic>
80103d7e:	66 90                	xchg   %ax,%ax

80103d80 <yield>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	53                   	push   %ebx
80103d84:	83 ec 10             	sub    $0x10,%esp
	acquire(&ptable.lock); // DOC: yieldlock
80103d87:	68 e0 31 11 80       	push   $0x801131e0
80103d8c:	e8 af 05 00 00       	call   80104340 <acquire>
	pushcli();
80103d91:	e8 6a 05 00 00       	call   80104300 <pushcli>
	c = mycpu();
80103d96:	e8 d5 f9 ff ff       	call   80103770 <mycpu>
	p = c->proc;
80103d9b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103da1:	e8 5a 06 00 00       	call   80104400 <popcli>
	myproc()->state = RUNNABLE;
80103da6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	sched();
80103dad:	e8 de fd ff ff       	call   80103b90 <sched>
	release(&ptable.lock);
80103db2:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
80103db9:	e8 a2 06 00 00       	call   80104460 <release>
}
80103dbe:	83 c4 10             	add    $0x10,%esp
80103dc1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dc4:	c9                   	leave  
80103dc5:	c3                   	ret    
80103dc6:	8d 76 00             	lea    0x0(%esi),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <sleep>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 0c             	sub    $0xc,%esp
80103dd9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ddc:	8b 75 0c             	mov    0xc(%ebp),%esi
	pushcli();
80103ddf:	e8 1c 05 00 00       	call   80104300 <pushcli>
	c = mycpu();
80103de4:	e8 87 f9 ff ff       	call   80103770 <mycpu>
	p = c->proc;
80103de9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103def:	e8 0c 06 00 00       	call   80104400 <popcli>
	if (p == 0) panic("sleep");
80103df4:	85 db                	test   %ebx,%ebx
80103df6:	0f 84 87 00 00 00    	je     80103e83 <sleep+0xb3>
	if (lk == 0) panic("sleep without lk");
80103dfc:	85 f6                	test   %esi,%esi
80103dfe:	74 76                	je     80103e76 <sleep+0xa6>
	if (lk != &ptable.lock) {      // DOC: sleeplock0
80103e00:	81 fe e0 31 11 80    	cmp    $0x801131e0,%esi
80103e06:	74 50                	je     80103e58 <sleep+0x88>
		acquire(&ptable.lock); // DOC: sleeplock1
80103e08:	83 ec 0c             	sub    $0xc,%esp
80103e0b:	68 e0 31 11 80       	push   $0x801131e0
80103e10:	e8 2b 05 00 00       	call   80104340 <acquire>
		release(lk);
80103e15:	89 34 24             	mov    %esi,(%esp)
80103e18:	e8 43 06 00 00       	call   80104460 <release>
	p->chan  = chan;
80103e1d:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
80103e20:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	sched();
80103e27:	e8 64 fd ff ff       	call   80103b90 <sched>
	p->chan = 0;
80103e2c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
		release(&ptable.lock);
80103e33:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
80103e3a:	e8 21 06 00 00       	call   80104460 <release>
		acquire(lk);
80103e3f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e42:	83 c4 10             	add    $0x10,%esp
}
80103e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e48:	5b                   	pop    %ebx
80103e49:	5e                   	pop    %esi
80103e4a:	5f                   	pop    %edi
80103e4b:	5d                   	pop    %ebp
		acquire(lk);
80103e4c:	e9 ef 04 00 00       	jmp    80104340 <acquire>
80103e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	p->chan  = chan;
80103e58:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
80103e5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	sched();
80103e62:	e8 29 fd ff ff       	call   80103b90 <sched>
	p->chan = 0;
80103e67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e71:	5b                   	pop    %ebx
80103e72:	5e                   	pop    %esi
80103e73:	5f                   	pop    %edi
80103e74:	5d                   	pop    %ebp
80103e75:	c3                   	ret    
	if (lk == 0) panic("sleep without lk");
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	68 8f 75 10 80       	push   $0x8010758f
80103e7e:	e8 0d c5 ff ff       	call   80100390 <panic>
	if (p == 0) panic("sleep");
80103e83:	83 ec 0c             	sub    $0xc,%esp
80103e86:	68 89 75 10 80       	push   $0x80107589
80103e8b:	e8 00 c5 ff ff       	call   80100390 <panic>

80103e90 <wait>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	56                   	push   %esi
80103e94:	53                   	push   %ebx
	pushcli();
80103e95:	e8 66 04 00 00       	call   80104300 <pushcli>
	c = mycpu();
80103e9a:	e8 d1 f8 ff ff       	call   80103770 <mycpu>
	p = c->proc;
80103e9f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	popcli();
80103ea5:	e8 56 05 00 00       	call   80104400 <popcli>
	acquire(&ptable.lock);
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 e0 31 11 80       	push   $0x801131e0
80103eb2:	e8 89 04 00 00       	call   80104340 <acquire>
80103eb7:	83 c4 10             	add    $0x10,%esp
		havekids = 0;
80103eba:	31 c0                	xor    %eax,%eax
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ebc:	bb 14 32 11 80       	mov    $0x80113214,%ebx
80103ec1:	eb 13                	jmp    80103ed6 <wait+0x46>
80103ec3:	90                   	nop
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ec8:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
80103ece:	81 fb 14 65 11 80    	cmp    $0x80116514,%ebx
80103ed4:	73 1e                	jae    80103ef4 <wait+0x64>
			if (p->parent != curproc) continue;
80103ed6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ed9:	75 ed                	jne    80103ec8 <wait+0x38>
			if (p->state == ZOMBIE) {
80103edb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103edf:	74 37                	je     80103f18 <wait+0x88>
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103ee1:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
			havekids = 1;
80103ee7:	b8 01 00 00 00       	mov    $0x1,%eax
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103eec:	81 fb 14 65 11 80    	cmp    $0x80116514,%ebx
80103ef2:	72 e2                	jb     80103ed6 <wait+0x46>
		if (!havekids || curproc->killed) {
80103ef4:	85 c0                	test   %eax,%eax
80103ef6:	74 76                	je     80103f6e <wait+0xde>
80103ef8:	8b 46 24             	mov    0x24(%esi),%eax
80103efb:	85 c0                	test   %eax,%eax
80103efd:	75 6f                	jne    80103f6e <wait+0xde>
		sleep(curproc, &ptable.lock); // DOC: wait-sleep
80103eff:	83 ec 08             	sub    $0x8,%esp
80103f02:	68 e0 31 11 80       	push   $0x801131e0
80103f07:	56                   	push   %esi
80103f08:	e8 c3 fe ff ff       	call   80103dd0 <sleep>
		havekids = 0;
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	eb a8                	jmp    80103eba <wait+0x2a>
80103f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				kfree(p->kstack);
80103f18:	83 ec 0c             	sub    $0xc,%esp
80103f1b:	ff 73 08             	pushl  0x8(%ebx)
				pid = p->pid;
80103f1e:	8b 73 10             	mov    0x10(%ebx),%esi
				kfree(p->kstack);
80103f21:	e8 fa e3 ff ff       	call   80102320 <kfree>
				freevm(p->pgdir);
80103f26:	5a                   	pop    %edx
80103f27:	ff 73 04             	pushl  0x4(%ebx)
				p->kstack = 0;
80103f2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
				freevm(p->pgdir);
80103f31:	e8 5a 2d 00 00       	call   80106c90 <freevm>
				release(&ptable.lock);
80103f36:	c7 04 24 e0 31 11 80 	movl   $0x801131e0,(%esp)
				p->pid     = 0;
80103f3d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
				p->parent  = 0;
80103f44:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
				p->name[0] = 0;
80103f4b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
				p->killed  = 0;
80103f4f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
				p->state   = UNUSED;
80103f56:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
				release(&ptable.lock);
80103f5d:	e8 fe 04 00 00       	call   80104460 <release>
				return pid;
80103f62:	83 c4 10             	add    $0x10,%esp
}
80103f65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f68:	89 f0                	mov    %esi,%eax
80103f6a:	5b                   	pop    %ebx
80103f6b:	5e                   	pop    %esi
80103f6c:	5d                   	pop    %ebp
80103f6d:	c3                   	ret    
			release(&ptable.lock);
80103f6e:	83 ec 0c             	sub    $0xc,%esp
			return -1;
80103f71:	be ff ff ff ff       	mov    $0xffffffff,%esi
			release(&ptable.lock);
80103f76:	68 e0 31 11 80       	push   $0x801131e0
80103f7b:	e8 e0 04 00 00       	call   80104460 <release>
			return -1;
80103f80:	83 c4 10             	add    $0x10,%esp
80103f83:	eb e0                	jmp    80103f65 <wait+0xd5>
80103f85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 10             	sub    $0x10,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
80103f9a:	68 e0 31 11 80       	push   $0x801131e0
80103f9f:	e8 9c 03 00 00       	call   80104340 <acquire>
80103fa4:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa7:	b8 14 32 11 80       	mov    $0x80113214,%eax
80103fac:	eb 0e                	jmp    80103fbc <wakeup+0x2c>
80103fae:	66 90                	xchg   %ax,%ax
80103fb0:	05 cc 00 00 00       	add    $0xcc,%eax
80103fb5:	3d 14 65 11 80       	cmp    $0x80116514,%eax
80103fba:	73 1e                	jae    80103fda <wakeup+0x4a>
		if (p->state == SLEEPING && p->chan == chan) p->state = RUNNABLE;
80103fbc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fc0:	75 ee                	jne    80103fb0 <wakeup+0x20>
80103fc2:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fc5:	75 e9                	jne    80103fb0 <wakeup+0x20>
80103fc7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fce:	05 cc 00 00 00       	add    $0xcc,%eax
80103fd3:	3d 14 65 11 80       	cmp    $0x80116514,%eax
80103fd8:	72 e2                	jb     80103fbc <wakeup+0x2c>
	wakeup1(chan);
	release(&ptable.lock);
80103fda:	c7 45 08 e0 31 11 80 	movl   $0x801131e0,0x8(%ebp)
}
80103fe1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fe4:	c9                   	leave  
	release(&ptable.lock);
80103fe5:	e9 76 04 00 00       	jmp    80104460 <release>
80103fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ff0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
80103ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *p;

	acquire(&ptable.lock);
80103ffa:	68 e0 31 11 80       	push   $0x801131e0
80103fff:	e8 3c 03 00 00       	call   80104340 <acquire>
80104004:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104007:	b8 14 32 11 80       	mov    $0x80113214,%eax
8010400c:	eb 0e                	jmp    8010401c <kill+0x2c>
8010400e:	66 90                	xchg   %ax,%ax
80104010:	05 cc 00 00 00       	add    $0xcc,%eax
80104015:	3d 14 65 11 80       	cmp    $0x80116514,%eax
8010401a:	73 34                	jae    80104050 <kill+0x60>
		if (p->pid == pid) {
8010401c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010401f:	75 ef                	jne    80104010 <kill+0x20>
			p->killed = 1;
			// Wake process from sleep if necessary.
			if (p->state == SLEEPING) p->state = RUNNABLE;
80104021:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
			p->killed = 1;
80104025:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
			if (p->state == SLEEPING) p->state = RUNNABLE;
8010402c:	75 07                	jne    80104035 <kill+0x45>
8010402e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
			release(&ptable.lock);
80104035:	83 ec 0c             	sub    $0xc,%esp
80104038:	68 e0 31 11 80       	push   $0x801131e0
8010403d:	e8 1e 04 00 00       	call   80104460 <release>
			return 0;
80104042:	83 c4 10             	add    $0x10,%esp
80104045:	31 c0                	xor    %eax,%eax
		}
	}
	release(&ptable.lock);
	return -1;
}
80104047:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010404a:	c9                   	leave  
8010404b:	c3                   	ret    
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	release(&ptable.lock);
80104050:	83 ec 0c             	sub    $0xc,%esp
80104053:	68 e0 31 11 80       	push   $0x801131e0
80104058:	e8 03 04 00 00       	call   80104460 <release>
	return -1;
8010405d:	83 c4 10             	add    $0x10,%esp
80104060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104068:	c9                   	leave  
80104069:	c3                   	ret    
8010406a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104070 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	8d 75 e8             	lea    -0x18(%ebp),%esi
	int          i;
	struct proc *p;
	char *       state;
	uint         pc[10];

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104079:	bb 14 32 11 80       	mov    $0x80113214,%ebx
{
8010407e:	83 ec 3c             	sub    $0x3c,%esp
80104081:	eb 27                	jmp    801040aa <procdump+0x3a>
80104083:	90                   	nop
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("%d %s %s", p->pid, state, p->name);
		if (p->state == SLEEPING) {
			getcallerpcs((uint *)p->context->ebp + 2, pc);
			for (i = 0; i < 10 && pc[i] != 0; i++) cprintf(" %p", pc[i]);
		}
		cprintf("\n");
80104088:	83 ec 0c             	sub    $0xc,%esp
8010408b:	68 27 79 10 80       	push   $0x80107927
80104090:	e8 cb c5 ff ff       	call   80100660 <cprintf>
80104095:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104098:	81 c3 cc 00 00 00    	add    $0xcc,%ebx
8010409e:	81 fb 14 65 11 80    	cmp    $0x80116514,%ebx
801040a4:	0f 83 86 00 00 00    	jae    80104130 <procdump+0xc0>
		if (p->state == UNUSED) continue;
801040aa:	8b 43 0c             	mov    0xc(%ebx),%eax
801040ad:	85 c0                	test   %eax,%eax
801040af:	74 e7                	je     80104098 <procdump+0x28>
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040b1:	83 f8 05             	cmp    $0x5,%eax
			state = "???";
801040b4:	ba a0 75 10 80       	mov    $0x801075a0,%edx
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040b9:	77 11                	ja     801040cc <procdump+0x5c>
801040bb:	8b 14 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%edx
			state = "???";
801040c2:	b8 a0 75 10 80       	mov    $0x801075a0,%eax
801040c7:	85 d2                	test   %edx,%edx
801040c9:	0f 44 d0             	cmove  %eax,%edx
		cprintf("%d %s %s", p->pid, state, p->name);
801040cc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801040cf:	50                   	push   %eax
801040d0:	52                   	push   %edx
801040d1:	ff 73 10             	pushl  0x10(%ebx)
801040d4:	68 a4 75 10 80       	push   $0x801075a4
801040d9:	e8 82 c5 ff ff       	call   80100660 <cprintf>
		if (p->state == SLEEPING) {
801040de:	83 c4 10             	add    $0x10,%esp
801040e1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801040e5:	75 a1                	jne    80104088 <procdump+0x18>
			getcallerpcs((uint *)p->context->ebp + 2, pc);
801040e7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801040ea:	83 ec 08             	sub    $0x8,%esp
801040ed:	8d 7d c0             	lea    -0x40(%ebp),%edi
801040f0:	50                   	push   %eax
801040f1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801040f4:	8b 40 0c             	mov    0xc(%eax),%eax
801040f7:	83 c0 08             	add    $0x8,%eax
801040fa:	50                   	push   %eax
801040fb:	e8 70 01 00 00       	call   80104270 <getcallerpcs>
80104100:	83 c4 10             	add    $0x10,%esp
80104103:	90                   	nop
80104104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			for (i = 0; i < 10 && pc[i] != 0; i++) cprintf(" %p", pc[i]);
80104108:	8b 17                	mov    (%edi),%edx
8010410a:	85 d2                	test   %edx,%edx
8010410c:	0f 84 76 ff ff ff    	je     80104088 <procdump+0x18>
80104112:	83 ec 08             	sub    $0x8,%esp
80104115:	83 c7 04             	add    $0x4,%edi
80104118:	52                   	push   %edx
80104119:	68 e1 6f 10 80       	push   $0x80106fe1
8010411e:	e8 3d c5 ff ff       	call   80100660 <cprintf>
80104123:	83 c4 10             	add    $0x10,%esp
80104126:	39 fe                	cmp    %edi,%esi
80104128:	75 de                	jne    80104108 <procdump+0x98>
8010412a:	e9 59 ff ff ff       	jmp    80104088 <procdump+0x18>
8010412f:	90                   	nop
	}
}
80104130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104133:	5b                   	pop    %ebx
80104134:	5e                   	pop    %esi
80104135:	5f                   	pop    %edi
80104136:	5d                   	pop    %ebp
80104137:	c3                   	ret    
80104138:	66 90                	xchg   %ax,%ax
8010413a:	66 90                	xchg   %ax,%ax
8010413c:	66 90                	xchg   %ax,%ax
8010413e:	66 90                	xchg   %ax,%ax

80104140 <initsleeplock>:
// #include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 0c             	sub    $0xc,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&lk->lk, "sleep lock");
8010414a:	68 18 76 10 80       	push   $0x80107618
8010414f:	8d 43 04             	lea    0x4(%ebx),%eax
80104152:	50                   	push   %eax
80104153:	e8 f8 00 00 00       	call   80104250 <initlock>
	lk->name   = name;
80104158:	8b 45 0c             	mov    0xc(%ebp),%eax
	lk->locked = 0;
8010415b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	lk->pid    = 0;
}
80104161:	83 c4 10             	add    $0x10,%esp
	lk->pid    = 0;
80104164:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
	lk->name   = name;
8010416b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010416e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104171:	c9                   	leave  
80104172:	c3                   	ret    
80104173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	56                   	push   %esi
80104184:	53                   	push   %ebx
80104185:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lk->lk);
80104188:	83 ec 0c             	sub    $0xc,%esp
8010418b:	8d 73 04             	lea    0x4(%ebx),%esi
8010418e:	56                   	push   %esi
8010418f:	e8 ac 01 00 00       	call   80104340 <acquire>
	while (lk->locked) {
80104194:	8b 13                	mov    (%ebx),%edx
80104196:	83 c4 10             	add    $0x10,%esp
80104199:	85 d2                	test   %edx,%edx
8010419b:	74 16                	je     801041b3 <acquiresleep+0x33>
8010419d:	8d 76 00             	lea    0x0(%esi),%esi
		sleep(lk, &lk->lk);
801041a0:	83 ec 08             	sub    $0x8,%esp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	e8 26 fc ff ff       	call   80103dd0 <sleep>
	while (lk->locked) {
801041aa:	8b 03                	mov    (%ebx),%eax
801041ac:	83 c4 10             	add    $0x10,%esp
801041af:	85 c0                	test   %eax,%eax
801041b1:	75 ed                	jne    801041a0 <acquiresleep+0x20>
	}
	lk->locked = 1;
801041b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
	lk->pid    = myproc()->pid;
801041b9:	e8 52 f6 ff ff       	call   80103810 <myproc>
801041be:	8b 40 10             	mov    0x10(%eax),%eax
801041c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
	release(&lk->lk);
801041c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041ca:	5b                   	pop    %ebx
801041cb:	5e                   	pop    %esi
801041cc:	5d                   	pop    %ebp
	release(&lk->lk);
801041cd:	e9 8e 02 00 00       	jmp    80104460 <release>
801041d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
801041e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lk->lk);
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	8d 73 04             	lea    0x4(%ebx),%esi
801041ee:	56                   	push   %esi
801041ef:	e8 4c 01 00 00       	call   80104340 <acquire>
	lk->locked = 0;
801041f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	lk->pid    = 0;
801041fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
	wakeup(lk);
80104201:	89 1c 24             	mov    %ebx,(%esp)
80104204:	e8 87 fd ff ff       	call   80103f90 <wakeup>
	release(&lk->lk);
80104209:	89 75 08             	mov    %esi,0x8(%ebp)
8010420c:	83 c4 10             	add    $0x10,%esp
}
8010420f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104212:	5b                   	pop    %ebx
80104213:	5e                   	pop    %esi
80104214:	5d                   	pop    %ebp
	release(&lk->lk);
80104215:	e9 46 02 00 00       	jmp    80104460 <release>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;

	acquire(&lk->lk);
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010422e:	53                   	push   %ebx
8010422f:	e8 0c 01 00 00       	call   80104340 <acquire>
	r = lk->locked;
80104234:	8b 36                	mov    (%esi),%esi
	release(&lk->lk);
80104236:	89 1c 24             	mov    %ebx,(%esp)
80104239:	e8 22 02 00 00       	call   80104460 <release>
	return r;
}
8010423e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104241:	89 f0                	mov    %esi,%eax
80104243:	5b                   	pop    %ebx
80104244:	5e                   	pop    %esi
80104245:	5d                   	pop    %ebp
80104246:	c3                   	ret    
80104247:	66 90                	xchg   %ax,%ax
80104249:	66 90                	xchg   %ax,%ax
8010424b:	66 90                	xchg   %ax,%ax
8010424d:	66 90                	xchg   %ax,%ax
8010424f:	90                   	nop

80104250 <initlock>:
#include "proc.h"
// #include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->name   = name;
80104256:	8b 55 0c             	mov    0xc(%ebp),%edx
	lk->locked = 0;
80104259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	lk->name   = name;
8010425f:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu    = 0;
80104262:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104269:	5d                   	pop    %ebp
8010426a:	c3                   	ret    
8010426b:	90                   	nop
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104270:	55                   	push   %ebp
	uint *ebp;
	int   i;

	ebp = (uint *)v - 2;
	for (i = 0; i < 10; i++) {
80104271:	31 d2                	xor    %edx,%edx
{
80104273:	89 e5                	mov    %esp,%ebp
80104275:	53                   	push   %ebx
	ebp = (uint *)v - 2;
80104276:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104279:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	ebp = (uint *)v - 2;
8010427c:	83 e8 08             	sub    $0x8,%eax
8010427f:	90                   	nop
		if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff) break;
80104280:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104286:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010428c:	77 1a                	ja     801042a8 <getcallerpcs+0x38>
		pcs[i] = ebp[1];         // saved %eip
8010428e:	8b 58 04             	mov    0x4(%eax),%ebx
80104291:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
	for (i = 0; i < 10; i++) {
80104294:	83 c2 01             	add    $0x1,%edx
		ebp    = (uint *)ebp[0]; // saved %ebp
80104297:	8b 00                	mov    (%eax),%eax
	for (i = 0; i < 10; i++) {
80104299:	83 fa 0a             	cmp    $0xa,%edx
8010429c:	75 e2                	jne    80104280 <getcallerpcs+0x10>
	}
	for (; i < 10; i++) pcs[i] = 0;
}
8010429e:	5b                   	pop    %ebx
8010429f:	5d                   	pop    %ebp
801042a0:	c3                   	ret    
801042a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801042ab:	83 c1 28             	add    $0x28,%ecx
801042ae:	66 90                	xchg   %ax,%ax
	for (; i < 10; i++) pcs[i] = 0;
801042b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801042b6:	83 c0 04             	add    $0x4,%eax
801042b9:	39 c1                	cmp    %eax,%ecx
801042bb:	75 f3                	jne    801042b0 <getcallerpcs+0x40>
}
801042bd:	5b                   	pop    %ebx
801042be:	5d                   	pop    %ebp
801042bf:	c3                   	ret    

801042c0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 04             	sub    $0x4,%esp
801042c7:	8b 55 08             	mov    0x8(%ebp),%edx
	return lock->locked && lock->cpu == mycpu();
801042ca:	8b 02                	mov    (%edx),%eax
801042cc:	85 c0                	test   %eax,%eax
801042ce:	75 10                	jne    801042e0 <holding+0x20>
}
801042d0:	83 c4 04             	add    $0x4,%esp
801042d3:	31 c0                	xor    %eax,%eax
801042d5:	5b                   	pop    %ebx
801042d6:	5d                   	pop    %ebp
801042d7:	c3                   	ret    
801042d8:	90                   	nop
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return lock->locked && lock->cpu == mycpu();
801042e0:	8b 5a 08             	mov    0x8(%edx),%ebx
801042e3:	e8 88 f4 ff ff       	call   80103770 <mycpu>
801042e8:	39 c3                	cmp    %eax,%ebx
801042ea:	0f 94 c0             	sete   %al
}
801042ed:	83 c4 04             	add    $0x4,%esp
	return lock->locked && lock->cpu == mycpu();
801042f0:	0f b6 c0             	movzbl %al,%eax
}
801042f3:	5b                   	pop    %ebx
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret    
801042f6:	8d 76 00             	lea    0x0(%esi),%esi
801042f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104300 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 04             	sub    $0x4,%esp
80104307:	9c                   	pushf  
80104308:	5b                   	pop    %ebx
	asm volatile("cli");
80104309:	fa                   	cli    
	int eflags;

	eflags = readeflags();
	cli();
	if (mycpu()->ncli == 0) mycpu()->intena = eflags & FL_IF;
8010430a:	e8 61 f4 ff ff       	call   80103770 <mycpu>
8010430f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104315:	85 c0                	test   %eax,%eax
80104317:	75 11                	jne    8010432a <pushcli+0x2a>
80104319:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010431f:	e8 4c f4 ff ff       	call   80103770 <mycpu>
80104324:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
	mycpu()->ncli += 1;
8010432a:	e8 41 f4 ff ff       	call   80103770 <mycpu>
8010432f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104336:	83 c4 04             	add    $0x4,%esp
80104339:	5b                   	pop    %ebx
8010433a:	5d                   	pop    %ebp
8010433b:	c3                   	ret    
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104340 <acquire>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	56                   	push   %esi
80104344:	53                   	push   %ebx
	pushcli(); // disable interrupts to avoid deadlock.
80104345:	e8 b6 ff ff ff       	call   80104300 <pushcli>
	if (holding(lk)) panic("acquire");
8010434a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == mycpu();
8010434d:	8b 03                	mov    (%ebx),%eax
8010434f:	85 c0                	test   %eax,%eax
80104351:	0f 85 81 00 00 00    	jne    801043d8 <acquire+0x98>
	asm volatile("lock; xchgl %0, %1" : "+m"(*addr), "=a"(result) : "1"(newval) : "cc");
80104357:	ba 01 00 00 00       	mov    $0x1,%edx
8010435c:	eb 05                	jmp    80104363 <acquire+0x23>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104363:	89 d0                	mov    %edx,%eax
80104365:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
80104368:	85 c0                	test   %eax,%eax
8010436a:	75 f4                	jne    80104360 <acquire+0x20>
	__sync_synchronize();
8010436c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
	lk->cpu = mycpu();
80104371:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104374:	e8 f7 f3 ff ff       	call   80103770 <mycpu>
	for (i = 0; i < 10; i++) {
80104379:	31 d2                	xor    %edx,%edx
	getcallerpcs(&lk, lk->pcs);
8010437b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
	lk->cpu = mycpu();
8010437e:	89 43 08             	mov    %eax,0x8(%ebx)
	ebp = (uint *)v - 2;
80104381:	89 e8                	mov    %ebp,%eax
80104383:	90                   	nop
80104384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff) break;
80104388:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010438e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104394:	77 1a                	ja     801043b0 <acquire+0x70>
		pcs[i] = ebp[1];         // saved %eip
80104396:	8b 58 04             	mov    0x4(%eax),%ebx
80104399:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
	for (i = 0; i < 10; i++) {
8010439c:	83 c2 01             	add    $0x1,%edx
		ebp    = (uint *)ebp[0]; // saved %ebp
8010439f:	8b 00                	mov    (%eax),%eax
	for (i = 0; i < 10; i++) {
801043a1:	83 fa 0a             	cmp    $0xa,%edx
801043a4:	75 e2                	jne    80104388 <acquire+0x48>
}
801043a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a9:	5b                   	pop    %ebx
801043aa:	5e                   	pop    %esi
801043ab:	5d                   	pop    %ebp
801043ac:	c3                   	ret    
801043ad:	8d 76 00             	lea    0x0(%esi),%esi
801043b0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043b3:	83 c1 28             	add    $0x28,%ecx
801043b6:	8d 76 00             	lea    0x0(%esi),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	for (; i < 10; i++) pcs[i] = 0;
801043c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043c6:	83 c0 04             	add    $0x4,%eax
801043c9:	39 c8                	cmp    %ecx,%eax
801043cb:	75 f3                	jne    801043c0 <acquire+0x80>
}
801043cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d0:	5b                   	pop    %ebx
801043d1:	5e                   	pop    %esi
801043d2:	5d                   	pop    %ebp
801043d3:	c3                   	ret    
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return lock->locked && lock->cpu == mycpu();
801043d8:	8b 73 08             	mov    0x8(%ebx),%esi
801043db:	e8 90 f3 ff ff       	call   80103770 <mycpu>
801043e0:	39 c6                	cmp    %eax,%esi
801043e2:	0f 85 6f ff ff ff    	jne    80104357 <acquire+0x17>
	if (holding(lk)) panic("acquire");
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	68 23 76 10 80       	push   $0x80107623
801043f0:	e8 9b bf ff ff       	call   80100390 <panic>
801043f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104400 <popcli>:

void
popcli(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	83 ec 08             	sub    $0x8,%esp
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80104406:	9c                   	pushf  
80104407:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("popcli - interruptible");
80104408:	f6 c4 02             	test   $0x2,%ah
8010440b:	75 35                	jne    80104442 <popcli+0x42>
	if (--mycpu()->ncli < 0) panic("popcli");
8010440d:	e8 5e f3 ff ff       	call   80103770 <mycpu>
80104412:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104419:	78 34                	js     8010444f <popcli+0x4f>
	if (mycpu()->ncli == 0 && mycpu()->intena) sti();
8010441b:	e8 50 f3 ff ff       	call   80103770 <mycpu>
80104420:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104426:	85 d2                	test   %edx,%edx
80104428:	74 06                	je     80104430 <popcli+0x30>
}
8010442a:	c9                   	leave  
8010442b:	c3                   	ret    
8010442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (mycpu()->ncli == 0 && mycpu()->intena) sti();
80104430:	e8 3b f3 ff ff       	call   80103770 <mycpu>
80104435:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010443b:	85 c0                	test   %eax,%eax
8010443d:	74 eb                	je     8010442a <popcli+0x2a>
	asm volatile("sti");
8010443f:	fb                   	sti    
}
80104440:	c9                   	leave  
80104441:	c3                   	ret    
	if (readeflags() & FL_IF) panic("popcli - interruptible");
80104442:	83 ec 0c             	sub    $0xc,%esp
80104445:	68 2b 76 10 80       	push   $0x8010762b
8010444a:	e8 41 bf ff ff       	call   80100390 <panic>
	if (--mycpu()->ncli < 0) panic("popcli");
8010444f:	83 ec 0c             	sub    $0xc,%esp
80104452:	68 42 76 10 80       	push   $0x80107642
80104457:	e8 34 bf ff ff       	call   80100390 <panic>
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104460 <release>:
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == mycpu();
80104468:	8b 03                	mov    (%ebx),%eax
8010446a:	85 c0                	test   %eax,%eax
8010446c:	74 0c                	je     8010447a <release+0x1a>
8010446e:	8b 73 08             	mov    0x8(%ebx),%esi
80104471:	e8 fa f2 ff ff       	call   80103770 <mycpu>
80104476:	39 c6                	cmp    %eax,%esi
80104478:	74 16                	je     80104490 <release+0x30>
	if (!holding(lk)) panic("release");
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	68 49 76 10 80       	push   $0x80107649
80104482:	e8 09 bf ff ff       	call   80100390 <panic>
80104487:	89 f6                	mov    %esi,%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	lk->pcs[0] = 0;
80104490:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	lk->cpu    = 0;
80104497:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	__sync_synchronize();
8010449e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
	asm volatile("movl $0, %0" : "+m"(lk->locked) :);
801044a3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801044a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044ac:	5b                   	pop    %ebx
801044ad:	5e                   	pop    %esi
801044ae:	5d                   	pop    %ebp
	popcli();
801044af:	e9 4c ff ff ff       	jmp    80104400 <popcli>
801044b4:	66 90                	xchg   %ax,%ax
801044b6:	66 90                	xchg   %ax,%ax
801044b8:	66 90                	xchg   %ax,%ax
801044ba:	66 90                	xchg   %ax,%ax
801044bc:	66 90                	xchg   %ax,%ax
801044be:	66 90                	xchg   %ax,%ax

801044c0 <memset>:
#include "types.h"
#include "x86.h"

void *
memset(void *dst, int c, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	53                   	push   %ebx
801044c5:	8b 55 08             	mov    0x8(%ebp),%edx
801044c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	if ((int)dst % 4 == 0 && n % 4 == 0) {
801044cb:	f6 c2 03             	test   $0x3,%dl
801044ce:	75 05                	jne    801044d5 <memset+0x15>
801044d0:	f6 c1 03             	test   $0x3,%cl
801044d3:	74 13                	je     801044e8 <memset+0x28>
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
801044d5:	89 d7                	mov    %edx,%edi
801044d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044da:	fc                   	cld    
801044db:	f3 aa                	rep stos %al,%es:(%edi)
		c &= 0xFF;
		stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
	} else
		stosb(dst, c, n);
	return dst;
}
801044dd:	5b                   	pop    %ebx
801044de:	89 d0                	mov    %edx,%eax
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c &= 0xFF;
801044e8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
		stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
801044ec:	c1 e9 02             	shr    $0x2,%ecx
801044ef:	89 f8                	mov    %edi,%eax
801044f1:	89 fb                	mov    %edi,%ebx
801044f3:	c1 e0 18             	shl    $0x18,%eax
801044f6:	c1 e3 10             	shl    $0x10,%ebx
801044f9:	09 d8                	or     %ebx,%eax
801044fb:	09 f8                	or     %edi,%eax
801044fd:	c1 e7 08             	shl    $0x8,%edi
80104500:	09 f8                	or     %edi,%eax
	asm volatile("cld; rep stosl" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
80104502:	89 d7                	mov    %edx,%edi
80104504:	fc                   	cld    
80104505:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104507:	5b                   	pop    %ebx
80104508:	89 d0                	mov    %edx,%eax
8010450a:	5f                   	pop    %edi
8010450b:	5d                   	pop    %ebp
8010450c:	c3                   	ret    
8010450d:	8d 76 00             	lea    0x0(%esi),%esi

80104510 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	53                   	push   %ebx
80104516:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104519:	8b 75 08             	mov    0x8(%ebp),%esi
8010451c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
8010451f:	85 db                	test   %ebx,%ebx
80104521:	74 29                	je     8010454c <memcmp+0x3c>
		if (*s1 != *s2) return *s1 - *s2;
80104523:	0f b6 16             	movzbl (%esi),%edx
80104526:	0f b6 0f             	movzbl (%edi),%ecx
80104529:	38 d1                	cmp    %dl,%cl
8010452b:	75 2b                	jne    80104558 <memcmp+0x48>
8010452d:	b8 01 00 00 00       	mov    $0x1,%eax
80104532:	eb 14                	jmp    80104548 <memcmp+0x38>
80104534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104538:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010453c:	83 c0 01             	add    $0x1,%eax
8010453f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104544:	38 ca                	cmp    %cl,%dl
80104546:	75 10                	jne    80104558 <memcmp+0x48>
	while (n-- > 0) {
80104548:	39 d8                	cmp    %ebx,%eax
8010454a:	75 ec                	jne    80104538 <memcmp+0x28>
		s1++, s2++;
	}

	return 0;
}
8010454c:	5b                   	pop    %ebx
	return 0;
8010454d:	31 c0                	xor    %eax,%eax
}
8010454f:	5e                   	pop    %esi
80104550:	5f                   	pop    %edi
80104551:	5d                   	pop    %ebp
80104552:	c3                   	ret    
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (*s1 != *s2) return *s1 - *s2;
80104558:	0f b6 c2             	movzbl %dl,%eax
}
8010455b:	5b                   	pop    %ebx
		if (*s1 != *s2) return *s1 - *s2;
8010455c:	29 c8                	sub    %ecx,%eax
}
8010455e:	5e                   	pop    %esi
8010455f:	5f                   	pop    %edi
80104560:	5d                   	pop    %ebp
80104561:	c3                   	ret    
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 45 08             	mov    0x8(%ebp),%eax
80104578:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010457b:	8b 75 10             	mov    0x10(%ebp),%esi
	const char *s;
	char *      d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
8010457e:	39 c3                	cmp    %eax,%ebx
80104580:	73 26                	jae    801045a8 <memmove+0x38>
80104582:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104585:	39 c8                	cmp    %ecx,%eax
80104587:	73 1f                	jae    801045a8 <memmove+0x38>
		s += n;
		d += n;
		while (n-- > 0) *--d = *--s;
80104589:	85 f6                	test   %esi,%esi
8010458b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010458e:	74 0f                	je     8010459f <memmove+0x2f>
80104590:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104594:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104597:	83 ea 01             	sub    $0x1,%edx
8010459a:	83 fa ff             	cmp    $0xffffffff,%edx
8010459d:	75 f1                	jne    80104590 <memmove+0x20>
	} else
		while (n-- > 0) *d++ = *s++;

	return dst;
}
8010459f:	5b                   	pop    %ebx
801045a0:	5e                   	pop    %esi
801045a1:	5d                   	pop    %ebp
801045a2:	c3                   	ret    
801045a3:	90                   	nop
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		while (n-- > 0) *d++ = *s++;
801045a8:	31 d2                	xor    %edx,%edx
801045aa:	85 f6                	test   %esi,%esi
801045ac:	74 f1                	je     8010459f <memmove+0x2f>
801045ae:	66 90                	xchg   %ax,%ax
801045b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045b7:	83 c2 01             	add    $0x1,%edx
801045ba:	39 d6                	cmp    %edx,%esi
801045bc:	75 f2                	jne    801045b0 <memmove+0x40>
}
801045be:	5b                   	pop    %ebx
801045bf:	5e                   	pop    %esi
801045c0:	5d                   	pop    %ebp
801045c1:	c3                   	ret    
801045c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
}
801045d3:	5d                   	pop    %ebp
	return memmove(dst, src, n);
801045d4:	eb 9a                	jmp    80104570 <memmove>
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	8b 7d 10             	mov    0x10(%ebp),%edi
801045e8:	53                   	push   %ebx
801045e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801045ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	while (n > 0 && *p && *p == *q) n--, p++, q++;
801045ef:	85 ff                	test   %edi,%edi
801045f1:	74 2f                	je     80104622 <strncmp+0x42>
801045f3:	0f b6 01             	movzbl (%ecx),%eax
801045f6:	0f b6 1e             	movzbl (%esi),%ebx
801045f9:	84 c0                	test   %al,%al
801045fb:	74 37                	je     80104634 <strncmp+0x54>
801045fd:	38 c3                	cmp    %al,%bl
801045ff:	75 33                	jne    80104634 <strncmp+0x54>
80104601:	01 f7                	add    %esi,%edi
80104603:	eb 13                	jmp    80104618 <strncmp+0x38>
80104605:	8d 76 00             	lea    0x0(%esi),%esi
80104608:	0f b6 01             	movzbl (%ecx),%eax
8010460b:	84 c0                	test   %al,%al
8010460d:	74 21                	je     80104630 <strncmp+0x50>
8010460f:	0f b6 1a             	movzbl (%edx),%ebx
80104612:	89 d6                	mov    %edx,%esi
80104614:	38 d8                	cmp    %bl,%al
80104616:	75 1c                	jne    80104634 <strncmp+0x54>
80104618:	8d 56 01             	lea    0x1(%esi),%edx
8010461b:	83 c1 01             	add    $0x1,%ecx
8010461e:	39 fa                	cmp    %edi,%edx
80104620:	75 e6                	jne    80104608 <strncmp+0x28>
	if (n == 0) return 0;
	return (uchar)*p - (uchar)*q;
}
80104622:	5b                   	pop    %ebx
	if (n == 0) return 0;
80104623:	31 c0                	xor    %eax,%eax
}
80104625:	5e                   	pop    %esi
80104626:	5f                   	pop    %edi
80104627:	5d                   	pop    %ebp
80104628:	c3                   	ret    
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104630:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
	return (uchar)*p - (uchar)*q;
80104634:	29 d8                	sub    %ebx,%eax
}
80104636:	5b                   	pop    %ebx
80104637:	5e                   	pop    %esi
80104638:	5f                   	pop    %edi
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    
8010463b:	90                   	nop
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 45 08             	mov    0x8(%ebp),%eax
80104648:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010464b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
8010464e:	89 c2                	mov    %eax,%edx
80104650:	eb 19                	jmp    8010466b <strncpy+0x2b>
80104652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104658:	83 c3 01             	add    $0x1,%ebx
8010465b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010465f:	83 c2 01             	add    $0x1,%edx
80104662:	84 c9                	test   %cl,%cl
80104664:	88 4a ff             	mov    %cl,-0x1(%edx)
80104667:	74 09                	je     80104672 <strncpy+0x32>
80104669:	89 f1                	mov    %esi,%ecx
8010466b:	85 c9                	test   %ecx,%ecx
8010466d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104670:	7f e6                	jg     80104658 <strncpy+0x18>
		;
	while (n-- > 0) *s++ = 0;
80104672:	31 c9                	xor    %ecx,%ecx
80104674:	85 f6                	test   %esi,%esi
80104676:	7e 17                	jle    8010468f <strncpy+0x4f>
80104678:	90                   	nop
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104680:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104684:	89 f3                	mov    %esi,%ebx
80104686:	83 c1 01             	add    $0x1,%ecx
80104689:	29 cb                	sub    %ecx,%ebx
8010468b:	85 db                	test   %ebx,%ebx
8010468d:	7f f1                	jg     80104680 <strncpy+0x40>
	return os;
}
8010468f:	5b                   	pop    %ebx
80104690:	5e                   	pop    %esi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046a8:	8b 45 08             	mov    0x8(%ebp),%eax
801046ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *os;

	os = s;
	if (n <= 0) return os;
801046ae:	85 c9                	test   %ecx,%ecx
801046b0:	7e 26                	jle    801046d8 <safestrcpy+0x38>
801046b2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046b6:	89 c1                	mov    %eax,%ecx
801046b8:	eb 17                	jmp    801046d1 <safestrcpy+0x31>
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while (--n > 0 && (*s++ = *t++) != 0)
801046c0:	83 c2 01             	add    $0x1,%edx
801046c3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801046c7:	83 c1 01             	add    $0x1,%ecx
801046ca:	84 db                	test   %bl,%bl
801046cc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801046cf:	74 04                	je     801046d5 <safestrcpy+0x35>
801046d1:	39 f2                	cmp    %esi,%edx
801046d3:	75 eb                	jne    801046c0 <safestrcpy+0x20>
		;
	*s = 0;
801046d5:	c6 01 00             	movb   $0x0,(%ecx)
	return os;
}
801046d8:	5b                   	pop    %ebx
801046d9:	5e                   	pop    %esi
801046da:	5d                   	pop    %ebp
801046db:	c3                   	ret    
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <strlen>:

int
strlen(const char *s)
{
801046e0:	55                   	push   %ebp
	int n;

	for (n = 0; s[n]; n++)
801046e1:	31 c0                	xor    %eax,%eax
{
801046e3:	89 e5                	mov    %esp,%ebp
801046e5:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; s[n]; n++)
801046e8:	80 3a 00             	cmpb   $0x0,(%edx)
801046eb:	74 0c                	je     801046f9 <strlen+0x19>
801046ed:	8d 76 00             	lea    0x0(%esi),%esi
801046f0:	83 c0 01             	add    $0x1,%eax
801046f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046f7:	75 f7                	jne    801046f0 <strlen+0x10>
		;
	return n;
}
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    

801046fb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046fb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046ff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104703:	55                   	push   %ebp
  pushl %ebx
80104704:	53                   	push   %ebx
  pushl %esi
80104705:	56                   	push   %esi
  pushl %edi
80104706:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104707:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104709:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010470b:	5f                   	pop    %edi
  popl %esi
8010470c:	5e                   	pop    %esi
  popl %ebx
8010470d:	5b                   	pop    %ebx
  popl %ebp
8010470e:	5d                   	pop    %ebp
  ret
8010470f:	c3                   	ret    

80104710 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
8010471a:	e8 f1 f0 ff ff       	call   80103810 <myproc>

	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
8010471f:	8b 00                	mov    (%eax),%eax
80104721:	39 d8                	cmp    %ebx,%eax
80104723:	76 1b                	jbe    80104740 <fetchint+0x30>
80104725:	8d 53 04             	lea    0x4(%ebx),%edx
80104728:	39 d0                	cmp    %edx,%eax
8010472a:	72 14                	jb     80104740 <fetchint+0x30>
	*ip = *(int *)(addr);
8010472c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010472f:	8b 13                	mov    (%ebx),%edx
80104731:	89 10                	mov    %edx,(%eax)
	return 0;
80104733:	31 c0                	xor    %eax,%eax
}
80104735:	83 c4 04             	add    $0x4,%esp
80104738:	5b                   	pop    %ebx
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104745:	eb ee                	jmp    80104735 <fetchint+0x25>
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104750 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *       s, *ep;
	struct proc *curproc = myproc();
8010475a:	e8 b1 f0 ff ff       	call   80103810 <myproc>

	if (addr >= curproc->sz) return -1;
8010475f:	39 18                	cmp    %ebx,(%eax)
80104761:	76 29                	jbe    8010478c <fetchstr+0x3c>
	*pp = (char *)addr;
80104763:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104766:	89 da                	mov    %ebx,%edx
80104768:	89 19                	mov    %ebx,(%ecx)
	ep  = (char *)curproc->sz;
8010476a:	8b 00                	mov    (%eax),%eax
	for (s = *pp; s < ep; s++) {
8010476c:	39 c3                	cmp    %eax,%ebx
8010476e:	73 1c                	jae    8010478c <fetchstr+0x3c>
		if (*s == 0) return s - *pp;
80104770:	80 3b 00             	cmpb   $0x0,(%ebx)
80104773:	75 10                	jne    80104785 <fetchstr+0x35>
80104775:	eb 39                	jmp    801047b0 <fetchstr+0x60>
80104777:	89 f6                	mov    %esi,%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104780:	80 3a 00             	cmpb   $0x0,(%edx)
80104783:	74 1b                	je     801047a0 <fetchstr+0x50>
	for (s = *pp; s < ep; s++) {
80104785:	83 c2 01             	add    $0x1,%edx
80104788:	39 d0                	cmp    %edx,%eax
8010478a:	77 f4                	ja     80104780 <fetchstr+0x30>
	if (addr >= curproc->sz) return -1;
8010478c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	return -1;
}
80104791:	83 c4 04             	add    $0x4,%esp
80104794:	5b                   	pop    %ebx
80104795:	5d                   	pop    %ebp
80104796:	c3                   	ret    
80104797:	89 f6                	mov    %esi,%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047a0:	83 c4 04             	add    $0x4,%esp
801047a3:	89 d0                	mov    %edx,%eax
801047a5:	29 d8                	sub    %ebx,%eax
801047a7:	5b                   	pop    %ebx
801047a8:	5d                   	pop    %ebp
801047a9:	c3                   	ret    
801047aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (*s == 0) return s - *pp;
801047b0:	31 c0                	xor    %eax,%eax
801047b2:	eb dd                	jmp    80104791 <fetchstr+0x41>
801047b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801047c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801047c5:	e8 46 f0 ff ff       	call   80103810 <myproc>
801047ca:	8b 40 18             	mov    0x18(%eax),%eax
801047cd:	8b 55 08             	mov    0x8(%ebp),%edx
801047d0:	8b 40 44             	mov    0x44(%eax),%eax
801047d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
	struct proc *curproc = myproc();
801047d6:	e8 35 f0 ff ff       	call   80103810 <myproc>
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
801047db:	8b 00                	mov    (%eax),%eax
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
801047dd:	8d 73 04             	lea    0x4(%ebx),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
801047e0:	39 c6                	cmp    %eax,%esi
801047e2:	73 1c                	jae    80104800 <argint+0x40>
801047e4:	8d 53 08             	lea    0x8(%ebx),%edx
801047e7:	39 d0                	cmp    %edx,%eax
801047e9:	72 15                	jb     80104800 <argint+0x40>
	*ip = *(int *)(addr);
801047eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ee:	8b 53 04             	mov    0x4(%ebx),%edx
801047f1:	89 10                	mov    %edx,(%eax)
	return 0;
801047f3:	31 c0                	xor    %eax,%eax
}
801047f5:	5b                   	pop    %ebx
801047f6:	5e                   	pop    %esi
801047f7:	5d                   	pop    %ebp
801047f8:	c3                   	ret    
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104800:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104805:	eb ee                	jmp    801047f5 <argint+0x35>
80104807:	89 f6                	mov    %esi,%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	83 ec 10             	sub    $0x10,%esp
80104818:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int          i;
	struct proc *curproc = myproc();
8010481b:	e8 f0 ef ff ff       	call   80103810 <myproc>
80104820:	89 c6                	mov    %eax,%esi

	if (argint(n, &i) < 0) return -1;
80104822:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104825:	83 ec 08             	sub    $0x8,%esp
80104828:	50                   	push   %eax
80104829:	ff 75 08             	pushl  0x8(%ebp)
8010482c:	e8 8f ff ff ff       	call   801047c0 <argint>
	if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) return -1;
80104831:	83 c4 10             	add    $0x10,%esp
80104834:	85 c0                	test   %eax,%eax
80104836:	78 28                	js     80104860 <argptr+0x50>
80104838:	85 db                	test   %ebx,%ebx
8010483a:	78 24                	js     80104860 <argptr+0x50>
8010483c:	8b 16                	mov    (%esi),%edx
8010483e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104841:	39 c2                	cmp    %eax,%edx
80104843:	76 1b                	jbe    80104860 <argptr+0x50>
80104845:	01 c3                	add    %eax,%ebx
80104847:	39 da                	cmp    %ebx,%edx
80104849:	72 15                	jb     80104860 <argptr+0x50>
	*pp = (char *)i;
8010484b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010484e:	89 02                	mov    %eax,(%edx)
	return 0;
80104850:	31 c0                	xor    %eax,%eax
}
80104852:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104855:	5b                   	pop    %ebx
80104856:	5e                   	pop    %esi
80104857:	5d                   	pop    %ebp
80104858:	c3                   	ret    
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) return -1;
80104860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104865:	eb eb                	jmp    80104852 <argptr+0x42>
80104867:	89 f6                	mov    %esi,%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	83 ec 20             	sub    $0x20,%esp
	int addr;
	if (argint(n, &addr) < 0) return -1;
80104876:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104879:	50                   	push   %eax
8010487a:	ff 75 08             	pushl  0x8(%ebp)
8010487d:	e8 3e ff ff ff       	call   801047c0 <argint>
80104882:	83 c4 10             	add    $0x10,%esp
80104885:	85 c0                	test   %eax,%eax
80104887:	78 17                	js     801048a0 <argstr+0x30>
	return fetchstr(addr, pp);
80104889:	83 ec 08             	sub    $0x8,%esp
8010488c:	ff 75 0c             	pushl  0xc(%ebp)
8010488f:	ff 75 f4             	pushl  -0xc(%ebp)
80104892:	e8 b9 fe ff ff       	call   80104750 <fetchstr>
80104897:	83 c4 10             	add    $0x10,%esp
}
8010489a:	c9                   	leave  
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (argint(n, &addr) < 0) return -1;
801048a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a5:	c9                   	leave  
801048a6:	c3                   	ret    
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <syscall>:
  [SYS_munlock] sys_munlock,
};

void
syscall(void)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 04             	sub    $0x4,%esp
	int          num;
	struct proc *curproc = myproc();
801048b7:	e8 54 ef ff ff       	call   80103810 <myproc>
801048bc:	89 c3                	mov    %eax,%ebx

	num = curproc->tf->eax;
801048be:	8b 40 18             	mov    0x18(%eax),%eax
801048c1:	8b 40 1c             	mov    0x1c(%eax),%eax
	if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801048c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801048c7:	83 fa 18             	cmp    $0x18,%edx
801048ca:	77 1c                	ja     801048e8 <syscall+0x38>
801048cc:	8b 14 85 80 76 10 80 	mov    -0x7fef8980(,%eax,4),%edx
801048d3:	85 d2                	test   %edx,%edx
801048d5:	74 11                	je     801048e8 <syscall+0x38>
		curproc->tf->eax = syscalls[num]();
801048d7:	ff d2                	call   *%edx
801048d9:	8b 53 18             	mov    0x18(%ebx),%edx
801048dc:	89 42 1c             	mov    %eax,0x1c(%edx)
	} else {
		cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name, num);
		curproc->tf->eax = -1;
	}
}
801048df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048e2:	c9                   	leave  
801048e3:	c3                   	ret    
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name, num);
801048e8:	50                   	push   %eax
801048e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801048ec:	50                   	push   %eax
801048ed:	ff 73 10             	pushl  0x10(%ebx)
801048f0:	68 51 76 10 80       	push   $0x80107651
801048f5:	e8 66 bd ff ff       	call   80100660 <cprintf>
		curproc->tf->eax = -1;
801048fa:	8b 43 18             	mov    0x18(%ebx),%eax
801048fd:	83 c4 10             	add    $0x10,%esp
80104900:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104907:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010490a:	c9                   	leave  
8010490b:	c3                   	ret    
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <create>:
	return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	56                   	push   %esi
80104915:	53                   	push   %ebx
	uint          off;
	struct inode *ip, *dp;
	char          name[DIRSIZ];

	if ((dp = nameiparent(path, name)) == 0) return 0;
80104916:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104919:	83 ec 44             	sub    $0x44,%esp
8010491c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010491f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if ((dp = nameiparent(path, name)) == 0) return 0;
80104922:	56                   	push   %esi
80104923:	50                   	push   %eax
{
80104924:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104927:	89 4d bc             	mov    %ecx,-0x44(%ebp)
	if ((dp = nameiparent(path, name)) == 0) return 0;
8010492a:	e8 e1 d5 ff ff       	call   80101f10 <nameiparent>
8010492f:	83 c4 10             	add    $0x10,%esp
80104932:	85 c0                	test   %eax,%eax
80104934:	0f 84 46 01 00 00    	je     80104a80 <create+0x170>
	ilock(dp);
8010493a:	83 ec 0c             	sub    $0xc,%esp
8010493d:	89 c3                	mov    %eax,%ebx
8010493f:	50                   	push   %eax
80104940:	e8 4b cd ff ff       	call   80101690 <ilock>

	if ((ip = dirlookup(dp, name, &off)) != 0) {
80104945:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104948:	83 c4 0c             	add    $0xc,%esp
8010494b:	50                   	push   %eax
8010494c:	56                   	push   %esi
8010494d:	53                   	push   %ebx
8010494e:	e8 6d d2 ff ff       	call   80101bc0 <dirlookup>
80104953:	83 c4 10             	add    $0x10,%esp
80104956:	85 c0                	test   %eax,%eax
80104958:	89 c7                	mov    %eax,%edi
8010495a:	74 34                	je     80104990 <create+0x80>
		iunlockput(dp);
8010495c:	83 ec 0c             	sub    $0xc,%esp
8010495f:	53                   	push   %ebx
80104960:	e8 bb cf ff ff       	call   80101920 <iunlockput>
		ilock(ip);
80104965:	89 3c 24             	mov    %edi,(%esp)
80104968:	e8 23 cd ff ff       	call   80101690 <ilock>
		if (type == T_FILE && ip->type == T_FILE) return ip;
8010496d:	83 c4 10             	add    $0x10,%esp
80104970:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104975:	0f 85 95 00 00 00    	jne    80104a10 <create+0x100>
8010497b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104980:	0f 85 8a 00 00 00    	jne    80104a10 <create+0x100>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
80104986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104989:	89 f8                	mov    %edi,%eax
8010498b:	5b                   	pop    %ebx
8010498c:	5e                   	pop    %esi
8010498d:	5f                   	pop    %edi
8010498e:	5d                   	pop    %ebp
8010498f:	c3                   	ret    
	if ((ip = ialloc(dp->dev, type)) == 0) panic("create: ialloc");
80104990:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104994:	83 ec 08             	sub    $0x8,%esp
80104997:	50                   	push   %eax
80104998:	ff 33                	pushl  (%ebx)
8010499a:	e8 81 cb ff ff       	call   80101520 <ialloc>
8010499f:	83 c4 10             	add    $0x10,%esp
801049a2:	85 c0                	test   %eax,%eax
801049a4:	89 c7                	mov    %eax,%edi
801049a6:	0f 84 e8 00 00 00    	je     80104a94 <create+0x184>
	ilock(ip);
801049ac:	83 ec 0c             	sub    $0xc,%esp
801049af:	50                   	push   %eax
801049b0:	e8 db cc ff ff       	call   80101690 <ilock>
	ip->major = major;
801049b5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049b9:	66 89 47 52          	mov    %ax,0x52(%edi)
	ip->minor = minor;
801049bd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049c1:	66 89 47 54          	mov    %ax,0x54(%edi)
	ip->nlink = 1;
801049c5:	b8 01 00 00 00       	mov    $0x1,%eax
801049ca:	66 89 47 56          	mov    %ax,0x56(%edi)
	iupdate(ip);
801049ce:	89 3c 24             	mov    %edi,(%esp)
801049d1:	e8 0a cc ff ff       	call   801015e0 <iupdate>
	if (type == T_DIR) { // Create . and .. entries.
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049de:	74 50                	je     80104a30 <create+0x120>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");
801049e0:	83 ec 04             	sub    $0x4,%esp
801049e3:	ff 77 04             	pushl  0x4(%edi)
801049e6:	56                   	push   %esi
801049e7:	53                   	push   %ebx
801049e8:	e8 43 d4 ff ff       	call   80101e30 <dirlink>
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	85 c0                	test   %eax,%eax
801049f2:	0f 88 8f 00 00 00    	js     80104a87 <create+0x177>
	iunlockput(dp);
801049f8:	83 ec 0c             	sub    $0xc,%esp
801049fb:	53                   	push   %ebx
801049fc:	e8 1f cf ff ff       	call   80101920 <iunlockput>
	return ip;
80104a01:	83 c4 10             	add    $0x10,%esp
}
80104a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a07:	89 f8                	mov    %edi,%eax
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5f                   	pop    %edi
80104a0c:	5d                   	pop    %ebp
80104a0d:	c3                   	ret    
80104a0e:	66 90                	xchg   %ax,%ax
		iunlockput(ip);
80104a10:	83 ec 0c             	sub    $0xc,%esp
80104a13:	57                   	push   %edi
		return 0;
80104a14:	31 ff                	xor    %edi,%edi
		iunlockput(ip);
80104a16:	e8 05 cf ff ff       	call   80101920 <iunlockput>
		return 0;
80104a1b:	83 c4 10             	add    $0x10,%esp
}
80104a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a21:	89 f8                	mov    %edi,%eax
80104a23:	5b                   	pop    %ebx
80104a24:	5e                   	pop    %esi
80104a25:	5f                   	pop    %edi
80104a26:	5d                   	pop    %ebp
80104a27:	c3                   	ret    
80104a28:	90                   	nop
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		dp->nlink++; // for ".."
80104a30:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
		iupdate(dp);
80104a35:	83 ec 0c             	sub    $0xc,%esp
80104a38:	53                   	push   %ebx
80104a39:	e8 a2 cb ff ff       	call   801015e0 <iupdate>
		if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0) panic("create dots");
80104a3e:	83 c4 0c             	add    $0xc,%esp
80104a41:	ff 77 04             	pushl  0x4(%edi)
80104a44:	68 04 77 10 80       	push   $0x80107704
80104a49:	57                   	push   %edi
80104a4a:	e8 e1 d3 ff ff       	call   80101e30 <dirlink>
80104a4f:	83 c4 10             	add    $0x10,%esp
80104a52:	85 c0                	test   %eax,%eax
80104a54:	78 1c                	js     80104a72 <create+0x162>
80104a56:	83 ec 04             	sub    $0x4,%esp
80104a59:	ff 73 04             	pushl  0x4(%ebx)
80104a5c:	68 03 77 10 80       	push   $0x80107703
80104a61:	57                   	push   %edi
80104a62:	e8 c9 d3 ff ff       	call   80101e30 <dirlink>
80104a67:	83 c4 10             	add    $0x10,%esp
80104a6a:	85 c0                	test   %eax,%eax
80104a6c:	0f 89 6e ff ff ff    	jns    801049e0 <create+0xd0>
80104a72:	83 ec 0c             	sub    $0xc,%esp
80104a75:	68 f7 76 10 80       	push   $0x801076f7
80104a7a:	e8 11 b9 ff ff       	call   80100390 <panic>
80104a7f:	90                   	nop
	if ((dp = nameiparent(path, name)) == 0) return 0;
80104a80:	31 ff                	xor    %edi,%edi
80104a82:	e9 ff fe ff ff       	jmp    80104986 <create+0x76>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");
80104a87:	83 ec 0c             	sub    $0xc,%esp
80104a8a:	68 06 77 10 80       	push   $0x80107706
80104a8f:	e8 fc b8 ff ff       	call   80100390 <panic>
	if ((ip = ialloc(dp->dev, type)) == 0) panic("create: ialloc");
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	68 e8 76 10 80       	push   $0x801076e8
80104a9c:	e8 ef b8 ff ff       	call   80100390 <panic>
80104aa1:	eb 0d                	jmp    80104ab0 <argfd.constprop.0>
80104aa3:	90                   	nop
80104aa4:	90                   	nop
80104aa5:	90                   	nop
80104aa6:	90                   	nop
80104aa7:	90                   	nop
80104aa8:	90                   	nop
80104aa9:	90                   	nop
80104aaa:	90                   	nop
80104aab:	90                   	nop
80104aac:	90                   	nop
80104aad:	90                   	nop
80104aae:	90                   	nop
80104aaf:	90                   	nop

80104ab0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	89 c3                	mov    %eax,%ebx
	if (argint(n, &fd) < 0) return -1;
80104ab7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104aba:	89 d6                	mov    %edx,%esi
80104abc:	83 ec 18             	sub    $0x18,%esp
	if (argint(n, &fd) < 0) return -1;
80104abf:	50                   	push   %eax
80104ac0:	6a 00                	push   $0x0
80104ac2:	e8 f9 fc ff ff       	call   801047c0 <argint>
80104ac7:	83 c4 10             	add    $0x10,%esp
80104aca:	85 c0                	test   %eax,%eax
80104acc:	78 2a                	js     80104af8 <argfd.constprop.0+0x48>
	if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
80104ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ad2:	77 24                	ja     80104af8 <argfd.constprop.0+0x48>
80104ad4:	e8 37 ed ff ff       	call   80103810 <myproc>
80104ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104adc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	74 14                	je     80104af8 <argfd.constprop.0+0x48>
	if (pfd) *pfd = fd;
80104ae4:	85 db                	test   %ebx,%ebx
80104ae6:	74 02                	je     80104aea <argfd.constprop.0+0x3a>
80104ae8:	89 13                	mov    %edx,(%ebx)
	if (pf) *pf = f;
80104aea:	89 06                	mov    %eax,(%esi)
	return 0;
80104aec:	31 c0                	xor    %eax,%eax
}
80104aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af1:	5b                   	pop    %ebx
80104af2:	5e                   	pop    %esi
80104af3:	5d                   	pop    %ebp
80104af4:	c3                   	ret    
80104af5:	8d 76 00             	lea    0x0(%esi),%esi
	if (argint(n, &fd) < 0) return -1;
80104af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104afd:	eb ef                	jmp    80104aee <argfd.constprop.0+0x3e>
80104aff:	90                   	nop

80104b00 <sys_dup>:
{
80104b00:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0) return -1;
80104b01:	31 c0                	xor    %eax,%eax
{
80104b03:	89 e5                	mov    %esp,%ebp
80104b05:	56                   	push   %esi
80104b06:	53                   	push   %ebx
	if (argfd(0, 0, &f) < 0) return -1;
80104b07:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104b0a:	83 ec 10             	sub    $0x10,%esp
	if (argfd(0, 0, &f) < 0) return -1;
80104b0d:	e8 9e ff ff ff       	call   80104ab0 <argfd.constprop.0>
80104b12:	85 c0                	test   %eax,%eax
80104b14:	78 42                	js     80104b58 <sys_dup+0x58>
	if ((fd = fdalloc(f)) < 0) return -1;
80104b16:	8b 75 f4             	mov    -0xc(%ebp),%esi
	for (fd = 0; fd < NOFILE; fd++) {
80104b19:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
80104b1b:	e8 f0 ec ff ff       	call   80103810 <myproc>
80104b20:	eb 0e                	jmp    80104b30 <sys_dup+0x30>
80104b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (fd = 0; fd < NOFILE; fd++) {
80104b28:	83 c3 01             	add    $0x1,%ebx
80104b2b:	83 fb 10             	cmp    $0x10,%ebx
80104b2e:	74 28                	je     80104b58 <sys_dup+0x58>
		if (curproc->ofile[fd] == 0) {
80104b30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b34:	85 d2                	test   %edx,%edx
80104b36:	75 f0                	jne    80104b28 <sys_dup+0x28>
			curproc->ofile[fd] = f;
80104b38:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
	filedup(f);
80104b3c:	83 ec 0c             	sub    $0xc,%esp
80104b3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b42:	e8 a9 c2 ff ff       	call   80100df0 <filedup>
	return fd;
80104b47:	83 c4 10             	add    $0x10,%esp
}
80104b4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b4d:	89 d8                	mov    %ebx,%eax
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	90                   	nop
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b58:	8d 65 f8             	lea    -0x8(%ebp),%esp
	if (argfd(0, 0, &f) < 0) return -1;
80104b5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104b60:	89 d8                	mov    %ebx,%eax
80104b62:	5b                   	pop    %ebx
80104b63:	5e                   	pop    %esi
80104b64:	5d                   	pop    %ebp
80104b65:	c3                   	ret    
80104b66:	8d 76 00             	lea    0x0(%esi),%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <sys_read>:
{
80104b70:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80104b71:	31 c0                	xor    %eax,%eax
{
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80104b78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b7b:	e8 30 ff ff ff       	call   80104ab0 <argfd.constprop.0>
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 4c                	js     80104bd0 <sys_read+0x60>
80104b84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b87:	83 ec 08             	sub    $0x8,%esp
80104b8a:	50                   	push   %eax
80104b8b:	6a 02                	push   $0x2
80104b8d:	e8 2e fc ff ff       	call   801047c0 <argint>
80104b92:	83 c4 10             	add    $0x10,%esp
80104b95:	85 c0                	test   %eax,%eax
80104b97:	78 37                	js     80104bd0 <sys_read+0x60>
80104b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b9c:	83 ec 04             	sub    $0x4,%esp
80104b9f:	ff 75 f0             	pushl  -0x10(%ebp)
80104ba2:	50                   	push   %eax
80104ba3:	6a 01                	push   $0x1
80104ba5:	e8 66 fc ff ff       	call   80104810 <argptr>
80104baa:	83 c4 10             	add    $0x10,%esp
80104bad:	85 c0                	test   %eax,%eax
80104baf:	78 1f                	js     80104bd0 <sys_read+0x60>
	return fileread(f, p, n);
80104bb1:	83 ec 04             	sub    $0x4,%esp
80104bb4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bba:	ff 75 ec             	pushl  -0x14(%ebp)
80104bbd:	e8 9e c3 ff ff       	call   80100f60 <fileread>
80104bc2:	83 c4 10             	add    $0x10,%esp
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_write>:
{
80104be0:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80104be1:	31 c0                	xor    %eax,%eax
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80104be8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104beb:	e8 c0 fe ff ff       	call   80104ab0 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 4c                	js     80104c40 <sys_write+0x60>
80104bf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bf7:	83 ec 08             	sub    $0x8,%esp
80104bfa:	50                   	push   %eax
80104bfb:	6a 02                	push   $0x2
80104bfd:	e8 be fb ff ff       	call   801047c0 <argint>
80104c02:	83 c4 10             	add    $0x10,%esp
80104c05:	85 c0                	test   %eax,%eax
80104c07:	78 37                	js     80104c40 <sys_write+0x60>
80104c09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c0c:	83 ec 04             	sub    $0x4,%esp
80104c0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c12:	50                   	push   %eax
80104c13:	6a 01                	push   $0x1
80104c15:	e8 f6 fb ff ff       	call   80104810 <argptr>
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	85 c0                	test   %eax,%eax
80104c1f:	78 1f                	js     80104c40 <sys_write+0x60>
	return filewrite(f, p, n);
80104c21:	83 ec 04             	sub    $0x4,%esp
80104c24:	ff 75 f0             	pushl  -0x10(%ebp)
80104c27:	ff 75 f4             	pushl  -0xc(%ebp)
80104c2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c2d:	e8 be c3 ff ff       	call   80100ff0 <filewrite>
80104c32:	83 c4 10             	add    $0x10,%esp
}
80104c35:	c9                   	leave  
80104c36:	c3                   	ret    
80104c37:	89 f6                	mov    %esi,%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <sys_close>:
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, &fd, &f) < 0) return -1;
80104c56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c5c:	e8 4f fe ff ff       	call   80104ab0 <argfd.constprop.0>
80104c61:	85 c0                	test   %eax,%eax
80104c63:	78 2b                	js     80104c90 <sys_close+0x40>
	myproc()->ofile[fd] = 0;
80104c65:	e8 a6 eb ff ff       	call   80103810 <myproc>
80104c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
	fileclose(f);
80104c6d:	83 ec 0c             	sub    $0xc,%esp
	myproc()->ofile[fd] = 0;
80104c70:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c77:	00 
	fileclose(f);
80104c78:	ff 75 f4             	pushl  -0xc(%ebp)
80104c7b:	e8 c0 c1 ff ff       	call   80100e40 <fileclose>
	return 0;
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	31 c0                	xor    %eax,%eax
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, &fd, &f) < 0) return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c95:	c9                   	leave  
80104c96:	c3                   	ret    
80104c97:	89 f6                	mov    %esi,%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <sys_fstat>:
{
80104ca0:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80104ca1:	31 c0                	xor    %eax,%eax
{
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80104ca8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104cab:	e8 00 fe ff ff       	call   80104ab0 <argfd.constprop.0>
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	78 2c                	js     80104ce0 <sys_fstat+0x40>
80104cb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cb7:	83 ec 04             	sub    $0x4,%esp
80104cba:	6a 14                	push   $0x14
80104cbc:	50                   	push   %eax
80104cbd:	6a 01                	push   $0x1
80104cbf:	e8 4c fb ff ff       	call   80104810 <argptr>
80104cc4:	83 c4 10             	add    $0x10,%esp
80104cc7:	85 c0                	test   %eax,%eax
80104cc9:	78 15                	js     80104ce0 <sys_fstat+0x40>
	return filestat(f, st);
80104ccb:	83 ec 08             	sub    $0x8,%esp
80104cce:	ff 75 f4             	pushl  -0xc(%ebp)
80104cd1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cd4:	e8 37 c2 ff ff       	call   80100f10 <filestat>
80104cd9:	83 c4 10             	add    $0x10,%esp
}
80104cdc:	c9                   	leave  
80104cdd:	c3                   	ret    
80104cde:	66 90                	xchg   %ax,%ax
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_link>:
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
	if (argstr(0, &old) < 0 || argstr(1, &new) < 0) return -1;
80104cf6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104cf9:	83 ec 34             	sub    $0x34,%esp
	if (argstr(0, &old) < 0 || argstr(1, &new) < 0) return -1;
80104cfc:	50                   	push   %eax
80104cfd:	6a 00                	push   $0x0
80104cff:	e8 6c fb ff ff       	call   80104870 <argstr>
80104d04:	83 c4 10             	add    $0x10,%esp
80104d07:	85 c0                	test   %eax,%eax
80104d09:	0f 88 fb 00 00 00    	js     80104e0a <sys_link+0x11a>
80104d0f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d12:	83 ec 08             	sub    $0x8,%esp
80104d15:	50                   	push   %eax
80104d16:	6a 01                	push   $0x1
80104d18:	e8 53 fb ff ff       	call   80104870 <argstr>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	85 c0                	test   %eax,%eax
80104d22:	0f 88 e2 00 00 00    	js     80104e0a <sys_link+0x11a>
	begin_op();
80104d28:	e8 83 de ff ff       	call   80102bb0 <begin_op>
	if ((ip = namei(old)) == 0) {
80104d2d:	83 ec 0c             	sub    $0xc,%esp
80104d30:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d33:	e8 b8 d1 ff ff       	call   80101ef0 <namei>
80104d38:	83 c4 10             	add    $0x10,%esp
80104d3b:	85 c0                	test   %eax,%eax
80104d3d:	89 c3                	mov    %eax,%ebx
80104d3f:	0f 84 ea 00 00 00    	je     80104e2f <sys_link+0x13f>
	ilock(ip);
80104d45:	83 ec 0c             	sub    $0xc,%esp
80104d48:	50                   	push   %eax
80104d49:	e8 42 c9 ff ff       	call   80101690 <ilock>
	if (ip->type == T_DIR) {
80104d4e:	83 c4 10             	add    $0x10,%esp
80104d51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d56:	0f 84 bb 00 00 00    	je     80104e17 <sys_link+0x127>
	ip->nlink++;
80104d5c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
	iupdate(ip);
80104d61:	83 ec 0c             	sub    $0xc,%esp
	if ((dp = nameiparent(new, name)) == 0) goto bad;
80104d64:	8d 7d da             	lea    -0x26(%ebp),%edi
	iupdate(ip);
80104d67:	53                   	push   %ebx
80104d68:	e8 73 c8 ff ff       	call   801015e0 <iupdate>
	iunlock(ip);
80104d6d:	89 1c 24             	mov    %ebx,(%esp)
80104d70:	e8 fb c9 ff ff       	call   80101770 <iunlock>
	if ((dp = nameiparent(new, name)) == 0) goto bad;
80104d75:	58                   	pop    %eax
80104d76:	5a                   	pop    %edx
80104d77:	57                   	push   %edi
80104d78:	ff 75 d0             	pushl  -0x30(%ebp)
80104d7b:	e8 90 d1 ff ff       	call   80101f10 <nameiparent>
80104d80:	83 c4 10             	add    $0x10,%esp
80104d83:	85 c0                	test   %eax,%eax
80104d85:	89 c6                	mov    %eax,%esi
80104d87:	74 5b                	je     80104de4 <sys_link+0xf4>
	ilock(dp);
80104d89:	83 ec 0c             	sub    $0xc,%esp
80104d8c:	50                   	push   %eax
80104d8d:	e8 fe c8 ff ff       	call   80101690 <ilock>
	if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
80104d92:	83 c4 10             	add    $0x10,%esp
80104d95:	8b 03                	mov    (%ebx),%eax
80104d97:	39 06                	cmp    %eax,(%esi)
80104d99:	75 3d                	jne    80104dd8 <sys_link+0xe8>
80104d9b:	83 ec 04             	sub    $0x4,%esp
80104d9e:	ff 73 04             	pushl  0x4(%ebx)
80104da1:	57                   	push   %edi
80104da2:	56                   	push   %esi
80104da3:	e8 88 d0 ff ff       	call   80101e30 <dirlink>
80104da8:	83 c4 10             	add    $0x10,%esp
80104dab:	85 c0                	test   %eax,%eax
80104dad:	78 29                	js     80104dd8 <sys_link+0xe8>
	iunlockput(dp);
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	56                   	push   %esi
80104db3:	e8 68 cb ff ff       	call   80101920 <iunlockput>
	iput(ip);
80104db8:	89 1c 24             	mov    %ebx,(%esp)
80104dbb:	e8 00 ca ff ff       	call   801017c0 <iput>
	end_op();
80104dc0:	e8 5b de ff ff       	call   80102c20 <end_op>
	return 0;
80104dc5:	83 c4 10             	add    $0x10,%esp
80104dc8:	31 c0                	xor    %eax,%eax
}
80104dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dcd:	5b                   	pop    %ebx
80104dce:	5e                   	pop    %esi
80104dcf:	5f                   	pop    %edi
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    
80104dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		iunlockput(dp);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	56                   	push   %esi
80104ddc:	e8 3f cb ff ff       	call   80101920 <iunlockput>
		goto bad;
80104de1:	83 c4 10             	add    $0x10,%esp
	ilock(ip);
80104de4:	83 ec 0c             	sub    $0xc,%esp
80104de7:	53                   	push   %ebx
80104de8:	e8 a3 c8 ff ff       	call   80101690 <ilock>
	ip->nlink--;
80104ded:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80104df2:	89 1c 24             	mov    %ebx,(%esp)
80104df5:	e8 e6 c7 ff ff       	call   801015e0 <iupdate>
	iunlockput(ip);
80104dfa:	89 1c 24             	mov    %ebx,(%esp)
80104dfd:	e8 1e cb ff ff       	call   80101920 <iunlockput>
	end_op();
80104e02:	e8 19 de ff ff       	call   80102c20 <end_op>
	return -1;
80104e07:	83 c4 10             	add    $0x10,%esp
}
80104e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
80104e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e12:	5b                   	pop    %ebx
80104e13:	5e                   	pop    %esi
80104e14:	5f                   	pop    %edi
80104e15:	5d                   	pop    %ebp
80104e16:	c3                   	ret    
		iunlockput(ip);
80104e17:	83 ec 0c             	sub    $0xc,%esp
80104e1a:	53                   	push   %ebx
80104e1b:	e8 00 cb ff ff       	call   80101920 <iunlockput>
		end_op();
80104e20:	e8 fb dd ff ff       	call   80102c20 <end_op>
		return -1;
80104e25:	83 c4 10             	add    $0x10,%esp
80104e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e2d:	eb 9b                	jmp    80104dca <sys_link+0xda>
		end_op();
80104e2f:	e8 ec dd ff ff       	call   80102c20 <end_op>
		return -1;
80104e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e39:	eb 8f                	jmp    80104dca <sys_link+0xda>
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <sys_unlink>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
	if (argstr(0, &path) < 0) return -1;
80104e46:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104e49:	83 ec 44             	sub    $0x44,%esp
	if (argstr(0, &path) < 0) return -1;
80104e4c:	50                   	push   %eax
80104e4d:	6a 00                	push   $0x0
80104e4f:	e8 1c fa ff ff       	call   80104870 <argstr>
80104e54:	83 c4 10             	add    $0x10,%esp
80104e57:	85 c0                	test   %eax,%eax
80104e59:	0f 88 77 01 00 00    	js     80104fd6 <sys_unlink+0x196>
	if ((dp = nameiparent(path, name)) == 0) {
80104e5f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
	begin_op();
80104e62:	e8 49 dd ff ff       	call   80102bb0 <begin_op>
	if ((dp = nameiparent(path, name)) == 0) {
80104e67:	83 ec 08             	sub    $0x8,%esp
80104e6a:	53                   	push   %ebx
80104e6b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e6e:	e8 9d d0 ff ff       	call   80101f10 <nameiparent>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	89 c6                	mov    %eax,%esi
80104e7a:	0f 84 60 01 00 00    	je     80104fe0 <sys_unlink+0x1a0>
	ilock(dp);
80104e80:	83 ec 0c             	sub    $0xc,%esp
80104e83:	50                   	push   %eax
80104e84:	e8 07 c8 ff ff       	call   80101690 <ilock>
	if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
80104e89:	58                   	pop    %eax
80104e8a:	5a                   	pop    %edx
80104e8b:	68 04 77 10 80       	push   $0x80107704
80104e90:	53                   	push   %ebx
80104e91:	e8 0a cd ff ff       	call   80101ba0 <namecmp>
80104e96:	83 c4 10             	add    $0x10,%esp
80104e99:	85 c0                	test   %eax,%eax
80104e9b:	0f 84 03 01 00 00    	je     80104fa4 <sys_unlink+0x164>
80104ea1:	83 ec 08             	sub    $0x8,%esp
80104ea4:	68 03 77 10 80       	push   $0x80107703
80104ea9:	53                   	push   %ebx
80104eaa:	e8 f1 cc ff ff       	call   80101ba0 <namecmp>
80104eaf:	83 c4 10             	add    $0x10,%esp
80104eb2:	85 c0                	test   %eax,%eax
80104eb4:	0f 84 ea 00 00 00    	je     80104fa4 <sys_unlink+0x164>
	if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
80104eba:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ebd:	83 ec 04             	sub    $0x4,%esp
80104ec0:	50                   	push   %eax
80104ec1:	53                   	push   %ebx
80104ec2:	56                   	push   %esi
80104ec3:	e8 f8 cc ff ff       	call   80101bc0 <dirlookup>
80104ec8:	83 c4 10             	add    $0x10,%esp
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	89 c3                	mov    %eax,%ebx
80104ecf:	0f 84 cf 00 00 00    	je     80104fa4 <sys_unlink+0x164>
	ilock(ip);
80104ed5:	83 ec 0c             	sub    $0xc,%esp
80104ed8:	50                   	push   %eax
80104ed9:	e8 b2 c7 ff ff       	call   80101690 <ilock>
	if (ip->nlink < 1) panic("unlink: nlink < 1");
80104ede:	83 c4 10             	add    $0x10,%esp
80104ee1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ee6:	0f 8e 10 01 00 00    	jle    80104ffc <sys_unlink+0x1bc>
	if (ip->type == T_DIR && !isdirempty(ip)) {
80104eec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ef1:	74 6d                	je     80104f60 <sys_unlink+0x120>
	memset(&de, 0, sizeof(de));
80104ef3:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104ef6:	83 ec 04             	sub    $0x4,%esp
80104ef9:	6a 10                	push   $0x10
80104efb:	6a 00                	push   $0x0
80104efd:	50                   	push   %eax
80104efe:	e8 bd f5 ff ff       	call   801044c0 <memset>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("unlink: writei");
80104f03:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f06:	6a 10                	push   $0x10
80104f08:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f0b:	50                   	push   %eax
80104f0c:	56                   	push   %esi
80104f0d:	e8 5e cb ff ff       	call   80101a70 <writei>
80104f12:	83 c4 20             	add    $0x20,%esp
80104f15:	83 f8 10             	cmp    $0x10,%eax
80104f18:	0f 85 eb 00 00 00    	jne    80105009 <sys_unlink+0x1c9>
	if (ip->type == T_DIR) {
80104f1e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f23:	0f 84 97 00 00 00    	je     80104fc0 <sys_unlink+0x180>
	iunlockput(dp);
80104f29:	83 ec 0c             	sub    $0xc,%esp
80104f2c:	56                   	push   %esi
80104f2d:	e8 ee c9 ff ff       	call   80101920 <iunlockput>
	ip->nlink--;
80104f32:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80104f37:	89 1c 24             	mov    %ebx,(%esp)
80104f3a:	e8 a1 c6 ff ff       	call   801015e0 <iupdate>
	iunlockput(ip);
80104f3f:	89 1c 24             	mov    %ebx,(%esp)
80104f42:	e8 d9 c9 ff ff       	call   80101920 <iunlockput>
	end_op();
80104f47:	e8 d4 dc ff ff       	call   80102c20 <end_op>
	return 0;
80104f4c:	83 c4 10             	add    $0x10,%esp
80104f4f:	31 c0                	xor    %eax,%eax
}
80104f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f54:	5b                   	pop    %ebx
80104f55:	5e                   	pop    %esi
80104f56:	5f                   	pop    %edi
80104f57:	5d                   	pop    %ebp
80104f58:	c3                   	ret    
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
80104f60:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f64:	76 8d                	jbe    80104ef3 <sys_unlink+0xb3>
80104f66:	bf 20 00 00 00       	mov    $0x20,%edi
80104f6b:	eb 0f                	jmp    80104f7c <sys_unlink+0x13c>
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
80104f70:	83 c7 10             	add    $0x10,%edi
80104f73:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f76:	0f 83 77 ff ff ff    	jae    80104ef3 <sys_unlink+0xb3>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("isdirempty: readi");
80104f7c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f7f:	6a 10                	push   $0x10
80104f81:	57                   	push   %edi
80104f82:	50                   	push   %eax
80104f83:	53                   	push   %ebx
80104f84:	e8 e7 c9 ff ff       	call   80101970 <readi>
80104f89:	83 c4 10             	add    $0x10,%esp
80104f8c:	83 f8 10             	cmp    $0x10,%eax
80104f8f:	75 5e                	jne    80104fef <sys_unlink+0x1af>
		if (de.inum != 0) return 0;
80104f91:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f96:	74 d8                	je     80104f70 <sys_unlink+0x130>
		iunlockput(ip);
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	53                   	push   %ebx
80104f9c:	e8 7f c9 ff ff       	call   80101920 <iunlockput>
		goto bad;
80104fa1:	83 c4 10             	add    $0x10,%esp
	iunlockput(dp);
80104fa4:	83 ec 0c             	sub    $0xc,%esp
80104fa7:	56                   	push   %esi
80104fa8:	e8 73 c9 ff ff       	call   80101920 <iunlockput>
	end_op();
80104fad:	e8 6e dc ff ff       	call   80102c20 <end_op>
	return -1;
80104fb2:	83 c4 10             	add    $0x10,%esp
80104fb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fba:	eb 95                	jmp    80104f51 <sys_unlink+0x111>
80104fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		dp->nlink--;
80104fc0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
		iupdate(dp);
80104fc5:	83 ec 0c             	sub    $0xc,%esp
80104fc8:	56                   	push   %esi
80104fc9:	e8 12 c6 ff ff       	call   801015e0 <iupdate>
80104fce:	83 c4 10             	add    $0x10,%esp
80104fd1:	e9 53 ff ff ff       	jmp    80104f29 <sys_unlink+0xe9>
	if (argstr(0, &path) < 0) return -1;
80104fd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdb:	e9 71 ff ff ff       	jmp    80104f51 <sys_unlink+0x111>
		end_op();
80104fe0:	e8 3b dc ff ff       	call   80102c20 <end_op>
		return -1;
80104fe5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fea:	e9 62 ff ff ff       	jmp    80104f51 <sys_unlink+0x111>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("isdirempty: readi");
80104fef:	83 ec 0c             	sub    $0xc,%esp
80104ff2:	68 28 77 10 80       	push   $0x80107728
80104ff7:	e8 94 b3 ff ff       	call   80100390 <panic>
	if (ip->nlink < 1) panic("unlink: nlink < 1");
80104ffc:	83 ec 0c             	sub    $0xc,%esp
80104fff:	68 16 77 10 80       	push   $0x80107716
80105004:	e8 87 b3 ff ff       	call   80100390 <panic>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("unlink: writei");
80105009:	83 ec 0c             	sub    $0xc,%esp
8010500c:	68 3a 77 10 80       	push   $0x8010773a
80105011:	e8 7a b3 ff ff       	call   80100390 <panic>
80105016:	8d 76 00             	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_open>:

int
sys_open(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
	char *        path;
	int           fd, omode;
	struct file * f;
	struct inode *ip;

	if (argstr(0, &path) < 0 || argint(1, &omode) < 0) return -1;
80105026:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105029:	83 ec 24             	sub    $0x24,%esp
	if (argstr(0, &path) < 0 || argint(1, &omode) < 0) return -1;
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 3c f8 ff ff       	call   80104870 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 1d 01 00 00    	js     8010515c <sys_open+0x13c>
8010503f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105042:	83 ec 08             	sub    $0x8,%esp
80105045:	50                   	push   %eax
80105046:	6a 01                	push   $0x1
80105048:	e8 73 f7 ff ff       	call   801047c0 <argint>
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	85 c0                	test   %eax,%eax
80105052:	0f 88 04 01 00 00    	js     8010515c <sys_open+0x13c>

	begin_op();
80105058:	e8 53 db ff ff       	call   80102bb0 <begin_op>

	if (omode & O_CREATE) {
8010505d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105061:	0f 85 a9 00 00 00    	jne    80105110 <sys_open+0xf0>
		if (ip == 0) {
			end_op();
			return -1;
		}
	} else {
		if ((ip = namei(path)) == 0) {
80105067:	83 ec 0c             	sub    $0xc,%esp
8010506a:	ff 75 e0             	pushl  -0x20(%ebp)
8010506d:	e8 7e ce ff ff       	call   80101ef0 <namei>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	89 c6                	mov    %eax,%esi
80105079:	0f 84 b2 00 00 00    	je     80105131 <sys_open+0x111>
			end_op();
			return -1;
		}
		ilock(ip);
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	50                   	push   %eax
80105083:	e8 08 c6 ff ff       	call   80101690 <ilock>
		if (ip->type == T_DIR && omode != O_RDONLY) {
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105090:	0f 84 aa 00 00 00    	je     80105140 <sys_open+0x120>
			end_op();
			return -1;
		}
	}

	if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
80105096:	e8 e5 bc ff ff       	call   80100d80 <filealloc>
8010509b:	85 c0                	test   %eax,%eax
8010509d:	89 c7                	mov    %eax,%edi
8010509f:	0f 84 a6 00 00 00    	je     8010514b <sys_open+0x12b>
	struct proc *curproc = myproc();
801050a5:	e8 66 e7 ff ff       	call   80103810 <myproc>
	for (fd = 0; fd < NOFILE; fd++) {
801050aa:	31 db                	xor    %ebx,%ebx
801050ac:	eb 0e                	jmp    801050bc <sys_open+0x9c>
801050ae:	66 90                	xchg   %ax,%ax
801050b0:	83 c3 01             	add    $0x1,%ebx
801050b3:	83 fb 10             	cmp    $0x10,%ebx
801050b6:	0f 84 ac 00 00 00    	je     80105168 <sys_open+0x148>
		if (curproc->ofile[fd] == 0) {
801050bc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050c0:	85 d2                	test   %edx,%edx
801050c2:	75 ec                	jne    801050b0 <sys_open+0x90>
		if (f) fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
801050c4:	83 ec 0c             	sub    $0xc,%esp
			curproc->ofile[fd] = f;
801050c7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
	iunlock(ip);
801050cb:	56                   	push   %esi
801050cc:	e8 9f c6 ff ff       	call   80101770 <iunlock>
	end_op();
801050d1:	e8 4a db ff ff       	call   80102c20 <end_op>

	f->type     = FD_INODE;
801050d6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
	f->ip       = ip;
	f->off      = 0;
	f->readable = !(omode & O_WRONLY);
801050dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050df:	83 c4 10             	add    $0x10,%esp
	f->ip       = ip;
801050e2:	89 77 10             	mov    %esi,0x10(%edi)
	f->off      = 0;
801050e5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
	f->readable = !(omode & O_WRONLY);
801050ec:	89 d0                	mov    %edx,%eax
801050ee:	f7 d0                	not    %eax
801050f0:	83 e0 01             	and    $0x1,%eax
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050f3:	83 e2 03             	and    $0x3,%edx
	f->readable = !(omode & O_WRONLY);
801050f6:	88 47 08             	mov    %al,0x8(%edi)
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050f9:	0f 95 47 09          	setne  0x9(%edi)
	return fd;
}
801050fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105100:	89 d8                	mov    %ebx,%eax
80105102:	5b                   	pop    %ebx
80105103:	5e                   	pop    %esi
80105104:	5f                   	pop    %edi
80105105:	5d                   	pop    %ebp
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		ip = create(path, T_FILE, 0, 0);
80105110:	83 ec 0c             	sub    $0xc,%esp
80105113:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105116:	31 c9                	xor    %ecx,%ecx
80105118:	6a 00                	push   $0x0
8010511a:	ba 02 00 00 00       	mov    $0x2,%edx
8010511f:	e8 ec f7 ff ff       	call   80104910 <create>
		if (ip == 0) {
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
		ip = create(path, T_FILE, 0, 0);
80105129:	89 c6                	mov    %eax,%esi
		if (ip == 0) {
8010512b:	0f 85 65 ff ff ff    	jne    80105096 <sys_open+0x76>
			end_op();
80105131:	e8 ea da ff ff       	call   80102c20 <end_op>
			return -1;
80105136:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010513b:	eb c0                	jmp    801050fd <sys_open+0xdd>
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
		if (ip->type == T_DIR && omode != O_RDONLY) {
80105140:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105143:	85 c9                	test   %ecx,%ecx
80105145:	0f 84 4b ff ff ff    	je     80105096 <sys_open+0x76>
		iunlockput(ip);
8010514b:	83 ec 0c             	sub    $0xc,%esp
8010514e:	56                   	push   %esi
8010514f:	e8 cc c7 ff ff       	call   80101920 <iunlockput>
		end_op();
80105154:	e8 c7 da ff ff       	call   80102c20 <end_op>
		return -1;
80105159:	83 c4 10             	add    $0x10,%esp
8010515c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105161:	eb 9a                	jmp    801050fd <sys_open+0xdd>
80105163:	90                   	nop
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (f) fileclose(f);
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	57                   	push   %edi
8010516c:	e8 cf bc ff ff       	call   80100e40 <fileclose>
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	eb d5                	jmp    8010514b <sys_open+0x12b>
80105176:	8d 76 00             	lea    0x0(%esi),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_mkdir>:

int
sys_mkdir(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 18             	sub    $0x18,%esp
	char *        path;
	struct inode *ip;

	begin_op();
80105186:	e8 25 da ff ff       	call   80102bb0 <begin_op>
	if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
8010518b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518e:	83 ec 08             	sub    $0x8,%esp
80105191:	50                   	push   %eax
80105192:	6a 00                	push   $0x0
80105194:	e8 d7 f6 ff ff       	call   80104870 <argstr>
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	85 c0                	test   %eax,%eax
8010519e:	78 30                	js     801051d0 <sys_mkdir+0x50>
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a6:	31 c9                	xor    %ecx,%ecx
801051a8:	6a 00                	push   $0x0
801051aa:	ba 01 00 00 00       	mov    $0x1,%edx
801051af:	e8 5c f7 ff ff       	call   80104910 <create>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	74 15                	je     801051d0 <sys_mkdir+0x50>
		end_op();
		return -1;
	}
	iunlockput(ip);
801051bb:	83 ec 0c             	sub    $0xc,%esp
801051be:	50                   	push   %eax
801051bf:	e8 5c c7 ff ff       	call   80101920 <iunlockput>
	end_op();
801051c4:	e8 57 da ff ff       	call   80102c20 <end_op>
	return 0;
801051c9:	83 c4 10             	add    $0x10,%esp
801051cc:	31 c0                	xor    %eax,%eax
}
801051ce:	c9                   	leave  
801051cf:	c3                   	ret    
		end_op();
801051d0:	e8 4b da ff ff       	call   80102c20 <end_op>
		return -1;
801051d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051da:	c9                   	leave  
801051db:	c3                   	ret    
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_mknod>:

int
sys_mknod(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 18             	sub    $0x18,%esp
	struct inode *ip;
	char *        path;
	int           major, minor;

	begin_op();
801051e6:	e8 c5 d9 ff ff       	call   80102bb0 <begin_op>
	if ((argstr(0, &path)) < 0 || argint(1, &major) < 0 || argint(2, &minor) < 0
801051eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051ee:	83 ec 08             	sub    $0x8,%esp
801051f1:	50                   	push   %eax
801051f2:	6a 00                	push   $0x0
801051f4:	e8 77 f6 ff ff       	call   80104870 <argstr>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	85 c0                	test   %eax,%eax
801051fe:	78 60                	js     80105260 <sys_mknod+0x80>
80105200:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	50                   	push   %eax
80105207:	6a 01                	push   $0x1
80105209:	e8 b2 f5 ff ff       	call   801047c0 <argint>
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	85 c0                	test   %eax,%eax
80105213:	78 4b                	js     80105260 <sys_mknod+0x80>
80105215:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105218:	83 ec 08             	sub    $0x8,%esp
8010521b:	50                   	push   %eax
8010521c:	6a 02                	push   $0x2
8010521e:	e8 9d f5 ff ff       	call   801047c0 <argint>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 36                	js     80105260 <sys_mknod+0x80>
	    || (ip = create(path, T_DEV, major, minor)) == 0) {
8010522a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010522e:	83 ec 0c             	sub    $0xc,%esp
80105231:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105235:	ba 03 00 00 00       	mov    $0x3,%edx
8010523a:	50                   	push   %eax
8010523b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010523e:	e8 cd f6 ff ff       	call   80104910 <create>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	74 16                	je     80105260 <sys_mknod+0x80>
		end_op();
		return -1;
	}
	iunlockput(ip);
8010524a:	83 ec 0c             	sub    $0xc,%esp
8010524d:	50                   	push   %eax
8010524e:	e8 cd c6 ff ff       	call   80101920 <iunlockput>
	end_op();
80105253:	e8 c8 d9 ff ff       	call   80102c20 <end_op>
	return 0;
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	31 c0                	xor    %eax,%eax
}
8010525d:	c9                   	leave  
8010525e:	c3                   	ret    
8010525f:	90                   	nop
		end_op();
80105260:	e8 bb d9 ff ff       	call   80102c20 <end_op>
		return -1;
80105265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_chdir>:

int
sys_chdir(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	83 ec 10             	sub    $0x10,%esp
	char *        path;
	struct inode *ip;
	struct proc * curproc = myproc();
80105278:	e8 93 e5 ff ff       	call   80103810 <myproc>
8010527d:	89 c6                	mov    %eax,%esi

	begin_op();
8010527f:	e8 2c d9 ff ff       	call   80102bb0 <begin_op>
	if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
80105284:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105287:	83 ec 08             	sub    $0x8,%esp
8010528a:	50                   	push   %eax
8010528b:	6a 00                	push   $0x0
8010528d:	e8 de f5 ff ff       	call   80104870 <argstr>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	78 77                	js     80105310 <sys_chdir+0xa0>
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	ff 75 f4             	pushl  -0xc(%ebp)
8010529f:	e8 4c cc ff ff       	call   80101ef0 <namei>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	89 c3                	mov    %eax,%ebx
801052ab:	74 63                	je     80105310 <sys_chdir+0xa0>
		end_op();
		return -1;
	}
	ilock(ip);
801052ad:	83 ec 0c             	sub    $0xc,%esp
801052b0:	50                   	push   %eax
801052b1:	e8 da c3 ff ff       	call   80101690 <ilock>
	if (ip->type != T_DIR) {
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052be:	75 30                	jne    801052f0 <sys_chdir+0x80>
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	53                   	push   %ebx
801052c4:	e8 a7 c4 ff ff       	call   80101770 <iunlock>
	iput(curproc->cwd);
801052c9:	58                   	pop    %eax
801052ca:	ff 76 68             	pushl  0x68(%esi)
801052cd:	e8 ee c4 ff ff       	call   801017c0 <iput>
	end_op();
801052d2:	e8 49 d9 ff ff       	call   80102c20 <end_op>
	curproc->cwd = ip;
801052d7:	89 5e 68             	mov    %ebx,0x68(%esi)
	return 0;
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	31 c0                	xor    %eax,%eax
}
801052df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e2:	5b                   	pop    %ebx
801052e3:	5e                   	pop    %esi
801052e4:	5d                   	pop    %ebp
801052e5:	c3                   	ret    
801052e6:	8d 76 00             	lea    0x0(%esi),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		iunlockput(ip);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	53                   	push   %ebx
801052f4:	e8 27 c6 ff ff       	call   80101920 <iunlockput>
		end_op();
801052f9:	e8 22 d9 ff ff       	call   80102c20 <end_op>
		return -1;
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105306:	eb d7                	jmp    801052df <sys_chdir+0x6f>
80105308:	90                   	nop
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		end_op();
80105310:	e8 0b d9 ff ff       	call   80102c20 <end_op>
		return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb c3                	jmp    801052df <sys_chdir+0x6f>
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_exec>:

int
sys_exec(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
	char *path, *argv[MAXARG];
	int   i;
	uint  uargv, uarg;

	if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0) {
80105326:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010532c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0) {
80105332:	50                   	push   %eax
80105333:	6a 00                	push   $0x0
80105335:	e8 36 f5 ff ff       	call   80104870 <argstr>
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	85 c0                	test   %eax,%eax
8010533f:	0f 88 87 00 00 00    	js     801053cc <sys_exec+0xac>
80105345:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010534b:	83 ec 08             	sub    $0x8,%esp
8010534e:	50                   	push   %eax
8010534f:	6a 01                	push   $0x1
80105351:	e8 6a f4 ff ff       	call   801047c0 <argint>
80105356:	83 c4 10             	add    $0x10,%esp
80105359:	85 c0                	test   %eax,%eax
8010535b:	78 6f                	js     801053cc <sys_exec+0xac>
		return -1;
	}
	memset(argv, 0, sizeof(argv));
8010535d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105363:	83 ec 04             	sub    $0x4,%esp
	for (i = 0;; i++) {
80105366:	31 db                	xor    %ebx,%ebx
	memset(argv, 0, sizeof(argv));
80105368:	68 80 00 00 00       	push   $0x80
8010536d:	6a 00                	push   $0x0
8010536f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105375:	50                   	push   %eax
80105376:	e8 45 f1 ff ff       	call   801044c0 <memset>
8010537b:	83 c4 10             	add    $0x10,%esp
8010537e:	eb 2c                	jmp    801053ac <sys_exec+0x8c>
		if (i >= NELEM(argv)) return -1;
		if (fetchint(uargv + 4 * i, (int *)&uarg) < 0) return -1;
		if (uarg == 0) {
80105380:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105386:	85 c0                	test   %eax,%eax
80105388:	74 56                	je     801053e0 <sys_exec+0xc0>
			argv[i] = 0;
			break;
		}
		if (fetchstr(uarg, &argv[i]) < 0) return -1;
8010538a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105390:	83 ec 08             	sub    $0x8,%esp
80105393:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105396:	52                   	push   %edx
80105397:	50                   	push   %eax
80105398:	e8 b3 f3 ff ff       	call   80104750 <fetchstr>
8010539d:	83 c4 10             	add    $0x10,%esp
801053a0:	85 c0                	test   %eax,%eax
801053a2:	78 28                	js     801053cc <sys_exec+0xac>
	for (i = 0;; i++) {
801053a4:	83 c3 01             	add    $0x1,%ebx
		if (i >= NELEM(argv)) return -1;
801053a7:	83 fb 20             	cmp    $0x20,%ebx
801053aa:	74 20                	je     801053cc <sys_exec+0xac>
		if (fetchint(uargv + 4 * i, (int *)&uarg) < 0) return -1;
801053ac:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053b2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801053b9:	83 ec 08             	sub    $0x8,%esp
801053bc:	57                   	push   %edi
801053bd:	01 f0                	add    %esi,%eax
801053bf:	50                   	push   %eax
801053c0:	e8 4b f3 ff ff       	call   80104710 <fetchint>
801053c5:	83 c4 10             	add    $0x10,%esp
801053c8:	85 c0                	test   %eax,%eax
801053ca:	79 b4                	jns    80105380 <sys_exec+0x60>
	}
	return exec(path, argv);
}
801053cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
801053cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d4:	5b                   	pop    %ebx
801053d5:	5e                   	pop    %esi
801053d6:	5f                   	pop    %edi
801053d7:	5d                   	pop    %ebp
801053d8:	c3                   	ret    
801053d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return exec(path, argv);
801053e0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053e6:	83 ec 08             	sub    $0x8,%esp
			argv[i] = 0;
801053e9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801053f0:	00 00 00 00 
	return exec(path, argv);
801053f4:	50                   	push   %eax
801053f5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801053fb:	e8 10 b6 ff ff       	call   80100a10 <exec>
80105400:	83 c4 10             	add    $0x10,%esp
}
80105403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105406:	5b                   	pop    %ebx
80105407:	5e                   	pop    %esi
80105408:	5f                   	pop    %edi
80105409:	5d                   	pop    %ebp
8010540a:	c3                   	ret    
8010540b:	90                   	nop
8010540c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_pipe>:

int
sys_pipe(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	57                   	push   %edi
80105414:	56                   	push   %esi
80105415:	53                   	push   %ebx
	int *        fd;
	struct file *rf, *wf;
	int          fd0, fd1;

	if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0) return -1;
80105416:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105419:	83 ec 20             	sub    $0x20,%esp
	if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0) return -1;
8010541c:	6a 08                	push   $0x8
8010541e:	50                   	push   %eax
8010541f:	6a 00                	push   $0x0
80105421:	e8 ea f3 ff ff       	call   80104810 <argptr>
80105426:	83 c4 10             	add    $0x10,%esp
80105429:	85 c0                	test   %eax,%eax
8010542b:	0f 88 ae 00 00 00    	js     801054df <sys_pipe+0xcf>
	if (pipealloc(&rf, &wf) < 0) return -1;
80105431:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	50                   	push   %eax
80105438:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010543b:	50                   	push   %eax
8010543c:	e8 0f de ff ff       	call   80103250 <pipealloc>
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	85 c0                	test   %eax,%eax
80105446:	0f 88 93 00 00 00    	js     801054df <sys_pipe+0xcf>
	fd0 = -1;
	if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
8010544c:	8b 7d e0             	mov    -0x20(%ebp),%edi
	for (fd = 0; fd < NOFILE; fd++) {
8010544f:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
80105451:	e8 ba e3 ff ff       	call   80103810 <myproc>
80105456:	eb 10                	jmp    80105468 <sys_pipe+0x58>
80105458:	90                   	nop
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (fd = 0; fd < NOFILE; fd++) {
80105460:	83 c3 01             	add    $0x1,%ebx
80105463:	83 fb 10             	cmp    $0x10,%ebx
80105466:	74 60                	je     801054c8 <sys_pipe+0xb8>
		if (curproc->ofile[fd] == 0) {
80105468:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010546c:	85 f6                	test   %esi,%esi
8010546e:	75 f0                	jne    80105460 <sys_pipe+0x50>
			curproc->ofile[fd] = f;
80105470:	8d 73 08             	lea    0x8(%ebx),%esi
80105473:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
	if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105477:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	struct proc *curproc = myproc();
8010547a:	e8 91 e3 ff ff       	call   80103810 <myproc>
	for (fd = 0; fd < NOFILE; fd++) {
8010547f:	31 d2                	xor    %edx,%edx
80105481:	eb 0d                	jmp    80105490 <sys_pipe+0x80>
80105483:	90                   	nop
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105488:	83 c2 01             	add    $0x1,%edx
8010548b:	83 fa 10             	cmp    $0x10,%edx
8010548e:	74 28                	je     801054b8 <sys_pipe+0xa8>
		if (curproc->ofile[fd] == 0) {
80105490:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105494:	85 c9                	test   %ecx,%ecx
80105496:	75 f0                	jne    80105488 <sys_pipe+0x78>
			curproc->ofile[fd] = f;
80105498:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
		if (fd0 >= 0) myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
8010549c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010549f:	89 18                	mov    %ebx,(%eax)
	fd[1] = fd1;
801054a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054a4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
801054a7:	31 c0                	xor    %eax,%eax
}
801054a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054ac:	5b                   	pop    %ebx
801054ad:	5e                   	pop    %esi
801054ae:	5f                   	pop    %edi
801054af:	5d                   	pop    %ebp
801054b0:	c3                   	ret    
801054b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (fd0 >= 0) myproc()->ofile[fd0] = 0;
801054b8:	e8 53 e3 ff ff       	call   80103810 <myproc>
801054bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801054c4:	00 
801054c5:	8d 76 00             	lea    0x0(%esi),%esi
		fileclose(rf);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	ff 75 e0             	pushl  -0x20(%ebp)
801054ce:	e8 6d b9 ff ff       	call   80100e40 <fileclose>
		fileclose(wf);
801054d3:	58                   	pop    %eax
801054d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801054d7:	e8 64 b9 ff ff       	call   80100e40 <fileclose>
		return -1;
801054dc:	83 c4 10             	add    $0x10,%esp
801054df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e4:	eb c3                	jmp    801054a9 <sys_pipe+0x99>
801054e6:	66 90                	xchg   %ax,%ax
801054e8:	66 90                	xchg   %ax,%ax
801054ea:	66 90                	xchg   %ax,%ax
801054ec:	66 90                	xchg   %ax,%ax
801054ee:	66 90                	xchg   %ax,%ax

801054f0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
	return fork();
}
801054f3:	5d                   	pop    %ebp
	return fork();
801054f4:	e9 d7 e4 ff ff       	jmp    801039d0 <fork>
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_exit>:

int
sys_exit(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 08             	sub    $0x8,%esp
	exit();
80105506:	e8 45 e7 ff ff       	call   80103c50 <exit>
	return 0; // not reached
}
8010550b:	31 c0                	xor    %eax,%eax
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    
8010550f:	90                   	nop

80105510 <sys_wait>:

int
sys_wait(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
	return wait();
}
80105513:	5d                   	pop    %ebp
	return wait();
80105514:	e9 77 e9 ff ff       	jmp    80103e90 <wait>
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_kill>:

int
sys_kill(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 20             	sub    $0x20,%esp
	int pid;

	if (argint(0, &pid) < 0) return -1;
80105526:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105529:	50                   	push   %eax
8010552a:	6a 00                	push   $0x0
8010552c:	e8 8f f2 ff ff       	call   801047c0 <argint>
80105531:	83 c4 10             	add    $0x10,%esp
80105534:	85 c0                	test   %eax,%eax
80105536:	78 18                	js     80105550 <sys_kill+0x30>
	return kill(pid);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	ff 75 f4             	pushl  -0xc(%ebp)
8010553e:	e8 ad ea ff ff       	call   80103ff0 <kill>
80105543:	83 c4 10             	add    $0x10,%esp
}
80105546:	c9                   	leave  
80105547:	c3                   	ret    
80105548:	90                   	nop
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (argint(0, &pid) < 0) return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_getpid>:

int
sys_getpid(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 08             	sub    $0x8,%esp
	return myproc()->pid;
80105566:	e8 a5 e2 ff ff       	call   80103810 <myproc>
8010556b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010556e:	c9                   	leave  
8010556f:	c3                   	ret    

80105570 <sys_sbrk>:

int
sys_sbrk(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	53                   	push   %ebx
	int addr;
	int n;

	if (argint(0, &n) < 0) return -1;
80105574:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105577:	83 ec 1c             	sub    $0x1c,%esp
	if (argint(0, &n) < 0) return -1;
8010557a:	50                   	push   %eax
8010557b:	6a 00                	push   $0x0
8010557d:	e8 3e f2 ff ff       	call   801047c0 <argint>
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 27                	js     801055b0 <sys_sbrk+0x40>
	addr = myproc()->sz;
80105589:	e8 82 e2 ff ff       	call   80103810 <myproc>
	if (growproc(n) < 0) return -1;
8010558e:	83 ec 0c             	sub    $0xc,%esp
	addr = myproc()->sz;
80105591:	8b 18                	mov    (%eax),%ebx
	if (growproc(n) < 0) return -1;
80105593:	ff 75 f4             	pushl  -0xc(%ebp)
80105596:	e8 b5 e3 ff ff       	call   80103950 <growproc>
8010559b:	83 c4 10             	add    $0x10,%esp
8010559e:	85 c0                	test   %eax,%eax
801055a0:	78 0e                	js     801055b0 <sys_sbrk+0x40>
	return addr;
}
801055a2:	89 d8                	mov    %ebx,%eax
801055a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055a7:	c9                   	leave  
801055a8:	c3                   	ret    
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (argint(0, &n) < 0) return -1;
801055b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055b5:	eb eb                	jmp    801055a2 <sys_sbrk+0x32>
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_sleep>:

int
sys_sleep(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
	int  n;
	uint ticks0;

	if (argint(0, &n) < 0) return -1;
801055c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055c7:	83 ec 1c             	sub    $0x1c,%esp
	if (argint(0, &n) < 0) return -1;
801055ca:	50                   	push   %eax
801055cb:	6a 00                	push   $0x0
801055cd:	e8 ee f1 ff ff       	call   801047c0 <argint>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	0f 88 8a 00 00 00    	js     80105667 <sys_sleep+0xa7>
	acquire(&tickslock);
801055dd:	83 ec 0c             	sub    $0xc,%esp
801055e0:	68 20 65 11 80       	push   $0x80116520
801055e5:	e8 56 ed ff ff       	call   80104340 <acquire>
	ticks0 = ticks;
	while (ticks - ticks0 < n) {
801055ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ed:	83 c4 10             	add    $0x10,%esp
	ticks0 = ticks;
801055f0:	8b 1d 60 6d 11 80    	mov    0x80116d60,%ebx
	while (ticks - ticks0 < n) {
801055f6:	85 d2                	test   %edx,%edx
801055f8:	75 27                	jne    80105621 <sys_sleep+0x61>
801055fa:	eb 54                	jmp    80105650 <sys_sleep+0x90>
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (myproc()->killed) {
			release(&tickslock);
			return -1;
		}
		sleep(&ticks, &tickslock);
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	68 20 65 11 80       	push   $0x80116520
80105608:	68 60 6d 11 80       	push   $0x80116d60
8010560d:	e8 be e7 ff ff       	call   80103dd0 <sleep>
	while (ticks - ticks0 < n) {
80105612:	a1 60 6d 11 80       	mov    0x80116d60,%eax
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	29 d8                	sub    %ebx,%eax
8010561c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010561f:	73 2f                	jae    80105650 <sys_sleep+0x90>
		if (myproc()->killed) {
80105621:	e8 ea e1 ff ff       	call   80103810 <myproc>
80105626:	8b 40 24             	mov    0x24(%eax),%eax
80105629:	85 c0                	test   %eax,%eax
8010562b:	74 d3                	je     80105600 <sys_sleep+0x40>
			release(&tickslock);
8010562d:	83 ec 0c             	sub    $0xc,%esp
80105630:	68 20 65 11 80       	push   $0x80116520
80105635:	e8 26 ee ff ff       	call   80104460 <release>
			return -1;
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	release(&tickslock);
	return 0;
}
80105642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105645:	c9                   	leave  
80105646:	c3                   	ret    
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	release(&tickslock);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	68 20 65 11 80       	push   $0x80116520
80105658:	e8 03 ee ff ff       	call   80104460 <release>
	return 0;
8010565d:	83 c4 10             	add    $0x10,%esp
80105660:	31 c0                	xor    %eax,%eax
}
80105662:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105665:	c9                   	leave  
80105666:	c3                   	ret    
	if (argint(0, &n) < 0) return -1;
80105667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566c:	eb f4                	jmp    80105662 <sys_sleep+0xa2>
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	53                   	push   %ebx
80105674:	83 ec 10             	sub    $0x10,%esp
	uint xticks;

	acquire(&tickslock);
80105677:	68 20 65 11 80       	push   $0x80116520
8010567c:	e8 bf ec ff ff       	call   80104340 <acquire>
	xticks = ticks;
80105681:	8b 1d 60 6d 11 80    	mov    0x80116d60,%ebx
	release(&tickslock);
80105687:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
8010568e:	e8 cd ed ff ff       	call   80104460 <release>
	return xticks;
}
80105693:	89 d8                	mov    %ebx,%eax
80105695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105698:	c9                   	leave  
80105699:	c3                   	ret    
8010569a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056a0 <sys_mcreate>:
/* Iterate throught the global array of mutexes.
find the index of the first 'empty mutex' 
(mutex is available), set mutex fields, return 
index or -1 if full */
int 
sys_mcreate(char *name){
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 0c             	sub    $0xc,%esp

	argptr(0, (void*)&name, sizeof(*name));
801056a6:	8d 45 08             	lea    0x8(%ebp),%eax
801056a9:	6a 01                	push   $0x1
801056ab:	50                   	push   %eax
801056ac:	6a 00                	push   $0x0
801056ae:	e8 5d f1 ff ff       	call   80104810 <argptr>
801056b3:	ba f4 ff 10 80       	mov    $0x8010fff4,%edx
801056b8:	83 c4 10             	add    $0x10,%esp
	int i;

	for (i=0; i<MUX_MAXNUM; i++){
801056bb:	31 c0                	xor    %eax,%eax
801056bd:	eb 0c                	jmp    801056cb <sys_mcreate+0x2b>
801056bf:	90                   	nop
801056c0:	83 c0 01             	add    $0x1,%eax
801056c3:	83 c2 3c             	add    $0x3c,%edx
801056c6:	83 f8 14             	cmp    $0x14,%eax
801056c9:	74 25                	je     801056f0 <sys_mcreate+0x50>
		if (MUTEXES[i].name == 0){
801056cb:	8b 0a                	mov    (%edx),%ecx
801056cd:	85 c9                	test   %ecx,%ecx
801056cf:	75 ef                	jne    801056c0 <sys_mcreate+0x20>
			MUTEXES[i].name = name;
801056d1:	6b d0 3c             	imul   $0x3c,%eax,%edx
801056d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801056d7:	89 8a f4 ff 10 80    	mov    %ecx,-0x7fef000c(%edx)
			MUTEXES[i].state = 0;
801056dd:	c7 82 f8 ff 10 80 00 	movl   $0x0,-0x7fef0008(%edx)
801056e4:	00 00 00 
			return i;
		}
	}
	return -1;
}
801056e7:	c9                   	leave  
801056e8:	c3                   	ret    
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <sys_mdelete>:

int
sys_mdelete(int muxid){
80105700:	55                   	push   %ebp
	return -1;
}
80105701:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
sys_mdelete(int muxid){
80105706:	89 e5                	mov    %esp,%ebp
}
80105708:	5d                   	pop    %ebp
80105709:	c3                   	ret    
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105710 <sys_mlock>:
80105710:	55                   	push   %ebp
80105711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105716:	89 e5                	mov    %esp,%ebp
80105718:	5d                   	pop    %ebp
80105719:	c3                   	ret    
8010571a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105720 <sys_munlock>:
80105720:	55                   	push   %ebp
80105721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105726:	89 e5                	mov    %esp,%ebp
80105728:	5d                   	pop    %ebp
80105729:	c3                   	ret    

8010572a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010572a:	1e                   	push   %ds
  pushl %es
8010572b:	06                   	push   %es
  pushl %fs
8010572c:	0f a0                	push   %fs
  pushl %gs
8010572e:	0f a8                	push   %gs
  pushal
80105730:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105731:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105735:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105737:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105739:	54                   	push   %esp
  call trap
8010573a:	e8 c1 00 00 00       	call   80105800 <trap>
  addl $4, %esp
8010573f:	83 c4 04             	add    $0x4,%esp

80105742 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105742:	61                   	popa   
  popl %gs
80105743:	0f a9                	pop    %gs
  popl %fs
80105745:	0f a1                	pop    %fs
  popl %es
80105747:	07                   	pop    %es
  popl %ds
80105748:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105749:	83 c4 08             	add    $0x8,%esp
  iret
8010574c:	cf                   	iret   
8010574d:	66 90                	xchg   %ax,%ax
8010574f:	90                   	nop

80105750 <tvinit>:
struct spinlock tickslock;
uint            ticks;

void
tvinit(void)
{
80105750:	55                   	push   %ebp
	int i;

	for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105751:	31 c0                	xor    %eax,%eax
{
80105753:	89 e5                	mov    %esp,%ebp
80105755:	83 ec 08             	sub    $0x8,%esp
80105758:	90                   	nop
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105760:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105767:	c7 04 c5 62 65 11 80 	movl   $0x8e000008,-0x7fee9a9e(,%eax,8)
8010576e:	08 00 00 8e 
80105772:	66 89 14 c5 60 65 11 	mov    %dx,-0x7fee9aa0(,%eax,8)
80105779:	80 
8010577a:	c1 ea 10             	shr    $0x10,%edx
8010577d:	66 89 14 c5 66 65 11 	mov    %dx,-0x7fee9a9a(,%eax,8)
80105784:	80 
80105785:	83 c0 01             	add    $0x1,%eax
80105788:	3d 00 01 00 00       	cmp    $0x100,%eax
8010578d:	75 d1                	jne    80105760 <tvinit+0x10>
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
8010578f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

	initlock(&tickslock, "time");
80105794:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105797:	c7 05 62 67 11 80 08 	movl   $0xef000008,0x80116762
8010579e:	00 00 ef 
	initlock(&tickslock, "time");
801057a1:	68 49 77 10 80       	push   $0x80107749
801057a6:	68 20 65 11 80       	push   $0x80116520
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801057ab:	66 a3 60 67 11 80    	mov    %ax,0x80116760
801057b1:	c1 e8 10             	shr    $0x10,%eax
801057b4:	66 a3 66 67 11 80    	mov    %ax,0x80116766
	initlock(&tickslock, "time");
801057ba:	e8 91 ea ff ff       	call   80104250 <initlock>
}
801057bf:	83 c4 10             	add    $0x10,%esp
801057c2:	c9                   	leave  
801057c3:	c3                   	ret    
801057c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057d0 <idtinit>:

void
idtinit(void)
{
801057d0:	55                   	push   %ebp
	pd[0] = size - 1;
801057d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057d6:	89 e5                	mov    %esp,%ebp
801057d8:	83 ec 10             	sub    $0x10,%esp
801057db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
	pd[1] = (uint)p;
801057df:	b8 60 65 11 80       	mov    $0x80116560,%eax
801057e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	pd[2] = (uint)p >> 16;
801057e8:	c1 e8 10             	shr    $0x10,%eax
801057eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
	asm volatile("lidt (%0)" : : "r"(pd));
801057ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801057f2:	0f 01 18             	lidtl  (%eax)
	lidt(idt, sizeof(idt));
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <trap>:

// PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
80105806:	83 ec 1c             	sub    $0x1c,%esp
80105809:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (tf->trapno == T_SYSCALL) {
8010580c:	8b 47 30             	mov    0x30(%edi),%eax
8010580f:	83 f8 40             	cmp    $0x40,%eax
80105812:	0f 84 f0 00 00 00    	je     80105908 <trap+0x108>
		syscall();
		if (myproc()->killed) exit();
		return;
	}

	switch (tf->trapno) {
80105818:	83 e8 20             	sub    $0x20,%eax
8010581b:	83 f8 1f             	cmp    $0x1f,%eax
8010581e:	77 10                	ja     80105830 <trap+0x30>
80105820:	ff 24 85 f0 77 10 80 	jmp    *-0x7fef8810(,%eax,4)
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		lapiceoi();
		break;

	// PAGEBREAK: 13
	default:
		if (myproc() == 0 || (tf->cs & 3) == 0) {
80105830:	e8 db df ff ff       	call   80103810 <myproc>
80105835:	85 c0                	test   %eax,%eax
80105837:	8b 5f 38             	mov    0x38(%edi),%ebx
8010583a:	0f 84 14 02 00 00    	je     80105a54 <trap+0x254>
80105840:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105844:	0f 84 0a 02 00 00    	je     80105a54 <trap+0x254>

static inline uint
rcr2(void)
{
	uint val;
	asm volatile("movl %%cr2,%0" : "=r"(val));
8010584a:	0f 20 d1             	mov    %cr2,%ecx
8010584d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno, cpuid(), tf->eip,
			        rcr2());
			panic("trap");
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80105850:	e8 9b df ff ff       	call   801037f0 <cpuid>
80105855:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105858:	8b 47 34             	mov    0x34(%edi),%eax
8010585b:	8b 77 30             	mov    0x30(%edi),%esi
8010585e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		        "eip 0x%x addr 0x%x--kill proc\n",
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
80105861:	e8 aa df ff ff       	call   80103810 <myproc>
80105866:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105869:	e8 a2 df ff ff       	call   80103810 <myproc>
		cprintf("pid %d %s: trap %d err %d on cpu %d "
8010586e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105871:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105874:	51                   	push   %ecx
80105875:	53                   	push   %ebx
80105876:	52                   	push   %edx
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
80105877:	8b 55 e0             	mov    -0x20(%ebp),%edx
		cprintf("pid %d %s: trap %d err %d on cpu %d "
8010587a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010587d:	56                   	push   %esi
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
8010587e:	83 c2 6c             	add    $0x6c,%edx
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80105881:	52                   	push   %edx
80105882:	ff 70 10             	pushl  0x10(%eax)
80105885:	68 ac 77 10 80       	push   $0x801077ac
8010588a:	e8 d1 ad ff ff       	call   80100660 <cprintf>
		myproc()->killed = 1;
8010588f:	83 c4 20             	add    $0x20,%esp
80105892:	e8 79 df ff ff       	call   80103810 <myproc>
80105897:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
	}

	// Force process exit if it has been killed and is in user space.
	// (If it is still executing in the kernel, let it keep running
	// until it gets to the regular system call return.)
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
8010589e:	e8 6d df ff ff       	call   80103810 <myproc>
801058a3:	85 c0                	test   %eax,%eax
801058a5:	74 1d                	je     801058c4 <trap+0xc4>
801058a7:	e8 64 df ff ff       	call   80103810 <myproc>
801058ac:	8b 50 24             	mov    0x24(%eax),%edx
801058af:	85 d2                	test   %edx,%edx
801058b1:	74 11                	je     801058c4 <trap+0xc4>
801058b3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058b7:	83 e0 03             	and    $0x3,%eax
801058ba:	66 83 f8 03          	cmp    $0x3,%ax
801058be:	0f 84 4c 01 00 00    	je     80105a10 <trap+0x210>

	// Force process to give up CPU on clock tick.
	// If interrupts were on while locks held, would need to check nlock.
	if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER) yield();
801058c4:	e8 47 df ff ff       	call   80103810 <myproc>
801058c9:	85 c0                	test   %eax,%eax
801058cb:	74 0b                	je     801058d8 <trap+0xd8>
801058cd:	e8 3e df ff ff       	call   80103810 <myproc>
801058d2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058d6:	74 68                	je     80105940 <trap+0x140>

	// Check if the process has been killed since we yielded
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801058d8:	e8 33 df ff ff       	call   80103810 <myproc>
801058dd:	85 c0                	test   %eax,%eax
801058df:	74 19                	je     801058fa <trap+0xfa>
801058e1:	e8 2a df ff ff       	call   80103810 <myproc>
801058e6:	8b 40 24             	mov    0x24(%eax),%eax
801058e9:	85 c0                	test   %eax,%eax
801058eb:	74 0d                	je     801058fa <trap+0xfa>
801058ed:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058f1:	83 e0 03             	and    $0x3,%eax
801058f4:	66 83 f8 03          	cmp    $0x3,%ax
801058f8:	74 37                	je     80105931 <trap+0x131>
}
801058fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058fd:	5b                   	pop    %ebx
801058fe:	5e                   	pop    %esi
801058ff:	5f                   	pop    %edi
80105900:	5d                   	pop    %ebp
80105901:	c3                   	ret    
80105902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (myproc()->killed) exit();
80105908:	e8 03 df ff ff       	call   80103810 <myproc>
8010590d:	8b 58 24             	mov    0x24(%eax),%ebx
80105910:	85 db                	test   %ebx,%ebx
80105912:	0f 85 e8 00 00 00    	jne    80105a00 <trap+0x200>
		myproc()->tf = tf;
80105918:	e8 f3 de ff ff       	call   80103810 <myproc>
8010591d:	89 78 18             	mov    %edi,0x18(%eax)
		syscall();
80105920:	e8 8b ef ff ff       	call   801048b0 <syscall>
		if (myproc()->killed) exit();
80105925:	e8 e6 de ff ff       	call   80103810 <myproc>
8010592a:	8b 48 24             	mov    0x24(%eax),%ecx
8010592d:	85 c9                	test   %ecx,%ecx
8010592f:	74 c9                	je     801058fa <trap+0xfa>
}
80105931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
		if (myproc()->killed) exit();
80105938:	e9 13 e3 ff ff       	jmp    80103c50 <exit>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
	if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER) yield();
80105940:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105944:	75 92                	jne    801058d8 <trap+0xd8>
80105946:	e8 35 e4 ff ff       	call   80103d80 <yield>
8010594b:	eb 8b                	jmp    801058d8 <trap+0xd8>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
		if (cpuid() == 0) {
80105950:	e8 9b de ff ff       	call   801037f0 <cpuid>
80105955:	85 c0                	test   %eax,%eax
80105957:	0f 84 c3 00 00 00    	je     80105a20 <trap+0x220>
		lapiceoi();
8010595d:	e8 fe cd ff ff       	call   80102760 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80105962:	e8 a9 de ff ff       	call   80103810 <myproc>
80105967:	85 c0                	test   %eax,%eax
80105969:	0f 85 38 ff ff ff    	jne    801058a7 <trap+0xa7>
8010596f:	e9 50 ff ff ff       	jmp    801058c4 <trap+0xc4>
80105974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		kbdintr();
80105978:	e8 a3 cc ff ff       	call   80102620 <kbdintr>
		lapiceoi();
8010597d:	e8 de cd ff ff       	call   80102760 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80105982:	e8 89 de ff ff       	call   80103810 <myproc>
80105987:	85 c0                	test   %eax,%eax
80105989:	0f 85 18 ff ff ff    	jne    801058a7 <trap+0xa7>
8010598f:	e9 30 ff ff ff       	jmp    801058c4 <trap+0xc4>
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		uartintr();
80105998:	e8 53 02 00 00       	call   80105bf0 <uartintr>
		lapiceoi();
8010599d:	e8 be cd ff ff       	call   80102760 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801059a2:	e8 69 de ff ff       	call   80103810 <myproc>
801059a7:	85 c0                	test   %eax,%eax
801059a9:	0f 85 f8 fe ff ff    	jne    801058a7 <trap+0xa7>
801059af:	e9 10 ff ff ff       	jmp    801058c4 <trap+0xc4>
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("cpu%d: spurious interrupt at %x:%x\n", cpuid(), tf->cs, tf->eip);
801059b8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059bc:	8b 77 38             	mov    0x38(%edi),%esi
801059bf:	e8 2c de ff ff       	call   801037f0 <cpuid>
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
801059c6:	50                   	push   %eax
801059c7:	68 54 77 10 80       	push   $0x80107754
801059cc:	e8 8f ac ff ff       	call   80100660 <cprintf>
		lapiceoi();
801059d1:	e8 8a cd ff ff       	call   80102760 <lapiceoi>
		break;
801059d6:	83 c4 10             	add    $0x10,%esp
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801059d9:	e8 32 de ff ff       	call   80103810 <myproc>
801059de:	85 c0                	test   %eax,%eax
801059e0:	0f 85 c1 fe ff ff    	jne    801058a7 <trap+0xa7>
801059e6:	e9 d9 fe ff ff       	jmp    801058c4 <trap+0xc4>
801059eb:	90                   	nop
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		ideintr();
801059f0:	e8 9b c6 ff ff       	call   80102090 <ideintr>
801059f5:	e9 63 ff ff ff       	jmp    8010595d <trap+0x15d>
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (myproc()->killed) exit();
80105a00:	e8 4b e2 ff ff       	call   80103c50 <exit>
80105a05:	e9 0e ff ff ff       	jmp    80105918 <trap+0x118>
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80105a10:	e8 3b e2 ff ff       	call   80103c50 <exit>
80105a15:	e9 aa fe ff ff       	jmp    801058c4 <trap+0xc4>
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			acquire(&tickslock);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	68 20 65 11 80       	push   $0x80116520
80105a28:	e8 13 e9 ff ff       	call   80104340 <acquire>
			wakeup(&ticks);
80105a2d:	c7 04 24 60 6d 11 80 	movl   $0x80116d60,(%esp)
			ticks++;
80105a34:	83 05 60 6d 11 80 01 	addl   $0x1,0x80116d60
			wakeup(&ticks);
80105a3b:	e8 50 e5 ff ff       	call   80103f90 <wakeup>
			release(&tickslock);
80105a40:	c7 04 24 20 65 11 80 	movl   $0x80116520,(%esp)
80105a47:	e8 14 ea ff ff       	call   80104460 <release>
80105a4c:	83 c4 10             	add    $0x10,%esp
80105a4f:	e9 09 ff ff ff       	jmp    8010595d <trap+0x15d>
80105a54:	0f 20 d6             	mov    %cr2,%esi
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno, cpuid(), tf->eip,
80105a57:	e8 94 dd ff ff       	call   801037f0 <cpuid>
80105a5c:	83 ec 0c             	sub    $0xc,%esp
80105a5f:	56                   	push   %esi
80105a60:	53                   	push   %ebx
80105a61:	50                   	push   %eax
80105a62:	ff 77 30             	pushl  0x30(%edi)
80105a65:	68 78 77 10 80       	push   $0x80107778
80105a6a:	e8 f1 ab ff ff       	call   80100660 <cprintf>
			panic("trap");
80105a6f:	83 c4 14             	add    $0x14,%esp
80105a72:	68 4e 77 10 80       	push   $0x8010774e
80105a77:	e8 14 a9 ff ff       	call   80100390 <panic>
80105a7c:	66 90                	xchg   %ax,%ax
80105a7e:	66 90                	xchg   %ax,%ax

80105a80 <uartgetc>:
}

static int
uartgetc(void)
{
	if (!uart) return -1;
80105a80:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105a85:	55                   	push   %ebp
80105a86:	89 e5                	mov    %esp,%ebp
	if (!uart) return -1;
80105a88:	85 c0                	test   %eax,%eax
80105a8a:	74 1c                	je     80105aa8 <uartgetc+0x28>
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80105a8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a91:	ec                   	in     (%dx),%al
	if (!(inb(COM1 + 5) & 0x01)) return -1;
80105a92:	a8 01                	test   $0x1,%al
80105a94:	74 12                	je     80105aa8 <uartgetc+0x28>
80105a96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a9b:	ec                   	in     (%dx),%al
	return inb(COM1 + 0);
80105a9c:	0f b6 c0             	movzbl %al,%eax
}
80105a9f:	5d                   	pop    %ebp
80105aa0:	c3                   	ret    
80105aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (!uart) return -1;
80105aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aad:	5d                   	pop    %ebp
80105aae:	c3                   	ret    
80105aaf:	90                   	nop

80105ab0 <uartputc.part.0>:
uartputc(int c)
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
80105ab5:	53                   	push   %ebx
80105ab6:	89 c7                	mov    %eax,%edi
80105ab8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105abd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ac2:	83 ec 0c             	sub    $0xc,%esp
80105ac5:	eb 1b                	jmp    80105ae2 <uartputc.part.0+0x32>
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) microdelay(10);
80105ad0:	83 ec 0c             	sub    $0xc,%esp
80105ad3:	6a 0a                	push   $0xa
80105ad5:	e8 a6 cc ff ff       	call   80102780 <microdelay>
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	83 eb 01             	sub    $0x1,%ebx
80105ae0:	74 07                	je     80105ae9 <uartputc.part.0+0x39>
80105ae2:	89 f2                	mov    %esi,%edx
80105ae4:	ec                   	in     (%dx),%al
80105ae5:	a8 20                	test   $0x20,%al
80105ae7:	74 e7                	je     80105ad0 <uartputc.part.0+0x20>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80105ae9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105aee:	89 f8                	mov    %edi,%eax
80105af0:	ee                   	out    %al,(%dx)
}
80105af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af4:	5b                   	pop    %ebx
80105af5:	5e                   	pop    %esi
80105af6:	5f                   	pop    %edi
80105af7:	5d                   	pop    %ebp
80105af8:	c3                   	ret    
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b00 <uartinit>:
{
80105b00:	55                   	push   %ebp
80105b01:	31 c9                	xor    %ecx,%ecx
80105b03:	89 c8                	mov    %ecx,%eax
80105b05:	89 e5                	mov    %esp,%ebp
80105b07:	57                   	push   %edi
80105b08:	56                   	push   %esi
80105b09:	53                   	push   %ebx
80105b0a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b0f:	89 da                	mov    %ebx,%edx
80105b11:	83 ec 0c             	sub    $0xc,%esp
80105b14:	ee                   	out    %al,(%dx)
80105b15:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b1f:	89 fa                	mov    %edi,%edx
80105b21:	ee                   	out    %al,(%dx)
80105b22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b2c:	ee                   	out    %al,(%dx)
80105b2d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b32:	89 c8                	mov    %ecx,%eax
80105b34:	89 f2                	mov    %esi,%edx
80105b36:	ee                   	out    %al,(%dx)
80105b37:	b8 03 00 00 00       	mov    $0x3,%eax
80105b3c:	89 fa                	mov    %edi,%edx
80105b3e:	ee                   	out    %al,(%dx)
80105b3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b44:	89 c8                	mov    %ecx,%eax
80105b46:	ee                   	out    %al,(%dx)
80105b47:	b8 01 00 00 00       	mov    $0x1,%eax
80105b4c:	89 f2                	mov    %esi,%edx
80105b4e:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
80105b4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b54:	ec                   	in     (%dx),%al
	if (inb(COM1 + 5) == 0xFF) return;
80105b55:	3c ff                	cmp    $0xff,%al
80105b57:	74 5a                	je     80105bb3 <uartinit+0xb3>
	uart = 1;
80105b59:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b60:	00 00 00 
80105b63:	89 da                	mov    %ebx,%edx
80105b65:	ec                   	in     (%dx),%al
80105b66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b6b:	ec                   	in     (%dx),%al
	ioapicenable(IRQ_COM1, 0);
80105b6c:	83 ec 08             	sub    $0x8,%esp
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
80105b6f:	bb 70 78 10 80       	mov    $0x80107870,%ebx
	ioapicenable(IRQ_COM1, 0);
80105b74:	6a 00                	push   $0x0
80105b76:	6a 04                	push   $0x4
80105b78:	e8 63 c7 ff ff       	call   801022e0 <ioapicenable>
80105b7d:	83 c4 10             	add    $0x10,%esp
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
80105b80:	b8 78 00 00 00       	mov    $0x78,%eax
80105b85:	eb 13                	jmp    80105b9a <uartinit+0x9a>
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	0f be 03             	movsbl (%ebx),%eax
80105b96:	84 c0                	test   %al,%al
80105b98:	74 19                	je     80105bb3 <uartinit+0xb3>
	if (!uart) return;
80105b9a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105ba0:	85 d2                	test   %edx,%edx
80105ba2:	74 ec                	je     80105b90 <uartinit+0x90>
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
80105ba4:	83 c3 01             	add    $0x1,%ebx
80105ba7:	e8 04 ff ff ff       	call   80105ab0 <uartputc.part.0>
80105bac:	0f be 03             	movsbl (%ebx),%eax
80105baf:	84 c0                	test   %al,%al
80105bb1:	75 e7                	jne    80105b9a <uartinit+0x9a>
}
80105bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb6:	5b                   	pop    %ebx
80105bb7:	5e                   	pop    %esi
80105bb8:	5f                   	pop    %edi
80105bb9:	5d                   	pop    %ebp
80105bba:	c3                   	ret    
80105bbb:	90                   	nop
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <uartputc>:
	if (!uart) return;
80105bc0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105bc6:	55                   	push   %ebp
80105bc7:	89 e5                	mov    %esp,%ebp
	if (!uart) return;
80105bc9:	85 d2                	test   %edx,%edx
{
80105bcb:	8b 45 08             	mov    0x8(%ebp),%eax
	if (!uart) return;
80105bce:	74 10                	je     80105be0 <uartputc+0x20>
}
80105bd0:	5d                   	pop    %ebp
80105bd1:	e9 da fe ff ff       	jmp    80105ab0 <uartputc.part.0>
80105bd6:	8d 76 00             	lea    0x0(%esi),%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105be0:	5d                   	pop    %ebp
80105be1:	c3                   	ret    
80105be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <uartintr>:

void
uartintr(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 14             	sub    $0x14,%esp
	consoleintr(uartgetc);
80105bf6:	68 80 5a 10 80       	push   $0x80105a80
80105bfb:	e8 10 ac ff ff       	call   80100810 <consoleintr>
}
80105c00:	83 c4 10             	add    $0x10,%esp
80105c03:	c9                   	leave  
80105c04:	c3                   	ret    

80105c05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $0
80105c07:	6a 00                	push   $0x0
  jmp alltraps
80105c09:	e9 1c fb ff ff       	jmp    8010572a <alltraps>

80105c0e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $1
80105c10:	6a 01                	push   $0x1
  jmp alltraps
80105c12:	e9 13 fb ff ff       	jmp    8010572a <alltraps>

80105c17 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $2
80105c19:	6a 02                	push   $0x2
  jmp alltraps
80105c1b:	e9 0a fb ff ff       	jmp    8010572a <alltraps>

80105c20 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $3
80105c22:	6a 03                	push   $0x3
  jmp alltraps
80105c24:	e9 01 fb ff ff       	jmp    8010572a <alltraps>

80105c29 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $4
80105c2b:	6a 04                	push   $0x4
  jmp alltraps
80105c2d:	e9 f8 fa ff ff       	jmp    8010572a <alltraps>

80105c32 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $5
80105c34:	6a 05                	push   $0x5
  jmp alltraps
80105c36:	e9 ef fa ff ff       	jmp    8010572a <alltraps>

80105c3b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $6
80105c3d:	6a 06                	push   $0x6
  jmp alltraps
80105c3f:	e9 e6 fa ff ff       	jmp    8010572a <alltraps>

80105c44 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $7
80105c46:	6a 07                	push   $0x7
  jmp alltraps
80105c48:	e9 dd fa ff ff       	jmp    8010572a <alltraps>

80105c4d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c4d:	6a 08                	push   $0x8
  jmp alltraps
80105c4f:	e9 d6 fa ff ff       	jmp    8010572a <alltraps>

80105c54 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c54:	6a 00                	push   $0x0
  pushl $9
80105c56:	6a 09                	push   $0x9
  jmp alltraps
80105c58:	e9 cd fa ff ff       	jmp    8010572a <alltraps>

80105c5d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c5d:	6a 0a                	push   $0xa
  jmp alltraps
80105c5f:	e9 c6 fa ff ff       	jmp    8010572a <alltraps>

80105c64 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c64:	6a 0b                	push   $0xb
  jmp alltraps
80105c66:	e9 bf fa ff ff       	jmp    8010572a <alltraps>

80105c6b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c6b:	6a 0c                	push   $0xc
  jmp alltraps
80105c6d:	e9 b8 fa ff ff       	jmp    8010572a <alltraps>

80105c72 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c72:	6a 0d                	push   $0xd
  jmp alltraps
80105c74:	e9 b1 fa ff ff       	jmp    8010572a <alltraps>

80105c79 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c79:	6a 0e                	push   $0xe
  jmp alltraps
80105c7b:	e9 aa fa ff ff       	jmp    8010572a <alltraps>

80105c80 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $15
80105c82:	6a 0f                	push   $0xf
  jmp alltraps
80105c84:	e9 a1 fa ff ff       	jmp    8010572a <alltraps>

80105c89 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $16
80105c8b:	6a 10                	push   $0x10
  jmp alltraps
80105c8d:	e9 98 fa ff ff       	jmp    8010572a <alltraps>

80105c92 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c92:	6a 11                	push   $0x11
  jmp alltraps
80105c94:	e9 91 fa ff ff       	jmp    8010572a <alltraps>

80105c99 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $18
80105c9b:	6a 12                	push   $0x12
  jmp alltraps
80105c9d:	e9 88 fa ff ff       	jmp    8010572a <alltraps>

80105ca2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $19
80105ca4:	6a 13                	push   $0x13
  jmp alltraps
80105ca6:	e9 7f fa ff ff       	jmp    8010572a <alltraps>

80105cab <vector20>:
.globl vector20
vector20:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $20
80105cad:	6a 14                	push   $0x14
  jmp alltraps
80105caf:	e9 76 fa ff ff       	jmp    8010572a <alltraps>

80105cb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $21
80105cb6:	6a 15                	push   $0x15
  jmp alltraps
80105cb8:	e9 6d fa ff ff       	jmp    8010572a <alltraps>

80105cbd <vector22>:
.globl vector22
vector22:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $22
80105cbf:	6a 16                	push   $0x16
  jmp alltraps
80105cc1:	e9 64 fa ff ff       	jmp    8010572a <alltraps>

80105cc6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $23
80105cc8:	6a 17                	push   $0x17
  jmp alltraps
80105cca:	e9 5b fa ff ff       	jmp    8010572a <alltraps>

80105ccf <vector24>:
.globl vector24
vector24:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $24
80105cd1:	6a 18                	push   $0x18
  jmp alltraps
80105cd3:	e9 52 fa ff ff       	jmp    8010572a <alltraps>

80105cd8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $25
80105cda:	6a 19                	push   $0x19
  jmp alltraps
80105cdc:	e9 49 fa ff ff       	jmp    8010572a <alltraps>

80105ce1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $26
80105ce3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ce5:	e9 40 fa ff ff       	jmp    8010572a <alltraps>

80105cea <vector27>:
.globl vector27
vector27:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $27
80105cec:	6a 1b                	push   $0x1b
  jmp alltraps
80105cee:	e9 37 fa ff ff       	jmp    8010572a <alltraps>

80105cf3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $28
80105cf5:	6a 1c                	push   $0x1c
  jmp alltraps
80105cf7:	e9 2e fa ff ff       	jmp    8010572a <alltraps>

80105cfc <vector29>:
.globl vector29
vector29:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $29
80105cfe:	6a 1d                	push   $0x1d
  jmp alltraps
80105d00:	e9 25 fa ff ff       	jmp    8010572a <alltraps>

80105d05 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $30
80105d07:	6a 1e                	push   $0x1e
  jmp alltraps
80105d09:	e9 1c fa ff ff       	jmp    8010572a <alltraps>

80105d0e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $31
80105d10:	6a 1f                	push   $0x1f
  jmp alltraps
80105d12:	e9 13 fa ff ff       	jmp    8010572a <alltraps>

80105d17 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $32
80105d19:	6a 20                	push   $0x20
  jmp alltraps
80105d1b:	e9 0a fa ff ff       	jmp    8010572a <alltraps>

80105d20 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $33
80105d22:	6a 21                	push   $0x21
  jmp alltraps
80105d24:	e9 01 fa ff ff       	jmp    8010572a <alltraps>

80105d29 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $34
80105d2b:	6a 22                	push   $0x22
  jmp alltraps
80105d2d:	e9 f8 f9 ff ff       	jmp    8010572a <alltraps>

80105d32 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $35
80105d34:	6a 23                	push   $0x23
  jmp alltraps
80105d36:	e9 ef f9 ff ff       	jmp    8010572a <alltraps>

80105d3b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $36
80105d3d:	6a 24                	push   $0x24
  jmp alltraps
80105d3f:	e9 e6 f9 ff ff       	jmp    8010572a <alltraps>

80105d44 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $37
80105d46:	6a 25                	push   $0x25
  jmp alltraps
80105d48:	e9 dd f9 ff ff       	jmp    8010572a <alltraps>

80105d4d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $38
80105d4f:	6a 26                	push   $0x26
  jmp alltraps
80105d51:	e9 d4 f9 ff ff       	jmp    8010572a <alltraps>

80105d56 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $39
80105d58:	6a 27                	push   $0x27
  jmp alltraps
80105d5a:	e9 cb f9 ff ff       	jmp    8010572a <alltraps>

80105d5f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $40
80105d61:	6a 28                	push   $0x28
  jmp alltraps
80105d63:	e9 c2 f9 ff ff       	jmp    8010572a <alltraps>

80105d68 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $41
80105d6a:	6a 29                	push   $0x29
  jmp alltraps
80105d6c:	e9 b9 f9 ff ff       	jmp    8010572a <alltraps>

80105d71 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $42
80105d73:	6a 2a                	push   $0x2a
  jmp alltraps
80105d75:	e9 b0 f9 ff ff       	jmp    8010572a <alltraps>

80105d7a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $43
80105d7c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d7e:	e9 a7 f9 ff ff       	jmp    8010572a <alltraps>

80105d83 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $44
80105d85:	6a 2c                	push   $0x2c
  jmp alltraps
80105d87:	e9 9e f9 ff ff       	jmp    8010572a <alltraps>

80105d8c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $45
80105d8e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d90:	e9 95 f9 ff ff       	jmp    8010572a <alltraps>

80105d95 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $46
80105d97:	6a 2e                	push   $0x2e
  jmp alltraps
80105d99:	e9 8c f9 ff ff       	jmp    8010572a <alltraps>

80105d9e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $47
80105da0:	6a 2f                	push   $0x2f
  jmp alltraps
80105da2:	e9 83 f9 ff ff       	jmp    8010572a <alltraps>

80105da7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $48
80105da9:	6a 30                	push   $0x30
  jmp alltraps
80105dab:	e9 7a f9 ff ff       	jmp    8010572a <alltraps>

80105db0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $49
80105db2:	6a 31                	push   $0x31
  jmp alltraps
80105db4:	e9 71 f9 ff ff       	jmp    8010572a <alltraps>

80105db9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $50
80105dbb:	6a 32                	push   $0x32
  jmp alltraps
80105dbd:	e9 68 f9 ff ff       	jmp    8010572a <alltraps>

80105dc2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $51
80105dc4:	6a 33                	push   $0x33
  jmp alltraps
80105dc6:	e9 5f f9 ff ff       	jmp    8010572a <alltraps>

80105dcb <vector52>:
.globl vector52
vector52:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $52
80105dcd:	6a 34                	push   $0x34
  jmp alltraps
80105dcf:	e9 56 f9 ff ff       	jmp    8010572a <alltraps>

80105dd4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $53
80105dd6:	6a 35                	push   $0x35
  jmp alltraps
80105dd8:	e9 4d f9 ff ff       	jmp    8010572a <alltraps>

80105ddd <vector54>:
.globl vector54
vector54:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $54
80105ddf:	6a 36                	push   $0x36
  jmp alltraps
80105de1:	e9 44 f9 ff ff       	jmp    8010572a <alltraps>

80105de6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $55
80105de8:	6a 37                	push   $0x37
  jmp alltraps
80105dea:	e9 3b f9 ff ff       	jmp    8010572a <alltraps>

80105def <vector56>:
.globl vector56
vector56:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $56
80105df1:	6a 38                	push   $0x38
  jmp alltraps
80105df3:	e9 32 f9 ff ff       	jmp    8010572a <alltraps>

80105df8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $57
80105dfa:	6a 39                	push   $0x39
  jmp alltraps
80105dfc:	e9 29 f9 ff ff       	jmp    8010572a <alltraps>

80105e01 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $58
80105e03:	6a 3a                	push   $0x3a
  jmp alltraps
80105e05:	e9 20 f9 ff ff       	jmp    8010572a <alltraps>

80105e0a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $59
80105e0c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e0e:	e9 17 f9 ff ff       	jmp    8010572a <alltraps>

80105e13 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $60
80105e15:	6a 3c                	push   $0x3c
  jmp alltraps
80105e17:	e9 0e f9 ff ff       	jmp    8010572a <alltraps>

80105e1c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $61
80105e1e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e20:	e9 05 f9 ff ff       	jmp    8010572a <alltraps>

80105e25 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $62
80105e27:	6a 3e                	push   $0x3e
  jmp alltraps
80105e29:	e9 fc f8 ff ff       	jmp    8010572a <alltraps>

80105e2e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $63
80105e30:	6a 3f                	push   $0x3f
  jmp alltraps
80105e32:	e9 f3 f8 ff ff       	jmp    8010572a <alltraps>

80105e37 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $64
80105e39:	6a 40                	push   $0x40
  jmp alltraps
80105e3b:	e9 ea f8 ff ff       	jmp    8010572a <alltraps>

80105e40 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $65
80105e42:	6a 41                	push   $0x41
  jmp alltraps
80105e44:	e9 e1 f8 ff ff       	jmp    8010572a <alltraps>

80105e49 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $66
80105e4b:	6a 42                	push   $0x42
  jmp alltraps
80105e4d:	e9 d8 f8 ff ff       	jmp    8010572a <alltraps>

80105e52 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $67
80105e54:	6a 43                	push   $0x43
  jmp alltraps
80105e56:	e9 cf f8 ff ff       	jmp    8010572a <alltraps>

80105e5b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $68
80105e5d:	6a 44                	push   $0x44
  jmp alltraps
80105e5f:	e9 c6 f8 ff ff       	jmp    8010572a <alltraps>

80105e64 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $69
80105e66:	6a 45                	push   $0x45
  jmp alltraps
80105e68:	e9 bd f8 ff ff       	jmp    8010572a <alltraps>

80105e6d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $70
80105e6f:	6a 46                	push   $0x46
  jmp alltraps
80105e71:	e9 b4 f8 ff ff       	jmp    8010572a <alltraps>

80105e76 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $71
80105e78:	6a 47                	push   $0x47
  jmp alltraps
80105e7a:	e9 ab f8 ff ff       	jmp    8010572a <alltraps>

80105e7f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $72
80105e81:	6a 48                	push   $0x48
  jmp alltraps
80105e83:	e9 a2 f8 ff ff       	jmp    8010572a <alltraps>

80105e88 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $73
80105e8a:	6a 49                	push   $0x49
  jmp alltraps
80105e8c:	e9 99 f8 ff ff       	jmp    8010572a <alltraps>

80105e91 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $74
80105e93:	6a 4a                	push   $0x4a
  jmp alltraps
80105e95:	e9 90 f8 ff ff       	jmp    8010572a <alltraps>

80105e9a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $75
80105e9c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e9e:	e9 87 f8 ff ff       	jmp    8010572a <alltraps>

80105ea3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $76
80105ea5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ea7:	e9 7e f8 ff ff       	jmp    8010572a <alltraps>

80105eac <vector77>:
.globl vector77
vector77:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $77
80105eae:	6a 4d                	push   $0x4d
  jmp alltraps
80105eb0:	e9 75 f8 ff ff       	jmp    8010572a <alltraps>

80105eb5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $78
80105eb7:	6a 4e                	push   $0x4e
  jmp alltraps
80105eb9:	e9 6c f8 ff ff       	jmp    8010572a <alltraps>

80105ebe <vector79>:
.globl vector79
vector79:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $79
80105ec0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ec2:	e9 63 f8 ff ff       	jmp    8010572a <alltraps>

80105ec7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $80
80105ec9:	6a 50                	push   $0x50
  jmp alltraps
80105ecb:	e9 5a f8 ff ff       	jmp    8010572a <alltraps>

80105ed0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $81
80105ed2:	6a 51                	push   $0x51
  jmp alltraps
80105ed4:	e9 51 f8 ff ff       	jmp    8010572a <alltraps>

80105ed9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $82
80105edb:	6a 52                	push   $0x52
  jmp alltraps
80105edd:	e9 48 f8 ff ff       	jmp    8010572a <alltraps>

80105ee2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $83
80105ee4:	6a 53                	push   $0x53
  jmp alltraps
80105ee6:	e9 3f f8 ff ff       	jmp    8010572a <alltraps>

80105eeb <vector84>:
.globl vector84
vector84:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $84
80105eed:	6a 54                	push   $0x54
  jmp alltraps
80105eef:	e9 36 f8 ff ff       	jmp    8010572a <alltraps>

80105ef4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $85
80105ef6:	6a 55                	push   $0x55
  jmp alltraps
80105ef8:	e9 2d f8 ff ff       	jmp    8010572a <alltraps>

80105efd <vector86>:
.globl vector86
vector86:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $86
80105eff:	6a 56                	push   $0x56
  jmp alltraps
80105f01:	e9 24 f8 ff ff       	jmp    8010572a <alltraps>

80105f06 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $87
80105f08:	6a 57                	push   $0x57
  jmp alltraps
80105f0a:	e9 1b f8 ff ff       	jmp    8010572a <alltraps>

80105f0f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $88
80105f11:	6a 58                	push   $0x58
  jmp alltraps
80105f13:	e9 12 f8 ff ff       	jmp    8010572a <alltraps>

80105f18 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $89
80105f1a:	6a 59                	push   $0x59
  jmp alltraps
80105f1c:	e9 09 f8 ff ff       	jmp    8010572a <alltraps>

80105f21 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $90
80105f23:	6a 5a                	push   $0x5a
  jmp alltraps
80105f25:	e9 00 f8 ff ff       	jmp    8010572a <alltraps>

80105f2a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $91
80105f2c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f2e:	e9 f7 f7 ff ff       	jmp    8010572a <alltraps>

80105f33 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $92
80105f35:	6a 5c                	push   $0x5c
  jmp alltraps
80105f37:	e9 ee f7 ff ff       	jmp    8010572a <alltraps>

80105f3c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $93
80105f3e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f40:	e9 e5 f7 ff ff       	jmp    8010572a <alltraps>

80105f45 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $94
80105f47:	6a 5e                	push   $0x5e
  jmp alltraps
80105f49:	e9 dc f7 ff ff       	jmp    8010572a <alltraps>

80105f4e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $95
80105f50:	6a 5f                	push   $0x5f
  jmp alltraps
80105f52:	e9 d3 f7 ff ff       	jmp    8010572a <alltraps>

80105f57 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $96
80105f59:	6a 60                	push   $0x60
  jmp alltraps
80105f5b:	e9 ca f7 ff ff       	jmp    8010572a <alltraps>

80105f60 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $97
80105f62:	6a 61                	push   $0x61
  jmp alltraps
80105f64:	e9 c1 f7 ff ff       	jmp    8010572a <alltraps>

80105f69 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $98
80105f6b:	6a 62                	push   $0x62
  jmp alltraps
80105f6d:	e9 b8 f7 ff ff       	jmp    8010572a <alltraps>

80105f72 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $99
80105f74:	6a 63                	push   $0x63
  jmp alltraps
80105f76:	e9 af f7 ff ff       	jmp    8010572a <alltraps>

80105f7b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $100
80105f7d:	6a 64                	push   $0x64
  jmp alltraps
80105f7f:	e9 a6 f7 ff ff       	jmp    8010572a <alltraps>

80105f84 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $101
80105f86:	6a 65                	push   $0x65
  jmp alltraps
80105f88:	e9 9d f7 ff ff       	jmp    8010572a <alltraps>

80105f8d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $102
80105f8f:	6a 66                	push   $0x66
  jmp alltraps
80105f91:	e9 94 f7 ff ff       	jmp    8010572a <alltraps>

80105f96 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $103
80105f98:	6a 67                	push   $0x67
  jmp alltraps
80105f9a:	e9 8b f7 ff ff       	jmp    8010572a <alltraps>

80105f9f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $104
80105fa1:	6a 68                	push   $0x68
  jmp alltraps
80105fa3:	e9 82 f7 ff ff       	jmp    8010572a <alltraps>

80105fa8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $105
80105faa:	6a 69                	push   $0x69
  jmp alltraps
80105fac:	e9 79 f7 ff ff       	jmp    8010572a <alltraps>

80105fb1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $106
80105fb3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fb5:	e9 70 f7 ff ff       	jmp    8010572a <alltraps>

80105fba <vector107>:
.globl vector107
vector107:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $107
80105fbc:	6a 6b                	push   $0x6b
  jmp alltraps
80105fbe:	e9 67 f7 ff ff       	jmp    8010572a <alltraps>

80105fc3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $108
80105fc5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fc7:	e9 5e f7 ff ff       	jmp    8010572a <alltraps>

80105fcc <vector109>:
.globl vector109
vector109:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $109
80105fce:	6a 6d                	push   $0x6d
  jmp alltraps
80105fd0:	e9 55 f7 ff ff       	jmp    8010572a <alltraps>

80105fd5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $110
80105fd7:	6a 6e                	push   $0x6e
  jmp alltraps
80105fd9:	e9 4c f7 ff ff       	jmp    8010572a <alltraps>

80105fde <vector111>:
.globl vector111
vector111:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $111
80105fe0:	6a 6f                	push   $0x6f
  jmp alltraps
80105fe2:	e9 43 f7 ff ff       	jmp    8010572a <alltraps>

80105fe7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $112
80105fe9:	6a 70                	push   $0x70
  jmp alltraps
80105feb:	e9 3a f7 ff ff       	jmp    8010572a <alltraps>

80105ff0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $113
80105ff2:	6a 71                	push   $0x71
  jmp alltraps
80105ff4:	e9 31 f7 ff ff       	jmp    8010572a <alltraps>

80105ff9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $114
80105ffb:	6a 72                	push   $0x72
  jmp alltraps
80105ffd:	e9 28 f7 ff ff       	jmp    8010572a <alltraps>

80106002 <vector115>:
.globl vector115
vector115:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $115
80106004:	6a 73                	push   $0x73
  jmp alltraps
80106006:	e9 1f f7 ff ff       	jmp    8010572a <alltraps>

8010600b <vector116>:
.globl vector116
vector116:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $116
8010600d:	6a 74                	push   $0x74
  jmp alltraps
8010600f:	e9 16 f7 ff ff       	jmp    8010572a <alltraps>

80106014 <vector117>:
.globl vector117
vector117:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $117
80106016:	6a 75                	push   $0x75
  jmp alltraps
80106018:	e9 0d f7 ff ff       	jmp    8010572a <alltraps>

8010601d <vector118>:
.globl vector118
vector118:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $118
8010601f:	6a 76                	push   $0x76
  jmp alltraps
80106021:	e9 04 f7 ff ff       	jmp    8010572a <alltraps>

80106026 <vector119>:
.globl vector119
vector119:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $119
80106028:	6a 77                	push   $0x77
  jmp alltraps
8010602a:	e9 fb f6 ff ff       	jmp    8010572a <alltraps>

8010602f <vector120>:
.globl vector120
vector120:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $120
80106031:	6a 78                	push   $0x78
  jmp alltraps
80106033:	e9 f2 f6 ff ff       	jmp    8010572a <alltraps>

80106038 <vector121>:
.globl vector121
vector121:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $121
8010603a:	6a 79                	push   $0x79
  jmp alltraps
8010603c:	e9 e9 f6 ff ff       	jmp    8010572a <alltraps>

80106041 <vector122>:
.globl vector122
vector122:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $122
80106043:	6a 7a                	push   $0x7a
  jmp alltraps
80106045:	e9 e0 f6 ff ff       	jmp    8010572a <alltraps>

8010604a <vector123>:
.globl vector123
vector123:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $123
8010604c:	6a 7b                	push   $0x7b
  jmp alltraps
8010604e:	e9 d7 f6 ff ff       	jmp    8010572a <alltraps>

80106053 <vector124>:
.globl vector124
vector124:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $124
80106055:	6a 7c                	push   $0x7c
  jmp alltraps
80106057:	e9 ce f6 ff ff       	jmp    8010572a <alltraps>

8010605c <vector125>:
.globl vector125
vector125:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $125
8010605e:	6a 7d                	push   $0x7d
  jmp alltraps
80106060:	e9 c5 f6 ff ff       	jmp    8010572a <alltraps>

80106065 <vector126>:
.globl vector126
vector126:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $126
80106067:	6a 7e                	push   $0x7e
  jmp alltraps
80106069:	e9 bc f6 ff ff       	jmp    8010572a <alltraps>

8010606e <vector127>:
.globl vector127
vector127:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $127
80106070:	6a 7f                	push   $0x7f
  jmp alltraps
80106072:	e9 b3 f6 ff ff       	jmp    8010572a <alltraps>

80106077 <vector128>:
.globl vector128
vector128:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $128
80106079:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010607e:	e9 a7 f6 ff ff       	jmp    8010572a <alltraps>

80106083 <vector129>:
.globl vector129
vector129:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $129
80106085:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010608a:	e9 9b f6 ff ff       	jmp    8010572a <alltraps>

8010608f <vector130>:
.globl vector130
vector130:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $130
80106091:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106096:	e9 8f f6 ff ff       	jmp    8010572a <alltraps>

8010609b <vector131>:
.globl vector131
vector131:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $131
8010609d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060a2:	e9 83 f6 ff ff       	jmp    8010572a <alltraps>

801060a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $132
801060a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060ae:	e9 77 f6 ff ff       	jmp    8010572a <alltraps>

801060b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $133
801060b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060ba:	e9 6b f6 ff ff       	jmp    8010572a <alltraps>

801060bf <vector134>:
.globl vector134
vector134:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $134
801060c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060c6:	e9 5f f6 ff ff       	jmp    8010572a <alltraps>

801060cb <vector135>:
.globl vector135
vector135:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $135
801060cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060d2:	e9 53 f6 ff ff       	jmp    8010572a <alltraps>

801060d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $136
801060d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060de:	e9 47 f6 ff ff       	jmp    8010572a <alltraps>

801060e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $137
801060e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060ea:	e9 3b f6 ff ff       	jmp    8010572a <alltraps>

801060ef <vector138>:
.globl vector138
vector138:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $138
801060f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060f6:	e9 2f f6 ff ff       	jmp    8010572a <alltraps>

801060fb <vector139>:
.globl vector139
vector139:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $139
801060fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106102:	e9 23 f6 ff ff       	jmp    8010572a <alltraps>

80106107 <vector140>:
.globl vector140
vector140:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $140
80106109:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010610e:	e9 17 f6 ff ff       	jmp    8010572a <alltraps>

80106113 <vector141>:
.globl vector141
vector141:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $141
80106115:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010611a:	e9 0b f6 ff ff       	jmp    8010572a <alltraps>

8010611f <vector142>:
.globl vector142
vector142:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $142
80106121:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106126:	e9 ff f5 ff ff       	jmp    8010572a <alltraps>

8010612b <vector143>:
.globl vector143
vector143:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $143
8010612d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106132:	e9 f3 f5 ff ff       	jmp    8010572a <alltraps>

80106137 <vector144>:
.globl vector144
vector144:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $144
80106139:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010613e:	e9 e7 f5 ff ff       	jmp    8010572a <alltraps>

80106143 <vector145>:
.globl vector145
vector145:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $145
80106145:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010614a:	e9 db f5 ff ff       	jmp    8010572a <alltraps>

8010614f <vector146>:
.globl vector146
vector146:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $146
80106151:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106156:	e9 cf f5 ff ff       	jmp    8010572a <alltraps>

8010615b <vector147>:
.globl vector147
vector147:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $147
8010615d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106162:	e9 c3 f5 ff ff       	jmp    8010572a <alltraps>

80106167 <vector148>:
.globl vector148
vector148:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $148
80106169:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010616e:	e9 b7 f5 ff ff       	jmp    8010572a <alltraps>

80106173 <vector149>:
.globl vector149
vector149:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $149
80106175:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010617a:	e9 ab f5 ff ff       	jmp    8010572a <alltraps>

8010617f <vector150>:
.globl vector150
vector150:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $150
80106181:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106186:	e9 9f f5 ff ff       	jmp    8010572a <alltraps>

8010618b <vector151>:
.globl vector151
vector151:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $151
8010618d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106192:	e9 93 f5 ff ff       	jmp    8010572a <alltraps>

80106197 <vector152>:
.globl vector152
vector152:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $152
80106199:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010619e:	e9 87 f5 ff ff       	jmp    8010572a <alltraps>

801061a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $153
801061a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061aa:	e9 7b f5 ff ff       	jmp    8010572a <alltraps>

801061af <vector154>:
.globl vector154
vector154:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $154
801061b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061b6:	e9 6f f5 ff ff       	jmp    8010572a <alltraps>

801061bb <vector155>:
.globl vector155
vector155:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $155
801061bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061c2:	e9 63 f5 ff ff       	jmp    8010572a <alltraps>

801061c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $156
801061c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061ce:	e9 57 f5 ff ff       	jmp    8010572a <alltraps>

801061d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $157
801061d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061da:	e9 4b f5 ff ff       	jmp    8010572a <alltraps>

801061df <vector158>:
.globl vector158
vector158:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $158
801061e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061e6:	e9 3f f5 ff ff       	jmp    8010572a <alltraps>

801061eb <vector159>:
.globl vector159
vector159:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $159
801061ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061f2:	e9 33 f5 ff ff       	jmp    8010572a <alltraps>

801061f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $160
801061f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061fe:	e9 27 f5 ff ff       	jmp    8010572a <alltraps>

80106203 <vector161>:
.globl vector161
vector161:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $161
80106205:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010620a:	e9 1b f5 ff ff       	jmp    8010572a <alltraps>

8010620f <vector162>:
.globl vector162
vector162:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $162
80106211:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106216:	e9 0f f5 ff ff       	jmp    8010572a <alltraps>

8010621b <vector163>:
.globl vector163
vector163:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $163
8010621d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106222:	e9 03 f5 ff ff       	jmp    8010572a <alltraps>

80106227 <vector164>:
.globl vector164
vector164:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $164
80106229:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010622e:	e9 f7 f4 ff ff       	jmp    8010572a <alltraps>

80106233 <vector165>:
.globl vector165
vector165:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $165
80106235:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010623a:	e9 eb f4 ff ff       	jmp    8010572a <alltraps>

8010623f <vector166>:
.globl vector166
vector166:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $166
80106241:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106246:	e9 df f4 ff ff       	jmp    8010572a <alltraps>

8010624b <vector167>:
.globl vector167
vector167:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $167
8010624d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106252:	e9 d3 f4 ff ff       	jmp    8010572a <alltraps>

80106257 <vector168>:
.globl vector168
vector168:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $168
80106259:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010625e:	e9 c7 f4 ff ff       	jmp    8010572a <alltraps>

80106263 <vector169>:
.globl vector169
vector169:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $169
80106265:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010626a:	e9 bb f4 ff ff       	jmp    8010572a <alltraps>

8010626f <vector170>:
.globl vector170
vector170:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $170
80106271:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106276:	e9 af f4 ff ff       	jmp    8010572a <alltraps>

8010627b <vector171>:
.globl vector171
vector171:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $171
8010627d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106282:	e9 a3 f4 ff ff       	jmp    8010572a <alltraps>

80106287 <vector172>:
.globl vector172
vector172:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $172
80106289:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010628e:	e9 97 f4 ff ff       	jmp    8010572a <alltraps>

80106293 <vector173>:
.globl vector173
vector173:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $173
80106295:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010629a:	e9 8b f4 ff ff       	jmp    8010572a <alltraps>

8010629f <vector174>:
.globl vector174
vector174:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $174
801062a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062a6:	e9 7f f4 ff ff       	jmp    8010572a <alltraps>

801062ab <vector175>:
.globl vector175
vector175:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $175
801062ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062b2:	e9 73 f4 ff ff       	jmp    8010572a <alltraps>

801062b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $176
801062b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062be:	e9 67 f4 ff ff       	jmp    8010572a <alltraps>

801062c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $177
801062c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062ca:	e9 5b f4 ff ff       	jmp    8010572a <alltraps>

801062cf <vector178>:
.globl vector178
vector178:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $178
801062d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062d6:	e9 4f f4 ff ff       	jmp    8010572a <alltraps>

801062db <vector179>:
.globl vector179
vector179:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $179
801062dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062e2:	e9 43 f4 ff ff       	jmp    8010572a <alltraps>

801062e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $180
801062e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062ee:	e9 37 f4 ff ff       	jmp    8010572a <alltraps>

801062f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $181
801062f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062fa:	e9 2b f4 ff ff       	jmp    8010572a <alltraps>

801062ff <vector182>:
.globl vector182
vector182:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $182
80106301:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106306:	e9 1f f4 ff ff       	jmp    8010572a <alltraps>

8010630b <vector183>:
.globl vector183
vector183:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $183
8010630d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106312:	e9 13 f4 ff ff       	jmp    8010572a <alltraps>

80106317 <vector184>:
.globl vector184
vector184:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $184
80106319:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010631e:	e9 07 f4 ff ff       	jmp    8010572a <alltraps>

80106323 <vector185>:
.globl vector185
vector185:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $185
80106325:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010632a:	e9 fb f3 ff ff       	jmp    8010572a <alltraps>

8010632f <vector186>:
.globl vector186
vector186:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $186
80106331:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106336:	e9 ef f3 ff ff       	jmp    8010572a <alltraps>

8010633b <vector187>:
.globl vector187
vector187:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $187
8010633d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106342:	e9 e3 f3 ff ff       	jmp    8010572a <alltraps>

80106347 <vector188>:
.globl vector188
vector188:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $188
80106349:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010634e:	e9 d7 f3 ff ff       	jmp    8010572a <alltraps>

80106353 <vector189>:
.globl vector189
vector189:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $189
80106355:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010635a:	e9 cb f3 ff ff       	jmp    8010572a <alltraps>

8010635f <vector190>:
.globl vector190
vector190:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $190
80106361:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106366:	e9 bf f3 ff ff       	jmp    8010572a <alltraps>

8010636b <vector191>:
.globl vector191
vector191:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $191
8010636d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106372:	e9 b3 f3 ff ff       	jmp    8010572a <alltraps>

80106377 <vector192>:
.globl vector192
vector192:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $192
80106379:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010637e:	e9 a7 f3 ff ff       	jmp    8010572a <alltraps>

80106383 <vector193>:
.globl vector193
vector193:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $193
80106385:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010638a:	e9 9b f3 ff ff       	jmp    8010572a <alltraps>

8010638f <vector194>:
.globl vector194
vector194:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $194
80106391:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106396:	e9 8f f3 ff ff       	jmp    8010572a <alltraps>

8010639b <vector195>:
.globl vector195
vector195:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $195
8010639d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063a2:	e9 83 f3 ff ff       	jmp    8010572a <alltraps>

801063a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $196
801063a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063ae:	e9 77 f3 ff ff       	jmp    8010572a <alltraps>

801063b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $197
801063b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063ba:	e9 6b f3 ff ff       	jmp    8010572a <alltraps>

801063bf <vector198>:
.globl vector198
vector198:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $198
801063c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063c6:	e9 5f f3 ff ff       	jmp    8010572a <alltraps>

801063cb <vector199>:
.globl vector199
vector199:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $199
801063cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063d2:	e9 53 f3 ff ff       	jmp    8010572a <alltraps>

801063d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $200
801063d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063de:	e9 47 f3 ff ff       	jmp    8010572a <alltraps>

801063e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $201
801063e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063ea:	e9 3b f3 ff ff       	jmp    8010572a <alltraps>

801063ef <vector202>:
.globl vector202
vector202:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $202
801063f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063f6:	e9 2f f3 ff ff       	jmp    8010572a <alltraps>

801063fb <vector203>:
.globl vector203
vector203:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $203
801063fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106402:	e9 23 f3 ff ff       	jmp    8010572a <alltraps>

80106407 <vector204>:
.globl vector204
vector204:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $204
80106409:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010640e:	e9 17 f3 ff ff       	jmp    8010572a <alltraps>

80106413 <vector205>:
.globl vector205
vector205:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $205
80106415:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010641a:	e9 0b f3 ff ff       	jmp    8010572a <alltraps>

8010641f <vector206>:
.globl vector206
vector206:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $206
80106421:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106426:	e9 ff f2 ff ff       	jmp    8010572a <alltraps>

8010642b <vector207>:
.globl vector207
vector207:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $207
8010642d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106432:	e9 f3 f2 ff ff       	jmp    8010572a <alltraps>

80106437 <vector208>:
.globl vector208
vector208:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $208
80106439:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010643e:	e9 e7 f2 ff ff       	jmp    8010572a <alltraps>

80106443 <vector209>:
.globl vector209
vector209:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $209
80106445:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010644a:	e9 db f2 ff ff       	jmp    8010572a <alltraps>

8010644f <vector210>:
.globl vector210
vector210:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $210
80106451:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106456:	e9 cf f2 ff ff       	jmp    8010572a <alltraps>

8010645b <vector211>:
.globl vector211
vector211:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $211
8010645d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106462:	e9 c3 f2 ff ff       	jmp    8010572a <alltraps>

80106467 <vector212>:
.globl vector212
vector212:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $212
80106469:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010646e:	e9 b7 f2 ff ff       	jmp    8010572a <alltraps>

80106473 <vector213>:
.globl vector213
vector213:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $213
80106475:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010647a:	e9 ab f2 ff ff       	jmp    8010572a <alltraps>

8010647f <vector214>:
.globl vector214
vector214:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $214
80106481:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106486:	e9 9f f2 ff ff       	jmp    8010572a <alltraps>

8010648b <vector215>:
.globl vector215
vector215:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $215
8010648d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106492:	e9 93 f2 ff ff       	jmp    8010572a <alltraps>

80106497 <vector216>:
.globl vector216
vector216:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $216
80106499:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010649e:	e9 87 f2 ff ff       	jmp    8010572a <alltraps>

801064a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $217
801064a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064aa:	e9 7b f2 ff ff       	jmp    8010572a <alltraps>

801064af <vector218>:
.globl vector218
vector218:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $218
801064b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064b6:	e9 6f f2 ff ff       	jmp    8010572a <alltraps>

801064bb <vector219>:
.globl vector219
vector219:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $219
801064bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064c2:	e9 63 f2 ff ff       	jmp    8010572a <alltraps>

801064c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $220
801064c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064ce:	e9 57 f2 ff ff       	jmp    8010572a <alltraps>

801064d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $221
801064d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064da:	e9 4b f2 ff ff       	jmp    8010572a <alltraps>

801064df <vector222>:
.globl vector222
vector222:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $222
801064e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064e6:	e9 3f f2 ff ff       	jmp    8010572a <alltraps>

801064eb <vector223>:
.globl vector223
vector223:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $223
801064ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064f2:	e9 33 f2 ff ff       	jmp    8010572a <alltraps>

801064f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $224
801064f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064fe:	e9 27 f2 ff ff       	jmp    8010572a <alltraps>

80106503 <vector225>:
.globl vector225
vector225:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $225
80106505:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010650a:	e9 1b f2 ff ff       	jmp    8010572a <alltraps>

8010650f <vector226>:
.globl vector226
vector226:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $226
80106511:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106516:	e9 0f f2 ff ff       	jmp    8010572a <alltraps>

8010651b <vector227>:
.globl vector227
vector227:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $227
8010651d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106522:	e9 03 f2 ff ff       	jmp    8010572a <alltraps>

80106527 <vector228>:
.globl vector228
vector228:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $228
80106529:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010652e:	e9 f7 f1 ff ff       	jmp    8010572a <alltraps>

80106533 <vector229>:
.globl vector229
vector229:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $229
80106535:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010653a:	e9 eb f1 ff ff       	jmp    8010572a <alltraps>

8010653f <vector230>:
.globl vector230
vector230:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $230
80106541:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106546:	e9 df f1 ff ff       	jmp    8010572a <alltraps>

8010654b <vector231>:
.globl vector231
vector231:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $231
8010654d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106552:	e9 d3 f1 ff ff       	jmp    8010572a <alltraps>

80106557 <vector232>:
.globl vector232
vector232:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $232
80106559:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010655e:	e9 c7 f1 ff ff       	jmp    8010572a <alltraps>

80106563 <vector233>:
.globl vector233
vector233:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $233
80106565:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010656a:	e9 bb f1 ff ff       	jmp    8010572a <alltraps>

8010656f <vector234>:
.globl vector234
vector234:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $234
80106571:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106576:	e9 af f1 ff ff       	jmp    8010572a <alltraps>

8010657b <vector235>:
.globl vector235
vector235:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $235
8010657d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106582:	e9 a3 f1 ff ff       	jmp    8010572a <alltraps>

80106587 <vector236>:
.globl vector236
vector236:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $236
80106589:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010658e:	e9 97 f1 ff ff       	jmp    8010572a <alltraps>

80106593 <vector237>:
.globl vector237
vector237:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $237
80106595:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010659a:	e9 8b f1 ff ff       	jmp    8010572a <alltraps>

8010659f <vector238>:
.globl vector238
vector238:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $238
801065a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065a6:	e9 7f f1 ff ff       	jmp    8010572a <alltraps>

801065ab <vector239>:
.globl vector239
vector239:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $239
801065ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065b2:	e9 73 f1 ff ff       	jmp    8010572a <alltraps>

801065b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $240
801065b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065be:	e9 67 f1 ff ff       	jmp    8010572a <alltraps>

801065c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $241
801065c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065ca:	e9 5b f1 ff ff       	jmp    8010572a <alltraps>

801065cf <vector242>:
.globl vector242
vector242:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $242
801065d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065d6:	e9 4f f1 ff ff       	jmp    8010572a <alltraps>

801065db <vector243>:
.globl vector243
vector243:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $243
801065dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065e2:	e9 43 f1 ff ff       	jmp    8010572a <alltraps>

801065e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $244
801065e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065ee:	e9 37 f1 ff ff       	jmp    8010572a <alltraps>

801065f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $245
801065f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065fa:	e9 2b f1 ff ff       	jmp    8010572a <alltraps>

801065ff <vector246>:
.globl vector246
vector246:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $246
80106601:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106606:	e9 1f f1 ff ff       	jmp    8010572a <alltraps>

8010660b <vector247>:
.globl vector247
vector247:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $247
8010660d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106612:	e9 13 f1 ff ff       	jmp    8010572a <alltraps>

80106617 <vector248>:
.globl vector248
vector248:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $248
80106619:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010661e:	e9 07 f1 ff ff       	jmp    8010572a <alltraps>

80106623 <vector249>:
.globl vector249
vector249:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $249
80106625:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010662a:	e9 fb f0 ff ff       	jmp    8010572a <alltraps>

8010662f <vector250>:
.globl vector250
vector250:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $250
80106631:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106636:	e9 ef f0 ff ff       	jmp    8010572a <alltraps>

8010663b <vector251>:
.globl vector251
vector251:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $251
8010663d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106642:	e9 e3 f0 ff ff       	jmp    8010572a <alltraps>

80106647 <vector252>:
.globl vector252
vector252:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $252
80106649:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010664e:	e9 d7 f0 ff ff       	jmp    8010572a <alltraps>

80106653 <vector253>:
.globl vector253
vector253:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $253
80106655:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010665a:	e9 cb f0 ff ff       	jmp    8010572a <alltraps>

8010665f <vector254>:
.globl vector254
vector254:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $254
80106661:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106666:	e9 bf f0 ff ff       	jmp    8010572a <alltraps>

8010666b <vector255>:
.globl vector255
vector255:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $255
8010666d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106672:	e9 b3 f0 ff ff       	jmp    8010572a <alltraps>
80106677:	66 90                	xchg   %ax,%ax
80106679:	66 90                	xchg   %ax,%ax
8010667b:	66 90                	xchg   %ax,%ax
8010667d:	66 90                	xchg   %ax,%ax
8010667f:	90                   	nop

80106680 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	57                   	push   %edi
80106684:	56                   	push   %esi
80106685:	53                   	push   %ebx
	pde_t *pde;
	pte_t *pgtab;

	pde = &pgdir[PDX(va)];
80106686:	89 d3                	mov    %edx,%ebx
{
80106688:	89 d7                	mov    %edx,%edi
	pde = &pgdir[PDX(va)];
8010668a:	c1 eb 16             	shr    $0x16,%ebx
8010668d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106690:	83 ec 0c             	sub    $0xc,%esp
	if (*pde & PTE_P) {
80106693:	8b 06                	mov    (%esi),%eax
80106695:	a8 01                	test   $0x1,%al
80106697:	74 27                	je     801066c0 <walkpgdir+0x40>
		pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
80106699:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010669e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
		// The permissions here are overly generous, but they can
		// be further restricted by the permissions in the page table
		// entries, if necessary.
		*pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
	}
	return &pgtab[PTX(va)];
801066a4:	c1 ef 0a             	shr    $0xa,%edi
}
801066a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return &pgtab[PTX(va)];
801066aa:	89 fa                	mov    %edi,%edx
801066ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801066b5:	5b                   	pop    %ebx
801066b6:	5e                   	pop    %esi
801066b7:	5f                   	pop    %edi
801066b8:	5d                   	pop    %ebp
801066b9:	c3                   	ret    
801066ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (!alloc || (pgtab = (pte_t *)kalloc()) == 0) return 0;
801066c0:	85 c9                	test   %ecx,%ecx
801066c2:	74 2c                	je     801066f0 <walkpgdir+0x70>
801066c4:	e8 07 be ff ff       	call   801024d0 <kalloc>
801066c9:	85 c0                	test   %eax,%eax
801066cb:	89 c3                	mov    %eax,%ebx
801066cd:	74 21                	je     801066f0 <walkpgdir+0x70>
		memset(pgtab, 0, PGSIZE);
801066cf:	83 ec 04             	sub    $0x4,%esp
801066d2:	68 00 10 00 00       	push   $0x1000
801066d7:	6a 00                	push   $0x0
801066d9:	50                   	push   %eax
801066da:	e8 e1 dd ff ff       	call   801044c0 <memset>
		*pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066e5:	83 c4 10             	add    $0x10,%esp
801066e8:	83 c8 07             	or     $0x7,%eax
801066eb:	89 06                	mov    %eax,(%esi)
801066ed:	eb b5                	jmp    801066a4 <walkpgdir+0x24>
801066ef:	90                   	nop
}
801066f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (!alloc || (pgtab = (pte_t *)kalloc()) == 0) return 0;
801066f3:	31 c0                	xor    %eax,%eax
}
801066f5:	5b                   	pop    %ebx
801066f6:	5e                   	pop    %esi
801066f7:	5f                   	pop    %edi
801066f8:	5d                   	pop    %ebp
801066f9:	c3                   	ret    
801066fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106700 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	57                   	push   %edi
80106704:	56                   	push   %esi
80106705:	53                   	push   %ebx
	char * a, *last;
	pte_t *pte;

	a    = (char *)PGROUNDDOWN((uint)va);
80106706:	89 d3                	mov    %edx,%ebx
80106708:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010670e:	83 ec 1c             	sub    $0x1c,%esp
80106711:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80106714:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106718:	8b 7d 08             	mov    0x8(%ebp),%edi
8010671b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106720:	89 45 e0             	mov    %eax,-0x20(%ebp)
	for (;;) {
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
		if (*pte & PTE_P) panic("remap");
		*pte = pa | perm | PTE_P;
80106723:	8b 45 0c             	mov    0xc(%ebp),%eax
80106726:	29 df                	sub    %ebx,%edi
80106728:	83 c8 01             	or     $0x1,%eax
8010672b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010672e:	eb 15                	jmp    80106745 <mappages+0x45>
		if (*pte & PTE_P) panic("remap");
80106730:	f6 00 01             	testb  $0x1,(%eax)
80106733:	75 45                	jne    8010677a <mappages+0x7a>
		*pte = pa | perm | PTE_P;
80106735:	0b 75 dc             	or     -0x24(%ebp),%esi
		if (a == last) break;
80106738:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
		*pte = pa | perm | PTE_P;
8010673b:	89 30                	mov    %esi,(%eax)
		if (a == last) break;
8010673d:	74 31                	je     80106770 <mappages+0x70>
		a += PGSIZE;
8010673f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
80106745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106748:	b9 01 00 00 00       	mov    $0x1,%ecx
8010674d:	89 da                	mov    %ebx,%edx
8010674f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106752:	e8 29 ff ff ff       	call   80106680 <walkpgdir>
80106757:	85 c0                	test   %eax,%eax
80106759:	75 d5                	jne    80106730 <mappages+0x30>
		pa += PGSIZE;
	}
	return 0;
}
8010675b:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
8010675e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106763:	5b                   	pop    %ebx
80106764:	5e                   	pop    %esi
80106765:	5f                   	pop    %edi
80106766:	5d                   	pop    %ebp
80106767:	c3                   	ret    
80106768:	90                   	nop
80106769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106770:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80106773:	31 c0                	xor    %eax,%eax
}
80106775:	5b                   	pop    %ebx
80106776:	5e                   	pop    %esi
80106777:	5f                   	pop    %edi
80106778:	5d                   	pop    %ebp
80106779:	c3                   	ret    
		if (*pte & PTE_P) panic("remap");
8010677a:	83 ec 0c             	sub    $0xc,%esp
8010677d:	68 78 78 10 80       	push   $0x80107878
80106782:	e8 09 9c ff ff       	call   80100390 <panic>
80106787:	89 f6                	mov    %esi,%esi
80106789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106790 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106790:	55                   	push   %ebp
80106791:	89 e5                	mov    %esp,%ebp
80106793:	57                   	push   %edi
80106794:	56                   	push   %esi
80106795:	53                   	push   %ebx
	pte_t *pte;
	uint   a, pa;

	if (newsz >= oldsz) return oldsz;

	a = PGROUNDUP(newsz);
80106796:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010679c:	89 c7                	mov    %eax,%edi
	a = PGROUNDUP(newsz);
8010679e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067a4:	83 ec 1c             	sub    $0x1c,%esp
801067a7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	for (; a < oldsz; a += PGSIZE) {
801067aa:	39 d3                	cmp    %edx,%ebx
801067ac:	73 66                	jae    80106814 <deallocuvm.part.0+0x84>
801067ae:	89 d6                	mov    %edx,%esi
801067b0:	eb 3d                	jmp    801067ef <deallocuvm.part.0+0x5f>
801067b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		pte = walkpgdir(pgdir, (char *)a, 0);
		if (!pte)
			a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
		else if ((*pte & PTE_P) != 0) {
801067b8:	8b 10                	mov    (%eax),%edx
801067ba:	f6 c2 01             	test   $0x1,%dl
801067bd:	74 26                	je     801067e5 <deallocuvm.part.0+0x55>
			pa = PTE_ADDR(*pte);
			if (pa == 0) panic("kfree");
801067bf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067c5:	74 58                	je     8010681f <deallocuvm.part.0+0x8f>
			char *v = P2V(pa);
			kfree(v);
801067c7:	83 ec 0c             	sub    $0xc,%esp
			char *v = P2V(pa);
801067ca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801067d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			kfree(v);
801067d3:	52                   	push   %edx
801067d4:	e8 47 bb ff ff       	call   80102320 <kfree>
			*pte = 0;
801067d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067dc:	83 c4 10             	add    $0x10,%esp
801067df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (; a < oldsz; a += PGSIZE) {
801067e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067eb:	39 f3                	cmp    %esi,%ebx
801067ed:	73 25                	jae    80106814 <deallocuvm.part.0+0x84>
		pte = walkpgdir(pgdir, (char *)a, 0);
801067ef:	31 c9                	xor    %ecx,%ecx
801067f1:	89 da                	mov    %ebx,%edx
801067f3:	89 f8                	mov    %edi,%eax
801067f5:	e8 86 fe ff ff       	call   80106680 <walkpgdir>
		if (!pte)
801067fa:	85 c0                	test   %eax,%eax
801067fc:	75 ba                	jne    801067b8 <deallocuvm.part.0+0x28>
			a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067fe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106804:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
	for (; a < oldsz; a += PGSIZE) {
8010680a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106810:	39 f3                	cmp    %esi,%ebx
80106812:	72 db                	jb     801067ef <deallocuvm.part.0+0x5f>
		}
	}
	return newsz;
}
80106814:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106817:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010681a:	5b                   	pop    %ebx
8010681b:	5e                   	pop    %esi
8010681c:	5f                   	pop    %edi
8010681d:	5d                   	pop    %ebp
8010681e:	c3                   	ret    
			if (pa == 0) panic("kfree");
8010681f:	83 ec 0c             	sub    $0xc,%esp
80106822:	68 06 72 10 80       	push   $0x80107206
80106827:	e8 64 9b ff ff       	call   80100390 <panic>
8010682c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106830 <seginit>:
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	83 ec 18             	sub    $0x18,%esp
	c                 = &cpus[cpuid()];
80106836:	e8 b5 cf ff ff       	call   801037f0 <cpuid>
8010683b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
	pd[0] = size - 1;
80106841:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106846:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
	c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010684a:	c7 80 b8 2c 11 80 ff 	movl   $0xffff,-0x7feed348(%eax)
80106851:	ff 00 00 
80106854:	c7 80 bc 2c 11 80 00 	movl   $0xcf9a00,-0x7feed344(%eax)
8010685b:	9a cf 00 
	c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010685e:	c7 80 c0 2c 11 80 ff 	movl   $0xffff,-0x7feed340(%eax)
80106865:	ff 00 00 
80106868:	c7 80 c4 2c 11 80 00 	movl   $0xcf9200,-0x7feed33c(%eax)
8010686f:	92 cf 00 
	c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80106872:	c7 80 c8 2c 11 80 ff 	movl   $0xffff,-0x7feed338(%eax)
80106879:	ff 00 00 
8010687c:	c7 80 cc 2c 11 80 00 	movl   $0xcffa00,-0x7feed334(%eax)
80106883:	fa cf 00 
	c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106886:	c7 80 d0 2c 11 80 ff 	movl   $0xffff,-0x7feed330(%eax)
8010688d:	ff 00 00 
80106890:	c7 80 d4 2c 11 80 00 	movl   $0xcff200,-0x7feed32c(%eax)
80106897:	f2 cf 00 
	lgdt(c->gdt, sizeof(c->gdt));
8010689a:	05 b0 2c 11 80       	add    $0x80112cb0,%eax
	pd[1] = (uint)p;
8010689f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
	pd[2] = (uint)p >> 16;
801068a3:	c1 e8 10             	shr    $0x10,%eax
801068a6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
	asm volatile("lgdt (%0)" : : "r"(pd));
801068aa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068ad:	0f 01 10             	lgdtl  (%eax)
}
801068b0:	c9                   	leave  
801068b1:	c3                   	ret    
801068b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068c0 <switchkvm>:
	lcr3(V2P(kpgdir)); // switch to the kernel page table
801068c0:	a1 64 6d 11 80       	mov    0x80116d64,%eax
{
801068c5:	55                   	push   %ebp
801068c6:	89 e5                	mov    %esp,%ebp
	lcr3(V2P(kpgdir)); // switch to the kernel page table
801068c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
	asm volatile("movl %0,%%cr3" : : "r"(val));
801068cd:	0f 22 d8             	mov    %eax,%cr3
}
801068d0:	5d                   	pop    %ebp
801068d1:	c3                   	ret    
801068d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068e0 <switchuvm>:
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	57                   	push   %edi
801068e4:	56                   	push   %esi
801068e5:	53                   	push   %ebx
801068e6:	83 ec 1c             	sub    $0x1c,%esp
801068e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (p == 0) panic("switchuvm: no process");
801068ec:	85 db                	test   %ebx,%ebx
801068ee:	0f 84 cb 00 00 00    	je     801069bf <switchuvm+0xdf>
	if (p->kstack == 0) panic("switchuvm: no kstack");
801068f4:	8b 43 08             	mov    0x8(%ebx),%eax
801068f7:	85 c0                	test   %eax,%eax
801068f9:	0f 84 da 00 00 00    	je     801069d9 <switchuvm+0xf9>
	if (p->pgdir == 0) panic("switchuvm: no pgdir");
801068ff:	8b 43 04             	mov    0x4(%ebx),%eax
80106902:	85 c0                	test   %eax,%eax
80106904:	0f 84 c2 00 00 00    	je     801069cc <switchuvm+0xec>
	pushcli();
8010690a:	e8 f1 d9 ff ff       	call   80104300 <pushcli>
	mycpu()->gdt[SEG_TSS]   = SEG16(STS_T32A, &mycpu()->ts, sizeof(mycpu()->ts) - 1, 0);
8010690f:	e8 5c ce ff ff       	call   80103770 <mycpu>
80106914:	89 c6                	mov    %eax,%esi
80106916:	e8 55 ce ff ff       	call   80103770 <mycpu>
8010691b:	89 c7                	mov    %eax,%edi
8010691d:	e8 4e ce ff ff       	call   80103770 <mycpu>
80106922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106925:	83 c7 08             	add    $0x8,%edi
80106928:	e8 43 ce ff ff       	call   80103770 <mycpu>
8010692d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106930:	83 c0 08             	add    $0x8,%eax
80106933:	ba 67 00 00 00       	mov    $0x67,%edx
80106938:	c1 e8 18             	shr    $0x18,%eax
8010693b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106942:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106949:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
	mycpu()->ts.iomb = (ushort)0xFFFF;
8010694f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	mycpu()->gdt[SEG_TSS]   = SEG16(STS_T32A, &mycpu()->ts, sizeof(mycpu()->ts) - 1, 0);
80106954:	83 c1 08             	add    $0x8,%ecx
80106957:	c1 e9 10             	shr    $0x10,%ecx
8010695a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106960:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106965:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
	mycpu()->ts.ss0         = SEG_KDATA << 3;
8010696c:	be 10 00 00 00       	mov    $0x10,%esi
	mycpu()->gdt[SEG_TSS].s = 0;
80106971:	e8 fa cd ff ff       	call   80103770 <mycpu>
80106976:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
	mycpu()->ts.ss0         = SEG_KDATA << 3;
8010697d:	e8 ee cd ff ff       	call   80103770 <mycpu>
80106982:	66 89 70 10          	mov    %si,0x10(%eax)
	mycpu()->ts.esp0        = (uint)p->kstack + KSTACKSIZE;
80106986:	8b 73 08             	mov    0x8(%ebx),%esi
80106989:	e8 e2 cd ff ff       	call   80103770 <mycpu>
8010698e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106994:	89 70 0c             	mov    %esi,0xc(%eax)
	mycpu()->ts.iomb = (ushort)0xFFFF;
80106997:	e8 d4 cd ff ff       	call   80103770 <mycpu>
8010699c:	66 89 78 6e          	mov    %di,0x6e(%eax)
	asm volatile("ltr %0" : : "r"(sel));
801069a0:	b8 28 00 00 00       	mov    $0x28,%eax
801069a5:	0f 00 d8             	ltr    %ax
	lcr3(V2P(p->pgdir)); // switch to process's address space
801069a8:	8b 43 04             	mov    0x4(%ebx),%eax
801069ab:	05 00 00 00 80       	add    $0x80000000,%eax
	asm volatile("movl %0,%%cr3" : : "r"(val));
801069b0:	0f 22 d8             	mov    %eax,%cr3
}
801069b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069b6:	5b                   	pop    %ebx
801069b7:	5e                   	pop    %esi
801069b8:	5f                   	pop    %edi
801069b9:	5d                   	pop    %ebp
	popcli();
801069ba:	e9 41 da ff ff       	jmp    80104400 <popcli>
	if (p == 0) panic("switchuvm: no process");
801069bf:	83 ec 0c             	sub    $0xc,%esp
801069c2:	68 7e 78 10 80       	push   $0x8010787e
801069c7:	e8 c4 99 ff ff       	call   80100390 <panic>
	if (p->pgdir == 0) panic("switchuvm: no pgdir");
801069cc:	83 ec 0c             	sub    $0xc,%esp
801069cf:	68 a9 78 10 80       	push   $0x801078a9
801069d4:	e8 b7 99 ff ff       	call   80100390 <panic>
	if (p->kstack == 0) panic("switchuvm: no kstack");
801069d9:	83 ec 0c             	sub    $0xc,%esp
801069dc:	68 94 78 10 80       	push   $0x80107894
801069e1:	e8 aa 99 ff ff       	call   80100390 <panic>
801069e6:	8d 76 00             	lea    0x0(%esi),%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069f0 <inituvm>:
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
801069f6:	83 ec 1c             	sub    $0x1c,%esp
801069f9:	8b 75 10             	mov    0x10(%ebp),%esi
801069fc:	8b 45 08             	mov    0x8(%ebp),%eax
801069ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (sz >= PGSIZE) panic("inituvm: more than a page");
80106a02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106a08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (sz >= PGSIZE) panic("inituvm: more than a page");
80106a0b:	77 49                	ja     80106a56 <inituvm+0x66>
	mem = kalloc();
80106a0d:	e8 be ba ff ff       	call   801024d0 <kalloc>
	memset(mem, 0, PGSIZE);
80106a12:	83 ec 04             	sub    $0x4,%esp
	mem = kalloc();
80106a15:	89 c3                	mov    %eax,%ebx
	memset(mem, 0, PGSIZE);
80106a17:	68 00 10 00 00       	push   $0x1000
80106a1c:	6a 00                	push   $0x0
80106a1e:	50                   	push   %eax
80106a1f:	e8 9c da ff ff       	call   801044c0 <memset>
	mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80106a24:	58                   	pop    %eax
80106a25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a2b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a30:	5a                   	pop    %edx
80106a31:	6a 06                	push   $0x6
80106a33:	50                   	push   %eax
80106a34:	31 d2                	xor    %edx,%edx
80106a36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a39:	e8 c2 fc ff ff       	call   80106700 <mappages>
	memmove(mem, init, sz);
80106a3e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a41:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a44:	83 c4 10             	add    $0x10,%esp
80106a47:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a4d:	5b                   	pop    %ebx
80106a4e:	5e                   	pop    %esi
80106a4f:	5f                   	pop    %edi
80106a50:	5d                   	pop    %ebp
	memmove(mem, init, sz);
80106a51:	e9 1a db ff ff       	jmp    80104570 <memmove>
	if (sz >= PGSIZE) panic("inituvm: more than a page");
80106a56:	83 ec 0c             	sub    $0xc,%esp
80106a59:	68 bd 78 10 80       	push   $0x801078bd
80106a5e:	e8 2d 99 ff ff       	call   80100390 <panic>
80106a63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a70 <loaduvm>:
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	56                   	push   %esi
80106a75:	53                   	push   %ebx
80106a76:	83 ec 0c             	sub    $0xc,%esp
	if ((uint)addr % PGSIZE != 0) panic("loaduvm: addr must be page aligned");
80106a79:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a80:	0f 85 91 00 00 00    	jne    80106b17 <loaduvm+0xa7>
	for (i = 0; i < sz; i += PGSIZE) {
80106a86:	8b 75 18             	mov    0x18(%ebp),%esi
80106a89:	31 db                	xor    %ebx,%ebx
80106a8b:	85 f6                	test   %esi,%esi
80106a8d:	75 1a                	jne    80106aa9 <loaduvm+0x39>
80106a8f:	eb 6f                	jmp    80106b00 <loaduvm+0x90>
80106a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a9e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106aa4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106aa7:	76 57                	jbe    80106b00 <loaduvm+0x90>
		if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) panic("loaduvm: address should exist");
80106aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106aac:	8b 45 08             	mov    0x8(%ebp),%eax
80106aaf:	31 c9                	xor    %ecx,%ecx
80106ab1:	01 da                	add    %ebx,%edx
80106ab3:	e8 c8 fb ff ff       	call   80106680 <walkpgdir>
80106ab8:	85 c0                	test   %eax,%eax
80106aba:	74 4e                	je     80106b0a <loaduvm+0x9a>
		pa = PTE_ADDR(*pte);
80106abc:	8b 00                	mov    (%eax),%eax
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80106abe:	8b 4d 14             	mov    0x14(%ebp),%ecx
		if (sz - i < PGSIZE)
80106ac1:	bf 00 10 00 00       	mov    $0x1000,%edi
		pa = PTE_ADDR(*pte);
80106ac6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		if (sz - i < PGSIZE)
80106acb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ad1:	0f 46 fe             	cmovbe %esi,%edi
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80106ad4:	01 d9                	add    %ebx,%ecx
80106ad6:	05 00 00 00 80       	add    $0x80000000,%eax
80106adb:	57                   	push   %edi
80106adc:	51                   	push   %ecx
80106add:	50                   	push   %eax
80106ade:	ff 75 10             	pushl  0x10(%ebp)
80106ae1:	e8 8a ae ff ff       	call   80101970 <readi>
80106ae6:	83 c4 10             	add    $0x10,%esp
80106ae9:	39 f8                	cmp    %edi,%eax
80106aeb:	74 ab                	je     80106a98 <loaduvm+0x28>
}
80106aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80106af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5f                   	pop    %edi
80106af8:	5d                   	pop    %ebp
80106af9:	c3                   	ret    
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b00:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80106b03:	31 c0                	xor    %eax,%eax
}
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5f                   	pop    %edi
80106b08:	5d                   	pop    %ebp
80106b09:	c3                   	ret    
		if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) panic("loaduvm: address should exist");
80106b0a:	83 ec 0c             	sub    $0xc,%esp
80106b0d:	68 d7 78 10 80       	push   $0x801078d7
80106b12:	e8 79 98 ff ff       	call   80100390 <panic>
	if ((uint)addr % PGSIZE != 0) panic("loaduvm: addr must be page aligned");
80106b17:	83 ec 0c             	sub    $0xc,%esp
80106b1a:	68 78 79 10 80       	push   $0x80107978
80106b1f:	e8 6c 98 ff ff       	call   80100390 <panic>
80106b24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b30 <allocuvm>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 1c             	sub    $0x1c,%esp
	if (newsz >= KERNBASE) return 0;
80106b39:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b3c:	85 ff                	test   %edi,%edi
80106b3e:	0f 88 8e 00 00 00    	js     80106bd2 <allocuvm+0xa2>
	if (newsz < oldsz) return oldsz;
80106b44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b47:	0f 82 93 00 00 00    	jb     80106be0 <allocuvm+0xb0>
	a = PGROUNDUP(oldsz);
80106b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b50:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b56:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; a < newsz; a += PGSIZE) {
80106b5c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b5f:	0f 86 7e 00 00 00    	jbe    80106be3 <allocuvm+0xb3>
80106b65:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b6b:	eb 42                	jmp    80106baf <allocuvm+0x7f>
80106b6d:	8d 76 00             	lea    0x0(%esi),%esi
		memset(mem, 0, PGSIZE);
80106b70:	83 ec 04             	sub    $0x4,%esp
80106b73:	68 00 10 00 00       	push   $0x1000
80106b78:	6a 00                	push   $0x0
80106b7a:	50                   	push   %eax
80106b7b:	e8 40 d9 ff ff       	call   801044c0 <memset>
		if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80106b80:	58                   	pop    %eax
80106b81:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b87:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b8c:	5a                   	pop    %edx
80106b8d:	6a 06                	push   $0x6
80106b8f:	50                   	push   %eax
80106b90:	89 da                	mov    %ebx,%edx
80106b92:	89 f8                	mov    %edi,%eax
80106b94:	e8 67 fb ff ff       	call   80106700 <mappages>
80106b99:	83 c4 10             	add    $0x10,%esp
80106b9c:	85 c0                	test   %eax,%eax
80106b9e:	78 50                	js     80106bf0 <allocuvm+0xc0>
	for (; a < newsz; a += PGSIZE) {
80106ba0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ba6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106ba9:	0f 86 81 00 00 00    	jbe    80106c30 <allocuvm+0x100>
		mem = kalloc();
80106baf:	e8 1c b9 ff ff       	call   801024d0 <kalloc>
		if (mem == 0) {
80106bb4:	85 c0                	test   %eax,%eax
		mem = kalloc();
80106bb6:	89 c6                	mov    %eax,%esi
		if (mem == 0) {
80106bb8:	75 b6                	jne    80106b70 <allocuvm+0x40>
			cprintf("allocuvm out of memory\n");
80106bba:	83 ec 0c             	sub    $0xc,%esp
80106bbd:	68 f5 78 10 80       	push   $0x801078f5
80106bc2:	e8 99 9a ff ff       	call   80100660 <cprintf>
	if (newsz >= oldsz) return oldsz;
80106bc7:	83 c4 10             	add    $0x10,%esp
80106bca:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bcd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bd0:	77 6e                	ja     80106c40 <allocuvm+0x110>
}
80106bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
	if (newsz >= KERNBASE) return 0;
80106bd5:	31 ff                	xor    %edi,%edi
}
80106bd7:	89 f8                	mov    %edi,%eax
80106bd9:	5b                   	pop    %ebx
80106bda:	5e                   	pop    %esi
80106bdb:	5f                   	pop    %edi
80106bdc:	5d                   	pop    %ebp
80106bdd:	c3                   	ret    
80106bde:	66 90                	xchg   %ax,%ax
	if (newsz < oldsz) return oldsz;
80106be0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be6:	89 f8                	mov    %edi,%eax
80106be8:	5b                   	pop    %ebx
80106be9:	5e                   	pop    %esi
80106bea:	5f                   	pop    %edi
80106beb:	5d                   	pop    %ebp
80106bec:	c3                   	ret    
80106bed:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("allocuvm out of memory (2)\n");
80106bf0:	83 ec 0c             	sub    $0xc,%esp
80106bf3:	68 0d 79 10 80       	push   $0x8010790d
80106bf8:	e8 63 9a ff ff       	call   80100660 <cprintf>
	if (newsz >= oldsz) return oldsz;
80106bfd:	83 c4 10             	add    $0x10,%esp
80106c00:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c03:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c06:	76 0d                	jbe    80106c15 <allocuvm+0xe5>
80106c08:	89 c1                	mov    %eax,%ecx
80106c0a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c10:	e8 7b fb ff ff       	call   80106790 <deallocuvm.part.0>
			kfree(mem);
80106c15:	83 ec 0c             	sub    $0xc,%esp
			return 0;
80106c18:	31 ff                	xor    %edi,%edi
			kfree(mem);
80106c1a:	56                   	push   %esi
80106c1b:	e8 00 b7 ff ff       	call   80102320 <kfree>
			return 0;
80106c20:	83 c4 10             	add    $0x10,%esp
}
80106c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c26:	89 f8                	mov    %edi,%eax
80106c28:	5b                   	pop    %ebx
80106c29:	5e                   	pop    %esi
80106c2a:	5f                   	pop    %edi
80106c2b:	5d                   	pop    %ebp
80106c2c:	c3                   	ret    
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi
80106c30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c36:	5b                   	pop    %ebx
80106c37:	89 f8                	mov    %edi,%eax
80106c39:	5e                   	pop    %esi
80106c3a:	5f                   	pop    %edi
80106c3b:	5d                   	pop    %ebp
80106c3c:	c3                   	ret    
80106c3d:	8d 76 00             	lea    0x0(%esi),%esi
80106c40:	89 c1                	mov    %eax,%ecx
80106c42:	8b 55 10             	mov    0x10(%ebp),%edx
80106c45:	8b 45 08             	mov    0x8(%ebp),%eax
			return 0;
80106c48:	31 ff                	xor    %edi,%edi
80106c4a:	e8 41 fb ff ff       	call   80106790 <deallocuvm.part.0>
80106c4f:	eb 92                	jmp    80106be3 <allocuvm+0xb3>
80106c51:	eb 0d                	jmp    80106c60 <deallocuvm>
80106c53:	90                   	nop
80106c54:	90                   	nop
80106c55:	90                   	nop
80106c56:	90                   	nop
80106c57:	90                   	nop
80106c58:	90                   	nop
80106c59:	90                   	nop
80106c5a:	90                   	nop
80106c5b:	90                   	nop
80106c5c:	90                   	nop
80106c5d:	90                   	nop
80106c5e:	90                   	nop
80106c5f:	90                   	nop

80106c60 <deallocuvm>:
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c69:	8b 45 08             	mov    0x8(%ebp),%eax
	if (newsz >= oldsz) return oldsz;
80106c6c:	39 d1                	cmp    %edx,%ecx
80106c6e:	73 10                	jae    80106c80 <deallocuvm+0x20>
}
80106c70:	5d                   	pop    %ebp
80106c71:	e9 1a fb ff ff       	jmp    80106790 <deallocuvm.part.0>
80106c76:	8d 76 00             	lea    0x0(%esi),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c80:	89 d0                	mov    %edx,%eax
80106c82:	5d                   	pop    %ebp
80106c83:	c3                   	ret    
80106c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 0c             	sub    $0xc,%esp
80106c99:	8b 75 08             	mov    0x8(%ebp),%esi
	uint i;

	if (pgdir == 0) panic("freevm: no pgdir");
80106c9c:	85 f6                	test   %esi,%esi
80106c9e:	74 59                	je     80106cf9 <freevm+0x69>
80106ca0:	31 c9                	xor    %ecx,%ecx
80106ca2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ca7:	89 f0                	mov    %esi,%eax
80106ca9:	e8 e2 fa ff ff       	call   80106790 <deallocuvm.part.0>
80106cae:	89 f3                	mov    %esi,%ebx
80106cb0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106cb6:	eb 0f                	jmp    80106cc7 <freevm+0x37>
80106cb8:	90                   	nop
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc0:	83 c3 04             	add    $0x4,%ebx
	deallocuvm(pgdir, KERNBASE, 0);
	for (i = 0; i < NPDENTRIES; i++) {
80106cc3:	39 fb                	cmp    %edi,%ebx
80106cc5:	74 23                	je     80106cea <freevm+0x5a>
		if (pgdir[i] & PTE_P) {
80106cc7:	8b 03                	mov    (%ebx),%eax
80106cc9:	a8 01                	test   $0x1,%al
80106ccb:	74 f3                	je     80106cc0 <freevm+0x30>
			char *v = P2V(PTE_ADDR(pgdir[i]));
80106ccd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
			kfree(v);
80106cd2:	83 ec 0c             	sub    $0xc,%esp
80106cd5:	83 c3 04             	add    $0x4,%ebx
			char *v = P2V(PTE_ADDR(pgdir[i]));
80106cd8:	05 00 00 00 80       	add    $0x80000000,%eax
			kfree(v);
80106cdd:	50                   	push   %eax
80106cde:	e8 3d b6 ff ff       	call   80102320 <kfree>
80106ce3:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPDENTRIES; i++) {
80106ce6:	39 fb                	cmp    %edi,%ebx
80106ce8:	75 dd                	jne    80106cc7 <freevm+0x37>
		}
	}
	kfree((char *)pgdir);
80106cea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cf0:	5b                   	pop    %ebx
80106cf1:	5e                   	pop    %esi
80106cf2:	5f                   	pop    %edi
80106cf3:	5d                   	pop    %ebp
	kfree((char *)pgdir);
80106cf4:	e9 27 b6 ff ff       	jmp    80102320 <kfree>
	if (pgdir == 0) panic("freevm: no pgdir");
80106cf9:	83 ec 0c             	sub    $0xc,%esp
80106cfc:	68 29 79 10 80       	push   $0x80107929
80106d01:	e8 8a 96 ff ff       	call   80100390 <panic>
80106d06:	8d 76 00             	lea    0x0(%esi),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d10 <setupkvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	56                   	push   %esi
80106d14:	53                   	push   %ebx
	if ((pgdir = (pde_t *)kalloc()) == 0) return 0;
80106d15:	e8 b6 b7 ff ff       	call   801024d0 <kalloc>
80106d1a:	85 c0                	test   %eax,%eax
80106d1c:	89 c6                	mov    %eax,%esi
80106d1e:	74 42                	je     80106d62 <setupkvm+0x52>
	memset(pgdir, 0, PGSIZE);
80106d20:	83 ec 04             	sub    $0x4,%esp
	for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d23:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
	memset(pgdir, 0, PGSIZE);
80106d28:	68 00 10 00 00       	push   $0x1000
80106d2d:	6a 00                	push   $0x0
80106d2f:	50                   	push   %eax
80106d30:	e8 8b d7 ff ff       	call   801044c0 <memset>
80106d35:	83 c4 10             	add    $0x10,%esp
		if (mappages(pgdir, k->virt, k->phys_end - k->phys_start, (uint)k->phys_start, k->perm) < 0) {
80106d38:	8b 43 04             	mov    0x4(%ebx),%eax
80106d3b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d3e:	83 ec 08             	sub    $0x8,%esp
80106d41:	8b 13                	mov    (%ebx),%edx
80106d43:	ff 73 0c             	pushl  0xc(%ebx)
80106d46:	50                   	push   %eax
80106d47:	29 c1                	sub    %eax,%ecx
80106d49:	89 f0                	mov    %esi,%eax
80106d4b:	e8 b0 f9 ff ff       	call   80106700 <mappages>
80106d50:	83 c4 10             	add    $0x10,%esp
80106d53:	85 c0                	test   %eax,%eax
80106d55:	78 19                	js     80106d70 <setupkvm+0x60>
	for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d57:	83 c3 10             	add    $0x10,%ebx
80106d5a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d60:	75 d6                	jne    80106d38 <setupkvm+0x28>
}
80106d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d65:	89 f0                	mov    %esi,%eax
80106d67:	5b                   	pop    %ebx
80106d68:	5e                   	pop    %esi
80106d69:	5d                   	pop    %ebp
80106d6a:	c3                   	ret    
80106d6b:	90                   	nop
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			freevm(pgdir);
80106d70:	83 ec 0c             	sub    $0xc,%esp
80106d73:	56                   	push   %esi
			return 0;
80106d74:	31 f6                	xor    %esi,%esi
			freevm(pgdir);
80106d76:	e8 15 ff ff ff       	call   80106c90 <freevm>
			return 0;
80106d7b:	83 c4 10             	add    $0x10,%esp
}
80106d7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d81:	89 f0                	mov    %esi,%eax
80106d83:	5b                   	pop    %ebx
80106d84:	5e                   	pop    %esi
80106d85:	5d                   	pop    %ebp
80106d86:	c3                   	ret    
80106d87:	89 f6                	mov    %esi,%esi
80106d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d90 <kvmalloc>:
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 08             	sub    $0x8,%esp
	kpgdir = setupkvm();
80106d96:	e8 75 ff ff ff       	call   80106d10 <setupkvm>
80106d9b:	a3 64 6d 11 80       	mov    %eax,0x80116d64
	lcr3(V2P(kpgdir)); // switch to the kernel page table
80106da0:	05 00 00 00 80       	add    $0x80000000,%eax
80106da5:	0f 22 d8             	mov    %eax,%cr3
}
80106da8:	c9                   	leave  
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106db0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106db0:	55                   	push   %ebp
	pte_t *pte;

	pte = walkpgdir(pgdir, uva, 0);
80106db1:	31 c9                	xor    %ecx,%ecx
{
80106db3:	89 e5                	mov    %esp,%ebp
80106db5:	83 ec 08             	sub    $0x8,%esp
	pte = walkpgdir(pgdir, uva, 0);
80106db8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbe:	e8 bd f8 ff ff       	call   80106680 <walkpgdir>
	if (pte == 0) panic("clearpteu");
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	74 05                	je     80106dcc <clearpteu+0x1c>
	*pte &= ~PTE_U;
80106dc7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dca:	c9                   	leave  
80106dcb:	c3                   	ret    
	if (pte == 0) panic("clearpteu");
80106dcc:	83 ec 0c             	sub    $0xc,%esp
80106dcf:	68 3a 79 10 80       	push   $0x8010793a
80106dd4:	e8 b7 95 ff ff       	call   80100390 <panic>
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106de0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz)
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 1c             	sub    $0x1c,%esp
	pde_t *d;
	pte_t *pte;
	uint   pa, i, flags;
	char * mem;

	if ((d = setupkvm()) == 0) return 0;
80106de9:	e8 22 ff ff ff       	call   80106d10 <setupkvm>
80106dee:	85 c0                	test   %eax,%eax
80106df0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106df3:	0f 84 a0 00 00 00    	je     80106e99 <copyuvm+0xb9>
	for (i = 0; i < sz; i += PGSIZE) {
80106df9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dfc:	85 c9                	test   %ecx,%ecx
80106dfe:	0f 84 95 00 00 00    	je     80106e99 <copyuvm+0xb9>
80106e04:	31 f6                	xor    %esi,%esi
80106e06:	eb 4e                	jmp    80106e56 <copyuvm+0x76>
80106e08:	90                   	nop
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
		pa    = PTE_ADDR(*pte);
		flags = PTE_FLAGS(*pte);
		if ((mem = kalloc()) == 0) goto bad;
		memmove(mem, (char *)P2V(pa), PGSIZE);
80106e10:	83 ec 04             	sub    $0x4,%esp
80106e13:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e1c:	68 00 10 00 00       	push   $0x1000
80106e21:	57                   	push   %edi
80106e22:	50                   	push   %eax
80106e23:	e8 48 d7 ff ff       	call   80104570 <memmove>
		if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0) goto bad;
80106e28:	58                   	pop    %eax
80106e29:	5a                   	pop    %edx
80106e2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e30:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e35:	53                   	push   %ebx
80106e36:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e3c:	52                   	push   %edx
80106e3d:	89 f2                	mov    %esi,%edx
80106e3f:	e8 bc f8 ff ff       	call   80106700 <mappages>
80106e44:	83 c4 10             	add    $0x10,%esp
80106e47:	85 c0                	test   %eax,%eax
80106e49:	78 39                	js     80106e84 <copyuvm+0xa4>
	for (i = 0; i < sz; i += PGSIZE) {
80106e4b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e51:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106e54:	76 43                	jbe    80106e99 <copyuvm+0xb9>
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
80106e56:	8b 45 08             	mov    0x8(%ebp),%eax
80106e59:	31 c9                	xor    %ecx,%ecx
80106e5b:	89 f2                	mov    %esi,%edx
80106e5d:	e8 1e f8 ff ff       	call   80106680 <walkpgdir>
80106e62:	85 c0                	test   %eax,%eax
80106e64:	74 3e                	je     80106ea4 <copyuvm+0xc4>
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
80106e66:	8b 18                	mov    (%eax),%ebx
80106e68:	f6 c3 01             	test   $0x1,%bl
80106e6b:	74 44                	je     80106eb1 <copyuvm+0xd1>
		pa    = PTE_ADDR(*pte);
80106e6d:	89 df                	mov    %ebx,%edi
		flags = PTE_FLAGS(*pte);
80106e6f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
		pa    = PTE_ADDR(*pte);
80106e75:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
		if ((mem = kalloc()) == 0) goto bad;
80106e7b:	e8 50 b6 ff ff       	call   801024d0 <kalloc>
80106e80:	85 c0                	test   %eax,%eax
80106e82:	75 8c                	jne    80106e10 <copyuvm+0x30>
	}
	return d;

bad:
	freevm(d);
80106e84:	83 ec 0c             	sub    $0xc,%esp
80106e87:	ff 75 e0             	pushl  -0x20(%ebp)
80106e8a:	e8 01 fe ff ff       	call   80106c90 <freevm>
	return 0;
80106e8f:	83 c4 10             	add    $0x10,%esp
80106e92:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e9f:	5b                   	pop    %ebx
80106ea0:	5e                   	pop    %esi
80106ea1:	5f                   	pop    %edi
80106ea2:	5d                   	pop    %ebp
80106ea3:	c3                   	ret    
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
80106ea4:	83 ec 0c             	sub    $0xc,%esp
80106ea7:	68 44 79 10 80       	push   $0x80107944
80106eac:	e8 df 94 ff ff       	call   80100390 <panic>
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
80106eb1:	83 ec 0c             	sub    $0xc,%esp
80106eb4:	68 5e 79 10 80       	push   $0x8010795e
80106eb9:	e8 d2 94 ff ff       	call   80100390 <panic>
80106ebe:	66 90                	xchg   %ax,%ax

80106ec0 <uva2ka>:

// PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80106ec0:	55                   	push   %ebp
	pte_t *pte;

	pte = walkpgdir(pgdir, uva, 0);
80106ec1:	31 c9                	xor    %ecx,%ecx
{
80106ec3:	89 e5                	mov    %esp,%ebp
80106ec5:	83 ec 08             	sub    $0x8,%esp
	pte = walkpgdir(pgdir, uva, 0);
80106ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ece:	e8 ad f7 ff ff       	call   80106680 <walkpgdir>
	if ((*pte & PTE_P) == 0) return 0;
80106ed3:	8b 00                	mov    (%eax),%eax
	if ((*pte & PTE_U) == 0) return 0;
	return (char *)P2V(PTE_ADDR(*pte));
}
80106ed5:	c9                   	leave  
	if ((*pte & PTE_U) == 0) return 0;
80106ed6:	89 c2                	mov    %eax,%edx
	return (char *)P2V(PTE_ADDR(*pte));
80106ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if ((*pte & PTE_U) == 0) return 0;
80106edd:	83 e2 05             	and    $0x5,%edx
	return (char *)P2V(PTE_ADDR(*pte));
80106ee0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ee5:	83 fa 05             	cmp    $0x5,%edx
80106ee8:	ba 00 00 00 00       	mov    $0x0,%edx
80106eed:	0f 45 c2             	cmovne %edx,%eax
}
80106ef0:	c3                   	ret    
80106ef1:	eb 0d                	jmp    80106f00 <copyout>
80106ef3:	90                   	nop
80106ef4:	90                   	nop
80106ef5:	90                   	nop
80106ef6:	90                   	nop
80106ef7:	90                   	nop
80106ef8:	90                   	nop
80106ef9:	90                   	nop
80106efa:	90                   	nop
80106efb:	90                   	nop
80106efc:	90                   	nop
80106efd:	90                   	nop
80106efe:	90                   	nop
80106eff:	90                   	nop

80106f00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f0f:	8b 7d 10             	mov    0x10(%ebp),%edi
	char *buf, *pa0;
	uint  n, va0;

	buf = (char *)p;
	while (len > 0) {
80106f12:	85 db                	test   %ebx,%ebx
80106f14:	75 40                	jne    80106f56 <copyout+0x56>
80106f16:	eb 70                	jmp    80106f88 <copyout+0x88>
80106f18:	90                   	nop
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		va0 = (uint)PGROUNDDOWN(va);
		pa0 = uva2ka(pgdir, (char *)va0);
		if (pa0 == 0) return -1;
		n = PGSIZE - (va - va0);
80106f20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f23:	89 f1                	mov    %esi,%ecx
80106f25:	29 d1                	sub    %edx,%ecx
80106f27:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f2d:	39 d9                	cmp    %ebx,%ecx
80106f2f:	0f 47 cb             	cmova  %ebx,%ecx
		if (n > len) n= len;
		memmove(pa0 + (va - va0), buf, n);
80106f32:	29 f2                	sub    %esi,%edx
80106f34:	83 ec 04             	sub    $0x4,%esp
80106f37:	01 d0                	add    %edx,%eax
80106f39:	51                   	push   %ecx
80106f3a:	57                   	push   %edi
80106f3b:	50                   	push   %eax
80106f3c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f3f:	e8 2c d6 ff ff       	call   80104570 <memmove>
		len -= n;
		buf += n;
80106f44:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	while (len > 0) {
80106f47:	83 c4 10             	add    $0x10,%esp
		va = va0 + PGSIZE;
80106f4a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
		buf += n;
80106f50:	01 cf                	add    %ecx,%edi
	while (len > 0) {
80106f52:	29 cb                	sub    %ecx,%ebx
80106f54:	74 32                	je     80106f88 <copyout+0x88>
		va0 = (uint)PGROUNDDOWN(va);
80106f56:	89 d6                	mov    %edx,%esi
		pa0 = uva2ka(pgdir, (char *)va0);
80106f58:	83 ec 08             	sub    $0x8,%esp
		va0 = (uint)PGROUNDDOWN(va);
80106f5b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f5e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		pa0 = uva2ka(pgdir, (char *)va0);
80106f64:	56                   	push   %esi
80106f65:	ff 75 08             	pushl  0x8(%ebp)
80106f68:	e8 53 ff ff ff       	call   80106ec0 <uva2ka>
		if (pa0 == 0) return -1;
80106f6d:	83 c4 10             	add    $0x10,%esp
80106f70:	85 c0                	test   %eax,%eax
80106f72:	75 ac                	jne    80106f20 <copyout+0x20>
	}
	return 0;
}
80106f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (pa0 == 0) return -1;
80106f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f7c:	5b                   	pop    %ebx
80106f7d:	5e                   	pop    %esi
80106f7e:	5f                   	pop    %edi
80106f7f:	5d                   	pop    %ebp
80106f80:	c3                   	ret    
80106f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80106f8b:	31 c0                	xor    %eax,%eax
}
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    
