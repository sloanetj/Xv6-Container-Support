
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
80100044:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
	initlock(&bcache.lock, "bcache");
8010004c:	68 e0 7b 10 80       	push   $0x80107be0
80100051:	68 e0 c5 10 80       	push   $0x8010c5e0
80100056:	e8 55 47 00 00       	call   801047b0 <initlock>
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
80100092:	68 e7 7b 10 80       	push   $0x80107be7
80100097:	50                   	push   %eax
80100098:	e8 03 46 00 00       	call   801046a0 <initsleeplock>
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
801000e4:	e8 b7 47 00 00       	call   801048a0 <acquire>
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
80100162:	e8 59 48 00 00       	call   801049c0 <release>
			acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 45 00 00       	call   801046e0 <acquiresleep>
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
80100193:	68 ee 7b 10 80       	push   $0x80107bee
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
801001ae:	e8 cd 45 00 00       	call   80104780 <holdingsleep>
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
801001cc:	68 ff 7b 10 80       	push   $0x80107bff
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
801001ef:	e8 8c 45 00 00       	call   80104780 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>

	releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 45 00 00       	call   80104740 <releasesleep>

	acquire(&bcache.lock);
80100204:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010020b:	e8 90 46 00 00       	call   801048a0 <acquire>
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
8010025c:	e9 5f 47 00 00       	jmp    801049c0 <release>
	if (!holdingsleep(&b->lock)) panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 7c 10 80       	push   $0x80107c06
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
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 0f 46 00 00       	call   801048a0 <acquire>
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
801002c5:	e8 06 3f 00 00       	call   801041d0 <sleep>
		while (input.r == input.w) {
801002ca:	8b 15 c0 0f 11 80    	mov    0x80110fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 0f 11 80    	cmp    0x80110fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
			if (myproc()->killed) {
801002db:	e8 00 36 00 00       	call   801038e0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
				release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 cc 46 00 00       	call   801049c0 <release>
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
8010034d:	e8 6e 46 00 00       	call   801049c0 <release>
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
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 7c 10 80       	push   $0x80107c0d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
	cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
	cprintf("\n");
801003c5:	c7 04 24 c7 85 10 80 	movl   $0x801085c7,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
	getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 43 00 00       	call   801047d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 10; i++) cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 7c 10 80       	push   $0x80107c21
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
8010043a:	e8 b1 63 00 00       	call   801067f0 <uartputc>
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
801004ec:	e8 ff 62 00 00       	call   801067f0 <uartputc>
		uartputc(' ');
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 f3 62 00 00       	call   801067f0 <uartputc>
		uartputc('\b');
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 e7 62 00 00       	call   801067f0 <uartputc>
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
80100524:	e8 a7 45 00 00       	call   80104ad0 <memmove>
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
80100541:	e8 da 44 00 00       	call   80104a20 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
	if (pos < 0 || pos > 25 * 80) panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 7c 10 80       	push   $0x80107c25
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
801005b1:	0f b6 92 50 7c 10 80 	movzbl -0x7fef83b0(%edx),%edx
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
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 80 42 00 00       	call   801048a0 <acquire>
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
80100647:	e8 74 43 00 00       	call   801049c0 <release>
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
8010071f:	e8 9c 42 00 00       	call   801049c0 <release>
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
801007d0:	ba 38 7c 10 80       	mov    $0x80107c38,%edx
			for (; *s; s++) consputc(*s);
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (locking) acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 ab 40 00 00       	call   801048a0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
	if (fmt == 0) panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 7c 10 80       	push   $0x80107c3f
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
80100823:	e8 78 40 00 00       	call   801048a0 <acquire>
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
80100888:	e8 33 41 00 00       	call   801049c0 <release>
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
80100916:	e8 75 3a 00 00       	call   80104390 <wakeup>
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
80100997:	e9 24 3b 00 00       	jmp    801044c0 <procdump>
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
801009c6:	68 48 7c 10 80       	push   $0x80107c48
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 db 3d 00 00       	call   801047b0 <initlock>

	devsw[CONSOLE].write = consolewrite;
	devsw[CONSOLE].read  = consoleread;
	cons.locking         = 1;

	ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
	devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ec b6 12 80 00 	movl   $0x80100600,0x8012b6ec
801009e2:	06 10 80 
	devsw[CONSOLE].read  = consoleread;
801009e5:	c7 05 e8 b6 12 80 70 	movl   $0x80100270,0x8012b6e8
801009ec:	02 10 80 
	cons.locking         = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
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
80100a1c:	e8 bf 2e 00 00       	call   801038e0 <myproc>
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
80100a94:	e8 a7 6e 00 00       	call   80107940 <setupkvm>
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
80100af6:	e8 65 6c 00 00       	call   80107760 <allocuvm>
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
80100b28:	e8 73 6b 00 00       	call   801076a0 <loaduvm>
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
80100b72:	e8 49 6d 00 00       	call   801078c0 <freevm>
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
80100baa:	e8 b1 6b 00 00       	call   80107760 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
	if (pgdir) freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 fa 6c 00 00       	call   801078c0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
	return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
		end_op();
80100bd3:	e8 48 20 00 00       	call   80102c20 <end_op>
		cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 61 7c 10 80       	push   $0x80107c61
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
80100c06:	e8 d5 6d 00 00       	call   801079e0 <clearpteu>
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
80100c39:	e8 02 40 00 00       	call   80104c40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
		if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) goto bad;
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
		sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
		if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) goto bad;
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 3f 00 00       	call   80104c40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ce 6e 00 00       	call   80107b30 <copyout>
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
80100cc7:	e8 64 6e 00 00       	call   80107b30 <copyout>
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
80100d0a:	e8 f1 3e 00 00       	call   80104c00 <safestrcpy>
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
80100d34:	e8 d7 67 00 00       	call   80107510 <switchuvm>
	freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 7f 6b 00 00       	call   801078c0 <freevm>
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
80100d66:	68 6d 7c 10 80       	push   $0x80107c6d
80100d6b:	68 40 ad 12 80       	push   $0x8012ad40
80100d70:	e8 3b 3a 00 00       	call   801047b0 <initlock>
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
80100d84:	bb 74 ad 12 80       	mov    $0x8012ad74,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
	acquire(&ftable.lock);
80100d8c:	68 40 ad 12 80       	push   $0x8012ad40
80100d91:	e8 0a 3b 00 00       	call   801048a0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (f = ftable.file; f < ftable.file + NFILE; f++) {
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb d4 b6 12 80    	cmp    $0x8012b6d4,%ebx
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
80100dbc:	68 40 ad 12 80       	push   $0x8012ad40
80100dc1:	e8 fa 3b 00 00       	call   801049c0 <release>
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
80100dd5:	68 40 ad 12 80       	push   $0x8012ad40
80100dda:	e8 e1 3b 00 00       	call   801049c0 <release>
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
80100dfa:	68 40 ad 12 80       	push   $0x8012ad40
80100dff:	e8 9c 3a 00 00       	call   801048a0 <acquire>
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
80100e17:	68 40 ad 12 80       	push   $0x8012ad40
80100e1c:	e8 9f 3b 00 00       	call   801049c0 <release>
	return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
	if (f->ref < 1) panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 74 7c 10 80       	push   $0x80107c74
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
80100e4c:	68 40 ad 12 80       	push   $0x8012ad40
80100e51:	e8 4a 3a 00 00       	call   801048a0 <acquire>
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
80100e6e:	c7 45 08 40 ad 12 80 	movl   $0x8012ad40,0x8(%ebp)
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
80100e7c:	e9 3f 3b 00 00       	jmp    801049c0 <release>
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
80100ea0:	68 40 ad 12 80       	push   $0x8012ad40
	ff      = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	release(&ftable.lock);
80100ea8:	e8 13 3b 00 00       	call   801049c0 <release>
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
80100f02:	68 7c 7c 10 80       	push   $0x80107c7c
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
80100fe2:	68 86 7c 10 80       	push   $0x80107c86
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
801010f5:	68 8f 7c 10 80       	push   $0x80107c8f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
	panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 95 7c 10 80       	push   $0x80107c95
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
80101119:	8b 0d 40 b7 12 80    	mov    0x8012b740,%ecx
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
8010113c:	03 05 58 b7 12 80    	add    0x8012b758,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010114e:	a1 40 b7 12 80       	mov    0x8012b740,%eax
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
801011a9:	39 05 40 b7 12 80    	cmp    %eax,0x8012b740
801011af:	77 80                	ja     80101131 <balloc+0x21>
	}
	panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 9f 7c 10 80       	push   $0x80107c9f
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
801011f5:	e8 26 38 00 00       	call   80104a20 <memset>
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
8010122a:	bb 94 b7 12 80       	mov    $0x8012b794,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	acquire(&icache.lock);
80101235:	68 60 b7 12 80       	push   $0x8012b760
8010123a:	e8 61 36 00 00       	call   801048a0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
	for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb b4 d3 12 80    	cmp    $0x8012d3b4,%ebx
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
80101278:	81 fb b4 d3 12 80    	cmp    $0x8012d3b4,%ebx
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
8010129a:	68 60 b7 12 80       	push   $0x8012b760
8010129f:	e8 1c 37 00 00       	call   801049c0 <release>

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
801012c5:	68 60 b7 12 80       	push   $0x8012b760
			ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
			release(&icache.lock);
801012cd:	e8 ee 36 00 00       	call   801049c0 <release>
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
801012e2:	68 b5 7c 10 80       	push   $0x80107cb5
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
801013b7:	68 c5 7c 10 80       	push   $0x80107cc5
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
801013f1:	e8 da 36 00 00       	call   80104ad0 <memmove>
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
8010141c:	68 40 b7 12 80       	push   $0x8012b740
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
	bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 58 b7 12 80    	add    0x8012b758,%edx
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
80101484:	68 d8 7c 10 80       	push   $0x80107cd8
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb a0 b7 12 80       	mov    $0x8012b7a0,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
	initlock(&icache.lock, "icache");
8010149c:	68 eb 7c 10 80       	push   $0x80107ceb
801014a1:	68 60 b7 12 80       	push   $0x8012b760
801014a6:	e8 05 33 00 00       	call   801047b0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
		initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 f2 7c 10 80       	push   $0x80107cf2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 dc 31 00 00       	call   801046a0 <initsleeplock>
	for (i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb c0 d3 12 80    	cmp    $0x8012d3c0,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
	readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 40 b7 12 80       	push   $0x8012b740
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
	cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 58 b7 12 80    	pushl  0x8012b758
801014e5:	ff 35 54 b7 12 80    	pushl  0x8012b754
801014eb:	ff 35 50 b7 12 80    	pushl  0x8012b750
801014f1:	ff 35 4c b7 12 80    	pushl  0x8012b74c
801014f7:	ff 35 48 b7 12 80    	pushl  0x8012b748
801014fd:	ff 35 44 b7 12 80    	pushl  0x8012b744
80101503:	ff 35 40 b7 12 80    	pushl  0x8012b740
80101509:	68 58 7d 10 80       	push   $0x80107d58
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
80101529:	83 3d 48 b7 12 80 01 	cmpl   $0x1,0x8012b748
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
8010155f:	39 1d 48 b7 12 80    	cmp    %ebx,0x8012b748
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
		bp  = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 54 b7 12 80    	add    0x8012b754,%eax
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
8010159e:	e8 7d 34 00 00       	call   80104a20 <memset>
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
801015d3:	68 f8 7c 10 80       	push   $0x80107cf8
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
801015f4:	03 05 54 b7 12 80    	add    0x8012b754,%eax
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
80101641:	e8 8a 34 00 00       	call   80104ad0 <memmove>
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
8010166a:	68 60 b7 12 80       	push   $0x8012b760
8010166f:	e8 2c 32 00 00       	call   801048a0 <acquire>
	ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
	release(&icache.lock);
80101678:	c7 04 24 60 b7 12 80 	movl   $0x8012b760,(%esp)
8010167f:	e8 3c 33 00 00       	call   801049c0 <release>
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
801016b2:	e8 29 30 00 00       	call   801046e0 <acquiresleep>
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
801016d9:	03 05 54 b7 12 80    	add    0x8012b754,%eax
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
80101728:	e8 a3 33 00 00       	call   80104ad0 <memmove>
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
8010174d:	68 10 7d 10 80       	push   $0x80107d10
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
	if (ip == 0 || ip->ref < 1) panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 0a 7d 10 80       	push   $0x80107d0a
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
80101783:	e8 f8 2f 00 00       	call   80104780 <holdingsleep>
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
8010179f:	e9 9c 2f 00 00       	jmp    80104740 <releasesleep>
	if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 1f 7d 10 80       	push   $0x80107d1f
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
801017d0:	e8 0b 2f 00 00       	call   801046e0 <acquiresleep>
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
801017ea:	e8 51 2f 00 00       	call   80104740 <releasesleep>
	acquire(&icache.lock);
801017ef:	c7 04 24 60 b7 12 80 	movl   $0x8012b760,(%esp)
801017f6:	e8 a5 30 00 00       	call   801048a0 <acquire>
	ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
	release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 60 b7 12 80 	movl   $0x8012b760,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
	release(&icache.lock);
80101810:	e9 ab 31 00 00       	jmp    801049c0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
		acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 60 b7 12 80       	push   $0x8012b760
80101820:	e8 7b 30 00 00       	call   801048a0 <acquire>
		int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
		release(&icache.lock);
80101828:	c7 04 24 60 b7 12 80 	movl   $0x8012b760,(%esp)
8010182f:	e8 8c 31 00 00       	call   801049c0 <release>
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
80101a17:	e8 b4 30 00 00       	call   80104ad0 <memmove>
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
80101a4a:	8b 04 c5 e0 b6 12 80 	mov    -0x7fed4920(,%eax,8),%eax
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
80101b13:	e8 b8 2f 00 00       	call   80104ad0 <memmove>
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
80101b5a:	8b 04 c5 e4 b6 12 80 	mov    -0x7fed491c(,%eax,8),%eax
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
80101bae:	e8 8d 2f 00 00       	call   80104b40 <strncmp>
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
80101c0d:	e8 2e 2f 00 00       	call   80104b40 <strncmp>
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
80101c52:	68 39 7d 10 80       	push   $0x80107d39
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
	if (dp->type != T_DIR) panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 27 7d 10 80       	push   $0x80107d27
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
80101c89:	e8 52 1c 00 00       	call   801038e0 <myproc>
	acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
		ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
	acquire(&icache.lock);
80101c94:	68 60 b7 12 80       	push   $0x8012b760
80101c99:	e8 02 2c 00 00       	call   801048a0 <acquire>
	ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
	release(&icache.lock);
80101ca2:	c7 04 24 60 b7 12 80 	movl   $0x8012b760,(%esp)
80101ca9:	e8 12 2d 00 00       	call   801049c0 <release>
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
80101d05:	e8 c6 2d 00 00       	call   80104ad0 <memmove>
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
80101d98:	e8 33 2d 00 00       	call   80104ad0 <memmove>
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
80101e8d:	e8 0e 2d 00 00       	call   80104ba0 <strncpy>
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
80101ecb:	68 48 7d 10 80       	push   $0x80107d48
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 a2 83 10 80       	push   $0x801083a2
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
80101feb:	68 b4 7d 10 80       	push   $0x80107db4
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
	if (b == 0) panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 ab 7d 10 80       	push   $0x80107dab
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
	initlock(&idelock, "ide");
80102016:	68 c6 7d 10 80       	push   $0x80107dc6
8010201b:	68 80 b5 10 80       	push   $0x8010b580
80102020:	e8 8b 27 00 00       	call   801047b0 <initlock>
	ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 80 da 12 80       	mov    0x8012da80,%eax
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
8010206a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
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
80102099:	68 80 b5 10 80       	push   $0x8010b580
8010209e:	e8 fd 27 00 00       	call   801048a0 <acquire>

	if ((b = idequeue) == 0) {
801020a3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
		release(&idelock);
		return;
	}
	idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

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
80102101:	e8 8a 22 00 00       	call   80104390 <wakeup>

	// Start disk on next buf in queue.
	if (idequeue != 0) idestart(idequeue);
80102106:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
		release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 b5 10 80       	push   $0x8010b580
8010211f:	e8 9c 28 00 00       	call   801049c0 <release>

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
8010213e:	e8 3d 26 00 00       	call   80104780 <holdingsleep>
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
80102163:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>

	acquire(&idelock); // DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 b5 10 80       	push   $0x8010b580
80102178:	e8 23 27 00 00       	call   801048a0 <acquire>

	// Append b to idequeue.
	b->qnext = 0;
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
8010217d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
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
801021a6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
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
801021c3:	68 80 b5 10 80       	push   $0x8010b580
801021c8:	53                   	push   %ebx
801021c9:	e8 02 20 00 00       	call   801041d0 <sleep>
	while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
	}


	release(&idelock);
801021db:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
	release(&idelock);
801021e6:	e9 d5 27 00 00       	jmp    801049c0 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (idequeue == b) idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (pp = &idequeue; *pp; pp = &(*pp)->qnext) // DOC:insert-queue
80102200:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
	if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 e0 7d 10 80       	push   $0x80107de0
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
	if (!holdingsleep(&b->lock)) panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 ca 7d 10 80       	push   $0x80107dca
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
	if (b->dev != 0 && !havedisk1) panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 f5 7d 10 80       	push   $0x80107df5
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
80102231:	c7 05 b4 d3 12 80 00 	movl   $0xfec00000,0x8012d3b4
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
	ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
	return ioapic->data;
80102249:	a1 b4 d3 12 80       	mov    0x8012d3b4,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
	ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return ioapic->data;
80102257:	8b 0d b4 d3 12 80    	mov    0x8012d3b4,%ecx
	maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
	id      = ioapicread(REG_ID) >> 24;
	if (id != ioapicid) cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010225d:	0f b6 15 e0 d4 12 80 	movzbl 0x8012d4e0,%edx
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
80102277:	68 14 7e 10 80       	push   $0x80107e14
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d b4 d3 12 80    	mov    0x8012d3b4,%ecx
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
801022a2:	8b 0d b4 d3 12 80    	mov    0x8012d3b4,%ecx

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
801022c0:	8b 0d b4 d3 12 80    	mov    0x8012d3b4,%ecx
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
801022e1:	8b 0d b4 d3 12 80    	mov    0x8012d3b4,%ecx
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
801022f5:	8b 0d b4 d3 12 80    	mov    0x8012d3b4,%ecx
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
	ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
	ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
	ioapic->reg  = reg;
80102304:	89 01                	mov    %eax,(%ecx)
	ioapic->data = data;
80102306:	a1 b4 d3 12 80       	mov    0x8012d3b4,%eax
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
80102332:	81 fb e8 e2 12 80    	cmp    $0x8012e2e8,%ebx
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
80102352:	e8 c9 26 00 00       	call   80104a20 <memset>

	if (kmem.use_lock) acquire(&kmem.lock);
80102357:	8b 15 f4 d3 12 80    	mov    0x8012d3f4,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
	r             = (struct run *)v;
	r->next       = kmem.freelist;
80102364:	a1 f8 d3 12 80       	mov    0x8012d3f8,%eax
80102369:	89 03                	mov    %eax,(%ebx)
	kmem.freelist = r;
	if (kmem.use_lock) release(&kmem.lock);
8010236b:	a1 f4 d3 12 80       	mov    0x8012d3f4,%eax
	kmem.freelist = r;
80102370:	89 1d f8 d3 12 80    	mov    %ebx,0x8012d3f8
	if (kmem.use_lock) release(&kmem.lock);
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
	if (kmem.use_lock) release(&kmem.lock);
80102380:	c7 45 08 c0 d3 12 80 	movl   $0x8012d3c0,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
	if (kmem.use_lock) release(&kmem.lock);
8010238b:	e9 30 26 00 00       	jmp    801049c0 <release>
	if (kmem.use_lock) acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 c0 d3 12 80       	push   $0x8012d3c0
80102398:	e8 03 25 00 00       	call   801048a0 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
	if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 46 7e 10 80       	push   $0x80107e46
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
8010240b:	68 4c 7e 10 80       	push   $0x80107e4c
80102410:	68 c0 d3 12 80       	push   $0x8012d3c0
80102415:	e8 96 23 00 00       	call   801047b0 <initlock>
	p = (char *)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
	for (; p + PGSIZE <= (char *)vend; p += PGSIZE) kfree(p);
8010241d:	83 c4 10             	add    $0x10,%esp
	kmem.use_lock = 0;
80102420:	c7 05 f4 d3 12 80 00 	movl   $0x0,0x8012d3f4
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
801024b4:	c7 05 f4 d3 12 80 01 	movl   $0x1,0x8012d3f4
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
801024d0:	a1 f4 d3 12 80       	mov    0x8012d3f4,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
	r = kmem.freelist;
801024d9:	a1 f8 d3 12 80       	mov    0x8012d3f8,%eax
	if (r) kmem.freelist= r->next;
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 f8 d3 12 80    	mov    %edx,0x8012d3f8
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
801024fe:	68 c0 d3 12 80       	push   $0x8012d3c0
80102503:	e8 98 23 00 00       	call   801048a0 <acquire>
	r = kmem.freelist;
80102508:	a1 f8 d3 12 80       	mov    0x8012d3f8,%eax
	if (r) kmem.freelist= r->next;
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 f4 d3 12 80    	mov    0x8012d3f4,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d f8 d3 12 80    	mov    %ecx,0x8012d3f8
	if (kmem.use_lock) release(&kmem.lock);
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 c0 d3 12 80       	push   $0x8012d3c0
80102531:	e8 8a 24 00 00       	call   801049c0 <release>
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
80102557:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

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
80102583:	0f b6 82 80 7f 10 80 	movzbl -0x7fef8080(%edx),%eax
8010258a:	09 c1                	or     %eax,%ecx
	shift ^= togglecode[data];
8010258c:	0f b6 82 80 7e 10 80 	movzbl -0x7fef8180(%edx),%eax
80102593:	31 c1                	xor    %eax,%ecx
	c = charcode[shift & (CTL | SHIFT)][data];
80102595:	89 c8                	mov    %ecx,%eax
	shift ^= togglecode[data];
80102597:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
	c = charcode[shift & (CTL | SHIFT)][data];
8010259d:	83 e0 03             	and    $0x3,%eax
	if (shift & CAPSLOCK) {
801025a0:	83 e1 08             	and    $0x8,%ecx
	c = charcode[shift & (CTL | SHIFT)][data];
801025a3:	8b 04 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%eax
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
801025c8:	0f b6 82 80 7f 10 80 	movzbl -0x7fef8080(%edx),%eax
801025cf:	83 c8 40             	or     $0x40,%eax
801025d2:	0f b6 c0             	movzbl %al,%eax
801025d5:	f7 d0                	not    %eax
801025d7:	21 c1                	and    %eax,%ecx
		return 0;
801025d9:	31 c0                	xor    %eax,%eax
		shift &= ~(shiftcode[data] | E0ESC);
801025db:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
801025ed:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
80102640:	a1 fc d3 12 80       	mov    0x8012d3fc,%eax
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
80102740:	8b 15 fc d3 12 80    	mov    0x8012d3fc,%edx
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
80102760:	a1 fc d3 12 80       	mov    0x8012d3fc,%eax
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
801027ce:	a1 fc d3 12 80       	mov    0x8012d3fc,%eax
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
80102947:	e8 24 21 00 00       	call   80104a70 <memcmp>
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
80102a10:	8b 0d 48 d4 12 80    	mov    0x8012d448,%ecx
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
80102a30:	a1 34 d4 12 80       	mov    0x8012d434,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 44 d4 12 80    	pushl  0x8012d444
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
		struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d 4c d4 12 80 	pushl  -0x7fed2bb4(,%ebx,4)
80102a54:	ff 35 44 d4 12 80    	pushl  0x8012d444
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
80102a74:	e8 57 20 00 00       	call   80104ad0 <memmove>
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
80102a94:	39 1d 48 d4 12 80    	cmp    %ebx,0x8012d448
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
80102ab8:	ff 35 34 d4 12 80    	pushl  0x8012d434
80102abe:	ff 35 44 d4 12 80    	pushl  0x8012d444
80102ac4:	e8 07 d6 ff ff       	call   801000d0 <bread>
	struct logheader *hb  = (struct logheader *)(buf->data);
	int               i;
	hb->n = log.lh.n;
80102ac9:	8b 1d 48 d4 12 80    	mov    0x8012d448,%ebx
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
80102ae0:	8b 8a 4c d4 12 80    	mov    -0x7fed2bb4(%edx),%ecx
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
80102b1a:	68 80 80 10 80       	push   $0x80108080
80102b1f:	68 00 d4 12 80       	push   $0x8012d400
80102b24:	e8 87 1c 00 00       	call   801047b0 <initlock>
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
80102b3c:	89 1d 44 d4 12 80    	mov    %ebx,0x8012d444
	log.size  = sb.nlog;
80102b42:	89 15 38 d4 12 80    	mov    %edx,0x8012d438
	log.start = sb.logstart;
80102b48:	a3 34 d4 12 80       	mov    %eax,0x8012d434
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
80102b5d:	89 1d 48 d4 12 80    	mov    %ebx,0x8012d448
	for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	c1 e3 02             	shl    $0x2,%ebx
80102b68:	31 d2                	xor    %edx,%edx
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a 48 d4 12 80    	mov    %ecx,-0x7fed2bb8(%edx)
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
80102b8f:	c7 05 48 d4 12 80 00 	movl   $0x0,0x8012d448
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
80102bb6:	68 00 d4 12 80       	push   $0x8012d400
80102bbb:	e8 e0 1c 00 00       	call   801048a0 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
	while (1) {
		if (log.committing) {
			sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 00 d4 12 80       	push   $0x8012d400
80102bd0:	68 00 d4 12 80       	push   $0x8012d400
80102bd5:	e8 f6 15 00 00       	call   801041d0 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
		if (log.committing) {
80102bdd:	a1 40 d4 12 80       	mov    0x8012d440,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
		} else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGSIZE) {
80102be6:	a1 3c d4 12 80       	mov    0x8012d43c,%eax
80102beb:	8b 15 48 d4 12 80    	mov    0x8012d448,%edx
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
80102c02:	a3 3c d4 12 80       	mov    %eax,0x8012d43c
			release(&log.lock);
80102c07:	68 00 d4 12 80       	push   $0x8012d400
80102c0c:	e8 af 1d 00 00       	call   801049c0 <release>
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
80102c29:	68 00 d4 12 80       	push   $0x8012d400
80102c2e:	e8 6d 1c 00 00       	call   801048a0 <acquire>
	log.outstanding -= 1;
80102c33:	a1 3c d4 12 80       	mov    0x8012d43c,%eax
	if (log.committing) panic("log.committing");
80102c38:	8b 35 40 d4 12 80    	mov    0x8012d440,%esi
80102c3e:	83 c4 10             	add    $0x10,%esp
	log.outstanding -= 1;
80102c41:	8d 58 ff             	lea    -0x1(%eax),%ebx
	if (log.committing) panic("log.committing");
80102c44:	85 f6                	test   %esi,%esi
	log.outstanding -= 1;
80102c46:	89 1d 3c d4 12 80    	mov    %ebx,0x8012d43c
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
80102c5d:	c7 05 40 d4 12 80 01 	movl   $0x1,0x8012d440
80102c64:	00 00 00 
	release(&log.lock);
80102c67:	68 00 d4 12 80       	push   $0x8012d400
80102c6c:	e8 4f 1d 00 00       	call   801049c0 <release>
}

static void
commit()
{
	if (log.lh.n > 0) {
80102c71:	8b 0d 48 d4 12 80    	mov    0x8012d448,%ecx
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	85 c9                	test   %ecx,%ecx
80102c7c:	0f 8e 85 00 00 00    	jle    80102d07 <end_op+0xe7>
		struct buf *to   = bread(log.dev, log.start + tail + 1); // log block
80102c82:	a1 34 d4 12 80       	mov    0x8012d434,%eax
80102c87:	83 ec 08             	sub    $0x8,%esp
80102c8a:	01 d8                	add    %ebx,%eax
80102c8c:	83 c0 01             	add    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	ff 35 44 d4 12 80    	pushl  0x8012d444
80102c96:	e8 35 d4 ff ff       	call   801000d0 <bread>
80102c9b:	89 c6                	mov    %eax,%esi
		struct buf *from = bread(log.dev, log.lh.block[tail]);   // cache block
80102c9d:	58                   	pop    %eax
80102c9e:	5a                   	pop    %edx
80102c9f:	ff 34 9d 4c d4 12 80 	pushl  -0x7fed2bb4(,%ebx,4)
80102ca6:	ff 35 44 d4 12 80    	pushl  0x8012d444
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
80102cc6:	e8 05 1e 00 00       	call   80104ad0 <memmove>
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
80102ce6:	3b 1d 48 d4 12 80    	cmp    0x8012d448,%ebx
80102cec:	7c 94                	jl     80102c82 <end_op+0x62>
		write_log();     // Write modified blocks from cache to log
		write_head();    // Write header to disk -- the real commit
80102cee:	e8 bd fd ff ff       	call   80102ab0 <write_head>
		install_trans(); // Now install writes to home locations
80102cf3:	e8 18 fd ff ff       	call   80102a10 <install_trans>
		log.lh.n = 0;
80102cf8:	c7 05 48 d4 12 80 00 	movl   $0x0,0x8012d448
80102cff:	00 00 00 
		write_head(); // Erase the transaction from the log
80102d02:	e8 a9 fd ff ff       	call   80102ab0 <write_head>
		acquire(&log.lock);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 00 d4 12 80       	push   $0x8012d400
80102d0f:	e8 8c 1b 00 00       	call   801048a0 <acquire>
		wakeup(&log);
80102d14:	c7 04 24 00 d4 12 80 	movl   $0x8012d400,(%esp)
		log.committing = 0;
80102d1b:	c7 05 40 d4 12 80 00 	movl   $0x0,0x8012d440
80102d22:	00 00 00 
		wakeup(&log);
80102d25:	e8 66 16 00 00       	call   80104390 <wakeup>
		release(&log.lock);
80102d2a:	c7 04 24 00 d4 12 80 	movl   $0x8012d400,(%esp)
80102d31:	e8 8a 1c 00 00       	call   801049c0 <release>
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
80102d4b:	68 00 d4 12 80       	push   $0x8012d400
80102d50:	e8 3b 16 00 00       	call   80104390 <wakeup>
	release(&log.lock);
80102d55:	c7 04 24 00 d4 12 80 	movl   $0x8012d400,(%esp)
80102d5c:	e8 5f 1c 00 00       	call   801049c0 <release>
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
80102d6f:	68 84 80 10 80       	push   $0x80108084
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
80102d87:	8b 15 48 d4 12 80    	mov    0x8012d448,%edx
{
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 9d 00 00 00    	jg     80102e36 <log_write+0xb6>
80102d99:	a1 38 d4 12 80       	mov    0x8012d438,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 8d 00 00 00    	jge    80102e36 <log_write+0xb6>
	if (log.outstanding < 1) panic("log_write outside of trans");
80102da9:	a1 3c d4 12 80       	mov    0x8012d43c,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 8d 00 00 00    	jle    80102e43 <log_write+0xc3>

	acquire(&log.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 00 d4 12 80       	push   $0x8012d400
80102dbe:	e8 dd 1a 00 00       	call   801048a0 <acquire>
	for (i = 0; i < log.lh.n; i++) {
80102dc3:	8b 0d 48 d4 12 80    	mov    0x8012d448,%ecx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 f9 00             	cmp    $0x0,%ecx
80102dcf:	7e 57                	jle    80102e28 <log_write+0xa8>
		if (log.lh.block[i] == b->blockno) // log absorbtion
80102dd1:	8b 53 08             	mov    0x8(%ebx),%edx
	for (i = 0; i < log.lh.n; i++) {
80102dd4:	31 c0                	xor    %eax,%eax
		if (log.lh.block[i] == b->blockno) // log absorbtion
80102dd6:	3b 15 4c d4 12 80    	cmp    0x8012d44c,%edx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 14 85 4c d4 12 80 	cmp    %edx,-0x7fed2bb4(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
	for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 c1                	cmp    %eax,%ecx
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
			break;
	}
	log.lh.block[i] = b->blockno;
80102df0:	89 14 85 4c d4 12 80 	mov    %edx,-0x7fed2bb4(,%eax,4)
	if (i == log.lh.n) log.lh.n++;
80102df7:	83 c0 01             	add    $0x1,%eax
80102dfa:	a3 48 d4 12 80       	mov    %eax,0x8012d448
	b->flags |= B_DIRTY; // prevent eviction
80102dff:	83 0b 04             	orl    $0x4,(%ebx)
	release(&log.lock);
80102e02:	c7 45 08 00 d4 12 80 	movl   $0x8012d400,0x8(%ebp)
}
80102e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0c:	c9                   	leave  
	release(&log.lock);
80102e0d:	e9 ae 1b 00 00       	jmp    801049c0 <release>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	log.lh.block[i] = b->blockno;
80102e18:	89 14 85 4c d4 12 80 	mov    %edx,-0x7fed2bb4(,%eax,4)
80102e1f:	eb de                	jmp    80102dff <log_write+0x7f>
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 43 08             	mov    0x8(%ebx),%eax
80102e2b:	a3 4c d4 12 80       	mov    %eax,0x8012d44c
	if (i == log.lh.n) log.lh.n++;
80102e30:	75 cd                	jne    80102dff <log_write+0x7f>
80102e32:	31 c0                	xor    %eax,%eax
80102e34:	eb c1                	jmp    80102df7 <log_write+0x77>
	if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1) panic("too big a transaction");
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 93 80 10 80       	push   $0x80108093
80102e3e:	e8 4d d5 ff ff       	call   80100390 <panic>
	if (log.outstanding < 1) panic("log_write outside of trans");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 a9 80 10 80       	push   $0x801080a9
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
80102e57:	e8 64 0a 00 00       	call   801038c0 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 5d 0a 00 00       	call   801038c0 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 c4 80 10 80       	push   $0x801080c4
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
	idtinit();                    // load idt register
80102e72:	e8 89 35 00 00       	call   80106400 <idtinit>
	xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e77:	e8 c4 09 00 00       	call   80103840 <mycpu>
80102e7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
	uint result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" : "+m"(*addr), "=a"(result) : "1"(newval) : "cc");
80102e7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
	scheduler();                  // start running processes
80102e8a:	e8 01 0f 00 00       	call   80103d90 <scheduler>
80102e8f:	90                   	nop

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
	switchkvm();
80102e96:	e8 55 46 00 00       	call   801074f0 <switchkvm>
	seginit();
80102e9b:	e8 c0 45 00 00       	call   80107460 <seginit>
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
80102ec7:	68 e8 e2 12 80       	push   $0x8012e2e8
80102ecc:	e8 2f f5 ff ff       	call   80102400 <kinit1>
	kvmalloc();                                 // kernel page table
80102ed1:	e8 ea 4a 00 00       	call   801079c0 <kvmalloc>
	mpinit();                                   // detect other processors
80102ed6:	e8 75 01 00 00       	call   80103050 <mpinit>
	lapicinit();                                // interrupt controller
80102edb:	e8 60 f7 ff ff       	call   80102640 <lapicinit>
	seginit();                                  // segment descriptors
80102ee0:	e8 7b 45 00 00       	call   80107460 <seginit>
	picinit();                                  // disable pic
80102ee5:	e8 46 03 00 00       	call   80103230 <picinit>
	ioapicinit();                               // another interrupt controller
80102eea:	e8 41 f3 ff ff       	call   80102230 <ioapicinit>
	consoleinit();                              // console hardware
80102eef:	e8 cc da ff ff       	call   801009c0 <consoleinit>
	uartinit();                                 // serial port
80102ef4:	e8 37 38 00 00       	call   80106730 <uartinit>
	pinit();                                    // process table
80102ef9:	e8 22 09 00 00       	call   80103820 <pinit>
	tvinit();                                   // trap vectors
80102efe:	e8 7d 34 00 00       	call   80106380 <tvinit>
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
80102f1a:	68 8c b4 10 80       	push   $0x8010b48c
80102f1f:	68 00 70 00 80       	push   $0x80007000
80102f24:	e8 a7 1b 00 00       	call   80104ad0 <memmove>

	for (c = cpus; c < cpus + ncpu; c++) {
80102f29:	69 05 80 da 12 80 b0 	imul   $0xb0,0x8012da80,%eax
80102f30:	00 00 00 
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	05 00 d5 12 80       	add    $0x8012d500,%eax
80102f3b:	3d 00 d5 12 80       	cmp    $0x8012d500,%eax
80102f40:	76 71                	jbe    80102fb3 <main+0x103>
80102f42:	bb 00 d5 12 80       	mov    $0x8012d500,%ebx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		if (c == mycpu()) // We've started already.
80102f50:	e8 eb 08 00 00       	call   80103840 <mycpu>
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
80102f6d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f74:	a0 10 00 
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
80102f9a:	69 05 80 da 12 80 b0 	imul   $0xb0,0x8012da80,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102faa:	05 00 d5 12 80       	add    $0x8012d500,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
	kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	83 ec 08             	sub    $0x8,%esp
80102fb6:	68 00 00 00 8e       	push   $0x8e000000
80102fbb:	68 00 00 40 80       	push   $0x80400000
80102fc0:	e8 ab f4 ff ff       	call   80102470 <kinit2>
	userinit();                                 // first user process
80102fc5:	e8 46 09 00 00       	call   80103910 <userinit>
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
80102ffe:	68 d8 80 10 80       	push   $0x801080d8
80103003:	56                   	push   %esi
80103004:	e8 67 1a 00 00       	call   80104a70 <memcmp>
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
801030bc:	68 f5 80 10 80       	push   $0x801080f5
801030c1:	56                   	push   %esi
801030c2:	e8 a9 19 00 00       	call   80104a70 <memcmp>
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
80103127:	a3 fc d3 12 80       	mov    %eax,0x8012d3fc
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
80103150:	ff 24 95 1c 81 10 80 	jmp    *-0x7fef7ee4(,%edx,4)
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
80103198:	8b 0d 80 da 12 80    	mov    0x8012da80,%ecx
8010319e:	83 f9 07             	cmp    $0x7,%ecx
801031a1:	7f 19                	jg     801031bc <mpinit+0x16c>
				cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
801031a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
				ncpu++;
801031ad:	83 c1 01             	add    $0x1,%ecx
801031b0:	89 0d 80 da 12 80    	mov    %ecx,0x8012da80
				cpus[ncpu].apicid = proc->apicid; // apicid may differ from ncpu
801031b6:	88 97 00 d5 12 80    	mov    %dl,-0x7fed2b00(%edi)
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
801031cf:	88 15 e0 d4 12 80    	mov    %dl,0x8012d4e0
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
80103203:	68 dd 80 10 80       	push   $0x801080dd
80103208:	e8 83 d1 ff ff       	call   80100390 <panic>
	if (!ismp) panic("Didn't find a suitable machine");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 fc 80 10 80       	push   $0x801080fc
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
8010330b:	68 30 81 10 80       	push   $0x80108130
80103310:	50                   	push   %eax
80103311:	e8 9a 14 00 00       	call   801047b0 <initlock>
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
8010336f:	e8 2c 15 00 00       	call   801048a0 <acquire>
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
8010338f:	e8 fc 0f 00 00       	call   80104390 <wakeup>
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
801033b4:	e9 07 16 00 00       	jmp    801049c0 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
		p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
		wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 b7 0f 00 00       	call   80104390 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
		release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 d7 15 00 00       	call   801049c0 <release>
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
8010340d:	e8 8e 14 00 00       	call   801048a0 <acquire>
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
80103464:	e8 27 0f 00 00       	call   80104390 <wakeup>
			sleep(&p->nwrite, &p->lock); // DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 5e 0d 00 00       	call   801041d0 <sleep>
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
80103494:	e8 47 04 00 00       	call   801038e0 <myproc>
80103499:	8b 40 24             	mov    0x24(%eax),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	74 c0                	je     80103460 <pipewrite+0x60>
				release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 17 15 00 00       	call   801049c0 <release>
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
801034f3:	e8 98 0e 00 00       	call   80104390 <wakeup>
	release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 c0 14 00 00       	call   801049c0 <release>
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
80103520:	e8 7b 13 00 00       	call   801048a0 <acquire>
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
80103555:	e8 76 0c 00 00       	call   801041d0 <sleep>
	while (p->nread == p->nwrite && p->writeopen) { // DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 8f 00 00 00    	je     80103608 <piperead+0xf8>
		if (myproc()->killed) {
80103579:	e8 62 03 00 00       	call   801038e0 <myproc>
8010357e:	8b 48 24             	mov    0x24(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
			release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
			return -1;
80103588:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
			release(&p->lock);
8010358d:	56                   	push   %esi
8010358e:	e8 2d 14 00 00       	call   801049c0 <release>
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
801035e7:	e8 a4 0d 00 00       	call   80104390 <wakeup>
	release(&p->lock);
801035ec:	89 34 24             	mov    %esi,(%esp)
801035ef:	e8 cc 13 00 00       	call   801049c0 <release>
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

80103610 <wakeup1>:
// PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103610:	55                   	push   %ebp
	struct proc *p;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103611:	b9 f4 1f 11 80       	mov    $0x80111ff4,%ecx
{
80103616:	89 e5                	mov    %esp,%ebp
80103618:	57                   	push   %edi
80103619:	56                   	push   %esi
8010361a:	53                   	push   %ebx
8010361b:	83 ec 1c             	sub    $0x1c,%esp
8010361e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103621:	eb 17                	jmp    8010363a <wakeup1+0x2a>
80103623:	90                   	nop
80103624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103628:	81 c1 d0 00 00 00    	add    $0xd0,%ecx
8010362e:	81 f9 f4 53 11 80    	cmp    $0x801153f4,%ecx
80103634:	0f 83 89 00 00 00    	jae    801036c3 <wakeup1+0xb3>
		if (p->state == SLEEPING && p->chan == chan){
8010363a:	83 79 0c 02          	cmpl   $0x2,0xc(%ecx)
8010363e:	75 e8                	jne    80103628 <wakeup1+0x18>
80103640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103643:	39 41 20             	cmp    %eax,0x20(%ecx)
80103646:	75 e0                	jne    80103628 <wakeup1+0x18>
	if (!(p->state == RUNNABLE)){
		// process must be runnable to be placed in queue
		return -1;
	}
	
	int priority = p->priority;
80103648:	8b b9 cc 00 00 00    	mov    0xcc(%ecx),%edi
			p->state = RUNNABLE;
8010364e:	c7 41 0c 03 00 00 00 	movl   $0x3,0xc(%ecx)
	int head = ptable.head_tail[priority][0];
	int tail = ptable.head_tail[priority][1];

	if (tail == (head-1)%QSIZE){
80103655:	8b 04 fd f4 53 11 80 	mov    -0x7feeac0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
8010365c:	8b 1c fd f8 53 11 80 	mov    -0x7feeac08(,%edi,8),%ebx
	if (tail == (head-1)%QSIZE){
80103663:	8d 70 ff             	lea    -0x1(%eax),%esi
80103666:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
8010366b:	f7 ee                	imul   %esi
8010366d:	89 f0                	mov    %esi,%eax
8010366f:	c1 f8 1f             	sar    $0x1f,%eax
80103672:	c1 fa 05             	sar    $0x5,%edx
80103675:	29 c2                	sub    %eax,%edx
80103677:	6b d2 64             	imul   $0x64,%edx,%edx
8010367a:	29 d6                	sub    %edx,%esi
8010367c:	39 f3                	cmp    %esi,%ebx
8010367e:	74 4b                	je     801036cb <wakeup1+0xbb>
		// queue is full
		return -1;
	}

	//update tail
	ptable.pqueues[priority][tail] =  p;
80103680:	6b c7 64             	imul   $0x64,%edi,%eax
80103683:	8d 84 03 34 0d 00 00 	lea    0xd34(%ebx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
8010368a:	83 c3 01             	add    $0x1,%ebx
	ptable.pqueues[priority][tail] =  p;
8010368d:	89 0c 85 c4 1f 11 80 	mov    %ecx,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103694:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103699:	81 c1 d0 00 00 00    	add    $0xd0,%ecx
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
8010369f:	f7 eb                	imul   %ebx
801036a1:	89 d8                	mov    %ebx,%eax
801036a3:	c1 f8 1f             	sar    $0x1f,%eax
801036a6:	c1 fa 05             	sar    $0x5,%edx
801036a9:	29 c2                	sub    %eax,%edx
801036ab:	6b d2 64             	imul   $0x64,%edx,%edx
801036ae:	29 d3                	sub    %edx,%ebx
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036b0:	81 f9 f4 53 11 80    	cmp    $0x801153f4,%ecx
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801036b6:	89 1c fd f8 53 11 80 	mov    %ebx,-0x7feeac08(,%edi,8)
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036bd:	0f 82 77 ff ff ff    	jb     8010363a <wakeup1+0x2a>
}
801036c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c6:	5b                   	pop    %ebx
801036c7:	5e                   	pop    %esi
801036c8:	5f                   	pop    %edi
801036c9:	5d                   	pop    %ebp
801036ca:	c3                   	ret    
				panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801036cb:	83 ec 0c             	sub    $0xc,%esp
801036ce:	68 38 81 10 80       	push   $0x80108138
801036d3:	e8 b8 cc ff ff       	call   80100390 <panic>
801036d8:	90                   	nop
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036e0 <allocproc>:
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036e4:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
{
801036e9:	83 ec 10             	sub    $0x10,%esp
	acquire(&ptable.lock);
801036ec:	68 c0 1f 11 80       	push   $0x80111fc0
801036f1:	e8 aa 11 00 00       	call   801048a0 <acquire>
801036f6:	83 c4 10             	add    $0x10,%esp
801036f9:	eb 17                	jmp    80103712 <allocproc+0x32>
801036fb:	90                   	nop
801036fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103700:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
80103706:	81 fb f4 53 11 80    	cmp    $0x801153f4,%ebx
8010370c:	0f 83 96 00 00 00    	jae    801037a8 <allocproc+0xc8>
		if (p->state == UNUSED) goto found;
80103712:	8b 43 0c             	mov    0xc(%ebx),%eax
80103715:	85 c0                	test   %eax,%eax
80103717:	75 e7                	jne    80103700 <allocproc+0x20>
	p->pid   = nextpid++;
80103719:	a1 08 b0 10 80       	mov    0x8010b008,%eax
	release(&ptable.lock);
8010371e:	83 ec 0c             	sub    $0xc,%esp
	p->state = EMBRYO;
80103721:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	p->pid   = nextpid++;
80103728:	8d 50 01             	lea    0x1(%eax),%edx
8010372b:	89 43 10             	mov    %eax,0x10(%ebx)
	release(&ptable.lock);
8010372e:	68 c0 1f 11 80       	push   $0x80111fc0
	p->pid   = nextpid++;
80103733:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
	release(&ptable.lock);
80103739:	e8 82 12 00 00       	call   801049c0 <release>
	if ((p->kstack = kalloc()) == 0) {
8010373e:	e8 8d ed ff ff       	call   801024d0 <kalloc>
80103743:	83 c4 10             	add    $0x10,%esp
80103746:	85 c0                	test   %eax,%eax
80103748:	89 43 08             	mov    %eax,0x8(%ebx)
8010374b:	74 74                	je     801037c1 <allocproc+0xe1>
	sp -= sizeof *p->tf;
8010374d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
	memset(p->context, 0, sizeof *p->context);
80103753:	83 ec 04             	sub    $0x4,%esp
	sp -= sizeof *p->context;
80103756:	05 9c 0f 00 00       	add    $0xf9c,%eax
	sp -= sizeof *p->tf;
8010375b:	89 53 18             	mov    %edx,0x18(%ebx)
	*(uint *)sp = (uint)trapret;
8010375e:	c7 40 14 6b 63 10 80 	movl   $0x8010636b,0x14(%eax)
	p->context = (struct context *)sp;
80103765:	89 43 1c             	mov    %eax,0x1c(%ebx)
	memset(p->context, 0, sizeof *p->context);
80103768:	6a 14                	push   $0x14
8010376a:	6a 00                	push   $0x0
8010376c:	50                   	push   %eax
8010376d:	e8 ae 12 00 00       	call   80104a20 <memset>
	p->context->eip = (uint)forkret;
80103772:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103775:	8d 93 cc 00 00 00    	lea    0xcc(%ebx),%edx
8010377b:	83 c4 10             	add    $0x10,%esp
8010377e:	c7 40 10 d0 37 10 80 	movl   $0x801037d0,0x10(%eax)
80103785:	8d 43 7c             	lea    0x7c(%ebx),%eax
80103788:	90                   	nop
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		p->mux_ptrs[i] = 0;
80103790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103796:	83 c0 04             	add    $0x4,%eax
	for (i=0; i<MUX_MAXNUM; i++){
80103799:	39 c2                	cmp    %eax,%edx
8010379b:	75 f3                	jne    80103790 <allocproc+0xb0>
}
8010379d:	89 d8                	mov    %ebx,%eax
8010379f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037a2:	c9                   	leave  
801037a3:	c3                   	ret    
801037a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	release(&ptable.lock);
801037a8:	83 ec 0c             	sub    $0xc,%esp
	return 0;
801037ab:	31 db                	xor    %ebx,%ebx
	release(&ptable.lock);
801037ad:	68 c0 1f 11 80       	push   $0x80111fc0
801037b2:	e8 09 12 00 00       	call   801049c0 <release>
}
801037b7:	89 d8                	mov    %ebx,%eax
	return 0;
801037b9:	83 c4 10             	add    $0x10,%esp
}
801037bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037bf:	c9                   	leave  
801037c0:	c3                   	ret    
		p->state = UNUSED;
801037c1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		return 0;
801037c8:	31 db                	xor    %ebx,%ebx
801037ca:	eb d1                	jmp    8010379d <allocproc+0xbd>
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037d0 <forkret>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 14             	sub    $0x14,%esp
	release(&ptable.lock);
801037d6:	68 c0 1f 11 80       	push   $0x80111fc0
801037db:	e8 e0 11 00 00       	call   801049c0 <release>
	if (first) {
801037e0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	85 c0                	test   %eax,%eax
801037ea:	75 04                	jne    801037f0 <forkret+0x20>
}
801037ec:	c9                   	leave  
801037ed:	c3                   	ret    
801037ee:	66 90                	xchg   %ax,%ax
		iinit(ROOTDEV);
801037f0:	83 ec 0c             	sub    $0xc,%esp
		first = 0;
801037f3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801037fa:	00 00 00 
		iinit(ROOTDEV);
801037fd:	6a 01                	push   $0x1
801037ff:	e8 8c dc ff ff       	call   80101490 <iinit>
		initlog(ROOTDEV);
80103804:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010380b:	e8 00 f3 ff ff       	call   80102b10 <initlog>
80103810:	83 c4 10             	add    $0x10,%esp
}
80103813:	c9                   	leave  
80103814:	c3                   	ret    
80103815:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <pinit>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 10             	sub    $0x10,%esp
	initlock(&ptable.lock, "ptable");
80103826:	68 8e 81 10 80       	push   $0x8010818e
8010382b:	68 c0 1f 11 80       	push   $0x80111fc0
80103830:	e8 7b 0f 00 00       	call   801047b0 <initlock>
}
80103835:	83 c4 10             	add    $0x10,%esp
80103838:	c9                   	leave  
80103839:	c3                   	ret    
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103840 <mycpu>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	56                   	push   %esi
80103844:	53                   	push   %ebx
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80103845:	9c                   	pushf  
80103846:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("mycpu called with interrupts enabled\n");
80103847:	f6 c4 02             	test   $0x2,%ah
8010384a:	75 5e                	jne    801038aa <mycpu+0x6a>
	apicid = lapicid();
8010384c:	e8 ef ee ff ff       	call   80102740 <lapicid>
	for (i = 0; i < ncpu; ++i) {
80103851:	8b 35 80 da 12 80    	mov    0x8012da80,%esi
80103857:	85 f6                	test   %esi,%esi
80103859:	7e 42                	jle    8010389d <mycpu+0x5d>
		if (cpus[i].apicid == apicid) return &cpus[i];
8010385b:	0f b6 15 00 d5 12 80 	movzbl 0x8012d500,%edx
80103862:	39 d0                	cmp    %edx,%eax
80103864:	74 30                	je     80103896 <mycpu+0x56>
80103866:	b9 b0 d5 12 80       	mov    $0x8012d5b0,%ecx
	for (i = 0; i < ncpu; ++i) {
8010386b:	31 d2                	xor    %edx,%edx
8010386d:	8d 76 00             	lea    0x0(%esi),%esi
80103870:	83 c2 01             	add    $0x1,%edx
80103873:	39 f2                	cmp    %esi,%edx
80103875:	74 26                	je     8010389d <mycpu+0x5d>
		if (cpus[i].apicid == apicid) return &cpus[i];
80103877:	0f b6 19             	movzbl (%ecx),%ebx
8010387a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103880:	39 c3                	cmp    %eax,%ebx
80103882:	75 ec                	jne    80103870 <mycpu+0x30>
80103884:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010388a:	05 00 d5 12 80       	add    $0x8012d500,%eax
}
8010388f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103892:	5b                   	pop    %ebx
80103893:	5e                   	pop    %esi
80103894:	5d                   	pop    %ebp
80103895:	c3                   	ret    
		if (cpus[i].apicid == apicid) return &cpus[i];
80103896:	b8 00 d5 12 80       	mov    $0x8012d500,%eax
8010389b:	eb f2                	jmp    8010388f <mycpu+0x4f>
	panic("unknown apicid\n");
8010389d:	83 ec 0c             	sub    $0xc,%esp
801038a0:	68 95 81 10 80       	push   $0x80108195
801038a5:	e8 e6 ca ff ff       	call   80100390 <panic>
	if (readeflags() & FL_IF) panic("mycpu called with interrupts enabled\n");
801038aa:	83 ec 0c             	sub    $0xc,%esp
801038ad:	68 68 81 10 80       	push   $0x80108168
801038b2:	e8 d9 ca ff ff       	call   80100390 <panic>
801038b7:	89 f6                	mov    %esi,%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038c0 <cpuid>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 08             	sub    $0x8,%esp
	return mycpu() - cpus;
801038c6:	e8 75 ff ff ff       	call   80103840 <mycpu>
801038cb:	2d 00 d5 12 80       	sub    $0x8012d500,%eax
}
801038d0:	c9                   	leave  
	return mycpu() - cpus;
801038d1:	c1 f8 04             	sar    $0x4,%eax
801038d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038da:	c3                   	ret    
801038db:	90                   	nop
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <myproc>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
801038e4:	83 ec 04             	sub    $0x4,%esp
	pushcli();
801038e7:	e8 74 0f 00 00       	call   80104860 <pushcli>
	c = mycpu();
801038ec:	e8 4f ff ff ff       	call   80103840 <mycpu>
	p = c->proc;
801038f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
801038f7:	e8 64 10 00 00       	call   80104960 <popcli>
}
801038fc:	83 c4 04             	add    $0x4,%esp
801038ff:	89 d8                	mov    %ebx,%eax
80103901:	5b                   	pop    %ebx
80103902:	5d                   	pop    %ebp
80103903:	c3                   	ret    
80103904:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010390a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103910 <userinit>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	57                   	push   %edi
80103914:	56                   	push   %esi
80103915:	53                   	push   %ebx
80103916:	83 ec 0c             	sub    $0xc,%esp
	p = allocproc();
80103919:	e8 c2 fd ff ff       	call   801036e0 <allocproc>
8010391e:	89 c3                	mov    %eax,%ebx
	initproc = p;
80103920:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
	if ((p->pgdir = setupkvm()) == 0) panic("userinit: out of memory?");
80103925:	e8 16 40 00 00       	call   80107940 <setupkvm>
8010392a:	85 c0                	test   %eax,%eax
8010392c:	89 43 04             	mov    %eax,0x4(%ebx)
8010392f:	0f 84 ee 01 00 00    	je     80103b23 <userinit+0x213>
	inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103935:	83 ec 04             	sub    $0x4,%esp
	p->tf->ds     = (SEG_UDATA << 3) | DPL_USER;
80103938:	be 23 00 00 00       	mov    $0x23,%esi
	inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010393d:	68 2c 00 00 00       	push   $0x2c
80103942:	68 60 b4 10 80       	push   $0x8010b460
80103947:	50                   	push   %eax
80103948:	e8 d3 3c 00 00       	call   80107620 <inituvm>
	memset(p->tf, 0, sizeof(*p->tf));
8010394d:	83 c4 0c             	add    $0xc,%esp
	p->sz = PGSIZE;
80103950:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
	memset(p->tf, 0, sizeof(*p->tf));
80103956:	6a 4c                	push   $0x4c
80103958:	6a 00                	push   $0x0
8010395a:	ff 73 18             	pushl  0x18(%ebx)
8010395d:	e8 be 10 00 00       	call   80104a20 <memset>
	p->tf->cs     = (SEG_UCODE << 3) | DPL_USER;
80103962:	8b 43 18             	mov    0x18(%ebx),%eax
80103965:	b9 1b 00 00 00       	mov    $0x1b,%ecx
	safestrcpy(p->name, "initcode", sizeof(p->name));
8010396a:	83 c4 0c             	add    $0xc,%esp
	p->tf->cs     = (SEG_UCODE << 3) | DPL_USER;
8010396d:	66 89 48 3c          	mov    %cx,0x3c(%eax)
	p->tf->ds     = (SEG_UDATA << 3) | DPL_USER;
80103971:	8b 43 18             	mov    0x18(%ebx),%eax
80103974:	66 89 70 2c          	mov    %si,0x2c(%eax)
	p->tf->es     = p->tf->ds;
80103978:	8b 43 18             	mov    0x18(%ebx),%eax
8010397b:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010397f:	66 89 50 28          	mov    %dx,0x28(%eax)
	p->tf->ss     = p->tf->ds;
80103983:	8b 43 18             	mov    0x18(%ebx),%eax
80103986:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010398a:	66 89 50 48          	mov    %dx,0x48(%eax)
	p->tf->eflags = FL_IF;
8010398e:	8b 43 18             	mov    0x18(%ebx),%eax
80103991:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
	p->tf->esp    = PGSIZE;
80103998:	8b 43 18             	mov    0x18(%ebx),%eax
8010399b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
	p->tf->eip    = 0; // beginning of initcode.S
801039a2:	8b 43 18             	mov    0x18(%ebx),%eax
801039a5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
	safestrcpy(p->name, "initcode", sizeof(p->name));
801039ac:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039af:	6a 10                	push   $0x10
801039b1:	68 be 81 10 80       	push   $0x801081be
801039b6:	50                   	push   %eax
801039b7:	e8 44 12 00 00       	call   80104c00 <safestrcpy>
	p->cwd = namei("/");
801039bc:	c7 04 24 c7 81 10 80 	movl   $0x801081c7,(%esp)
801039c3:	e8 28 e5 ff ff       	call   80101ef0 <namei>
801039c8:	89 43 68             	mov    %eax,0x68(%ebx)
	acquire(&ptable.lock);
801039cb:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
801039d2:	e8 c9 0e 00 00       	call   801048a0 <acquire>
	if (!pqueue_ready){
801039d7:	8b 3d b8 b5 10 80    	mov    0x8010b5b8,%edi
801039dd:	83 c4 10             	add    $0x10,%esp
801039e0:	85 ff                	test   %edi,%edi
801039e2:	75 30                	jne    80103a14 <userinit+0x104>
		pqueue_ready = 1;
801039e4:	c7 05 b8 b5 10 80 01 	movl   $0x1,0x8010b5b8
801039eb:	00 00 00 
		p->priority = 0;
801039ee:	c7 83 cc 00 00 00 00 	movl   $0x0,0xcc(%ebx)
801039f5:	00 00 00 
801039f8:	b8 f4 53 11 80       	mov    $0x801153f4,%eax
				ptable.head_tail[m][n] = 0;
801039fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103a03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80103a0a:	83 c0 08             	add    $0x8,%eax
		for (m=0; m<PRIO_MAX; m++){
80103a0d:	3d 94 54 11 80       	cmp    $0x80115494,%eax
80103a12:	75 e9                	jne    801039fd <userinit+0xed>
	int priority = p->priority;
80103a14:	8b bb cc 00 00 00    	mov    0xcc(%ebx),%edi
	p->state = RUNNABLE;
80103a1a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	if (tail == (head-1)%QSIZE){
80103a21:	8b 04 fd f4 53 11 80 	mov    -0x7feeac0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
80103a28:	8b 0c fd f8 53 11 80 	mov    -0x7feeac08(,%edi,8),%ecx
	if (tail == (head-1)%QSIZE){
80103a2f:	8d 70 ff             	lea    -0x1(%eax),%esi
80103a32:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103a37:	f7 ee                	imul   %esi
80103a39:	89 d0                	mov    %edx,%eax
80103a3b:	89 f2                	mov    %esi,%edx
80103a3d:	c1 f8 05             	sar    $0x5,%eax
80103a40:	c1 fa 1f             	sar    $0x1f,%edx
80103a43:	29 d0                	sub    %edx,%eax
80103a45:	6b c0 64             	imul   $0x64,%eax,%eax
80103a48:	29 c6                	sub    %eax,%esi
80103a4a:	39 f1                	cmp    %esi,%ecx
80103a4c:	0f 84 de 00 00 00    	je     80103b30 <userinit+0x220>
	ptable.pqueues[priority][tail] =  p;
80103a52:	6b c7 64             	imul   $0x64,%edi,%eax
	release(&ptable.lock);
80103a55:	83 ec 0c             	sub    $0xc,%esp
80103a58:	68 c0 1f 11 80       	push   $0x80111fc0
	ptable.pqueues[priority][tail] =  p;
80103a5d:	8d 84 01 34 0d 00 00 	lea    0xd34(%ecx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103a64:	83 c1 01             	add    $0x1,%ecx
	ptable.pqueues[priority][tail] =  p;
80103a67:	89 1c 85 c4 1f 11 80 	mov    %ebx,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103a6e:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103a73:	f7 e9                	imul   %ecx
80103a75:	89 d0                	mov    %edx,%eax
80103a77:	89 ca                	mov    %ecx,%edx
80103a79:	c1 fa 1f             	sar    $0x1f,%edx
80103a7c:	c1 f8 05             	sar    $0x5,%eax
80103a7f:	29 d0                	sub    %edx,%eax
80103a81:	6b c0 64             	imul   $0x64,%eax,%eax
80103a84:	29 c1                	sub    %eax,%ecx
80103a86:	89 0c fd f8 53 11 80 	mov    %ecx,-0x7feeac08(,%edi,8)
	release(&ptable.lock);
80103a8d:	e8 2e 0f 00 00       	call   801049c0 <release>
80103a92:	b9 1c 74 11 80       	mov    $0x8011741c,%ecx
80103a97:	83 c4 10             	add    $0x10,%esp
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aa0:	8d 91 a0 0f 00 00    	lea    0xfa0(%ecx),%edx
		MUTEXES.muxes[i].name = 0;
80103aa6:	c7 41 f8 00 00 00 00 	movl   $0x0,-0x8(%ecx)
		MUTEXES.muxes[i].state = -1;
80103aad:	c7 41 fc ff ff ff ff 	movl   $0xffffffff,-0x4(%ecx)
80103ab4:	89 c8                	mov    %ecx,%eax
80103ab6:	8d 76 00             	lea    0x0(%esi),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
			MUTEXES.muxes[i].cv[j] = 0;
80103ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103ac6:	83 c0 04             	add    $0x4,%eax
		for (j=0; j<1000; j++){
80103ac9:	39 d0                	cmp    %edx,%eax
80103acb:	75 f3                	jne    80103ac0 <userinit+0x1b0>
80103acd:	81 c1 a8 0f 00 00    	add    $0xfa8,%ecx
	for(i=0; i<MUX_MAXNUM; i++){
80103ad3:	81 f9 3c ad 12 80    	cmp    $0x8012ad3c,%ecx
80103ad9:	75 c5                	jne    80103aa0 <userinit+0x190>
80103adb:	b8 14 10 11 80       	mov    $0x80111014,%eax
80103ae0:	ba b4 1f 11 80       	mov    $0x80111fb4,%edx
80103ae5:	8d 76 00             	lea    0x0(%esi),%esi
		wqueue.queue[i] = 0;
80103ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103aee:	83 c0 04             	add    $0x4,%eax
	for (i=0; i<1000; i++){
80103af1:	39 c2                	cmp    %eax,%edx
80103af3:	75 f3                	jne    80103ae8 <userinit+0x1d8>
	initlock(&MUTEXES.lock, "mutex_table");
80103af5:	83 ec 08             	sub    $0x8,%esp
80103af8:	68 c9 81 10 80       	push   $0x801081c9
80103afd:	68 e0 73 11 80       	push   $0x801173e0
80103b02:	e8 a9 0c 00 00       	call   801047b0 <initlock>
	initlock(&wqueue.lock, "wqueue");
80103b07:	58                   	pop    %eax
80103b08:	5a                   	pop    %edx
80103b09:	68 d5 81 10 80       	push   $0x801081d5
80103b0e:	68 e0 0f 11 80       	push   $0x80110fe0
80103b13:	e8 98 0c 00 00       	call   801047b0 <initlock>
}
80103b18:	83 c4 10             	add    $0x10,%esp
80103b1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b1e:	5b                   	pop    %ebx
80103b1f:	5e                   	pop    %esi
80103b20:	5f                   	pop    %edi
80103b21:	5d                   	pop    %ebp
80103b22:	c3                   	ret    
	if ((p->pgdir = setupkvm()) == 0) panic("userinit: out of memory?");
80103b23:	83 ec 0c             	sub    $0xc,%esp
80103b26:	68 a5 81 10 80       	push   $0x801081a5
80103b2b:	e8 60 c8 ff ff       	call   80100390 <panic>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	68 38 81 10 80       	push   $0x80108138
80103b38:	e8 53 c8 ff ff       	call   80100390 <panic>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi

80103b40 <growproc>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
80103b45:	8b 75 08             	mov    0x8(%ebp),%esi
	pushcli();
80103b48:	e8 13 0d 00 00       	call   80104860 <pushcli>
	c = mycpu();
80103b4d:	e8 ee fc ff ff       	call   80103840 <mycpu>
	p = c->proc;
80103b52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103b58:	e8 03 0e 00 00       	call   80104960 <popcli>
	if (n > 0) {
80103b5d:	83 fe 00             	cmp    $0x0,%esi
	sz = curproc->sz;
80103b60:	8b 03                	mov    (%ebx),%eax
	if (n > 0) {
80103b62:	7f 1c                	jg     80103b80 <growproc+0x40>
	} else if (n < 0) {
80103b64:	75 3a                	jne    80103ba0 <growproc+0x60>
	switchuvm(curproc);
80103b66:	83 ec 0c             	sub    $0xc,%esp
	curproc->sz = sz;
80103b69:	89 03                	mov    %eax,(%ebx)
	switchuvm(curproc);
80103b6b:	53                   	push   %ebx
80103b6c:	e8 9f 39 00 00       	call   80107510 <switchuvm>
	return 0;
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	31 c0                	xor    %eax,%eax
}
80103b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b79:	5b                   	pop    %ebx
80103b7a:	5e                   	pop    %esi
80103b7b:	5d                   	pop    %ebp
80103b7c:	c3                   	ret    
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
		if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) return -1;
80103b80:	83 ec 04             	sub    $0x4,%esp
80103b83:	01 c6                	add    %eax,%esi
80103b85:	56                   	push   %esi
80103b86:	50                   	push   %eax
80103b87:	ff 73 04             	pushl  0x4(%ebx)
80103b8a:	e8 d1 3b 00 00       	call   80107760 <allocuvm>
80103b8f:	83 c4 10             	add    $0x10,%esp
80103b92:	85 c0                	test   %eax,%eax
80103b94:	75 d0                	jne    80103b66 <growproc+0x26>
80103b96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b9b:	eb d9                	jmp    80103b76 <growproc+0x36>
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi
		if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) return -1;
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	01 c6                	add    %eax,%esi
80103ba5:	56                   	push   %esi
80103ba6:	50                   	push   %eax
80103ba7:	ff 73 04             	pushl  0x4(%ebx)
80103baa:	e8 e1 3c 00 00       	call   80107890 <deallocuvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	75 b0                	jne    80103b66 <growproc+0x26>
80103bb6:	eb de                	jmp    80103b96 <growproc+0x56>
80103bb8:	90                   	nop
80103bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103bc0 <fork>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	57                   	push   %edi
80103bc4:	56                   	push   %esi
80103bc5:	53                   	push   %ebx
80103bc6:	83 ec 1c             	sub    $0x1c,%esp
	pushcli();
80103bc9:	e8 92 0c 00 00       	call   80104860 <pushcli>
	c = mycpu();
80103bce:	e8 6d fc ff ff       	call   80103840 <mycpu>
	p = c->proc;
80103bd3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103bd9:	e8 82 0d 00 00       	call   80104960 <popcli>
	if ((np = allocproc()) == 0) {
80103bde:	e8 fd fa ff ff       	call   801036e0 <allocproc>
80103be3:	85 c0                	test   %eax,%eax
80103be5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103be8:	0f 84 5c 01 00 00    	je     80103d4a <fork+0x18a>
	if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103bee:	83 ec 08             	sub    $0x8,%esp
80103bf1:	ff 33                	pushl  (%ebx)
80103bf3:	ff 73 04             	pushl  0x4(%ebx)
80103bf6:	89 c7                	mov    %eax,%edi
80103bf8:	e8 13 3e 00 00       	call   80107a10 <copyuvm>
80103bfd:	83 c4 10             	add    $0x10,%esp
80103c00:	85 c0                	test   %eax,%eax
80103c02:	89 47 04             	mov    %eax,0x4(%edi)
80103c05:	0f 84 48 01 00 00    	je     80103d53 <fork+0x193>
	np->sz     = curproc->sz;
80103c0b:	8b 03                	mov    (%ebx),%eax
80103c0d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	*np->tf    = *curproc->tf;
80103c10:	b9 13 00 00 00       	mov    $0x13,%ecx
	np->sz     = curproc->sz;
80103c15:	89 07                	mov    %eax,(%edi)
	np->parent = curproc;
80103c17:	89 5f 14             	mov    %ebx,0x14(%edi)
80103c1a:	89 f8                	mov    %edi,%eax
	*np->tf    = *curproc->tf;
80103c1c:	8b 73 18             	mov    0x18(%ebx),%esi
80103c1f:	8b 7f 18             	mov    0x18(%edi),%edi
80103c22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	np->tf->eax = 0;
80103c24:	89 c7                	mov    %eax,%edi
	for (i = 0; i < NOFILE; i++)
80103c26:	31 f6                	xor    %esi,%esi
	np->tf->eax = 0;
80103c28:	8b 40 18             	mov    0x18(%eax),%eax
80103c2b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (curproc->ofile[i]) np->ofile[i] = filedup(curproc->ofile[i]);
80103c38:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c3c:	85 c0                	test   %eax,%eax
80103c3e:	74 10                	je     80103c50 <fork+0x90>
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	50                   	push   %eax
80103c44:	e8 a7 d1 ff ff       	call   80100df0 <filedup>
80103c49:	83 c4 10             	add    $0x10,%esp
80103c4c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
	for (i = 0; i < NOFILE; i++)
80103c50:	83 c6 01             	add    $0x1,%esi
80103c53:	83 fe 10             	cmp    $0x10,%esi
80103c56:	75 e0                	jne    80103c38 <fork+0x78>
	np->cwd = idup(curproc->cwd);
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	ff 73 68             	pushl  0x68(%ebx)
80103c5e:	e8 fd d9 ff ff       	call   80101660 <idup>
80103c63:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c66:	83 c4 0c             	add    $0xc,%esp
	np->cwd = idup(curproc->cwd);
80103c69:	89 46 68             	mov    %eax,0x68(%esi)
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c6c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c6f:	6a 10                	push   $0x10
80103c71:	50                   	push   %eax
80103c72:	8d 46 6c             	lea    0x6c(%esi),%eax
80103c75:	50                   	push   %eax
80103c76:	e8 85 0f 00 00       	call   80104c00 <safestrcpy>
	pid = np->pid;
80103c7b:	8b 46 10             	mov    0x10(%esi),%eax
	acquire(&ptable.lock);
80103c7e:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
	pid = np->pid;
80103c85:	89 45 e0             	mov    %eax,-0x20(%ebp)
	acquire(&ptable.lock);
80103c88:	e8 13 0c 00 00       	call   801048a0 <acquire>
	int priority = p->priority;
80103c8d:	8b be cc 00 00 00    	mov    0xcc(%esi),%edi
	np->state = RUNNABLE;
80103c93:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
	if (tail == (head-1)%QSIZE){
80103c9a:	83 c4 10             	add    $0x10,%esp
	int priority = p->priority;
80103c9d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	if (tail == (head-1)%QSIZE){
80103ca0:	8b 04 fd f4 53 11 80 	mov    -0x7feeac0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
80103ca7:	8b 0c fd f8 53 11 80 	mov    -0x7feeac08(,%edi,8),%ecx
	if (tail == (head-1)%QSIZE){
80103cae:	8d 70 ff             	lea    -0x1(%eax),%esi
80103cb1:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103cb6:	f7 ee                	imul   %esi
80103cb8:	89 f0                	mov    %esi,%eax
80103cba:	c1 f8 1f             	sar    $0x1f,%eax
80103cbd:	c1 fa 05             	sar    $0x5,%edx
80103cc0:	29 c2                	sub    %eax,%edx
80103cc2:	6b c2 64             	imul   $0x64,%edx,%eax
80103cc5:	29 c6                	sub    %eax,%esi
80103cc7:	39 f1                	cmp    %esi,%ecx
80103cc9:	0f 84 ac 00 00 00    	je     80103d7b <fork+0x1bb>
	ptable.pqueues[priority][tail] =  p;
80103ccf:	6b c7 64             	imul   $0x64,%edi,%eax
80103cd2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	release(&ptable.lock);
80103cd5:	83 ec 0c             	sub    $0xc,%esp
80103cd8:	68 c0 1f 11 80       	push   $0x80111fc0
	ptable.pqueues[priority][tail] =  p;
80103cdd:	8d 84 01 34 0d 00 00 	lea    0xd34(%ecx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103ce4:	83 c1 01             	add    $0x1,%ecx
	ptable.pqueues[priority][tail] =  p;
80103ce7:	89 34 85 c4 1f 11 80 	mov    %esi,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80103cee:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103cf3:	f7 e9                	imul   %ecx
80103cf5:	89 c8                	mov    %ecx,%eax
80103cf7:	c1 f8 1f             	sar    $0x1f,%eax
80103cfa:	c1 fa 05             	sar    $0x5,%edx
80103cfd:	29 c2                	sub    %eax,%edx
80103cff:	6b c2 64             	imul   $0x64,%edx,%eax
80103d02:	29 c1                	sub    %eax,%ecx
80103d04:	89 0c fd f8 53 11 80 	mov    %ecx,-0x7feeac08(,%edi,8)
	release(&ptable.lock);
80103d0b:	e8 b0 0c 00 00       	call   801049c0 <release>
80103d10:	83 c4 10             	add    $0x10,%esp
	for(i=0; i<MUX_MAXNUM; i++)
80103d13:	31 c0                	xor    %eax,%eax
80103d15:	89 f1                	mov    %esi,%ecx
80103d17:	89 f6                	mov    %esi,%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		np->mux_ptrs[i] = curproc->mux_ptrs[i];
80103d20:	8b 54 83 7c          	mov    0x7c(%ebx,%eax,4),%edx
80103d24:	89 54 81 7c          	mov    %edx,0x7c(%ecx,%eax,4)
	for(i=0; i<MUX_MAXNUM; i++)
80103d28:	83 c0 01             	add    $0x1,%eax
80103d2b:	83 f8 14             	cmp    $0x14,%eax
80103d2e:	75 f0                	jne    80103d20 <fork+0x160>
	np->priority = curproc->priority;
80103d30:	8b 83 cc 00 00 00    	mov    0xcc(%ebx),%eax
80103d36:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d39:	89 81 cc 00 00 00    	mov    %eax,0xcc(%ecx)
}
80103d3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d45:	5b                   	pop    %ebx
80103d46:	5e                   	pop    %esi
80103d47:	5f                   	pop    %edi
80103d48:	5d                   	pop    %ebp
80103d49:	c3                   	ret    
		return -1;
80103d4a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80103d51:	eb ec                	jmp    80103d3f <fork+0x17f>
		kfree(np->kstack);
80103d53:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103d56:	83 ec 0c             	sub    $0xc,%esp
80103d59:	ff 77 08             	pushl  0x8(%edi)
80103d5c:	e8 bf e5 ff ff       	call   80102320 <kfree>
		np->kstack = 0;
80103d61:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
		np->state  = UNUSED;
80103d68:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
		return -1;
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80103d79:	eb c4                	jmp    80103d3f <fork+0x17f>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
80103d7b:	83 ec 0c             	sub    $0xc,%esp
80103d7e:	68 38 81 10 80       	push   $0x80108138
80103d83:	e8 08 c6 ff ff       	call   80100390 <panic>
80103d88:	90                   	nop
80103d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d90 <scheduler>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 1c             	sub    $0x1c,%esp
	struct cpu * c = mycpu();
80103d99:	e8 a2 fa ff ff       	call   80103840 <mycpu>
	c->proc = 0;
80103d9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103da5:	00 00 00 
	struct cpu * c = mycpu();
80103da8:	89 c6                	mov    %eax,%esi
80103daa:	8d 40 04             	lea    0x4(%eax),%eax
80103dad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	asm volatile("sti");
80103db0:	fb                   	sti    
		acquire(&ptable.lock);
80103db1:	83 ec 0c             	sub    $0xc,%esp
80103db4:	68 c0 1f 11 80       	push   $0x80111fc0
80103db9:	e8 e2 0a 00 00       	call   801048a0 <acquire>
		if (first_time){
80103dbe:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80103dc3:	83 c4 10             	add    $0x10,%esp

struct proc*
pq_dequeue(){

	// go to highest priority, non-empty queue 
	int priority = 0;
80103dc6:	31 c9                	xor    %ecx,%ecx
		if (first_time){
80103dc8:	85 c0                	test   %eax,%eax
80103dca:	74 7c                	je     80103e48 <scheduler+0xb8>
			for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dcc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			first_time = 0;
80103dcf:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
80103dd6:	00 00 00 
			for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103dd9:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
80103dde:	66 90                	xchg   %ax,%ax
				if (p->state != RUNNABLE) continue;
80103de0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103de4:	75 33                	jne    80103e19 <scheduler+0x89>
				switchuvm(p);
80103de6:	83 ec 0c             	sub    $0xc,%esp
				c->proc = p;
80103de9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
				switchuvm(p);
80103def:	53                   	push   %ebx
80103df0:	e8 1b 37 00 00       	call   80107510 <switchuvm>
				p->state = RUNNING;
80103df5:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
				swtch(&(c->scheduler), p->context);
80103dfc:	59                   	pop    %ecx
80103dfd:	58                   	pop    %eax
80103dfe:	ff 73 1c             	pushl  0x1c(%ebx)
80103e01:	57                   	push   %edi
80103e02:	e8 54 0e 00 00       	call   80104c5b <swtch>
				switchkvm();
80103e07:	e8 e4 36 00 00       	call   801074f0 <switchkvm>
				c->proc = 0;
80103e0c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e13:	00 00 00 
80103e16:	83 c4 10             	add    $0x10,%esp
			for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103e19:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
80103e1f:	81 fb f4 53 11 80    	cmp    $0x801153f4,%ebx
80103e25:	72 b9                	jb     80103de0 <scheduler+0x50>
		release(&ptable.lock);
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 c0 1f 11 80       	push   $0x80111fc0
80103e2f:	e8 8c 0b 00 00       	call   801049c0 <release>
		sti();
80103e34:	83 c4 10             	add    $0x10,%esp
80103e37:	e9 74 ff ff ff       	jmp    80103db0 <scheduler+0x20>
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	while (priority < PRIO_MAX && ptable.head_tail[priority][0] == ptable.head_tail[priority][1])	// queue is empty if head == tail
		priority++;
80103e40:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && ptable.head_tail[priority][0] == ptable.head_tail[priority][1])	// queue is empty if head == tail
80103e43:	83 f9 14             	cmp    $0x14,%ecx
80103e46:	74 df                	je     80103e27 <scheduler+0x97>
80103e48:	8b 1c cd f4 53 11 80 	mov    -0x7feeac0c(,%ecx,8),%ebx
80103e4f:	3b 1c cd f8 53 11 80 	cmp    -0x7feeac08(,%ecx,8),%ebx
80103e56:	74 e8                	je     80103e40 <scheduler+0xb0>
		return NULL;
	}

	// get proc
	int head = ptable.head_tail[priority][0];
	struct proc *p = ptable.pqueues[priority][head];
80103e58:	6b c1 64             	imul   $0x64,%ecx,%eax
80103e5b:	8d 84 03 34 0d 00 00 	lea    0xd34(%ebx,%eax,1),%eax

	// update head
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103e62:	83 c3 01             	add    $0x1,%ebx
	struct proc *p = ptable.pqueues[priority][head];
80103e65:	8b 3c 85 c4 1f 11 80 	mov    -0x7feee03c(,%eax,4),%edi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103e6c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103e71:	f7 eb                	imul   %ebx
80103e73:	89 d8                	mov    %ebx,%eax
80103e75:	c1 f8 1f             	sar    $0x1f,%eax
80103e78:	c1 fa 05             	sar    $0x5,%edx
80103e7b:	29 c2                	sub    %eax,%edx
80103e7d:	6b c2 64             	imul   $0x64,%edx,%eax
80103e80:	29 c3                	sub    %eax,%ebx
			while (p != NULL){
80103e82:	83 ff ff             	cmp    $0xffffffff,%edi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103e85:	89 1c cd f4 53 11 80 	mov    %ebx,-0x7feeac0c(,%ecx,8)
			while (p != NULL){
80103e8c:	74 99                	je     80103e27 <scheduler+0x97>
80103e8e:	66 90                	xchg   %ax,%ax
				switchuvm(p);
80103e90:	83 ec 0c             	sub    $0xc,%esp
				c->proc = p;
80103e93:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
				switchuvm(p);
80103e99:	57                   	push   %edi
80103e9a:	e8 71 36 00 00       	call   80107510 <switchuvm>
				p->state = RUNNING;
80103e9f:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
				swtch(&(c->scheduler), p->context);
80103ea6:	58                   	pop    %eax
80103ea7:	5a                   	pop    %edx
80103ea8:	ff 77 1c             	pushl  0x1c(%edi)
80103eab:	ff 75 e4             	pushl  -0x1c(%ebp)
80103eae:	e8 a8 0d 00 00       	call   80104c5b <swtch>
				switchkvm();
80103eb3:	e8 38 36 00 00       	call   801074f0 <switchkvm>
				c->proc = 0;
80103eb8:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103ebf:	00 00 00 
80103ec2:	83 c4 10             	add    $0x10,%esp
	int priority = 0;
80103ec5:	31 c9                	xor    %ecx,%ecx
80103ec7:	eb 13                	jmp    80103edc <scheduler+0x14c>
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		priority++;
80103ed0:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && ptable.head_tail[priority][0] == ptable.head_tail[priority][1])	// queue is empty if head == tail
80103ed3:	83 f9 14             	cmp    $0x14,%ecx
80103ed6:	0f 84 4b ff ff ff    	je     80103e27 <scheduler+0x97>
80103edc:	8b 1c cd f4 53 11 80 	mov    -0x7feeac0c(,%ecx,8),%ebx
80103ee3:	3b 1c cd f8 53 11 80 	cmp    -0x7feeac08(,%ecx,8),%ebx
80103eea:	74 e4                	je     80103ed0 <scheduler+0x140>
	struct proc *p = ptable.pqueues[priority][head];
80103eec:	6b c1 64             	imul   $0x64,%ecx,%eax
80103eef:	8d 84 03 34 0d 00 00 	lea    0xd34(%ebx,%eax,1),%eax
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103ef6:	83 c3 01             	add    $0x1,%ebx
	struct proc *p = ptable.pqueues[priority][head];
80103ef9:	8b 3c 85 c4 1f 11 80 	mov    -0x7feee03c(,%eax,4),%edi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103f00:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80103f05:	f7 eb                	imul   %ebx
80103f07:	89 d8                	mov    %ebx,%eax
80103f09:	c1 f8 1f             	sar    $0x1f,%eax
80103f0c:	c1 fa 05             	sar    $0x5,%edx
80103f0f:	29 c2                	sub    %eax,%edx
80103f11:	6b d2 64             	imul   $0x64,%edx,%edx
80103f14:	29 d3                	sub    %edx,%ebx
			while (p != NULL){
80103f16:	83 ff ff             	cmp    $0xffffffff,%edi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80103f19:	89 1c cd f4 53 11 80 	mov    %ebx,-0x7feeac0c(,%ecx,8)
			while (p != NULL){
80103f20:	0f 85 6a ff ff ff    	jne    80103e90 <scheduler+0x100>
		release(&ptable.lock);
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	68 c0 1f 11 80       	push   $0x80111fc0
80103f2e:	e8 8d 0a 00 00       	call   801049c0 <release>
		sti();
80103f33:	83 c4 10             	add    $0x10,%esp
80103f36:	e9 75 fe ff ff       	jmp    80103db0 <scheduler+0x20>
80103f3b:	90                   	nop
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f40 <sched>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
	pushcli();
80103f45:	e8 16 09 00 00       	call   80104860 <pushcli>
	c = mycpu();
80103f4a:	e8 f1 f8 ff ff       	call   80103840 <mycpu>
	p = c->proc;
80103f4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80103f55:	e8 06 0a 00 00       	call   80104960 <popcli>
	if (!holding(&ptable.lock)) panic("sched ptable.lock");
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 c0 1f 11 80       	push   $0x80111fc0
80103f62:	e8 b9 08 00 00       	call   80104820 <holding>
80103f67:	83 c4 10             	add    $0x10,%esp
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	74 4f                	je     80103fbd <sched+0x7d>
	if (mycpu()->ncli != 1) panic("sched locks");
80103f6e:	e8 cd f8 ff ff       	call   80103840 <mycpu>
80103f73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f7a:	75 68                	jne    80103fe4 <sched+0xa4>
	if (p->state == RUNNING) panic("sched running");
80103f7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f80:	74 55                	je     80103fd7 <sched+0x97>
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80103f82:	9c                   	pushf  
80103f83:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("sched interruptible");
80103f84:	f6 c4 02             	test   $0x2,%ah
80103f87:	75 41                	jne    80103fca <sched+0x8a>
	intena = mycpu()->intena;
80103f89:	e8 b2 f8 ff ff       	call   80103840 <mycpu>
	swtch(&p->context, mycpu()->scheduler);
80103f8e:	83 c3 1c             	add    $0x1c,%ebx
	intena = mycpu()->intena;
80103f91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
	swtch(&p->context, mycpu()->scheduler);
80103f97:	e8 a4 f8 ff ff       	call   80103840 <mycpu>
80103f9c:	83 ec 08             	sub    $0x8,%esp
80103f9f:	ff 70 04             	pushl  0x4(%eax)
80103fa2:	53                   	push   %ebx
80103fa3:	e8 b3 0c 00 00       	call   80104c5b <swtch>
	mycpu()->intena = intena;
80103fa8:	e8 93 f8 ff ff       	call   80103840 <mycpu>
}
80103fad:	83 c4 10             	add    $0x10,%esp
	mycpu()->intena = intena;
80103fb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb9:	5b                   	pop    %ebx
80103fba:	5e                   	pop    %esi
80103fbb:	5d                   	pop    %ebp
80103fbc:	c3                   	ret    
	if (!holding(&ptable.lock)) panic("sched ptable.lock");
80103fbd:	83 ec 0c             	sub    $0xc,%esp
80103fc0:	68 dc 81 10 80       	push   $0x801081dc
80103fc5:	e8 c6 c3 ff ff       	call   80100390 <panic>
	if (readeflags() & FL_IF) panic("sched interruptible");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 08 82 10 80       	push   $0x80108208
80103fd2:	e8 b9 c3 ff ff       	call   80100390 <panic>
	if (p->state == RUNNING) panic("sched running");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 fa 81 10 80       	push   $0x801081fa
80103fdf:	e8 ac c3 ff ff       	call   80100390 <panic>
	if (mycpu()->ncli != 1) panic("sched locks");
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	68 ee 81 10 80       	push   $0x801081ee
80103fec:	e8 9f c3 ff ff       	call   80100390 <panic>
80103ff1:	eb 0d                	jmp    80104000 <exit>
80103ff3:	90                   	nop
80103ff4:	90                   	nop
80103ff5:	90                   	nop
80103ff6:	90                   	nop
80103ff7:	90                   	nop
80103ff8:	90                   	nop
80103ff9:	90                   	nop
80103ffa:	90                   	nop
80103ffb:	90                   	nop
80103ffc:	90                   	nop
80103ffd:	90                   	nop
80103ffe:	90                   	nop
80103fff:	90                   	nop

80104000 <exit>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
	pushcli();
80104009:	e8 52 08 00 00       	call   80104860 <pushcli>
	c = mycpu();
8010400e:	e8 2d f8 ff ff       	call   80103840 <mycpu>
	p = c->proc;
80104013:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	popcli();
80104019:	e8 42 09 00 00       	call   80104960 <popcli>
	if (curproc == initproc) panic("init exiting");
8010401e:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
80104024:	8d 5e 28             	lea    0x28(%esi),%ebx
80104027:	8d 7e 68             	lea    0x68(%esi),%edi
8010402a:	0f 84 b1 00 00 00    	je     801040e1 <exit+0xe1>
		if (curproc->ofile[fd]) {
80104030:	8b 03                	mov    (%ebx),%eax
80104032:	85 c0                	test   %eax,%eax
80104034:	74 12                	je     80104048 <exit+0x48>
			fileclose(curproc->ofile[fd]);
80104036:	83 ec 0c             	sub    $0xc,%esp
80104039:	50                   	push   %eax
8010403a:	e8 01 ce ff ff       	call   80100e40 <fileclose>
			curproc->ofile[fd] = 0;
8010403f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104045:	83 c4 10             	add    $0x10,%esp
80104048:	83 c3 04             	add    $0x4,%ebx
	for (fd = 0; fd < NOFILE; fd++) {
8010404b:	39 df                	cmp    %ebx,%edi
8010404d:	75 e1                	jne    80104030 <exit+0x30>
	begin_op();
8010404f:	e8 5c eb ff ff       	call   80102bb0 <begin_op>
	iput(curproc->cwd);
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	ff 76 68             	pushl  0x68(%esi)
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010405a:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
	iput(curproc->cwd);
8010405f:	e8 5c d7 ff ff       	call   801017c0 <iput>
	end_op();
80104064:	e8 b7 eb ff ff       	call   80102c20 <end_op>
	curproc->cwd = 0;
80104069:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
	acquire(&ptable.lock);
80104070:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80104077:	e8 24 08 00 00       	call   801048a0 <acquire>
	wakeup1(curproc->parent);
8010407c:	8b 46 14             	mov    0x14(%esi),%eax
8010407f:	e8 8c f5 ff ff       	call   80103610 <wakeup1>
80104084:	83 c4 10             	add    $0x10,%esp
80104087:	eb 15                	jmp    8010409e <exit+0x9e>
80104089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104090:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
80104096:	81 fb f4 53 11 80    	cmp    $0x801153f4,%ebx
8010409c:	73 2a                	jae    801040c8 <exit+0xc8>
		if (p->parent == curproc) {
8010409e:	39 73 14             	cmp    %esi,0x14(%ebx)
801040a1:	75 ed                	jne    80104090 <exit+0x90>
			if (p->state == ZOMBIE) wakeup1(initproc);
801040a3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
			p->parent = initproc;
801040a7:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801040ac:	89 43 14             	mov    %eax,0x14(%ebx)
			if (p->state == ZOMBIE) wakeup1(initproc);
801040af:	75 df                	jne    80104090 <exit+0x90>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040b1:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
			if (p->state == ZOMBIE) wakeup1(initproc);
801040b7:	e8 54 f5 ff ff       	call   80103610 <wakeup1>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040bc:	81 fb f4 53 11 80    	cmp    $0x801153f4,%ebx
801040c2:	72 da                	jb     8010409e <exit+0x9e>
801040c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	curproc->state = ZOMBIE;
801040c8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
	sched();
801040cf:	e8 6c fe ff ff       	call   80103f40 <sched>
	panic("zombie exit");
801040d4:	83 ec 0c             	sub    $0xc,%esp
801040d7:	68 29 82 10 80       	push   $0x80108229
801040dc:	e8 af c2 ff ff       	call   80100390 <panic>
	if (curproc == initproc) panic("init exiting");
801040e1:	83 ec 0c             	sub    $0xc,%esp
801040e4:	68 1c 82 10 80       	push   $0x8010821c
801040e9:	e8 a2 c2 ff ff       	call   80100390 <panic>
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <yield>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 18             	sub    $0x18,%esp
	acquire(&ptable.lock); // DOC: yieldlock
801040f9:	68 c0 1f 11 80       	push   $0x80111fc0
801040fe:	e8 9d 07 00 00       	call   801048a0 <acquire>
	pushcli();
80104103:	e8 58 07 00 00       	call   80104860 <pushcli>
	c = mycpu();
80104108:	e8 33 f7 ff ff       	call   80103840 <mycpu>
	p = c->proc;
8010410d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
80104113:	e8 48 08 00 00       	call   80104960 <popcli>
	myproc()->state = RUNNABLE;
80104118:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
	pushcli();
8010411f:	e8 3c 07 00 00       	call   80104860 <pushcli>
	c = mycpu();
80104124:	e8 17 f7 ff ff       	call   80103840 <mycpu>
	p = c->proc;
80104129:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
	popcli();
8010412f:	e8 2c 08 00 00       	call   80104960 <popcli>
	if (!(p->state == RUNNABLE)){
80104134:	83 c4 10             	add    $0x10,%esp
80104137:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
8010413b:	75 7c                	jne    801041b9 <yield+0xc9>
	int priority = p->priority;
8010413d:	8b b7 cc 00 00 00    	mov    0xcc(%edi),%esi
	if (tail == (head-1)%QSIZE){
80104143:	8b 04 f5 f4 53 11 80 	mov    -0x7feeac0c(,%esi,8),%eax
	int tail = ptable.head_tail[priority][1];
8010414a:	8b 0c f5 f8 53 11 80 	mov    -0x7feeac08(,%esi,8),%ecx
	if (tail == (head-1)%QSIZE){
80104151:	8d 58 ff             	lea    -0x1(%eax),%ebx
80104154:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104159:	f7 eb                	imul   %ebx
8010415b:	89 d8                	mov    %ebx,%eax
8010415d:	c1 f8 1f             	sar    $0x1f,%eax
80104160:	c1 fa 05             	sar    $0x5,%edx
80104163:	29 c2                	sub    %eax,%edx
80104165:	6b d2 64             	imul   $0x64,%edx,%edx
80104168:	29 d3                	sub    %edx,%ebx
8010416a:	39 d9                	cmp    %ebx,%ecx
8010416c:	74 4b                	je     801041b9 <yield+0xc9>
	ptable.pqueues[priority][tail] =  p;
8010416e:	6b c6 64             	imul   $0x64,%esi,%eax
80104171:	8d 84 01 34 0d 00 00 	lea    0xd34(%ecx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104178:	83 c1 01             	add    $0x1,%ecx
	ptable.pqueues[priority][tail] =  p;
8010417b:	89 3c 85 c4 1f 11 80 	mov    %edi,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104182:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104187:	f7 e9                	imul   %ecx
80104189:	89 c8                	mov    %ecx,%eax
8010418b:	c1 f8 1f             	sar    $0x1f,%eax
8010418e:	c1 fa 05             	sar    $0x5,%edx
80104191:	29 c2                	sub    %eax,%edx
80104193:	6b d2 64             	imul   $0x64,%edx,%edx
80104196:	29 d1                	sub    %edx,%ecx
80104198:	89 0c f5 f8 53 11 80 	mov    %ecx,-0x7feeac08(,%esi,8)
	sched();
8010419f:	e8 9c fd ff ff       	call   80103f40 <sched>
	release(&ptable.lock);
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	68 c0 1f 11 80       	push   $0x80111fc0
801041ac:	e8 0f 08 00 00       	call   801049c0 <release>
}
801041b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041b4:	5b                   	pop    %ebx
801041b5:	5e                   	pop    %esi
801041b6:	5f                   	pop    %edi
801041b7:	5d                   	pop    %ebp
801041b8:	c3                   	ret    
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801041b9:	83 ec 0c             	sub    $0xc,%esp
801041bc:	68 38 81 10 80       	push   $0x80108138
801041c1:	e8 ca c1 ff ff       	call   80100390 <panic>
801041c6:	8d 76 00             	lea    0x0(%esi),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041d0 <sleep>:
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	pushcli();
801041df:	e8 7c 06 00 00       	call   80104860 <pushcli>
	c = mycpu();
801041e4:	e8 57 f6 ff ff       	call   80103840 <mycpu>
	p = c->proc;
801041e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
	popcli();
801041ef:	e8 6c 07 00 00       	call   80104960 <popcli>
	if (p == 0) panic("sleep");
801041f4:	85 db                	test   %ebx,%ebx
801041f6:	0f 84 87 00 00 00    	je     80104283 <sleep+0xb3>
	if (lk == 0) panic("sleep without lk");
801041fc:	85 f6                	test   %esi,%esi
801041fe:	74 76                	je     80104276 <sleep+0xa6>
	if (lk != &ptable.lock) {      // DOC: sleeplock0
80104200:	81 fe c0 1f 11 80    	cmp    $0x80111fc0,%esi
80104206:	74 50                	je     80104258 <sleep+0x88>
		acquire(&ptable.lock); // DOC: sleeplock1
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 c0 1f 11 80       	push   $0x80111fc0
80104210:	e8 8b 06 00 00       	call   801048a0 <acquire>
		release(lk);
80104215:	89 34 24             	mov    %esi,(%esp)
80104218:	e8 a3 07 00 00       	call   801049c0 <release>
	p->chan  = chan;
8010421d:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
80104220:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	sched();
80104227:	e8 14 fd ff ff       	call   80103f40 <sched>
	p->chan = 0;
8010422c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
		release(&ptable.lock);
80104233:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
8010423a:	e8 81 07 00 00       	call   801049c0 <release>
		acquire(lk);
8010423f:	89 75 08             	mov    %esi,0x8(%ebp)
80104242:	83 c4 10             	add    $0x10,%esp
}
80104245:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104248:	5b                   	pop    %ebx
80104249:	5e                   	pop    %esi
8010424a:	5f                   	pop    %edi
8010424b:	5d                   	pop    %ebp
		acquire(lk);
8010424c:	e9 4f 06 00 00       	jmp    801048a0 <acquire>
80104251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	p->chan  = chan;
80104258:	89 7b 20             	mov    %edi,0x20(%ebx)
	p->state = SLEEPING;
8010425b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	sched();
80104262:	e8 d9 fc ff ff       	call   80103f40 <sched>
	p->chan = 0;
80104267:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010426e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104271:	5b                   	pop    %ebx
80104272:	5e                   	pop    %esi
80104273:	5f                   	pop    %edi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret    
	if (lk == 0) panic("sleep without lk");
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	68 3b 82 10 80       	push   $0x8010823b
8010427e:	e8 0d c1 ff ff       	call   80100390 <panic>
	if (p == 0) panic("sleep");
80104283:	83 ec 0c             	sub    $0xc,%esp
80104286:	68 35 82 10 80       	push   $0x80108235
8010428b:	e8 00 c1 ff ff       	call   80100390 <panic>

80104290 <wait>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
	pushcli();
80104295:	e8 c6 05 00 00       	call   80104860 <pushcli>
	c = mycpu();
8010429a:	e8 a1 f5 ff ff       	call   80103840 <mycpu>
	p = c->proc;
8010429f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
	popcli();
801042a5:	e8 b6 06 00 00       	call   80104960 <popcli>
	acquire(&ptable.lock);
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	68 c0 1f 11 80       	push   $0x80111fc0
801042b2:	e8 e9 05 00 00       	call   801048a0 <acquire>
801042b7:	83 c4 10             	add    $0x10,%esp
		havekids = 0;
801042ba:	31 c0                	xor    %eax,%eax
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042bc:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
801042c1:	eb 13                	jmp    801042d6 <wait+0x46>
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c8:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
801042ce:	81 fb f4 53 11 80    	cmp    $0x801153f4,%ebx
801042d4:	73 1e                	jae    801042f4 <wait+0x64>
			if (p->parent != curproc) continue;
801042d6:	39 73 14             	cmp    %esi,0x14(%ebx)
801042d9:	75 ed                	jne    801042c8 <wait+0x38>
			if (p->state == ZOMBIE) {
801042db:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042df:	74 37                	je     80104318 <wait+0x88>
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042e1:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
			havekids = 1;
801042e7:	b8 01 00 00 00       	mov    $0x1,%eax
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042ec:	81 fb f4 53 11 80    	cmp    $0x801153f4,%ebx
801042f2:	72 e2                	jb     801042d6 <wait+0x46>
		if (!havekids || curproc->killed) {
801042f4:	85 c0                	test   %eax,%eax
801042f6:	74 76                	je     8010436e <wait+0xde>
801042f8:	8b 46 24             	mov    0x24(%esi),%eax
801042fb:	85 c0                	test   %eax,%eax
801042fd:	75 6f                	jne    8010436e <wait+0xde>
		sleep(curproc, &ptable.lock); // DOC: wait-sleep
801042ff:	83 ec 08             	sub    $0x8,%esp
80104302:	68 c0 1f 11 80       	push   $0x80111fc0
80104307:	56                   	push   %esi
80104308:	e8 c3 fe ff ff       	call   801041d0 <sleep>
		havekids = 0;
8010430d:	83 c4 10             	add    $0x10,%esp
80104310:	eb a8                	jmp    801042ba <wait+0x2a>
80104312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				kfree(p->kstack);
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	ff 73 08             	pushl  0x8(%ebx)
				pid = p->pid;
8010431e:	8b 73 10             	mov    0x10(%ebx),%esi
				kfree(p->kstack);
80104321:	e8 fa df ff ff       	call   80102320 <kfree>
				freevm(p->pgdir);
80104326:	5a                   	pop    %edx
80104327:	ff 73 04             	pushl  0x4(%ebx)
				p->kstack = 0;
8010432a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
				freevm(p->pgdir);
80104331:	e8 8a 35 00 00       	call   801078c0 <freevm>
				release(&ptable.lock);
80104336:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
				p->pid     = 0;
8010433d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
				p->parent  = 0;
80104344:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
				p->name[0] = 0;
8010434b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
				p->killed  = 0;
8010434f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
				p->state   = UNUSED;
80104356:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
				release(&ptable.lock);
8010435d:	e8 5e 06 00 00       	call   801049c0 <release>
				return pid;
80104362:	83 c4 10             	add    $0x10,%esp
}
80104365:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104368:	89 f0                	mov    %esi,%eax
8010436a:	5b                   	pop    %ebx
8010436b:	5e                   	pop    %esi
8010436c:	5d                   	pop    %ebp
8010436d:	c3                   	ret    
			release(&ptable.lock);
8010436e:	83 ec 0c             	sub    $0xc,%esp
			return -1;
80104371:	be ff ff ff ff       	mov    $0xffffffff,%esi
			release(&ptable.lock);
80104376:	68 c0 1f 11 80       	push   $0x80111fc0
8010437b:	e8 40 06 00 00       	call   801049c0 <release>
			return -1;
80104380:	83 c4 10             	add    $0x10,%esp
80104383:	eb e0                	jmp    80104365 <wait+0xd5>
80104385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <wakeup>:
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
8010439a:	68 c0 1f 11 80       	push   $0x80111fc0
8010439f:	e8 fc 04 00 00       	call   801048a0 <acquire>
	wakeup1(chan);
801043a4:	89 d8                	mov    %ebx,%eax
801043a6:	e8 65 f2 ff ff       	call   80103610 <wakeup1>
	release(&ptable.lock);
801043ab:	83 c4 10             	add    $0x10,%esp
801043ae:	c7 45 08 c0 1f 11 80 	movl   $0x80111fc0,0x8(%ebp)
}
801043b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b8:	c9                   	leave  
	release(&ptable.lock);
801043b9:	e9 02 06 00 00       	jmp    801049c0 <release>
801043be:	66 90                	xchg   %ax,%ax

801043c0 <kill>:
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	57                   	push   %edi
801043c4:	56                   	push   %esi
801043c5:	53                   	push   %ebx
801043c6:	83 ec 18             	sub    $0x18,%esp
801043c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
801043cc:	68 c0 1f 11 80       	push   $0x80111fc0
801043d1:	e8 ca 04 00 00       	call   801048a0 <acquire>
801043d6:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043d9:	b9 f4 1f 11 80       	mov    $0x80111ff4,%ecx
801043de:	eb 12                	jmp    801043f2 <kill+0x32>
801043e0:	81 c1 d0 00 00 00    	add    $0xd0,%ecx
801043e6:	81 f9 f4 53 11 80    	cmp    $0x801153f4,%ecx
801043ec:	0f 83 9e 00 00 00    	jae    80104490 <kill+0xd0>
		if (p->pid == pid) {
801043f2:	39 59 10             	cmp    %ebx,0x10(%ecx)
801043f5:	75 e9                	jne    801043e0 <kill+0x20>
			if (p->state == SLEEPING){
801043f7:	83 79 0c 02          	cmpl   $0x2,0xc(%ecx)
			p->killed = 1;
801043fb:	c7 41 24 01 00 00 00 	movl   $0x1,0x24(%ecx)
			if (p->state == SLEEPING){
80104402:	75 69                	jne    8010446d <kill+0xad>
	int priority = p->priority;
80104404:	8b b9 cc 00 00 00    	mov    0xcc(%ecx),%edi
				p->state = RUNNABLE;
8010440a:	c7 41 0c 03 00 00 00 	movl   $0x3,0xc(%ecx)
	if (tail == (head-1)%QSIZE){
80104411:	8b 04 fd f4 53 11 80 	mov    -0x7feeac0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
80104418:	8b 1c fd f8 53 11 80 	mov    -0x7feeac08(,%edi,8),%ebx
	if (tail == (head-1)%QSIZE){
8010441f:	8d 70 ff             	lea    -0x1(%eax),%esi
80104422:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104427:	f7 ee                	imul   %esi
80104429:	89 f0                	mov    %esi,%eax
8010442b:	c1 f8 1f             	sar    $0x1f,%eax
8010442e:	c1 fa 05             	sar    $0x5,%edx
80104431:	29 c2                	sub    %eax,%edx
80104433:	6b c2 64             	imul   $0x64,%edx,%eax
80104436:	29 c6                	sub    %eax,%esi
80104438:	39 f3                	cmp    %esi,%ebx
8010443a:	74 71                	je     801044ad <kill+0xed>
	ptable.pqueues[priority][tail] =  p;
8010443c:	6b c7 64             	imul   $0x64,%edi,%eax
8010443f:	8d 84 03 34 0d 00 00 	lea    0xd34(%ebx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104446:	83 c3 01             	add    $0x1,%ebx
	ptable.pqueues[priority][tail] =  p;
80104449:	89 0c 85 c4 1f 11 80 	mov    %ecx,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
80104450:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
80104455:	f7 eb                	imul   %ebx
80104457:	89 d8                	mov    %ebx,%eax
80104459:	c1 f8 1f             	sar    $0x1f,%eax
8010445c:	c1 fa 05             	sar    $0x5,%edx
8010445f:	29 c2                	sub    %eax,%edx
80104461:	6b c2 64             	imul   $0x64,%edx,%eax
80104464:	29 c3                	sub    %eax,%ebx
80104466:	89 1c fd f8 53 11 80 	mov    %ebx,-0x7feeac08(,%edi,8)
			release(&ptable.lock);
8010446d:	83 ec 0c             	sub    $0xc,%esp
80104470:	68 c0 1f 11 80       	push   $0x80111fc0
80104475:	e8 46 05 00 00       	call   801049c0 <release>
			return 0;
8010447a:	83 c4 10             	add    $0x10,%esp
}
8010447d:	8d 65 f4             	lea    -0xc(%ebp),%esp
			return 0;
80104480:	31 c0                	xor    %eax,%eax
}
80104482:	5b                   	pop    %ebx
80104483:	5e                   	pop    %esi
80104484:	5f                   	pop    %edi
80104485:	5d                   	pop    %ebp
80104486:	c3                   	ret    
80104487:	89 f6                	mov    %esi,%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	release(&ptable.lock);
80104490:	83 ec 0c             	sub    $0xc,%esp
80104493:	68 c0 1f 11 80       	push   $0x80111fc0
80104498:	e8 23 05 00 00       	call   801049c0 <release>
	return -1;
8010449d:	83 c4 10             	add    $0x10,%esp
}
801044a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
801044a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044a8:	5b                   	pop    %ebx
801044a9:	5e                   	pop    %esi
801044aa:	5f                   	pop    %edi
801044ab:	5d                   	pop    %ebp
801044ac:	c3                   	ret    
					panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801044ad:	83 ec 0c             	sub    $0xc,%esp
801044b0:	68 38 81 10 80       	push   $0x80108138
801044b5:	e8 d6 be ff ff       	call   80100390 <panic>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <procdump>:
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	56                   	push   %esi
801044c5:	53                   	push   %ebx
801044c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044c9:	bb f4 1f 11 80       	mov    $0x80111ff4,%ebx
{
801044ce:	83 ec 3c             	sub    $0x3c,%esp
801044d1:	eb 27                	jmp    801044fa <procdump+0x3a>
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("\n");
801044d8:	83 ec 0c             	sub    $0xc,%esp
801044db:	68 c7 85 10 80       	push   $0x801085c7
801044e0:	e8 7b c1 ff ff       	call   80100660 <cprintf>
801044e5:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044e8:	81 c3 d0 00 00 00    	add    $0xd0,%ebx
801044ee:	81 fb f4 53 11 80    	cmp    $0x801153f4,%ebx
801044f4:	0f 83 86 00 00 00    	jae    80104580 <procdump+0xc0>
		if (p->state == UNUSED) continue;
801044fa:	8b 43 0c             	mov    0xc(%ebx),%eax
801044fd:	85 c0                	test   %eax,%eax
801044ff:	74 e7                	je     801044e8 <procdump+0x28>
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104501:	83 f8 05             	cmp    $0x5,%eax
			state = "???";
80104504:	ba 4c 82 10 80       	mov    $0x8010824c,%edx
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104509:	77 11                	ja     8010451c <procdump+0x5c>
8010450b:	8b 14 85 84 82 10 80 	mov    -0x7fef7d7c(,%eax,4),%edx
			state = "???";
80104512:	b8 4c 82 10 80       	mov    $0x8010824c,%eax
80104517:	85 d2                	test   %edx,%edx
80104519:	0f 44 d0             	cmove  %eax,%edx
		cprintf("%d %s %s", p->pid, state, p->name);
8010451c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010451f:	50                   	push   %eax
80104520:	52                   	push   %edx
80104521:	ff 73 10             	pushl  0x10(%ebx)
80104524:	68 50 82 10 80       	push   $0x80108250
80104529:	e8 32 c1 ff ff       	call   80100660 <cprintf>
		if (p->state == SLEEPING) {
8010452e:	83 c4 10             	add    $0x10,%esp
80104531:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104535:	75 a1                	jne    801044d8 <procdump+0x18>
			getcallerpcs((uint *)p->context->ebp + 2, pc);
80104537:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010453a:	83 ec 08             	sub    $0x8,%esp
8010453d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104540:	50                   	push   %eax
80104541:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104544:	8b 40 0c             	mov    0xc(%eax),%eax
80104547:	83 c0 08             	add    $0x8,%eax
8010454a:	50                   	push   %eax
8010454b:	e8 80 02 00 00       	call   801047d0 <getcallerpcs>
80104550:	83 c4 10             	add    $0x10,%esp
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			for (i = 0; i < 10 && pc[i] != 0; i++) cprintf(" %p", pc[i]);
80104558:	8b 17                	mov    (%edi),%edx
8010455a:	85 d2                	test   %edx,%edx
8010455c:	0f 84 76 ff ff ff    	je     801044d8 <procdump+0x18>
80104562:	83 ec 08             	sub    $0x8,%esp
80104565:	83 c7 04             	add    $0x4,%edi
80104568:	52                   	push   %edx
80104569:	68 21 7c 10 80       	push   $0x80107c21
8010456e:	e8 ed c0 ff ff       	call   80100660 <cprintf>
80104573:	83 c4 10             	add    $0x10,%esp
80104576:	39 fe                	cmp    %edi,%esi
80104578:	75 de                	jne    80104558 <procdump+0x98>
8010457a:	e9 59 ff ff ff       	jmp    801044d8 <procdump+0x18>
8010457f:	90                   	nop
}
80104580:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104583:	5b                   	pop    %ebx
80104584:	5e                   	pop    %esi
80104585:	5f                   	pop    %edi
80104586:	5d                   	pop    %ebp
80104587:	c3                   	ret    
80104588:	90                   	nop
80104589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104590 <pq_enqueue>:
pq_enqueue (struct proc *p){
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
	if (!(p->state == RUNNABLE)){
80104595:	8b 45 08             	mov    0x8(%ebp),%eax
pq_enqueue (struct proc *p){
80104598:	53                   	push   %ebx
	if (!(p->state == RUNNABLE)){
80104599:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010459d:	75 71                	jne    80104610 <pq_enqueue+0x80>
	int priority = p->priority;
8010459f:	8b b8 cc 00 00 00    	mov    0xcc(%eax),%edi
	if (tail == (head-1)%QSIZE){
801045a5:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
801045aa:	8b 04 fd f4 53 11 80 	mov    -0x7feeac0c(,%edi,8),%eax
	int tail = ptable.head_tail[priority][1];
801045b1:	8b 1c fd f8 53 11 80 	mov    -0x7feeac08(,%edi,8),%ebx
	if (tail == (head-1)%QSIZE){
801045b8:	8d 70 ff             	lea    -0x1(%eax),%esi
801045bb:	89 f0                	mov    %esi,%eax
801045bd:	f7 e9                	imul   %ecx
801045bf:	89 f0                	mov    %esi,%eax
801045c1:	c1 f8 1f             	sar    $0x1f,%eax
801045c4:	c1 fa 05             	sar    $0x5,%edx
801045c7:	29 c2                	sub    %eax,%edx
801045c9:	6b d2 64             	imul   $0x64,%edx,%edx
801045cc:	29 d6                	sub    %edx,%esi
801045ce:	39 de                	cmp    %ebx,%esi
801045d0:	74 3e                	je     80104610 <pq_enqueue+0x80>
	ptable.pqueues[priority][tail] =  p;
801045d2:	6b c7 64             	imul   $0x64,%edi,%eax
801045d5:	8b 75 08             	mov    0x8(%ebp),%esi
801045d8:	8d 84 03 34 0d 00 00 	lea    0xd34(%ebx,%eax,1),%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801045df:	83 c3 01             	add    $0x1,%ebx
	ptable.pqueues[priority][tail] =  p;
801045e2:	89 34 85 c4 1f 11 80 	mov    %esi,-0x7feee03c(,%eax,4)
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801045e9:	89 d8                	mov    %ebx,%eax
801045eb:	f7 e9                	imul   %ecx
801045ed:	89 d8                	mov    %ebx,%eax
801045ef:	c1 f8 1f             	sar    $0x1f,%eax
801045f2:	89 d1                	mov    %edx,%ecx
801045f4:	c1 f9 05             	sar    $0x5,%ecx
801045f7:	29 c1                	sub    %eax,%ecx
	return 1;
801045f9:	b8 01 00 00 00       	mov    $0x1,%eax
	ptable.head_tail[priority][1] = (tail+1)%QSIZE;
801045fe:	6b c9 64             	imul   $0x64,%ecx,%ecx
80104601:	29 cb                	sub    %ecx,%ebx
80104603:	89 1c fd f8 53 11 80 	mov    %ebx,-0x7feeac08(,%edi,8)
}
8010460a:	5b                   	pop    %ebx
8010460b:	5e                   	pop    %esi
8010460c:	5f                   	pop    %edi
8010460d:	5d                   	pop    %ebp
8010460e:	c3                   	ret    
8010460f:	90                   	nop
		return -1;
80104610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104615:	eb f3                	jmp    8010460a <pq_enqueue+0x7a>
80104617:	89 f6                	mov    %esi,%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <pq_dequeue>:
pq_dequeue(){
80104620:	55                   	push   %ebp
	int priority = 0;
80104621:	31 c9                	xor    %ecx,%ecx
pq_dequeue(){
80104623:	89 e5                	mov    %esp,%ebp
80104625:	56                   	push   %esi
80104626:	53                   	push   %ebx
80104627:	eb 0f                	jmp    80104638 <pq_dequeue+0x18>
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		priority++;
80104630:	83 c1 01             	add    $0x1,%ecx
	while (priority < PRIO_MAX && ptable.head_tail[priority][0] == ptable.head_tail[priority][1])	// queue is empty if head == tail
80104633:	83 f9 14             	cmp    $0x14,%ecx
80104636:	74 50                	je     80104688 <pq_dequeue+0x68>
80104638:	8b 04 cd f4 53 11 80 	mov    -0x7feeac0c(,%ecx,8),%eax
8010463f:	3b 04 cd f8 53 11 80 	cmp    -0x7feeac08(,%ecx,8),%eax
80104646:	74 e8                	je     80104630 <pq_dequeue+0x10>
	struct proc *p = ptable.pqueues[priority][head];
80104648:	6b d1 64             	imul   $0x64,%ecx,%edx
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
8010464b:	8d 58 01             	lea    0x1(%eax),%ebx
	struct proc *p = ptable.pqueues[priority][head];
8010464e:	8d 94 10 34 0d 00 00 	lea    0xd34(%eax,%edx,1),%edx
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80104655:	89 d8                	mov    %ebx,%eax
	struct proc *p = ptable.pqueues[priority][head];
80104657:	8b 34 95 c4 1f 11 80 	mov    -0x7feee03c(,%edx,4),%esi
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
8010465e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80104663:	f7 ea                	imul   %edx
80104665:	89 d8                	mov    %ebx,%eax
80104667:	c1 f8 1f             	sar    $0x1f,%eax
8010466a:	c1 fa 05             	sar    $0x5,%edx
8010466d:	29 c2                	sub    %eax,%edx
8010466f:	89 d8                	mov    %ebx,%eax
80104671:	6b d2 64             	imul   $0x64,%edx,%edx
	return p;
80104674:	5b                   	pop    %ebx
	ptable.head_tail[priority][0] = (head+1)%QSIZE;
80104675:	29 d0                	sub    %edx,%eax
80104677:	89 04 cd f4 53 11 80 	mov    %eax,-0x7feeac0c(,%ecx,8)
8010467e:	89 f0                	mov    %esi,%eax
80104680:	5e                   	pop    %esi
80104681:	5d                   	pop    %ebp
80104682:	c3                   	ret    
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		return NULL;
80104688:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010468d:	89 f0                	mov    %esi,%eax
8010468f:	5b                   	pop    %ebx
80104690:	5e                   	pop    %esi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	66 90                	xchg   %ax,%ax
80104695:	66 90                	xchg   %ax,%ax
80104697:	66 90                	xchg   %ax,%ax
80104699:	66 90                	xchg   %ax,%ax
8010469b:	66 90                	xchg   %ax,%ax
8010469d:	66 90                	xchg   %ax,%ax
8010469f:	90                   	nop

801046a0 <initsleeplock>:
// #include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	53                   	push   %ebx
801046a4:	83 ec 0c             	sub    $0xc,%esp
801046a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&lk->lk, "sleep lock");
801046aa:	68 9c 82 10 80       	push   $0x8010829c
801046af:	8d 43 04             	lea    0x4(%ebx),%eax
801046b2:	50                   	push   %eax
801046b3:	e8 f8 00 00 00       	call   801047b0 <initlock>
	lk->name   = name;
801046b8:	8b 45 0c             	mov    0xc(%ebp),%eax
	lk->locked = 0;
801046bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	lk->pid    = 0;
}
801046c1:	83 c4 10             	add    $0x10,%esp
	lk->pid    = 0;
801046c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
	lk->name   = name;
801046cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801046ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d1:	c9                   	leave  
801046d2:	c3                   	ret    
801046d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lk->lk);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	8d 73 04             	lea    0x4(%ebx),%esi
801046ee:	56                   	push   %esi
801046ef:	e8 ac 01 00 00       	call   801048a0 <acquire>
	while (lk->locked) {
801046f4:	8b 13                	mov    (%ebx),%edx
801046f6:	83 c4 10             	add    $0x10,%esp
801046f9:	85 d2                	test   %edx,%edx
801046fb:	74 16                	je     80104713 <acquiresleep+0x33>
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
		sleep(lk, &lk->lk);
80104700:	83 ec 08             	sub    $0x8,%esp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	e8 c6 fa ff ff       	call   801041d0 <sleep>
	while (lk->locked) {
8010470a:	8b 03                	mov    (%ebx),%eax
8010470c:	83 c4 10             	add    $0x10,%esp
8010470f:	85 c0                	test   %eax,%eax
80104711:	75 ed                	jne    80104700 <acquiresleep+0x20>
	}
	lk->locked = 1;
80104713:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
	lk->pid    = myproc()->pid;
80104719:	e8 c2 f1 ff ff       	call   801038e0 <myproc>
8010471e:	8b 40 10             	mov    0x10(%eax),%eax
80104721:	89 43 3c             	mov    %eax,0x3c(%ebx)
	release(&lk->lk);
80104724:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104727:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010472a:	5b                   	pop    %ebx
8010472b:	5e                   	pop    %esi
8010472c:	5d                   	pop    %ebp
	release(&lk->lk);
8010472d:	e9 8e 02 00 00       	jmp    801049c0 <release>
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lk->lk);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	8d 73 04             	lea    0x4(%ebx),%esi
8010474e:	56                   	push   %esi
8010474f:	e8 4c 01 00 00       	call   801048a0 <acquire>
	lk->locked = 0;
80104754:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	lk->pid    = 0;
8010475a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
	wakeup(lk);
80104761:	89 1c 24             	mov    %ebx,(%esp)
80104764:	e8 27 fc ff ff       	call   80104390 <wakeup>
	release(&lk->lk);
80104769:	89 75 08             	mov    %esi,0x8(%ebp)
8010476c:	83 c4 10             	add    $0x10,%esp
}
8010476f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104772:	5b                   	pop    %ebx
80104773:	5e                   	pop    %esi
80104774:	5d                   	pop    %ebp
	release(&lk->lk);
80104775:	e9 46 02 00 00       	jmp    801049c0 <release>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	8b 75 08             	mov    0x8(%ebp),%esi
	int r;

	acquire(&lk->lk);
80104788:	83 ec 0c             	sub    $0xc,%esp
8010478b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010478e:	53                   	push   %ebx
8010478f:	e8 0c 01 00 00       	call   801048a0 <acquire>
	r = lk->locked;
80104794:	8b 36                	mov    (%esi),%esi
	release(&lk->lk);
80104796:	89 1c 24             	mov    %ebx,(%esp)
80104799:	e8 22 02 00 00       	call   801049c0 <release>
	return r;
}
8010479e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a1:	89 f0                	mov    %esi,%eax
801047a3:	5b                   	pop    %ebx
801047a4:	5e                   	pop    %esi
801047a5:	5d                   	pop    %ebp
801047a6:	c3                   	ret    
801047a7:	66 90                	xchg   %ax,%ax
801047a9:	66 90                	xchg   %ax,%ax
801047ab:	66 90                	xchg   %ax,%ax
801047ad:	66 90                	xchg   %ax,%ax
801047af:	90                   	nop

801047b0 <initlock>:
#include "proc.h"
// #include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->name   = name;
801047b6:	8b 55 0c             	mov    0xc(%ebp),%edx
	lk->locked = 0;
801047b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	lk->name   = name;
801047bf:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu    = 0;
801047c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
801047cb:	90                   	nop
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047d0:	55                   	push   %ebp
	uint *ebp;
	int   i;

	ebp = (uint *)v - 2;
	for (i = 0; i < 10; i++) {
801047d1:	31 d2                	xor    %edx,%edx
{
801047d3:	89 e5                	mov    %esp,%ebp
801047d5:	53                   	push   %ebx
	ebp = (uint *)v - 2;
801047d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	ebp = (uint *)v - 2;
801047dc:	83 e8 08             	sub    $0x8,%eax
801047df:	90                   	nop
		if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff) break;
801047e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047ec:	77 1a                	ja     80104808 <getcallerpcs+0x38>
		pcs[i] = ebp[1];         // saved %eip
801047ee:	8b 58 04             	mov    0x4(%eax),%ebx
801047f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
	for (i = 0; i < 10; i++) {
801047f4:	83 c2 01             	add    $0x1,%edx
		ebp    = (uint *)ebp[0]; // saved %ebp
801047f7:	8b 00                	mov    (%eax),%eax
	for (i = 0; i < 10; i++) {
801047f9:	83 fa 0a             	cmp    $0xa,%edx
801047fc:	75 e2                	jne    801047e0 <getcallerpcs+0x10>
	}
	for (; i < 10; i++) pcs[i] = 0;
}
801047fe:	5b                   	pop    %ebx
801047ff:	5d                   	pop    %ebp
80104800:	c3                   	ret    
80104801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104808:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010480b:	83 c1 28             	add    $0x28,%ecx
8010480e:	66 90                	xchg   %ax,%ax
	for (; i < 10; i++) pcs[i] = 0;
80104810:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104816:	83 c0 04             	add    $0x4,%eax
80104819:	39 c1                	cmp    %eax,%ecx
8010481b:	75 f3                	jne    80104810 <getcallerpcs+0x40>
}
8010481d:	5b                   	pop    %ebx
8010481e:	5d                   	pop    %ebp
8010481f:	c3                   	ret    

80104820 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 04             	sub    $0x4,%esp
80104827:	8b 55 08             	mov    0x8(%ebp),%edx
	return lock->locked && lock->cpu == mycpu();
8010482a:	8b 02                	mov    (%edx),%eax
8010482c:	85 c0                	test   %eax,%eax
8010482e:	75 10                	jne    80104840 <holding+0x20>
}
80104830:	83 c4 04             	add    $0x4,%esp
80104833:	31 c0                	xor    %eax,%eax
80104835:	5b                   	pop    %ebx
80104836:	5d                   	pop    %ebp
80104837:	c3                   	ret    
80104838:	90                   	nop
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return lock->locked && lock->cpu == mycpu();
80104840:	8b 5a 08             	mov    0x8(%edx),%ebx
80104843:	e8 f8 ef ff ff       	call   80103840 <mycpu>
80104848:	39 c3                	cmp    %eax,%ebx
8010484a:	0f 94 c0             	sete   %al
}
8010484d:	83 c4 04             	add    $0x4,%esp
	return lock->locked && lock->cpu == mycpu();
80104850:	0f b6 c0             	movzbl %al,%eax
}
80104853:	5b                   	pop    %ebx
80104854:	5d                   	pop    %ebp
80104855:	c3                   	ret    
80104856:	8d 76 00             	lea    0x0(%esi),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	53                   	push   %ebx
80104864:	83 ec 04             	sub    $0x4,%esp
80104867:	9c                   	pushf  
80104868:	5b                   	pop    %ebx
	asm volatile("cli");
80104869:	fa                   	cli    
	int eflags;

	eflags = readeflags();
	cli();
	if (mycpu()->ncli == 0) mycpu()->intena = eflags & FL_IF;
8010486a:	e8 d1 ef ff ff       	call   80103840 <mycpu>
8010486f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104875:	85 c0                	test   %eax,%eax
80104877:	75 11                	jne    8010488a <pushcli+0x2a>
80104879:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010487f:	e8 bc ef ff ff       	call   80103840 <mycpu>
80104884:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
	mycpu()->ncli += 1;
8010488a:	e8 b1 ef ff ff       	call   80103840 <mycpu>
8010488f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104896:	83 c4 04             	add    $0x4,%esp
80104899:	5b                   	pop    %ebx
8010489a:	5d                   	pop    %ebp
8010489b:	c3                   	ret    
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <acquire>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
	pushcli(); // disable interrupts to avoid deadlock.
801048a5:	e8 b6 ff ff ff       	call   80104860 <pushcli>
	if (holding(lk)) panic("acquire");
801048aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == mycpu();
801048ad:	8b 03                	mov    (%ebx),%eax
801048af:	85 c0                	test   %eax,%eax
801048b1:	0f 85 81 00 00 00    	jne    80104938 <acquire+0x98>
	asm volatile("lock; xchgl %0, %1" : "+m"(*addr), "=a"(result) : "1"(newval) : "cc");
801048b7:	ba 01 00 00 00       	mov    $0x1,%edx
801048bc:	eb 05                	jmp    801048c3 <acquire+0x23>
801048be:	66 90                	xchg   %ax,%ax
801048c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048c3:	89 d0                	mov    %edx,%eax
801048c5:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
801048c8:	85 c0                	test   %eax,%eax
801048ca:	75 f4                	jne    801048c0 <acquire+0x20>
	__sync_synchronize();
801048cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
	lk->cpu = mycpu();
801048d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048d4:	e8 67 ef ff ff       	call   80103840 <mycpu>
	for (i = 0; i < 10; i++) {
801048d9:	31 d2                	xor    %edx,%edx
	getcallerpcs(&lk, lk->pcs);
801048db:	8d 4b 0c             	lea    0xc(%ebx),%ecx
	lk->cpu = mycpu();
801048de:	89 43 08             	mov    %eax,0x8(%ebx)
	ebp = (uint *)v - 2;
801048e1:	89 e8                	mov    %ebp,%eax
801048e3:	90                   	nop
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (ebp == 0 || ebp < (uint *)KERNBASE || ebp == (uint *)0xffffffff) break;
801048e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801048ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048f4:	77 1a                	ja     80104910 <acquire+0x70>
		pcs[i] = ebp[1];         // saved %eip
801048f6:	8b 58 04             	mov    0x4(%eax),%ebx
801048f9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
	for (i = 0; i < 10; i++) {
801048fc:	83 c2 01             	add    $0x1,%edx
		ebp    = (uint *)ebp[0]; // saved %ebp
801048ff:	8b 00                	mov    (%eax),%eax
	for (i = 0; i < 10; i++) {
80104901:	83 fa 0a             	cmp    $0xa,%edx
80104904:	75 e2                	jne    801048e8 <acquire+0x48>
}
80104906:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104909:	5b                   	pop    %ebx
8010490a:	5e                   	pop    %esi
8010490b:	5d                   	pop    %ebp
8010490c:	c3                   	ret    
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
80104910:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104913:	83 c1 28             	add    $0x28,%ecx
80104916:	8d 76 00             	lea    0x0(%esi),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	for (; i < 10; i++) pcs[i] = 0;
80104920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104926:	83 c0 04             	add    $0x4,%eax
80104929:	39 c8                	cmp    %ecx,%eax
8010492b:	75 f3                	jne    80104920 <acquire+0x80>
}
8010492d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104930:	5b                   	pop    %ebx
80104931:	5e                   	pop    %esi
80104932:	5d                   	pop    %ebp
80104933:	c3                   	ret    
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	return lock->locked && lock->cpu == mycpu();
80104938:	8b 73 08             	mov    0x8(%ebx),%esi
8010493b:	e8 00 ef ff ff       	call   80103840 <mycpu>
80104940:	39 c6                	cmp    %eax,%esi
80104942:	0f 85 6f ff ff ff    	jne    801048b7 <acquire+0x17>
	if (holding(lk)) panic("acquire");
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	68 a7 82 10 80       	push   $0x801082a7
80104950:	e8 3b ba ff ff       	call   80100390 <panic>
80104955:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104960 <popcli>:

void
popcli(void)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	83 ec 08             	sub    $0x8,%esp
	asm volatile("pushfl; popl %0" : "=r"(eflags));
80104966:	9c                   	pushf  
80104967:	58                   	pop    %eax
	if (readeflags() & FL_IF) panic("popcli - interruptible");
80104968:	f6 c4 02             	test   $0x2,%ah
8010496b:	75 35                	jne    801049a2 <popcli+0x42>
	if (--mycpu()->ncli < 0) panic("popcli");
8010496d:	e8 ce ee ff ff       	call   80103840 <mycpu>
80104972:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104979:	78 34                	js     801049af <popcli+0x4f>
	if (mycpu()->ncli == 0 && mycpu()->intena) sti();
8010497b:	e8 c0 ee ff ff       	call   80103840 <mycpu>
80104980:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104986:	85 d2                	test   %edx,%edx
80104988:	74 06                	je     80104990 <popcli+0x30>
}
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (mycpu()->ncli == 0 && mycpu()->intena) sti();
80104990:	e8 ab ee ff ff       	call   80103840 <mycpu>
80104995:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010499b:	85 c0                	test   %eax,%eax
8010499d:	74 eb                	je     8010498a <popcli+0x2a>
	asm volatile("sti");
8010499f:	fb                   	sti    
}
801049a0:	c9                   	leave  
801049a1:	c3                   	ret    
	if (readeflags() & FL_IF) panic("popcli - interruptible");
801049a2:	83 ec 0c             	sub    $0xc,%esp
801049a5:	68 af 82 10 80       	push   $0x801082af
801049aa:	e8 e1 b9 ff ff       	call   80100390 <panic>
	if (--mycpu()->ncli < 0) panic("popcli");
801049af:	83 ec 0c             	sub    $0xc,%esp
801049b2:	68 c6 82 10 80       	push   $0x801082c6
801049b7:	e8 d4 b9 ff ff       	call   80100390 <panic>
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049c0 <release>:
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	56                   	push   %esi
801049c4:	53                   	push   %ebx
801049c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == mycpu();
801049c8:	8b 03                	mov    (%ebx),%eax
801049ca:	85 c0                	test   %eax,%eax
801049cc:	74 0c                	je     801049da <release+0x1a>
801049ce:	8b 73 08             	mov    0x8(%ebx),%esi
801049d1:	e8 6a ee ff ff       	call   80103840 <mycpu>
801049d6:	39 c6                	cmp    %eax,%esi
801049d8:	74 16                	je     801049f0 <release+0x30>
	if (!holding(lk)) panic("release");
801049da:	83 ec 0c             	sub    $0xc,%esp
801049dd:	68 cd 82 10 80       	push   $0x801082cd
801049e2:	e8 a9 b9 ff ff       	call   80100390 <panic>
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	lk->pcs[0] = 0;
801049f0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
	lk->cpu    = 0;
801049f7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	__sync_synchronize();
801049fe:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
	asm volatile("movl $0, %0" : "+m"(lk->locked) :);
80104a03:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a0c:	5b                   	pop    %ebx
80104a0d:	5e                   	pop    %esi
80104a0e:	5d                   	pop    %ebp
	popcli();
80104a0f:	e9 4c ff ff ff       	jmp    80104960 <popcli>
80104a14:	66 90                	xchg   %ax,%ax
80104a16:	66 90                	xchg   %ax,%ax
80104a18:	66 90                	xchg   %ax,%ax
80104a1a:	66 90                	xchg   %ax,%ax
80104a1c:	66 90                	xchg   %ax,%ax
80104a1e:	66 90                	xchg   %ax,%ax

80104a20 <memset>:
#include "types.h"
#include "x86.h"

void *
memset(void *dst, int c, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	53                   	push   %ebx
80104a25:	8b 55 08             	mov    0x8(%ebp),%edx
80104a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
	if ((int)dst % 4 == 0 && n % 4 == 0) {
80104a2b:	f6 c2 03             	test   $0x3,%dl
80104a2e:	75 05                	jne    80104a35 <memset+0x15>
80104a30:	f6 c1 03             	test   $0x3,%cl
80104a33:	74 13                	je     80104a48 <memset+0x28>
	asm volatile("cld; rep stosb" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
80104a35:	89 d7                	mov    %edx,%edi
80104a37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a3a:	fc                   	cld    
80104a3b:	f3 aa                	rep stos %al,%es:(%edi)
		c &= 0xFF;
		stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
	} else
		stosb(dst, c, n);
	return dst;
}
80104a3d:	5b                   	pop    %ebx
80104a3e:	89 d0                	mov    %edx,%eax
80104a40:	5f                   	pop    %edi
80104a41:	5d                   	pop    %ebp
80104a42:	c3                   	ret    
80104a43:	90                   	nop
80104a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		c &= 0xFF;
80104a48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
		stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
80104a4c:	c1 e9 02             	shr    $0x2,%ecx
80104a4f:	89 f8                	mov    %edi,%eax
80104a51:	89 fb                	mov    %edi,%ebx
80104a53:	c1 e0 18             	shl    $0x18,%eax
80104a56:	c1 e3 10             	shl    $0x10,%ebx
80104a59:	09 d8                	or     %ebx,%eax
80104a5b:	09 f8                	or     %edi,%eax
80104a5d:	c1 e7 08             	shl    $0x8,%edi
80104a60:	09 f8                	or     %edi,%eax
	asm volatile("cld; rep stosl" : "=D"(addr), "=c"(cnt) : "0"(addr), "1"(cnt), "a"(data) : "memory", "cc");
80104a62:	89 d7                	mov    %edx,%edi
80104a64:	fc                   	cld    
80104a65:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104a67:	5b                   	pop    %ebx
80104a68:	89 d0                	mov    %edx,%eax
80104a6a:	5f                   	pop    %edi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret    
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	53                   	push   %ebx
80104a76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a79:	8b 75 08             	mov    0x8(%ebp),%esi
80104a7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
80104a7f:	85 db                	test   %ebx,%ebx
80104a81:	74 29                	je     80104aac <memcmp+0x3c>
		if (*s1 != *s2) return *s1 - *s2;
80104a83:	0f b6 16             	movzbl (%esi),%edx
80104a86:	0f b6 0f             	movzbl (%edi),%ecx
80104a89:	38 d1                	cmp    %dl,%cl
80104a8b:	75 2b                	jne    80104ab8 <memcmp+0x48>
80104a8d:	b8 01 00 00 00       	mov    $0x1,%eax
80104a92:	eb 14                	jmp    80104aa8 <memcmp+0x38>
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a98:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104a9c:	83 c0 01             	add    $0x1,%eax
80104a9f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104aa4:	38 ca                	cmp    %cl,%dl
80104aa6:	75 10                	jne    80104ab8 <memcmp+0x48>
	while (n-- > 0) {
80104aa8:	39 d8                	cmp    %ebx,%eax
80104aaa:	75 ec                	jne    80104a98 <memcmp+0x28>
		s1++, s2++;
	}

	return 0;
}
80104aac:	5b                   	pop    %ebx
	return 0;
80104aad:	31 c0                	xor    %eax,%eax
}
80104aaf:	5e                   	pop    %esi
80104ab0:	5f                   	pop    %edi
80104ab1:	5d                   	pop    %ebp
80104ab2:	c3                   	ret    
80104ab3:	90                   	nop
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (*s1 != *s2) return *s1 - *s2;
80104ab8:	0f b6 c2             	movzbl %dl,%eax
}
80104abb:	5b                   	pop    %ebx
		if (*s1 != *s2) return *s1 - *s2;
80104abc:	29 c8                	sub    %ecx,%eax
}
80104abe:	5e                   	pop    %esi
80104abf:	5f                   	pop    %edi
80104ac0:	5d                   	pop    %ebp
80104ac1:	c3                   	ret    
80104ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ad8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104adb:	8b 75 10             	mov    0x10(%ebp),%esi
	const char *s;
	char *      d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
80104ade:	39 c3                	cmp    %eax,%ebx
80104ae0:	73 26                	jae    80104b08 <memmove+0x38>
80104ae2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104ae5:	39 c8                	cmp    %ecx,%eax
80104ae7:	73 1f                	jae    80104b08 <memmove+0x38>
		s += n;
		d += n;
		while (n-- > 0) *--d = *--s;
80104ae9:	85 f6                	test   %esi,%esi
80104aeb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104aee:	74 0f                	je     80104aff <memmove+0x2f>
80104af0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104af4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104af7:	83 ea 01             	sub    $0x1,%edx
80104afa:	83 fa ff             	cmp    $0xffffffff,%edx
80104afd:	75 f1                	jne    80104af0 <memmove+0x20>
	} else
		while (n-- > 0) *d++ = *s++;

	return dst;
}
80104aff:	5b                   	pop    %ebx
80104b00:	5e                   	pop    %esi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		while (n-- > 0) *d++ = *s++;
80104b08:	31 d2                	xor    %edx,%edx
80104b0a:	85 f6                	test   %esi,%esi
80104b0c:	74 f1                	je     80104aff <memmove+0x2f>
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b17:	83 c2 01             	add    $0x1,%edx
80104b1a:	39 d6                	cmp    %edx,%esi
80104b1c:	75 f2                	jne    80104b10 <memmove+0x40>
}
80104b1e:	5b                   	pop    %ebx
80104b1f:	5e                   	pop    %esi
80104b20:	5d                   	pop    %ebp
80104b21:	c3                   	ret    
80104b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
}
80104b33:	5d                   	pop    %ebp
	return memmove(dst, src, n);
80104b34:	eb 9a                	jmp    80104ad0 <memmove>
80104b36:	8d 76 00             	lea    0x0(%esi),%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	56                   	push   %esi
80104b45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b48:	53                   	push   %ebx
80104b49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
	while (n > 0 && *p && *p == *q) n--, p++, q++;
80104b4f:	85 ff                	test   %edi,%edi
80104b51:	74 2f                	je     80104b82 <strncmp+0x42>
80104b53:	0f b6 01             	movzbl (%ecx),%eax
80104b56:	0f b6 1e             	movzbl (%esi),%ebx
80104b59:	84 c0                	test   %al,%al
80104b5b:	74 37                	je     80104b94 <strncmp+0x54>
80104b5d:	38 c3                	cmp    %al,%bl
80104b5f:	75 33                	jne    80104b94 <strncmp+0x54>
80104b61:	01 f7                	add    %esi,%edi
80104b63:	eb 13                	jmp    80104b78 <strncmp+0x38>
80104b65:	8d 76 00             	lea    0x0(%esi),%esi
80104b68:	0f b6 01             	movzbl (%ecx),%eax
80104b6b:	84 c0                	test   %al,%al
80104b6d:	74 21                	je     80104b90 <strncmp+0x50>
80104b6f:	0f b6 1a             	movzbl (%edx),%ebx
80104b72:	89 d6                	mov    %edx,%esi
80104b74:	38 d8                	cmp    %bl,%al
80104b76:	75 1c                	jne    80104b94 <strncmp+0x54>
80104b78:	8d 56 01             	lea    0x1(%esi),%edx
80104b7b:	83 c1 01             	add    $0x1,%ecx
80104b7e:	39 fa                	cmp    %edi,%edx
80104b80:	75 e6                	jne    80104b68 <strncmp+0x28>
	if (n == 0) return 0;
	return (uchar)*p - (uchar)*q;
}
80104b82:	5b                   	pop    %ebx
	if (n == 0) return 0;
80104b83:	31 c0                	xor    %eax,%eax
}
80104b85:	5e                   	pop    %esi
80104b86:	5f                   	pop    %edi
80104b87:	5d                   	pop    %ebp
80104b88:	c3                   	ret    
80104b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
	return (uchar)*p - (uchar)*q;
80104b94:	29 d8                	sub    %ebx,%eax
}
80104b96:	5b                   	pop    %ebx
80104b97:	5e                   	pop    %esi
80104b98:	5f                   	pop    %edi
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	90                   	nop
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
80104ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ba8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bab:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
80104bae:	89 c2                	mov    %eax,%edx
80104bb0:	eb 19                	jmp    80104bcb <strncpy+0x2b>
80104bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb8:	83 c3 01             	add    $0x1,%ebx
80104bbb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104bbf:	83 c2 01             	add    $0x1,%edx
80104bc2:	84 c9                	test   %cl,%cl
80104bc4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bc7:	74 09                	je     80104bd2 <strncpy+0x32>
80104bc9:	89 f1                	mov    %esi,%ecx
80104bcb:	85 c9                	test   %ecx,%ecx
80104bcd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104bd0:	7f e6                	jg     80104bb8 <strncpy+0x18>
		;
	while (n-- > 0) *s++ = 0;
80104bd2:	31 c9                	xor    %ecx,%ecx
80104bd4:	85 f6                	test   %esi,%esi
80104bd6:	7e 17                	jle    80104bef <strncpy+0x4f>
80104bd8:	90                   	nop
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104be4:	89 f3                	mov    %esi,%ebx
80104be6:	83 c1 01             	add    $0x1,%ecx
80104be9:	29 cb                	sub    %ecx,%ebx
80104beb:	85 db                	test   %ebx,%ebx
80104bed:	7f f1                	jg     80104be0 <strncpy+0x40>
	return os;
}
80104bef:	5b                   	pop    %ebx
80104bf0:	5e                   	pop    %esi
80104bf1:	5d                   	pop    %ebp
80104bf2:	c3                   	ret    
80104bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
80104c05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c08:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *os;

	os = s;
	if (n <= 0) return os;
80104c0e:	85 c9                	test   %ecx,%ecx
80104c10:	7e 26                	jle    80104c38 <safestrcpy+0x38>
80104c12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c16:	89 c1                	mov    %eax,%ecx
80104c18:	eb 17                	jmp    80104c31 <safestrcpy+0x31>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	while (--n > 0 && (*s++ = *t++) != 0)
80104c20:	83 c2 01             	add    $0x1,%edx
80104c23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c27:	83 c1 01             	add    $0x1,%ecx
80104c2a:	84 db                	test   %bl,%bl
80104c2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c2f:	74 04                	je     80104c35 <safestrcpy+0x35>
80104c31:	39 f2                	cmp    %esi,%edx
80104c33:	75 eb                	jne    80104c20 <safestrcpy+0x20>
		;
	*s = 0;
80104c35:	c6 01 00             	movb   $0x0,(%ecx)
	return os;
}
80104c38:	5b                   	pop    %ebx
80104c39:	5e                   	pop    %esi
80104c3a:	5d                   	pop    %ebp
80104c3b:	c3                   	ret    
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <strlen>:

int
strlen(const char *s)
{
80104c40:	55                   	push   %ebp
	int n;

	for (n = 0; s[n]; n++)
80104c41:	31 c0                	xor    %eax,%eax
{
80104c43:	89 e5                	mov    %esp,%ebp
80104c45:	8b 55 08             	mov    0x8(%ebp),%edx
	for (n = 0; s[n]; n++)
80104c48:	80 3a 00             	cmpb   $0x0,(%edx)
80104c4b:	74 0c                	je     80104c59 <strlen+0x19>
80104c4d:	8d 76 00             	lea    0x0(%esi),%esi
80104c50:	83 c0 01             	add    $0x1,%eax
80104c53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c57:	75 f7                	jne    80104c50 <strlen+0x10>
		;
	return n;
}
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    

80104c5b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104c63:	55                   	push   %ebp
  pushl %ebx
80104c64:	53                   	push   %ebx
  pushl %esi
80104c65:	56                   	push   %esi
  pushl %edi
80104c66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c69:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104c6b:	5f                   	pop    %edi
  popl %esi
80104c6c:	5e                   	pop    %esi
  popl %ebx
80104c6d:	5b                   	pop    %ebx
  popl %ebp
80104c6e:	5d                   	pop    %ebp
  ret
80104c6f:	c3                   	ret    

80104c70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct proc *curproc = myproc();
80104c7a:	e8 61 ec ff ff       	call   801038e0 <myproc>

	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104c7f:	8b 00                	mov    (%eax),%eax
80104c81:	39 d8                	cmp    %ebx,%eax
80104c83:	76 1b                	jbe    80104ca0 <fetchint+0x30>
80104c85:	8d 53 04             	lea    0x4(%ebx),%edx
80104c88:	39 d0                	cmp    %edx,%eax
80104c8a:	72 14                	jb     80104ca0 <fetchint+0x30>
	*ip = *(int *)(addr);
80104c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c8f:	8b 13                	mov    (%ebx),%edx
80104c91:	89 10                	mov    %edx,(%eax)
	return 0;
80104c93:	31 c0                	xor    %eax,%eax
}
80104c95:	83 c4 04             	add    $0x4,%esp
80104c98:	5b                   	pop    %ebx
80104c99:	5d                   	pop    %ebp
80104c9a:	c3                   	ret    
80104c9b:	90                   	nop
80104c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca5:	eb ee                	jmp    80104c95 <fetchint+0x25>
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	53                   	push   %ebx
80104cb4:	83 ec 04             	sub    $0x4,%esp
80104cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *       s, *ep;
	struct proc *curproc = myproc();
80104cba:	e8 21 ec ff ff       	call   801038e0 <myproc>

	if (addr >= curproc->sz) return -1;
80104cbf:	39 18                	cmp    %ebx,(%eax)
80104cc1:	76 29                	jbe    80104cec <fetchstr+0x3c>
	*pp = (char *)addr;
80104cc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104cc6:	89 da                	mov    %ebx,%edx
80104cc8:	89 19                	mov    %ebx,(%ecx)
	ep  = (char *)curproc->sz;
80104cca:	8b 00                	mov    (%eax),%eax
	for (s = *pp; s < ep; s++) {
80104ccc:	39 c3                	cmp    %eax,%ebx
80104cce:	73 1c                	jae    80104cec <fetchstr+0x3c>
		if (*s == 0) return s - *pp;
80104cd0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104cd3:	75 10                	jne    80104ce5 <fetchstr+0x35>
80104cd5:	eb 39                	jmp    80104d10 <fetchstr+0x60>
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ce0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ce3:	74 1b                	je     80104d00 <fetchstr+0x50>
	for (s = *pp; s < ep; s++) {
80104ce5:	83 c2 01             	add    $0x1,%edx
80104ce8:	39 d0                	cmp    %edx,%eax
80104cea:	77 f4                	ja     80104ce0 <fetchstr+0x30>
	if (addr >= curproc->sz) return -1;
80104cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	return -1;
}
80104cf1:	83 c4 04             	add    $0x4,%esp
80104cf4:	5b                   	pop    %ebx
80104cf5:	5d                   	pop    %ebp
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d00:	83 c4 04             	add    $0x4,%esp
80104d03:	89 d0                	mov    %edx,%eax
80104d05:	29 d8                	sub    %ebx,%eax
80104d07:	5b                   	pop    %ebx
80104d08:	5d                   	pop    %ebp
80104d09:	c3                   	ret    
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (*s == 0) return s - *pp;
80104d10:	31 c0                	xor    %eax,%eax
80104d12:	eb dd                	jmp    80104cf1 <fetchstr+0x41>
80104d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104d25:	e8 b6 eb ff ff       	call   801038e0 <myproc>
80104d2a:	8b 40 18             	mov    0x18(%eax),%eax
80104d2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d30:	8b 40 44             	mov    0x44(%eax),%eax
80104d33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
	struct proc *curproc = myproc();
80104d36:	e8 a5 eb ff ff       	call   801038e0 <myproc>
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104d3b:	8b 00                	mov    (%eax),%eax
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104d3d:	8d 73 04             	lea    0x4(%ebx),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104d40:	39 c6                	cmp    %eax,%esi
80104d42:	73 1c                	jae    80104d60 <argint+0x40>
80104d44:	8d 53 08             	lea    0x8(%ebx),%edx
80104d47:	39 d0                	cmp    %edx,%eax
80104d49:	72 15                	jb     80104d60 <argint+0x40>
	*ip = *(int *)(addr);
80104d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d51:	89 10                	mov    %edx,(%eax)
	return 0;
80104d53:	31 c0                	xor    %eax,%eax
}
80104d55:	5b                   	pop    %ebx
80104d56:	5e                   	pop    %esi
80104d57:	5d                   	pop    %ebp
80104d58:	c3                   	ret    
80104d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (addr >= curproc->sz || addr + 4 > curproc->sz) return -1;
80104d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104d65:	eb ee                	jmp    80104d55 <argint+0x35>
80104d67:	89 f6                	mov    %esi,%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	83 ec 10             	sub    $0x10,%esp
80104d78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int          i;
	struct proc *curproc = myproc();
80104d7b:	e8 60 eb ff ff       	call   801038e0 <myproc>
80104d80:	89 c6                	mov    %eax,%esi

	if (argint(n, &i) < 0) return -1;
80104d82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d85:	83 ec 08             	sub    $0x8,%esp
80104d88:	50                   	push   %eax
80104d89:	ff 75 08             	pushl  0x8(%ebp)
80104d8c:	e8 8f ff ff ff       	call   80104d20 <argint>
	if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) return -1;
80104d91:	83 c4 10             	add    $0x10,%esp
80104d94:	85 c0                	test   %eax,%eax
80104d96:	78 28                	js     80104dc0 <argptr+0x50>
80104d98:	85 db                	test   %ebx,%ebx
80104d9a:	78 24                	js     80104dc0 <argptr+0x50>
80104d9c:	8b 16                	mov    (%esi),%edx
80104d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da1:	39 c2                	cmp    %eax,%edx
80104da3:	76 1b                	jbe    80104dc0 <argptr+0x50>
80104da5:	01 c3                	add    %eax,%ebx
80104da7:	39 da                	cmp    %ebx,%edx
80104da9:	72 15                	jb     80104dc0 <argptr+0x50>
	*pp = (char *)i;
80104dab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dae:	89 02                	mov    %eax,(%edx)
	return 0;
80104db0:	31 c0                	xor    %eax,%eax
}
80104db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104db5:	5b                   	pop    %ebx
80104db6:	5e                   	pop    %esi
80104db7:	5d                   	pop    %ebp
80104db8:	c3                   	ret    
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb eb                	jmp    80104db2 <argptr+0x42>
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	83 ec 20             	sub    $0x20,%esp
	int addr;
	if (argint(n, &addr) < 0) return -1;
80104dd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd9:	50                   	push   %eax
80104dda:	ff 75 08             	pushl  0x8(%ebp)
80104ddd:	e8 3e ff ff ff       	call   80104d20 <argint>
80104de2:	83 c4 10             	add    $0x10,%esp
80104de5:	85 c0                	test   %eax,%eax
80104de7:	78 17                	js     80104e00 <argstr+0x30>
	return fetchstr(addr, pp);
80104de9:	83 ec 08             	sub    $0x8,%esp
80104dec:	ff 75 0c             	pushl  0xc(%ebp)
80104def:	ff 75 f4             	pushl  -0xc(%ebp)
80104df2:	e8 b9 fe ff ff       	call   80104cb0 <fetchstr>
80104df7:	83 c4 10             	add    $0x10,%esp
}
80104dfa:	c9                   	leave  
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	if (argint(n, &addr) < 0) return -1;
80104e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e10 <syscall>:
  [SYS_testpqeq] sys_testpqeq, [SYS_testpqdq] sys_testpqdq,
};

void
syscall(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	53                   	push   %ebx
80104e14:	83 ec 04             	sub    $0x4,%esp
	int          num;
	struct proc *curproc = myproc();
80104e17:	e8 c4 ea ff ff       	call   801038e0 <myproc>
80104e1c:	89 c3                	mov    %eax,%ebx

	num = curproc->tf->eax;
80104e1e:	8b 40 18             	mov    0x18(%eax),%eax
80104e21:	8b 40 1c             	mov    0x1c(%eax),%eax
	if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e27:	83 fa 1d             	cmp    $0x1d,%edx
80104e2a:	77 1c                	ja     80104e48 <syscall+0x38>
80104e2c:	8b 14 85 00 83 10 80 	mov    -0x7fef7d00(,%eax,4),%edx
80104e33:	85 d2                	test   %edx,%edx
80104e35:	74 11                	je     80104e48 <syscall+0x38>
		curproc->tf->eax = syscalls[num]();
80104e37:	ff d2                	call   *%edx
80104e39:	8b 53 18             	mov    0x18(%ebx),%edx
80104e3c:	89 42 1c             	mov    %eax,0x1c(%edx)
	} else {
		cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name, num);
		curproc->tf->eax = -1;
	}
}
80104e3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e42:	c9                   	leave  
80104e43:	c3                   	ret    
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("%d %s: unknown sys call %d\n", curproc->pid, curproc->name, num);
80104e48:	50                   	push   %eax
80104e49:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104e4c:	50                   	push   %eax
80104e4d:	ff 73 10             	pushl  0x10(%ebx)
80104e50:	68 d5 82 10 80       	push   $0x801082d5
80104e55:	e8 06 b8 ff ff       	call   80100660 <cprintf>
		curproc->tf->eax = -1;
80104e5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e6a:	c9                   	leave  
80104e6b:	c3                   	ret    
80104e6c:	66 90                	xchg   %ax,%ax
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <create>:
	return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
	uint          off;
	struct inode *ip, *dp;
	char          name[DIRSIZ];

	if ((dp = nameiparent(path, name)) == 0) return 0;
80104e76:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104e79:	83 ec 44             	sub    $0x44,%esp
80104e7c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104e7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if ((dp = nameiparent(path, name)) == 0) return 0;
80104e82:	56                   	push   %esi
80104e83:	50                   	push   %eax
{
80104e84:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104e87:	89 4d bc             	mov    %ecx,-0x44(%ebp)
	if ((dp = nameiparent(path, name)) == 0) return 0;
80104e8a:	e8 81 d0 ff ff       	call   80101f10 <nameiparent>
80104e8f:	83 c4 10             	add    $0x10,%esp
80104e92:	85 c0                	test   %eax,%eax
80104e94:	0f 84 46 01 00 00    	je     80104fe0 <create+0x170>
	ilock(dp);
80104e9a:	83 ec 0c             	sub    $0xc,%esp
80104e9d:	89 c3                	mov    %eax,%ebx
80104e9f:	50                   	push   %eax
80104ea0:	e8 eb c7 ff ff       	call   80101690 <ilock>

	if ((ip = dirlookup(dp, name, &off)) != 0) {
80104ea5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104ea8:	83 c4 0c             	add    $0xc,%esp
80104eab:	50                   	push   %eax
80104eac:	56                   	push   %esi
80104ead:	53                   	push   %ebx
80104eae:	e8 0d cd ff ff       	call   80101bc0 <dirlookup>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	89 c7                	mov    %eax,%edi
80104eba:	74 34                	je     80104ef0 <create+0x80>
		iunlockput(dp);
80104ebc:	83 ec 0c             	sub    $0xc,%esp
80104ebf:	53                   	push   %ebx
80104ec0:	e8 5b ca ff ff       	call   80101920 <iunlockput>
		ilock(ip);
80104ec5:	89 3c 24             	mov    %edi,(%esp)
80104ec8:	e8 c3 c7 ff ff       	call   80101690 <ilock>
		if (type == T_FILE && ip->type == T_FILE) return ip;
80104ecd:	83 c4 10             	add    $0x10,%esp
80104ed0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ed5:	0f 85 95 00 00 00    	jne    80104f70 <create+0x100>
80104edb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104ee0:	0f 85 8a 00 00 00    	jne    80104f70 <create+0x100>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");

	iunlockput(dp);

	return ip;
}
80104ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee9:	89 f8                	mov    %edi,%eax
80104eeb:	5b                   	pop    %ebx
80104eec:	5e                   	pop    %esi
80104eed:	5f                   	pop    %edi
80104eee:	5d                   	pop    %ebp
80104eef:	c3                   	ret    
	if ((ip = ialloc(dp->dev, type)) == 0) panic("create: ialloc");
80104ef0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ef4:	83 ec 08             	sub    $0x8,%esp
80104ef7:	50                   	push   %eax
80104ef8:	ff 33                	pushl  (%ebx)
80104efa:	e8 21 c6 ff ff       	call   80101520 <ialloc>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	85 c0                	test   %eax,%eax
80104f04:	89 c7                	mov    %eax,%edi
80104f06:	0f 84 e8 00 00 00    	je     80104ff4 <create+0x184>
	ilock(ip);
80104f0c:	83 ec 0c             	sub    $0xc,%esp
80104f0f:	50                   	push   %eax
80104f10:	e8 7b c7 ff ff       	call   80101690 <ilock>
	ip->major = major;
80104f15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f19:	66 89 47 52          	mov    %ax,0x52(%edi)
	ip->minor = minor;
80104f1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104f21:	66 89 47 54          	mov    %ax,0x54(%edi)
	ip->nlink = 1;
80104f25:	b8 01 00 00 00       	mov    $0x1,%eax
80104f2a:	66 89 47 56          	mov    %ax,0x56(%edi)
	iupdate(ip);
80104f2e:	89 3c 24             	mov    %edi,(%esp)
80104f31:	e8 aa c6 ff ff       	call   801015e0 <iupdate>
	if (type == T_DIR) { // Create . and .. entries.
80104f36:	83 c4 10             	add    $0x10,%esp
80104f39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f3e:	74 50                	je     80104f90 <create+0x120>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");
80104f40:	83 ec 04             	sub    $0x4,%esp
80104f43:	ff 77 04             	pushl  0x4(%edi)
80104f46:	56                   	push   %esi
80104f47:	53                   	push   %ebx
80104f48:	e8 e3 ce ff ff       	call   80101e30 <dirlink>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	0f 88 8f 00 00 00    	js     80104fe7 <create+0x177>
	iunlockput(dp);
80104f58:	83 ec 0c             	sub    $0xc,%esp
80104f5b:	53                   	push   %ebx
80104f5c:	e8 bf c9 ff ff       	call   80101920 <iunlockput>
	return ip;
80104f61:	83 c4 10             	add    $0x10,%esp
}
80104f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f67:	89 f8                	mov    %edi,%eax
80104f69:	5b                   	pop    %ebx
80104f6a:	5e                   	pop    %esi
80104f6b:	5f                   	pop    %edi
80104f6c:	5d                   	pop    %ebp
80104f6d:	c3                   	ret    
80104f6e:	66 90                	xchg   %ax,%ax
		iunlockput(ip);
80104f70:	83 ec 0c             	sub    $0xc,%esp
80104f73:	57                   	push   %edi
		return 0;
80104f74:	31 ff                	xor    %edi,%edi
		iunlockput(ip);
80104f76:	e8 a5 c9 ff ff       	call   80101920 <iunlockput>
		return 0;
80104f7b:	83 c4 10             	add    $0x10,%esp
}
80104f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f81:	89 f8                	mov    %edi,%eax
80104f83:	5b                   	pop    %ebx
80104f84:	5e                   	pop    %esi
80104f85:	5f                   	pop    %edi
80104f86:	5d                   	pop    %ebp
80104f87:	c3                   	ret    
80104f88:	90                   	nop
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		dp->nlink++; // for ".."
80104f90:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
		iupdate(dp);
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	53                   	push   %ebx
80104f99:	e8 42 c6 ff ff       	call   801015e0 <iupdate>
		if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0) panic("create dots");
80104f9e:	83 c4 0c             	add    $0xc,%esp
80104fa1:	ff 77 04             	pushl  0x4(%edi)
80104fa4:	68 98 83 10 80       	push   $0x80108398
80104fa9:	57                   	push   %edi
80104faa:	e8 81 ce ff ff       	call   80101e30 <dirlink>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	78 1c                	js     80104fd2 <create+0x162>
80104fb6:	83 ec 04             	sub    $0x4,%esp
80104fb9:	ff 73 04             	pushl  0x4(%ebx)
80104fbc:	68 97 83 10 80       	push   $0x80108397
80104fc1:	57                   	push   %edi
80104fc2:	e8 69 ce ff ff       	call   80101e30 <dirlink>
80104fc7:	83 c4 10             	add    $0x10,%esp
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	0f 89 6e ff ff ff    	jns    80104f40 <create+0xd0>
80104fd2:	83 ec 0c             	sub    $0xc,%esp
80104fd5:	68 8b 83 10 80       	push   $0x8010838b
80104fda:	e8 b1 b3 ff ff       	call   80100390 <panic>
80104fdf:	90                   	nop
	if ((dp = nameiparent(path, name)) == 0) return 0;
80104fe0:	31 ff                	xor    %edi,%edi
80104fe2:	e9 ff fe ff ff       	jmp    80104ee6 <create+0x76>
	if (dirlink(dp, name, ip->inum) < 0) panic("create: dirlink");
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	68 9a 83 10 80       	push   $0x8010839a
80104fef:	e8 9c b3 ff ff       	call   80100390 <panic>
	if ((ip = ialloc(dp->dev, type)) == 0) panic("create: ialloc");
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	68 7c 83 10 80       	push   $0x8010837c
80104ffc:	e8 8f b3 ff ff       	call   80100390 <panic>
80105001:	eb 0d                	jmp    80105010 <argfd.constprop.0>
80105003:	90                   	nop
80105004:	90                   	nop
80105005:	90                   	nop
80105006:	90                   	nop
80105007:	90                   	nop
80105008:	90                   	nop
80105009:	90                   	nop
8010500a:	90                   	nop
8010500b:	90                   	nop
8010500c:	90                   	nop
8010500d:	90                   	nop
8010500e:	90                   	nop
8010500f:	90                   	nop

80105010 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	89 c3                	mov    %eax,%ebx
	if (argint(n, &fd) < 0) return -1;
80105017:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010501a:	89 d6                	mov    %edx,%esi
8010501c:	83 ec 18             	sub    $0x18,%esp
	if (argint(n, &fd) < 0) return -1;
8010501f:	50                   	push   %eax
80105020:	6a 00                	push   $0x0
80105022:	e8 f9 fc ff ff       	call   80104d20 <argint>
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	85 c0                	test   %eax,%eax
8010502c:	78 2a                	js     80105058 <argfd.constprop.0+0x48>
	if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) return -1;
8010502e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105032:	77 24                	ja     80105058 <argfd.constprop.0+0x48>
80105034:	e8 a7 e8 ff ff       	call   801038e0 <myproc>
80105039:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010503c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105040:	85 c0                	test   %eax,%eax
80105042:	74 14                	je     80105058 <argfd.constprop.0+0x48>
	if (pfd) *pfd = fd;
80105044:	85 db                	test   %ebx,%ebx
80105046:	74 02                	je     8010504a <argfd.constprop.0+0x3a>
80105048:	89 13                	mov    %edx,(%ebx)
	if (pf) *pf = f;
8010504a:	89 06                	mov    %eax,(%esi)
	return 0;
8010504c:	31 c0                	xor    %eax,%eax
}
8010504e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105051:	5b                   	pop    %ebx
80105052:	5e                   	pop    %esi
80105053:	5d                   	pop    %ebp
80105054:	c3                   	ret    
80105055:	8d 76 00             	lea    0x0(%esi),%esi
	if (argint(n, &fd) < 0) return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ef                	jmp    8010504e <argfd.constprop.0+0x3e>
8010505f:	90                   	nop

80105060 <sys_dup>:
{
80105060:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0) return -1;
80105061:	31 c0                	xor    %eax,%eax
{
80105063:	89 e5                	mov    %esp,%ebp
80105065:	56                   	push   %esi
80105066:	53                   	push   %ebx
	if (argfd(0, 0, &f) < 0) return -1;
80105067:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010506a:	83 ec 10             	sub    $0x10,%esp
	if (argfd(0, 0, &f) < 0) return -1;
8010506d:	e8 9e ff ff ff       	call   80105010 <argfd.constprop.0>
80105072:	85 c0                	test   %eax,%eax
80105074:	78 42                	js     801050b8 <sys_dup+0x58>
	if ((fd = fdalloc(f)) < 0) return -1;
80105076:	8b 75 f4             	mov    -0xc(%ebp),%esi
	for (fd = 0; fd < NOFILE; fd++) {
80105079:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
8010507b:	e8 60 e8 ff ff       	call   801038e0 <myproc>
80105080:	eb 0e                	jmp    80105090 <sys_dup+0x30>
80105082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	for (fd = 0; fd < NOFILE; fd++) {
80105088:	83 c3 01             	add    $0x1,%ebx
8010508b:	83 fb 10             	cmp    $0x10,%ebx
8010508e:	74 28                	je     801050b8 <sys_dup+0x58>
		if (curproc->ofile[fd] == 0) {
80105090:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105094:	85 d2                	test   %edx,%edx
80105096:	75 f0                	jne    80105088 <sys_dup+0x28>
			curproc->ofile[fd] = f;
80105098:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
	filedup(f);
8010509c:	83 ec 0c             	sub    $0xc,%esp
8010509f:	ff 75 f4             	pushl  -0xc(%ebp)
801050a2:	e8 49 bd ff ff       	call   80100df0 <filedup>
	return fd;
801050a7:	83 c4 10             	add    $0x10,%esp
}
801050aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ad:	89 d8                	mov    %ebx,%eax
801050af:	5b                   	pop    %ebx
801050b0:	5e                   	pop    %esi
801050b1:	5d                   	pop    %ebp
801050b2:	c3                   	ret    
801050b3:	90                   	nop
801050b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
	if (argfd(0, 0, &f) < 0) return -1;
801050bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801050c0:	89 d8                	mov    %ebx,%eax
801050c2:	5b                   	pop    %ebx
801050c3:	5e                   	pop    %esi
801050c4:	5d                   	pop    %ebp
801050c5:	c3                   	ret    
801050c6:	8d 76 00             	lea    0x0(%esi),%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <sys_read>:
{
801050d0:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
801050d1:	31 c0                	xor    %eax,%eax
{
801050d3:	89 e5                	mov    %esp,%ebp
801050d5:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
801050d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050db:	e8 30 ff ff ff       	call   80105010 <argfd.constprop.0>
801050e0:	85 c0                	test   %eax,%eax
801050e2:	78 4c                	js     80105130 <sys_read+0x60>
801050e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050e7:	83 ec 08             	sub    $0x8,%esp
801050ea:	50                   	push   %eax
801050eb:	6a 02                	push   $0x2
801050ed:	e8 2e fc ff ff       	call   80104d20 <argint>
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	85 c0                	test   %eax,%eax
801050f7:	78 37                	js     80105130 <sys_read+0x60>
801050f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050fc:	83 ec 04             	sub    $0x4,%esp
801050ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105102:	50                   	push   %eax
80105103:	6a 01                	push   $0x1
80105105:	e8 66 fc ff ff       	call   80104d70 <argptr>
8010510a:	83 c4 10             	add    $0x10,%esp
8010510d:	85 c0                	test   %eax,%eax
8010510f:	78 1f                	js     80105130 <sys_read+0x60>
	return fileread(f, p, n);
80105111:	83 ec 04             	sub    $0x4,%esp
80105114:	ff 75 f0             	pushl  -0x10(%ebp)
80105117:	ff 75 f4             	pushl  -0xc(%ebp)
8010511a:	ff 75 ec             	pushl  -0x14(%ebp)
8010511d:	e8 3e be ff ff       	call   80100f60 <fileread>
80105122:	83 c4 10             	add    $0x10,%esp
}
80105125:	c9                   	leave  
80105126:	c3                   	ret    
80105127:	89 f6                	mov    %esi,%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105135:	c9                   	leave  
80105136:	c3                   	ret    
80105137:	89 f6                	mov    %esi,%esi
80105139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105140 <sys_write>:
{
80105140:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80105141:	31 c0                	xor    %eax,%eax
{
80105143:	89 e5                	mov    %esp,%ebp
80105145:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
80105148:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010514b:	e8 c0 fe ff ff       	call   80105010 <argfd.constprop.0>
80105150:	85 c0                	test   %eax,%eax
80105152:	78 4c                	js     801051a0 <sys_write+0x60>
80105154:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105157:	83 ec 08             	sub    $0x8,%esp
8010515a:	50                   	push   %eax
8010515b:	6a 02                	push   $0x2
8010515d:	e8 be fb ff ff       	call   80104d20 <argint>
80105162:	83 c4 10             	add    $0x10,%esp
80105165:	85 c0                	test   %eax,%eax
80105167:	78 37                	js     801051a0 <sys_write+0x60>
80105169:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010516c:	83 ec 04             	sub    $0x4,%esp
8010516f:	ff 75 f0             	pushl  -0x10(%ebp)
80105172:	50                   	push   %eax
80105173:	6a 01                	push   $0x1
80105175:	e8 f6 fb ff ff       	call   80104d70 <argptr>
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	85 c0                	test   %eax,%eax
8010517f:	78 1f                	js     801051a0 <sys_write+0x60>
	return filewrite(f, p, n);
80105181:	83 ec 04             	sub    $0x4,%esp
80105184:	ff 75 f0             	pushl  -0x10(%ebp)
80105187:	ff 75 f4             	pushl  -0xc(%ebp)
8010518a:	ff 75 ec             	pushl  -0x14(%ebp)
8010518d:	e8 5e be ff ff       	call   80100ff0 <filewrite>
80105192:	83 c4 10             	add    $0x10,%esp
}
80105195:	c9                   	leave  
80105196:	c3                   	ret    
80105197:	89 f6                	mov    %esi,%esi
80105199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051b0 <sys_close>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, &fd, &f) < 0) return -1;
801051b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801051b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051bc:	e8 4f fe ff ff       	call   80105010 <argfd.constprop.0>
801051c1:	85 c0                	test   %eax,%eax
801051c3:	78 2b                	js     801051f0 <sys_close+0x40>
	myproc()->ofile[fd] = 0;
801051c5:	e8 16 e7 ff ff       	call   801038e0 <myproc>
801051ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
	fileclose(f);
801051cd:	83 ec 0c             	sub    $0xc,%esp
	myproc()->ofile[fd] = 0;
801051d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051d7:	00 
	fileclose(f);
801051d8:	ff 75 f4             	pushl  -0xc(%ebp)
801051db:	e8 60 bc ff ff       	call   80100e40 <fileclose>
	return 0;
801051e0:	83 c4 10             	add    $0x10,%esp
801051e3:	31 c0                	xor    %eax,%eax
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	if (argfd(0, &fd, &f) < 0) return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_fstat>:
{
80105200:	55                   	push   %ebp
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80105201:	31 c0                	xor    %eax,%eax
{
80105203:	89 e5                	mov    %esp,%ebp
80105205:	83 ec 18             	sub    $0x18,%esp
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80105208:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010520b:	e8 00 fe ff ff       	call   80105010 <argfd.constprop.0>
80105210:	85 c0                	test   %eax,%eax
80105212:	78 2c                	js     80105240 <sys_fstat+0x40>
80105214:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105217:	83 ec 04             	sub    $0x4,%esp
8010521a:	6a 14                	push   $0x14
8010521c:	50                   	push   %eax
8010521d:	6a 01                	push   $0x1
8010521f:	e8 4c fb ff ff       	call   80104d70 <argptr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	78 15                	js     80105240 <sys_fstat+0x40>
	return filestat(f, st);
8010522b:	83 ec 08             	sub    $0x8,%esp
8010522e:	ff 75 f4             	pushl  -0xc(%ebp)
80105231:	ff 75 f0             	pushl  -0x10(%ebp)
80105234:	e8 d7 bc ff ff       	call   80100f10 <filestat>
80105239:	83 c4 10             	add    $0x10,%esp
}
8010523c:	c9                   	leave  
8010523d:	c3                   	ret    
8010523e:	66 90                	xchg   %ax,%ax
	if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0) return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_link>:
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
80105255:	53                   	push   %ebx
	if (argstr(0, &old) < 0 || argstr(1, &new) < 0) return -1;
80105256:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105259:	83 ec 34             	sub    $0x34,%esp
	if (argstr(0, &old) < 0 || argstr(1, &new) < 0) return -1;
8010525c:	50                   	push   %eax
8010525d:	6a 00                	push   $0x0
8010525f:	e8 6c fb ff ff       	call   80104dd0 <argstr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	0f 88 fb 00 00 00    	js     8010536a <sys_link+0x11a>
8010526f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105272:	83 ec 08             	sub    $0x8,%esp
80105275:	50                   	push   %eax
80105276:	6a 01                	push   $0x1
80105278:	e8 53 fb ff ff       	call   80104dd0 <argstr>
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	85 c0                	test   %eax,%eax
80105282:	0f 88 e2 00 00 00    	js     8010536a <sys_link+0x11a>
	begin_op();
80105288:	e8 23 d9 ff ff       	call   80102bb0 <begin_op>
	if ((ip = namei(old)) == 0) {
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	ff 75 d4             	pushl  -0x2c(%ebp)
80105293:	e8 58 cc ff ff       	call   80101ef0 <namei>
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	85 c0                	test   %eax,%eax
8010529d:	89 c3                	mov    %eax,%ebx
8010529f:	0f 84 ea 00 00 00    	je     8010538f <sys_link+0x13f>
	ilock(ip);
801052a5:	83 ec 0c             	sub    $0xc,%esp
801052a8:	50                   	push   %eax
801052a9:	e8 e2 c3 ff ff       	call   80101690 <ilock>
	if (ip->type == T_DIR) {
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b6:	0f 84 bb 00 00 00    	je     80105377 <sys_link+0x127>
	ip->nlink++;
801052bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
	iupdate(ip);
801052c1:	83 ec 0c             	sub    $0xc,%esp
	if ((dp = nameiparent(new, name)) == 0) goto bad;
801052c4:	8d 7d da             	lea    -0x26(%ebp),%edi
	iupdate(ip);
801052c7:	53                   	push   %ebx
801052c8:	e8 13 c3 ff ff       	call   801015e0 <iupdate>
	iunlock(ip);
801052cd:	89 1c 24             	mov    %ebx,(%esp)
801052d0:	e8 9b c4 ff ff       	call   80101770 <iunlock>
	if ((dp = nameiparent(new, name)) == 0) goto bad;
801052d5:	58                   	pop    %eax
801052d6:	5a                   	pop    %edx
801052d7:	57                   	push   %edi
801052d8:	ff 75 d0             	pushl  -0x30(%ebp)
801052db:	e8 30 cc ff ff       	call   80101f10 <nameiparent>
801052e0:	83 c4 10             	add    $0x10,%esp
801052e3:	85 c0                	test   %eax,%eax
801052e5:	89 c6                	mov    %eax,%esi
801052e7:	74 5b                	je     80105344 <sys_link+0xf4>
	ilock(dp);
801052e9:	83 ec 0c             	sub    $0xc,%esp
801052ec:	50                   	push   %eax
801052ed:	e8 9e c3 ff ff       	call   80101690 <ilock>
	if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	8b 03                	mov    (%ebx),%eax
801052f7:	39 06                	cmp    %eax,(%esi)
801052f9:	75 3d                	jne    80105338 <sys_link+0xe8>
801052fb:	83 ec 04             	sub    $0x4,%esp
801052fe:	ff 73 04             	pushl  0x4(%ebx)
80105301:	57                   	push   %edi
80105302:	56                   	push   %esi
80105303:	e8 28 cb ff ff       	call   80101e30 <dirlink>
80105308:	83 c4 10             	add    $0x10,%esp
8010530b:	85 c0                	test   %eax,%eax
8010530d:	78 29                	js     80105338 <sys_link+0xe8>
	iunlockput(dp);
8010530f:	83 ec 0c             	sub    $0xc,%esp
80105312:	56                   	push   %esi
80105313:	e8 08 c6 ff ff       	call   80101920 <iunlockput>
	iput(ip);
80105318:	89 1c 24             	mov    %ebx,(%esp)
8010531b:	e8 a0 c4 ff ff       	call   801017c0 <iput>
	end_op();
80105320:	e8 fb d8 ff ff       	call   80102c20 <end_op>
	return 0;
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	31 c0                	xor    %eax,%eax
}
8010532a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010532d:	5b                   	pop    %ebx
8010532e:	5e                   	pop    %esi
8010532f:	5f                   	pop    %edi
80105330:	5d                   	pop    %ebp
80105331:	c3                   	ret    
80105332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		iunlockput(dp);
80105338:	83 ec 0c             	sub    $0xc,%esp
8010533b:	56                   	push   %esi
8010533c:	e8 df c5 ff ff       	call   80101920 <iunlockput>
		goto bad;
80105341:	83 c4 10             	add    $0x10,%esp
	ilock(ip);
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	53                   	push   %ebx
80105348:	e8 43 c3 ff ff       	call   80101690 <ilock>
	ip->nlink--;
8010534d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80105352:	89 1c 24             	mov    %ebx,(%esp)
80105355:	e8 86 c2 ff ff       	call   801015e0 <iupdate>
	iunlockput(ip);
8010535a:	89 1c 24             	mov    %ebx,(%esp)
8010535d:	e8 be c5 ff ff       	call   80101920 <iunlockput>
	end_op();
80105362:	e8 b9 d8 ff ff       	call   80102c20 <end_op>
	return -1;
80105367:	83 c4 10             	add    $0x10,%esp
}
8010536a:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return -1;
8010536d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105372:	5b                   	pop    %ebx
80105373:	5e                   	pop    %esi
80105374:	5f                   	pop    %edi
80105375:	5d                   	pop    %ebp
80105376:	c3                   	ret    
		iunlockput(ip);
80105377:	83 ec 0c             	sub    $0xc,%esp
8010537a:	53                   	push   %ebx
8010537b:	e8 a0 c5 ff ff       	call   80101920 <iunlockput>
		end_op();
80105380:	e8 9b d8 ff ff       	call   80102c20 <end_op>
		return -1;
80105385:	83 c4 10             	add    $0x10,%esp
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538d:	eb 9b                	jmp    8010532a <sys_link+0xda>
		end_op();
8010538f:	e8 8c d8 ff ff       	call   80102c20 <end_op>
		return -1;
80105394:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105399:	eb 8f                	jmp    8010532a <sys_link+0xda>
8010539b:	90                   	nop
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_unlink>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
	if (argstr(0, &path) < 0) return -1;
801053a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053a9:	83 ec 44             	sub    $0x44,%esp
	if (argstr(0, &path) < 0) return -1;
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 1c fa ff ff       	call   80104dd0 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 77 01 00 00    	js     80105536 <sys_unlink+0x196>
	if ((dp = nameiparent(path, name)) == 0) {
801053bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
	begin_op();
801053c2:	e8 e9 d7 ff ff       	call   80102bb0 <begin_op>
	if ((dp = nameiparent(path, name)) == 0) {
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	53                   	push   %ebx
801053cb:	ff 75 c0             	pushl  -0x40(%ebp)
801053ce:	e8 3d cb ff ff       	call   80101f10 <nameiparent>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	85 c0                	test   %eax,%eax
801053d8:	89 c6                	mov    %eax,%esi
801053da:	0f 84 60 01 00 00    	je     80105540 <sys_unlink+0x1a0>
	ilock(dp);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	50                   	push   %eax
801053e4:	e8 a7 c2 ff ff       	call   80101690 <ilock>
	if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) goto bad;
801053e9:	58                   	pop    %eax
801053ea:	5a                   	pop    %edx
801053eb:	68 98 83 10 80       	push   $0x80108398
801053f0:	53                   	push   %ebx
801053f1:	e8 aa c7 ff ff       	call   80101ba0 <namecmp>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 c0                	test   %eax,%eax
801053fb:	0f 84 03 01 00 00    	je     80105504 <sys_unlink+0x164>
80105401:	83 ec 08             	sub    $0x8,%esp
80105404:	68 97 83 10 80       	push   $0x80108397
80105409:	53                   	push   %ebx
8010540a:	e8 91 c7 ff ff       	call   80101ba0 <namecmp>
8010540f:	83 c4 10             	add    $0x10,%esp
80105412:	85 c0                	test   %eax,%eax
80105414:	0f 84 ea 00 00 00    	je     80105504 <sys_unlink+0x164>
	if ((ip = dirlookup(dp, name, &off)) == 0) goto bad;
8010541a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010541d:	83 ec 04             	sub    $0x4,%esp
80105420:	50                   	push   %eax
80105421:	53                   	push   %ebx
80105422:	56                   	push   %esi
80105423:	e8 98 c7 ff ff       	call   80101bc0 <dirlookup>
80105428:	83 c4 10             	add    $0x10,%esp
8010542b:	85 c0                	test   %eax,%eax
8010542d:	89 c3                	mov    %eax,%ebx
8010542f:	0f 84 cf 00 00 00    	je     80105504 <sys_unlink+0x164>
	ilock(ip);
80105435:	83 ec 0c             	sub    $0xc,%esp
80105438:	50                   	push   %eax
80105439:	e8 52 c2 ff ff       	call   80101690 <ilock>
	if (ip->nlink < 1) panic("unlink: nlink < 1");
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105446:	0f 8e 10 01 00 00    	jle    8010555c <sys_unlink+0x1bc>
	if (ip->type == T_DIR && !isdirempty(ip)) {
8010544c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105451:	74 6d                	je     801054c0 <sys_unlink+0x120>
	memset(&de, 0, sizeof(de));
80105453:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105456:	83 ec 04             	sub    $0x4,%esp
80105459:	6a 10                	push   $0x10
8010545b:	6a 00                	push   $0x0
8010545d:	50                   	push   %eax
8010545e:	e8 bd f5 ff ff       	call   80104a20 <memset>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("unlink: writei");
80105463:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105466:	6a 10                	push   $0x10
80105468:	ff 75 c4             	pushl  -0x3c(%ebp)
8010546b:	50                   	push   %eax
8010546c:	56                   	push   %esi
8010546d:	e8 fe c5 ff ff       	call   80101a70 <writei>
80105472:	83 c4 20             	add    $0x20,%esp
80105475:	83 f8 10             	cmp    $0x10,%eax
80105478:	0f 85 eb 00 00 00    	jne    80105569 <sys_unlink+0x1c9>
	if (ip->type == T_DIR) {
8010547e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105483:	0f 84 97 00 00 00    	je     80105520 <sys_unlink+0x180>
	iunlockput(dp);
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	56                   	push   %esi
8010548d:	e8 8e c4 ff ff       	call   80101920 <iunlockput>
	ip->nlink--;
80105492:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
	iupdate(ip);
80105497:	89 1c 24             	mov    %ebx,(%esp)
8010549a:	e8 41 c1 ff ff       	call   801015e0 <iupdate>
	iunlockput(ip);
8010549f:	89 1c 24             	mov    %ebx,(%esp)
801054a2:	e8 79 c4 ff ff       	call   80101920 <iunlockput>
	end_op();
801054a7:	e8 74 d7 ff ff       	call   80102c20 <end_op>
	return 0;
801054ac:	83 c4 10             	add    $0x10,%esp
801054af:	31 c0                	xor    %eax,%eax
}
801054b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b4:	5b                   	pop    %ebx
801054b5:	5e                   	pop    %esi
801054b6:	5f                   	pop    %edi
801054b7:	5d                   	pop    %ebp
801054b8:	c3                   	ret    
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
801054c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054c4:	76 8d                	jbe    80105453 <sys_unlink+0xb3>
801054c6:	bf 20 00 00 00       	mov    $0x20,%edi
801054cb:	eb 0f                	jmp    801054dc <sys_unlink+0x13c>
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
801054d0:	83 c7 10             	add    $0x10,%edi
801054d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801054d6:	0f 83 77 ff ff ff    	jae    80105453 <sys_unlink+0xb3>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("isdirempty: readi");
801054dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054df:	6a 10                	push   $0x10
801054e1:	57                   	push   %edi
801054e2:	50                   	push   %eax
801054e3:	53                   	push   %ebx
801054e4:	e8 87 c4 ff ff       	call   80101970 <readi>
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	83 f8 10             	cmp    $0x10,%eax
801054ef:	75 5e                	jne    8010554f <sys_unlink+0x1af>
		if (de.inum != 0) return 0;
801054f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054f6:	74 d8                	je     801054d0 <sys_unlink+0x130>
		iunlockput(ip);
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	53                   	push   %ebx
801054fc:	e8 1f c4 ff ff       	call   80101920 <iunlockput>
		goto bad;
80105501:	83 c4 10             	add    $0x10,%esp
	iunlockput(dp);
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	56                   	push   %esi
80105508:	e8 13 c4 ff ff       	call   80101920 <iunlockput>
	end_op();
8010550d:	e8 0e d7 ff ff       	call   80102c20 <end_op>
	return -1;
80105512:	83 c4 10             	add    $0x10,%esp
80105515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551a:	eb 95                	jmp    801054b1 <sys_unlink+0x111>
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		dp->nlink--;
80105520:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
		iupdate(dp);
80105525:	83 ec 0c             	sub    $0xc,%esp
80105528:	56                   	push   %esi
80105529:	e8 b2 c0 ff ff       	call   801015e0 <iupdate>
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	e9 53 ff ff ff       	jmp    80105489 <sys_unlink+0xe9>
	if (argstr(0, &path) < 0) return -1;
80105536:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553b:	e9 71 ff ff ff       	jmp    801054b1 <sys_unlink+0x111>
		end_op();
80105540:	e8 db d6 ff ff       	call   80102c20 <end_op>
		return -1;
80105545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554a:	e9 62 ff ff ff       	jmp    801054b1 <sys_unlink+0x111>
		if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("isdirempty: readi");
8010554f:	83 ec 0c             	sub    $0xc,%esp
80105552:	68 bc 83 10 80       	push   $0x801083bc
80105557:	e8 34 ae ff ff       	call   80100390 <panic>
	if (ip->nlink < 1) panic("unlink: nlink < 1");
8010555c:	83 ec 0c             	sub    $0xc,%esp
8010555f:	68 aa 83 10 80       	push   $0x801083aa
80105564:	e8 27 ae ff ff       	call   80100390 <panic>
	if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de)) panic("unlink: writei");
80105569:	83 ec 0c             	sub    $0xc,%esp
8010556c:	68 ce 83 10 80       	push   $0x801083ce
80105571:	e8 1a ae ff ff       	call   80100390 <panic>
80105576:	8d 76 00             	lea    0x0(%esi),%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_open>:

int
sys_open(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
	char *        path;
	int           fd, omode;
	struct file * f;
	struct inode *ip;

	if (argstr(0, &path) < 0 || argint(1, &omode) < 0) return -1;
80105586:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105589:	83 ec 24             	sub    $0x24,%esp
	if (argstr(0, &path) < 0 || argint(1, &omode) < 0) return -1;
8010558c:	50                   	push   %eax
8010558d:	6a 00                	push   $0x0
8010558f:	e8 3c f8 ff ff       	call   80104dd0 <argstr>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	0f 88 1d 01 00 00    	js     801056bc <sys_open+0x13c>
8010559f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055a2:	83 ec 08             	sub    $0x8,%esp
801055a5:	50                   	push   %eax
801055a6:	6a 01                	push   $0x1
801055a8:	e8 73 f7 ff ff       	call   80104d20 <argint>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	0f 88 04 01 00 00    	js     801056bc <sys_open+0x13c>

	begin_op();
801055b8:	e8 f3 d5 ff ff       	call   80102bb0 <begin_op>

	if (omode & O_CREATE) {
801055bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055c1:	0f 85 a9 00 00 00    	jne    80105670 <sys_open+0xf0>
		if (ip == 0) {
			end_op();
			return -1;
		}
	} else {
		if ((ip = namei(path)) == 0) {
801055c7:	83 ec 0c             	sub    $0xc,%esp
801055ca:	ff 75 e0             	pushl  -0x20(%ebp)
801055cd:	e8 1e c9 ff ff       	call   80101ef0 <namei>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	89 c6                	mov    %eax,%esi
801055d9:	0f 84 b2 00 00 00    	je     80105691 <sys_open+0x111>
			end_op();
			return -1;
		}
		ilock(ip);
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	50                   	push   %eax
801055e3:	e8 a8 c0 ff ff       	call   80101690 <ilock>
		if (ip->type == T_DIR && omode != O_RDONLY) {
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055f0:	0f 84 aa 00 00 00    	je     801056a0 <sys_open+0x120>
			end_op();
			return -1;
		}
	}

	if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
801055f6:	e8 85 b7 ff ff       	call   80100d80 <filealloc>
801055fb:	85 c0                	test   %eax,%eax
801055fd:	89 c7                	mov    %eax,%edi
801055ff:	0f 84 a6 00 00 00    	je     801056ab <sys_open+0x12b>
	struct proc *curproc = myproc();
80105605:	e8 d6 e2 ff ff       	call   801038e0 <myproc>
	for (fd = 0; fd < NOFILE; fd++) {
8010560a:	31 db                	xor    %ebx,%ebx
8010560c:	eb 0e                	jmp    8010561c <sys_open+0x9c>
8010560e:	66 90                	xchg   %ax,%ax
80105610:	83 c3 01             	add    $0x1,%ebx
80105613:	83 fb 10             	cmp    $0x10,%ebx
80105616:	0f 84 ac 00 00 00    	je     801056c8 <sys_open+0x148>
		if (curproc->ofile[fd] == 0) {
8010561c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105620:	85 d2                	test   %edx,%edx
80105622:	75 ec                	jne    80105610 <sys_open+0x90>
		if (f) fileclose(f);
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
80105624:	83 ec 0c             	sub    $0xc,%esp
			curproc->ofile[fd] = f;
80105627:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
	iunlock(ip);
8010562b:	56                   	push   %esi
8010562c:	e8 3f c1 ff ff       	call   80101770 <iunlock>
	end_op();
80105631:	e8 ea d5 ff ff       	call   80102c20 <end_op>

	f->type     = FD_INODE;
80105636:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
	f->ip       = ip;
	f->off      = 0;
	f->readable = !(omode & O_WRONLY);
8010563c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010563f:	83 c4 10             	add    $0x10,%esp
	f->ip       = ip;
80105642:	89 77 10             	mov    %esi,0x10(%edi)
	f->off      = 0;
80105645:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
	f->readable = !(omode & O_WRONLY);
8010564c:	89 d0                	mov    %edx,%eax
8010564e:	f7 d0                	not    %eax
80105650:	83 e0 01             	and    $0x1,%eax
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105653:	83 e2 03             	and    $0x3,%edx
	f->readable = !(omode & O_WRONLY);
80105656:	88 47 08             	mov    %al,0x8(%edi)
	f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105659:	0f 95 47 09          	setne  0x9(%edi)
	return fd;
}
8010565d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105660:	89 d8                	mov    %ebx,%eax
80105662:	5b                   	pop    %ebx
80105663:	5e                   	pop    %esi
80105664:	5f                   	pop    %edi
80105665:	5d                   	pop    %ebp
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		ip = create(path, T_FILE, 0, 0);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105676:	31 c9                	xor    %ecx,%ecx
80105678:	6a 00                	push   $0x0
8010567a:	ba 02 00 00 00       	mov    $0x2,%edx
8010567f:	e8 ec f7 ff ff       	call   80104e70 <create>
		if (ip == 0) {
80105684:	83 c4 10             	add    $0x10,%esp
80105687:	85 c0                	test   %eax,%eax
		ip = create(path, T_FILE, 0, 0);
80105689:	89 c6                	mov    %eax,%esi
		if (ip == 0) {
8010568b:	0f 85 65 ff ff ff    	jne    801055f6 <sys_open+0x76>
			end_op();
80105691:	e8 8a d5 ff ff       	call   80102c20 <end_op>
			return -1;
80105696:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010569b:	eb c0                	jmp    8010565d <sys_open+0xdd>
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
		if (ip->type == T_DIR && omode != O_RDONLY) {
801056a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056a3:	85 c9                	test   %ecx,%ecx
801056a5:	0f 84 4b ff ff ff    	je     801055f6 <sys_open+0x76>
		iunlockput(ip);
801056ab:	83 ec 0c             	sub    $0xc,%esp
801056ae:	56                   	push   %esi
801056af:	e8 6c c2 ff ff       	call   80101920 <iunlockput>
		end_op();
801056b4:	e8 67 d5 ff ff       	call   80102c20 <end_op>
		return -1;
801056b9:	83 c4 10             	add    $0x10,%esp
801056bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056c1:	eb 9a                	jmp    8010565d <sys_open+0xdd>
801056c3:	90                   	nop
801056c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (f) fileclose(f);
801056c8:	83 ec 0c             	sub    $0xc,%esp
801056cb:	57                   	push   %edi
801056cc:	e8 6f b7 ff ff       	call   80100e40 <fileclose>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	eb d5                	jmp    801056ab <sys_open+0x12b>
801056d6:	8d 76 00             	lea    0x0(%esi),%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 18             	sub    $0x18,%esp
	char *        path;
	struct inode *ip;

	begin_op();
801056e6:	e8 c5 d4 ff ff       	call   80102bb0 <begin_op>
	if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
801056eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ee:	83 ec 08             	sub    $0x8,%esp
801056f1:	50                   	push   %eax
801056f2:	6a 00                	push   $0x0
801056f4:	e8 d7 f6 ff ff       	call   80104dd0 <argstr>
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	85 c0                	test   %eax,%eax
801056fe:	78 30                	js     80105730 <sys_mkdir+0x50>
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105706:	31 c9                	xor    %ecx,%ecx
80105708:	6a 00                	push   $0x0
8010570a:	ba 01 00 00 00       	mov    $0x1,%edx
8010570f:	e8 5c f7 ff ff       	call   80104e70 <create>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	74 15                	je     80105730 <sys_mkdir+0x50>
		end_op();
		return -1;
	}
	iunlockput(ip);
8010571b:	83 ec 0c             	sub    $0xc,%esp
8010571e:	50                   	push   %eax
8010571f:	e8 fc c1 ff ff       	call   80101920 <iunlockput>
	end_op();
80105724:	e8 f7 d4 ff ff       	call   80102c20 <end_op>
	return 0;
80105729:	83 c4 10             	add    $0x10,%esp
8010572c:	31 c0                	xor    %eax,%eax
}
8010572e:	c9                   	leave  
8010572f:	c3                   	ret    
		end_op();
80105730:	e8 eb d4 ff ff       	call   80102c20 <end_op>
		return -1;
80105735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_mknod>:

int
sys_mknod(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 18             	sub    $0x18,%esp
	struct inode *ip;
	char *        path;
	int           major, minor;

	begin_op();
80105746:	e8 65 d4 ff ff       	call   80102bb0 <begin_op>
	if ((argstr(0, &path)) < 0 || argint(1, &major) < 0 || argint(2, &minor) < 0
8010574b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010574e:	83 ec 08             	sub    $0x8,%esp
80105751:	50                   	push   %eax
80105752:	6a 00                	push   $0x0
80105754:	e8 77 f6 ff ff       	call   80104dd0 <argstr>
80105759:	83 c4 10             	add    $0x10,%esp
8010575c:	85 c0                	test   %eax,%eax
8010575e:	78 60                	js     801057c0 <sys_mknod+0x80>
80105760:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105763:	83 ec 08             	sub    $0x8,%esp
80105766:	50                   	push   %eax
80105767:	6a 01                	push   $0x1
80105769:	e8 b2 f5 ff ff       	call   80104d20 <argint>
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	85 c0                	test   %eax,%eax
80105773:	78 4b                	js     801057c0 <sys_mknod+0x80>
80105775:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105778:	83 ec 08             	sub    $0x8,%esp
8010577b:	50                   	push   %eax
8010577c:	6a 02                	push   $0x2
8010577e:	e8 9d f5 ff ff       	call   80104d20 <argint>
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	78 36                	js     801057c0 <sys_mknod+0x80>
	    || (ip = create(path, T_DEV, major, minor)) == 0) {
8010578a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010578e:	83 ec 0c             	sub    $0xc,%esp
80105791:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105795:	ba 03 00 00 00       	mov    $0x3,%edx
8010579a:	50                   	push   %eax
8010579b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010579e:	e8 cd f6 ff ff       	call   80104e70 <create>
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	85 c0                	test   %eax,%eax
801057a8:	74 16                	je     801057c0 <sys_mknod+0x80>
		end_op();
		return -1;
	}
	iunlockput(ip);
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	50                   	push   %eax
801057ae:	e8 6d c1 ff ff       	call   80101920 <iunlockput>
	end_op();
801057b3:	e8 68 d4 ff ff       	call   80102c20 <end_op>
	return 0;
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	31 c0                	xor    %eax,%eax
}
801057bd:	c9                   	leave  
801057be:	c3                   	ret    
801057bf:	90                   	nop
		end_op();
801057c0:	e8 5b d4 ff ff       	call   80102c20 <end_op>
		return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ca:	c9                   	leave  
801057cb:	c3                   	ret    
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057d0 <sys_chdir>:

int
sys_chdir(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
801057d5:	83 ec 10             	sub    $0x10,%esp
	char *        path;
	struct inode *ip;
	struct proc * curproc = myproc();
801057d8:	e8 03 e1 ff ff       	call   801038e0 <myproc>
801057dd:	89 c6                	mov    %eax,%esi

	begin_op();
801057df:	e8 cc d3 ff ff       	call   80102bb0 <begin_op>
	if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e7:	83 ec 08             	sub    $0x8,%esp
801057ea:	50                   	push   %eax
801057eb:	6a 00                	push   $0x0
801057ed:	e8 de f5 ff ff       	call   80104dd0 <argstr>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	78 77                	js     80105870 <sys_chdir+0xa0>
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	ff 75 f4             	pushl  -0xc(%ebp)
801057ff:	e8 ec c6 ff ff       	call   80101ef0 <namei>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	85 c0                	test   %eax,%eax
80105809:	89 c3                	mov    %eax,%ebx
8010580b:	74 63                	je     80105870 <sys_chdir+0xa0>
		end_op();
		return -1;
	}
	ilock(ip);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	50                   	push   %eax
80105811:	e8 7a be ff ff       	call   80101690 <ilock>
	if (ip->type != T_DIR) {
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010581e:	75 30                	jne    80105850 <sys_chdir+0x80>
		iunlockput(ip);
		end_op();
		return -1;
	}
	iunlock(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	53                   	push   %ebx
80105824:	e8 47 bf ff ff       	call   80101770 <iunlock>
	iput(curproc->cwd);
80105829:	58                   	pop    %eax
8010582a:	ff 76 68             	pushl  0x68(%esi)
8010582d:	e8 8e bf ff ff       	call   801017c0 <iput>
	end_op();
80105832:	e8 e9 d3 ff ff       	call   80102c20 <end_op>
	curproc->cwd = ip;
80105837:	89 5e 68             	mov    %ebx,0x68(%esi)
	return 0;
8010583a:	83 c4 10             	add    $0x10,%esp
8010583d:	31 c0                	xor    %eax,%eax
}
8010583f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105842:	5b                   	pop    %ebx
80105843:	5e                   	pop    %esi
80105844:	5d                   	pop    %ebp
80105845:	c3                   	ret    
80105846:	8d 76 00             	lea    0x0(%esi),%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		iunlockput(ip);
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	53                   	push   %ebx
80105854:	e8 c7 c0 ff ff       	call   80101920 <iunlockput>
		end_op();
80105859:	e8 c2 d3 ff ff       	call   80102c20 <end_op>
		return -1;
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105866:	eb d7                	jmp    8010583f <sys_chdir+0x6f>
80105868:	90                   	nop
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		end_op();
80105870:	e8 ab d3 ff ff       	call   80102c20 <end_op>
		return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587a:	eb c3                	jmp    8010583f <sys_chdir+0x6f>
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_exec>:

int
sys_exec(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
80105885:	53                   	push   %ebx
	char *path, *argv[MAXARG];
	int   i;
	uint  uargv, uarg;

	if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0) {
80105886:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010588c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
	if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0) {
80105892:	50                   	push   %eax
80105893:	6a 00                	push   $0x0
80105895:	e8 36 f5 ff ff       	call   80104dd0 <argstr>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	85 c0                	test   %eax,%eax
8010589f:	0f 88 87 00 00 00    	js     8010592c <sys_exec+0xac>
801058a5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058ab:	83 ec 08             	sub    $0x8,%esp
801058ae:	50                   	push   %eax
801058af:	6a 01                	push   $0x1
801058b1:	e8 6a f4 ff ff       	call   80104d20 <argint>
801058b6:	83 c4 10             	add    $0x10,%esp
801058b9:	85 c0                	test   %eax,%eax
801058bb:	78 6f                	js     8010592c <sys_exec+0xac>
		return -1;
	}
	memset(argv, 0, sizeof(argv));
801058bd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058c3:	83 ec 04             	sub    $0x4,%esp
	for (i = 0;; i++) {
801058c6:	31 db                	xor    %ebx,%ebx
	memset(argv, 0, sizeof(argv));
801058c8:	68 80 00 00 00       	push   $0x80
801058cd:	6a 00                	push   $0x0
801058cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801058d5:	50                   	push   %eax
801058d6:	e8 45 f1 ff ff       	call   80104a20 <memset>
801058db:	83 c4 10             	add    $0x10,%esp
801058de:	eb 2c                	jmp    8010590c <sys_exec+0x8c>
		if (i >= NELEM(argv)) return -1;
		if (fetchint(uargv + 4 * i, (int *)&uarg) < 0) return -1;
		if (uarg == 0) {
801058e0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058e6:	85 c0                	test   %eax,%eax
801058e8:	74 56                	je     80105940 <sys_exec+0xc0>
			argv[i] = 0;
			break;
		}
		if (fetchstr(uarg, &argv[i]) < 0) return -1;
801058ea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801058f0:	83 ec 08             	sub    $0x8,%esp
801058f3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801058f6:	52                   	push   %edx
801058f7:	50                   	push   %eax
801058f8:	e8 b3 f3 ff ff       	call   80104cb0 <fetchstr>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	78 28                	js     8010592c <sys_exec+0xac>
	for (i = 0;; i++) {
80105904:	83 c3 01             	add    $0x1,%ebx
		if (i >= NELEM(argv)) return -1;
80105907:	83 fb 20             	cmp    $0x20,%ebx
8010590a:	74 20                	je     8010592c <sys_exec+0xac>
		if (fetchint(uargv + 4 * i, (int *)&uarg) < 0) return -1;
8010590c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105912:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105919:	83 ec 08             	sub    $0x8,%esp
8010591c:	57                   	push   %edi
8010591d:	01 f0                	add    %esi,%eax
8010591f:	50                   	push   %eax
80105920:	e8 4b f3 ff ff       	call   80104c70 <fetchint>
80105925:	83 c4 10             	add    $0x10,%esp
80105928:	85 c0                	test   %eax,%eax
8010592a:	79 b4                	jns    801058e0 <sys_exec+0x60>
	}
	return exec(path, argv);
}
8010592c:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
8010592f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105934:	5b                   	pop    %ebx
80105935:	5e                   	pop    %esi
80105936:	5f                   	pop    %edi
80105937:	5d                   	pop    %ebp
80105938:	c3                   	ret    
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	return exec(path, argv);
80105940:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105946:	83 ec 08             	sub    $0x8,%esp
			argv[i] = 0;
80105949:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105950:	00 00 00 00 
	return exec(path, argv);
80105954:	50                   	push   %eax
80105955:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010595b:	e8 b0 b0 ff ff       	call   80100a10 <exec>
80105960:	83 c4 10             	add    $0x10,%esp
}
80105963:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105966:	5b                   	pop    %ebx
80105967:	5e                   	pop    %esi
80105968:	5f                   	pop    %edi
80105969:	5d                   	pop    %ebp
8010596a:	c3                   	ret    
8010596b:	90                   	nop
8010596c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_pipe>:

int
sys_pipe(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	56                   	push   %esi
80105975:	53                   	push   %ebx
	int *        fd;
	struct file *rf, *wf;
	int          fd0, fd1;

	if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0) return -1;
80105976:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105979:	83 ec 20             	sub    $0x20,%esp
	if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0) return -1;
8010597c:	6a 08                	push   $0x8
8010597e:	50                   	push   %eax
8010597f:	6a 00                	push   $0x0
80105981:	e8 ea f3 ff ff       	call   80104d70 <argptr>
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	85 c0                	test   %eax,%eax
8010598b:	0f 88 ae 00 00 00    	js     80105a3f <sys_pipe+0xcf>
	if (pipealloc(&rf, &wf) < 0) return -1;
80105991:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105994:	83 ec 08             	sub    $0x8,%esp
80105997:	50                   	push   %eax
80105998:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010599b:	50                   	push   %eax
8010599c:	e8 af d8 ff ff       	call   80103250 <pipealloc>
801059a1:	83 c4 10             	add    $0x10,%esp
801059a4:	85 c0                	test   %eax,%eax
801059a6:	0f 88 93 00 00 00    	js     80105a3f <sys_pipe+0xcf>
	fd0 = -1;
	if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
801059ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
	for (fd = 0; fd < NOFILE; fd++) {
801059af:	31 db                	xor    %ebx,%ebx
	struct proc *curproc = myproc();
801059b1:	e8 2a df ff ff       	call   801038e0 <myproc>
801059b6:	eb 10                	jmp    801059c8 <sys_pipe+0x58>
801059b8:	90                   	nop
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (fd = 0; fd < NOFILE; fd++) {
801059c0:	83 c3 01             	add    $0x1,%ebx
801059c3:	83 fb 10             	cmp    $0x10,%ebx
801059c6:	74 60                	je     80105a28 <sys_pipe+0xb8>
		if (curproc->ofile[fd] == 0) {
801059c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059cc:	85 f6                	test   %esi,%esi
801059ce:	75 f0                	jne    801059c0 <sys_pipe+0x50>
			curproc->ofile[fd] = f;
801059d0:	8d 73 08             	lea    0x8(%ebx),%esi
801059d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
	if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
801059d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	struct proc *curproc = myproc();
801059da:	e8 01 df ff ff       	call   801038e0 <myproc>
	for (fd = 0; fd < NOFILE; fd++) {
801059df:	31 d2                	xor    %edx,%edx
801059e1:	eb 0d                	jmp    801059f0 <sys_pipe+0x80>
801059e3:	90                   	nop
801059e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059e8:	83 c2 01             	add    $0x1,%edx
801059eb:	83 fa 10             	cmp    $0x10,%edx
801059ee:	74 28                	je     80105a18 <sys_pipe+0xa8>
		if (curproc->ofile[fd] == 0) {
801059f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059f4:	85 c9                	test   %ecx,%ecx
801059f6:	75 f0                	jne    801059e8 <sys_pipe+0x78>
			curproc->ofile[fd] = f;
801059f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
		if (fd0 >= 0) myproc()->ofile[fd0] = 0;
		fileclose(rf);
		fileclose(wf);
		return -1;
	}
	fd[0] = fd0;
801059fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059ff:	89 18                	mov    %ebx,(%eax)
	fd[1] = fd1;
80105a01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a04:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
80105a07:	31 c0                	xor    %eax,%eax
}
80105a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a0c:	5b                   	pop    %ebx
80105a0d:	5e                   	pop    %esi
80105a0e:	5f                   	pop    %edi
80105a0f:	5d                   	pop    %ebp
80105a10:	c3                   	ret    
80105a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if (fd0 >= 0) myproc()->ofile[fd0] = 0;
80105a18:	e8 c3 de ff ff       	call   801038e0 <myproc>
80105a1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a24:	00 
80105a25:	8d 76 00             	lea    0x0(%esi),%esi
		fileclose(rf);
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105a2e:	e8 0d b4 ff ff       	call   80100e40 <fileclose>
		fileclose(wf);
80105a33:	58                   	pop    %eax
80105a34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a37:	e8 04 b4 ff ff       	call   80100e40 <fileclose>
		return -1;
80105a3c:	83 c4 10             	add    $0x10,%esp
80105a3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a44:	eb c3                	jmp    80105a09 <sys_pipe+0x99>
80105a46:	66 90                	xchg   %ax,%ax
80105a48:	66 90                	xchg   %ax,%ax
80105a4a:	66 90                	xchg   %ax,%ax
80105a4c:	66 90                	xchg   %ax,%ax
80105a4e:	66 90                	xchg   %ax,%ax

80105a50 <sys_fork>:
int pq_enqueue(struct proc *p);
struct proc* pq_dequeue();

int
sys_fork(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
	return fork();
}
80105a53:	5d                   	pop    %ebp
	return fork();
80105a54:	e9 67 e1 ff ff       	jmp    80103bc0 <fork>
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_exit>:

int
sys_exit(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 08             	sub    $0x8,%esp
	exit();
80105a66:	e8 95 e5 ff ff       	call   80104000 <exit>
	return 0; // not reached
}
80105a6b:	31 c0                	xor    %eax,%eax
80105a6d:	c9                   	leave  
80105a6e:	c3                   	ret    
80105a6f:	90                   	nop

80105a70 <sys_wait>:

int
sys_wait(void)
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
	return wait();
}
80105a73:	5d                   	pop    %ebp
	return wait();
80105a74:	e9 17 e8 ff ff       	jmp    80104290 <wait>
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_kill>:

int
sys_kill(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	83 ec 20             	sub    $0x20,%esp
	int pid;

	if (argint(0, &pid) < 0) return -1;
80105a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a89:	50                   	push   %eax
80105a8a:	6a 00                	push   $0x0
80105a8c:	e8 8f f2 ff ff       	call   80104d20 <argint>
80105a91:	83 c4 10             	add    $0x10,%esp
80105a94:	85 c0                	test   %eax,%eax
80105a96:	78 18                	js     80105ab0 <sys_kill+0x30>
	return kill(pid);
80105a98:	83 ec 0c             	sub    $0xc,%esp
80105a9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a9e:	e8 1d e9 ff ff       	call   801043c0 <kill>
80105aa3:	83 c4 10             	add    $0x10,%esp
}
80105aa6:	c9                   	leave  
80105aa7:	c3                   	ret    
80105aa8:	90                   	nop
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (argint(0, &pid) < 0) return -1;
80105ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ac0 <sys_getpid>:

int
sys_getpid(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	83 ec 08             	sub    $0x8,%esp
	return myproc()->pid;
80105ac6:	e8 15 de ff ff       	call   801038e0 <myproc>
80105acb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105ace:	c9                   	leave  
80105acf:	c3                   	ret    

80105ad0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	53                   	push   %ebx
	int addr;
	int n;

	if (argint(0, &n) < 0) return -1;
80105ad4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ad7:	83 ec 1c             	sub    $0x1c,%esp
	if (argint(0, &n) < 0) return -1;
80105ada:	50                   	push   %eax
80105adb:	6a 00                	push   $0x0
80105add:	e8 3e f2 ff ff       	call   80104d20 <argint>
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	78 27                	js     80105b10 <sys_sbrk+0x40>
	addr = myproc()->sz;
80105ae9:	e8 f2 dd ff ff       	call   801038e0 <myproc>
	if (growproc(n) < 0) return -1;
80105aee:	83 ec 0c             	sub    $0xc,%esp
	addr = myproc()->sz;
80105af1:	8b 18                	mov    (%eax),%ebx
	if (growproc(n) < 0) return -1;
80105af3:	ff 75 f4             	pushl  -0xc(%ebp)
80105af6:	e8 45 e0 ff ff       	call   80103b40 <growproc>
80105afb:	83 c4 10             	add    $0x10,%esp
80105afe:	85 c0                	test   %eax,%eax
80105b00:	78 0e                	js     80105b10 <sys_sbrk+0x40>
	return addr;
}
80105b02:	89 d8                	mov    %ebx,%eax
80105b04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b07:	c9                   	leave  
80105b08:	c3                   	ret    
80105b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (argint(0, &n) < 0) return -1;
80105b10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b15:	eb eb                	jmp    80105b02 <sys_sbrk+0x32>
80105b17:	89 f6                	mov    %esi,%esi
80105b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b20 <sys_sleep>:

int
sys_sleep(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
	int  n;
	uint ticks0;

	if (argint(0, &n) < 0) return -1;
80105b24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b27:	83 ec 1c             	sub    $0x1c,%esp
	if (argint(0, &n) < 0) return -1;
80105b2a:	50                   	push   %eax
80105b2b:	6a 00                	push   $0x0
80105b2d:	e8 ee f1 ff ff       	call   80104d20 <argint>
80105b32:	83 c4 10             	add    $0x10,%esp
80105b35:	85 c0                	test   %eax,%eax
80105b37:	0f 88 8a 00 00 00    	js     80105bc7 <sys_sleep+0xa7>
	acquire(&tickslock);
80105b3d:	83 ec 0c             	sub    $0xc,%esp
80105b40:	68 a0 da 12 80       	push   $0x8012daa0
80105b45:	e8 56 ed ff ff       	call   801048a0 <acquire>
	ticks0 = ticks;
	while (ticks - ticks0 < n) {
80105b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b4d:	83 c4 10             	add    $0x10,%esp
	ticks0 = ticks;
80105b50:	8b 1d e0 e2 12 80    	mov    0x8012e2e0,%ebx
	while (ticks - ticks0 < n) {
80105b56:	85 d2                	test   %edx,%edx
80105b58:	75 27                	jne    80105b81 <sys_sleep+0x61>
80105b5a:	eb 54                	jmp    80105bb0 <sys_sleep+0x90>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if (myproc()->killed) {
			release(&tickslock);
			return -1;
		}
		sleep(&ticks, &tickslock);
80105b60:	83 ec 08             	sub    $0x8,%esp
80105b63:	68 a0 da 12 80       	push   $0x8012daa0
80105b68:	68 e0 e2 12 80       	push   $0x8012e2e0
80105b6d:	e8 5e e6 ff ff       	call   801041d0 <sleep>
	while (ticks - ticks0 < n) {
80105b72:	a1 e0 e2 12 80       	mov    0x8012e2e0,%eax
80105b77:	83 c4 10             	add    $0x10,%esp
80105b7a:	29 d8                	sub    %ebx,%eax
80105b7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b7f:	73 2f                	jae    80105bb0 <sys_sleep+0x90>
		if (myproc()->killed) {
80105b81:	e8 5a dd ff ff       	call   801038e0 <myproc>
80105b86:	8b 40 24             	mov    0x24(%eax),%eax
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	74 d3                	je     80105b60 <sys_sleep+0x40>
			release(&tickslock);
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	68 a0 da 12 80       	push   $0x8012daa0
80105b95:	e8 26 ee ff ff       	call   801049c0 <release>
			return -1;
80105b9a:	83 c4 10             	add    $0x10,%esp
80105b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
	release(&tickslock);
	return 0;
}
80105ba2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ba5:	c9                   	leave  
80105ba6:	c3                   	ret    
80105ba7:	89 f6                	mov    %esi,%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	release(&tickslock);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	68 a0 da 12 80       	push   $0x8012daa0
80105bb8:	e8 03 ee ff ff       	call   801049c0 <release>
	return 0;
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	31 c0                	xor    %eax,%eax
}
80105bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc5:	c9                   	leave  
80105bc6:	c3                   	ret    
	if (argint(0, &n) < 0) return -1;
80105bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bcc:	eb f4                	jmp    80105bc2 <sys_sleep+0xa2>
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
80105bd4:	83 ec 10             	sub    $0x10,%esp
	uint xticks;

	acquire(&tickslock);
80105bd7:	68 a0 da 12 80       	push   $0x8012daa0
80105bdc:	e8 bf ec ff ff       	call   801048a0 <acquire>
	xticks = ticks;
80105be1:	8b 1d e0 e2 12 80    	mov    0x8012e2e0,%ebx
	release(&tickslock);
80105be7:	c7 04 24 a0 da 12 80 	movl   $0x8012daa0,(%esp)
80105bee:	e8 cd ed ff ff       	call   801049c0 <release>
	return xticks;
}
80105bf3:	89 d8                	mov    %ebx,%eax
80105bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bf8:	c9                   	leave  
80105bf9:	c3                   	ret    
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c00 <sys_mcreate>:
find the index of the first 'empty mutex' 
(mutex is available), set mutex fields, initialize 
this process's reference to the mutex, return 
index/mutexid or -1 if full */
int 
sys_mcreate(char *name){
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	56                   	push   %esi
80105c04:	53                   	push   %ebx

	argptr(0,(void*)&name,sizeof(*name));
80105c05:	8d 45 08             	lea    0x8(%ebp),%eax
	struct proc *p = myproc();
	int i;

	acquire(&MUTEXES.lock);
	for (i=0; i<MUX_MAXNUM; i++){
80105c08:	31 db                	xor    %ebx,%ebx
	argptr(0,(void*)&name,sizeof(*name));
80105c0a:	83 ec 04             	sub    $0x4,%esp
80105c0d:	6a 01                	push   $0x1
80105c0f:	50                   	push   %eax
80105c10:	6a 00                	push   $0x0
80105c12:	e8 59 f1 ff ff       	call   80104d70 <argptr>
	struct proc *p = myproc();
80105c17:	e8 c4 dc ff ff       	call   801038e0 <myproc>
	acquire(&MUTEXES.lock);
80105c1c:	c7 04 24 e0 73 11 80 	movl   $0x801173e0,(%esp)
	struct proc *p = myproc();
80105c23:	89 c6                	mov    %eax,%esi
	acquire(&MUTEXES.lock);
80105c25:	e8 76 ec ff ff       	call   801048a0 <acquire>
80105c2a:	ba 14 74 11 80       	mov    $0x80117414,%edx
80105c2f:	83 c4 10             	add    $0x10,%esp
80105c32:	eb 12                	jmp    80105c46 <sys_mcreate+0x46>
80105c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (i=0; i<MUX_MAXNUM; i++){
80105c38:	83 c3 01             	add    $0x1,%ebx
80105c3b:	81 c2 a8 0f 00 00    	add    $0xfa8,%edx
80105c41:	83 fb 14             	cmp    $0x14,%ebx
80105c44:	74 4a                	je     80105c90 <sys_mcreate+0x90>
		if (MUTEXES.muxes[i].name == 0){
80105c46:	8b 02                	mov    (%edx),%eax
80105c48:	85 c0                	test   %eax,%eax
80105c4a:	75 ec                	jne    80105c38 <sys_mcreate+0x38>
			// set mutex fields
			MUTEXES.muxes[i].name = name;
80105c4c:	69 d3 a8 0f 00 00    	imul   $0xfa8,%ebx,%edx
80105c52:	8b 4d 08             	mov    0x8(%ebp),%ecx
			MUTEXES.muxes[i].state = 0;

			// initialize process reference
			p->mux_ptrs[i] = &MUTEXES.muxes[i];

			release(&MUTEXES.lock);
80105c55:	83 ec 0c             	sub    $0xc,%esp
			MUTEXES.muxes[i].name = name;
80105c58:	89 8a 14 74 11 80    	mov    %ecx,-0x7fee8bec(%edx)
			MUTEXES.muxes[i].state = 0;
80105c5e:	c7 82 18 74 11 80 00 	movl   $0x0,-0x7fee8be8(%edx)
80105c65:	00 00 00 
			p->mux_ptrs[i] = &MUTEXES.muxes[i];
80105c68:	81 c2 14 74 11 80    	add    $0x80117414,%edx
80105c6e:	89 54 9e 7c          	mov    %edx,0x7c(%esi,%ebx,4)
			release(&MUTEXES.lock);
80105c72:	68 e0 73 11 80       	push   $0x801173e0
80105c77:	e8 44 ed ff ff       	call   801049c0 <release>
			return i;
80105c7c:	83 c4 10             	add    $0x10,%esp
		}
	}
	release(&MUTEXES.lock);
	return -1;
}
80105c7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c82:	89 d8                	mov    %ebx,%eax
80105c84:	5b                   	pop    %ebx
80105c85:	5e                   	pop    %esi
80105c86:	5d                   	pop    %ebp
80105c87:	c3                   	ret    
80105c88:	90                   	nop
80105c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	release(&MUTEXES.lock);
80105c90:	83 ec 0c             	sub    $0xc,%esp
	return -1;
80105c93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
	release(&MUTEXES.lock);
80105c98:	68 e0 73 11 80       	push   $0x801173e0
80105c9d:	e8 1e ed ff ff       	call   801049c0 <release>
	return -1;
80105ca2:	83 c4 10             	add    $0x10,%esp
}
80105ca5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ca8:	89 d8                	mov    %ebx,%eax
80105caa:	5b                   	pop    %ebx
80105cab:	5e                   	pop    %esi
80105cac:	5d                   	pop    %ebp
80105cad:	c3                   	ret    
80105cae:	66 90                	xchg   %ax,%ax

80105cb0 <sys_mdelete>:

int
sys_mdelete(int muxid){
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	56                   	push   %esi
80105cb4:	53                   	push   %ebx
	
	argint(0,(int*)&muxid);
80105cb5:	8d 45 08             	lea    0x8(%ebp),%eax
80105cb8:	83 ec 08             	sub    $0x8,%esp
80105cbb:	50                   	push   %eax
80105cbc:	6a 00                	push   $0x0
80105cbe:	e8 5d f0 ff ff       	call   80104d20 <argint>
	struct proc *curproc = myproc();
80105cc3:	e8 18 dc ff ff       	call   801038e0 <myproc>
80105cc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105ccb:	89 c3                	mov    %eax,%ebx
	struct proc *p;

	// verify we have access to this mutex
	if (curproc->mux_ptrs[muxid] == 0){
80105ccd:	83 c4 10             	add    $0x10,%esp
80105cd0:	8d 34 88             	lea    (%eax,%ecx,4),%esi
		return 0;
80105cd3:	31 c0                	xor    %eax,%eax
	if (curproc->mux_ptrs[muxid] == 0){
80105cd5:	8b 56 7c             	mov    0x7c(%esi),%edx
80105cd8:	85 d2                	test   %edx,%edx
80105cda:	74 32                	je     80105d0e <sys_mdelete+0x5e>
	}

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105cdc:	ba f4 1f 11 80       	mov    $0x80111ff4,%edx
80105ce1:	eb 13                	jmp    80105cf6 <sys_mdelete+0x46>
80105ce3:	90                   	nop
80105ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ce8:	81 c2 d0 00 00 00    	add    $0xd0,%edx
80105cee:	81 fa f4 53 11 80    	cmp    $0x801153f4,%edx
80105cf4:	73 22                	jae    80105d18 <sys_mdelete+0x68>
		if (p != curproc && p->mux_ptrs[muxid] != 0){
80105cf6:	39 d3                	cmp    %edx,%ebx
80105cf8:	74 ee                	je     80105ce8 <sys_mdelete+0x38>
80105cfa:	8b 44 8a 7c          	mov    0x7c(%edx,%ecx,4),%eax
80105cfe:	85 c0                	test   %eax,%eax
80105d00:	74 e6                	je     80105ce8 <sys_mdelete+0x38>
	return 1;


rmptr:
	// remove this process's reference to mutex
	curproc->mux_ptrs[muxid] = 0;
80105d02:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
	return 1;
80105d09:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d11:	5b                   	pop    %ebx
80105d12:	5e                   	pop    %esi
80105d13:	5d                   	pop    %ebp
80105d14:	c3                   	ret    
80105d15:	8d 76 00             	lea    0x0(%esi),%esi
	acquire(&MUTEXES.lock);
80105d18:	83 ec 0c             	sub    $0xc,%esp
80105d1b:	68 e0 73 11 80       	push   $0x801173e0
80105d20:	e8 7b eb ff ff       	call   801048a0 <acquire>
	curproc->mux_ptrs[muxid]->name = 0;
80105d25:	8b 45 08             	mov    0x8(%ebp),%eax
80105d28:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80105d2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	curproc->mux_ptrs[muxid]->state = -1;
80105d32:	8b 45 08             	mov    0x8(%ebp),%eax
80105d35:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80105d39:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
	release(&MUTEXES.lock);
80105d40:	c7 04 24 e0 73 11 80 	movl   $0x801173e0,(%esp)
80105d47:	e8 74 ec ff ff       	call   801049c0 <release>
	curproc->mux_ptrs[muxid] = 0;
80105d4c:	8b 45 08             	mov    0x8(%ebp),%eax
	return 1;
80105d4f:	83 c4 10             	add    $0x10,%esp
	curproc->mux_ptrs[muxid] = 0;
80105d52:	c7 44 83 7c 00 00 00 	movl   $0x0,0x7c(%ebx,%eax,4)
80105d59:	00 
}
80105d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
	return 1;
80105d5d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105d62:	5b                   	pop    %ebx
80105d63:	5e                   	pop    %esi
80105d64:	5d                   	pop    %ebp
80105d65:	c3                   	ret    
80105d66:	8d 76 00             	lea    0x0(%esi),%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_mlock>:


int
sys_mlock(int muxid){
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx

	argint(0,(int*)&muxid);
80105d74:	8d 45 08             	lea    0x8(%ebp),%eax
sys_mlock(int muxid){
80105d77:	83 ec 0c             	sub    $0xc,%esp
	argint(0,(int*)&muxid);
80105d7a:	50                   	push   %eax
80105d7b:	6a 00                	push   $0x0
80105d7d:	e8 9e ef ff ff       	call   80104d20 <argint>
	struct proc *p = myproc();
80105d82:	e8 59 db ff ff       	call   801038e0 <myproc>
	int i;

	// verify this process has access to this mutex
	if (p->mux_ptrs[muxid] == 0){
80105d87:	8b 55 08             	mov    0x8(%ebp),%edx
	struct proc *p = myproc();
80105d8a:	89 c3                	mov    %eax,%ebx
	if (p->mux_ptrs[muxid] == 0){
80105d8c:	83 c4 10             	add    $0x10,%esp
		return 0;
80105d8f:	31 c0                	xor    %eax,%eax
	if (p->mux_ptrs[muxid] == 0){
80105d91:	8b 54 93 7c          	mov    0x7c(%ebx,%edx,4),%edx
80105d95:	85 d2                	test   %edx,%edx
80105d97:	0f 84 c8 00 00 00    	je     80105e65 <sys_mlock+0xf5>
	}

	acquire(&MUTEXES.lock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 e0 73 11 80       	push   $0x801173e0
80105da5:	8d 76 00             	lea    0x0(%esi),%esi
80105da8:	e8 f3 ea ff ff       	call   801048a0 <acquire>
	while (p->mux_ptrs[muxid]->state == 1){ // lock taken, block waiting for your turn
80105dad:	8b 45 08             	mov    0x8(%ebp),%eax
80105db0:	83 c4 10             	add    $0x10,%esp
80105db3:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80105db7:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
80105dbb:	0f 85 88 00 00 00    	jne    80105e49 <sys_mlock+0xd9>

		//cprintf("A\n");

		/* atomically enqueue myself into wait queue
		if this process is already on the wait queue, do not add it again */
		acquire(&wqueue.lock);
80105dc1:	83 ec 0c             	sub    $0xc,%esp
80105dc4:	68 e0 0f 11 80       	push   $0x80110fe0
80105dc9:	e8 d2 ea ff ff       	call   801048a0 <acquire>
80105dce:	83 c4 10             	add    $0x10,%esp
		for (i=0; i<1000; i++){
80105dd1:	31 d2                	xor    %edx,%edx
80105dd3:	eb 16                	jmp    80105deb <sys_mlock+0x7b>
80105dd5:	8d 76 00             	lea    0x0(%esi),%esi
			if (wqueue.queue[i] == p){
				break;
			}
			if (wqueue.queue[i] == 0){
80105dd8:	85 c9                	test   %ecx,%ecx
80105dda:	74 64                	je     80105e40 <sys_mlock+0xd0>
		for (i=0; i<1000; i++){
80105ddc:	83 c2 01             	add    $0x1,%edx
80105ddf:	81 fa e8 03 00 00    	cmp    $0x3e8,%edx
80105de5:	0f 84 85 00 00 00    	je     80105e70 <sys_mlock+0x100>
			if (wqueue.queue[i] == p){
80105deb:	8b 0c 95 14 10 11 80 	mov    -0x7feeefec(,%edx,4),%ecx
80105df2:	39 d9                	cmp    %ebx,%ecx
80105df4:	75 e2                	jne    80105dd8 <sys_mlock+0x68>
				wqueue.queue[i] = p;
				break;
			}
		}
		release(&wqueue.lock);
80105df6:	83 ec 0c             	sub    $0xc,%esp
80105df9:	68 e0 0f 11 80       	push   $0x80110fe0
80105dfe:	e8 bd eb ff ff       	call   801049c0 <release>
			// wait queue is full
			return 0;
		}
		
		// put myself to sleep and call scheduler
		release(&MUTEXES.lock);
80105e03:	c7 04 24 e0 73 11 80 	movl   $0x801173e0,(%esp)
80105e0a:	e8 b1 eb ff ff       	call   801049c0 <release>
		acquire(&ptable.lock);
80105e0f:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80105e16:	e8 85 ea ff ff       	call   801048a0 <acquire>
		p->state = SLEEPING;
80105e1b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
		sched();
80105e22:	e8 19 e1 ff ff       	call   80103f40 <sched>
		release(&ptable.lock);
80105e27:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80105e2e:	e8 8d eb ff ff       	call   801049c0 <release>

		acquire(&MUTEXES.lock);
80105e33:	c7 04 24 e0 73 11 80 	movl   $0x801173e0,(%esp)
80105e3a:	e9 69 ff ff ff       	jmp    80105da8 <sys_mlock+0x38>
80105e3f:	90                   	nop
				wqueue.queue[i] = p;
80105e40:	89 1c 95 14 10 11 80 	mov    %ebx,-0x7feeefec(,%edx,4)
				break;
80105e47:	eb ad                	jmp    80105df6 <sys_mlock+0x86>
	}

	// lock available, take the lock
	p->mux_ptrs[muxid]->state = 1;
	release(&MUTEXES.lock);
80105e49:	83 ec 0c             	sub    $0xc,%esp
	p->mux_ptrs[muxid]->state = 1;
80105e4c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	release(&MUTEXES.lock);
80105e53:	68 e0 73 11 80       	push   $0x801173e0
80105e58:	e8 63 eb ff ff       	call   801049c0 <release>
	return 1;
80105e5d:	83 c4 10             	add    $0x10,%esp
80105e60:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e68:	c9                   	leave  
80105e69:	c3                   	ret    
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		release(&wqueue.lock);
80105e70:	83 ec 0c             	sub    $0xc,%esp
80105e73:	68 e0 0f 11 80       	push   $0x80110fe0
80105e78:	e8 43 eb ff ff       	call   801049c0 <release>
80105e7d:	83 c4 10             	add    $0x10,%esp
			return 0;
80105e80:	31 c0                	xor    %eax,%eax
}
80105e82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e85:	c9                   	leave  
80105e86:	c3                   	ret    
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e90 <sys_munlock>:

int
sys_munlock(int muxid){
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	56                   	push   %esi
80105e94:	53                   	push   %ebx

	argint(0,(int*)&muxid);
80105e95:	8d 45 08             	lea    0x8(%ebp),%eax
sys_munlock(int muxid){
80105e98:	83 ec 18             	sub    $0x18,%esp
	argint(0,(int*)&muxid);
80105e9b:	50                   	push   %eax
80105e9c:	6a 00                	push   $0x0
80105e9e:	e8 7d ee ff ff       	call   80104d20 <argint>
	struct proc *p, *sleepy_proc;
	p = myproc();
80105ea3:	e8 38 da ff ff       	call   801038e0 <myproc>
	int i;


	/* verify this process has access to this mutex
	and make sure proc is currently holding this mutex*/
	if (p->mux_ptrs[muxid] == 0 || p->mux_ptrs[muxid]->state != 1){
80105ea8:	8b 55 08             	mov    0x8(%ebp),%edx
80105eab:	83 c4 10             	add    $0x10,%esp
80105eae:	8b 54 90 7c          	mov    0x7c(%eax,%edx,4),%edx
80105eb2:	85 d2                	test   %edx,%edx
80105eb4:	74 08                	je     80105ebe <sys_munlock+0x2e>
80105eb6:	8b 5a 04             	mov    0x4(%edx),%ebx
80105eb9:	83 fb 01             	cmp    $0x1,%ebx
80105ebc:	74 12                	je     80105ed0 <sys_munlock+0x40>
		return 0;
80105ebe:	31 db                	xor    %ebx,%ebx
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
	}
	release(&ptable.lock);

	return 1;
}
80105ec0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ec3:	89 d8                	mov    %ebx,%eax
80105ec5:	5b                   	pop    %ebx
80105ec6:	5e                   	pop    %esi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	acquire(&MUTEXES.lock);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ed6:	68 e0 73 11 80       	push   $0x801173e0
80105edb:	e8 c0 e9 ff ff       	call   801048a0 <acquire>
	p->mux_ptrs[muxid]->state = 0;
80105ee0:	8b 55 08             	mov    0x8(%ebp),%edx
80105ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee6:	8b 44 90 7c          	mov    0x7c(%eax,%edx,4),%eax
80105eea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	release(&MUTEXES.lock);
80105ef1:	c7 04 24 e0 73 11 80 	movl   $0x801173e0,(%esp)
80105ef8:	e8 c3 ea ff ff       	call   801049c0 <release>
	acquire(&wqueue.lock);
80105efd:	c7 04 24 e0 0f 11 80 	movl   $0x80110fe0,(%esp)
80105f04:	e8 97 e9 ff ff       	call   801048a0 <acquire>
	sleepy_proc = wqueue.queue[0];
80105f09:	8b 35 14 10 11 80    	mov    0x80111014,%esi
	if (sleepy_proc == 0){
80105f0f:	83 c4 10             	add    $0x10,%esp
80105f12:	b8 14 10 11 80       	mov    $0x80111014,%eax
80105f17:	85 f6                	test   %esi,%esi
80105f19:	74 67                	je     80105f82 <sys_munlock+0xf2>
80105f1b:	90                   	nop
80105f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		wqueue.queue[i] = wqueue.queue[i+1];
80105f20:	8b 50 04             	mov    0x4(%eax),%edx
80105f23:	83 c0 04             	add    $0x4,%eax
80105f26:	89 50 fc             	mov    %edx,-0x4(%eax)
	for (i=0; i<999; i++){
80105f29:	3d b0 1f 11 80       	cmp    $0x80111fb0,%eax
80105f2e:	75 f0                	jne    80105f20 <sys_munlock+0x90>
	release(&wqueue.lock);
80105f30:	83 ec 0c             	sub    $0xc,%esp
	wqueue.queue[999] = 0;
80105f33:	c7 05 b0 1f 11 80 00 	movl   $0x0,0x80111fb0
80105f3a:	00 00 00 
	release(&wqueue.lock);
80105f3d:	68 e0 0f 11 80       	push   $0x80110fe0
80105f42:	e8 79 ea ff ff       	call   801049c0 <release>
	acquire(&ptable.lock);
80105f47:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80105f4e:	e8 4d e9 ff ff       	call   801048a0 <acquire>
	sleepy_proc->state = RUNNABLE;
80105f53:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
	if (pq_enqueue(sleepy_proc) < 0){
80105f5a:	89 34 24             	mov    %esi,(%esp)
80105f5d:	e8 2e e6 ff ff       	call   80104590 <pq_enqueue>
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	85 c0                	test   %eax,%eax
80105f67:	78 2e                	js     80105f97 <sys_munlock+0x107>
	release(&ptable.lock);
80105f69:	83 ec 0c             	sub    $0xc,%esp
80105f6c:	68 c0 1f 11 80       	push   $0x80111fc0
80105f71:	e8 4a ea ff ff       	call   801049c0 <release>
	return 1;
80105f76:	83 c4 10             	add    $0x10,%esp
}
80105f79:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f7c:	89 d8                	mov    %ebx,%eax
80105f7e:	5b                   	pop    %ebx
80105f7f:	5e                   	pop    %esi
80105f80:	5d                   	pop    %ebp
80105f81:	c3                   	ret    
		release(&wqueue.lock);
80105f82:	83 ec 0c             	sub    $0xc,%esp
80105f85:	68 e0 0f 11 80       	push   $0x80110fe0
80105f8a:	e8 31 ea ff ff       	call   801049c0 <release>
		return 1;
80105f8f:	83 c4 10             	add    $0x10,%esp
80105f92:	e9 29 ff ff ff       	jmp    80105ec0 <sys_munlock+0x30>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
80105f97:	83 ec 0c             	sub    $0xc,%esp
80105f9a:	68 38 81 10 80       	push   $0x80108138
80105f9f:	e8 ec a3 ff ff       	call   80100390 <panic>
80105fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105fb0 <sys_waitcv>:


int
sys_waitcv(int muxid){
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	53                   	push   %ebx

	argint(0,(int*)&muxid);
80105fb4:	8d 45 08             	lea    0x8(%ebp),%eax
sys_waitcv(int muxid){
80105fb7:	83 ec 0c             	sub    $0xc,%esp
	argint(0,(int*)&muxid);
80105fba:	50                   	push   %eax
80105fbb:	6a 00                	push   $0x0
80105fbd:	e8 5e ed ff ff       	call   80104d20 <argint>
	struct proc *p = myproc();
80105fc2:	e8 19 d9 ff ff       	call   801038e0 <myproc>
	int i;

	/* atomically enqueue proc to mux's cv wait queue if this 
	process is already on the wait queue, do not add it again */
	acquire(&MUTEXES.lock);
80105fc7:	c7 04 24 e0 73 11 80 	movl   $0x801173e0,(%esp)
	struct proc *p = myproc();
80105fce:	89 c3                	mov    %eax,%ebx
	acquire(&MUTEXES.lock);
80105fd0:	e8 cb e8 ff ff       	call   801048a0 <acquire>
	for (i=0; i<1000; i++){
		if (p->mux_ptrs[muxid]->cv[i] == p){
80105fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80105fd8:	83 c4 10             	add    $0x10,%esp
	for (i=0; i<1000; i++){
80105fdb:	31 d2                	xor    %edx,%edx
		if (p->mux_ptrs[muxid]->cv[i] == p){
80105fdd:	8b 44 83 7c          	mov    0x7c(%ebx,%eax,4),%eax
80105fe1:	eb 14                	jmp    80105ff7 <sys_waitcv+0x47>
80105fe3:	90                   	nop
80105fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			break;
		}
		if (p->mux_ptrs[muxid]->cv[i] == 0){
80105fe8:	85 c9                	test   %ecx,%ecx
80105fea:	74 4c                	je     80106038 <sys_waitcv+0x88>
	for (i=0; i<1000; i++){
80105fec:	83 c2 01             	add    $0x1,%edx
80105fef:	81 fa e8 03 00 00    	cmp    $0x3e8,%edx
80105ff5:	74 79                	je     80106070 <sys_waitcv+0xc0>
		if (p->mux_ptrs[muxid]->cv[i] == p){
80105ff7:	8b 4c 90 08          	mov    0x8(%eax,%edx,4),%ecx
80105ffb:	39 d9                	cmp    %ebx,%ecx
80105ffd:	75 e9                	jne    80105fe8 <sys_waitcv+0x38>
			p->mux_ptrs[muxid]->cv[i]= p;
			break;
		}
	}
	release(&MUTEXES.lock);
80105fff:	83 ec 0c             	sub    $0xc,%esp
80106002:	68 e0 73 11 80       	push   $0x801173e0
80106007:	e8 b4 e9 ff ff       	call   801049c0 <release>
		// cv wait queue is full
		return 0;
	}
	
	// sleep self and call scheduler
	acquire(&ptable.lock);
8010600c:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
80106013:	e8 88 e8 ff ff       	call   801048a0 <acquire>
	p->state = SLEEPING;
80106018:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
	// release mutex
	if (!sys_munlock(muxid)){
8010601f:	58                   	pop    %eax
80106020:	ff 75 08             	pushl  0x8(%ebp)
80106023:	e8 68 fe ff ff       	call   80105e90 <sys_munlock>
80106028:	83 c4 10             	add    $0x10,%esp
8010602b:	85 c0                	test   %eax,%eax
8010602d:	75 11                	jne    80106040 <sys_waitcv+0x90>
	if (!sys_mlock(muxid)){
		return 0;
	}
	return 1;

}
8010602f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106032:	c9                   	leave  
80106033:	c3                   	ret    
80106034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			p->mux_ptrs[muxid]->cv[i]= p;
80106038:	89 5c 90 08          	mov    %ebx,0x8(%eax,%edx,4)
			break;
8010603c:	eb c1                	jmp    80105fff <sys_waitcv+0x4f>
8010603e:	66 90                	xchg   %ax,%ax
	sched();
80106040:	e8 fb de ff ff       	call   80103f40 <sched>
	release(&ptable.lock);
80106045:	83 ec 0c             	sub    $0xc,%esp
80106048:	68 c0 1f 11 80       	push   $0x80111fc0
8010604d:	e8 6e e9 ff ff       	call   801049c0 <release>
	if (!sys_mlock(muxid)){
80106052:	5a                   	pop    %edx
80106053:	ff 75 08             	pushl  0x8(%ebp)
80106056:	e8 15 fd ff ff       	call   80105d70 <sys_mlock>
8010605b:	83 c4 10             	add    $0x10,%esp
8010605e:	85 c0                	test   %eax,%eax
}
80106060:	8b 5d fc             	mov    -0x4(%ebp),%ebx
	if (!sys_mlock(muxid)){
80106063:	0f 95 c0             	setne  %al
}
80106066:	c9                   	leave  
	if (!sys_mlock(muxid)){
80106067:	0f b6 c0             	movzbl %al,%eax
}
8010606a:	c3                   	ret    
8010606b:	90                   	nop
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	release(&MUTEXES.lock);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	68 e0 73 11 80       	push   $0x801173e0
80106078:	e8 43 e9 ff ff       	call   801049c0 <release>
8010607d:	83 c4 10             	add    $0x10,%esp
		return 0;
80106080:	31 c0                	xor    %eax,%eax
80106082:	eb ab                	jmp    8010602f <sys_waitcv+0x7f>
80106084:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010608a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106090 <sys_signalcv>:
int 
sys_signalcv(int muxid){
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	57                   	push   %edi
80106094:	56                   	push   %esi
80106095:	53                   	push   %ebx

	argint(0,(int*)&muxid);
80106096:	8d 45 08             	lea    0x8(%ebp),%eax
sys_signalcv(int muxid){
80106099:	83 ec 24             	sub    $0x24,%esp
	argint(0,(int*)&muxid);
8010609c:	50                   	push   %eax
8010609d:	6a 00                	push   $0x0
8010609f:	e8 7c ec ff ff       	call   80104d20 <argint>
	struct proc *p, *sleepy_proc; 
	p = myproc();
801060a4:	e8 37 d8 ff ff       	call   801038e0 <myproc>
	int i;

	/* verify this process has access to this mutex
	and make sure proc is currently holding this mutex*/
	if (p->mux_ptrs[muxid] == 0 || p->mux_ptrs[muxid]->state != 1){
801060a9:	8b 55 08             	mov    0x8(%ebp),%edx
801060ac:	83 c4 10             	add    $0x10,%esp
801060af:	8b 54 90 7c          	mov    0x7c(%eax,%edx,4),%edx
801060b3:	85 d2                	test   %edx,%edx
801060b5:	74 08                	je     801060bf <sys_signalcv+0x2f>
801060b7:	8b 5a 04             	mov    0x4(%edx),%ebx
801060ba:	83 fb 01             	cmp    $0x1,%ebx
801060bd:	74 21                	je     801060e0 <sys_signalcv+0x50>
		cprintf("A\n");
801060bf:	83 ec 0c             	sub    $0xc,%esp
		return 0;
801060c2:	31 db                	xor    %ebx,%ebx
		cprintf("A\n");
801060c4:	68 dd 83 10 80       	push   $0x801083dd
801060c9:	e8 92 a5 ff ff       	call   80100660 <cprintf>
		return 0;
801060ce:	83 c4 10             	add    $0x10,%esp
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
	}
	release(&ptable.lock);

	return 1;
}
801060d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d4:	89 d8                	mov    %ebx,%eax
801060d6:	5b                   	pop    %ebx
801060d7:	5e                   	pop    %esi
801060d8:	5f                   	pop    %edi
801060d9:	5d                   	pop    %ebp
801060da:	c3                   	ret    
801060db:	90                   	nop
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	acquire(&MUTEXES.lock);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801060e6:	68 e0 73 11 80       	push   $0x801173e0
801060eb:	e8 b0 e7 ff ff       	call   801048a0 <acquire>
801060f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060f3:	8b 55 08             	mov    0x8(%ebp),%edx
	if (sleepy_proc == 0){
801060f6:	83 c4 10             	add    $0x10,%esp
801060f9:	8d 0c 90             	lea    (%eax,%edx,4),%ecx
	for (i=0; i<999; i++){
801060fc:	31 c0                	xor    %eax,%eax
	sleepy_proc = p->mux_ptrs[muxid]->cv[0];
801060fe:	8b 79 7c             	mov    0x7c(%ecx),%edi
80106101:	8b 77 08             	mov    0x8(%edi),%esi
	if (sleepy_proc == 0){
80106104:	85 f6                	test   %esi,%esi
80106106:	75 0d                	jne    80106115 <sys_signalcv+0x85>
80106108:	eb 75                	jmp    8010617f <sys_signalcv+0xef>
8010610a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106110:	8b 79 7c             	mov    0x7c(%ecx),%edi
80106113:	89 d0                	mov    %edx,%eax
		p->mux_ptrs[muxid]->cv[i] = p->mux_ptrs[muxid]->cv[i+1];
80106115:	8d 50 01             	lea    0x1(%eax),%edx
80106118:	8d 04 87             	lea    (%edi,%eax,4),%eax
8010611b:	8b 78 0c             	mov    0xc(%eax),%edi
	for (i=0; i<999; i++){
8010611e:	81 fa e7 03 00 00    	cmp    $0x3e7,%edx
		p->mux_ptrs[muxid]->cv[i] = p->mux_ptrs[muxid]->cv[i+1];
80106124:	89 78 08             	mov    %edi,0x8(%eax)
	for (i=0; i<999; i++){
80106127:	75 e7                	jne    80106110 <sys_signalcv+0x80>
	p->mux_ptrs[muxid]->cv[999] = 0;
80106129:	8b 41 7c             	mov    0x7c(%ecx),%eax
	release(&MUTEXES.lock);
8010612c:	83 ec 0c             	sub    $0xc,%esp
	p->mux_ptrs[muxid]->cv[999] = 0;
8010612f:	c7 80 a4 0f 00 00 00 	movl   $0x0,0xfa4(%eax)
80106136:	00 00 00 
	release(&MUTEXES.lock);
80106139:	68 e0 73 11 80       	push   $0x801173e0
8010613e:	e8 7d e8 ff ff       	call   801049c0 <release>
	acquire(&ptable.lock);
80106143:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
8010614a:	e8 51 e7 ff ff       	call   801048a0 <acquire>
	sleepy_proc->state = RUNNABLE;
8010614f:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
	if (pq_enqueue(sleepy_proc) < 0){
80106156:	89 34 24             	mov    %esi,(%esp)
80106159:	e8 32 e4 ff ff       	call   80104590 <pq_enqueue>
8010615e:	83 c4 10             	add    $0x10,%esp
80106161:	85 c0                	test   %eax,%eax
80106163:	78 3d                	js     801061a2 <sys_signalcv+0x112>
	release(&ptable.lock);
80106165:	83 ec 0c             	sub    $0xc,%esp
80106168:	68 c0 1f 11 80       	push   $0x80111fc0
8010616d:	e8 4e e8 ff ff       	call   801049c0 <release>
	return 1;
80106172:	83 c4 10             	add    $0x10,%esp
}
80106175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106178:	89 d8                	mov    %ebx,%eax
8010617a:	5b                   	pop    %ebx
8010617b:	5e                   	pop    %esi
8010617c:	5f                   	pop    %edi
8010617d:	5d                   	pop    %ebp
8010617e:	c3                   	ret    
		release(&MUTEXES.lock);
8010617f:	83 ec 0c             	sub    $0xc,%esp
		return 0;
80106182:	31 db                	xor    %ebx,%ebx
		release(&MUTEXES.lock);
80106184:	68 e0 73 11 80       	push   $0x801173e0
80106189:	e8 32 e8 ff ff       	call   801049c0 <release>
		cprintf("B\n");
8010618e:	c7 04 24 e0 83 10 80 	movl   $0x801083e0,(%esp)
80106195:	e8 c6 a4 ff ff       	call   80100660 <cprintf>
		return 0;
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	e9 2f ff ff ff       	jmp    801060d1 <sys_signalcv+0x41>
		panic("process tried to enqueue when queue is full\n"); // should probably change this at some point
801061a2:	83 ec 0c             	sub    $0xc,%esp
801061a5:	68 38 81 10 80       	push   $0x80108138
801061aa:	e8 e1 a1 ff ff       	call   80100390 <panic>
801061af:	90                   	nop

801061b0 <sys_prio_set>:

/* attempts to set the priority of the process identified by pid to priority. 
The priority of the initial process was already set to 0 (highest priority), 
and all child processes inherit the priority level of parent*/
int 
sys_prio_set(int pid, int priority){
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	53                   	push   %ebx

	argint(0,(int*)&pid);	
801061b4:	8d 45 08             	lea    0x8(%ebp),%eax
sys_prio_set(int pid, int priority){
801061b7:	83 ec 0c             	sub    $0xc,%esp
	argint(0,(int*)&pid);	
801061ba:	50                   	push   %eax
801061bb:	6a 00                	push   $0x0
801061bd:	e8 5e eb ff ff       	call   80104d20 <argint>
	argint(1,(int*)&priority);
801061c2:	58                   	pop    %eax
801061c3:	8d 45 0c             	lea    0xc(%ebp),%eax
801061c6:	5a                   	pop    %edx
801061c7:	50                   	push   %eax
801061c8:	6a 01                	push   $0x1
801061ca:	e8 51 eb ff ff       	call   80104d20 <argint>
	struct proc *curproc = myproc();
801061cf:	e8 0c d7 ff ff       	call   801038e0 <myproc>
801061d4:	89 c3                	mov    %eax,%ebx
	struct proc *p;

	//temporarily
	//cprintf("%d\n", curproc->priority);

	if (priority >= PRIO_MAX){
801061d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801061d9:	83 c4 10             	add    $0x10,%esp
801061dc:	83 f8 13             	cmp    $0x13,%eax
801061df:	0f 8f c5 00 00 00    	jg     801062aa <sys_prio_set+0xfa>
		// invalid priority
		return -1;
	}

	// quick-exit case 1: process is trying to set priority above its own
	if (priority < curproc->priority){
801061e5:	39 83 cc 00 00 00    	cmp    %eax,0xcc(%ebx)
801061eb:	0f 87 b9 00 00 00    	ja     801062aa <sys_prio_set+0xfa>
		return -1;
	}
	// quick-exit case 2: pid refers to this process
	if (curproc->pid == pid){
801061f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801061f4:	39 4b 10             	cmp    %ecx,0x10(%ebx)
801061f7:	0f 84 83 00 00 00    	je     80106280 <sys_prio_set+0xd0>
	}


	// validate that the pid process is in ancestry of current process:
	// search through proc table until we find process with pid
	acquire(&ptable.lock);
801061fd:	83 ec 0c             	sub    $0xc,%esp
80106200:	68 c0 1f 11 80       	push   $0x80111fc0
80106205:	e8 96 e6 ff ff       	call   801048a0 <acquire>
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
		if (p != curproc && p->pid == pid){
8010620a:	8b 45 08             	mov    0x8(%ebp),%eax
8010620d:	83 c4 10             	add    $0x10,%esp
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80106210:	ba f4 1f 11 80       	mov    $0x80111ff4,%edx
80106215:	eb 17                	jmp    8010622e <sys_prio_set+0x7e>
80106217:	89 f6                	mov    %esi,%esi
80106219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106220:	81 c2 d0 00 00 00    	add    $0xd0,%edx
80106226:	81 fa f4 53 11 80    	cmp    $0x801153f4,%edx
8010622c:	73 62                	jae    80106290 <sys_prio_set+0xe0>
		if (p != curproc && p->pid == pid){
8010622e:	39 d3                	cmp    %edx,%ebx
80106230:	74 ee                	je     80106220 <sys_prio_set+0x70>
80106232:	39 42 10             	cmp    %eax,0x10(%edx)
80106235:	75 e9                	jne    80106220 <sys_prio_set+0x70>
			break;
		}
	}
	if (p >= &ptable.proc[NPROC]){
80106237:	81 fa f4 53 11 80    	cmp    $0x801153f4,%edx
8010623d:	73 51                	jae    80106290 <sys_prio_set+0xe0>
		release(&ptable.lock);
		return -1;
	}
	// search down it's parent links until we either find the current proc, or we reach pid <= 1
	int found = 0;
	struct proc *i = p->parent;
8010623f:	8b 42 14             	mov    0x14(%edx),%eax
	while (i->pid > 1){
80106242:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80106246:	7f 11                	jg     80106259 <sys_prio_set+0xa9>
80106248:	eb 46                	jmp    80106290 <sys_prio_set+0xe0>
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (i == curproc){
			found = 1;
			break;
		}
		i = i->parent;
80106250:	8b 40 14             	mov    0x14(%eax),%eax
	while (i->pid > 1){
80106253:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80106257:	7e 37                	jle    80106290 <sys_prio_set+0xe0>
		if (i == curproc){
80106259:	39 c3                	cmp    %eax,%ebx
8010625b:	75 f3                	jne    80106250 <sys_prio_set+0xa0>
	}
	if (found){
		p->priority = priority;
8010625d:	8b 45 0c             	mov    0xc(%ebp),%eax
	} else{
		// this process is not in your ancestry
		release(&ptable.lock);
		return -1;
	}
	release(&ptable.lock);
80106260:	83 ec 0c             	sub    $0xc,%esp
		p->priority = priority;
80106263:	89 82 cc 00 00 00    	mov    %eax,0xcc(%edx)
	release(&ptable.lock);
80106269:	68 c0 1f 11 80       	push   $0x80111fc0
8010626e:	e8 4d e7 ff ff       	call   801049c0 <release>
	return 1;
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010627b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010627e:	c9                   	leave  
8010627f:	c3                   	ret    
		curproc->priority = priority;
80106280:	89 83 cc 00 00 00    	mov    %eax,0xcc(%ebx)
		return 1;
80106286:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010628b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010628e:	c9                   	leave  
8010628f:	c3                   	ret    
		release(&ptable.lock);
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	68 c0 1f 11 80       	push   $0x80111fc0
80106298:	e8 23 e7 ff ff       	call   801049c0 <release>
		return -1;
8010629d:	83 c4 10             	add    $0x10,%esp
801062a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062a8:	c9                   	leave  
801062a9:	c3                   	ret    
		return -1;
801062aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062af:	eb ca                	jmp    8010627b <sys_prio_set+0xcb>
801062b1:	eb 0d                	jmp    801062c0 <sys_testpqeq>
801062b3:	90                   	nop
801062b4:	90                   	nop
801062b5:	90                   	nop
801062b6:	90                   	nop
801062b7:	90                   	nop
801062b8:	90                   	nop
801062b9:	90                   	nop
801062ba:	90                   	nop
801062bb:	90                   	nop
801062bc:	90                   	nop
801062bd:	90                   	nop
801062be:	90                   	nop
801062bf:	90                   	nop

801062c0 <sys_testpqeq>:

// user forks a bunch of children, sets varying priority levels, and calls this function for each of them
void
sys_testpqeq(){
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	83 ec 14             	sub    $0x14,%esp

	acquire(&ptable.lock);
801062c6:	68 c0 1f 11 80       	push   $0x80111fc0
801062cb:	e8 d0 e5 ff ff       	call   801048a0 <acquire>
	struct proc *p = myproc();
801062d0:	e8 0b d6 ff ff       	call   801038e0 <myproc>
	
	int priority = p->priority;
	char prio_char = (char)(priority+47);
801062d5:	0f b6 88 cc 00 00 00 	movzbl 0xcc(%eax),%ecx
	p->name[0] = prio_char; 
	p->name[1] = '\0';
801062dc:	c6 40 6d 00          	movb   $0x0,0x6d(%eax)
	char prio_char = (char)(priority+47);
801062e0:	8d 51 2f             	lea    0x2f(%ecx),%edx
801062e3:	88 50 6c             	mov    %dl,0x6c(%eax)

	// enqueue 
	pq_enqueue(p);
801062e6:	89 04 24             	mov    %eax,(%esp)
801062e9:	e8 a2 e2 ff ff       	call   80104590 <pq_enqueue>
	release(&ptable.lock);
801062ee:	c7 04 24 c0 1f 11 80 	movl   $0x80111fc0,(%esp)
801062f5:	e8 c6 e6 ff ff       	call   801049c0 <release>



}
801062fa:	83 c4 10             	add    $0x10,%esp
801062fd:	c9                   	leave  
801062fe:	c3                   	ret    
801062ff:	90                   	nop

80106300 <sys_testpqdq>:

// after user enqueued a bunch of procs using the above function, dequeue them all and observe the order
void
sys_testpqdq(){
80106300:	55                   	push   %ebp
80106301:	89 e5                	mov    %esp,%ebp
80106303:	53                   	push   %ebx

	struct proc *p = pq_dequeue();
	int count = 0;
80106304:	31 db                	xor    %ebx,%ebx
sys_testpqdq(){
80106306:	83 ec 04             	sub    $0x4,%esp
	struct proc *p = pq_dequeue();
80106309:	e8 12 e3 ff ff       	call   80104620 <pq_dequeue>
8010630e:	eb 14                	jmp    80106324 <sys_testpqdq+0x24>

		if (p->name[0] == '1'){
			cprintf("%s\n", p->name);
			count++;
		}
		else if (p->name[0] == '2'){
80106310:	80 fa 32             	cmp    $0x32,%dl
80106313:	74 18                	je     8010632d <sys_testpqdq+0x2d>
			cprintf("%s\n", p->name);
			count++;
		}
		else if (p->name[0] == '3'){
80106315:	80 fa 33             	cmp    $0x33,%dl
80106318:	74 13                	je     8010632d <sys_testpqdq+0x2d>
			cprintf("%s\n", p->name);
			count++;
		}

		p = pq_dequeue();
8010631a:	e8 01 e3 ff ff       	call   80104620 <pq_dequeue>
	while (count < 3){
8010631f:	83 fb 03             	cmp    $0x3,%ebx
80106322:	74 2a                	je     8010634e <sys_testpqdq+0x4e>
		if (p->name[0] == '1'){
80106324:	0f b6 50 6c          	movzbl 0x6c(%eax),%edx
80106328:	80 fa 31             	cmp    $0x31,%dl
8010632b:	75 e3                	jne    80106310 <sys_testpqdq+0x10>
			cprintf("%s\n", p->name);
8010632d:	83 ec 08             	sub    $0x8,%esp
80106330:	83 c0 6c             	add    $0x6c,%eax
			count++;
80106333:	83 c3 01             	add    $0x1,%ebx
			cprintf("%s\n", p->name);
80106336:	50                   	push   %eax
80106337:	68 e3 83 10 80       	push   $0x801083e3
8010633c:	e8 1f a3 ff ff       	call   80100660 <cprintf>
			count++;
80106341:	83 c4 10             	add    $0x10,%esp
		p = pq_dequeue();
80106344:	e8 d7 e2 ff ff       	call   80104620 <pq_dequeue>
	while (count < 3){
80106349:	83 fb 03             	cmp    $0x3,%ebx
8010634c:	75 d6                	jne    80106324 <sys_testpqdq+0x24>
	}
	
	
8010634e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106351:	c9                   	leave  
80106352:	c3                   	ret    

80106353 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106353:	1e                   	push   %ds
  pushl %es
80106354:	06                   	push   %es
  pushl %fs
80106355:	0f a0                	push   %fs
  pushl %gs
80106357:	0f a8                	push   %gs
  pushal
80106359:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010635a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010635e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106360:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106362:	54                   	push   %esp
  call trap
80106363:	e8 c8 00 00 00       	call   80106430 <trap>
  addl $4, %esp
80106368:	83 c4 04             	add    $0x4,%esp

8010636b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010636b:	61                   	popa   
  popl %gs
8010636c:	0f a9                	pop    %gs
  popl %fs
8010636e:	0f a1                	pop    %fs
  popl %es
80106370:	07                   	pop    %es
  popl %ds
80106371:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106372:	83 c4 08             	add    $0x8,%esp
  iret
80106375:	cf                   	iret   
80106376:	66 90                	xchg   %ax,%ax
80106378:	66 90                	xchg   %ax,%ax
8010637a:	66 90                	xchg   %ax,%ax
8010637c:	66 90                	xchg   %ax,%ax
8010637e:	66 90                	xchg   %ax,%ax

80106380 <tvinit>:
struct spinlock tickslock;
uint            ticks;

void
tvinit(void)
{
80106380:	55                   	push   %ebp
	int i;

	for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106381:	31 c0                	xor    %eax,%eax
{
80106383:	89 e5                	mov    %esp,%ebp
80106385:	83 ec 08             	sub    $0x8,%esp
80106388:	90                   	nop
80106389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80106390:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106397:	c7 04 c5 e2 da 12 80 	movl   $0x8e000008,-0x7fed251e(,%eax,8)
8010639e:	08 00 00 8e 
801063a2:	66 89 14 c5 e0 da 12 	mov    %dx,-0x7fed2520(,%eax,8)
801063a9:	80 
801063aa:	c1 ea 10             	shr    $0x10,%edx
801063ad:	66 89 14 c5 e6 da 12 	mov    %dx,-0x7fed251a(,%eax,8)
801063b4:	80 
801063b5:	83 c0 01             	add    $0x1,%eax
801063b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801063bd:	75 d1                	jne    80106390 <tvinit+0x10>
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801063bf:	a1 0c b1 10 80       	mov    0x8010b10c,%eax

	initlock(&tickslock, "time");
801063c4:	83 ec 08             	sub    $0x8,%esp
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801063c7:	c7 05 e2 dc 12 80 08 	movl   $0xef000008,0x8012dce2
801063ce:	00 00 ef 
	initlock(&tickslock, "time");
801063d1:	68 e7 83 10 80       	push   $0x801083e7
801063d6:	68 a0 da 12 80       	push   $0x8012daa0
	SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801063db:	66 a3 e0 dc 12 80    	mov    %ax,0x8012dce0
801063e1:	c1 e8 10             	shr    $0x10,%eax
801063e4:	66 a3 e6 dc 12 80    	mov    %ax,0x8012dce6
	initlock(&tickslock, "time");
801063ea:	e8 c1 e3 ff ff       	call   801047b0 <initlock>
}
801063ef:	83 c4 10             	add    $0x10,%esp
801063f2:	c9                   	leave  
801063f3:	c3                   	ret    
801063f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801063fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106400 <idtinit>:

void
idtinit(void)
{
80106400:	55                   	push   %ebp
	pd[0] = size - 1;
80106401:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106406:	89 e5                	mov    %esp,%ebp
80106408:	83 ec 10             	sub    $0x10,%esp
8010640b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
	pd[1] = (uint)p;
8010640f:	b8 e0 da 12 80       	mov    $0x8012dae0,%eax
80106414:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
	pd[2] = (uint)p >> 16;
80106418:	c1 e8 10             	shr    $0x10,%eax
8010641b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
	asm volatile("lidt (%0)" : : "r"(pd));
8010641f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106422:	0f 01 18             	lidtl  (%eax)
	lidt(idt, sizeof(idt));
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    
80106427:	89 f6                	mov    %esi,%esi
80106429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106430 <trap>:

// PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	57                   	push   %edi
80106434:	56                   	push   %esi
80106435:	53                   	push   %ebx
80106436:	83 ec 1c             	sub    $0x1c,%esp
80106439:	8b 7d 08             	mov    0x8(%ebp),%edi
	if (tf->trapno == T_SYSCALL) {
8010643c:	8b 47 30             	mov    0x30(%edi),%eax
8010643f:	83 f8 40             	cmp    $0x40,%eax
80106442:	0f 84 f0 00 00 00    	je     80106538 <trap+0x108>
		syscall();
		if (myproc()->killed) exit();
		return;
	}

	switch (tf->trapno) {
80106448:	83 e8 20             	sub    $0x20,%eax
8010644b:	83 f8 1f             	cmp    $0x1f,%eax
8010644e:	77 10                	ja     80106460 <trap+0x30>
80106450:	ff 24 85 90 84 10 80 	jmp    *-0x7fef7b70(,%eax,4)
80106457:	89 f6                	mov    %esi,%esi
80106459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		lapiceoi();
		break;

	// PAGEBREAK: 13
	default:
		if (myproc() == 0 || (tf->cs & 3) == 0) {
80106460:	e8 7b d4 ff ff       	call   801038e0 <myproc>
80106465:	85 c0                	test   %eax,%eax
80106467:	8b 5f 38             	mov    0x38(%edi),%ebx
8010646a:	0f 84 14 02 00 00    	je     80106684 <trap+0x254>
80106470:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106474:	0f 84 0a 02 00 00    	je     80106684 <trap+0x254>

static inline uint
rcr2(void)
{
	uint val;
	asm volatile("movl %%cr2,%0" : "=r"(val));
8010647a:	0f 20 d1             	mov    %cr2,%ecx
8010647d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno, cpuid(), tf->eip,
			        rcr2());
			panic("trap");
		}
		// In user space, assume process misbehaved.
		cprintf("pid %d %s: trap %d err %d on cpu %d "
80106480:	e8 3b d4 ff ff       	call   801038c0 <cpuid>
80106485:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106488:	8b 47 34             	mov    0x34(%edi),%eax
8010648b:	8b 77 30             	mov    0x30(%edi),%esi
8010648e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		        "eip 0x%x addr 0x%x--kill proc\n",
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
80106491:	e8 4a d4 ff ff       	call   801038e0 <myproc>
80106496:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106499:	e8 42 d4 ff ff       	call   801038e0 <myproc>
		cprintf("pid %d %s: trap %d err %d on cpu %d "
8010649e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801064a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801064a4:	51                   	push   %ecx
801064a5:	53                   	push   %ebx
801064a6:	52                   	push   %edx
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
801064a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
		cprintf("pid %d %s: trap %d err %d on cpu %d "
801064aa:	ff 75 e4             	pushl  -0x1c(%ebp)
801064ad:	56                   	push   %esi
		        myproc()->pid, myproc()->name, tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
801064ae:	83 c2 6c             	add    $0x6c,%edx
		cprintf("pid %d %s: trap %d err %d on cpu %d "
801064b1:	52                   	push   %edx
801064b2:	ff 70 10             	pushl  0x10(%eax)
801064b5:	68 4c 84 10 80       	push   $0x8010844c
801064ba:	e8 a1 a1 ff ff       	call   80100660 <cprintf>
		myproc()->killed = 1;
801064bf:	83 c4 20             	add    $0x20,%esp
801064c2:	e8 19 d4 ff ff       	call   801038e0 <myproc>
801064c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
	}

	// Force process exit if it has been killed and is in user space.
	// (If it is still executing in the kernel, let it keep running
	// until it gets to the regular system call return.)
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801064ce:	e8 0d d4 ff ff       	call   801038e0 <myproc>
801064d3:	85 c0                	test   %eax,%eax
801064d5:	74 1d                	je     801064f4 <trap+0xc4>
801064d7:	e8 04 d4 ff ff       	call   801038e0 <myproc>
801064dc:	8b 50 24             	mov    0x24(%eax),%edx
801064df:	85 d2                	test   %edx,%edx
801064e1:	74 11                	je     801064f4 <trap+0xc4>
801064e3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801064e7:	83 e0 03             	and    $0x3,%eax
801064ea:	66 83 f8 03          	cmp    $0x3,%ax
801064ee:	0f 84 4c 01 00 00    	je     80106640 <trap+0x210>

	// Force process to give up CPU on clock tick.
	// If interrupts were on while locks held, would need to check nlock.
	if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER) yield();
801064f4:	e8 e7 d3 ff ff       	call   801038e0 <myproc>
801064f9:	85 c0                	test   %eax,%eax
801064fb:	74 0b                	je     80106508 <trap+0xd8>
801064fd:	e8 de d3 ff ff       	call   801038e0 <myproc>
80106502:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106506:	74 68                	je     80106570 <trap+0x140>

	// Check if the process has been killed since we yielded
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80106508:	e8 d3 d3 ff ff       	call   801038e0 <myproc>
8010650d:	85 c0                	test   %eax,%eax
8010650f:	74 19                	je     8010652a <trap+0xfa>
80106511:	e8 ca d3 ff ff       	call   801038e0 <myproc>
80106516:	8b 40 24             	mov    0x24(%eax),%eax
80106519:	85 c0                	test   %eax,%eax
8010651b:	74 0d                	je     8010652a <trap+0xfa>
8010651d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106521:	83 e0 03             	and    $0x3,%eax
80106524:	66 83 f8 03          	cmp    $0x3,%ax
80106528:	74 37                	je     80106561 <trap+0x131>
}
8010652a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010652d:	5b                   	pop    %ebx
8010652e:	5e                   	pop    %esi
8010652f:	5f                   	pop    %edi
80106530:	5d                   	pop    %ebp
80106531:	c3                   	ret    
80106532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (myproc()->killed) exit();
80106538:	e8 a3 d3 ff ff       	call   801038e0 <myproc>
8010653d:	8b 58 24             	mov    0x24(%eax),%ebx
80106540:	85 db                	test   %ebx,%ebx
80106542:	0f 85 e8 00 00 00    	jne    80106630 <trap+0x200>
		myproc()->tf = tf;
80106548:	e8 93 d3 ff ff       	call   801038e0 <myproc>
8010654d:	89 78 18             	mov    %edi,0x18(%eax)
		syscall();
80106550:	e8 bb e8 ff ff       	call   80104e10 <syscall>
		if (myproc()->killed) exit();
80106555:	e8 86 d3 ff ff       	call   801038e0 <myproc>
8010655a:	8b 48 24             	mov    0x24(%eax),%ecx
8010655d:	85 c9                	test   %ecx,%ecx
8010655f:	74 c9                	je     8010652a <trap+0xfa>
}
80106561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106564:	5b                   	pop    %ebx
80106565:	5e                   	pop    %esi
80106566:	5f                   	pop    %edi
80106567:	5d                   	pop    %ebp
		if (myproc()->killed) exit();
80106568:	e9 93 da ff ff       	jmp    80104000 <exit>
8010656d:	8d 76 00             	lea    0x0(%esi),%esi
	if (myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER) yield();
80106570:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106574:	75 92                	jne    80106508 <trap+0xd8>
80106576:	e8 75 db ff ff       	call   801040f0 <yield>
8010657b:	eb 8b                	jmp    80106508 <trap+0xd8>
8010657d:	8d 76 00             	lea    0x0(%esi),%esi
		if (cpuid() == 0) {
80106580:	e8 3b d3 ff ff       	call   801038c0 <cpuid>
80106585:	85 c0                	test   %eax,%eax
80106587:	0f 84 c3 00 00 00    	je     80106650 <trap+0x220>
		lapiceoi();
8010658d:	e8 ce c1 ff ff       	call   80102760 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80106592:	e8 49 d3 ff ff       	call   801038e0 <myproc>
80106597:	85 c0                	test   %eax,%eax
80106599:	0f 85 38 ff ff ff    	jne    801064d7 <trap+0xa7>
8010659f:	e9 50 ff ff ff       	jmp    801064f4 <trap+0xc4>
801065a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		kbdintr();
801065a8:	e8 73 c0 ff ff       	call   80102620 <kbdintr>
		lapiceoi();
801065ad:	e8 ae c1 ff ff       	call   80102760 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801065b2:	e8 29 d3 ff ff       	call   801038e0 <myproc>
801065b7:	85 c0                	test   %eax,%eax
801065b9:	0f 85 18 ff ff ff    	jne    801064d7 <trap+0xa7>
801065bf:	e9 30 ff ff ff       	jmp    801064f4 <trap+0xc4>
801065c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		uartintr();
801065c8:	e8 53 02 00 00       	call   80106820 <uartintr>
		lapiceoi();
801065cd:	e8 8e c1 ff ff       	call   80102760 <lapiceoi>
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
801065d2:	e8 09 d3 ff ff       	call   801038e0 <myproc>
801065d7:	85 c0                	test   %eax,%eax
801065d9:	0f 85 f8 fe ff ff    	jne    801064d7 <trap+0xa7>
801065df:	e9 10 ff ff ff       	jmp    801064f4 <trap+0xc4>
801065e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		cprintf("cpu%d: spurious interrupt at %x:%x\n", cpuid(), tf->cs, tf->eip);
801065e8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801065ec:	8b 77 38             	mov    0x38(%edi),%esi
801065ef:	e8 cc d2 ff ff       	call   801038c0 <cpuid>
801065f4:	56                   	push   %esi
801065f5:	53                   	push   %ebx
801065f6:	50                   	push   %eax
801065f7:	68 f4 83 10 80       	push   $0x801083f4
801065fc:	e8 5f a0 ff ff       	call   80100660 <cprintf>
		lapiceoi();
80106601:	e8 5a c1 ff ff       	call   80102760 <lapiceoi>
		break;
80106606:	83 c4 10             	add    $0x10,%esp
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80106609:	e8 d2 d2 ff ff       	call   801038e0 <myproc>
8010660e:	85 c0                	test   %eax,%eax
80106610:	0f 85 c1 fe ff ff    	jne    801064d7 <trap+0xa7>
80106616:	e9 d9 fe ff ff       	jmp    801064f4 <trap+0xc4>
8010661b:	90                   	nop
8010661c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		ideintr();
80106620:	e8 6b ba ff ff       	call   80102090 <ideintr>
80106625:	e9 63 ff ff ff       	jmp    8010658d <trap+0x15d>
8010662a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (myproc()->killed) exit();
80106630:	e8 cb d9 ff ff       	call   80104000 <exit>
80106635:	e9 0e ff ff ff       	jmp    80106548 <trap+0x118>
8010663a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) exit();
80106640:	e8 bb d9 ff ff       	call   80104000 <exit>
80106645:	e9 aa fe ff ff       	jmp    801064f4 <trap+0xc4>
8010664a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			acquire(&tickslock);
80106650:	83 ec 0c             	sub    $0xc,%esp
80106653:	68 a0 da 12 80       	push   $0x8012daa0
80106658:	e8 43 e2 ff ff       	call   801048a0 <acquire>
			wakeup(&ticks);
8010665d:	c7 04 24 e0 e2 12 80 	movl   $0x8012e2e0,(%esp)
			ticks++;
80106664:	83 05 e0 e2 12 80 01 	addl   $0x1,0x8012e2e0
			wakeup(&ticks);
8010666b:	e8 20 dd ff ff       	call   80104390 <wakeup>
			release(&tickslock);
80106670:	c7 04 24 a0 da 12 80 	movl   $0x8012daa0,(%esp)
80106677:	e8 44 e3 ff ff       	call   801049c0 <release>
8010667c:	83 c4 10             	add    $0x10,%esp
8010667f:	e9 09 ff ff ff       	jmp    8010658d <trap+0x15d>
80106684:	0f 20 d6             	mov    %cr2,%esi
			cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n", tf->trapno, cpuid(), tf->eip,
80106687:	e8 34 d2 ff ff       	call   801038c0 <cpuid>
8010668c:	83 ec 0c             	sub    $0xc,%esp
8010668f:	56                   	push   %esi
80106690:	53                   	push   %ebx
80106691:	50                   	push   %eax
80106692:	ff 77 30             	pushl  0x30(%edi)
80106695:	68 18 84 10 80       	push   $0x80108418
8010669a:	e8 c1 9f ff ff       	call   80100660 <cprintf>
			panic("trap");
8010669f:	83 c4 14             	add    $0x14,%esp
801066a2:	68 ec 83 10 80       	push   $0x801083ec
801066a7:	e8 e4 9c ff ff       	call   80100390 <panic>
801066ac:	66 90                	xchg   %ax,%ax
801066ae:	66 90                	xchg   %ax,%ax

801066b0 <uartgetc>:
}

static int
uartgetc(void)
{
	if (!uart) return -1;
801066b0:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
{
801066b5:	55                   	push   %ebp
801066b6:	89 e5                	mov    %esp,%ebp
	if (!uart) return -1;
801066b8:	85 c0                	test   %eax,%eax
801066ba:	74 1c                	je     801066d8 <uartgetc+0x28>
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
801066bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066c1:	ec                   	in     (%dx),%al
	if (!(inb(COM1 + 5) & 0x01)) return -1;
801066c2:	a8 01                	test   $0x1,%al
801066c4:	74 12                	je     801066d8 <uartgetc+0x28>
801066c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066cb:	ec                   	in     (%dx),%al
	return inb(COM1 + 0);
801066cc:	0f b6 c0             	movzbl %al,%eax
}
801066cf:	5d                   	pop    %ebp
801066d0:	c3                   	ret    
801066d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	if (!uart) return -1;
801066d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066dd:	5d                   	pop    %ebp
801066de:	c3                   	ret    
801066df:	90                   	nop

801066e0 <uartputc.part.0>:
uartputc(int c)
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
801066e5:	53                   	push   %ebx
801066e6:	89 c7                	mov    %eax,%edi
801066e8:	bb 80 00 00 00       	mov    $0x80,%ebx
801066ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801066f2:	83 ec 0c             	sub    $0xc,%esp
801066f5:	eb 1b                	jmp    80106712 <uartputc.part.0+0x32>
801066f7:	89 f6                	mov    %esi,%esi
801066f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) microdelay(10);
80106700:	83 ec 0c             	sub    $0xc,%esp
80106703:	6a 0a                	push   $0xa
80106705:	e8 76 c0 ff ff       	call   80102780 <microdelay>
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	83 eb 01             	sub    $0x1,%ebx
80106710:	74 07                	je     80106719 <uartputc.part.0+0x39>
80106712:	89 f2                	mov    %esi,%edx
80106714:	ec                   	in     (%dx),%al
80106715:	a8 20                	test   $0x20,%al
80106717:	74 e7                	je     80106700 <uartputc.part.0+0x20>
	asm volatile("out %0,%1" : : "a"(data), "d"(port));
80106719:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010671e:	89 f8                	mov    %edi,%eax
80106720:	ee                   	out    %al,(%dx)
}
80106721:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106724:	5b                   	pop    %ebx
80106725:	5e                   	pop    %esi
80106726:	5f                   	pop    %edi
80106727:	5d                   	pop    %ebp
80106728:	c3                   	ret    
80106729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106730 <uartinit>:
{
80106730:	55                   	push   %ebp
80106731:	31 c9                	xor    %ecx,%ecx
80106733:	89 c8                	mov    %ecx,%eax
80106735:	89 e5                	mov    %esp,%ebp
80106737:	57                   	push   %edi
80106738:	56                   	push   %esi
80106739:	53                   	push   %ebx
8010673a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010673f:	89 da                	mov    %ebx,%edx
80106741:	83 ec 0c             	sub    $0xc,%esp
80106744:	ee                   	out    %al,(%dx)
80106745:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010674a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010674f:	89 fa                	mov    %edi,%edx
80106751:	ee                   	out    %al,(%dx)
80106752:	b8 0c 00 00 00       	mov    $0xc,%eax
80106757:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010675c:	ee                   	out    %al,(%dx)
8010675d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106762:	89 c8                	mov    %ecx,%eax
80106764:	89 f2                	mov    %esi,%edx
80106766:	ee                   	out    %al,(%dx)
80106767:	b8 03 00 00 00       	mov    $0x3,%eax
8010676c:	89 fa                	mov    %edi,%edx
8010676e:	ee                   	out    %al,(%dx)
8010676f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106774:	89 c8                	mov    %ecx,%eax
80106776:	ee                   	out    %al,(%dx)
80106777:	b8 01 00 00 00       	mov    $0x1,%eax
8010677c:	89 f2                	mov    %esi,%edx
8010677e:	ee                   	out    %al,(%dx)
	asm volatile("in %1,%0" : "=a"(data) : "d"(port));
8010677f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106784:	ec                   	in     (%dx),%al
	if (inb(COM1 + 5) == 0xFF) return;
80106785:	3c ff                	cmp    $0xff,%al
80106787:	74 5a                	je     801067e3 <uartinit+0xb3>
	uart = 1;
80106789:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106790:	00 00 00 
80106793:	89 da                	mov    %ebx,%edx
80106795:	ec                   	in     (%dx),%al
80106796:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010679b:	ec                   	in     (%dx),%al
	ioapicenable(IRQ_COM1, 0);
8010679c:	83 ec 08             	sub    $0x8,%esp
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
8010679f:	bb 10 85 10 80       	mov    $0x80108510,%ebx
	ioapicenable(IRQ_COM1, 0);
801067a4:	6a 00                	push   $0x0
801067a6:	6a 04                	push   $0x4
801067a8:	e8 33 bb ff ff       	call   801022e0 <ioapicenable>
801067ad:	83 c4 10             	add    $0x10,%esp
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
801067b0:	b8 78 00 00 00       	mov    $0x78,%eax
801067b5:	eb 13                	jmp    801067ca <uartinit+0x9a>
801067b7:	89 f6                	mov    %esi,%esi
801067b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801067c0:	83 c3 01             	add    $0x1,%ebx
801067c3:	0f be 03             	movsbl (%ebx),%eax
801067c6:	84 c0                	test   %al,%al
801067c8:	74 19                	je     801067e3 <uartinit+0xb3>
	if (!uart) return;
801067ca:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
801067d0:	85 d2                	test   %edx,%edx
801067d2:	74 ec                	je     801067c0 <uartinit+0x90>
	for (p = "xv6...\n"; *p; p++) uartputc(*p);
801067d4:	83 c3 01             	add    $0x1,%ebx
801067d7:	e8 04 ff ff ff       	call   801066e0 <uartputc.part.0>
801067dc:	0f be 03             	movsbl (%ebx),%eax
801067df:	84 c0                	test   %al,%al
801067e1:	75 e7                	jne    801067ca <uartinit+0x9a>
}
801067e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067e6:	5b                   	pop    %ebx
801067e7:	5e                   	pop    %esi
801067e8:	5f                   	pop    %edi
801067e9:	5d                   	pop    %ebp
801067ea:	c3                   	ret    
801067eb:	90                   	nop
801067ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801067f0 <uartputc>:
	if (!uart) return;
801067f0:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
801067f6:	55                   	push   %ebp
801067f7:	89 e5                	mov    %esp,%ebp
	if (!uart) return;
801067f9:	85 d2                	test   %edx,%edx
{
801067fb:	8b 45 08             	mov    0x8(%ebp),%eax
	if (!uart) return;
801067fe:	74 10                	je     80106810 <uartputc+0x20>
}
80106800:	5d                   	pop    %ebp
80106801:	e9 da fe ff ff       	jmp    801066e0 <uartputc.part.0>
80106806:	8d 76 00             	lea    0x0(%esi),%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106810:	5d                   	pop    %ebp
80106811:	c3                   	ret    
80106812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106820 <uartintr>:

void
uartintr(void)
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	83 ec 14             	sub    $0x14,%esp
	consoleintr(uartgetc);
80106826:	68 b0 66 10 80       	push   $0x801066b0
8010682b:	e8 e0 9f ff ff       	call   80100810 <consoleintr>
}
80106830:	83 c4 10             	add    $0x10,%esp
80106833:	c9                   	leave  
80106834:	c3                   	ret    

80106835 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $0
80106837:	6a 00                	push   $0x0
  jmp alltraps
80106839:	e9 15 fb ff ff       	jmp    80106353 <alltraps>

8010683e <vector1>:
.globl vector1
vector1:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $1
80106840:	6a 01                	push   $0x1
  jmp alltraps
80106842:	e9 0c fb ff ff       	jmp    80106353 <alltraps>

80106847 <vector2>:
.globl vector2
vector2:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $2
80106849:	6a 02                	push   $0x2
  jmp alltraps
8010684b:	e9 03 fb ff ff       	jmp    80106353 <alltraps>

80106850 <vector3>:
.globl vector3
vector3:
  pushl $0
80106850:	6a 00                	push   $0x0
  pushl $3
80106852:	6a 03                	push   $0x3
  jmp alltraps
80106854:	e9 fa fa ff ff       	jmp    80106353 <alltraps>

80106859 <vector4>:
.globl vector4
vector4:
  pushl $0
80106859:	6a 00                	push   $0x0
  pushl $4
8010685b:	6a 04                	push   $0x4
  jmp alltraps
8010685d:	e9 f1 fa ff ff       	jmp    80106353 <alltraps>

80106862 <vector5>:
.globl vector5
vector5:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $5
80106864:	6a 05                	push   $0x5
  jmp alltraps
80106866:	e9 e8 fa ff ff       	jmp    80106353 <alltraps>

8010686b <vector6>:
.globl vector6
vector6:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $6
8010686d:	6a 06                	push   $0x6
  jmp alltraps
8010686f:	e9 df fa ff ff       	jmp    80106353 <alltraps>

80106874 <vector7>:
.globl vector7
vector7:
  pushl $0
80106874:	6a 00                	push   $0x0
  pushl $7
80106876:	6a 07                	push   $0x7
  jmp alltraps
80106878:	e9 d6 fa ff ff       	jmp    80106353 <alltraps>

8010687d <vector8>:
.globl vector8
vector8:
  pushl $8
8010687d:	6a 08                	push   $0x8
  jmp alltraps
8010687f:	e9 cf fa ff ff       	jmp    80106353 <alltraps>

80106884 <vector9>:
.globl vector9
vector9:
  pushl $0
80106884:	6a 00                	push   $0x0
  pushl $9
80106886:	6a 09                	push   $0x9
  jmp alltraps
80106888:	e9 c6 fa ff ff       	jmp    80106353 <alltraps>

8010688d <vector10>:
.globl vector10
vector10:
  pushl $10
8010688d:	6a 0a                	push   $0xa
  jmp alltraps
8010688f:	e9 bf fa ff ff       	jmp    80106353 <alltraps>

80106894 <vector11>:
.globl vector11
vector11:
  pushl $11
80106894:	6a 0b                	push   $0xb
  jmp alltraps
80106896:	e9 b8 fa ff ff       	jmp    80106353 <alltraps>

8010689b <vector12>:
.globl vector12
vector12:
  pushl $12
8010689b:	6a 0c                	push   $0xc
  jmp alltraps
8010689d:	e9 b1 fa ff ff       	jmp    80106353 <alltraps>

801068a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801068a2:	6a 0d                	push   $0xd
  jmp alltraps
801068a4:	e9 aa fa ff ff       	jmp    80106353 <alltraps>

801068a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801068a9:	6a 0e                	push   $0xe
  jmp alltraps
801068ab:	e9 a3 fa ff ff       	jmp    80106353 <alltraps>

801068b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $15
801068b2:	6a 0f                	push   $0xf
  jmp alltraps
801068b4:	e9 9a fa ff ff       	jmp    80106353 <alltraps>

801068b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $16
801068bb:	6a 10                	push   $0x10
  jmp alltraps
801068bd:	e9 91 fa ff ff       	jmp    80106353 <alltraps>

801068c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801068c2:	6a 11                	push   $0x11
  jmp alltraps
801068c4:	e9 8a fa ff ff       	jmp    80106353 <alltraps>

801068c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $18
801068cb:	6a 12                	push   $0x12
  jmp alltraps
801068cd:	e9 81 fa ff ff       	jmp    80106353 <alltraps>

801068d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $19
801068d4:	6a 13                	push   $0x13
  jmp alltraps
801068d6:	e9 78 fa ff ff       	jmp    80106353 <alltraps>

801068db <vector20>:
.globl vector20
vector20:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $20
801068dd:	6a 14                	push   $0x14
  jmp alltraps
801068df:	e9 6f fa ff ff       	jmp    80106353 <alltraps>

801068e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $21
801068e6:	6a 15                	push   $0x15
  jmp alltraps
801068e8:	e9 66 fa ff ff       	jmp    80106353 <alltraps>

801068ed <vector22>:
.globl vector22
vector22:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $22
801068ef:	6a 16                	push   $0x16
  jmp alltraps
801068f1:	e9 5d fa ff ff       	jmp    80106353 <alltraps>

801068f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $23
801068f8:	6a 17                	push   $0x17
  jmp alltraps
801068fa:	e9 54 fa ff ff       	jmp    80106353 <alltraps>

801068ff <vector24>:
.globl vector24
vector24:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $24
80106901:	6a 18                	push   $0x18
  jmp alltraps
80106903:	e9 4b fa ff ff       	jmp    80106353 <alltraps>

80106908 <vector25>:
.globl vector25
vector25:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $25
8010690a:	6a 19                	push   $0x19
  jmp alltraps
8010690c:	e9 42 fa ff ff       	jmp    80106353 <alltraps>

80106911 <vector26>:
.globl vector26
vector26:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $26
80106913:	6a 1a                	push   $0x1a
  jmp alltraps
80106915:	e9 39 fa ff ff       	jmp    80106353 <alltraps>

8010691a <vector27>:
.globl vector27
vector27:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $27
8010691c:	6a 1b                	push   $0x1b
  jmp alltraps
8010691e:	e9 30 fa ff ff       	jmp    80106353 <alltraps>

80106923 <vector28>:
.globl vector28
vector28:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $28
80106925:	6a 1c                	push   $0x1c
  jmp alltraps
80106927:	e9 27 fa ff ff       	jmp    80106353 <alltraps>

8010692c <vector29>:
.globl vector29
vector29:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $29
8010692e:	6a 1d                	push   $0x1d
  jmp alltraps
80106930:	e9 1e fa ff ff       	jmp    80106353 <alltraps>

80106935 <vector30>:
.globl vector30
vector30:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $30
80106937:	6a 1e                	push   $0x1e
  jmp alltraps
80106939:	e9 15 fa ff ff       	jmp    80106353 <alltraps>

8010693e <vector31>:
.globl vector31
vector31:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $31
80106940:	6a 1f                	push   $0x1f
  jmp alltraps
80106942:	e9 0c fa ff ff       	jmp    80106353 <alltraps>

80106947 <vector32>:
.globl vector32
vector32:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $32
80106949:	6a 20                	push   $0x20
  jmp alltraps
8010694b:	e9 03 fa ff ff       	jmp    80106353 <alltraps>

80106950 <vector33>:
.globl vector33
vector33:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $33
80106952:	6a 21                	push   $0x21
  jmp alltraps
80106954:	e9 fa f9 ff ff       	jmp    80106353 <alltraps>

80106959 <vector34>:
.globl vector34
vector34:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $34
8010695b:	6a 22                	push   $0x22
  jmp alltraps
8010695d:	e9 f1 f9 ff ff       	jmp    80106353 <alltraps>

80106962 <vector35>:
.globl vector35
vector35:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $35
80106964:	6a 23                	push   $0x23
  jmp alltraps
80106966:	e9 e8 f9 ff ff       	jmp    80106353 <alltraps>

8010696b <vector36>:
.globl vector36
vector36:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $36
8010696d:	6a 24                	push   $0x24
  jmp alltraps
8010696f:	e9 df f9 ff ff       	jmp    80106353 <alltraps>

80106974 <vector37>:
.globl vector37
vector37:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $37
80106976:	6a 25                	push   $0x25
  jmp alltraps
80106978:	e9 d6 f9 ff ff       	jmp    80106353 <alltraps>

8010697d <vector38>:
.globl vector38
vector38:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $38
8010697f:	6a 26                	push   $0x26
  jmp alltraps
80106981:	e9 cd f9 ff ff       	jmp    80106353 <alltraps>

80106986 <vector39>:
.globl vector39
vector39:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $39
80106988:	6a 27                	push   $0x27
  jmp alltraps
8010698a:	e9 c4 f9 ff ff       	jmp    80106353 <alltraps>

8010698f <vector40>:
.globl vector40
vector40:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $40
80106991:	6a 28                	push   $0x28
  jmp alltraps
80106993:	e9 bb f9 ff ff       	jmp    80106353 <alltraps>

80106998 <vector41>:
.globl vector41
vector41:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $41
8010699a:	6a 29                	push   $0x29
  jmp alltraps
8010699c:	e9 b2 f9 ff ff       	jmp    80106353 <alltraps>

801069a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $42
801069a3:	6a 2a                	push   $0x2a
  jmp alltraps
801069a5:	e9 a9 f9 ff ff       	jmp    80106353 <alltraps>

801069aa <vector43>:
.globl vector43
vector43:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $43
801069ac:	6a 2b                	push   $0x2b
  jmp alltraps
801069ae:	e9 a0 f9 ff ff       	jmp    80106353 <alltraps>

801069b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $44
801069b5:	6a 2c                	push   $0x2c
  jmp alltraps
801069b7:	e9 97 f9 ff ff       	jmp    80106353 <alltraps>

801069bc <vector45>:
.globl vector45
vector45:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $45
801069be:	6a 2d                	push   $0x2d
  jmp alltraps
801069c0:	e9 8e f9 ff ff       	jmp    80106353 <alltraps>

801069c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $46
801069c7:	6a 2e                	push   $0x2e
  jmp alltraps
801069c9:	e9 85 f9 ff ff       	jmp    80106353 <alltraps>

801069ce <vector47>:
.globl vector47
vector47:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $47
801069d0:	6a 2f                	push   $0x2f
  jmp alltraps
801069d2:	e9 7c f9 ff ff       	jmp    80106353 <alltraps>

801069d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $48
801069d9:	6a 30                	push   $0x30
  jmp alltraps
801069db:	e9 73 f9 ff ff       	jmp    80106353 <alltraps>

801069e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $49
801069e2:	6a 31                	push   $0x31
  jmp alltraps
801069e4:	e9 6a f9 ff ff       	jmp    80106353 <alltraps>

801069e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $50
801069eb:	6a 32                	push   $0x32
  jmp alltraps
801069ed:	e9 61 f9 ff ff       	jmp    80106353 <alltraps>

801069f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $51
801069f4:	6a 33                	push   $0x33
  jmp alltraps
801069f6:	e9 58 f9 ff ff       	jmp    80106353 <alltraps>

801069fb <vector52>:
.globl vector52
vector52:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $52
801069fd:	6a 34                	push   $0x34
  jmp alltraps
801069ff:	e9 4f f9 ff ff       	jmp    80106353 <alltraps>

80106a04 <vector53>:
.globl vector53
vector53:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $53
80106a06:	6a 35                	push   $0x35
  jmp alltraps
80106a08:	e9 46 f9 ff ff       	jmp    80106353 <alltraps>

80106a0d <vector54>:
.globl vector54
vector54:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $54
80106a0f:	6a 36                	push   $0x36
  jmp alltraps
80106a11:	e9 3d f9 ff ff       	jmp    80106353 <alltraps>

80106a16 <vector55>:
.globl vector55
vector55:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $55
80106a18:	6a 37                	push   $0x37
  jmp alltraps
80106a1a:	e9 34 f9 ff ff       	jmp    80106353 <alltraps>

80106a1f <vector56>:
.globl vector56
vector56:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $56
80106a21:	6a 38                	push   $0x38
  jmp alltraps
80106a23:	e9 2b f9 ff ff       	jmp    80106353 <alltraps>

80106a28 <vector57>:
.globl vector57
vector57:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $57
80106a2a:	6a 39                	push   $0x39
  jmp alltraps
80106a2c:	e9 22 f9 ff ff       	jmp    80106353 <alltraps>

80106a31 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $58
80106a33:	6a 3a                	push   $0x3a
  jmp alltraps
80106a35:	e9 19 f9 ff ff       	jmp    80106353 <alltraps>

80106a3a <vector59>:
.globl vector59
vector59:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $59
80106a3c:	6a 3b                	push   $0x3b
  jmp alltraps
80106a3e:	e9 10 f9 ff ff       	jmp    80106353 <alltraps>

80106a43 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $60
80106a45:	6a 3c                	push   $0x3c
  jmp alltraps
80106a47:	e9 07 f9 ff ff       	jmp    80106353 <alltraps>

80106a4c <vector61>:
.globl vector61
vector61:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $61
80106a4e:	6a 3d                	push   $0x3d
  jmp alltraps
80106a50:	e9 fe f8 ff ff       	jmp    80106353 <alltraps>

80106a55 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $62
80106a57:	6a 3e                	push   $0x3e
  jmp alltraps
80106a59:	e9 f5 f8 ff ff       	jmp    80106353 <alltraps>

80106a5e <vector63>:
.globl vector63
vector63:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $63
80106a60:	6a 3f                	push   $0x3f
  jmp alltraps
80106a62:	e9 ec f8 ff ff       	jmp    80106353 <alltraps>

80106a67 <vector64>:
.globl vector64
vector64:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $64
80106a69:	6a 40                	push   $0x40
  jmp alltraps
80106a6b:	e9 e3 f8 ff ff       	jmp    80106353 <alltraps>

80106a70 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $65
80106a72:	6a 41                	push   $0x41
  jmp alltraps
80106a74:	e9 da f8 ff ff       	jmp    80106353 <alltraps>

80106a79 <vector66>:
.globl vector66
vector66:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $66
80106a7b:	6a 42                	push   $0x42
  jmp alltraps
80106a7d:	e9 d1 f8 ff ff       	jmp    80106353 <alltraps>

80106a82 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $67
80106a84:	6a 43                	push   $0x43
  jmp alltraps
80106a86:	e9 c8 f8 ff ff       	jmp    80106353 <alltraps>

80106a8b <vector68>:
.globl vector68
vector68:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $68
80106a8d:	6a 44                	push   $0x44
  jmp alltraps
80106a8f:	e9 bf f8 ff ff       	jmp    80106353 <alltraps>

80106a94 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $69
80106a96:	6a 45                	push   $0x45
  jmp alltraps
80106a98:	e9 b6 f8 ff ff       	jmp    80106353 <alltraps>

80106a9d <vector70>:
.globl vector70
vector70:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $70
80106a9f:	6a 46                	push   $0x46
  jmp alltraps
80106aa1:	e9 ad f8 ff ff       	jmp    80106353 <alltraps>

80106aa6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $71
80106aa8:	6a 47                	push   $0x47
  jmp alltraps
80106aaa:	e9 a4 f8 ff ff       	jmp    80106353 <alltraps>

80106aaf <vector72>:
.globl vector72
vector72:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $72
80106ab1:	6a 48                	push   $0x48
  jmp alltraps
80106ab3:	e9 9b f8 ff ff       	jmp    80106353 <alltraps>

80106ab8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $73
80106aba:	6a 49                	push   $0x49
  jmp alltraps
80106abc:	e9 92 f8 ff ff       	jmp    80106353 <alltraps>

80106ac1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $74
80106ac3:	6a 4a                	push   $0x4a
  jmp alltraps
80106ac5:	e9 89 f8 ff ff       	jmp    80106353 <alltraps>

80106aca <vector75>:
.globl vector75
vector75:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $75
80106acc:	6a 4b                	push   $0x4b
  jmp alltraps
80106ace:	e9 80 f8 ff ff       	jmp    80106353 <alltraps>

80106ad3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $76
80106ad5:	6a 4c                	push   $0x4c
  jmp alltraps
80106ad7:	e9 77 f8 ff ff       	jmp    80106353 <alltraps>

80106adc <vector77>:
.globl vector77
vector77:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $77
80106ade:	6a 4d                	push   $0x4d
  jmp alltraps
80106ae0:	e9 6e f8 ff ff       	jmp    80106353 <alltraps>

80106ae5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $78
80106ae7:	6a 4e                	push   $0x4e
  jmp alltraps
80106ae9:	e9 65 f8 ff ff       	jmp    80106353 <alltraps>

80106aee <vector79>:
.globl vector79
vector79:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $79
80106af0:	6a 4f                	push   $0x4f
  jmp alltraps
80106af2:	e9 5c f8 ff ff       	jmp    80106353 <alltraps>

80106af7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $80
80106af9:	6a 50                	push   $0x50
  jmp alltraps
80106afb:	e9 53 f8 ff ff       	jmp    80106353 <alltraps>

80106b00 <vector81>:
.globl vector81
vector81:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $81
80106b02:	6a 51                	push   $0x51
  jmp alltraps
80106b04:	e9 4a f8 ff ff       	jmp    80106353 <alltraps>

80106b09 <vector82>:
.globl vector82
vector82:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $82
80106b0b:	6a 52                	push   $0x52
  jmp alltraps
80106b0d:	e9 41 f8 ff ff       	jmp    80106353 <alltraps>

80106b12 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $83
80106b14:	6a 53                	push   $0x53
  jmp alltraps
80106b16:	e9 38 f8 ff ff       	jmp    80106353 <alltraps>

80106b1b <vector84>:
.globl vector84
vector84:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $84
80106b1d:	6a 54                	push   $0x54
  jmp alltraps
80106b1f:	e9 2f f8 ff ff       	jmp    80106353 <alltraps>

80106b24 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $85
80106b26:	6a 55                	push   $0x55
  jmp alltraps
80106b28:	e9 26 f8 ff ff       	jmp    80106353 <alltraps>

80106b2d <vector86>:
.globl vector86
vector86:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $86
80106b2f:	6a 56                	push   $0x56
  jmp alltraps
80106b31:	e9 1d f8 ff ff       	jmp    80106353 <alltraps>

80106b36 <vector87>:
.globl vector87
vector87:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $87
80106b38:	6a 57                	push   $0x57
  jmp alltraps
80106b3a:	e9 14 f8 ff ff       	jmp    80106353 <alltraps>

80106b3f <vector88>:
.globl vector88
vector88:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $88
80106b41:	6a 58                	push   $0x58
  jmp alltraps
80106b43:	e9 0b f8 ff ff       	jmp    80106353 <alltraps>

80106b48 <vector89>:
.globl vector89
vector89:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $89
80106b4a:	6a 59                	push   $0x59
  jmp alltraps
80106b4c:	e9 02 f8 ff ff       	jmp    80106353 <alltraps>

80106b51 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $90
80106b53:	6a 5a                	push   $0x5a
  jmp alltraps
80106b55:	e9 f9 f7 ff ff       	jmp    80106353 <alltraps>

80106b5a <vector91>:
.globl vector91
vector91:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $91
80106b5c:	6a 5b                	push   $0x5b
  jmp alltraps
80106b5e:	e9 f0 f7 ff ff       	jmp    80106353 <alltraps>

80106b63 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $92
80106b65:	6a 5c                	push   $0x5c
  jmp alltraps
80106b67:	e9 e7 f7 ff ff       	jmp    80106353 <alltraps>

80106b6c <vector93>:
.globl vector93
vector93:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $93
80106b6e:	6a 5d                	push   $0x5d
  jmp alltraps
80106b70:	e9 de f7 ff ff       	jmp    80106353 <alltraps>

80106b75 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $94
80106b77:	6a 5e                	push   $0x5e
  jmp alltraps
80106b79:	e9 d5 f7 ff ff       	jmp    80106353 <alltraps>

80106b7e <vector95>:
.globl vector95
vector95:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $95
80106b80:	6a 5f                	push   $0x5f
  jmp alltraps
80106b82:	e9 cc f7 ff ff       	jmp    80106353 <alltraps>

80106b87 <vector96>:
.globl vector96
vector96:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $96
80106b89:	6a 60                	push   $0x60
  jmp alltraps
80106b8b:	e9 c3 f7 ff ff       	jmp    80106353 <alltraps>

80106b90 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $97
80106b92:	6a 61                	push   $0x61
  jmp alltraps
80106b94:	e9 ba f7 ff ff       	jmp    80106353 <alltraps>

80106b99 <vector98>:
.globl vector98
vector98:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $98
80106b9b:	6a 62                	push   $0x62
  jmp alltraps
80106b9d:	e9 b1 f7 ff ff       	jmp    80106353 <alltraps>

80106ba2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $99
80106ba4:	6a 63                	push   $0x63
  jmp alltraps
80106ba6:	e9 a8 f7 ff ff       	jmp    80106353 <alltraps>

80106bab <vector100>:
.globl vector100
vector100:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $100
80106bad:	6a 64                	push   $0x64
  jmp alltraps
80106baf:	e9 9f f7 ff ff       	jmp    80106353 <alltraps>

80106bb4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $101
80106bb6:	6a 65                	push   $0x65
  jmp alltraps
80106bb8:	e9 96 f7 ff ff       	jmp    80106353 <alltraps>

80106bbd <vector102>:
.globl vector102
vector102:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $102
80106bbf:	6a 66                	push   $0x66
  jmp alltraps
80106bc1:	e9 8d f7 ff ff       	jmp    80106353 <alltraps>

80106bc6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $103
80106bc8:	6a 67                	push   $0x67
  jmp alltraps
80106bca:	e9 84 f7 ff ff       	jmp    80106353 <alltraps>

80106bcf <vector104>:
.globl vector104
vector104:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $104
80106bd1:	6a 68                	push   $0x68
  jmp alltraps
80106bd3:	e9 7b f7 ff ff       	jmp    80106353 <alltraps>

80106bd8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $105
80106bda:	6a 69                	push   $0x69
  jmp alltraps
80106bdc:	e9 72 f7 ff ff       	jmp    80106353 <alltraps>

80106be1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $106
80106be3:	6a 6a                	push   $0x6a
  jmp alltraps
80106be5:	e9 69 f7 ff ff       	jmp    80106353 <alltraps>

80106bea <vector107>:
.globl vector107
vector107:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $107
80106bec:	6a 6b                	push   $0x6b
  jmp alltraps
80106bee:	e9 60 f7 ff ff       	jmp    80106353 <alltraps>

80106bf3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $108
80106bf5:	6a 6c                	push   $0x6c
  jmp alltraps
80106bf7:	e9 57 f7 ff ff       	jmp    80106353 <alltraps>

80106bfc <vector109>:
.globl vector109
vector109:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $109
80106bfe:	6a 6d                	push   $0x6d
  jmp alltraps
80106c00:	e9 4e f7 ff ff       	jmp    80106353 <alltraps>

80106c05 <vector110>:
.globl vector110
vector110:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $110
80106c07:	6a 6e                	push   $0x6e
  jmp alltraps
80106c09:	e9 45 f7 ff ff       	jmp    80106353 <alltraps>

80106c0e <vector111>:
.globl vector111
vector111:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $111
80106c10:	6a 6f                	push   $0x6f
  jmp alltraps
80106c12:	e9 3c f7 ff ff       	jmp    80106353 <alltraps>

80106c17 <vector112>:
.globl vector112
vector112:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $112
80106c19:	6a 70                	push   $0x70
  jmp alltraps
80106c1b:	e9 33 f7 ff ff       	jmp    80106353 <alltraps>

80106c20 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $113
80106c22:	6a 71                	push   $0x71
  jmp alltraps
80106c24:	e9 2a f7 ff ff       	jmp    80106353 <alltraps>

80106c29 <vector114>:
.globl vector114
vector114:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $114
80106c2b:	6a 72                	push   $0x72
  jmp alltraps
80106c2d:	e9 21 f7 ff ff       	jmp    80106353 <alltraps>

80106c32 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $115
80106c34:	6a 73                	push   $0x73
  jmp alltraps
80106c36:	e9 18 f7 ff ff       	jmp    80106353 <alltraps>

80106c3b <vector116>:
.globl vector116
vector116:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $116
80106c3d:	6a 74                	push   $0x74
  jmp alltraps
80106c3f:	e9 0f f7 ff ff       	jmp    80106353 <alltraps>

80106c44 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $117
80106c46:	6a 75                	push   $0x75
  jmp alltraps
80106c48:	e9 06 f7 ff ff       	jmp    80106353 <alltraps>

80106c4d <vector118>:
.globl vector118
vector118:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $118
80106c4f:	6a 76                	push   $0x76
  jmp alltraps
80106c51:	e9 fd f6 ff ff       	jmp    80106353 <alltraps>

80106c56 <vector119>:
.globl vector119
vector119:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $119
80106c58:	6a 77                	push   $0x77
  jmp alltraps
80106c5a:	e9 f4 f6 ff ff       	jmp    80106353 <alltraps>

80106c5f <vector120>:
.globl vector120
vector120:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $120
80106c61:	6a 78                	push   $0x78
  jmp alltraps
80106c63:	e9 eb f6 ff ff       	jmp    80106353 <alltraps>

80106c68 <vector121>:
.globl vector121
vector121:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $121
80106c6a:	6a 79                	push   $0x79
  jmp alltraps
80106c6c:	e9 e2 f6 ff ff       	jmp    80106353 <alltraps>

80106c71 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $122
80106c73:	6a 7a                	push   $0x7a
  jmp alltraps
80106c75:	e9 d9 f6 ff ff       	jmp    80106353 <alltraps>

80106c7a <vector123>:
.globl vector123
vector123:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $123
80106c7c:	6a 7b                	push   $0x7b
  jmp alltraps
80106c7e:	e9 d0 f6 ff ff       	jmp    80106353 <alltraps>

80106c83 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $124
80106c85:	6a 7c                	push   $0x7c
  jmp alltraps
80106c87:	e9 c7 f6 ff ff       	jmp    80106353 <alltraps>

80106c8c <vector125>:
.globl vector125
vector125:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $125
80106c8e:	6a 7d                	push   $0x7d
  jmp alltraps
80106c90:	e9 be f6 ff ff       	jmp    80106353 <alltraps>

80106c95 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $126
80106c97:	6a 7e                	push   $0x7e
  jmp alltraps
80106c99:	e9 b5 f6 ff ff       	jmp    80106353 <alltraps>

80106c9e <vector127>:
.globl vector127
vector127:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $127
80106ca0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ca2:	e9 ac f6 ff ff       	jmp    80106353 <alltraps>

80106ca7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $128
80106ca9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106cae:	e9 a0 f6 ff ff       	jmp    80106353 <alltraps>

80106cb3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $129
80106cb5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106cba:	e9 94 f6 ff ff       	jmp    80106353 <alltraps>

80106cbf <vector130>:
.globl vector130
vector130:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $130
80106cc1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106cc6:	e9 88 f6 ff ff       	jmp    80106353 <alltraps>

80106ccb <vector131>:
.globl vector131
vector131:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $131
80106ccd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106cd2:	e9 7c f6 ff ff       	jmp    80106353 <alltraps>

80106cd7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $132
80106cd9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106cde:	e9 70 f6 ff ff       	jmp    80106353 <alltraps>

80106ce3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $133
80106ce5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106cea:	e9 64 f6 ff ff       	jmp    80106353 <alltraps>

80106cef <vector134>:
.globl vector134
vector134:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $134
80106cf1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106cf6:	e9 58 f6 ff ff       	jmp    80106353 <alltraps>

80106cfb <vector135>:
.globl vector135
vector135:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $135
80106cfd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106d02:	e9 4c f6 ff ff       	jmp    80106353 <alltraps>

80106d07 <vector136>:
.globl vector136
vector136:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $136
80106d09:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d0e:	e9 40 f6 ff ff       	jmp    80106353 <alltraps>

80106d13 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $137
80106d15:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d1a:	e9 34 f6 ff ff       	jmp    80106353 <alltraps>

80106d1f <vector138>:
.globl vector138
vector138:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $138
80106d21:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d26:	e9 28 f6 ff ff       	jmp    80106353 <alltraps>

80106d2b <vector139>:
.globl vector139
vector139:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $139
80106d2d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d32:	e9 1c f6 ff ff       	jmp    80106353 <alltraps>

80106d37 <vector140>:
.globl vector140
vector140:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $140
80106d39:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d3e:	e9 10 f6 ff ff       	jmp    80106353 <alltraps>

80106d43 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $141
80106d45:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d4a:	e9 04 f6 ff ff       	jmp    80106353 <alltraps>

80106d4f <vector142>:
.globl vector142
vector142:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $142
80106d51:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d56:	e9 f8 f5 ff ff       	jmp    80106353 <alltraps>

80106d5b <vector143>:
.globl vector143
vector143:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $143
80106d5d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d62:	e9 ec f5 ff ff       	jmp    80106353 <alltraps>

80106d67 <vector144>:
.globl vector144
vector144:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $144
80106d69:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d6e:	e9 e0 f5 ff ff       	jmp    80106353 <alltraps>

80106d73 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $145
80106d75:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d7a:	e9 d4 f5 ff ff       	jmp    80106353 <alltraps>

80106d7f <vector146>:
.globl vector146
vector146:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $146
80106d81:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d86:	e9 c8 f5 ff ff       	jmp    80106353 <alltraps>

80106d8b <vector147>:
.globl vector147
vector147:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $147
80106d8d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d92:	e9 bc f5 ff ff       	jmp    80106353 <alltraps>

80106d97 <vector148>:
.globl vector148
vector148:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $148
80106d99:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d9e:	e9 b0 f5 ff ff       	jmp    80106353 <alltraps>

80106da3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $149
80106da5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106daa:	e9 a4 f5 ff ff       	jmp    80106353 <alltraps>

80106daf <vector150>:
.globl vector150
vector150:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $150
80106db1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106db6:	e9 98 f5 ff ff       	jmp    80106353 <alltraps>

80106dbb <vector151>:
.globl vector151
vector151:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $151
80106dbd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106dc2:	e9 8c f5 ff ff       	jmp    80106353 <alltraps>

80106dc7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $152
80106dc9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106dce:	e9 80 f5 ff ff       	jmp    80106353 <alltraps>

80106dd3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $153
80106dd5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106dda:	e9 74 f5 ff ff       	jmp    80106353 <alltraps>

80106ddf <vector154>:
.globl vector154
vector154:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $154
80106de1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106de6:	e9 68 f5 ff ff       	jmp    80106353 <alltraps>

80106deb <vector155>:
.globl vector155
vector155:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $155
80106ded:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106df2:	e9 5c f5 ff ff       	jmp    80106353 <alltraps>

80106df7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $156
80106df9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106dfe:	e9 50 f5 ff ff       	jmp    80106353 <alltraps>

80106e03 <vector157>:
.globl vector157
vector157:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $157
80106e05:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106e0a:	e9 44 f5 ff ff       	jmp    80106353 <alltraps>

80106e0f <vector158>:
.globl vector158
vector158:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $158
80106e11:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e16:	e9 38 f5 ff ff       	jmp    80106353 <alltraps>

80106e1b <vector159>:
.globl vector159
vector159:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $159
80106e1d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e22:	e9 2c f5 ff ff       	jmp    80106353 <alltraps>

80106e27 <vector160>:
.globl vector160
vector160:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $160
80106e29:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e2e:	e9 20 f5 ff ff       	jmp    80106353 <alltraps>

80106e33 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $161
80106e35:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e3a:	e9 14 f5 ff ff       	jmp    80106353 <alltraps>

80106e3f <vector162>:
.globl vector162
vector162:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $162
80106e41:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e46:	e9 08 f5 ff ff       	jmp    80106353 <alltraps>

80106e4b <vector163>:
.globl vector163
vector163:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $163
80106e4d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e52:	e9 fc f4 ff ff       	jmp    80106353 <alltraps>

80106e57 <vector164>:
.globl vector164
vector164:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $164
80106e59:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e5e:	e9 f0 f4 ff ff       	jmp    80106353 <alltraps>

80106e63 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $165
80106e65:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e6a:	e9 e4 f4 ff ff       	jmp    80106353 <alltraps>

80106e6f <vector166>:
.globl vector166
vector166:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $166
80106e71:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e76:	e9 d8 f4 ff ff       	jmp    80106353 <alltraps>

80106e7b <vector167>:
.globl vector167
vector167:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $167
80106e7d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e82:	e9 cc f4 ff ff       	jmp    80106353 <alltraps>

80106e87 <vector168>:
.globl vector168
vector168:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $168
80106e89:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e8e:	e9 c0 f4 ff ff       	jmp    80106353 <alltraps>

80106e93 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $169
80106e95:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e9a:	e9 b4 f4 ff ff       	jmp    80106353 <alltraps>

80106e9f <vector170>:
.globl vector170
vector170:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $170
80106ea1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ea6:	e9 a8 f4 ff ff       	jmp    80106353 <alltraps>

80106eab <vector171>:
.globl vector171
vector171:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $171
80106ead:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106eb2:	e9 9c f4 ff ff       	jmp    80106353 <alltraps>

80106eb7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $172
80106eb9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106ebe:	e9 90 f4 ff ff       	jmp    80106353 <alltraps>

80106ec3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $173
80106ec5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106eca:	e9 84 f4 ff ff       	jmp    80106353 <alltraps>

80106ecf <vector174>:
.globl vector174
vector174:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $174
80106ed1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106ed6:	e9 78 f4 ff ff       	jmp    80106353 <alltraps>

80106edb <vector175>:
.globl vector175
vector175:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $175
80106edd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ee2:	e9 6c f4 ff ff       	jmp    80106353 <alltraps>

80106ee7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $176
80106ee9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106eee:	e9 60 f4 ff ff       	jmp    80106353 <alltraps>

80106ef3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $177
80106ef5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106efa:	e9 54 f4 ff ff       	jmp    80106353 <alltraps>

80106eff <vector178>:
.globl vector178
vector178:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $178
80106f01:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106f06:	e9 48 f4 ff ff       	jmp    80106353 <alltraps>

80106f0b <vector179>:
.globl vector179
vector179:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $179
80106f0d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f12:	e9 3c f4 ff ff       	jmp    80106353 <alltraps>

80106f17 <vector180>:
.globl vector180
vector180:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $180
80106f19:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f1e:	e9 30 f4 ff ff       	jmp    80106353 <alltraps>

80106f23 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $181
80106f25:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f2a:	e9 24 f4 ff ff       	jmp    80106353 <alltraps>

80106f2f <vector182>:
.globl vector182
vector182:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $182
80106f31:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f36:	e9 18 f4 ff ff       	jmp    80106353 <alltraps>

80106f3b <vector183>:
.globl vector183
vector183:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $183
80106f3d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f42:	e9 0c f4 ff ff       	jmp    80106353 <alltraps>

80106f47 <vector184>:
.globl vector184
vector184:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $184
80106f49:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f4e:	e9 00 f4 ff ff       	jmp    80106353 <alltraps>

80106f53 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $185
80106f55:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f5a:	e9 f4 f3 ff ff       	jmp    80106353 <alltraps>

80106f5f <vector186>:
.globl vector186
vector186:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $186
80106f61:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f66:	e9 e8 f3 ff ff       	jmp    80106353 <alltraps>

80106f6b <vector187>:
.globl vector187
vector187:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $187
80106f6d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f72:	e9 dc f3 ff ff       	jmp    80106353 <alltraps>

80106f77 <vector188>:
.globl vector188
vector188:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $188
80106f79:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f7e:	e9 d0 f3 ff ff       	jmp    80106353 <alltraps>

80106f83 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $189
80106f85:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f8a:	e9 c4 f3 ff ff       	jmp    80106353 <alltraps>

80106f8f <vector190>:
.globl vector190
vector190:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $190
80106f91:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f96:	e9 b8 f3 ff ff       	jmp    80106353 <alltraps>

80106f9b <vector191>:
.globl vector191
vector191:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $191
80106f9d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106fa2:	e9 ac f3 ff ff       	jmp    80106353 <alltraps>

80106fa7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $192
80106fa9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106fae:	e9 a0 f3 ff ff       	jmp    80106353 <alltraps>

80106fb3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $193
80106fb5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106fba:	e9 94 f3 ff ff       	jmp    80106353 <alltraps>

80106fbf <vector194>:
.globl vector194
vector194:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $194
80106fc1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106fc6:	e9 88 f3 ff ff       	jmp    80106353 <alltraps>

80106fcb <vector195>:
.globl vector195
vector195:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $195
80106fcd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106fd2:	e9 7c f3 ff ff       	jmp    80106353 <alltraps>

80106fd7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $196
80106fd9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106fde:	e9 70 f3 ff ff       	jmp    80106353 <alltraps>

80106fe3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $197
80106fe5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106fea:	e9 64 f3 ff ff       	jmp    80106353 <alltraps>

80106fef <vector198>:
.globl vector198
vector198:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $198
80106ff1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ff6:	e9 58 f3 ff ff       	jmp    80106353 <alltraps>

80106ffb <vector199>:
.globl vector199
vector199:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $199
80106ffd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107002:	e9 4c f3 ff ff       	jmp    80106353 <alltraps>

80107007 <vector200>:
.globl vector200
vector200:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $200
80107009:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010700e:	e9 40 f3 ff ff       	jmp    80106353 <alltraps>

80107013 <vector201>:
.globl vector201
vector201:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $201
80107015:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010701a:	e9 34 f3 ff ff       	jmp    80106353 <alltraps>

8010701f <vector202>:
.globl vector202
vector202:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $202
80107021:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107026:	e9 28 f3 ff ff       	jmp    80106353 <alltraps>

8010702b <vector203>:
.globl vector203
vector203:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $203
8010702d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107032:	e9 1c f3 ff ff       	jmp    80106353 <alltraps>

80107037 <vector204>:
.globl vector204
vector204:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $204
80107039:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010703e:	e9 10 f3 ff ff       	jmp    80106353 <alltraps>

80107043 <vector205>:
.globl vector205
vector205:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $205
80107045:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010704a:	e9 04 f3 ff ff       	jmp    80106353 <alltraps>

8010704f <vector206>:
.globl vector206
vector206:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $206
80107051:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107056:	e9 f8 f2 ff ff       	jmp    80106353 <alltraps>

8010705b <vector207>:
.globl vector207
vector207:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $207
8010705d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107062:	e9 ec f2 ff ff       	jmp    80106353 <alltraps>

80107067 <vector208>:
.globl vector208
vector208:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $208
80107069:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010706e:	e9 e0 f2 ff ff       	jmp    80106353 <alltraps>

80107073 <vector209>:
.globl vector209
vector209:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $209
80107075:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010707a:	e9 d4 f2 ff ff       	jmp    80106353 <alltraps>

8010707f <vector210>:
.globl vector210
vector210:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $210
80107081:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107086:	e9 c8 f2 ff ff       	jmp    80106353 <alltraps>

8010708b <vector211>:
.globl vector211
vector211:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $211
8010708d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107092:	e9 bc f2 ff ff       	jmp    80106353 <alltraps>

80107097 <vector212>:
.globl vector212
vector212:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $212
80107099:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010709e:	e9 b0 f2 ff ff       	jmp    80106353 <alltraps>

801070a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $213
801070a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801070aa:	e9 a4 f2 ff ff       	jmp    80106353 <alltraps>

801070af <vector214>:
.globl vector214
vector214:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $214
801070b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070b6:	e9 98 f2 ff ff       	jmp    80106353 <alltraps>

801070bb <vector215>:
.globl vector215
vector215:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $215
801070bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801070c2:	e9 8c f2 ff ff       	jmp    80106353 <alltraps>

801070c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $216
801070c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801070ce:	e9 80 f2 ff ff       	jmp    80106353 <alltraps>

801070d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $217
801070d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801070da:	e9 74 f2 ff ff       	jmp    80106353 <alltraps>

801070df <vector218>:
.globl vector218
vector218:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $218
801070e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070e6:	e9 68 f2 ff ff       	jmp    80106353 <alltraps>

801070eb <vector219>:
.globl vector219
vector219:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $219
801070ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070f2:	e9 5c f2 ff ff       	jmp    80106353 <alltraps>

801070f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $220
801070f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801070fe:	e9 50 f2 ff ff       	jmp    80106353 <alltraps>

80107103 <vector221>:
.globl vector221
vector221:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $221
80107105:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010710a:	e9 44 f2 ff ff       	jmp    80106353 <alltraps>

8010710f <vector222>:
.globl vector222
vector222:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $222
80107111:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107116:	e9 38 f2 ff ff       	jmp    80106353 <alltraps>

8010711b <vector223>:
.globl vector223
vector223:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $223
8010711d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107122:	e9 2c f2 ff ff       	jmp    80106353 <alltraps>

80107127 <vector224>:
.globl vector224
vector224:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $224
80107129:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010712e:	e9 20 f2 ff ff       	jmp    80106353 <alltraps>

80107133 <vector225>:
.globl vector225
vector225:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $225
80107135:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010713a:	e9 14 f2 ff ff       	jmp    80106353 <alltraps>

8010713f <vector226>:
.globl vector226
vector226:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $226
80107141:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107146:	e9 08 f2 ff ff       	jmp    80106353 <alltraps>

8010714b <vector227>:
.globl vector227
vector227:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $227
8010714d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107152:	e9 fc f1 ff ff       	jmp    80106353 <alltraps>

80107157 <vector228>:
.globl vector228
vector228:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $228
80107159:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010715e:	e9 f0 f1 ff ff       	jmp    80106353 <alltraps>

80107163 <vector229>:
.globl vector229
vector229:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $229
80107165:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010716a:	e9 e4 f1 ff ff       	jmp    80106353 <alltraps>

8010716f <vector230>:
.globl vector230
vector230:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $230
80107171:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107176:	e9 d8 f1 ff ff       	jmp    80106353 <alltraps>

8010717b <vector231>:
.globl vector231
vector231:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $231
8010717d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107182:	e9 cc f1 ff ff       	jmp    80106353 <alltraps>

80107187 <vector232>:
.globl vector232
vector232:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $232
80107189:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010718e:	e9 c0 f1 ff ff       	jmp    80106353 <alltraps>

80107193 <vector233>:
.globl vector233
vector233:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $233
80107195:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010719a:	e9 b4 f1 ff ff       	jmp    80106353 <alltraps>

8010719f <vector234>:
.globl vector234
vector234:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $234
801071a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801071a6:	e9 a8 f1 ff ff       	jmp    80106353 <alltraps>

801071ab <vector235>:
.globl vector235
vector235:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $235
801071ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071b2:	e9 9c f1 ff ff       	jmp    80106353 <alltraps>

801071b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $236
801071b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071be:	e9 90 f1 ff ff       	jmp    80106353 <alltraps>

801071c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $237
801071c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801071ca:	e9 84 f1 ff ff       	jmp    80106353 <alltraps>

801071cf <vector238>:
.globl vector238
vector238:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $238
801071d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801071d6:	e9 78 f1 ff ff       	jmp    80106353 <alltraps>

801071db <vector239>:
.globl vector239
vector239:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $239
801071dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071e2:	e9 6c f1 ff ff       	jmp    80106353 <alltraps>

801071e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $240
801071e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071ee:	e9 60 f1 ff ff       	jmp    80106353 <alltraps>

801071f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $241
801071f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071fa:	e9 54 f1 ff ff       	jmp    80106353 <alltraps>

801071ff <vector242>:
.globl vector242
vector242:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $242
80107201:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107206:	e9 48 f1 ff ff       	jmp    80106353 <alltraps>

8010720b <vector243>:
.globl vector243
vector243:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $243
8010720d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107212:	e9 3c f1 ff ff       	jmp    80106353 <alltraps>

80107217 <vector244>:
.globl vector244
vector244:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $244
80107219:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010721e:	e9 30 f1 ff ff       	jmp    80106353 <alltraps>

80107223 <vector245>:
.globl vector245
vector245:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $245
80107225:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010722a:	e9 24 f1 ff ff       	jmp    80106353 <alltraps>

8010722f <vector246>:
.globl vector246
vector246:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $246
80107231:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107236:	e9 18 f1 ff ff       	jmp    80106353 <alltraps>

8010723b <vector247>:
.globl vector247
vector247:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $247
8010723d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107242:	e9 0c f1 ff ff       	jmp    80106353 <alltraps>

80107247 <vector248>:
.globl vector248
vector248:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $248
80107249:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010724e:	e9 00 f1 ff ff       	jmp    80106353 <alltraps>

80107253 <vector249>:
.globl vector249
vector249:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $249
80107255:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010725a:	e9 f4 f0 ff ff       	jmp    80106353 <alltraps>

8010725f <vector250>:
.globl vector250
vector250:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $250
80107261:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107266:	e9 e8 f0 ff ff       	jmp    80106353 <alltraps>

8010726b <vector251>:
.globl vector251
vector251:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $251
8010726d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107272:	e9 dc f0 ff ff       	jmp    80106353 <alltraps>

80107277 <vector252>:
.globl vector252
vector252:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $252
80107279:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010727e:	e9 d0 f0 ff ff       	jmp    80106353 <alltraps>

80107283 <vector253>:
.globl vector253
vector253:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $253
80107285:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010728a:	e9 c4 f0 ff ff       	jmp    80106353 <alltraps>

8010728f <vector254>:
.globl vector254
vector254:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $254
80107291:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107296:	e9 b8 f0 ff ff       	jmp    80106353 <alltraps>

8010729b <vector255>:
.globl vector255
vector255:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $255
8010729d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801072a2:	e9 ac f0 ff ff       	jmp    80106353 <alltraps>
801072a7:	66 90                	xchg   %ax,%ax
801072a9:	66 90                	xchg   %ax,%ax
801072ab:	66 90                	xchg   %ax,%ax
801072ad:	66 90                	xchg   %ax,%ax
801072af:	90                   	nop

801072b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801072b0:	55                   	push   %ebp
801072b1:	89 e5                	mov    %esp,%ebp
801072b3:	57                   	push   %edi
801072b4:	56                   	push   %esi
801072b5:	53                   	push   %ebx
	pde_t *pde;
	pte_t *pgtab;

	pde = &pgdir[PDX(va)];
801072b6:	89 d3                	mov    %edx,%ebx
{
801072b8:	89 d7                	mov    %edx,%edi
	pde = &pgdir[PDX(va)];
801072ba:	c1 eb 16             	shr    $0x16,%ebx
801072bd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801072c0:	83 ec 0c             	sub    $0xc,%esp
	if (*pde & PTE_P) {
801072c3:	8b 06                	mov    (%esi),%eax
801072c5:	a8 01                	test   $0x1,%al
801072c7:	74 27                	je     801072f0 <walkpgdir+0x40>
		pgtab = (pte_t *)P2V(PTE_ADDR(*pde));
801072c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072ce:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
		// The permissions here are overly generous, but they can
		// be further restricted by the permissions in the page table
		// entries, if necessary.
		*pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
	}
	return &pgtab[PTX(va)];
801072d4:	c1 ef 0a             	shr    $0xa,%edi
}
801072d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return &pgtab[PTX(va)];
801072da:	89 fa                	mov    %edi,%edx
801072dc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801072e2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801072e5:	5b                   	pop    %ebx
801072e6:	5e                   	pop    %esi
801072e7:	5f                   	pop    %edi
801072e8:	5d                   	pop    %ebp
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if (!alloc || (pgtab = (pte_t *)kalloc()) == 0) return 0;
801072f0:	85 c9                	test   %ecx,%ecx
801072f2:	74 2c                	je     80107320 <walkpgdir+0x70>
801072f4:	e8 d7 b1 ff ff       	call   801024d0 <kalloc>
801072f9:	85 c0                	test   %eax,%eax
801072fb:	89 c3                	mov    %eax,%ebx
801072fd:	74 21                	je     80107320 <walkpgdir+0x70>
		memset(pgtab, 0, PGSIZE);
801072ff:	83 ec 04             	sub    $0x4,%esp
80107302:	68 00 10 00 00       	push   $0x1000
80107307:	6a 00                	push   $0x0
80107309:	50                   	push   %eax
8010730a:	e8 11 d7 ff ff       	call   80104a20 <memset>
		*pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010730f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107315:	83 c4 10             	add    $0x10,%esp
80107318:	83 c8 07             	or     $0x7,%eax
8010731b:	89 06                	mov    %eax,(%esi)
8010731d:	eb b5                	jmp    801072d4 <walkpgdir+0x24>
8010731f:	90                   	nop
}
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (!alloc || (pgtab = (pte_t *)kalloc()) == 0) return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
8010732a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107330 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
	char * a, *last;
	pte_t *pte;

	a    = (char *)PGROUNDDOWN((uint)va);
80107336:	89 d3                	mov    %edx,%ebx
80107338:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010733e:	83 ec 1c             	sub    $0x1c,%esp
80107341:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	last = (char *)PGROUNDDOWN(((uint)va) + size - 1);
80107344:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107348:	8b 7d 08             	mov    0x8(%ebp),%edi
8010734b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107350:	89 45 e0             	mov    %eax,-0x20(%ebp)
	for (;;) {
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
		if (*pte & PTE_P) panic("remap");
		*pte = pa | perm | PTE_P;
80107353:	8b 45 0c             	mov    0xc(%ebp),%eax
80107356:	29 df                	sub    %ebx,%edi
80107358:	83 c8 01             	or     $0x1,%eax
8010735b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010735e:	eb 15                	jmp    80107375 <mappages+0x45>
		if (*pte & PTE_P) panic("remap");
80107360:	f6 00 01             	testb  $0x1,(%eax)
80107363:	75 45                	jne    801073aa <mappages+0x7a>
		*pte = pa | perm | PTE_P;
80107365:	0b 75 dc             	or     -0x24(%ebp),%esi
		if (a == last) break;
80107368:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
		*pte = pa | perm | PTE_P;
8010736b:	89 30                	mov    %esi,(%eax)
		if (a == last) break;
8010736d:	74 31                	je     801073a0 <mappages+0x70>
		a += PGSIZE;
8010736f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
80107375:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107378:	b9 01 00 00 00       	mov    $0x1,%ecx
8010737d:	89 da                	mov    %ebx,%edx
8010737f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107382:	e8 29 ff ff ff       	call   801072b0 <walkpgdir>
80107387:	85 c0                	test   %eax,%eax
80107389:	75 d5                	jne    80107360 <mappages+0x30>
		pa += PGSIZE;
	}
	return 0;
}
8010738b:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if ((pte = walkpgdir(pgdir, a, 1)) == 0) return -1;
8010738e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107393:	5b                   	pop    %ebx
80107394:	5e                   	pop    %esi
80107395:	5f                   	pop    %edi
80107396:	5d                   	pop    %ebp
80107397:	c3                   	ret    
80107398:	90                   	nop
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
801073a3:	31 c0                	xor    %eax,%eax
}
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    
		if (*pte & PTE_P) panic("remap");
801073aa:	83 ec 0c             	sub    $0xc,%esp
801073ad:	68 18 85 10 80       	push   $0x80108518
801073b2:	e8 d9 8f ff ff       	call   80100390 <panic>
801073b7:	89 f6                	mov    %esi,%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
	pte_t *pte;
	uint   a, pa;

	if (newsz >= oldsz) return oldsz;

	a = PGROUNDUP(newsz);
801073c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073cc:	89 c7                	mov    %eax,%edi
	a = PGROUNDUP(newsz);
801073ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073d4:	83 ec 1c             	sub    $0x1c,%esp
801073d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
	for (; a < oldsz; a += PGSIZE) {
801073da:	39 d3                	cmp    %edx,%ebx
801073dc:	73 66                	jae    80107444 <deallocuvm.part.0+0x84>
801073de:	89 d6                	mov    %edx,%esi
801073e0:	eb 3d                	jmp    8010741f <deallocuvm.part.0+0x5f>
801073e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		pte = walkpgdir(pgdir, (char *)a, 0);
		if (!pte)
			a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
		else if ((*pte & PTE_P) != 0) {
801073e8:	8b 10                	mov    (%eax),%edx
801073ea:	f6 c2 01             	test   $0x1,%dl
801073ed:	74 26                	je     80107415 <deallocuvm.part.0+0x55>
			pa = PTE_ADDR(*pte);
			if (pa == 0) panic("kfree");
801073ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801073f5:	74 58                	je     8010744f <deallocuvm.part.0+0x8f>
			char *v = P2V(pa);
			kfree(v);
801073f7:	83 ec 0c             	sub    $0xc,%esp
			char *v = P2V(pa);
801073fa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			kfree(v);
80107403:	52                   	push   %edx
80107404:	e8 17 af ff ff       	call   80102320 <kfree>
			*pte = 0;
80107409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010740c:	83 c4 10             	add    $0x10,%esp
8010740f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (; a < oldsz; a += PGSIZE) {
80107415:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010741b:	39 f3                	cmp    %esi,%ebx
8010741d:	73 25                	jae    80107444 <deallocuvm.part.0+0x84>
		pte = walkpgdir(pgdir, (char *)a, 0);
8010741f:	31 c9                	xor    %ecx,%ecx
80107421:	89 da                	mov    %ebx,%edx
80107423:	89 f8                	mov    %edi,%eax
80107425:	e8 86 fe ff ff       	call   801072b0 <walkpgdir>
		if (!pte)
8010742a:	85 c0                	test   %eax,%eax
8010742c:	75 ba                	jne    801073e8 <deallocuvm.part.0+0x28>
			a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010742e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107434:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
	for (; a < oldsz; a += PGSIZE) {
8010743a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107440:	39 f3                	cmp    %esi,%ebx
80107442:	72 db                	jb     8010741f <deallocuvm.part.0+0x5f>
		}
	}
	return newsz;
}
80107444:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010744a:	5b                   	pop    %ebx
8010744b:	5e                   	pop    %esi
8010744c:	5f                   	pop    %edi
8010744d:	5d                   	pop    %ebp
8010744e:	c3                   	ret    
			if (pa == 0) panic("kfree");
8010744f:	83 ec 0c             	sub    $0xc,%esp
80107452:	68 46 7e 10 80       	push   $0x80107e46
80107457:	e8 34 8f ff ff       	call   80100390 <panic>
8010745c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107460 <seginit>:
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	83 ec 18             	sub    $0x18,%esp
	c                 = &cpus[cpuid()];
80107466:	e8 55 c4 ff ff       	call   801038c0 <cpuid>
8010746b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
	pd[0] = size - 1;
80107471:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107476:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
	c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010747a:	c7 80 78 d5 12 80 ff 	movl   $0xffff,-0x7fed2a88(%eax)
80107481:	ff 00 00 
80107484:	c7 80 7c d5 12 80 00 	movl   $0xcf9a00,-0x7fed2a84(%eax)
8010748b:	9a cf 00 
	c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010748e:	c7 80 80 d5 12 80 ff 	movl   $0xffff,-0x7fed2a80(%eax)
80107495:	ff 00 00 
80107498:	c7 80 84 d5 12 80 00 	movl   $0xcf9200,-0x7fed2a7c(%eax)
8010749f:	92 cf 00 
	c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
801074a2:	c7 80 88 d5 12 80 ff 	movl   $0xffff,-0x7fed2a78(%eax)
801074a9:	ff 00 00 
801074ac:	c7 80 8c d5 12 80 00 	movl   $0xcffa00,-0x7fed2a74(%eax)
801074b3:	fa cf 00 
	c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074b6:	c7 80 90 d5 12 80 ff 	movl   $0xffff,-0x7fed2a70(%eax)
801074bd:	ff 00 00 
801074c0:	c7 80 94 d5 12 80 00 	movl   $0xcff200,-0x7fed2a6c(%eax)
801074c7:	f2 cf 00 
	lgdt(c->gdt, sizeof(c->gdt));
801074ca:	05 70 d5 12 80       	add    $0x8012d570,%eax
	pd[1] = (uint)p;
801074cf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
	pd[2] = (uint)p >> 16;
801074d3:	c1 e8 10             	shr    $0x10,%eax
801074d6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
	asm volatile("lgdt (%0)" : : "r"(pd));
801074da:	8d 45 f2             	lea    -0xe(%ebp),%eax
801074dd:	0f 01 10             	lgdtl  (%eax)
}
801074e0:	c9                   	leave  
801074e1:	c3                   	ret    
801074e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074f0 <switchkvm>:
	lcr3(V2P(kpgdir)); // switch to the kernel page table
801074f0:	a1 e4 e2 12 80       	mov    0x8012e2e4,%eax
{
801074f5:	55                   	push   %ebp
801074f6:	89 e5                	mov    %esp,%ebp
	lcr3(V2P(kpgdir)); // switch to the kernel page table
801074f8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
	asm volatile("movl %0,%%cr3" : : "r"(val));
801074fd:	0f 22 d8             	mov    %eax,%cr3
}
80107500:	5d                   	pop    %ebp
80107501:	c3                   	ret    
80107502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107510 <switchuvm>:
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
80107516:	83 ec 1c             	sub    $0x1c,%esp
80107519:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (p == 0) panic("switchuvm: no process");
8010751c:	85 db                	test   %ebx,%ebx
8010751e:	0f 84 cb 00 00 00    	je     801075ef <switchuvm+0xdf>
	if (p->kstack == 0) panic("switchuvm: no kstack");
80107524:	8b 43 08             	mov    0x8(%ebx),%eax
80107527:	85 c0                	test   %eax,%eax
80107529:	0f 84 da 00 00 00    	je     80107609 <switchuvm+0xf9>
	if (p->pgdir == 0) panic("switchuvm: no pgdir");
8010752f:	8b 43 04             	mov    0x4(%ebx),%eax
80107532:	85 c0                	test   %eax,%eax
80107534:	0f 84 c2 00 00 00    	je     801075fc <switchuvm+0xec>
	pushcli();
8010753a:	e8 21 d3 ff ff       	call   80104860 <pushcli>
	mycpu()->gdt[SEG_TSS]   = SEG16(STS_T32A, &mycpu()->ts, sizeof(mycpu()->ts) - 1, 0);
8010753f:	e8 fc c2 ff ff       	call   80103840 <mycpu>
80107544:	89 c6                	mov    %eax,%esi
80107546:	e8 f5 c2 ff ff       	call   80103840 <mycpu>
8010754b:	89 c7                	mov    %eax,%edi
8010754d:	e8 ee c2 ff ff       	call   80103840 <mycpu>
80107552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107555:	83 c7 08             	add    $0x8,%edi
80107558:	e8 e3 c2 ff ff       	call   80103840 <mycpu>
8010755d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107560:	83 c0 08             	add    $0x8,%eax
80107563:	ba 67 00 00 00       	mov    $0x67,%edx
80107568:	c1 e8 18             	shr    $0x18,%eax
8010756b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107572:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107579:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
	mycpu()->ts.iomb = (ushort)0xFFFF;
8010757f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	mycpu()->gdt[SEG_TSS]   = SEG16(STS_T32A, &mycpu()->ts, sizeof(mycpu()->ts) - 1, 0);
80107584:	83 c1 08             	add    $0x8,%ecx
80107587:	c1 e9 10             	shr    $0x10,%ecx
8010758a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107590:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107595:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
	mycpu()->ts.ss0         = SEG_KDATA << 3;
8010759c:	be 10 00 00 00       	mov    $0x10,%esi
	mycpu()->gdt[SEG_TSS].s = 0;
801075a1:	e8 9a c2 ff ff       	call   80103840 <mycpu>
801075a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
	mycpu()->ts.ss0         = SEG_KDATA << 3;
801075ad:	e8 8e c2 ff ff       	call   80103840 <mycpu>
801075b2:	66 89 70 10          	mov    %si,0x10(%eax)
	mycpu()->ts.esp0        = (uint)p->kstack + KSTACKSIZE;
801075b6:	8b 73 08             	mov    0x8(%ebx),%esi
801075b9:	e8 82 c2 ff ff       	call   80103840 <mycpu>
801075be:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075c4:	89 70 0c             	mov    %esi,0xc(%eax)
	mycpu()->ts.iomb = (ushort)0xFFFF;
801075c7:	e8 74 c2 ff ff       	call   80103840 <mycpu>
801075cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
	asm volatile("ltr %0" : : "r"(sel));
801075d0:	b8 28 00 00 00       	mov    $0x28,%eax
801075d5:	0f 00 d8             	ltr    %ax
	lcr3(V2P(p->pgdir)); // switch to process's address space
801075d8:	8b 43 04             	mov    0x4(%ebx),%eax
801075db:	05 00 00 00 80       	add    $0x80000000,%eax
	asm volatile("movl %0,%%cr3" : : "r"(val));
801075e0:	0f 22 d8             	mov    %eax,%cr3
}
801075e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e6:	5b                   	pop    %ebx
801075e7:	5e                   	pop    %esi
801075e8:	5f                   	pop    %edi
801075e9:	5d                   	pop    %ebp
	popcli();
801075ea:	e9 71 d3 ff ff       	jmp    80104960 <popcli>
	if (p == 0) panic("switchuvm: no process");
801075ef:	83 ec 0c             	sub    $0xc,%esp
801075f2:	68 1e 85 10 80       	push   $0x8010851e
801075f7:	e8 94 8d ff ff       	call   80100390 <panic>
	if (p->pgdir == 0) panic("switchuvm: no pgdir");
801075fc:	83 ec 0c             	sub    $0xc,%esp
801075ff:	68 49 85 10 80       	push   $0x80108549
80107604:	e8 87 8d ff ff       	call   80100390 <panic>
	if (p->kstack == 0) panic("switchuvm: no kstack");
80107609:	83 ec 0c             	sub    $0xc,%esp
8010760c:	68 34 85 10 80       	push   $0x80108534
80107611:	e8 7a 8d ff ff       	call   80100390 <panic>
80107616:	8d 76 00             	lea    0x0(%esi),%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107620 <inituvm>:
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	57                   	push   %edi
80107624:	56                   	push   %esi
80107625:	53                   	push   %ebx
80107626:	83 ec 1c             	sub    $0x1c,%esp
80107629:	8b 75 10             	mov    0x10(%ebp),%esi
8010762c:	8b 45 08             	mov    0x8(%ebp),%eax
8010762f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if (sz >= PGSIZE) panic("inituvm: more than a page");
80107632:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (sz >= PGSIZE) panic("inituvm: more than a page");
8010763b:	77 49                	ja     80107686 <inituvm+0x66>
	mem = kalloc();
8010763d:	e8 8e ae ff ff       	call   801024d0 <kalloc>
	memset(mem, 0, PGSIZE);
80107642:	83 ec 04             	sub    $0x4,%esp
	mem = kalloc();
80107645:	89 c3                	mov    %eax,%ebx
	memset(mem, 0, PGSIZE);
80107647:	68 00 10 00 00       	push   $0x1000
8010764c:	6a 00                	push   $0x0
8010764e:	50                   	push   %eax
8010764f:	e8 cc d3 ff ff       	call   80104a20 <memset>
	mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107654:	58                   	pop    %eax
80107655:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010765b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107660:	5a                   	pop    %edx
80107661:	6a 06                	push   $0x6
80107663:	50                   	push   %eax
80107664:	31 d2                	xor    %edx,%edx
80107666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107669:	e8 c2 fc ff ff       	call   80107330 <mappages>
	memmove(mem, init, sz);
8010766e:	89 75 10             	mov    %esi,0x10(%ebp)
80107671:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107674:	83 c4 10             	add    $0x10,%esp
80107677:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010767a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010767d:	5b                   	pop    %ebx
8010767e:	5e                   	pop    %esi
8010767f:	5f                   	pop    %edi
80107680:	5d                   	pop    %ebp
	memmove(mem, init, sz);
80107681:	e9 4a d4 ff ff       	jmp    80104ad0 <memmove>
	if (sz >= PGSIZE) panic("inituvm: more than a page");
80107686:	83 ec 0c             	sub    $0xc,%esp
80107689:	68 5d 85 10 80       	push   $0x8010855d
8010768e:	e8 fd 8c ff ff       	call   80100390 <panic>
80107693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076a0 <loaduvm>:
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 0c             	sub    $0xc,%esp
	if ((uint)addr % PGSIZE != 0) panic("loaduvm: addr must be page aligned");
801076a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801076b0:	0f 85 91 00 00 00    	jne    80107747 <loaduvm+0xa7>
	for (i = 0; i < sz; i += PGSIZE) {
801076b6:	8b 75 18             	mov    0x18(%ebp),%esi
801076b9:	31 db                	xor    %ebx,%ebx
801076bb:	85 f6                	test   %esi,%esi
801076bd:	75 1a                	jne    801076d9 <loaduvm+0x39>
801076bf:	eb 6f                	jmp    80107730 <loaduvm+0x90>
801076c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801076d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801076d7:	76 57                	jbe    80107730 <loaduvm+0x90>
		if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) panic("loaduvm: address should exist");
801076d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801076dc:	8b 45 08             	mov    0x8(%ebp),%eax
801076df:	31 c9                	xor    %ecx,%ecx
801076e1:	01 da                	add    %ebx,%edx
801076e3:	e8 c8 fb ff ff       	call   801072b0 <walkpgdir>
801076e8:	85 c0                	test   %eax,%eax
801076ea:	74 4e                	je     8010773a <loaduvm+0x9a>
		pa = PTE_ADDR(*pte);
801076ec:	8b 00                	mov    (%eax),%eax
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
801076ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
		if (sz - i < PGSIZE)
801076f1:	bf 00 10 00 00       	mov    $0x1000,%edi
		pa = PTE_ADDR(*pte);
801076f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
		if (sz - i < PGSIZE)
801076fb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107701:	0f 46 fe             	cmovbe %esi,%edi
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80107704:	01 d9                	add    %ebx,%ecx
80107706:	05 00 00 00 80       	add    $0x80000000,%eax
8010770b:	57                   	push   %edi
8010770c:	51                   	push   %ecx
8010770d:	50                   	push   %eax
8010770e:	ff 75 10             	pushl  0x10(%ebp)
80107711:	e8 5a a2 ff ff       	call   80101970 <readi>
80107716:	83 c4 10             	add    $0x10,%esp
80107719:	39 f8                	cmp    %edi,%eax
8010771b:	74 ab                	je     801076c8 <loaduvm+0x28>
}
8010771d:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (readi(ip, P2V(pa), offset + i, n) != n) return -1;
80107720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107725:	5b                   	pop    %ebx
80107726:	5e                   	pop    %esi
80107727:	5f                   	pop    %edi
80107728:	5d                   	pop    %ebp
80107729:	c3                   	ret    
8010772a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107730:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80107733:	31 c0                	xor    %eax,%eax
}
80107735:	5b                   	pop    %ebx
80107736:	5e                   	pop    %esi
80107737:	5f                   	pop    %edi
80107738:	5d                   	pop    %ebp
80107739:	c3                   	ret    
		if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) panic("loaduvm: address should exist");
8010773a:	83 ec 0c             	sub    $0xc,%esp
8010773d:	68 77 85 10 80       	push   $0x80108577
80107742:	e8 49 8c ff ff       	call   80100390 <panic>
	if ((uint)addr % PGSIZE != 0) panic("loaduvm: addr must be page aligned");
80107747:	83 ec 0c             	sub    $0xc,%esp
8010774a:	68 18 86 10 80       	push   $0x80108618
8010774f:	e8 3c 8c ff ff       	call   80100390 <panic>
80107754:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010775a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107760 <allocuvm>:
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	57                   	push   %edi
80107764:	56                   	push   %esi
80107765:	53                   	push   %ebx
80107766:	83 ec 1c             	sub    $0x1c,%esp
	if (newsz >= KERNBASE) return 0;
80107769:	8b 7d 10             	mov    0x10(%ebp),%edi
8010776c:	85 ff                	test   %edi,%edi
8010776e:	0f 88 8e 00 00 00    	js     80107802 <allocuvm+0xa2>
	if (newsz < oldsz) return oldsz;
80107774:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107777:	0f 82 93 00 00 00    	jb     80107810 <allocuvm+0xb0>
	a = PGROUNDUP(oldsz);
8010777d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107780:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107786:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	for (; a < newsz; a += PGSIZE) {
8010778c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010778f:	0f 86 7e 00 00 00    	jbe    80107813 <allocuvm+0xb3>
80107795:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107798:	8b 7d 08             	mov    0x8(%ebp),%edi
8010779b:	eb 42                	jmp    801077df <allocuvm+0x7f>
8010779d:	8d 76 00             	lea    0x0(%esi),%esi
		memset(mem, 0, PGSIZE);
801077a0:	83 ec 04             	sub    $0x4,%esp
801077a3:	68 00 10 00 00       	push   $0x1000
801077a8:	6a 00                	push   $0x0
801077aa:	50                   	push   %eax
801077ab:	e8 70 d2 ff ff       	call   80104a20 <memset>
		if (mappages(pgdir, (char *)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801077b0:	58                   	pop    %eax
801077b1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801077b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077bc:	5a                   	pop    %edx
801077bd:	6a 06                	push   $0x6
801077bf:	50                   	push   %eax
801077c0:	89 da                	mov    %ebx,%edx
801077c2:	89 f8                	mov    %edi,%eax
801077c4:	e8 67 fb ff ff       	call   80107330 <mappages>
801077c9:	83 c4 10             	add    $0x10,%esp
801077cc:	85 c0                	test   %eax,%eax
801077ce:	78 50                	js     80107820 <allocuvm+0xc0>
	for (; a < newsz; a += PGSIZE) {
801077d0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801077d6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801077d9:	0f 86 81 00 00 00    	jbe    80107860 <allocuvm+0x100>
		mem = kalloc();
801077df:	e8 ec ac ff ff       	call   801024d0 <kalloc>
		if (mem == 0) {
801077e4:	85 c0                	test   %eax,%eax
		mem = kalloc();
801077e6:	89 c6                	mov    %eax,%esi
		if (mem == 0) {
801077e8:	75 b6                	jne    801077a0 <allocuvm+0x40>
			cprintf("allocuvm out of memory\n");
801077ea:	83 ec 0c             	sub    $0xc,%esp
801077ed:	68 95 85 10 80       	push   $0x80108595
801077f2:	e8 69 8e ff ff       	call   80100660 <cprintf>
	if (newsz >= oldsz) return oldsz;
801077f7:	83 c4 10             	add    $0x10,%esp
801077fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801077fd:	39 45 10             	cmp    %eax,0x10(%ebp)
80107800:	77 6e                	ja     80107870 <allocuvm+0x110>
}
80107802:	8d 65 f4             	lea    -0xc(%ebp),%esp
	if (newsz >= KERNBASE) return 0;
80107805:	31 ff                	xor    %edi,%edi
}
80107807:	89 f8                	mov    %edi,%eax
80107809:	5b                   	pop    %ebx
8010780a:	5e                   	pop    %esi
8010780b:	5f                   	pop    %edi
8010780c:	5d                   	pop    %ebp
8010780d:	c3                   	ret    
8010780e:	66 90                	xchg   %ax,%ax
	if (newsz < oldsz) return oldsz;
80107810:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107813:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107816:	89 f8                	mov    %edi,%eax
80107818:	5b                   	pop    %ebx
80107819:	5e                   	pop    %esi
8010781a:	5f                   	pop    %edi
8010781b:	5d                   	pop    %ebp
8010781c:	c3                   	ret    
8010781d:	8d 76 00             	lea    0x0(%esi),%esi
			cprintf("allocuvm out of memory (2)\n");
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	68 ad 85 10 80       	push   $0x801085ad
80107828:	e8 33 8e ff ff       	call   80100660 <cprintf>
	if (newsz >= oldsz) return oldsz;
8010782d:	83 c4 10             	add    $0x10,%esp
80107830:	8b 45 0c             	mov    0xc(%ebp),%eax
80107833:	39 45 10             	cmp    %eax,0x10(%ebp)
80107836:	76 0d                	jbe    80107845 <allocuvm+0xe5>
80107838:	89 c1                	mov    %eax,%ecx
8010783a:	8b 55 10             	mov    0x10(%ebp),%edx
8010783d:	8b 45 08             	mov    0x8(%ebp),%eax
80107840:	e8 7b fb ff ff       	call   801073c0 <deallocuvm.part.0>
			kfree(mem);
80107845:	83 ec 0c             	sub    $0xc,%esp
			return 0;
80107848:	31 ff                	xor    %edi,%edi
			kfree(mem);
8010784a:	56                   	push   %esi
8010784b:	e8 d0 aa ff ff       	call   80102320 <kfree>
			return 0;
80107850:	83 c4 10             	add    $0x10,%esp
}
80107853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107856:	89 f8                	mov    %edi,%eax
80107858:	5b                   	pop    %ebx
80107859:	5e                   	pop    %esi
8010785a:	5f                   	pop    %edi
8010785b:	5d                   	pop    %ebp
8010785c:	c3                   	ret    
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
80107860:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107863:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107866:	5b                   	pop    %ebx
80107867:	89 f8                	mov    %edi,%eax
80107869:	5e                   	pop    %esi
8010786a:	5f                   	pop    %edi
8010786b:	5d                   	pop    %ebp
8010786c:	c3                   	ret    
8010786d:	8d 76 00             	lea    0x0(%esi),%esi
80107870:	89 c1                	mov    %eax,%ecx
80107872:	8b 55 10             	mov    0x10(%ebp),%edx
80107875:	8b 45 08             	mov    0x8(%ebp),%eax
			return 0;
80107878:	31 ff                	xor    %edi,%edi
8010787a:	e8 41 fb ff ff       	call   801073c0 <deallocuvm.part.0>
8010787f:	eb 92                	jmp    80107813 <allocuvm+0xb3>
80107881:	eb 0d                	jmp    80107890 <deallocuvm>
80107883:	90                   	nop
80107884:	90                   	nop
80107885:	90                   	nop
80107886:	90                   	nop
80107887:	90                   	nop
80107888:	90                   	nop
80107889:	90                   	nop
8010788a:	90                   	nop
8010788b:	90                   	nop
8010788c:	90                   	nop
8010788d:	90                   	nop
8010788e:	90                   	nop
8010788f:	90                   	nop

80107890 <deallocuvm>:
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	8b 55 0c             	mov    0xc(%ebp),%edx
80107896:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107899:	8b 45 08             	mov    0x8(%ebp),%eax
	if (newsz >= oldsz) return oldsz;
8010789c:	39 d1                	cmp    %edx,%ecx
8010789e:	73 10                	jae    801078b0 <deallocuvm+0x20>
}
801078a0:	5d                   	pop    %ebp
801078a1:	e9 1a fb ff ff       	jmp    801073c0 <deallocuvm.part.0>
801078a6:	8d 76 00             	lea    0x0(%esi),%esi
801078a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801078b0:	89 d0                	mov    %edx,%eax
801078b2:	5d                   	pop    %ebp
801078b3:	c3                   	ret    
801078b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801078c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	57                   	push   %edi
801078c4:	56                   	push   %esi
801078c5:	53                   	push   %ebx
801078c6:	83 ec 0c             	sub    $0xc,%esp
801078c9:	8b 75 08             	mov    0x8(%ebp),%esi
	uint i;

	if (pgdir == 0) panic("freevm: no pgdir");
801078cc:	85 f6                	test   %esi,%esi
801078ce:	74 59                	je     80107929 <freevm+0x69>
801078d0:	31 c9                	xor    %ecx,%ecx
801078d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801078d7:	89 f0                	mov    %esi,%eax
801078d9:	e8 e2 fa ff ff       	call   801073c0 <deallocuvm.part.0>
801078de:	89 f3                	mov    %esi,%ebx
801078e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801078e6:	eb 0f                	jmp    801078f7 <freevm+0x37>
801078e8:	90                   	nop
801078e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078f0:	83 c3 04             	add    $0x4,%ebx
	deallocuvm(pgdir, KERNBASE, 0);
	for (i = 0; i < NPDENTRIES; i++) {
801078f3:	39 fb                	cmp    %edi,%ebx
801078f5:	74 23                	je     8010791a <freevm+0x5a>
		if (pgdir[i] & PTE_P) {
801078f7:	8b 03                	mov    (%ebx),%eax
801078f9:	a8 01                	test   $0x1,%al
801078fb:	74 f3                	je     801078f0 <freevm+0x30>
			char *v = P2V(PTE_ADDR(pgdir[i]));
801078fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
			kfree(v);
80107902:	83 ec 0c             	sub    $0xc,%esp
80107905:	83 c3 04             	add    $0x4,%ebx
			char *v = P2V(PTE_ADDR(pgdir[i]));
80107908:	05 00 00 00 80       	add    $0x80000000,%eax
			kfree(v);
8010790d:	50                   	push   %eax
8010790e:	e8 0d aa ff ff       	call   80102320 <kfree>
80107913:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPDENTRIES; i++) {
80107916:	39 fb                	cmp    %edi,%ebx
80107918:	75 dd                	jne    801078f7 <freevm+0x37>
		}
	}
	kfree((char *)pgdir);
8010791a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010791d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107920:	5b                   	pop    %ebx
80107921:	5e                   	pop    %esi
80107922:	5f                   	pop    %edi
80107923:	5d                   	pop    %ebp
	kfree((char *)pgdir);
80107924:	e9 f7 a9 ff ff       	jmp    80102320 <kfree>
	if (pgdir == 0) panic("freevm: no pgdir");
80107929:	83 ec 0c             	sub    $0xc,%esp
8010792c:	68 c9 85 10 80       	push   $0x801085c9
80107931:	e8 5a 8a ff ff       	call   80100390 <panic>
80107936:	8d 76 00             	lea    0x0(%esi),%esi
80107939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107940 <setupkvm>:
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	56                   	push   %esi
80107944:	53                   	push   %ebx
	if ((pgdir = (pde_t *)kalloc()) == 0) return 0;
80107945:	e8 86 ab ff ff       	call   801024d0 <kalloc>
8010794a:	85 c0                	test   %eax,%eax
8010794c:	89 c6                	mov    %eax,%esi
8010794e:	74 42                	je     80107992 <setupkvm+0x52>
	memset(pgdir, 0, PGSIZE);
80107950:	83 ec 04             	sub    $0x4,%esp
	for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107953:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
	memset(pgdir, 0, PGSIZE);
80107958:	68 00 10 00 00       	push   $0x1000
8010795d:	6a 00                	push   $0x0
8010795f:	50                   	push   %eax
80107960:	e8 bb d0 ff ff       	call   80104a20 <memset>
80107965:	83 c4 10             	add    $0x10,%esp
		if (mappages(pgdir, k->virt, k->phys_end - k->phys_start, (uint)k->phys_start, k->perm) < 0) {
80107968:	8b 43 04             	mov    0x4(%ebx),%eax
8010796b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010796e:	83 ec 08             	sub    $0x8,%esp
80107971:	8b 13                	mov    (%ebx),%edx
80107973:	ff 73 0c             	pushl  0xc(%ebx)
80107976:	50                   	push   %eax
80107977:	29 c1                	sub    %eax,%ecx
80107979:	89 f0                	mov    %esi,%eax
8010797b:	e8 b0 f9 ff ff       	call   80107330 <mappages>
80107980:	83 c4 10             	add    $0x10,%esp
80107983:	85 c0                	test   %eax,%eax
80107985:	78 19                	js     801079a0 <setupkvm+0x60>
	for (k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107987:	83 c3 10             	add    $0x10,%ebx
8010798a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107990:	75 d6                	jne    80107968 <setupkvm+0x28>
}
80107992:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107995:	89 f0                	mov    %esi,%eax
80107997:	5b                   	pop    %ebx
80107998:	5e                   	pop    %esi
80107999:	5d                   	pop    %ebp
8010799a:	c3                   	ret    
8010799b:	90                   	nop
8010799c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			freevm(pgdir);
801079a0:	83 ec 0c             	sub    $0xc,%esp
801079a3:	56                   	push   %esi
			return 0;
801079a4:	31 f6                	xor    %esi,%esi
			freevm(pgdir);
801079a6:	e8 15 ff ff ff       	call   801078c0 <freevm>
			return 0;
801079ab:	83 c4 10             	add    $0x10,%esp
}
801079ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079b1:	89 f0                	mov    %esi,%eax
801079b3:	5b                   	pop    %ebx
801079b4:	5e                   	pop    %esi
801079b5:	5d                   	pop    %ebp
801079b6:	c3                   	ret    
801079b7:	89 f6                	mov    %esi,%esi
801079b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079c0 <kvmalloc>:
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	83 ec 08             	sub    $0x8,%esp
	kpgdir = setupkvm();
801079c6:	e8 75 ff ff ff       	call   80107940 <setupkvm>
801079cb:	a3 e4 e2 12 80       	mov    %eax,0x8012e2e4
	lcr3(V2P(kpgdir)); // switch to the kernel page table
801079d0:	05 00 00 00 80       	add    $0x80000000,%eax
801079d5:	0f 22 d8             	mov    %eax,%cr3
}
801079d8:	c9                   	leave  
801079d9:	c3                   	ret    
801079da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801079e0:	55                   	push   %ebp
	pte_t *pte;

	pte = walkpgdir(pgdir, uva, 0);
801079e1:	31 c9                	xor    %ecx,%ecx
{
801079e3:	89 e5                	mov    %esp,%ebp
801079e5:	83 ec 08             	sub    $0x8,%esp
	pte = walkpgdir(pgdir, uva, 0);
801079e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801079eb:	8b 45 08             	mov    0x8(%ebp),%eax
801079ee:	e8 bd f8 ff ff       	call   801072b0 <walkpgdir>
	if (pte == 0) panic("clearpteu");
801079f3:	85 c0                	test   %eax,%eax
801079f5:	74 05                	je     801079fc <clearpteu+0x1c>
	*pte &= ~PTE_U;
801079f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079fa:	c9                   	leave  
801079fb:	c3                   	ret    
	if (pte == 0) panic("clearpteu");
801079fc:	83 ec 0c             	sub    $0xc,%esp
801079ff:	68 da 85 10 80       	push   $0x801085da
80107a04:	e8 87 89 ff ff       	call   80100390 <panic>
80107a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t *
copyuvm(pde_t *pgdir, uint sz)
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	57                   	push   %edi
80107a14:	56                   	push   %esi
80107a15:	53                   	push   %ebx
80107a16:	83 ec 1c             	sub    $0x1c,%esp
	pde_t *d;
	pte_t *pte;
	uint   pa, i, flags;
	char * mem;

	if ((d = setupkvm()) == 0) return 0;
80107a19:	e8 22 ff ff ff       	call   80107940 <setupkvm>
80107a1e:	85 c0                	test   %eax,%eax
80107a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a23:	0f 84 a0 00 00 00    	je     80107ac9 <copyuvm+0xb9>
	for (i = 0; i < sz; i += PGSIZE) {
80107a29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a2c:	85 c9                	test   %ecx,%ecx
80107a2e:	0f 84 95 00 00 00    	je     80107ac9 <copyuvm+0xb9>
80107a34:	31 f6                	xor    %esi,%esi
80107a36:	eb 4e                	jmp    80107a86 <copyuvm+0x76>
80107a38:	90                   	nop
80107a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
		pa    = PTE_ADDR(*pte);
		flags = PTE_FLAGS(*pte);
		if ((mem = kalloc()) == 0) goto bad;
		memmove(mem, (char *)P2V(pa), PGSIZE);
80107a40:	83 ec 04             	sub    $0x4,%esp
80107a43:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a4c:	68 00 10 00 00       	push   $0x1000
80107a51:	57                   	push   %edi
80107a52:	50                   	push   %eax
80107a53:	e8 78 d0 ff ff       	call   80104ad0 <memmove>
		if (mappages(d, (void *)i, PGSIZE, V2P(mem), flags) < 0) goto bad;
80107a58:	58                   	pop    %eax
80107a59:	5a                   	pop    %edx
80107a5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a65:	53                   	push   %ebx
80107a66:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107a6c:	52                   	push   %edx
80107a6d:	89 f2                	mov    %esi,%edx
80107a6f:	e8 bc f8 ff ff       	call   80107330 <mappages>
80107a74:	83 c4 10             	add    $0x10,%esp
80107a77:	85 c0                	test   %eax,%eax
80107a79:	78 39                	js     80107ab4 <copyuvm+0xa4>
	for (i = 0; i < sz; i += PGSIZE) {
80107a7b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a81:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a84:	76 43                	jbe    80107ac9 <copyuvm+0xb9>
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
80107a86:	8b 45 08             	mov    0x8(%ebp),%eax
80107a89:	31 c9                	xor    %ecx,%ecx
80107a8b:	89 f2                	mov    %esi,%edx
80107a8d:	e8 1e f8 ff ff       	call   801072b0 <walkpgdir>
80107a92:	85 c0                	test   %eax,%eax
80107a94:	74 3e                	je     80107ad4 <copyuvm+0xc4>
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
80107a96:	8b 18                	mov    (%eax),%ebx
80107a98:	f6 c3 01             	test   $0x1,%bl
80107a9b:	74 44                	je     80107ae1 <copyuvm+0xd1>
		pa    = PTE_ADDR(*pte);
80107a9d:	89 df                	mov    %ebx,%edi
		flags = PTE_FLAGS(*pte);
80107a9f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
		pa    = PTE_ADDR(*pte);
80107aa5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
		if ((mem = kalloc()) == 0) goto bad;
80107aab:	e8 20 aa ff ff       	call   801024d0 <kalloc>
80107ab0:	85 c0                	test   %eax,%eax
80107ab2:	75 8c                	jne    80107a40 <copyuvm+0x30>
	}
	return d;

bad:
	freevm(d);
80107ab4:	83 ec 0c             	sub    $0xc,%esp
80107ab7:	ff 75 e0             	pushl  -0x20(%ebp)
80107aba:	e8 01 fe ff ff       	call   801078c0 <freevm>
	return 0;
80107abf:	83 c4 10             	add    $0x10,%esp
80107ac2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107acf:	5b                   	pop    %ebx
80107ad0:	5e                   	pop    %esi
80107ad1:	5f                   	pop    %edi
80107ad2:	5d                   	pop    %ebp
80107ad3:	c3                   	ret    
		if ((pte = walkpgdir(pgdir, (void *)i, 0)) == 0) panic("copyuvm: pte should exist");
80107ad4:	83 ec 0c             	sub    $0xc,%esp
80107ad7:	68 e4 85 10 80       	push   $0x801085e4
80107adc:	e8 af 88 ff ff       	call   80100390 <panic>
		if (!(*pte & PTE_P)) panic("copyuvm: page not present");
80107ae1:	83 ec 0c             	sub    $0xc,%esp
80107ae4:	68 fe 85 10 80       	push   $0x801085fe
80107ae9:	e8 a2 88 ff ff       	call   80100390 <panic>
80107aee:	66 90                	xchg   %ax,%ax

80107af0 <uva2ka>:

// PAGEBREAK!
// Map user virtual address to kernel address.
char *
uva2ka(pde_t *pgdir, char *uva)
{
80107af0:	55                   	push   %ebp
	pte_t *pte;

	pte = walkpgdir(pgdir, uva, 0);
80107af1:	31 c9                	xor    %ecx,%ecx
{
80107af3:	89 e5                	mov    %esp,%ebp
80107af5:	83 ec 08             	sub    $0x8,%esp
	pte = walkpgdir(pgdir, uva, 0);
80107af8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107afb:	8b 45 08             	mov    0x8(%ebp),%eax
80107afe:	e8 ad f7 ff ff       	call   801072b0 <walkpgdir>
	if ((*pte & PTE_P) == 0) return 0;
80107b03:	8b 00                	mov    (%eax),%eax
	if ((*pte & PTE_U) == 0) return 0;
	return (char *)P2V(PTE_ADDR(*pte));
}
80107b05:	c9                   	leave  
	if ((*pte & PTE_U) == 0) return 0;
80107b06:	89 c2                	mov    %eax,%edx
	return (char *)P2V(PTE_ADDR(*pte));
80107b08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if ((*pte & PTE_U) == 0) return 0;
80107b0d:	83 e2 05             	and    $0x5,%edx
	return (char *)P2V(PTE_ADDR(*pte));
80107b10:	05 00 00 00 80       	add    $0x80000000,%eax
80107b15:	83 fa 05             	cmp    $0x5,%edx
80107b18:	ba 00 00 00 00       	mov    $0x0,%edx
80107b1d:	0f 45 c2             	cmovne %edx,%eax
}
80107b20:	c3                   	ret    
80107b21:	eb 0d                	jmp    80107b30 <copyout>
80107b23:	90                   	nop
80107b24:	90                   	nop
80107b25:	90                   	nop
80107b26:	90                   	nop
80107b27:	90                   	nop
80107b28:	90                   	nop
80107b29:	90                   	nop
80107b2a:	90                   	nop
80107b2b:	90                   	nop
80107b2c:	90                   	nop
80107b2d:	90                   	nop
80107b2e:	90                   	nop
80107b2f:	90                   	nop

80107b30 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b30:	55                   	push   %ebp
80107b31:	89 e5                	mov    %esp,%ebp
80107b33:	57                   	push   %edi
80107b34:	56                   	push   %esi
80107b35:	53                   	push   %ebx
80107b36:	83 ec 1c             	sub    $0x1c,%esp
80107b39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b3f:	8b 7d 10             	mov    0x10(%ebp),%edi
	char *buf, *pa0;
	uint  n, va0;

	buf = (char *)p;
	while (len > 0) {
80107b42:	85 db                	test   %ebx,%ebx
80107b44:	75 40                	jne    80107b86 <copyout+0x56>
80107b46:	eb 70                	jmp    80107bb8 <copyout+0x88>
80107b48:	90                   	nop
80107b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		va0 = (uint)PGROUNDDOWN(va);
		pa0 = uva2ka(pgdir, (char *)va0);
		if (pa0 == 0) return -1;
		n = PGSIZE - (va - va0);
80107b50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b53:	89 f1                	mov    %esi,%ecx
80107b55:	29 d1                	sub    %edx,%ecx
80107b57:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107b5d:	39 d9                	cmp    %ebx,%ecx
80107b5f:	0f 47 cb             	cmova  %ebx,%ecx
		if (n > len) n= len;
		memmove(pa0 + (va - va0), buf, n);
80107b62:	29 f2                	sub    %esi,%edx
80107b64:	83 ec 04             	sub    $0x4,%esp
80107b67:	01 d0                	add    %edx,%eax
80107b69:	51                   	push   %ecx
80107b6a:	57                   	push   %edi
80107b6b:	50                   	push   %eax
80107b6c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107b6f:	e8 5c cf ff ff       	call   80104ad0 <memmove>
		len -= n;
		buf += n;
80107b74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
	while (len > 0) {
80107b77:	83 c4 10             	add    $0x10,%esp
		va = va0 + PGSIZE;
80107b7a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
		buf += n;
80107b80:	01 cf                	add    %ecx,%edi
	while (len > 0) {
80107b82:	29 cb                	sub    %ecx,%ebx
80107b84:	74 32                	je     80107bb8 <copyout+0x88>
		va0 = (uint)PGROUNDDOWN(va);
80107b86:	89 d6                	mov    %edx,%esi
		pa0 = uva2ka(pgdir, (char *)va0);
80107b88:	83 ec 08             	sub    $0x8,%esp
		va0 = (uint)PGROUNDDOWN(va);
80107b8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107b8e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		pa0 = uva2ka(pgdir, (char *)va0);
80107b94:	56                   	push   %esi
80107b95:	ff 75 08             	pushl  0x8(%ebp)
80107b98:	e8 53 ff ff ff       	call   80107af0 <uva2ka>
		if (pa0 == 0) return -1;
80107b9d:	83 c4 10             	add    $0x10,%esp
80107ba0:	85 c0                	test   %eax,%eax
80107ba2:	75 ac                	jne    80107b50 <copyout+0x20>
	}
	return 0;
}
80107ba4:	8d 65 f4             	lea    -0xc(%ebp),%esp
		if (pa0 == 0) return -1;
80107ba7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bac:	5b                   	pop    %ebx
80107bad:	5e                   	pop    %esi
80107bae:	5f                   	pop    %edi
80107baf:	5d                   	pop    %ebp
80107bb0:	c3                   	ret    
80107bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
80107bbb:	31 c0                	xor    %eax,%eax
}
80107bbd:	5b                   	pop    %ebx
80107bbe:	5e                   	pop    %esi
80107bbf:	5f                   	pop    %edi
80107bc0:	5d                   	pop    %ebp
80107bc1:	c3                   	ret    
