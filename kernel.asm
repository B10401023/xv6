
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2e 10 80       	mov    $0x80102e60,%eax
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

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 76 10 80       	push   $0x801076a0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 15 47 00 00       	call   80104770 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 76 10 80       	push   $0x801076a7
80100097:	50                   	push   %eax
80100098:	e8 c3 45 00 00       	call   80104660 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
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
struct buf*
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
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 87 47 00 00       	call   80104870 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 29 48 00 00       	call   80104990 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 45 00 00       	call   801046a0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
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
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 76 10 80       	push   $0x801076ae
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 8d 45 00 00       	call   80104740 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 76 10 80       	push   $0x801076bf
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
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
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 4c 45 00 00       	call   80104740 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 44 00 00       	call   80104700 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 60 46 00 00       	call   80104870 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 2f 47 00 00       	jmp    80104990 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 76 10 80       	push   $0x801076c6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
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
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 df 45 00 00       	call   80104870 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 de 3a 00 00       	call   80103da0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 d9 34 00 00       	call   801037b0 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 a5 46 00 00       	call   80104990 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 45 46 00 00       	call   80104990 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 62 23 00 00       	call   801026f0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 cd 76 10 80       	push   $0x801076cd
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 2f 80 10 80 	movl   $0x8010802f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 d3 43 00 00       	call   80104790 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 e1 76 10 80       	push   $0x801076e1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 41 5e 00 00       	call   80106260 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 88 5d 00 00       	call   80106260 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 7c 5d 00 00       	call   80106260 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 70 5d 00 00       	call   80106260 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 77 45 00 00       	call   80104a90 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 b2 44 00 00       	call   801049e0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 e5 76 10 80       	push   $0x801076e5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 10 77 10 80 	movzbl -0x7fef88f0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 50 42 00 00       	call   80104870 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 44 43 00 00       	call   80104990 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

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
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 7e 42 00 00       	call   80104990 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 f8 76 10 80       	mov    $0x801076f8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 a3 40 00 00       	call   80104870 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 ff 76 10 80       	push   $0x801076ff
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 68 40 00 00       	call   80104870 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 23 41 00 00       	call   80104990 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 05 38 00 00       	call   80104100 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 74 38 00 00       	jmp    801041f0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 08 77 10 80       	push   $0x80107708
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 bb 3d 00 00       	call   80104770 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 c2 18 00 00       	call   801022a0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 af 2d 00 00       	call   801037b0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 44 21 00 00       	call   80102b50 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 a9 14 00 00       	call   80101ec0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 43 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 12 0f 00 00       	call   80101950 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 b1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a4f:	e8 6c 21 00 00       	call   80102bc0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 77 69 00 00       	call   801073f0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 83 0e 00 00       	call   80101950 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 37 67 00 00       	call   80107240 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 41 66 00 00       	call   80107180 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 12 68 00 00       	call   80107370 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 91 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b6f:	e8 4c 20 00 00       	call   80102bc0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 a6 66 00 00       	call   80107240 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 bf 67 00 00       	call   80107370 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 fd 1f 00 00       	call   80102bc0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 21 77 10 80       	push   $0x80107721
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 9a 68 00 00       	call   80107490 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 ee 3f 00 00       	call   80104c20 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 db 3f 00 00       	call   80104c20 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 9a 69 00 00       	call   801075f0 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 30 69 00 00       	call   801075f0 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 6c             	add    $0x6c,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 db 3e 00 00       	call   80104be0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 18             	mov    0x18(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 18             	mov    0x18(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 bf 62 00 00       	call   80106ff0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 37 66 00 00       	call   80107370 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 2d 77 10 80       	push   $0x8010772d
80100d5b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d60:	e8 0b 3a 00 00       	call   80104770 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 c0 0f 11 80       	push   $0x80110fc0
80100d81:	e8 ea 3a 00 00       	call   80104870 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 c0 0f 11 80       	push   $0x80110fc0
80100db1:	e8 da 3b 00 00       	call   80104990 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc8:	e8 c3 3b 00 00       	call   80104990 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 c0 0f 11 80       	push   $0x80110fc0
80100def:	e8 7c 3a 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0c:	e8 7f 3b 00 00       	call   80104990 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 34 77 10 80       	push   $0x80107734
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 2a 3a 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 1f 3b 00 00       	jmp    80104990 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 f3 3a 00 00       	call   80104990 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 2a 24 00 00       	call   801032f0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 7b 1c 00 00       	call   80102b50 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 d1 1c 00 00       	jmp    80102bc0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 3c 77 10 80       	push   $0x8010773c
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 f9 09 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 06 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 c4 09 00 00       	call   80101950 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 07 00 00       	call   80101750 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 ce 24 00 00       	jmp    80103490 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 46 77 10 80       	push   $0x80107746
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 07 00 00       	call   80101750 <iunlock>
      end_op();
80101039:	e8 82 1b 00 00       	call   80102bc0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 e5 1a 00 00       	call   80102b50 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 05 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 c8 09 00 00       	call   80101a50 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010109d:	e8 1e 1b 00 00       	call   80102bc0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 af 22 00 00       	jmp    80103390 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 4f 77 10 80       	push   $0x8010774f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 55 77 10 80       	push   $0x80107755
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 5f 77 10 80       	push   $0x8010775f
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 6e 1b 00 00       	call   80102d30 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 f6 37 00 00       	call   801049e0 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 3e 1b 00 00       	call   80102d30 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 e0 19 11 80       	push   $0x801119e0
8010122a:	e8 41 36 00 00       	call   80104870 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 19 37 00 00       	call   80104990 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 e0 19 11 80       	push   $0x801119e0
801012bf:	e8 cc 36 00 00       	call   80104990 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 75 77 10 80       	push   $0x80107775
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 de 19 00 00       	call   80102d30 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 85 77 10 80       	push   $0x80107785
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 ba 36 00 00       	call   80104a90 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 c0 19 11 80       	push   $0x801119c0
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 df 18 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 98 77 10 80       	push   $0x80107798
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 ab 77 10 80       	push   $0x801077ab
80101481:	68 e0 19 11 80       	push   $0x801119e0
80101486:	e8 e5 32 00 00       	call   80104770 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 b2 77 10 80       	push   $0x801077b2
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 bc 31 00 00       	call   80104660 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 c0 19 11 80       	push   $0x801119c0
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014c5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014cb:	ff 35 d0 19 11 80    	pushl  0x801119d0
801014d1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801014d7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801014dd:	ff 35 c4 19 11 80    	pushl  0x801119c4
801014e3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801014e9:	68 18 78 10 80       	push   $0x80107818
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 5d 34 00 00       	call   801049e0 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 9b 17 00 00       	call   80102d30 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 b8 77 10 80       	push   $0x801077b8
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 6a 34 00 00       	call   80104a90 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 02 17 00 00       	call   80102d30 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 e0 19 11 80       	push   $0x801119e0
8010164f:	e8 1c 32 00 00       	call   80104870 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010165f:	e8 2c 33 00 00       	call   80104990 <release>
  return ip;
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 09 30 00 00       	call   801046a0 <acquiresleep>

  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 83 33 00 00       	call   80104a90 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 d0 77 10 80       	push   $0x801077d0
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 ca 77 10 80       	push   $0x801077ca
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 d8 2f 00 00       	call   80104740 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010177f:	e9 7c 2f 00 00       	jmp    80104700 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 df 77 10 80       	push   $0x801077df
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 eb 2e 00 00       	call   801046a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 31 2f 00 00       	call   80104700 <releasesleep>

  acquire(&icache.lock);
801017cf:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017d6:	e8 95 30 00 00       	call   80104870 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017f0:	e9 9b 31 00 00       	jmp    80104990 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 e0 19 11 80       	push   $0x801119e0
80101800:	e8 6b 30 00 00       	call   80104870 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010180f:	e8 7c 31 00 00       	call   80104990 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    }
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 c1 00 00 00    	jb     80101a48 <readi+0xf8>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 fa                	mov    %edi,%edx
8010198c:	01 f2                	add    %esi,%edx
8010198e:	0f 82 b4 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c1                	mov    %eax,%ecx
80101996:	29 f1                	sub    %esi,%ecx
80101998:	39 d0                	cmp    %edx,%eax
8010199a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6d                	je     80101a13 <readi+0xc3>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ca:	e8 01 e7 ff ff       	call   801000d0 <bread>
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d4:	89 f1                	mov    %esi,%ecx
801019d6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019dc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e2:	29 cb                	sub    %ecx,%ebx
801019e4:	29 f8                	sub    %edi,%eax
801019e6:	39 c3                	cmp    %eax,%ebx
801019e8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019eb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019ef:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
801019f2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f4:	50                   	push   %eax
801019f5:	ff 75 e0             	pushl  -0x20(%ebp)
801019f8:	e8 93 30 00 00       	call   80104a90 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a11:	77 9d                	ja     801019b0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a19:	5b                   	pop    %ebx
80101a1a:	5e                   	pop    %esi
80101a1b:	5f                   	pop    %edi
80101a1c:	5d                   	pop    %ebp
80101a1d:	c3                   	ret    
80101a1e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c7                	jmp    80101a16 <readi+0xc6>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
80101a85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a88:	89 f8                	mov    %edi,%eax
80101a8a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a8c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a91:	0f 87 d9 00 00 00    	ja     80101b70 <writei+0x120>
80101a97:	39 c6                	cmp    %eax,%esi
80101a99:	0f 87 d1 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9f:	85 ff                	test   %edi,%edi
80101aa1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa8:	74 78                	je     80101b22 <writei+0xd2>
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aba:	c1 ea 09             	shr    $0x9,%edx
80101abd:	89 f8                	mov    %edi,%eax
80101abf:	e8 1c f8 ff ff       	call   801012e0 <bmap>
80101ac4:	83 ec 08             	sub    $0x8,%esp
80101ac7:	50                   	push   %eax
80101ac8:	ff 37                	pushl  (%edi)
80101aca:	e8 01 e6 ff ff       	call   801000d0 <bread>
80101acf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ad4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ad7:	89 f1                	mov    %esi,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ae2:	29 cb                	sub    %ecx,%ebx
80101ae4:	39 c3                	cmp    %eax,%ebx
80101ae6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aed:	53                   	push   %ebx
80101aee:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	50                   	push   %eax
80101af4:	e8 97 2f 00 00       	call   80104a90 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 2f 12 00 00       	call   80102d30 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0f:	83 c4 10             	add    $0x10,%esp
80101b12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b15:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b18:	77 96                	ja     80101ab0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b20:	77 36                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b6                	jmp    80101b22 <writei+0xd2>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ae                	jmp    80101b25 <writei+0xd5>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 7d 2f 00 00       	call   80104b10 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 16 2f 00 00       	call   80104b10 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 f9 77 10 80       	push   $0x801077f9
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 e7 77 10 80       	push   $0x801077e7
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c63:	0f 84 53 01 00 00    	je     80101dbc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 42 1b 00 00       	call   801037b0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c71:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c74:	68 e0 19 11 80       	push   $0x801119e0
80101c79:	e8 f2 2b 00 00       	call   80104870 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c89:	e8 02 2d 00 00       	call   80104990 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
    path++;
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 a6 2d 00 00       	call   80104a90 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a3 00 00 00    	je     80101dd2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 17 2d 00 00       	call   80104a90 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 54                	jne    80101de8 <namex+0x198>
80101d94:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
80101daa:	e8 f1 f9 ff ff       	call   801017a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101daf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101db5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dbc:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc1:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc6:	e8 45 f4 ff ff       	call   80101210 <iget>
80101dcb:	89 c6                	mov    %eax,%esi
80101dcd:	e9 c9 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	56                   	push   %esi
80101dd6:	e8 75 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101de1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de3:	5b                   	pop    %ebx
80101de4:	5e                   	pop    %esi
80101de5:	5f                   	pop    %edi
80101de6:	5d                   	pop    %ebp
80101de7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 af f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	31 c0                	xor    %eax,%eax
80101df6:	eb 9e                	jmp    80101d96 <namex+0x146>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 1e 2d 00 00       	call   80104b80 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 08 78 10 80       	push   $0x80107808
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 16 7e 10 80       	push   $0x80107e16
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	66 90                	xchg   %ax,%ax
80101ef6:	66 90                	xchg   %ax,%ax
80101ef8:	66 90                	xchg   %ax,%ax
80101efa:	66 90                	xchg   %ax,%ax
80101efc:	66 90                	xchg   %ax,%ax
80101efe:	66 90                	xchg   %ax,%ax

80101f00 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f00:	55                   	push   %ebp
  if(b == 0)
80101f01:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	56                   	push   %esi
80101f06:	53                   	push   %ebx
  if(b == 0)
80101f07:	0f 84 ad 00 00 00    	je     80101fba <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f0d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f10:	89 c1                	mov    %eax,%ecx
80101f12:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f18:	0f 87 8f 00 00 00    	ja     80101fad <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f28:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f29:	83 e0 c0             	and    $0xffffffc0,%eax
80101f2c:	3c 40                	cmp    $0x40,%al
80101f2e:	75 f8                	jne    80101f28 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f30:	31 f6                	xor    %esi,%esi
80101f32:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f37:	89 f0                	mov    %esi,%eax
80101f39:	ee                   	out    %al,(%dx)
80101f3a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f44:	ee                   	out    %al,(%dx)
80101f45:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f4a:	89 d8                	mov    %ebx,%eax
80101f4c:	ee                   	out    %al,(%dx)
80101f4d:	89 d8                	mov    %ebx,%eax
80101f4f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f54:	c1 f8 08             	sar    $0x8,%eax
80101f57:	ee                   	out    %al,(%dx)
80101f58:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f5d:	89 f0                	mov    %esi,%eax
80101f5f:	ee                   	out    %al,(%dx)
80101f60:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f64:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f69:	83 e0 01             	and    $0x1,%eax
80101f6c:	c1 e0 04             	shl    $0x4,%eax
80101f6f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f72:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f73:	f6 01 04             	testb  $0x4,(%ecx)
80101f76:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f7b:	75 13                	jne    80101f90 <idestart+0x90>
80101f7d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f82:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f86:	5b                   	pop    %ebx
80101f87:	5e                   	pop    %esi
80101f88:	5d                   	pop    %ebp
80101f89:	c3                   	ret    
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f90:	b8 30 00 00 00       	mov    $0x30,%eax
80101f95:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f96:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f9b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f9e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fa3:	fc                   	cld    
80101fa4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fa9:	5b                   	pop    %ebx
80101faa:	5e                   	pop    %esi
80101fab:	5d                   	pop    %ebp
80101fac:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fad:	83 ec 0c             	sub    $0xc,%esp
80101fb0:	68 74 78 10 80       	push   $0x80107874
80101fb5:	e8 b6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 6b 78 10 80       	push   $0x8010786b
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fd6:	68 86 78 10 80       	push   $0x80107886
80101fdb:	68 80 b5 10 80       	push   $0x8010b580
80101fe0:	e8 8b 27 00 00       	call   80104770 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe5:	58                   	pop    %eax
80101fe6:	a1 00 3d 11 80       	mov    0x80113d00,%eax
80101feb:	5a                   	pop    %edx
80101fec:	83 e8 01             	sub    $0x1,%eax
80101fef:	50                   	push   %eax
80101ff0:	6a 0e                	push   $0xe
80101ff2:	e8 a9 02 00 00       	call   801022a0 <ioapicenable>
80101ff7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ffa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fff:	90                   	nop
80102000:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x55>
8010201f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x64>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x50>
      havedisk1 = 1;
8010202a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102031:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 80 b5 10 80       	push   $0x8010b580
8010205e:	e8 0d 28 00 00       	call   80104870 <acquire>

  if((b = idequeue) == 0){
80102063:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 6d 20 00 00       	call   80104100 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 5c fe ff ff       	call   80101f00 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 80 b5 10 80       	push   $0x8010b580
801020ac:	e8 df 28 00 00       	call   80104990 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 3d 26 00 00       	call   80104740 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 80 b5 10 80       	push   $0x8010b580
80102138:	e8 33 27 00 00       	call   80104870 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102143:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 80 b5 10 80       	push   $0x8010b580
80102188:	53                   	push   %ebx
80102189:	e8 12 1c 00 00       	call   80103da0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010219b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021a6:	e9 e5 27 00 00       	jmp    80104990 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 47 fd ff ff       	call   80101f00 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 8a 78 10 80       	push   $0x8010788a
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 b5 78 10 80       	push   $0x801078b5
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 a0 78 10 80       	push   $0x801078a0
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f1:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801021f8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fb:	89 e5                	mov    %esp,%ebp
801021fd:	56                   	push   %esi
801021fe:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102206:	00 00 00 
  return ioapic->data;
80102209:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010220f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102212:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102218:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010221e:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102225:	89 f0                	mov    %esi,%eax
80102227:	c1 e8 10             	shr    $0x10,%eax
8010222a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010222d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102230:	c1 e8 18             	shr    $0x18,%eax
80102233:	39 d0                	cmp    %edx,%eax
80102235:	74 16                	je     8010224d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 d4 78 10 80       	push   $0x801078d4
8010223f:	e8 1c e4 ff ff       	call   80100660 <cprintf>
80102244:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	ba 10 00 00 00       	mov    $0x10,%edx
80102255:	b8 20 00 00 00       	mov    $0x20,%eax
8010225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102260:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102262:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102270:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102273:	89 59 10             	mov    %ebx,0x10(%ecx)
80102276:	8d 5a 01             	lea    0x1(%edx),%ebx
80102279:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102280:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102286:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228d:	75 d1                	jne    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102292:	5b                   	pop    %ebx
80102293:	5e                   	pop    %esi
80102294:	5d                   	pop    %ebp
80102295:	c3                   	ret    
80102296:	8d 76 00             	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ac:	8d 50 20             	lea    0x20(%eax),%edx
801022af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022be:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c6:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022cb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022ce:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret    
801022d3:	66 90                	xchg   %ax,%ax
801022d5:	66 90                	xchg   %ax,%ax
801022d7:	66 90                	xchg   %ax,%ax
801022d9:	66 90                	xchg   %ax,%ax
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 04             	sub    $0x4,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 70                	jne    80102362 <kfree+0x82>
801022f2:	81 fb a8 6a 11 80    	cmp    $0x80116aa8,%ebx
801022f8:	72 68                	jb     80102362 <kfree+0x82>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 5b                	ja     80102362 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	83 ec 04             	sub    $0x4,%esp
8010230a:	68 00 10 00 00       	push   $0x1000
8010230f:	6a 01                	push   $0x1
80102311:	53                   	push   %ebx
80102312:	e8 c9 26 00 00       	call   801049e0 <memset>

  if(kmem.use_lock)
80102317:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 d2                	test   %edx,%edx
80102322:	75 2c                	jne    80102350 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102324:	a1 78 36 11 80       	mov    0x80113678,%eax
80102329:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010232b:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102330:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
80102336:	85 c0                	test   %eax,%eax
80102338:	75 06                	jne    80102340 <kfree+0x60>
    release(&kmem.lock);
}
8010233a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    
8010233f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102340:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010234b:	e9 40 26 00 00       	jmp    80104990 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 40 36 11 80       	push   $0x80113640
80102358:	e8 13 25 00 00       	call   80104870 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	eb c2                	jmp    80102324 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102362:	83 ec 0c             	sub    $0xc,%esp
80102365:	68 06 79 10 80       	push   $0x80107906
8010236a:	e8 01 e0 ff ff       	call   80100370 <panic>
8010236f:	90                   	nop

80102370 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102378:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010237b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102381:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102387:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010238d:	39 de                	cmp    %ebx,%esi
8010238f:	72 23                	jb     801023b4 <freerange+0x44>
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102398:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010239e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023a7:	50                   	push   %eax
801023a8:	e8 33 ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	39 f3                	cmp    %esi,%ebx
801023b2:	76 e4                	jbe    80102398 <freerange+0x28>
    kfree(p);
}
801023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5e                   	pop    %esi
801023b9:	5d                   	pop    %ebp
801023ba:	c3                   	ret    
801023bb:	90                   	nop
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023c8:	83 ec 08             	sub    $0x8,%esp
801023cb:	68 0c 79 10 80       	push   $0x8010790c
801023d0:	68 40 36 11 80       	push   $0x80113640
801023d5:	e8 96 23 00 00       	call   80104770 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023e0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801023e7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fc:	39 de                	cmp    %ebx,%esi
801023fe:	72 1c                	jb     8010241c <kinit1+0x5c>
    kfree(p);
80102400:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102406:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102409:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010240f:	50                   	push   %eax
80102410:	e8 cb fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	39 de                	cmp    %ebx,%esi
8010241a:	73 e4                	jae    80102400 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010241f:	5b                   	pop    %ebx
80102420:	5e                   	pop    %esi
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102438:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102441:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102447:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244d:	39 de                	cmp    %ebx,%esi
8010244f:	72 23                	jb     80102474 <kinit2+0x44>
80102451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102458:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010245e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102467:	50                   	push   %eax
80102468:	e8 73 fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 e4                	jae    80102458 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102474:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010247b:	00 00 00 
}
8010247e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 74 36 11 80       	mov    0x80113674,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 1c                	je     801024c6 <kalloc+0x36>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 10                	je     801024c6 <kalloc+0x36>
    release(&kmem.lock);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	68 40 36 11 80       	push   $0x80113640
801024be:	e8 cd 24 00 00       	call   80104990 <release>
801024c3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024c6:	89 d8                	mov    %ebx,%eax
801024c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    
801024cd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 40 36 11 80       	push   $0x80113640
801024d8:	e8 93 23 00 00       	call   80104870 <acquire>
  r = kmem.freelist;
801024dd:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
801024e3:	83 c4 10             	add    $0x10,%esp
801024e6:	a1 74 36 11 80       	mov    0x80113674,%eax
801024eb:	85 db                	test   %ebx,%ebx
801024ed:	75 bb                	jne    801024aa <kalloc+0x1a>
801024ef:	eb c1                	jmp    801024b2 <kalloc+0x22>
801024f1:	66 90                	xchg   %ax,%ax
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102500:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102501:	ba 64 00 00 00       	mov    $0x64,%edx
80102506:	89 e5                	mov    %esp,%ebp
80102508:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102509:	a8 01                	test   $0x1,%al
8010250b:	0f 84 af 00 00 00    	je     801025c0 <kbdgetc+0xc0>
80102511:	ba 60 00 00 00       	mov    $0x60,%edx
80102516:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102517:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010251a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102520:	74 7e                	je     801025a0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102522:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010252a:	79 24                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010252c:	f6 c1 40             	test   $0x40,%cl
8010252f:	75 05                	jne    80102536 <kbdgetc+0x36>
80102531:	89 c2                	mov    %eax,%edx
80102533:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102536:	0f b6 82 40 7a 10 80 	movzbl -0x7fef85c0(%edx),%eax
8010253d:	83 c8 40             	or     $0x40,%eax
80102540:	0f b6 c0             	movzbl %al,%eax
80102543:	f7 d0                	not    %eax
80102545:	21 c8                	and    %ecx,%eax
80102547:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
8010254c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010254e:	5d                   	pop    %ebp
8010254f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102550:	f6 c1 40             	test   $0x40,%cl
80102553:	74 09                	je     8010255e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102558:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010255e:	0f b6 82 40 7a 10 80 	movzbl -0x7fef85c0(%edx),%eax
80102565:	09 c1                	or     %eax,%ecx
80102567:	0f b6 82 40 79 10 80 	movzbl -0x7fef86c0(%edx),%eax
8010256e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102570:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102572:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102578:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010257b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257e:	8b 04 85 20 79 10 80 	mov    -0x7fef86e0(,%eax,4),%eax
80102585:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102589:	74 c3                	je     8010254e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010258b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010258e:	83 fa 19             	cmp    $0x19,%edx
80102591:	77 1d                	ja     801025b0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102593:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102596:	5d                   	pop    %ebp
80102597:	c3                   	ret    
80102598:	90                   	nop
80102599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025a0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a2:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025b3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025b6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025b7:	83 f9 19             	cmp    $0x19,%ecx
801025ba:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c5:	5d                   	pop    %ebp
801025c6:	c3                   	ret    
801025c7:	89 f6                	mov    %esi,%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025d0 <kbdintr>:

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025d6:	68 00 25 10 80       	push   $0x80102500
801025db:	e8 10 e2 ff ff       	call   801007f0 <consoleintr>
}
801025e0:	83 c4 10             	add    $0x10,%esp
801025e3:	c9                   	leave  
801025e4:	c3                   	ret    
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025f0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025f5:	55                   	push   %ebp
801025f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025f8:	85 c0                	test   %eax,%eax
801025fa:	0f 84 c8 00 00 00    	je     801026c8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102600:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102607:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102614:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102617:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010261a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102621:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102624:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102627:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010262e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102631:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102634:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010263b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102641:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102648:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010264e:	8b 50 30             	mov    0x30(%eax),%edx
80102651:	c1 ea 10             	shr    $0x10,%edx
80102654:	80 fa 03             	cmp    $0x3,%dl
80102657:	77 77                	ja     801026d0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102659:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102660:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102663:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102666:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102670:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102673:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102687:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
801026a7:	89 f6                	mov    %esi,%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026b6:	80 e6 10             	and    $0x10,%dh
801026b9:	75 f5                	jne    801026b0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026c8:	5d                   	pop    %ebp
801026c9:	c3                   	ret    
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
801026dd:	e9 77 ff ff ff       	jmp    80102659 <lapicinit+0x69>
801026e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026f0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026f0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026f8:	85 c0                	test   %eax,%eax
801026fa:	74 0c                	je     80102708 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ff:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102700:	c1 e8 18             	shr    $0x18,%eax
}
80102703:	c3                   	ret    
80102704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102708:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010270a:	5d                   	pop    %ebp
8010270b:	c3                   	ret    
8010270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102710 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102710:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102715:	55                   	push   %ebp
80102716:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102718:	85 c0                	test   %eax,%eax
8010271a:	74 0d                	je     80102729 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102723:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102726:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102729:	5d                   	pop    %ebp
8010272a:	c3                   	ret    
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102730 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
}
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret    
80102735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102740:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102741:	ba 70 00 00 00       	mov    $0x70,%edx
80102746:	b8 0f 00 00 00       	mov    $0xf,%eax
8010274b:	89 e5                	mov    %esp,%ebp
8010274d:	53                   	push   %ebx
8010274e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102751:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102754:	ee                   	out    %al,(%dx)
80102755:	ba 71 00 00 00       	mov    $0x71,%edx
8010275a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010275f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102760:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102762:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102765:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010276b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010276d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102770:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102773:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102775:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102778:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102783:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102789:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102793:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102799:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ac:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ca:	5b                   	pop    %ebx
801027cb:	5d                   	pop    %ebp
801027cc:	c3                   	ret    
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801027d0:	55                   	push   %ebp
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	57                   	push   %edi
801027de:	56                   	push   %esi
801027df:	53                   	push   %ebx
801027e0:	83 ec 4c             	sub    $0x4c,%esp
801027e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e4:	ba 71 00 00 00       	mov    $0x71,%edx
801027e9:	ec                   	in     (%dx),%al
801027ea:	83 e0 04             	and    $0x4,%eax
801027ed:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f0:	31 db                	xor    %ebx,%ebx
801027f2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027f5:	bf 70 00 00 00       	mov    $0x70,%edi
801027fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102800:	89 d8                	mov    %ebx,%eax
80102802:	89 fa                	mov    %edi,%edx
80102804:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102805:	b9 71 00 00 00       	mov    $0x71,%ecx
8010280a:	89 ca                	mov    %ecx,%edx
8010280c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010280d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102810:	89 fa                	mov    %edi,%edx
80102812:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102815:	b8 02 00 00 00       	mov    $0x2,%eax
8010281a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281b:	89 ca                	mov    %ecx,%edx
8010281d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010281e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	89 fa                	mov    %edi,%edx
80102823:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102826:	b8 04 00 00 00       	mov    $0x4,%eax
8010282b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282c:	89 ca                	mov    %ecx,%edx
8010282e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010282f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102832:	89 fa                	mov    %edi,%edx
80102834:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102837:	b8 07 00 00 00       	mov    $0x7,%eax
8010283c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	89 ca                	mov    %ecx,%edx
8010283f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102840:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102843:	89 fa                	mov    %edi,%edx
80102845:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102848:	b8 08 00 00 00       	mov    $0x8,%eax
8010284d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284e:	89 ca                	mov    %ecx,%edx
80102850:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102851:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102854:	89 fa                	mov    %edi,%edx
80102856:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102859:	b8 09 00 00 00       	mov    $0x9,%eax
8010285e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285f:	89 ca                	mov    %ecx,%edx
80102861:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102862:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102865:	89 fa                	mov    %edi,%edx
80102867:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010286a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010286f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	89 ca                	mov    %ecx,%edx
80102872:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102873:	84 c0                	test   %al,%al
80102875:	78 89                	js     80102800 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102877:	89 d8                	mov    %ebx,%eax
80102879:	89 fa                	mov    %edi,%edx
8010287b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010287f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 fa                	mov    %edi,%edx
80102884:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102887:	b8 02 00 00 00       	mov    $0x2,%eax
8010288c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288d:	89 ca                	mov    %ecx,%edx
8010288f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102890:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102893:	89 fa                	mov    %edi,%edx
80102895:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028a1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 fa                	mov    %edi,%edx
801028a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028a9:	b8 07 00 00 00       	mov    $0x7,%eax
801028ae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028af:	89 ca                	mov    %ecx,%edx
801028b1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028b2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b5:	89 fa                	mov    %edi,%edx
801028b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028ba:	b8 08 00 00 00       	mov    $0x8,%eax
801028bf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028c3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c6:	89 fa                	mov    %edi,%edx
801028c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028cb:	b8 09 00 00 00       	mov    $0x9,%eax
801028d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d1:	89 ca                	mov    %ecx,%edx
801028d3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028d4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028d7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028dd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028e0:	6a 18                	push   $0x18
801028e2:	56                   	push   %esi
801028e3:	50                   	push   %eax
801028e4:	e8 47 21 00 00       	call   80104a30 <memcmp>
801028e9:	83 c4 10             	add    $0x10,%esp
801028ec:	85 c0                	test   %eax,%eax
801028ee:	0f 85 0c ff ff ff    	jne    80102800 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028f4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028f8:	75 78                	jne    80102972 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028fd:	89 c2                	mov    %eax,%edx
801028ff:	83 e0 0f             	and    $0xf,%eax
80102902:	c1 ea 04             	shr    $0x4,%edx
80102905:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102908:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010290e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102911:	89 c2                	mov    %eax,%edx
80102913:	83 e0 0f             	and    $0xf,%eax
80102916:	c1 ea 04             	shr    $0x4,%edx
80102919:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102922:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102925:	89 c2                	mov    %eax,%edx
80102927:	83 e0 0f             	and    $0xf,%eax
8010292a:	c1 ea 04             	shr    $0x4,%edx
8010292d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102930:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102933:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102936:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102939:	89 c2                	mov    %eax,%edx
8010293b:	83 e0 0f             	and    $0xf,%eax
8010293e:	c1 ea 04             	shr    $0x4,%edx
80102941:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102944:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102947:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010294a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010294d:	89 c2                	mov    %eax,%edx
8010294f:	83 e0 0f             	and    $0xf,%eax
80102952:	c1 ea 04             	shr    $0x4,%edx
80102955:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102958:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102961:	89 c2                	mov    %eax,%edx
80102963:	83 e0 0f             	and    $0xf,%eax
80102966:	c1 ea 04             	shr    $0x4,%edx
80102969:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102972:	8b 75 08             	mov    0x8(%ebp),%esi
80102975:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102978:	89 06                	mov    %eax,(%esi)
8010297a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010297d:	89 46 04             	mov    %eax,0x4(%esi)
80102980:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102983:	89 46 08             	mov    %eax,0x8(%esi)
80102986:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102989:	89 46 0c             	mov    %eax,0xc(%esi)
8010298c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010298f:	89 46 10             	mov    %eax,0x10(%esi)
80102992:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102995:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102998:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010299f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029a2:	5b                   	pop    %ebx
801029a3:	5e                   	pop    %esi
801029a4:	5f                   	pop    %edi
801029a5:	5d                   	pop    %ebp
801029a6:	c3                   	ret    
801029a7:	66 90                	xchg   %ax,%ax
801029a9:	66 90                	xchg   %ax,%ax
801029ab:	66 90                	xchg   %ax,%ax
801029ad:	66 90                	xchg   %ax,%ax
801029af:	90                   	nop

801029b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029b0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
801029b6:	85 c9                	test   %ecx,%ecx
801029b8:	0f 8e 85 00 00 00    	jle    80102a43 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029be:	55                   	push   %ebp
801029bf:	89 e5                	mov    %esp,%ebp
801029c1:	57                   	push   %edi
801029c2:	56                   	push   %esi
801029c3:	53                   	push   %ebx
801029c4:	31 db                	xor    %ebx,%ebx
801029c6:	83 ec 0c             	sub    $0xc,%esp
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029d0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801029d5:	83 ec 08             	sub    $0x8,%esp
801029d8:	01 d8                	add    %ebx,%eax
801029da:	83 c0 01             	add    $0x1,%eax
801029dd:	50                   	push   %eax
801029de:	ff 35 c4 36 11 80    	pushl  0x801136c4
801029e4:	e8 e7 d6 ff ff       	call   801000d0 <bread>
801029e9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029eb:	58                   	pop    %eax
801029ec:	5a                   	pop    %edx
801029ed:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
801029f4:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029fd:	e8 ce d6 ff ff       	call   801000d0 <bread>
80102a02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a07:	83 c4 0c             	add    $0xc,%esp
80102a0a:	68 00 02 00 00       	push   $0x200
80102a0f:	50                   	push   %eax
80102a10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a13:	50                   	push   %eax
80102a14:	e8 77 20 00 00       	call   80104a90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 7f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a21:	89 3c 24             	mov    %edi,(%esp)
80102a24:	e8 b7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a29:	89 34 24             	mov    %esi,(%esp)
80102a2c:	e8 af d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a31:	83 c4 10             	add    $0x10,%esp
80102a34:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102a3a:	7f 94                	jg     801029d0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a3f:	5b                   	pop    %ebx
80102a40:	5e                   	pop    %esi
80102a41:	5f                   	pop    %edi
80102a42:	5d                   	pop    %ebp
80102a43:	f3 c3                	repz ret 
80102a45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	53                   	push   %ebx
80102a54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a57:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102a5d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a63:	e8 68 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a68:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a6e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a71:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a73:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a75:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a78:	7e 1f                	jle    80102a99 <write_head+0x49>
80102a7a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a81:	31 d2                	xor    %edx,%edx
80102a83:	90                   	nop
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a88:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102a8e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a92:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a95:	39 c2                	cmp    %eax,%edx
80102a97:	75 ef                	jne    80102a88 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a99:	83 ec 0c             	sub    $0xc,%esp
80102a9c:	53                   	push   %ebx
80102a9d:	e8 fe d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aa2:	89 1c 24             	mov    %ebx,(%esp)
80102aa5:	e8 36 d7 ff ff       	call   801001e0 <brelse>
}
80102aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aad:	c9                   	leave  
80102aae:	c3                   	ret    
80102aaf:	90                   	nop

80102ab0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 2c             	sub    $0x2c,%esp
80102ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aba:	68 40 7b 10 80       	push   $0x80107b40
80102abf:	68 80 36 11 80       	push   $0x80113680
80102ac4:	e8 a7 1c 00 00       	call   80104770 <initlock>
  readsb(dev, &sb);
80102ac9:	58                   	pop    %eax
80102aca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102acd:	5a                   	pop    %edx
80102ace:	50                   	push   %eax
80102acf:	53                   	push   %ebx
80102ad0:	e8 db e8 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102adb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102adc:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ae2:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ae8:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aed:	5a                   	pop    %edx
80102aee:	50                   	push   %eax
80102aef:	53                   	push   %ebx
80102af0:	e8 db d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102af5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102af8:	83 c4 10             	add    $0x10,%esp
80102afb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102afd:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b03:	7e 1c                	jle    80102b21 <initlog+0x71>
80102b05:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b0c:	31 d2                	xor    %edx,%edx
80102b0e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b14:	83 c2 04             	add    $0x4,%edx
80102b17:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	50                   	push   %eax
80102b25:	e8 b6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b2a:	e8 81 fe ff ff       	call   801029b0 <install_trans>
  log.lh.n = 0;
80102b2f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102b36:	00 00 00 
  write_head(); // clear the log
80102b39:	e8 12 ff ff ff       	call   80102a50 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b41:	c9                   	leave  
80102b42:	c3                   	ret    
80102b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b56:	68 80 36 11 80       	push   $0x80113680
80102b5b:	e8 10 1d 00 00       	call   80104870 <acquire>
80102b60:	83 c4 10             	add    $0x10,%esp
80102b63:	eb 18                	jmp    80102b7d <begin_op+0x2d>
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b68:	83 ec 08             	sub    $0x8,%esp
80102b6b:	68 80 36 11 80       	push   $0x80113680
80102b70:	68 80 36 11 80       	push   $0x80113680
80102b75:	e8 26 12 00 00       	call   80103da0 <sleep>
80102b7a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b7d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102b82:	85 c0                	test   %eax,%eax
80102b84:	75 e2                	jne    80102b68 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b86:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102b8b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102b91:	83 c0 01             	add    $0x1,%eax
80102b94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b9a:	83 fa 1e             	cmp    $0x1e,%edx
80102b9d:	7f c9                	jg     80102b68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b9f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102ba2:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102ba7:	68 80 36 11 80       	push   $0x80113680
80102bac:	e8 df 1d 00 00       	call   80104990 <release>
      break;
    }
  }
}
80102bb1:	83 c4 10             	add    $0x10,%esp
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	57                   	push   %edi
80102bc4:	56                   	push   %esi
80102bc5:	53                   	push   %ebx
80102bc6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bc9:	68 80 36 11 80       	push   $0x80113680
80102bce:	e8 9d 1c 00 00       	call   80104870 <acquire>
  log.outstanding -= 1;
80102bd3:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102bd8:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102bde:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102be4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be6:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102beb:	0f 85 23 01 00 00    	jne    80102d14 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102bf1:	85 c0                	test   %eax,%eax
80102bf3:	0f 85 f7 00 00 00    	jne    80102cf0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bfc:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c03:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c06:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c08:	68 80 36 11 80       	push   $0x80113680
80102c0d:	e8 7e 1d 00 00       	call   80104990 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c12:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102c18:	83 c4 10             	add    $0x10,%esp
80102c1b:	85 c9                	test   %ecx,%ecx
80102c1d:	0f 8e 8a 00 00 00    	jle    80102cad <end_op+0xed>
80102c23:	90                   	nop
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c28:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c2d:	83 ec 08             	sub    $0x8,%esp
80102c30:	01 d8                	add    %ebx,%eax
80102c32:	83 c0 01             	add    $0x1,%eax
80102c35:	50                   	push   %eax
80102c36:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c3c:	e8 8f d4 ff ff       	call   801000d0 <bread>
80102c41:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c43:	58                   	pop    %eax
80102c44:	5a                   	pop    %edx
80102c45:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102c4c:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c52:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c55:	e8 76 d4 ff ff       	call   801000d0 <bread>
80102c5a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c5c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c5f:	83 c4 0c             	add    $0xc,%esp
80102c62:	68 00 02 00 00       	push   $0x200
80102c67:	50                   	push   %eax
80102c68:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6b:	50                   	push   %eax
80102c6c:	e8 1f 1e 00 00       	call   80104a90 <memmove>
    bwrite(to);  // write the log
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 27 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c79:	89 3c 24             	mov    %edi,(%esp)
80102c7c:	e8 5f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 57 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c89:	83 c4 10             	add    $0x10,%esp
80102c8c:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102c92:	7c 94                	jl     80102c28 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c94:	e8 b7 fd ff ff       	call   80102a50 <write_head>
    install_trans(); // Now install writes to home locations
80102c99:	e8 12 fd ff ff       	call   801029b0 <install_trans>
    log.lh.n = 0;
80102c9e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ca5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ca8:	e8 a3 fd ff ff       	call   80102a50 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cad:	83 ec 0c             	sub    $0xc,%esp
80102cb0:	68 80 36 11 80       	push   $0x80113680
80102cb5:	e8 b6 1b 00 00       	call   80104870 <acquire>
    log.committing = 0;
    wakeup(&log);
80102cba:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cc1:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102cc8:	00 00 00 
    wakeup(&log);
80102ccb:	e8 30 14 00 00       	call   80104100 <wakeup>
    release(&log.lock);
80102cd0:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102cd7:	e8 b4 1c 00 00       	call   80104990 <release>
80102cdc:	83 c4 10             	add    $0x10,%esp
  }
}
80102cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5f                   	pop    %edi
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
80102ce7:	89 f6                	mov    %esi,%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102cf0:	83 ec 0c             	sub    $0xc,%esp
80102cf3:	68 80 36 11 80       	push   $0x80113680
80102cf8:	e8 03 14 00 00       	call   80104100 <wakeup>
  }
  release(&log.lock);
80102cfd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d04:	e8 87 1c 00 00       	call   80104990 <release>
80102d09:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0f:	5b                   	pop    %ebx
80102d10:	5e                   	pop    %esi
80102d11:	5f                   	pop    %edi
80102d12:	5d                   	pop    %ebp
80102d13:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d14:	83 ec 0c             	sub    $0xc,%esp
80102d17:	68 44 7b 10 80       	push   $0x80107b44
80102d1c:	e8 4f d6 ff ff       	call   80100370 <panic>
80102d21:	eb 0d                	jmp    80102d30 <log_write>
80102d23:	90                   	nop
80102d24:	90                   	nop
80102d25:	90                   	nop
80102d26:	90                   	nop
80102d27:	90                   	nop
80102d28:	90                   	nop
80102d29:	90                   	nop
80102d2a:	90                   	nop
80102d2b:	90                   	nop
80102d2c:	90                   	nop
80102d2d:	90                   	nop
80102d2e:	90                   	nop
80102d2f:	90                   	nop

80102d30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d37:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d40:	83 fa 1d             	cmp    $0x1d,%edx
80102d43:	0f 8f 97 00 00 00    	jg     80102de0 <log_write+0xb0>
80102d49:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102d4e:	83 e8 01             	sub    $0x1,%eax
80102d51:	39 c2                	cmp    %eax,%edx
80102d53:	0f 8d 87 00 00 00    	jge    80102de0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d59:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	0f 8e 87 00 00 00    	jle    80102ded <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	68 80 36 11 80       	push   $0x80113680
80102d6e:	e8 fd 1a 00 00       	call   80104870 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d73:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d79:	83 c4 10             	add    $0x10,%esp
80102d7c:	83 fa 00             	cmp    $0x0,%edx
80102d7f:	7e 50                	jle    80102dd1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d81:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d84:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d86:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
80102d8c:	75 0b                	jne    80102d99 <log_write+0x69>
80102d8e:	eb 38                	jmp    80102dc8 <log_write+0x98>
80102d90:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102d97:	74 2f                	je     80102dc8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	39 d0                	cmp    %edx,%eax
80102d9e:	75 f0                	jne    80102d90 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102da7:	83 c2 01             	add    $0x1,%edx
80102daa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102db0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102db3:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dbd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dbe:	e9 cd 1b 00 00       	jmp    80104990 <release>
80102dc3:	90                   	nop
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc8:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
80102dcf:	eb df                	jmp    80102db0 <log_write+0x80>
80102dd1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dd4:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102dd9:	75 d5                	jne    80102db0 <log_write+0x80>
80102ddb:	eb ca                	jmp    80102da7 <log_write+0x77>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102de0:	83 ec 0c             	sub    $0xc,%esp
80102de3:	68 53 7b 10 80       	push   $0x80107b53
80102de8:	e8 83 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	68 69 7b 10 80       	push   $0x80107b69
80102df5:	e8 76 d5 ff ff       	call   80100370 <panic>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e07:	e8 84 09 00 00       	call   80103790 <cpuid>
80102e0c:	89 c3                	mov    %eax,%ebx
80102e0e:	e8 7d 09 00 00       	call   80103790 <cpuid>
80102e13:	83 ec 04             	sub    $0x4,%esp
80102e16:	53                   	push   %ebx
80102e17:	50                   	push   %eax
80102e18:	68 84 7b 10 80       	push   $0x80107b84
80102e1d:	e8 3e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e22:	e8 79 30 00 00       	call   80105ea0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e27:	e8 e4 08 00 00       	call   80103710 <mycpu>
80102e2c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e2e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e33:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e3a:	e8 61 0c 00 00       	call   80103aa0 <scheduler>
80102e3f:	90                   	nop

80102e40 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e46:	e8 85 41 00 00       	call   80106fd0 <switchkvm>
  seginit();
80102e4b:	e8 80 40 00 00       	call   80106ed0 <seginit>
  lapicinit();
80102e50:	e8 9b f7 ff ff       	call   801025f0 <lapicinit>
  mpmain();
80102e55:	e8 a6 ff ff ff       	call   80102e00 <mpmain>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e60:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e64:	83 e4 f0             	and    $0xfffffff0,%esp
80102e67:	ff 71 fc             	pushl  -0x4(%ecx)
80102e6a:	55                   	push   %ebp
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	53                   	push   %ebx
80102e6e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e6f:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e74:	83 ec 08             	sub    $0x8,%esp
80102e77:	68 00 00 40 80       	push   $0x80400000
80102e7c:	68 a8 6a 11 80       	push   $0x80116aa8
80102e81:	e8 3a f5 ff ff       	call   801023c0 <kinit1>
  kvmalloc();      // kernel page table
80102e86:	e8 e5 45 00 00       	call   80107470 <kvmalloc>
  mpinit();        // detect other processors
80102e8b:	e8 70 01 00 00       	call   80103000 <mpinit>
  lapicinit();     // interrupt controller
80102e90:	e8 5b f7 ff ff       	call   801025f0 <lapicinit>
  seginit();       // segment descriptors
80102e95:	e8 36 40 00 00       	call   80106ed0 <seginit>
  picinit();       // disable pic
80102e9a:	e8 31 03 00 00       	call   801031d0 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 f7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 f2 32 00 00       	call   801061a0 <uartinit>
  pinit();         // process table
80102eae:	e8 3d 08 00 00       	call   801036f0 <pinit>
  tvinit();        // trap vectors
80102eb3:	e8 48 2f 00 00       	call   80105e00 <tvinit>
  binit();         // buffer cache
80102eb8:	e8 83 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ebd:	e8 8e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102ec2:	e8 09 f1 ff ff       	call   80101fd0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ec7:	83 c4 0c             	add    $0xc,%esp
80102eca:	68 8a 00 00 00       	push   $0x8a
80102ecf:	68 8c b4 10 80       	push   $0x8010b48c
80102ed4:	68 00 70 00 80       	push   $0x80007000
80102ed9:	e8 b2 1b 00 00       	call   80104a90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ede:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102ee5:	00 00 00 
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	05 80 37 11 80       	add    $0x80113780,%eax
80102ef0:	39 d8                	cmp    %ebx,%eax
80102ef2:	76 6f                	jbe    80102f63 <main+0x103>
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ef8:	e8 13 08 00 00       	call   80103710 <mycpu>
80102efd:	39 d8                	cmp    %ebx,%eax
80102eff:	74 49                	je     80102f4a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f01:	e8 8a f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f06:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102f0b:	c7 05 f8 6f 00 80 40 	movl   $0x80102e40,0x80006ff8
80102f12:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f15:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f1c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f1f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f24:	0f b6 03             	movzbl (%ebx),%eax
80102f27:	83 ec 08             	sub    $0x8,%esp
80102f2a:	68 00 70 00 00       	push   $0x7000
80102f2f:	50                   	push   %eax
80102f30:	e8 0b f8 ff ff       	call   80102740 <lapicstartap>
80102f35:	83 c4 10             	add    $0x10,%esp
80102f38:	90                   	nop
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f40:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	74 f6                	je     80102f40 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f4a:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f51:	00 00 00 
80102f54:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f5a:	05 80 37 11 80       	add    $0x80113780,%eax
80102f5f:	39 c3                	cmp    %eax,%ebx
80102f61:	72 95                	jb     80102ef8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f63:	83 ec 08             	sub    $0x8,%esp
80102f66:	68 00 00 00 8e       	push   $0x8e000000
80102f6b:	68 00 00 40 80       	push   $0x80400000
80102f70:	e8 bb f4 ff ff       	call   80102430 <kinit2>
  userinit();      // first user process
80102f75:	e8 66 08 00 00       	call   801037e0 <userinit>
  mpmain();        // finish this processor's setup
80102f7a:	e8 81 fe ff ff       	call   80102e00 <mpmain>
80102f7f:	90                   	nop

80102f80 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f85:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f8c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f92:	39 de                	cmp    %ebx,%esi
80102f94:	73 48                	jae    80102fde <mpsearch1+0x5e>
80102f96:	8d 76 00             	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fa0:	83 ec 04             	sub    $0x4,%esp
80102fa3:	8d 7e 10             	lea    0x10(%esi),%edi
80102fa6:	6a 04                	push   $0x4
80102fa8:	68 98 7b 10 80       	push   $0x80107b98
80102fad:	56                   	push   %esi
80102fae:	e8 7d 1a 00 00       	call   80104a30 <memcmp>
80102fb3:	83 c4 10             	add    $0x10,%esp
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	75 1e                	jne    80102fd8 <mpsearch1+0x58>
80102fba:	8d 7e 10             	lea    0x10(%esi),%edi
80102fbd:	89 f2                	mov    %esi,%edx
80102fbf:	31 c9                	xor    %ecx,%ecx
80102fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fc8:	0f b6 02             	movzbl (%edx),%eax
80102fcb:	83 c2 01             	add    $0x1,%edx
80102fce:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fd0:	39 fa                	cmp    %edi,%edx
80102fd2:	75 f4                	jne    80102fc8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fd4:	84 c9                	test   %cl,%cl
80102fd6:	74 10                	je     80102fe8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd8:	39 fb                	cmp    %edi,%ebx
80102fda:	89 fe                	mov    %edi,%esi
80102fdc:	77 c2                	ja     80102fa0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fe1:	31 c0                	xor    %eax,%eax
}
80102fe3:	5b                   	pop    %ebx
80102fe4:	5e                   	pop    %esi
80102fe5:	5f                   	pop    %edi
80102fe6:	5d                   	pop    %ebp
80102fe7:	c3                   	ret    
80102fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102feb:	89 f0                	mov    %esi,%eax
80102fed:	5b                   	pop    %ebx
80102fee:	5e                   	pop    %esi
80102fef:	5f                   	pop    %edi
80102ff0:	5d                   	pop    %ebp
80102ff1:	c3                   	ret    
80102ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103000 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
80103005:	53                   	push   %ebx
80103006:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103009:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103010:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103017:	c1 e0 08             	shl    $0x8,%eax
8010301a:	09 d0                	or     %edx,%eax
8010301c:	c1 e0 04             	shl    $0x4,%eax
8010301f:	85 c0                	test   %eax,%eax
80103021:	75 1b                	jne    8010303e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103023:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010302a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103031:	c1 e0 08             	shl    $0x8,%eax
80103034:	09 d0                	or     %edx,%eax
80103036:	c1 e0 0a             	shl    $0xa,%eax
80103039:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010303e:	ba 00 04 00 00       	mov    $0x400,%edx
80103043:	e8 38 ff ff ff       	call   80102f80 <mpsearch1>
80103048:	85 c0                	test   %eax,%eax
8010304a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010304d:	0f 84 37 01 00 00    	je     8010318a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103053:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103056:	8b 58 04             	mov    0x4(%eax),%ebx
80103059:	85 db                	test   %ebx,%ebx
8010305b:	0f 84 43 01 00 00    	je     801031a4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103061:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103067:	83 ec 04             	sub    $0x4,%esp
8010306a:	6a 04                	push   $0x4
8010306c:	68 9d 7b 10 80       	push   $0x80107b9d
80103071:	56                   	push   %esi
80103072:	e8 b9 19 00 00       	call   80104a30 <memcmp>
80103077:	83 c4 10             	add    $0x10,%esp
8010307a:	85 c0                	test   %eax,%eax
8010307c:	0f 85 22 01 00 00    	jne    801031a4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103082:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103089:	3c 01                	cmp    $0x1,%al
8010308b:	74 08                	je     80103095 <mpinit+0x95>
8010308d:	3c 04                	cmp    $0x4,%al
8010308f:	0f 85 0f 01 00 00    	jne    801031a4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103095:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010309c:	85 ff                	test   %edi,%edi
8010309e:	74 21                	je     801030c1 <mpinit+0xc1>
801030a0:	31 d2                	xor    %edx,%edx
801030a2:	31 c0                	xor    %eax,%eax
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030a8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030af:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030b3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b5:	39 c7                	cmp    %eax,%edi
801030b7:	75 ef                	jne    801030a8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b9:	84 d2                	test   %dl,%dl
801030bb:	0f 85 e3 00 00 00    	jne    801031a4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030c1:	85 f6                	test   %esi,%esi
801030c3:	0f 84 db 00 00 00    	je     801031a4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030c9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030cf:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030db:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030e1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e6:	01 d6                	add    %edx,%esi
801030e8:	90                   	nop
801030e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f0:	39 c6                	cmp    %eax,%esi
801030f2:	76 23                	jbe    80103117 <mpinit+0x117>
801030f4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030f7:	80 fa 04             	cmp    $0x4,%dl
801030fa:	0f 87 c0 00 00 00    	ja     801031c0 <mpinit+0x1c0>
80103100:	ff 24 95 dc 7b 10 80 	jmp    *-0x7fef8424(,%edx,4)
80103107:	89 f6                	mov    %esi,%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103110:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103113:	39 c6                	cmp    %eax,%esi
80103115:	77 dd                	ja     801030f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103117:	85 db                	test   %ebx,%ebx
80103119:	0f 84 92 00 00 00    	je     801031b1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010311f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103122:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103126:	74 15                	je     8010313d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103128:	ba 22 00 00 00       	mov    $0x22,%edx
8010312d:	b8 70 00 00 00       	mov    $0x70,%eax
80103132:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103133:	ba 23 00 00 00       	mov    $0x23,%edx
80103138:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103139:	83 c8 01             	or     $0x1,%eax
8010313c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010313d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103140:	5b                   	pop    %ebx
80103141:	5e                   	pop    %esi
80103142:	5f                   	pop    %edi
80103143:	5d                   	pop    %ebp
80103144:	c3                   	ret    
80103145:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103148:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
8010314e:	83 f9 07             	cmp    $0x7,%ecx
80103151:	7f 19                	jg     8010316c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103153:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103157:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010315d:	83 c1 01             	add    $0x1,%ecx
80103160:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103166:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010316c:	83 c0 14             	add    $0x14,%eax
      continue;
8010316f:	e9 7c ff ff ff       	jmp    801030f0 <mpinit+0xf0>
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010317c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010317f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
80103185:	e9 66 ff ff ff       	jmp    801030f0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010318f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103194:	e8 e7 fd ff ff       	call   80102f80 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103199:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010319b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010319e:	0f 85 af fe ff ff    	jne    80103053 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801031a4:	83 ec 0c             	sub    $0xc,%esp
801031a7:	68 a2 7b 10 80       	push   $0x80107ba2
801031ac:	e8 bf d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031b1:	83 ec 0c             	sub    $0xc,%esp
801031b4:	68 bc 7b 10 80       	push   $0x80107bbc
801031b9:	e8 b2 d1 ff ff       	call   80100370 <panic>
801031be:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031c0:	31 db                	xor    %ebx,%ebx
801031c2:	e9 30 ff ff ff       	jmp    801030f7 <mpinit+0xf7>
801031c7:	66 90                	xchg   %ax,%ax
801031c9:	66 90                	xchg   %ax,%ax
801031cb:	66 90                	xchg   %ax,%ax
801031cd:	66 90                	xchg   %ax,%ax
801031cf:	90                   	nop

801031d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031d0:	55                   	push   %ebp
801031d1:	ba 21 00 00 00       	mov    $0x21,%edx
801031d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	ee                   	out    %al,(%dx)
801031de:	ba a1 00 00 00       	mov    $0xa1,%edx
801031e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031e4:	5d                   	pop    %ebp
801031e5:	c3                   	ret    
801031e6:	66 90                	xchg   %ax,%ax
801031e8:	66 90                	xchg   %ax,%ax
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
801031f5:	53                   	push   %ebx
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	8b 75 08             	mov    0x8(%ebp),%esi
801031fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103205:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010320b:	e8 60 db ff ff       	call   80100d70 <filealloc>
80103210:	85 c0                	test   %eax,%eax
80103212:	89 06                	mov    %eax,(%esi)
80103214:	0f 84 a8 00 00 00    	je     801032c2 <pipealloc+0xd2>
8010321a:	e8 51 db ff ff       	call   80100d70 <filealloc>
8010321f:	85 c0                	test   %eax,%eax
80103221:	89 03                	mov    %eax,(%ebx)
80103223:	0f 84 87 00 00 00    	je     801032b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103229:	e8 62 f2 ff ff       	call   80102490 <kalloc>
8010322e:	85 c0                	test   %eax,%eax
80103230:	89 c7                	mov    %eax,%edi
80103232:	0f 84 b0 00 00 00    	je     801032e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103238:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010323b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103242:	00 00 00 
  p->writeopen = 1;
80103245:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010324c:	00 00 00 
  p->nwrite = 0;
8010324f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103256:	00 00 00 
  p->nread = 0;
80103259:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103260:	00 00 00 
  initlock(&p->lock, "pipe");
80103263:	68 f0 7b 10 80       	push   $0x80107bf0
80103268:	50                   	push   %eax
80103269:	e8 02 15 00 00       	call   80104770 <initlock>
  (*f0)->type = FD_PIPE;
8010326e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103270:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103273:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103279:	8b 06                	mov    (%esi),%eax
8010327b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010327f:	8b 06                	mov    (%esi),%eax
80103281:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103285:	8b 06                	mov    (%esi),%eax
80103287:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010328a:	8b 03                	mov    (%ebx),%eax
8010328c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103292:	8b 03                	mov    (%ebx),%eax
80103294:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103298:	8b 03                	mov    (%ebx),%eax
8010329a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010329e:	8b 03                	mov    (%ebx),%eax
801032a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801032a6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a8:	5b                   	pop    %ebx
801032a9:	5e                   	pop    %esi
801032aa:	5f                   	pop    %edi
801032ab:	5d                   	pop    %ebp
801032ac:	c3                   	ret    
801032ad:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032b0:	8b 06                	mov    (%esi),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 1e                	je     801032d4 <pipealloc+0xe4>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 71 db ff ff       	call   80100e30 <fileclose>
801032bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c2:	8b 03                	mov    (%ebx),%eax
801032c4:	85 c0                	test   %eax,%eax
801032c6:	74 0c                	je     801032d4 <pipealloc+0xe4>
    fileclose(*f1);
801032c8:	83 ec 0c             	sub    $0xc,%esp
801032cb:	50                   	push   %eax
801032cc:	e8 5f db ff ff       	call   80100e30 <fileclose>
801032d1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032dc:	5b                   	pop    %ebx
801032dd:	5e                   	pop    %esi
801032de:	5f                   	pop    %edi
801032df:	5d                   	pop    %ebp
801032e0:	c3                   	ret    
801032e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032e8:	8b 06                	mov    (%esi),%eax
801032ea:	85 c0                	test   %eax,%eax
801032ec:	75 c8                	jne    801032b6 <pipealloc+0xc6>
801032ee:	eb d2                	jmp    801032c2 <pipealloc+0xd2>

801032f0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	56                   	push   %esi
801032f4:	53                   	push   %ebx
801032f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032fb:	83 ec 0c             	sub    $0xc,%esp
801032fe:	53                   	push   %ebx
801032ff:	e8 6c 15 00 00       	call   80104870 <acquire>
  if(writable){
80103304:	83 c4 10             	add    $0x10,%esp
80103307:	85 f6                	test   %esi,%esi
80103309:	74 45                	je     80103350 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010330b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103311:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103314:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010331b:	00 00 00 
    wakeup(&p->nread);
8010331e:	50                   	push   %eax
8010331f:	e8 dc 0d 00 00       	call   80104100 <wakeup>
80103324:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103327:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010332d:	85 d2                	test   %edx,%edx
8010332f:	75 0a                	jne    8010333b <pipeclose+0x4b>
80103331:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103337:	85 c0                	test   %eax,%eax
80103339:	74 35                	je     80103370 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010333b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010333e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103341:	5b                   	pop    %ebx
80103342:	5e                   	pop    %esi
80103343:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103344:	e9 47 16 00 00       	jmp    80104990 <release>
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103350:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103356:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103359:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103360:	00 00 00 
    wakeup(&p->nwrite);
80103363:	50                   	push   %eax
80103364:	e8 97 0d 00 00       	call   80104100 <wakeup>
80103369:	83 c4 10             	add    $0x10,%esp
8010336c:	eb b9                	jmp    80103327 <pipeclose+0x37>
8010336e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	53                   	push   %ebx
80103374:	e8 17 16 00 00       	call   80104990 <release>
    kfree((char*)p);
80103379:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010337c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010337f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103382:	5b                   	pop    %ebx
80103383:	5e                   	pop    %esi
80103384:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103385:	e9 56 ef ff ff       	jmp    801022e0 <kfree>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103390 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 28             	sub    $0x28,%esp
80103399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010339c:	53                   	push   %ebx
8010339d:	e8 ce 14 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++){
801033a2:	8b 45 10             	mov    0x10(%ebp),%eax
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	85 c0                	test   %eax,%eax
801033aa:	0f 8e b9 00 00 00    	jle    80103469 <pipewrite+0xd9>
801033b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033bf:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033c8:	03 4d 10             	add    0x10(%ebp),%ecx
801033cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ce:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033d4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033da:	39 d0                	cmp    %edx,%eax
801033dc:	74 38                	je     80103416 <pipewrite+0x86>
801033de:	eb 59                	jmp    80103439 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033e0:	e8 cb 03 00 00       	call   801037b0 <myproc>
801033e5:	8b 48 24             	mov    0x24(%eax),%ecx
801033e8:	85 c9                	test   %ecx,%ecx
801033ea:	75 34                	jne    80103420 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033ec:	83 ec 0c             	sub    $0xc,%esp
801033ef:	57                   	push   %edi
801033f0:	e8 0b 0d 00 00       	call   80104100 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033f5:	58                   	pop    %eax
801033f6:	5a                   	pop    %edx
801033f7:	53                   	push   %ebx
801033f8:	56                   	push   %esi
801033f9:	e8 a2 09 00 00       	call   80103da0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033fe:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103404:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010340a:	83 c4 10             	add    $0x10,%esp
8010340d:	05 00 02 00 00       	add    $0x200,%eax
80103412:	39 c2                	cmp    %eax,%edx
80103414:	75 2a                	jne    80103440 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103416:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010341c:	85 c0                	test   %eax,%eax
8010341e:	75 c0                	jne    801033e0 <pipewrite+0x50>
        release(&p->lock);
80103420:	83 ec 0c             	sub    $0xc,%esp
80103423:	53                   	push   %ebx
80103424:	e8 67 15 00 00       	call   80104990 <release>
        return -1;
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103431:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103434:	5b                   	pop    %ebx
80103435:	5e                   	pop    %esi
80103436:	5f                   	pop    %edi
80103437:	5d                   	pop    %ebp
80103438:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103439:	89 c2                	mov    %eax,%edx
8010343b:	90                   	nop
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103440:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103443:	8d 42 01             	lea    0x1(%edx),%eax
80103446:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010344a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103450:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103456:	0f b6 09             	movzbl (%ecx),%ecx
80103459:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010345d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103460:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103463:	0f 85 65 ff ff ff    	jne    801033ce <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103469:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010346f:	83 ec 0c             	sub    $0xc,%esp
80103472:	50                   	push   %eax
80103473:	e8 88 0c 00 00       	call   80104100 <wakeup>
  release(&p->lock);
80103478:	89 1c 24             	mov    %ebx,(%esp)
8010347b:	e8 10 15 00 00       	call   80104990 <release>
  return n;
80103480:	83 c4 10             	add    $0x10,%esp
80103483:	8b 45 10             	mov    0x10(%ebp),%eax
80103486:	eb a9                	jmp    80103431 <pipewrite+0xa1>
80103488:	90                   	nop
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103490 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 18             	sub    $0x18,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010349c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010349f:	53                   	push   %ebx
801034a0:	e8 cb 13 00 00       	call   80104870 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034a5:	83 c4 10             	add    $0x10,%esp
801034a8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034ae:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034b4:	75 6a                	jne    80103520 <piperead+0x90>
801034b6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034bc:	85 f6                	test   %esi,%esi
801034be:	0f 84 cc 00 00 00    	je     80103590 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034c4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034ca:	eb 2d                	jmp    801034f9 <piperead+0x69>
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034d0:	83 ec 08             	sub    $0x8,%esp
801034d3:	53                   	push   %ebx
801034d4:	56                   	push   %esi
801034d5:	e8 c6 08 00 00       	call   80103da0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034da:	83 c4 10             	add    $0x10,%esp
801034dd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034e3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034e9:	75 35                	jne    80103520 <piperead+0x90>
801034eb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034f1:	85 d2                	test   %edx,%edx
801034f3:	0f 84 97 00 00 00    	je     80103590 <piperead+0x100>
    if(myproc()->killed){
801034f9:	e8 b2 02 00 00       	call   801037b0 <myproc>
801034fe:	8b 48 24             	mov    0x24(%eax),%ecx
80103501:	85 c9                	test   %ecx,%ecx
80103503:	74 cb                	je     801034d0 <piperead+0x40>
      release(&p->lock);
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	53                   	push   %ebx
80103509:	e8 82 14 00 00       	call   80104990 <release>
      return -1;
8010350e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103511:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103519:	5b                   	pop    %ebx
8010351a:	5e                   	pop    %esi
8010351b:	5f                   	pop    %edi
8010351c:	5d                   	pop    %ebp
8010351d:	c3                   	ret    
8010351e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103520:	8b 45 10             	mov    0x10(%ebp),%eax
80103523:	85 c0                	test   %eax,%eax
80103525:	7e 69                	jle    80103590 <piperead+0x100>
    if(p->nread == p->nwrite)
80103527:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352d:	31 c9                	xor    %ecx,%ecx
8010352f:	eb 15                	jmp    80103546 <piperead+0xb6>
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103538:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010353e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103544:	74 5a                	je     801035a0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103546:	8d 70 01             	lea    0x1(%eax),%esi
80103549:	25 ff 01 00 00       	and    $0x1ff,%eax
8010354e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103554:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103559:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010355c:	83 c1 01             	add    $0x1,%ecx
8010355f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103562:	75 d4                	jne    80103538 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103564:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010356a:	83 ec 0c             	sub    $0xc,%esp
8010356d:	50                   	push   %eax
8010356e:	e8 8d 0b 00 00       	call   80104100 <wakeup>
  release(&p->lock);
80103573:	89 1c 24             	mov    %ebx,(%esp)
80103576:	e8 15 14 00 00       	call   80104990 <release>
  return i;
8010357b:	8b 45 10             	mov    0x10(%ebp),%eax
8010357e:	83 c4 10             	add    $0x10,%esp
}
80103581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103584:	5b                   	pop    %ebx
80103585:	5e                   	pop    %esi
80103586:	5f                   	pop    %edi
80103587:	5d                   	pop    %ebp
80103588:	c3                   	ret    
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103597:	eb cb                	jmp    80103564 <piperead+0xd4>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035a0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801035a3:	eb bf                	jmp    80103564 <piperead+0xd4>
801035a5:	66 90                	xchg   %ax,%ax
801035a7:	66 90                	xchg   %ax,%ax
801035a9:	66 90                	xchg   %ax,%ax
801035ab:	66 90                	xchg   %ax,%ax
801035ad:	66 90                	xchg   %ax,%ax
801035af:	90                   	nop

801035b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035b4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801035bc:	68 20 3d 11 80       	push   $0x80113d20
801035c1:	e8 aa 12 00 00       	call   80104870 <acquire>
801035c6:	83 c4 10             	add    $0x10,%esp
801035c9:	eb 17                	jmp    801035e2 <allocproc+0x32>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035d0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801035d6:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
801035dc:	0f 84 9e 00 00 00    	je     80103680 <allocproc+0xd0>
    if(p->state == UNUSED)
801035e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801035e5:	85 c0                	test   %eax,%eax
801035e7:	75 e7                	jne    801035d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035e9:	a1 14 b0 10 80       	mov    0x8010b014,%eax
  p->ctime = ticks;
  p->retime = 0;
  p->rutime = 0;
  p->stime = 0;

  release(&ptable.lock);
801035ee:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->ctime = ticks;
  p->retime = 0;
  p->rutime = 0;
  p->stime = 0;

  release(&ptable.lock);
801035f8:	68 20 3d 11 80       	push   $0x80113d20
    p->priority = 2;
  #endif
  #endif

  p->ctime = ticks;
  p->retime = 0;
801035fd:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103604:	00 00 00 
  p->rutime = 0;
80103607:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010360e:	00 00 00 
  p->stime = 0;
80103611:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103618:	00 00 00 
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
8010361b:	8d 50 01             	lea    0x1(%eax),%edx
8010361e:	89 43 10             	mov    %eax,0x10(%ebx)
  #ifdef SML
    p->priority = 2;
  #endif
  #endif

  p->ctime = ticks;
80103621:	a1 a0 6a 11 80       	mov    0x80116aa0,%eax
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103626:	89 15 14 b0 10 80    	mov    %edx,0x8010b014
  #ifdef SML
    p->priority = 2;
  #endif
  #endif

  p->ctime = ticks;
8010362c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  p->retime = 0;
  p->rutime = 0;
  p->stime = 0;

  release(&ptable.lock);
80103632:	e8 59 13 00 00       	call   80104990 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103637:	e8 54 ee ff ff       	call   80102490 <kalloc>
8010363c:	83 c4 10             	add    $0x10,%esp
8010363f:	85 c0                	test   %eax,%eax
80103641:	89 43 08             	mov    %eax,0x8(%ebx)
80103644:	74 51                	je     80103697 <allocproc+0xe7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103646:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010364c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010364f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103654:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103657:	c7 40 14 ef 5d 10 80 	movl   $0x80105def,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010365e:	6a 14                	push   $0x14
80103660:	6a 00                	push   $0x0
80103662:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103663:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103666:	e8 75 13 00 00       	call   801049e0 <memset>
  p->context->eip = (uint)forkret;
8010366b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010366e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103671:	c7 40 10 a0 36 10 80 	movl   $0x801036a0,0x10(%eax)

  return p;
80103678:	89 d8                	mov    %ebx,%eax
}
8010367a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010367d:	c9                   	leave  
8010367e:	c3                   	ret    
8010367f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	68 20 3d 11 80       	push   $0x80113d20
80103688:	e8 03 13 00 00       	call   80104990 <release>
  return 0;
8010368d:	83 c4 10             	add    $0x10,%esp
80103690:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103695:	c9                   	leave  
80103696:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103697:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010369e:	eb da                	jmp    8010367a <allocproc+0xca>

801036a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036a6:	68 20 3d 11 80       	push   $0x80113d20
801036ab:	e8 e0 12 00 00       	call   80104990 <release>

  if (first) {
801036b0:	a1 10 b0 10 80       	mov    0x8010b010,%eax
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	85 c0                	test   %eax,%eax
801036ba:	75 04                	jne    801036c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036bc:	c9                   	leave  
801036bd:	c3                   	ret    
801036be:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801036c0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801036c3:	c7 05 10 b0 10 80 00 	movl   $0x0,0x8010b010
801036ca:	00 00 00 
    iinit(ROOTDEV);
801036cd:	6a 01                	push   $0x1
801036cf:	e8 9c dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
801036d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036db:	e8 d0 f3 ff ff       	call   80102ab0 <initlog>
801036e0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036e3:	c9                   	leave  
801036e4:	c3                   	ret    
801036e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036f0 <pinit>:
extern void forkret(void);
extern void trapret(void);

void
pinit(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036f6:	68 f5 7b 10 80       	push   $0x80107bf5
801036fb:	68 20 3d 11 80       	push   $0x80113d20
80103700:	e8 6b 10 00 00       	call   80104770 <initlock>
}
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	c9                   	leave  
80103709:	c3                   	ret    
8010370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103710 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103715:	9c                   	pushf  
80103716:	58                   	pop    %eax
  int apicid, i;

  if(readeflags()&FL_IF)
80103717:	f6 c4 02             	test   $0x2,%ah
8010371a:	75 5b                	jne    80103777 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
8010371c:	e8 cf ef ff ff       	call   801026f0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103721:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103727:	85 f6                	test   %esi,%esi
80103729:	7e 3f                	jle    8010376a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010372b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103732:	39 d0                	cmp    %edx,%eax
80103734:	74 30                	je     80103766 <mycpu+0x56>
80103736:	b9 30 38 11 80       	mov    $0x80113830,%ecx
8010373b:	31 d2                	xor    %edx,%edx
8010373d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103740:	83 c2 01             	add    $0x1,%edx
80103743:	39 f2                	cmp    %esi,%edx
80103745:	74 23                	je     8010376a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103747:	0f b6 19             	movzbl (%ecx),%ebx
8010374a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103750:	39 d8                	cmp    %ebx,%eax
80103752:	75 ec                	jne    80103740 <mycpu+0x30>
      return &cpus[i];
80103754:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010375a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010375d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010375e:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
80103763:	5e                   	pop    %esi
80103764:	5d                   	pop    %ebp
80103765:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");

  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103766:	31 d2                	xor    %edx,%edx
80103768:	eb ea                	jmp    80103754 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010376a:	83 ec 0c             	sub    $0xc,%esp
8010376d:	68 fc 7b 10 80       	push   $0x80107bfc
80103772:	e8 f9 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;

  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103777:	83 ec 0c             	sub    $0xc,%esp
8010377a:	68 d8 7c 10 80       	push   $0x80107cd8
8010377f:	e8 ec cb ff ff       	call   80100370 <panic>
80103784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010378a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103790 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103796:	e8 75 ff ff ff       	call   80103710 <mycpu>
8010379b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
801037a0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801037a1:	c1 f8 04             	sar    $0x4,%eax
801037a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037aa:	c3                   	ret    
801037ab:	90                   	nop
801037ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037b0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
801037b4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801037b7:	e8 74 10 00 00       	call   80104830 <pushcli>
  c = mycpu();
801037bc:	e8 4f ff ff ff       	call   80103710 <mycpu>
  p = c->proc;
801037c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037c7:	e8 54 11 00 00       	call   80104920 <popcli>
  return p;
}
801037cc:	83 c4 04             	add    $0x4,%esp
801037cf:	89 d8                	mov    %ebx,%eax
801037d1:	5b                   	pop    %ebx
801037d2:	5d                   	pop    %ebp
801037d3:	c3                   	ret    
801037d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037e0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801037e7:	e8 c4 fd ff ff       	call   801035b0 <allocproc>
801037ec:	89 c3                	mov    %eax,%ebx

  initproc = p;
801037ee:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801037f3:	e8 f8 3b 00 00       	call   801073f0 <setupkvm>
801037f8:	85 c0                	test   %eax,%eax
801037fa:	89 43 04             	mov    %eax,0x4(%ebx)
801037fd:	0f 84 d2 00 00 00    	je     801038d5 <userinit+0xf5>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103803:	83 ec 04             	sub    $0x4,%esp
80103806:	68 2c 00 00 00       	push   $0x2c
8010380b:	68 60 b4 10 80       	push   $0x8010b460
80103810:	50                   	push   %eax
80103811:	e8 ea 38 00 00       	call   80107100 <inituvm>
  p->sz = PGSIZE;
80103816:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  p->ctime = ticks;
8010381c:	a1 a0 6a 11 80       	mov    0x80116aa0,%eax
  memset(p->tf, 0, sizeof(*p->tf));
80103821:	83 c4 0c             	add    $0xc,%esp
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  p->ctime = ticks;
80103824:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010382a:	6a 4c                	push   $0x4c
8010382c:	6a 00                	push   $0x0
8010382e:	ff 73 18             	pushl  0x18(%ebx)
80103831:	e8 aa 11 00 00       	call   801049e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103836:	8b 43 18             	mov    0x18(%ebx),%eax
80103839:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010383e:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  p->tickets = DEFAULT_TICKETS; // used in LOTTERY

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103843:	83 c4 0c             	add    $0xc,%esp
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  p->ctime = ticks;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103846:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010384a:	8b 43 18             	mov    0x18(%ebx),%eax
8010384d:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103851:	8b 43 18             	mov    0x18(%ebx),%eax
80103854:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103858:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010385c:	8b 43 18             	mov    0x18(%ebx),%eax
8010385f:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103863:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103867:	8b 43 18             	mov    0x18(%ebx),%eax
8010386a:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103871:	8b 43 18             	mov    0x18(%ebx),%eax
80103874:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010387b:	8b 43 18             	mov    0x18(%ebx),%eax
8010387e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->tickets = DEFAULT_TICKETS; // used in LOTTERY

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103885:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S
  p->tickets = DEFAULT_TICKETS; // used in LOTTERY
80103888:	c7 83 90 00 00 00 01 	movl   $0x1,0x90(%ebx)
8010388f:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103892:	6a 10                	push   $0x10
80103894:	68 25 7c 10 80       	push   $0x80107c25
80103899:	50                   	push   %eax
8010389a:	e8 41 13 00 00       	call   80104be0 <safestrcpy>
  p->cwd = namei("/");
8010389f:	c7 04 24 2e 7c 10 80 	movl   $0x80107c2e,(%esp)
801038a6:	e8 15 e6 ff ff       	call   80101ec0 <namei>
801038ab:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801038ae:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801038b5:	e8 b6 0f 00 00       	call   80104870 <acquire>

  p->state = RUNNABLE;
801038ba:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801038c1:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801038c8:	e8 c3 10 00 00       	call   80104990 <release>
}
801038cd:	83 c4 10             	add    $0x10,%esp
801038d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    

  p = allocproc();

  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038d5:	83 ec 0c             	sub    $0xc,%esp
801038d8:	68 0c 7c 10 80       	push   $0x80107c0c
801038dd:	e8 8e ca ff ff       	call   80100370 <panic>
801038e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038f0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	56                   	push   %esi
801038f4:	53                   	push   %ebx
801038f5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801038f8:	e8 33 0f 00 00       	call   80104830 <pushcli>
  c = mycpu();
801038fd:	e8 0e fe ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103902:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103908:	e8 13 10 00 00       	call   80104920 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010390d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103910:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103912:	7e 34                	jle    80103948 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103914:	83 ec 04             	sub    $0x4,%esp
80103917:	01 c6                	add    %eax,%esi
80103919:	56                   	push   %esi
8010391a:	50                   	push   %eax
8010391b:	ff 73 04             	pushl  0x4(%ebx)
8010391e:	e8 1d 39 00 00       	call   80107240 <allocuvm>
80103923:	83 c4 10             	add    $0x10,%esp
80103926:	85 c0                	test   %eax,%eax
80103928:	74 36                	je     80103960 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010392a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010392d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010392f:	53                   	push   %ebx
80103930:	e8 bb 36 00 00       	call   80106ff0 <switchuvm>
  return 0;
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	31 c0                	xor    %eax,%eax
}
8010393a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010393d:	5b                   	pop    %ebx
8010393e:	5e                   	pop    %esi
8010393f:	5d                   	pop    %ebp
80103940:	c3                   	ret    
80103941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103948:	74 e0                	je     8010392a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010394a:	83 ec 04             	sub    $0x4,%esp
8010394d:	01 c6                	add    %eax,%esi
8010394f:	56                   	push   %esi
80103950:	50                   	push   %eax
80103951:	ff 73 04             	pushl  0x4(%ebx)
80103954:	e8 e7 39 00 00       	call   80107340 <deallocuvm>
80103959:	83 c4 10             	add    $0x10,%esp
8010395c:	85 c0                	test   %eax,%eax
8010395e:	75 ca                	jne    8010392a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103965:	eb d3                	jmp    8010393a <growproc+0x4a>
80103967:	89 f6                	mov    %esi,%esi
80103969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103970 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
80103975:	53                   	push   %ebx
80103976:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103979:	e8 b2 0e 00 00       	call   80104830 <pushcli>
  c = mycpu();
8010397e:	e8 8d fd ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103983:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103989:	e8 92 0f 00 00       	call   80104920 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010398e:	e8 1d fc ff ff       	call   801035b0 <allocproc>
80103993:	85 c0                	test   %eax,%eax
80103995:	89 c7                	mov    %eax,%edi
80103997:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010399a:	0f 84 c5 00 00 00    	je     80103a65 <fork+0xf5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039a0:	83 ec 08             	sub    $0x8,%esp
801039a3:	ff 33                	pushl  (%ebx)
801039a5:	ff 73 04             	pushl  0x4(%ebx)
801039a8:	e8 13 3b 00 00       	call   801074c0 <copyuvm>
801039ad:	83 c4 10             	add    $0x10,%esp
801039b0:	85 c0                	test   %eax,%eax
801039b2:	89 47 04             	mov    %eax,0x4(%edi)
801039b5:	0f 84 b1 00 00 00    	je     80103a6c <fork+0xfc>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801039bb:	8b 03                	mov    (%ebx),%eax
801039bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039c0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039c2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801039c5:	89 c8                	mov    %ecx,%eax
801039c7:	8b 79 18             	mov    0x18(%ecx),%edi
801039ca:	8b 73 18             	mov    0x18(%ebx),%esi
801039cd:	b9 13 00 00 00       	mov    $0x13,%ecx
801039d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  np->tickets = DEFAULT_TICKETS; // used in LOTTERY
801039d4:	c7 80 90 00 00 00 01 	movl   $0x1,0x90(%eax)
801039db:	00 00 00 

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039de:	31 f6                	xor    %esi,%esi
  *np->tf = *curproc->tf;

  np->tickets = DEFAULT_TICKETS; // used in LOTTERY

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801039e0:	8b 40 18             	mov    0x18(%eax),%eax
801039e3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801039f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801039f4:	85 c0                	test   %eax,%eax
801039f6:	74 13                	je     80103a0b <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039f8:	83 ec 0c             	sub    $0xc,%esp
801039fb:	50                   	push   %eax
801039fc:	e8 df d3 ff ff       	call   80100de0 <filedup>
80103a01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a04:	83 c4 10             	add    $0x10,%esp
80103a07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  np->tickets = DEFAULT_TICKETS; // used in LOTTERY

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a0b:	83 c6 01             	add    $0x1,%esi
80103a0e:	83 fe 10             	cmp    $0x10,%esi
80103a11:	75 dd                	jne    801039f0 <fork+0x80>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a13:	83 ec 0c             	sub    $0xc,%esp
80103a16:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a19:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a1c:	e8 1f dc ff ff       	call   80101640 <idup>
80103a21:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a24:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a27:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103a2d:	6a 10                	push   $0x10
80103a2f:	53                   	push   %ebx
80103a30:	50                   	push   %eax
80103a31:	e8 aa 11 00 00       	call   80104be0 <safestrcpy>

  pid = np->pid;
80103a36:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103a39:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a40:	e8 2b 0e 00 00       	call   80104870 <acquire>

  np->state = RUNNABLE;
80103a45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103a4c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a53:	e8 38 0f 00 00       	call   80104990 <release>

  return pid;
80103a58:	83 c4 10             	add    $0x10,%esp
80103a5b:	89 d8                	mov    %ebx,%eax
}
80103a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a60:	5b                   	pop    %ebx
80103a61:	5e                   	pop    %esi
80103a62:	5f                   	pop    %edi
80103a63:	5d                   	pop    %ebp
80103a64:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a6a:	eb f1                	jmp    80103a5d <fork+0xed>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a6c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a6f:	83 ec 0c             	sub    $0xc,%esp
80103a72:	ff 77 08             	pushl  0x8(%edi)
80103a75:	e8 66 e8 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103a7a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103a81:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a88:	83 c4 10             	add    $0x10,%esp
80103a8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a90:	eb cb                	jmp    80103a5d <fork+0xed>
80103a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103aa0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	57                   	push   %edi
80103aa4:	56                   	push   %esi
80103aa5:	53                   	push   %ebx
80103aa6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p = 0;

  struct cpu *c = mycpu();
80103aa9:	e8 62 fc ff ff       	call   80103710 <mycpu>
80103aae:	8d 78 04             	lea    0x4(%eax),%edi
80103ab1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ab3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103aba:	00 00 00 
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ac0:	fb                   	sti    
  {
      // Enable interrupts on this processor.
      sti();

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
80103ac1:	83 ec 0c             	sub    $0xc,%esp
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ac4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  {
      // Enable interrupts on this processor.
      sti();

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
80103ac9:	68 20 3d 11 80       	push   $0x80113d20
80103ace:	e8 9d 0d 00 00       	call   80104870 <acquire>
80103ad3:	83 c4 10             	add    $0x10,%esp
80103ad6:	eb 16                	jmp    80103aee <scheduler+0x4e>
80103ad8:	90                   	nop
80103ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ae0:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103ae6:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
80103aec:	74 52                	je     80103b40 <scheduler+0xa0>
      {

          #ifdef DEFAULT
              if(p->state != RUNNABLE)
80103aee:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103af2:	75 ec                	jne    80103ae0 <scheduler+0x40>

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
80103af4:	83 ec 0c             	sub    $0xc,%esp
          {

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
80103af7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
80103afd:	53                   	push   %ebx
      // Enable interrupts on this processor.
      sti();

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103afe:	81 c3 94 00 00 00    	add    $0x94,%ebx

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
80103b04:	e8 e7 34 00 00       	call   80106ff0 <switchuvm>
            p->state = RUNNING;

            swtch(&(c->scheduler), p->context);
80103b09:	58                   	pop    %eax
80103b0a:	5a                   	pop    %edx
80103b0b:	ff 73 88             	pushl  -0x78(%ebx)
80103b0e:	57                   	push   %edi
            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.
            c->proc = p;
            switchuvm(p);
            p->state = RUNNING;
80103b0f:	c7 83 78 ff ff ff 04 	movl   $0x4,-0x88(%ebx)
80103b16:	00 00 00 

            swtch(&(c->scheduler), p->context);
80103b19:	e8 1d 11 00 00       	call   80104c3b <swtch>
            switchkvm();
80103b1e:	e8 ad 34 00 00       	call   80106fd0 <switchkvm>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103b23:	83 c4 10             	add    $0x10,%esp
      // Enable interrupts on this processor.
      sti();

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b26:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
            swtch(&(c->scheduler), p->context);
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
80103b2c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b33:	00 00 00 
      // Enable interrupts on this processor.
      sti();

      // Loop over process table looking for process to run.
      acquire(&ptable.lock);
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b36:	75 b6                	jne    80103aee <scheduler+0x4e>
80103b38:	90                   	nop
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            // It should have changed its p->state before coming back.
            c->proc = 0;
          }
        }

        release(&ptable.lock);
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	68 20 3d 11 80       	push   $0x80113d20
80103b48:	e8 43 0e 00 00       	call   80104990 <release>
  }
80103b4d:	83 c4 10             	add    $0x10,%esp
80103b50:	e9 6b ff ff ff       	jmp    80103ac0 <scheduler+0x20>
80103b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b65:	e8 c6 0c 00 00       	call   80104830 <pushcli>
  c = mycpu();
80103b6a:	e8 a1 fb ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103b6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b75:	e8 a6 0d 00 00       	call   80104920 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103b7a:	83 ec 0c             	sub    $0xc,%esp
80103b7d:	68 20 3d 11 80       	push   $0x80113d20
80103b82:	e8 69 0c 00 00       	call   801047f0 <holding>
80103b87:	83 c4 10             	add    $0x10,%esp
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	74 4f                	je     80103bdd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103b8e:	e8 7d fb ff ff       	call   80103710 <mycpu>
80103b93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b9a:	75 68                	jne    80103c04 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103b9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ba0:	74 55                	je     80103bf7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ba2:	9c                   	pushf  
80103ba3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103ba4:	f6 c4 02             	test   $0x2,%ah
80103ba7:	75 41                	jne    80103bea <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103ba9:	e8 62 fb ff ff       	call   80103710 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bae:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103bb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103bb7:	e8 54 fb ff ff       	call   80103710 <mycpu>
80103bbc:	83 ec 08             	sub    $0x8,%esp
80103bbf:	ff 70 04             	pushl  0x4(%eax)
80103bc2:	53                   	push   %ebx
80103bc3:	e8 73 10 00 00       	call   80104c3b <swtch>
  mycpu()->intena = intena;
80103bc8:	e8 43 fb ff ff       	call   80103710 <mycpu>
}
80103bcd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103bd0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bd9:	5b                   	pop    %ebx
80103bda:	5e                   	pop    %esi
80103bdb:	5d                   	pop    %ebp
80103bdc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103bdd:	83 ec 0c             	sub    $0xc,%esp
80103be0:	68 30 7c 10 80       	push   $0x80107c30
80103be5:	e8 86 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	68 5c 7c 10 80       	push   $0x80107c5c
80103bf2:	e8 79 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103bf7:	83 ec 0c             	sub    $0xc,%esp
80103bfa:	68 4e 7c 10 80       	push   $0x80107c4e
80103bff:	e8 6c c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103c04:	83 ec 0c             	sub    $0xc,%esp
80103c07:	68 42 7c 10 80       	push   $0x80107c42
80103c0c:	e8 5f c7 ff ff       	call   80100370 <panic>
80103c11:	eb 0d                	jmp    80103c20 <exit>
80103c13:	90                   	nop
80103c14:	90                   	nop
80103c15:	90                   	nop
80103c16:	90                   	nop
80103c17:	90                   	nop
80103c18:	90                   	nop
80103c19:	90                   	nop
80103c1a:	90                   	nop
80103c1b:	90                   	nop
80103c1c:	90                   	nop
80103c1d:	90                   	nop
80103c1e:	90                   	nop
80103c1f:	90                   	nop

80103c20 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c29:	e8 02 0c 00 00       	call   80104830 <pushcli>
  c = mycpu();
80103c2e:	e8 dd fa ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103c33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c39:	e8 e2 0c 00 00       	call   80104920 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103c3e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103c44:	8d 5e 28             	lea    0x28(%esi),%ebx
80103c47:	8d 7e 68             	lea    0x68(%esi),%edi
80103c4a:	0f 84 f1 00 00 00    	je     80103d41 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103c50:	8b 03                	mov    (%ebx),%eax
80103c52:	85 c0                	test   %eax,%eax
80103c54:	74 12                	je     80103c68 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c56:	83 ec 0c             	sub    $0xc,%esp
80103c59:	50                   	push   %eax
80103c5a:	e8 d1 d1 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c6b:	39 df                	cmp    %ebx,%edi
80103c6d:	75 e1                	jne    80103c50 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103c6f:	e8 dc ee ff ff       	call   80102b50 <begin_op>
  iput(curproc->cwd);
80103c74:	83 ec 0c             	sub    $0xc,%esp
80103c77:	ff 76 68             	pushl  0x68(%esi)
80103c7a:	e8 21 db ff ff       	call   801017a0 <iput>
  end_op();
80103c7f:	e8 3c ef ff ff       	call   80102bc0 <end_op>
  curproc->cwd = 0;
80103c84:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103c8b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c92:	e8 d9 0b 00 00       	call   80104870 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103c97:	8b 56 14             	mov    0x14(%esi),%edx
80103c9a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c9d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ca2:	eb 10                	jmp    80103cb4 <exit+0x94>
80103ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ca8:	05 94 00 00 00       	add    $0x94,%eax
80103cad:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80103cb2:	74 1e                	je     80103cd2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103cb4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103cb8:	75 ee                	jne    80103ca8 <exit+0x88>
80103cba:	3b 50 20             	cmp    0x20(%eax),%edx
80103cbd:	75 e9                	jne    80103ca8 <exit+0x88>
      p->state = RUNNABLE;
80103cbf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cc6:	05 94 00 00 00       	add    $0x94,%eax
80103ccb:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80103cd0:	75 e2                	jne    80103cb4 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103cd2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80103cd8:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103cdd:	eb 0f                	jmp    80103cee <exit+0xce>
80103cdf:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce0:	81 c2 94 00 00 00    	add    $0x94,%edx
80103ce6:	81 fa 54 62 11 80    	cmp    $0x80116254,%edx
80103cec:	74 3a                	je     80103d28 <exit+0x108>
    if(p->parent == curproc){
80103cee:	39 72 14             	cmp    %esi,0x14(%edx)
80103cf1:	75 ed                	jne    80103ce0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103cf3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103cf7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103cfa:	75 e4                	jne    80103ce0 <exit+0xc0>
80103cfc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103d01:	eb 11                	jmp    80103d14 <exit+0xf4>
80103d03:	90                   	nop
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d08:	05 94 00 00 00       	add    $0x94,%eax
80103d0d:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80103d12:	74 cc                	je     80103ce0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d14:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d18:	75 ee                	jne    80103d08 <exit+0xe8>
80103d1a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d1d:	75 e9                	jne    80103d08 <exit+0xe8>
      p->state = RUNNABLE;
80103d1f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d26:	eb e0                	jmp    80103d08 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103d28:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d2f:	e8 2c fe ff ff       	call   80103b60 <sched>
  panic("zombie exit");
80103d34:	83 ec 0c             	sub    $0xc,%esp
80103d37:	68 7d 7c 10 80       	push   $0x80107c7d
80103d3c:	e8 2f c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103d41:	83 ec 0c             	sub    $0xc,%esp
80103d44:	68 70 7c 10 80       	push   $0x80107c70
80103d49:	e8 22 c6 ff ff       	call   80100370 <panic>
80103d4e:	66 90                	xchg   %ax,%ax

80103d50 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	53                   	push   %ebx
80103d54:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d57:	68 20 3d 11 80       	push   $0x80113d20
80103d5c:	e8 0f 0b 00 00       	call   80104870 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d61:	e8 ca 0a 00 00       	call   80104830 <pushcli>
  c = mycpu();
80103d66:	e8 a5 f9 ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103d6b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d71:	e8 aa 0b 00 00       	call   80104920 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103d76:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103d7d:	e8 de fd ff ff       	call   80103b60 <sched>
  release(&ptable.lock);
80103d82:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d89:	e8 02 0c 00 00       	call   80104990 <release>
}
80103d8e:	83 c4 10             	add    $0x10,%esp
80103d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d94:	c9                   	leave  
80103d95:	c3                   	ret    
80103d96:	8d 76 00             	lea    0x0(%esi),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dac:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103daf:	e8 7c 0a 00 00       	call   80104830 <pushcli>
  c = mycpu();
80103db4:	e8 57 f9 ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103db9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dbf:	e8 5c 0b 00 00       	call   80104920 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
80103dc4:	85 db                	test   %ebx,%ebx
80103dc6:	0f 84 87 00 00 00    	je     80103e53 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103dcc:	85 f6                	test   %esi,%esi
80103dce:	74 76                	je     80103e46 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103dd0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103dd6:	74 50                	je     80103e28 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103dd8:	83 ec 0c             	sub    $0xc,%esp
80103ddb:	68 20 3d 11 80       	push   $0x80113d20
80103de0:	e8 8b 0a 00 00       	call   80104870 <acquire>
    release(lk);
80103de5:	89 34 24             	mov    %esi,(%esp)
80103de8:	e8 a3 0b 00 00       	call   80104990 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103ded:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103df0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103df7:	e8 64 fd ff ff       	call   80103b60 <sched>

  // Tidy up.
  p->chan = 0;
80103dfc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e03:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e0a:	e8 81 0b 00 00       	call   80104990 <release>
    acquire(lk);
80103e0f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e12:	83 c4 10             	add    $0x10,%esp
  }
}
80103e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e18:	5b                   	pop    %ebx
80103e19:	5e                   	pop    %esi
80103e1a:	5f                   	pop    %edi
80103e1b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e1c:	e9 4f 0a 00 00       	jmp    80104870 <acquire>
80103e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103e28:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e2b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e32:	e8 29 fd ff ff       	call   80103b60 <sched>

  // Tidy up.
  p->chan = 0;
80103e37:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e41:	5b                   	pop    %ebx
80103e42:	5e                   	pop    %esi
80103e43:	5f                   	pop    %edi
80103e44:	5d                   	pop    %ebp
80103e45:	c3                   	ret    

  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103e46:	83 ec 0c             	sub    $0xc,%esp
80103e49:	68 8f 7c 10 80       	push   $0x80107c8f
80103e4e:	e8 1d c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  if(p == 0)
    panic("sleep");
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	68 89 7c 10 80       	push   $0x80107c89
80103e5b:	e8 10 c5 ff ff       	call   80100370 <panic>

80103e60 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	56                   	push   %esi
80103e64:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e65:	e8 c6 09 00 00       	call   80104830 <pushcli>
  c = mycpu();
80103e6a:	e8 a1 f8 ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103e6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e75:	e8 a6 0a 00 00       	call   80104920 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();

  acquire(&ptable.lock);
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 20 3d 11 80       	push   $0x80113d20
80103e82:	e8 e9 09 00 00       	call   80104870 <acquire>
80103e87:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103e8a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103e91:	eb 13                	jmp    80103ea6 <wait+0x46>
80103e93:	90                   	nop
80103e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e98:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103e9e:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
80103ea4:	74 22                	je     80103ec8 <wait+0x68>
      if(p->parent != curproc)
80103ea6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ea9:	75 ed                	jne    80103e98 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103eab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eaf:	74 35                	je     80103ee6 <wait+0x86>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb1:	81 c3 94 00 00 00    	add    $0x94,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103eb7:	b8 01 00 00 00       	mov    $0x1,%eax

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ebc:	81 fb 54 62 11 80    	cmp    $0x80116254,%ebx
80103ec2:	75 e2                	jne    80103ea6 <wait+0x46>
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103ec8:	85 c0                	test   %eax,%eax
80103eca:	74 7a                	je     80103f46 <wait+0xe6>
80103ecc:	8b 46 24             	mov    0x24(%esi),%eax
80103ecf:	85 c0                	test   %eax,%eax
80103ed1:	75 73                	jne    80103f46 <wait+0xe6>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103ed3:	83 ec 08             	sub    $0x8,%esp
80103ed6:	68 20 3d 11 80       	push   $0x80113d20
80103edb:	56                   	push   %esi
80103edc:	e8 bf fe ff ff       	call   80103da0 <sleep>
  }
80103ee1:	83 c4 10             	add    $0x10,%esp
80103ee4:	eb a4                	jmp    80103e8a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103eec:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103eef:	e8 ec e3 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103ef4:	5a                   	pop    %edx
80103ef5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103ef8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103eff:	e8 6c 34 00 00       	call   80107370 <freevm>
        p->pid = 0;
80103f04:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f0b:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f12:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f16:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->ctime = 0;
80103f1d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103f24:	00 00 00 
        p->state = UNUSED;
80103f27:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f2e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f35:	e8 56 0a 00 00       	call   80104990 <release>
        return pid;
80103f3a:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->name[0] = 0;
        p->killed = 0;
        p->ctime = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f40:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f42:	5b                   	pop    %ebx
80103f43:	5e                   	pop    %esi
80103f44:	5d                   	pop    %ebp
80103f45:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103f46:	83 ec 0c             	sub    $0xc,%esp
80103f49:	68 20 3d 11 80       	push   $0x80113d20
80103f4e:	e8 3d 0a 00 00       	call   80104990 <release>
      return -1;
80103f53:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103f59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f5e:	5b                   	pop    %ebx
80103f5f:	5e                   	pop    %esi
80103f60:	5d                   	pop    %ebp
80103f61:	c3                   	ret    
80103f62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <wait2>:

int wait2(int *retime, int *rutime, int *stime) {
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  acquire(&ptable.lock);
80103f79:	68 20 3d 11 80       	push   $0x80113d20
80103f7e:	e8 ed 08 00 00       	call   80104870 <acquire>
80103f83:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80103f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f8d:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
80103f92:	eb 12                	jmp    80103fa6 <wait2+0x36>
80103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f98:	81 c7 94 00 00 00    	add    $0x94,%edi
80103f9e:	81 ff 54 62 11 80    	cmp    $0x80116254,%edi
80103fa4:	74 3a                	je     80103fe0 <wait2+0x70>
      if(p->parent != myproc())
80103fa6:	8b 77 14             	mov    0x14(%edi),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103fa9:	e8 82 08 00 00       	call   80104830 <pushcli>
  c = mycpu();
80103fae:	e8 5d f7 ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103fb3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb9:	e8 62 09 00 00       	call   80104920 <popcli>
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != myproc())
80103fbe:	39 de                	cmp    %ebx,%esi
80103fc0:	75 d6                	jne    80103f98 <wait2+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103fc2:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
80103fc6:	74 6e                	je     80104036 <wait2+0xc6>
  int havekids, pid;
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc8:	81 c7 94 00 00 00    	add    $0x94,%edi
      if(p->parent != myproc())
        continue;
      havekids = 1;
80103fce:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int havekids, pid;
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd5:	81 ff 54 62 11 80    	cmp    $0x80116254,%edi
80103fdb:	75 c9                	jne    80103fa6 <wait2+0x36>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || myproc()->killed){
80103fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103fe3:	85 d2                	test   %edx,%edx
80103fe5:	0f 84 f2 00 00 00    	je     801040dd <wait2+0x16d>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103feb:	e8 40 08 00 00       	call   80104830 <pushcli>
  c = mycpu();
80103ff0:	e8 1b f7 ff ff       	call   80103710 <mycpu>
  p = c->proc;
80103ff5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ffb:	e8 20 09 00 00       	call   80104920 <popcli>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || myproc()->killed){
80104000:	8b 43 24             	mov    0x24(%ebx),%eax
80104003:	85 c0                	test   %eax,%eax
80104005:	0f 85 d2 00 00 00    	jne    801040dd <wait2+0x16d>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010400b:	e8 20 08 00 00       	call   80104830 <pushcli>
  c = mycpu();
80104010:	e8 fb f6 ff ff       	call   80103710 <mycpu>
  p = c->proc;
80104015:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010401b:	e8 00 09 00 00       	call   80104920 <popcli>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(myproc(), &ptable.lock);  //DOC: wait-sleep
80104020:	83 ec 08             	sub    $0x8,%esp
80104023:	68 20 3d 11 80       	push   $0x80113d20
80104028:	53                   	push   %ebx
80104029:	e8 72 fd ff ff       	call   80103da0 <sleep>
  }
8010402e:	83 c4 10             	add    $0x10,%esp
80104031:	e9 50 ff ff ff       	jmp    80103f86 <wait2+0x16>
      if(p->parent != myproc())
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        *retime = p->retime;
80104036:	8b 8f 88 00 00 00    	mov    0x88(%edi),%ecx
8010403c:	8b 45 08             	mov    0x8(%ebp),%eax
        *rutime = p->rutime;
        *stime = p->stime;
        pid = p->pid;
        kfree(p->kstack);
8010403f:	83 ec 0c             	sub    $0xc,%esp
      if(p->parent != myproc())
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        *retime = p->retime;
80104042:	89 08                	mov    %ecx,(%eax)
        *rutime = p->rutime;
80104044:	8b 45 0c             	mov    0xc(%ebp),%eax
80104047:	8b 8f 8c 00 00 00    	mov    0x8c(%edi),%ecx
8010404d:	89 08                	mov    %ecx,(%eax)
        *stime = p->stime;
8010404f:	8b 45 10             	mov    0x10(%ebp),%eax
80104052:	8b 8f 84 00 00 00    	mov    0x84(%edi),%ecx
80104058:	89 08                	mov    %ecx,(%eax)
        pid = p->pid;
        kfree(p->kstack);
8010405a:	ff 77 08             	pushl  0x8(%edi)
      if(p->state == ZOMBIE){
        // Found one.
        *retime = p->retime;
        *rutime = p->rutime;
        *stime = p->stime;
        pid = p->pid;
8010405d:	8b 5f 10             	mov    0x10(%edi),%ebx
        kfree(p->kstack);
80104060:	e8 7b e2 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104065:	59                   	pop    %ecx
80104066:	ff 77 04             	pushl  0x4(%edi)
        *retime = p->retime;
        *rutime = p->rutime;
        *stime = p->stime;
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104069:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
        freevm(p->pgdir);
80104070:	e8 fb 32 00 00       	call   80107370 <freevm>
        p->state = UNUSED;
80104075:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        p->pid = 0;
8010407c:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
        p->parent = 0;
80104083:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
        p->name[0] = 0;
8010408a:	c6 47 6c 00          	movb   $0x0,0x6c(%edi)
        p->killed = 0;
8010408e:	c7 47 24 00 00 00 00 	movl   $0x0,0x24(%edi)
        p->ctime = 0;
80104095:	c7 87 80 00 00 00 00 	movl   $0x0,0x80(%edi)
8010409c:	00 00 00 
        p->retime = 0;
8010409f:	c7 87 88 00 00 00 00 	movl   $0x0,0x88(%edi)
801040a6:	00 00 00 
        p->rutime = 0;
801040a9:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
801040b0:	00 00 00 
        p->stime = 0;
801040b3:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
801040ba:	00 00 00 
        p->priority = 0;
801040bd:	c7 47 7c 00 00 00 00 	movl   $0x0,0x7c(%edi)
        release(&ptable.lock);
801040c4:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040cb:	e8 c0 08 00 00       	call   80104990 <release>
        return pid;
801040d0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(myproc(), &ptable.lock);  //DOC: wait-sleep
  }
}
801040d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        p->retime = 0;
        p->rutime = 0;
        p->stime = 0;
        p->priority = 0;
        release(&ptable.lock);
        return pid;
801040d6:	89 d8                	mov    %ebx,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(myproc(), &ptable.lock);  //DOC: wait-sleep
  }
}
801040d8:	5b                   	pop    %ebx
801040d9:	5e                   	pop    %esi
801040da:	5f                   	pop    %edi
801040db:	5d                   	pop    %ebp
801040dc:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || myproc()->killed){
      release(&ptable.lock);
801040dd:	83 ec 0c             	sub    $0xc,%esp
801040e0:	68 20 3d 11 80       	push   $0x80113d20
801040e5:	e8 a6 08 00 00       	call   80104990 <release>
      return -1;
801040ea:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(myproc(), &ptable.lock);  //DOC: wait-sleep
  }
}
801040ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || myproc()->killed){
      release(&ptable.lock);
      return -1;
801040f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(myproc(), &ptable.lock);  //DOC: wait-sleep
  }
}
801040f5:	5b                   	pop    %ebx
801040f6:	5e                   	pop    %esi
801040f7:	5f                   	pop    %edi
801040f8:	5d                   	pop    %ebp
801040f9:	c3                   	ret    
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104100 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	53                   	push   %ebx
80104104:	83 ec 10             	sub    $0x10,%esp
80104107:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010410a:	68 20 3d 11 80       	push   $0x80113d20
8010410f:	e8 5c 07 00 00       	call   80104870 <acquire>
80104114:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104117:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010411c:	eb 0e                	jmp    8010412c <wakeup+0x2c>
8010411e:	66 90                	xchg   %ax,%ax
80104120:	05 94 00 00 00       	add    $0x94,%eax
80104125:	3d 54 62 11 80       	cmp    $0x80116254,%eax
8010412a:	74 1e                	je     8010414a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010412c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104130:	75 ee                	jne    80104120 <wakeup+0x20>
80104132:	3b 58 20             	cmp    0x20(%eax),%ebx
80104135:	75 e9                	jne    80104120 <wakeup+0x20>
      p->state = RUNNABLE;
80104137:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413e:	05 94 00 00 00       	add    $0x94,%eax
80104143:	3d 54 62 11 80       	cmp    $0x80116254,%eax
80104148:	75 e2                	jne    8010412c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010414a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104151:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104154:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104155:	e9 36 08 00 00       	jmp    80104990 <release>
8010415a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104160 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 10             	sub    $0x10,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010416a:	68 20 3d 11 80       	push   $0x80113d20
8010416f:	e8 fc 06 00 00       	call   80104870 <acquire>
80104174:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104177:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010417c:	eb 0e                	jmp    8010418c <kill+0x2c>
8010417e:	66 90                	xchg   %ax,%ax
80104180:	05 94 00 00 00       	add    $0x94,%eax
80104185:	3d 54 62 11 80       	cmp    $0x80116254,%eax
8010418a:	74 3c                	je     801041c8 <kill+0x68>
    if(p->pid == pid){
8010418c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010418f:	75 ef                	jne    80104180 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104191:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104195:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010419c:	74 1a                	je     801041b8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010419e:	83 ec 0c             	sub    $0xc,%esp
801041a1:	68 20 3d 11 80       	push   $0x80113d20
801041a6:	e8 e5 07 00 00       	call   80104990 <release>
      return 0;
801041ab:	83 c4 10             	add    $0x10,%esp
801041ae:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801041b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b3:	c9                   	leave  
801041b4:	c3                   	ret    
801041b5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801041b8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041bf:	eb dd                	jmp    8010419e <kill+0x3e>
801041c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	68 20 3d 11 80       	push   $0x80113d20
801041d0:	e8 bb 07 00 00       	call   80104990 <release>
  return -1;
801041d5:	83 c4 10             	add    $0x10,%esp
801041d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    
801041e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	56                   	push   %esi
801041f5:	53                   	push   %ebx
801041f6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041f9:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801041fe:	83 ec 3c             	sub    $0x3c,%esp
80104201:	eb 27                	jmp    8010422a <procdump+0x3a>
80104203:	90                   	nop
80104204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 2f 80 10 80       	push   $0x8010802f
80104210:	e8 4b c4 ff ff       	call   80100660 <cprintf>
80104215:	83 c4 10             	add    $0x10,%esp
80104218:	81 c3 94 00 00 00    	add    $0x94,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010421e:	81 fb c0 62 11 80    	cmp    $0x801162c0,%ebx
80104224:	0f 84 7e 00 00 00    	je     801042a8 <procdump+0xb8>
    if(p->state == UNUSED)
8010422a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010422d:	85 c0                	test   %eax,%eax
8010422f:	74 e7                	je     80104218 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104231:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104234:	ba a0 7c 10 80       	mov    $0x80107ca0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104239:	77 11                	ja     8010424c <procdump+0x5c>
8010423b:	8b 14 85 00 7d 10 80 	mov    -0x7fef8300(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104242:	b8 a0 7c 10 80       	mov    $0x80107ca0,%eax
80104247:	85 d2                	test   %edx,%edx
80104249:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010424c:	53                   	push   %ebx
8010424d:	52                   	push   %edx
8010424e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104251:	68 a4 7c 10 80       	push   $0x80107ca4
80104256:	e8 05 c4 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010425b:	83 c4 10             	add    $0x10,%esp
8010425e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104262:	75 a4                	jne    80104208 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104264:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104267:	83 ec 08             	sub    $0x8,%esp
8010426a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010426d:	50                   	push   %eax
8010426e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104271:	8b 40 0c             	mov    0xc(%eax),%eax
80104274:	83 c0 08             	add    $0x8,%eax
80104277:	50                   	push   %eax
80104278:	e8 13 05 00 00       	call   80104790 <getcallerpcs>
8010427d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104280:	8b 17                	mov    (%edi),%edx
80104282:	85 d2                	test   %edx,%edx
80104284:	74 82                	je     80104208 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104286:	83 ec 08             	sub    $0x8,%esp
80104289:	83 c7 04             	add    $0x4,%edi
8010428c:	52                   	push   %edx
8010428d:	68 e1 76 10 80       	push   $0x801076e1
80104292:	e8 c9 c3 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	39 f7                	cmp    %esi,%edi
8010429c:	75 e2                	jne    80104280 <procdump+0x90>
8010429e:	e9 65 ff ff ff       	jmp    80104208 <procdump+0x18>
801042a3:	90                   	nop
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801042a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ab:	5b                   	pop    %ebx
801042ac:	5e                   	pop    %esi
801042ad:	5f                   	pop    %edi
801042ae:	5d                   	pop    %ebp
801042af:	c3                   	ret    

801042b0 <getptable_proc>:

struct proc *getptable_proc(void) {
801042b0:	55                   	push   %ebp
  return ptable.proc;
}
801042b1:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
    }
    cprintf("\n");
  }
}

struct proc *getptable_proc(void) {
801042b6:	89 e5                	mov    %esp,%ebp
  return ptable.proc;
}
801042b8:	5d                   	pop    %ebp
801042b9:	c3                   	ret    
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042c0 <chpr>:

// Change Process priority
int
chpr(int pid, int priority)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042ca:	68 20 3d 11 80       	push   $0x80113d20
801042cf:	e8 9c 05 00 00       	call   80104870 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
801042dc:	eb 10                	jmp    801042ee <chpr+0x2e>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	81 c2 94 00 00 00    	add    $0x94,%edx
801042e6:	81 fa 54 62 11 80    	cmp    $0x80116254,%edx
801042ec:	74 0b                	je     801042f9 <chpr+0x39>
    if(p->pid == pid) {
801042ee:	39 5a 10             	cmp    %ebx,0x10(%edx)
801042f1:	75 ed                	jne    801042e0 <chpr+0x20>
        p->priority = priority;
801042f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801042f6:	89 42 7c             	mov    %eax,0x7c(%edx)
        break;
    }
  }
  release(&ptable.lock);
801042f9:	83 ec 0c             	sub    $0xc,%esp
801042fc:	68 20 3d 11 80       	push   $0x80113d20
80104301:	e8 8a 06 00 00       	call   80104990 <release>

  return pid;
}
80104306:	89 d8                	mov    %ebx,%eax
80104308:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010430b:	c9                   	leave  
8010430c:	c3                   	ret    
8010430d:	8d 76 00             	lea    0x0(%esi),%esi

80104310 <chtickets>:

// Change Process tickets
int
chtickets(int pid, int tickets)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 10             	sub    $0x10,%esp
80104317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010431a:	68 20 3d 11 80       	push   $0x80113d20
8010431f:	e8 4c 05 00 00       	call   80104870 <acquire>
80104324:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104327:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010432c:	eb 10                	jmp    8010433e <chtickets+0x2e>
8010432e:	66 90                	xchg   %ax,%ax
80104330:	81 c2 94 00 00 00    	add    $0x94,%edx
80104336:	81 fa 54 62 11 80    	cmp    $0x80116254,%edx
8010433c:	74 0e                	je     8010434c <chtickets+0x3c>
    if(p->pid == pid) {
8010433e:	39 5a 10             	cmp    %ebx,0x10(%edx)
80104341:	75 ed                	jne    80104330 <chtickets+0x20>
        p->tickets = tickets;
80104343:	8b 45 0c             	mov    0xc(%ebp),%eax
80104346:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)
        break;
    }
  }
  release(&ptable.lock);
8010434c:	83 ec 0c             	sub    $0xc,%esp
8010434f:	68 20 3d 11 80       	push   $0x80113d20
80104354:	e8 37 06 00 00       	call   80104990 <release>

  return pid;
}
80104359:	89 d8                	mov    %ebx,%eax
8010435b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010435e:	c9                   	leave  
8010435f:	c3                   	ret    

80104360 <updatestatistics>:

/*
  This method will run every clock tick and update the statistic fields for each proc
*/
void updatestatistics() {
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  acquire(&ptable.lock);
80104366:	68 20 3d 11 80       	push   $0x80113d20
8010436b:	e8 00 05 00 00       	call   80104870 <acquire>
80104370:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104373:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104378:	eb 23                	jmp    8010439d <updatestatistics+0x3d>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(p->state) {
80104380:	83 fa 04             	cmp    $0x4,%edx
80104383:	74 4b                	je     801043d0 <updatestatistics+0x70>
80104385:	83 fa 02             	cmp    $0x2,%edx
80104388:	75 07                	jne    80104391 <updatestatistics+0x31>
      case SLEEPING:
        p->stime++;
8010438a:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
  This method will run every clock tick and update the statistic fields for each proc
*/
void updatestatistics() {
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104391:	05 94 00 00 00       	add    $0x94,%eax
80104396:	3d 54 62 11 80       	cmp    $0x80116254,%eax
8010439b:	74 1b                	je     801043b8 <updatestatistics+0x58>
    switch(p->state) {
8010439d:	8b 50 0c             	mov    0xc(%eax),%edx
801043a0:	83 fa 03             	cmp    $0x3,%edx
801043a3:	75 db                	jne    80104380 <updatestatistics+0x20>
      case SLEEPING:
        p->stime++;
        break;
      case RUNNABLE:
        p->retime++;
801043a5:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
  This method will run every clock tick and update the statistic fields for each proc
*/
void updatestatistics() {
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ac:	05 94 00 00 00       	add    $0x94,%eax
801043b1:	3d 54 62 11 80       	cmp    $0x80116254,%eax
801043b6:	75 e5                	jne    8010439d <updatestatistics+0x3d>
        break;
      default:
        ;
    }
  }
  release(&ptable.lock);
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	68 20 3d 11 80       	push   $0x80113d20
801043c0:	e8 cb 05 00 00       	call   80104990 <release>
}
801043c5:	83 c4 10             	add    $0x10,%esp
801043c8:	c9                   	leave  
801043c9:	c3                   	ret    
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        break;
      case RUNNABLE:
        p->retime++;
        break;
      case RUNNING:
        p->rutime++;
801043d0:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)
        break;
801043d7:	eb b8                	jmp    80104391 <updatestatistics+0x31>
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043e0 <random>:

/* This method is used to generate a random number, between 0 and M
This is a modified version of the LFSR alogrithm
found here: http://goo.gl/At4AIC */
int
random(int max) {
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	83 ec 0c             	sub    $0xc,%esp

  if(max <= 0) {
801043e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043ec:	85 ff                	test   %edi,%edi
801043ee:	0f 8e ac 00 00 00    	jle    801044a0 <random+0xc0>
  static int z2 = 12345; // 12345 for rest of zx
  static int z3 = 12345; // 12345 for rest of zx
  static int z4 = 12345; // 12345 for rest of zx

  int b;
  b = (((z1 << 6) ^ z1) >> 13);
801043f4:	8b 3d 0c b0 10 80    	mov    0x8010b00c,%edi
  z1 = (((z1 & 4294967294) << 18) ^ b);
  b = (((z2 << 2) ^ z2) >> 27);
801043fa:	8b 35 08 b0 10 80    	mov    0x8010b008,%esi
  static int z3 = 12345; // 12345 for rest of zx
  static int z4 = 12345; // 12345 for rest of zx

  int b;
  b = (((z1 << 6) ^ z1) >> 13);
  z1 = (((z1 & 4294967294) << 18) ^ b);
80104400:	89 fb                	mov    %edi,%ebx
80104402:	c1 e3 06             	shl    $0x6,%ebx
80104405:	31 fb                	xor    %edi,%ebx
80104407:	83 e7 fe             	and    $0xfffffffe,%edi
8010440a:	c1 fb 0d             	sar    $0xd,%ebx
8010440d:	89 f8                	mov    %edi,%eax
  b = (((z2 << 2) ^ z2) >> 27);
  z2 = (((z2 & 4294967288) << 2) ^ b);
8010440f:	8d 3c b5 00 00 00 00 	lea    0x0(,%esi,4),%edi
  static int z3 = 12345; // 12345 for rest of zx
  static int z4 = 12345; // 12345 for rest of zx

  int b;
  b = (((z1 << 6) ^ z1) >> 13);
  z1 = (((z1 & 4294967294) << 18) ^ b);
80104416:	89 d9                	mov    %ebx,%ecx
80104418:	c1 e0 12             	shl    $0x12,%eax
8010441b:	31 c1                	xor    %eax,%ecx
  b = (((z2 << 2) ^ z2) >> 27);
  z2 = (((z2 & 4294967288) << 2) ^ b);
8010441d:	31 f7                	xor    %esi,%edi
8010441f:	83 e6 f8             	and    $0xfffffff8,%esi
  static int z3 = 12345; // 12345 for rest of zx
  static int z4 = 12345; // 12345 for rest of zx

  int b;
  b = (((z1 << 6) ^ z1) >> 13);
  z1 = (((z1 & 4294967294) << 18) ^ b);
80104422:	89 cb                	mov    %ecx,%ebx
80104424:	89 0d 0c b0 10 80    	mov    %ecx,0x8010b00c
  b = (((z2 << 2) ^ z2) >> 27);
  z2 = (((z2 & 4294967288) << 2) ^ b);
  b = (((z3 << 13) ^ z3) >> 21);
8010442a:	8b 0d 04 b0 10 80    	mov    0x8010b004,%ecx

  int b;
  b = (((z1 << 6) ^ z1) >> 13);
  z1 = (((z1 & 4294967294) << 18) ^ b);
  b = (((z2 << 2) ^ z2) >> 27);
  z2 = (((z2 & 4294967288) << 2) ^ b);
80104430:	89 f0                	mov    %esi,%eax
80104432:	c1 ff 1b             	sar    $0x1b,%edi
80104435:	89 da                	mov    %ebx,%edx
80104437:	c1 e0 02             	shl    $0x2,%eax
  b = (((z3 << 13) ^ z3) >> 21);
  z3 = (((z3 & 4294967280) << 7) ^ b);
8010443a:	89 ce                	mov    %ecx,%esi

  int b;
  b = (((z1 << 6) ^ z1) >> 13);
  z1 = (((z1 & 4294967294) << 18) ^ b);
  b = (((z2 << 2) ^ z2) >> 27);
  z2 = (((z2 & 4294967288) << 2) ^ b);
8010443c:	31 c7                	xor    %eax,%edi
  b = (((z3 << 13) ^ z3) >> 21);
  z3 = (((z3 & 4294967280) << 7) ^ b);
8010443e:	c1 e6 0d             	shl    $0xd,%esi
80104441:	31 fa                	xor    %edi,%edx

  int b;
  b = (((z1 << 6) ^ z1) >> 13);
  z1 = (((z1 & 4294967294) << 18) ^ b);
  b = (((z2 << 2) ^ z2) >> 27);
  z2 = (((z2 & 4294967288) << 2) ^ b);
80104443:	89 3d 08 b0 10 80    	mov    %edi,0x8010b008
  b = (((z3 << 13) ^ z3) >> 21);
  z3 = (((z3 & 4294967280) << 7) ^ b);
80104449:	31 ce                	xor    %ecx,%esi
8010444b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010444e:	c1 fe 15             	sar    $0x15,%esi
80104451:	89 c8                	mov    %ecx,%eax
80104453:	89 f1                	mov    %esi,%ecx
  b = (((z4 << 3) ^ z4) >> 12);
80104455:	8b 35 00 b0 10 80    	mov    0x8010b000,%esi
  b = (((z1 << 6) ^ z1) >> 13);
  z1 = (((z1 & 4294967294) << 18) ^ b);
  b = (((z2 << 2) ^ z2) >> 27);
  z2 = (((z2 & 4294967288) << 2) ^ b);
  b = (((z3 << 13) ^ z3) >> 21);
  z3 = (((z3 & 4294967280) << 7) ^ b);
8010445b:	c1 e0 07             	shl    $0x7,%eax
8010445e:	31 c1                	xor    %eax,%ecx
80104460:	31 ca                	xor    %ecx,%edx
80104462:	89 0d 04 b0 10 80    	mov    %ecx,0x8010b004
  b = (((z4 << 3) ^ z4) >> 12);
  z4 = (((z4 & 4294967168) << 13) ^ b);
80104468:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
8010446f:	31 f0                	xor    %esi,%eax
80104471:	83 e6 80             	and    $0xffffff80,%esi
80104474:	c1 f8 0c             	sar    $0xc,%eax
80104477:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010447a:	89 f0                	mov    %esi,%eax
8010447c:	c1 e0 0d             	shl    $0xd,%eax
8010447f:	33 45 ec             	xor    -0x14(%ebp),%eax
80104482:	a3 00 b0 10 80       	mov    %eax,0x8010b000
80104487:	31 d0                	xor    %edx,%eax
80104489:	99                   	cltd   
8010448a:	f7 7d 08             	idivl  0x8(%ebp)
  if(rand < 0) {
    rand = rand * -1;
  }

  return rand;
}
8010448d:	83 c4 0c             	add    $0xc,%esp
80104490:	5b                   	pop    %ebx
80104491:	5e                   	pop    %esi
80104492:	5f                   	pop    %edi
80104493:	5d                   	pop    %ebp
80104494:	89 d1                	mov    %edx,%ecx
80104496:	89 d0                	mov    %edx,%eax
80104498:	c1 f9 1f             	sar    $0x1f,%ecx
8010449b:	31 c8                	xor    %ecx,%eax
8010449d:	29 c8                	sub    %ecx,%eax
8010449f:	c3                   	ret    
801044a0:	83 c4 0c             	add    $0xc,%esp
found here: http://goo.gl/At4AIC */
int
random(int max) {

  if(max <= 0) {
    return 1;
801044a3:	b8 01 00 00 00       	mov    $0x1,%eax
  if(rand < 0) {
    rand = rand * -1;
  }

  return rand;
}
801044a8:	5b                   	pop    %ebx
801044a9:	5e                   	pop    %esi
801044aa:	5f                   	pop    %edi
801044ab:	5d                   	pop    %ebp
801044ac:	c3                   	ret    
801044ad:	8d 76 00             	lea    0x0(%esi),%esi

801044b0 <totalTickets>:

/* This method counts the total number of tickets that the runnable processes have
(the lottery is done only of the process which can execute) */
int
totalTickets(void) {
801044b0:	55                   	push   %ebp

	struct proc *p;
	int total = 0;
801044b1:	31 c0                	xor    %eax,%eax
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044b3:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
}

/* This method counts the total number of tickets that the runnable processes have
(the lottery is done only of the process which can execute) */
int
totalTickets(void) {
801044b8:	89 e5                	mov    %esp,%ebp
801044ba:	eb 12                	jmp    801044ce <totalTickets+0x1e>
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

	struct proc *p;
	int total = 0;
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044c0:	81 c2 94 00 00 00    	add    $0x94,%edx
801044c6:	81 fa 54 62 11 80    	cmp    $0x80116254,%edx
801044cc:	74 1a                	je     801044e8 <totalTickets+0x38>
		if (p->state == RUNNABLE) {
801044ce:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801044d2:	75 ec                	jne    801044c0 <totalTickets+0x10>
			total += p->tickets;
801044d4:	03 82 90 00 00 00    	add    0x90(%edx),%eax
int
totalTickets(void) {

	struct proc *p;
	int total = 0;
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044da:	81 c2 94 00 00 00    	add    $0x94,%edx
801044e0:	81 fa 54 62 11 80    	cmp    $0x80116254,%edx
801044e6:	75 e6                	jne    801044ce <totalTickets+0x1e>
			total += p->tickets;
		}
	}

	return total;
}
801044e8:	5d                   	pop    %ebp
801044e9:	c3                   	ret    
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044f0 <findReadyProcess>:

struct proc* findReadyProcess(int *index1, int *index2, int *index3, uint *priority) {
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	57                   	push   %edi
801044f4:	56                   	push   %esi
801044f5:	8b 45 14             	mov    0x14(%ebp),%eax
801044f8:	53                   	push   %ebx
801044f9:	8b 75 10             	mov    0x10(%ebp),%esi
801044fc:	8b 08                	mov    (%eax),%ecx
  int i;
  struct proc* proc2;
notfound:
  for (i = 0; i < NPROC; i++) {
801044fe:	31 d2                	xor    %edx,%edx
80104500:	eb 20                	jmp    80104522 <findReadyProcess+0x32>
80104502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(*priority) {
80104508:	83 f9 03             	cmp    $0x3,%ecx
8010450b:	74 44                	je     80104551 <findReadyProcess+0x61>
8010450d:	83 f9 01             	cmp    $0x1,%ecx
80104510:	0f 84 8a 00 00 00    	je     801045a0 <findReadyProcess+0xb0>

struct proc* findReadyProcess(int *index1, int *index2, int *index3, uint *priority) {
  int i;
  struct proc* proc2;
notfound:
  for (i = 0; i < NPROC; i++) {
80104516:	83 c2 01             	add    $0x1,%edx
80104519:	83 fa 40             	cmp    $0x40,%edx
8010451c:	0f 84 0e 01 00 00    	je     80104630 <findReadyProcess+0x140>
    switch(*priority) {
80104522:	83 f9 02             	cmp    $0x2,%ecx
80104525:	75 e1                	jne    80104508 <findReadyProcess+0x18>
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
          *index1 = (*index1 + 1 + i) % NPROC;
          return proc2; // found a runnable process with appropriate priority
        }
      case 2:
        proc2 = &ptable.proc[(*index2 + i) % NPROC];
80104527:	8b 45 0c             	mov    0xc(%ebp),%eax
8010452a:	8b 18                	mov    (%eax),%ebx
8010452c:	8d 04 13             	lea    (%ebx,%edx,1),%eax
8010452f:	89 c7                	mov    %eax,%edi
80104531:	c1 ff 1f             	sar    $0x1f,%edi
80104534:	c1 ef 1a             	shr    $0x1a,%edi
80104537:	01 f8                	add    %edi,%eax
80104539:	83 e0 3f             	and    $0x3f,%eax
8010453c:	29 f8                	sub    %edi,%eax
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
8010453e:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
80104544:	83 b8 60 3d 11 80 03 	cmpl   $0x3,-0x7feec2a0(%eax)
8010454b:	0f 84 af 00 00 00    	je     80104600 <findReadyProcess+0x110>
          *index2 = (*index2 + 1 + i) % NPROC;
          return proc2; // found a runnable process with appropriate priority
        }
      case 3:
        proc2 = &ptable.proc[(*index3 + i) % NPROC];
80104551:	8b 1e                	mov    (%esi),%ebx
80104553:	8d 04 13             	lea    (%ebx,%edx,1),%eax
80104556:	89 c7                	mov    %eax,%edi
80104558:	c1 ff 1f             	sar    $0x1f,%edi
8010455b:	c1 ef 1a             	shr    $0x1a,%edi
8010455e:	01 f8                	add    %edi,%eax
80104560:	83 e0 3f             	and    $0x3f,%eax
80104563:	29 f8                	sub    %edi,%eax
        if (proc2->state == RUNNABLE && proc2->priority == *priority){
80104565:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
8010456b:	83 b8 60 3d 11 80 03 	cmpl   $0x3,-0x7feec2a0(%eax)
80104572:	75 a2                	jne    80104516 <findReadyProcess+0x26>
80104574:	39 88 d0 3d 11 80    	cmp    %ecx,-0x7feec230(%eax)
8010457a:	75 9a                	jne    80104516 <findReadyProcess+0x26>
          *index3 = (*index3 + 1 + i) % NPROC;
8010457c:	8d 54 13 01          	lea    0x1(%ebx,%edx,1),%edx
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
          *index2 = (*index2 + 1 + i) % NPROC;
          return proc2; // found a runnable process with appropriate priority
        }
      case 3:
        proc2 = &ptable.proc[(*index3 + i) % NPROC];
80104580:	05 54 3d 11 80       	add    $0x80113d54,%eax
        if (proc2->state == RUNNABLE && proc2->priority == *priority){
          *index3 = (*index3 + 1 + i) % NPROC;
80104585:	89 d1                	mov    %edx,%ecx
80104587:	c1 f9 1f             	sar    $0x1f,%ecx
8010458a:	c1 e9 1a             	shr    $0x1a,%ecx
8010458d:	01 ca                	add    %ecx,%edx
8010458f:	83 e2 3f             	and    $0x3f,%edx
80104592:	29 ca                	sub    %ecx,%edx
80104594:	89 16                	mov    %edx,(%esi)
  else {
    *priority -= 1; //will try to find a process at a lower priority
    goto notfound;
  }
  return 0;
}
80104596:	5b                   	pop    %ebx
80104597:	5e                   	pop    %esi
80104598:	5f                   	pop    %edi
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret    
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc* proc2;
notfound:
  for (i = 0; i < NPROC; i++) {
    switch(*priority) {
      case 1:
        proc2 = &ptable.proc[(*index1 + i) % NPROC];
801045a0:	8b 45 08             	mov    0x8(%ebp),%eax
801045a3:	8b 18                	mov    (%eax),%ebx
801045a5:	8d 04 13             	lea    (%ebx,%edx,1),%eax
801045a8:	89 c7                	mov    %eax,%edi
801045aa:	c1 ff 1f             	sar    $0x1f,%edi
801045ad:	c1 ef 1a             	shr    $0x1a,%edi
801045b0:	01 f8                	add    %edi,%eax
801045b2:	83 e0 3f             	and    $0x3f,%eax
801045b5:	29 f8                	sub    %edi,%eax
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
801045b7:	69 c0 94 00 00 00    	imul   $0x94,%eax,%eax
801045bd:	83 b8 60 3d 11 80 03 	cmpl   $0x3,-0x7feec2a0(%eax)
801045c4:	0f 85 5d ff ff ff    	jne    80104527 <findReadyProcess+0x37>
801045ca:	83 b8 d0 3d 11 80 01 	cmpl   $0x1,-0x7feec230(%eax)
801045d1:	0f 85 50 ff ff ff    	jne    80104527 <findReadyProcess+0x37>
          *index1 = (*index1 + 1 + i) % NPROC;
801045d7:	8d 54 1a 01          	lea    0x1(%edx,%ebx,1),%edx
801045db:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc* proc2;
notfound:
  for (i = 0; i < NPROC; i++) {
    switch(*priority) {
      case 1:
        proc2 = &ptable.proc[(*index1 + i) % NPROC];
801045de:	05 54 3d 11 80       	add    $0x80113d54,%eax
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
          *index1 = (*index1 + 1 + i) % NPROC;
801045e3:	89 d1                	mov    %edx,%ecx
801045e5:	c1 f9 1f             	sar    $0x1f,%ecx
801045e8:	c1 e9 1a             	shr    $0x1a,%ecx
801045eb:	01 ca                	add    %ecx,%edx
801045ed:	83 e2 3f             	and    $0x3f,%edx
801045f0:	29 ca                	sub    %ecx,%edx
801045f2:	89 16                	mov    %edx,(%esi)
  else {
    *priority -= 1; //will try to find a process at a lower priority
    goto notfound;
  }
  return 0;
}
801045f4:	5b                   	pop    %ebx
801045f5:	5e                   	pop    %esi
801045f6:	5f                   	pop    %edi
801045f7:	5d                   	pop    %ebp
801045f8:	c3                   	ret    
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          *index1 = (*index1 + 1 + i) % NPROC;
          return proc2; // found a runnable process with appropriate priority
        }
      case 2:
        proc2 = &ptable.proc[(*index2 + i) % NPROC];
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
80104600:	39 88 d0 3d 11 80    	cmp    %ecx,-0x7feec230(%eax)
80104606:	0f 85 45 ff ff ff    	jne    80104551 <findReadyProcess+0x61>
          *index2 = (*index2 + 1 + i) % NPROC;
8010460c:	8d 54 13 01          	lea    0x1(%ebx,%edx,1),%edx
80104610:	8b 75 0c             	mov    0xc(%ebp),%esi
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
          *index1 = (*index1 + 1 + i) % NPROC;
          return proc2; // found a runnable process with appropriate priority
        }
      case 2:
        proc2 = &ptable.proc[(*index2 + i) % NPROC];
80104613:	05 54 3d 11 80       	add    $0x80113d54,%eax
        if (proc2->state == RUNNABLE && proc2->priority == *priority) {
          *index2 = (*index2 + 1 + i) % NPROC;
80104618:	89 d1                	mov    %edx,%ecx
8010461a:	c1 f9 1f             	sar    $0x1f,%ecx
8010461d:	c1 e9 1a             	shr    $0x1a,%ecx
80104620:	01 ca                	add    %ecx,%edx
80104622:	83 e2 3f             	and    $0x3f,%edx
80104625:	29 ca                	sub    %ecx,%edx
80104627:	89 16                	mov    %edx,(%esi)
  else {
    *priority -= 1; //will try to find a process at a lower priority
    goto notfound;
  }
  return 0;
}
80104629:	5b                   	pop    %ebx
8010462a:	5e                   	pop    %esi
8010462b:	5f                   	pop    %edi
8010462c:	5d                   	pop    %ebp
8010462d:	c3                   	ret    
8010462e:	66 90                	xchg   %ax,%ax
          *index3 = (*index3 + 1 + i) % NPROC;
          return proc2; // found a runnable process with appropriate priority
        }
    }
  }
  if (*priority == 1) {//did not find any process on any of the prorities
80104630:	83 f9 01             	cmp    $0x1,%ecx
80104633:	74 0d                	je     80104642 <findReadyProcess+0x152>
    *priority = 3;
    return 0;
  }
  else {
    *priority -= 1; //will try to find a process at a lower priority
80104635:	8b 45 14             	mov    0x14(%ebp),%eax
80104638:	83 e9 01             	sub    $0x1,%ecx
8010463b:	89 08                	mov    %ecx,(%eax)
    goto notfound;
8010463d:	e9 bc fe ff ff       	jmp    801044fe <findReadyProcess+0xe>
          return proc2; // found a runnable process with appropriate priority
        }
    }
  }
  if (*priority == 1) {//did not find any process on any of the prorities
    *priority = 3;
80104642:	8b 45 14             	mov    0x14(%ebp),%eax
80104645:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    return 0;
8010464b:	31 c0                	xor    %eax,%eax
8010464d:	e9 44 ff ff ff       	jmp    80104596 <findReadyProcess+0xa6>
80104652:	66 90                	xchg   %ax,%ax
80104654:	66 90                	xchg   %ax,%ax
80104656:	66 90                	xchg   %ax,%ax
80104658:	66 90                	xchg   %ax,%ax
8010465a:	66 90                	xchg   %ax,%ax
8010465c:	66 90                	xchg   %ax,%ax
8010465e:	66 90                	xchg   %ax,%ax

80104660 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 0c             	sub    $0xc,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010466a:	68 18 7d 10 80       	push   $0x80107d18
8010466f:	8d 43 04             	lea    0x4(%ebx),%eax
80104672:	50                   	push   %eax
80104673:	e8 f8 00 00 00       	call   80104770 <initlock>
  lk->name = name;
80104678:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010467b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104681:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104684:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010468b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010468e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104691:	c9                   	leave  
80104692:	c3                   	ret    
80104693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	8d 73 04             	lea    0x4(%ebx),%esi
801046ae:	56                   	push   %esi
801046af:	e8 bc 01 00 00       	call   80104870 <acquire>
  while (lk->locked) {
801046b4:	8b 13                	mov    (%ebx),%edx
801046b6:	83 c4 10             	add    $0x10,%esp
801046b9:	85 d2                	test   %edx,%edx
801046bb:	74 16                	je     801046d3 <acquiresleep+0x33>
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801046c0:	83 ec 08             	sub    $0x8,%esp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	e8 d6 f6 ff ff       	call   80103da0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801046ca:	8b 03                	mov    (%ebx),%eax
801046cc:	83 c4 10             	add    $0x10,%esp
801046cf:	85 c0                	test   %eax,%eax
801046d1:	75 ed                	jne    801046c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801046d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046d9:	e8 d2 f0 ff ff       	call   801037b0 <myproc>
801046de:	8b 40 10             	mov    0x10(%eax),%eax
801046e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046ea:	5b                   	pop    %ebx
801046eb:	5e                   	pop    %esi
801046ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801046ed:	e9 9e 02 00 00       	jmp    80104990 <release>
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	8d 73 04             	lea    0x4(%ebx),%esi
8010470e:	56                   	push   %esi
8010470f:	e8 5c 01 00 00       	call   80104870 <acquire>
  lk->locked = 0;
80104714:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010471a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104721:	89 1c 24             	mov    %ebx,(%esp)
80104724:	e8 d7 f9 ff ff       	call   80104100 <wakeup>
  release(&lk->lk);
80104729:	89 75 08             	mov    %esi,0x8(%ebp)
8010472c:	83 c4 10             	add    $0x10,%esp
}
8010472f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104732:	5b                   	pop    %ebx
80104733:	5e                   	pop    %esi
80104734:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104735:	e9 56 02 00 00       	jmp    80104990 <release>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104740 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104748:	83 ec 0c             	sub    $0xc,%esp
8010474b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010474e:	53                   	push   %ebx
8010474f:	e8 1c 01 00 00       	call   80104870 <acquire>
  r = lk->locked;
80104754:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104756:	89 1c 24             	mov    %ebx,(%esp)
80104759:	e8 32 02 00 00       	call   80104990 <release>
  return r;
}
8010475e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104761:	89 f0                	mov    %esi,%eax
80104763:	5b                   	pop    %ebx
80104764:	5e                   	pop    %esi
80104765:	5d                   	pop    %ebp
80104766:	c3                   	ret    
80104767:	66 90                	xchg   %ax,%ax
80104769:	66 90                	xchg   %ax,%ax
8010476b:	66 90                	xchg   %ax,%ax
8010476d:	66 90                	xchg   %ax,%ax
8010476f:	90                   	nop

80104770 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104776:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104779:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010477f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104782:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104789:	5d                   	pop    %ebp
8010478a:	c3                   	ret    
8010478b:	90                   	nop
8010478c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104790 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104794:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104797:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010479a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010479d:	31 c0                	xor    %eax,%eax
8010479f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801047a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047ac:	77 1a                	ja     801047c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801047b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801047b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047b9:	83 f8 0a             	cmp    $0xa,%eax
801047bc:	75 e2                	jne    801047a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047be:	5b                   	pop    %ebx
801047bf:	5d                   	pop    %ebp
801047c0:	c3                   	ret    
801047c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801047c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801047cf:	83 c0 01             	add    $0x1,%eax
801047d2:	83 f8 0a             	cmp    $0xa,%eax
801047d5:	74 e7                	je     801047be <getcallerpcs+0x2e>
    pcs[i] = 0;
801047d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801047de:	83 c0 01             	add    $0x1,%eax
801047e1:	83 f8 0a             	cmp    $0xa,%eax
801047e4:	75 e2                	jne    801047c8 <getcallerpcs+0x38>
801047e6:	eb d6                	jmp    801047be <getcallerpcs+0x2e>
801047e8:	90                   	nop
801047e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 04             	sub    $0x4,%esp
801047f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801047fa:	8b 02                	mov    (%edx),%eax
801047fc:	85 c0                	test   %eax,%eax
801047fe:	75 10                	jne    80104810 <holding+0x20>
}
80104800:	83 c4 04             	add    $0x4,%esp
80104803:	31 c0                	xor    %eax,%eax
80104805:	5b                   	pop    %ebx
80104806:	5d                   	pop    %ebp
80104807:	c3                   	ret    
80104808:	90                   	nop
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104810:	8b 5a 08             	mov    0x8(%edx),%ebx
80104813:	e8 f8 ee ff ff       	call   80103710 <mycpu>
80104818:	39 c3                	cmp    %eax,%ebx
8010481a:	0f 94 c0             	sete   %al
}
8010481d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104820:	0f b6 c0             	movzbl %al,%eax
}
80104823:	5b                   	pop    %ebx
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
80104826:	8d 76 00             	lea    0x0(%esi),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 04             	sub    $0x4,%esp
80104837:	9c                   	pushf  
80104838:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104839:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010483a:	e8 d1 ee ff ff       	call   80103710 <mycpu>
8010483f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104845:	85 c0                	test   %eax,%eax
80104847:	75 11                	jne    8010485a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104849:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010484f:	e8 bc ee ff ff       	call   80103710 <mycpu>
80104854:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010485a:	e8 b1 ee ff ff       	call   80103710 <mycpu>
8010485f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104866:	83 c4 04             	add    $0x4,%esp
80104869:	5b                   	pop    %ebx
8010486a:	5d                   	pop    %ebp
8010486b:	c3                   	ret    
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104875:	e8 b6 ff ff ff       	call   80104830 <pushcli>
  if(holding(lk))
8010487a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010487d:	8b 03                	mov    (%ebx),%eax
8010487f:	85 c0                	test   %eax,%eax
80104881:	75 7d                	jne    80104900 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104883:	ba 01 00 00 00       	mov    $0x1,%edx
80104888:	eb 09                	jmp    80104893 <acquire+0x23>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104890:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104893:	89 d0                	mov    %edx,%eax
80104895:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104898:	85 c0                	test   %eax,%eax
8010489a:	75 f4                	jne    80104890 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010489c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801048a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048a4:	e8 67 ee ff ff       	call   80103710 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801048a9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801048ab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801048ae:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048b1:	31 c0                	xor    %eax,%eax
801048b3:	90                   	nop
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048c4:	77 1a                	ja     801048e0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801048c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801048c9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048cc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801048cf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801048d1:	83 f8 0a             	cmp    $0xa,%eax
801048d4:	75 e2                	jne    801048b8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801048d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801048e0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801048e7:	83 c0 01             	add    $0x1,%eax
801048ea:	83 f8 0a             	cmp    $0xa,%eax
801048ed:	74 e7                	je     801048d6 <acquire+0x66>
    pcs[i] = 0;
801048ef:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801048f6:	83 c0 01             	add    $0x1,%eax
801048f9:	83 f8 0a             	cmp    $0xa,%eax
801048fc:	75 e2                	jne    801048e0 <acquire+0x70>
801048fe:	eb d6                	jmp    801048d6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104900:	8b 73 08             	mov    0x8(%ebx),%esi
80104903:	e8 08 ee ff ff       	call   80103710 <mycpu>
80104908:	39 c6                	cmp    %eax,%esi
8010490a:	0f 85 73 ff ff ff    	jne    80104883 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104910:	83 ec 0c             	sub    $0xc,%esp
80104913:	68 23 7d 10 80       	push   $0x80107d23
80104918:	e8 53 ba ff ff       	call   80100370 <panic>
8010491d:	8d 76 00             	lea    0x0(%esi),%esi

80104920 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104926:	9c                   	pushf  
80104927:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104928:	f6 c4 02             	test   $0x2,%ah
8010492b:	75 52                	jne    8010497f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010492d:	e8 de ed ff ff       	call   80103710 <mycpu>
80104932:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104938:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010493b:	85 d2                	test   %edx,%edx
8010493d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104943:	78 2d                	js     80104972 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104945:	e8 c6 ed ff ff       	call   80103710 <mycpu>
8010494a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104950:	85 d2                	test   %edx,%edx
80104952:	74 0c                	je     80104960 <popcli+0x40>
    sti();
}
80104954:	c9                   	leave  
80104955:	c3                   	ret    
80104956:	8d 76 00             	lea    0x0(%esi),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104960:	e8 ab ed ff ff       	call   80103710 <mycpu>
80104965:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010496b:	85 c0                	test   %eax,%eax
8010496d:	74 e5                	je     80104954 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010496f:	fb                   	sti    
    sti();
}
80104970:	c9                   	leave  
80104971:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104972:	83 ec 0c             	sub    $0xc,%esp
80104975:	68 42 7d 10 80       	push   $0x80107d42
8010497a:	e8 f1 b9 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010497f:	83 ec 0c             	sub    $0xc,%esp
80104982:	68 2b 7d 10 80       	push   $0x80107d2b
80104987:	e8 e4 b9 ff ff       	call   80100370 <panic>
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104990 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
80104995:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104998:	8b 03                	mov    (%ebx),%eax
8010499a:	85 c0                	test   %eax,%eax
8010499c:	75 12                	jne    801049b0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010499e:	83 ec 0c             	sub    $0xc,%esp
801049a1:	68 49 7d 10 80       	push   $0x80107d49
801049a6:	e8 c5 b9 ff ff       	call   80100370 <panic>
801049ab:	90                   	nop
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801049b0:	8b 73 08             	mov    0x8(%ebx),%esi
801049b3:	e8 58 ed ff ff       	call   80103710 <mycpu>
801049b8:	39 c6                	cmp    %eax,%esi
801049ba:	75 e2                	jne    8010499e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801049bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801049ca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801049d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d8:	5b                   	pop    %ebx
801049d9:	5e                   	pop    %esi
801049da:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801049db:	e9 40 ff ff ff       	jmp    80104920 <popcli>

801049e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	53                   	push   %ebx
801049e5:	8b 55 08             	mov    0x8(%ebp),%edx
801049e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049eb:	f6 c2 03             	test   $0x3,%dl
801049ee:	75 05                	jne    801049f5 <memset+0x15>
801049f0:	f6 c1 03             	test   $0x3,%cl
801049f3:	74 13                	je     80104a08 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801049f5:	89 d7                	mov    %edx,%edi
801049f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801049fa:	fc                   	cld    
801049fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801049fd:	5b                   	pop    %ebx
801049fe:	89 d0                	mov    %edx,%eax
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104a08:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104a0c:	c1 e9 02             	shr    $0x2,%ecx
80104a0f:	89 fb                	mov    %edi,%ebx
80104a11:	89 f8                	mov    %edi,%eax
80104a13:	c1 e3 18             	shl    $0x18,%ebx
80104a16:	c1 e0 10             	shl    $0x10,%eax
80104a19:	09 d8                	or     %ebx,%eax
80104a1b:	09 f8                	or     %edi,%eax
80104a1d:	c1 e7 08             	shl    $0x8,%edi
80104a20:	09 f8                	or     %edi,%eax
80104a22:	89 d7                	mov    %edx,%edi
80104a24:	fc                   	cld    
80104a25:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a27:	5b                   	pop    %ebx
80104a28:	89 d0                	mov    %edx,%eax
80104a2a:	5f                   	pop    %edi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	8b 45 10             	mov    0x10(%ebp),%eax
80104a38:	53                   	push   %ebx
80104a39:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a3f:	85 c0                	test   %eax,%eax
80104a41:	74 29                	je     80104a6c <memcmp+0x3c>
    if(*s1 != *s2)
80104a43:	0f b6 13             	movzbl (%ebx),%edx
80104a46:	0f b6 0e             	movzbl (%esi),%ecx
80104a49:	38 d1                	cmp    %dl,%cl
80104a4b:	75 2b                	jne    80104a78 <memcmp+0x48>
80104a4d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104a50:	31 c0                	xor    %eax,%eax
80104a52:	eb 14                	jmp    80104a68 <memcmp+0x38>
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104a5d:	83 c0 01             	add    $0x1,%eax
80104a60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a64:	38 ca                	cmp    %cl,%dl
80104a66:	75 10                	jne    80104a78 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a68:	39 f8                	cmp    %edi,%eax
80104a6a:	75 ec                	jne    80104a58 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a6c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104a6d:	31 c0                	xor    %eax,%eax
}
80104a6f:	5e                   	pop    %esi
80104a70:	5f                   	pop    %edi
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret    
80104a73:	90                   	nop
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104a78:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104a7b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104a7c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104a7e:	5e                   	pop    %esi
80104a7f:	5f                   	pop    %edi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 45 08             	mov    0x8(%ebp),%eax
80104a98:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a9e:	39 c6                	cmp    %eax,%esi
80104aa0:	73 2e                	jae    80104ad0 <memmove+0x40>
80104aa2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104aa5:	39 c8                	cmp    %ecx,%eax
80104aa7:	73 27                	jae    80104ad0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104aa9:	85 db                	test   %ebx,%ebx
80104aab:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104aae:	74 17                	je     80104ac7 <memmove+0x37>
      *--d = *--s;
80104ab0:	29 d9                	sub    %ebx,%ecx
80104ab2:	89 cb                	mov    %ecx,%ebx
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ab8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104abc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104abf:	83 ea 01             	sub    $0x1,%edx
80104ac2:	83 fa ff             	cmp    $0xffffffff,%edx
80104ac5:	75 f1                	jne    80104ab8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ac7:	5b                   	pop    %ebx
80104ac8:	5e                   	pop    %esi
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret    
80104acb:	90                   	nop
80104acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104ad0:	31 d2                	xor    %edx,%edx
80104ad2:	85 db                	test   %ebx,%ebx
80104ad4:	74 f1                	je     80104ac7 <memmove+0x37>
80104ad6:	8d 76 00             	lea    0x0(%esi),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104ae0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104ae4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ae7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104aea:	39 d3                	cmp    %edx,%ebx
80104aec:	75 f2                	jne    80104ae0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104aee:	5b                   	pop    %ebx
80104aef:	5e                   	pop    %esi
80104af0:	5d                   	pop    %ebp
80104af1:	c3                   	ret    
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b03:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104b04:	eb 8a                	jmp    80104a90 <memmove>
80104b06:	8d 76 00             	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b18:	53                   	push   %ebx
80104b19:	8b 7d 08             	mov    0x8(%ebp),%edi
80104b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b1f:	85 c9                	test   %ecx,%ecx
80104b21:	74 37                	je     80104b5a <strncmp+0x4a>
80104b23:	0f b6 17             	movzbl (%edi),%edx
80104b26:	0f b6 1e             	movzbl (%esi),%ebx
80104b29:	84 d2                	test   %dl,%dl
80104b2b:	74 3f                	je     80104b6c <strncmp+0x5c>
80104b2d:	38 d3                	cmp    %dl,%bl
80104b2f:	75 3b                	jne    80104b6c <strncmp+0x5c>
80104b31:	8d 47 01             	lea    0x1(%edi),%eax
80104b34:	01 cf                	add    %ecx,%edi
80104b36:	eb 1b                	jmp    80104b53 <strncmp+0x43>
80104b38:	90                   	nop
80104b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b40:	0f b6 10             	movzbl (%eax),%edx
80104b43:	84 d2                	test   %dl,%dl
80104b45:	74 21                	je     80104b68 <strncmp+0x58>
80104b47:	0f b6 19             	movzbl (%ecx),%ebx
80104b4a:	83 c0 01             	add    $0x1,%eax
80104b4d:	89 ce                	mov    %ecx,%esi
80104b4f:	38 da                	cmp    %bl,%dl
80104b51:	75 19                	jne    80104b6c <strncmp+0x5c>
80104b53:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104b55:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104b58:	75 e6                	jne    80104b40 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b5a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104b5b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104b5d:	5e                   	pop    %esi
80104b5e:	5f                   	pop    %edi
80104b5f:	5d                   	pop    %ebp
80104b60:	c3                   	ret    
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b68:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b6c:	0f b6 c2             	movzbl %dl,%eax
80104b6f:	29 d8                	sub    %ebx,%eax
}
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5f                   	pop    %edi
80104b74:	5d                   	pop    %ebp
80104b75:	c3                   	ret    
80104b76:	8d 76 00             	lea    0x0(%esi),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 45 08             	mov    0x8(%ebp),%eax
80104b88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b8e:	89 c2                	mov    %eax,%edx
80104b90:	eb 19                	jmp    80104bab <strncpy+0x2b>
80104b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b98:	83 c3 01             	add    $0x1,%ebx
80104b9b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b9f:	83 c2 01             	add    $0x1,%edx
80104ba2:	84 c9                	test   %cl,%cl
80104ba4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ba7:	74 09                	je     80104bb2 <strncpy+0x32>
80104ba9:	89 f1                	mov    %esi,%ecx
80104bab:	85 c9                	test   %ecx,%ecx
80104bad:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104bb0:	7f e6                	jg     80104b98 <strncpy+0x18>
    ;
  while(n-- > 0)
80104bb2:	31 c9                	xor    %ecx,%ecx
80104bb4:	85 f6                	test   %esi,%esi
80104bb6:	7e 17                	jle    80104bcf <strncpy+0x4f>
80104bb8:	90                   	nop
80104bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104bc0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104bc4:	89 f3                	mov    %esi,%ebx
80104bc6:	83 c1 01             	add    $0x1,%ecx
80104bc9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104bcb:	85 db                	test   %ebx,%ebx
80104bcd:	7f f1                	jg     80104bc0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104bcf:	5b                   	pop    %ebx
80104bd0:	5e                   	pop    %esi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	56                   	push   %esi
80104be4:	53                   	push   %ebx
80104be5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104be8:	8b 45 08             	mov    0x8(%ebp),%eax
80104beb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104bee:	85 c9                	test   %ecx,%ecx
80104bf0:	7e 26                	jle    80104c18 <safestrcpy+0x38>
80104bf2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104bf6:	89 c1                	mov    %eax,%ecx
80104bf8:	eb 17                	jmp    80104c11 <safestrcpy+0x31>
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c00:	83 c2 01             	add    $0x1,%edx
80104c03:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c07:	83 c1 01             	add    $0x1,%ecx
80104c0a:	84 db                	test   %bl,%bl
80104c0c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c0f:	74 04                	je     80104c15 <safestrcpy+0x35>
80104c11:	39 f2                	cmp    %esi,%edx
80104c13:	75 eb                	jne    80104c00 <safestrcpy+0x20>
    ;
  *s = 0;
80104c15:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c18:	5b                   	pop    %ebx
80104c19:	5e                   	pop    %esi
80104c1a:	5d                   	pop    %ebp
80104c1b:	c3                   	ret    
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c20 <strlen>:

int
strlen(const char *s)
{
80104c20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c21:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104c23:	89 e5                	mov    %esp,%ebp
80104c25:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104c28:	80 3a 00             	cmpb   $0x0,(%edx)
80104c2b:	74 0c                	je     80104c39 <strlen+0x19>
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
80104c30:	83 c0 01             	add    $0x1,%eax
80104c33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c37:	75 f7                	jne    80104c30 <strlen+0x10>
    ;
  return n;
}
80104c39:	5d                   	pop    %ebp
80104c3a:	c3                   	ret    

80104c3b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c3b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c3f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104c43:	55                   	push   %ebp
  pushl %ebx
80104c44:	53                   	push   %ebx
  pushl %esi
80104c45:	56                   	push   %esi
  pushl %edi
80104c46:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c47:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c49:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104c4b:	5f                   	pop    %edi
  popl %esi
80104c4c:	5e                   	pop    %esi
  popl %ebx
80104c4d:	5b                   	pop    %ebx
  popl %ebp
80104c4e:	5d                   	pop    %ebp
  ret
80104c4f:	c3                   	ret    

80104c50 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	53                   	push   %ebx
80104c54:	83 ec 04             	sub    $0x4,%esp
80104c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c5a:	e8 51 eb ff ff       	call   801037b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c5f:	8b 00                	mov    (%eax),%eax
80104c61:	39 d8                	cmp    %ebx,%eax
80104c63:	76 1b                	jbe    80104c80 <fetchint+0x30>
80104c65:	8d 53 04             	lea    0x4(%ebx),%edx
80104c68:	39 d0                	cmp    %edx,%eax
80104c6a:	72 14                	jb     80104c80 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c6f:	8b 13                	mov    (%ebx),%edx
80104c71:	89 10                	mov    %edx,(%eax)
  return 0;
80104c73:	31 c0                	xor    %eax,%eax
}
80104c75:	83 c4 04             	add    $0x4,%esp
80104c78:	5b                   	pop    %ebx
80104c79:	5d                   	pop    %ebp
80104c7a:	c3                   	ret    
80104c7b:	90                   	nop
80104c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c85:	eb ee                	jmp    80104c75 <fetchint+0x25>
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
80104c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c9a:	e8 11 eb ff ff       	call   801037b0 <myproc>

  if(addr >= curproc->sz)
80104c9f:	39 18                	cmp    %ebx,(%eax)
80104ca1:	76 29                	jbe    80104ccc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ca6:	89 da                	mov    %ebx,%edx
80104ca8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104caa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104cac:	39 c3                	cmp    %eax,%ebx
80104cae:	73 1c                	jae    80104ccc <fetchstr+0x3c>
    if(*s == 0)
80104cb0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104cb3:	75 10                	jne    80104cc5 <fetchstr+0x35>
80104cb5:	eb 29                	jmp    80104ce0 <fetchstr+0x50>
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cc0:	80 3a 00             	cmpb   $0x0,(%edx)
80104cc3:	74 1b                	je     80104ce0 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104cc5:	83 c2 01             	add    $0x1,%edx
80104cc8:	39 d0                	cmp    %edx,%eax
80104cca:	77 f4                	ja     80104cc0 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104ccc:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104ccf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104cd4:	5b                   	pop    %ebx
80104cd5:	5d                   	pop    %ebp
80104cd6:	c3                   	ret    
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ce0:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104ce3:	89 d0                	mov    %edx,%eax
80104ce5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ce7:	5b                   	pop    %ebx
80104ce8:	5d                   	pop    %ebp
80104ce9:	c3                   	ret    
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cf0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cf5:	e8 b6 ea ff ff       	call   801037b0 <myproc>
80104cfa:	8b 40 18             	mov    0x18(%eax),%eax
80104cfd:	8b 55 08             	mov    0x8(%ebp),%edx
80104d00:	8b 40 44             	mov    0x44(%eax),%eax
80104d03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104d06:	e8 a5 ea ff ff       	call   801037b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d0b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d0d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d10:	39 c6                	cmp    %eax,%esi
80104d12:	73 1c                	jae    80104d30 <argint+0x40>
80104d14:	8d 53 08             	lea    0x8(%ebx),%edx
80104d17:	39 d0                	cmp    %edx,%eax
80104d19:	72 15                	jb     80104d30 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d21:	89 10                	mov    %edx,(%eax)
  return 0;
80104d23:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104d25:	5b                   	pop    %ebx
80104d26:	5e                   	pop    %esi
80104d27:	5d                   	pop    %ebp
80104d28:	c3                   	ret    
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d35:	eb ee                	jmp    80104d25 <argint+0x35>
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	83 ec 10             	sub    $0x10,%esp
80104d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d4b:	e8 60 ea ff ff       	call   801037b0 <myproc>
80104d50:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
80104d52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d55:	83 ec 08             	sub    $0x8,%esp
80104d58:	50                   	push   %eax
80104d59:	ff 75 08             	pushl  0x8(%ebp)
80104d5c:	e8 8f ff ff ff       	call   80104cf0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d61:	c1 e8 1f             	shr    $0x1f,%eax
80104d64:	83 c4 10             	add    $0x10,%esp
80104d67:	84 c0                	test   %al,%al
80104d69:	75 2d                	jne    80104d98 <argptr+0x58>
80104d6b:	89 d8                	mov    %ebx,%eax
80104d6d:	c1 e8 1f             	shr    $0x1f,%eax
80104d70:	84 c0                	test   %al,%al
80104d72:	75 24                	jne    80104d98 <argptr+0x58>
80104d74:	8b 16                	mov    (%esi),%edx
80104d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d79:	39 c2                	cmp    %eax,%edx
80104d7b:	76 1b                	jbe    80104d98 <argptr+0x58>
80104d7d:	01 c3                	add    %eax,%ebx
80104d7f:	39 da                	cmp    %ebx,%edx
80104d81:	72 15                	jb     80104d98 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104d83:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d86:	89 02                	mov    %eax,(%edx)
  return 0;
80104d88:	31 c0                	xor    %eax,%eax
}
80104d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d8d:	5b                   	pop    %ebx
80104d8e:	5e                   	pop    %esi
80104d8f:	5d                   	pop    %ebp
80104d90:	c3                   	ret    
80104d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d9d:	eb eb                	jmp    80104d8a <argptr+0x4a>
80104d9f:	90                   	nop

80104da0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da9:	50                   	push   %eax
80104daa:	ff 75 08             	pushl  0x8(%ebp)
80104dad:	e8 3e ff ff ff       	call   80104cf0 <argint>
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	85 c0                	test   %eax,%eax
80104db7:	78 17                	js     80104dd0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104db9:	83 ec 08             	sub    $0x8,%esp
80104dbc:	ff 75 0c             	pushl  0xc(%ebp)
80104dbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104dc2:	e8 c9 fe ff ff       	call   80104c90 <fetchstr>
80104dc7:	83 c4 10             	add    $0x10,%esp
}
80104dca:	c9                   	leave  
80104dcb:	c3                   	ret    
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <syscall>:
[SYS_chtickets]    sys_chtickets,
};

void
syscall(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104de5:	e8 c6 e9 ff ff       	call   801037b0 <myproc>

  num = curproc->tf->eax;
80104dea:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104ded:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104def:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104df2:	8d 50 ff             	lea    -0x1(%eax),%edx
80104df5:	83 fa 1a             	cmp    $0x1a,%edx
80104df8:	77 1e                	ja     80104e18 <syscall+0x38>
80104dfa:	8b 14 85 80 7d 10 80 	mov    -0x7fef8280(,%eax,4),%edx
80104e01:	85 d2                	test   %edx,%edx
80104e03:	74 13                	je     80104e18 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104e05:	ff d2                	call   *%edx
80104e07:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e0d:	5b                   	pop    %ebx
80104e0e:	5e                   	pop    %esi
80104e0f:	5d                   	pop    %ebp
80104e10:	c3                   	ret    
80104e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104e18:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e19:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104e1c:	50                   	push   %eax
80104e1d:	ff 73 10             	pushl  0x10(%ebx)
80104e20:	68 51 7d 10 80       	push   $0x80107d51
80104e25:	e8 36 b8 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104e2a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e2d:	83 c4 10             	add    $0x10,%esp
80104e30:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104e37:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e3a:	5b                   	pop    %ebx
80104e3b:	5e                   	pop    %esi
80104e3c:	5d                   	pop    %ebp
80104e3d:	c3                   	ret    
80104e3e:	66 90                	xchg   %ax,%ax

80104e40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e46:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e49:	83 ec 44             	sub    $0x44,%esp
80104e4c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e52:	56                   	push   %esi
80104e53:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e54:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104e57:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e5a:	e8 81 d0 ff ff       	call   80101ee0 <nameiparent>
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	85 c0                	test   %eax,%eax
80104e64:	0f 84 f6 00 00 00    	je     80104f60 <create+0x120>
    return 0;
  ilock(dp);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	89 c7                	mov    %eax,%edi
80104e6f:	50                   	push   %eax
80104e70:	e8 fb c7 ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104e75:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e78:	83 c4 0c             	add    $0xc,%esp
80104e7b:	50                   	push   %eax
80104e7c:	56                   	push   %esi
80104e7d:	57                   	push   %edi
80104e7e:	e8 1d cd ff ff       	call   80101ba0 <dirlookup>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	89 c3                	mov    %eax,%ebx
80104e8a:	74 54                	je     80104ee0 <create+0xa0>
    iunlockput(dp);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	57                   	push   %edi
80104e90:	e8 6b ca ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104e95:	89 1c 24             	mov    %ebx,(%esp)
80104e98:	e8 d3 c7 ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e9d:	83 c4 10             	add    $0x10,%esp
80104ea0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ea5:	75 19                	jne    80104ec0 <create+0x80>
80104ea7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104eac:	89 d8                	mov    %ebx,%eax
80104eae:	75 10                	jne    80104ec0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb3:	5b                   	pop    %ebx
80104eb4:	5e                   	pop    %esi
80104eb5:	5f                   	pop    %edi
80104eb6:	5d                   	pop    %ebp
80104eb7:	c3                   	ret    
80104eb8:	90                   	nop
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
80104ec3:	53                   	push   %ebx
80104ec4:	e8 37 ca ff ff       	call   80101900 <iunlockput>
    return 0;
80104ec9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104ecf:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ed1:	5b                   	pop    %ebx
80104ed2:	5e                   	pop    %esi
80104ed3:	5f                   	pop    %edi
80104ed4:	5d                   	pop    %ebp
80104ed5:	c3                   	ret    
80104ed6:	8d 76 00             	lea    0x0(%esi),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104ee0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ee4:	83 ec 08             	sub    $0x8,%esp
80104ee7:	50                   	push   %eax
80104ee8:	ff 37                	pushl  (%edi)
80104eea:	e8 11 c6 ff ff       	call   80101500 <ialloc>
80104eef:	83 c4 10             	add    $0x10,%esp
80104ef2:	85 c0                	test   %eax,%eax
80104ef4:	89 c3                	mov    %eax,%ebx
80104ef6:	0f 84 cc 00 00 00    	je     80104fc8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	50                   	push   %eax
80104f00:	e8 6b c7 ff ff       	call   80101670 <ilock>
  ip->major = major;
80104f05:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104f09:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104f0d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104f11:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104f15:	b8 01 00 00 00       	mov    $0x1,%eax
80104f1a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104f1e:	89 1c 24             	mov    %ebx,(%esp)
80104f21:	e8 9a c6 ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104f26:	83 c4 10             	add    $0x10,%esp
80104f29:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f2e:	74 40                	je     80104f70 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104f30:	83 ec 04             	sub    $0x4,%esp
80104f33:	ff 73 04             	pushl  0x4(%ebx)
80104f36:	56                   	push   %esi
80104f37:	57                   	push   %edi
80104f38:	e8 c3 ce ff ff       	call   80101e00 <dirlink>
80104f3d:	83 c4 10             	add    $0x10,%esp
80104f40:	85 c0                	test   %eax,%eax
80104f42:	78 77                	js     80104fbb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104f44:	83 ec 0c             	sub    $0xc,%esp
80104f47:	57                   	push   %edi
80104f48:	e8 b3 c9 ff ff       	call   80101900 <iunlockput>

  return ip;
80104f4d:	83 c4 10             	add    $0x10,%esp
}
80104f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104f53:	89 d8                	mov    %ebx,%eax
}
80104f55:	5b                   	pop    %ebx
80104f56:	5e                   	pop    %esi
80104f57:	5f                   	pop    %edi
80104f58:	5d                   	pop    %ebp
80104f59:	c3                   	ret    
80104f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104f60:	31 c0                	xor    %eax,%eax
80104f62:	e9 49 ff ff ff       	jmp    80104eb0 <create+0x70>
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104f70:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104f75:	83 ec 0c             	sub    $0xc,%esp
80104f78:	57                   	push   %edi
80104f79:	e8 42 c6 ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f7e:	83 c4 0c             	add    $0xc,%esp
80104f81:	ff 73 04             	pushl  0x4(%ebx)
80104f84:	68 0c 7e 10 80       	push   $0x80107e0c
80104f89:	53                   	push   %ebx
80104f8a:	e8 71 ce ff ff       	call   80101e00 <dirlink>
80104f8f:	83 c4 10             	add    $0x10,%esp
80104f92:	85 c0                	test   %eax,%eax
80104f94:	78 18                	js     80104fae <create+0x16e>
80104f96:	83 ec 04             	sub    $0x4,%esp
80104f99:	ff 77 04             	pushl  0x4(%edi)
80104f9c:	68 0b 7e 10 80       	push   $0x80107e0b
80104fa1:	53                   	push   %ebx
80104fa2:	e8 59 ce ff ff       	call   80101e00 <dirlink>
80104fa7:	83 c4 10             	add    $0x10,%esp
80104faa:	85 c0                	test   %eax,%eax
80104fac:	79 82                	jns    80104f30 <create+0xf0>
      panic("create dots");
80104fae:	83 ec 0c             	sub    $0xc,%esp
80104fb1:	68 ff 7d 10 80       	push   $0x80107dff
80104fb6:	e8 b5 b3 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104fbb:	83 ec 0c             	sub    $0xc,%esp
80104fbe:	68 0e 7e 10 80       	push   $0x80107e0e
80104fc3:	e8 a8 b3 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104fc8:	83 ec 0c             	sub    $0xc,%esp
80104fcb:	68 f0 7d 10 80       	push   $0x80107df0
80104fd0:	e8 9b b3 ff ff       	call   80100370 <panic>
80104fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fe0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fe7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104fea:	89 d3                	mov    %edx,%ebx
80104fec:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104fef:	50                   	push   %eax
80104ff0:	6a 00                	push   $0x0
80104ff2:	e8 f9 fc ff ff       	call   80104cf0 <argint>
80104ff7:	83 c4 10             	add    $0x10,%esp
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	78 32                	js     80105030 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105002:	77 2c                	ja     80105030 <argfd.constprop.0+0x50>
80105004:	e8 a7 e7 ff ff       	call   801037b0 <myproc>
80105009:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010500c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105010:	85 c0                	test   %eax,%eax
80105012:	74 1c                	je     80105030 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105014:	85 f6                	test   %esi,%esi
80105016:	74 02                	je     8010501a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105018:	89 16                	mov    %edx,(%esi)
  if(pf)
8010501a:	85 db                	test   %ebx,%ebx
8010501c:	74 22                	je     80105040 <argfd.constprop.0+0x60>
    *pf = f;
8010501e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105020:	31 c0                	xor    %eax,%eax
}
80105022:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105025:	5b                   	pop    %ebx
80105026:	5e                   	pop    %esi
80105027:	5d                   	pop    %ebp
80105028:	c3                   	ret    
80105029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105030:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105038:	5b                   	pop    %ebx
80105039:	5e                   	pop    %esi
8010503a:	5d                   	pop    %ebp
8010503b:	c3                   	ret    
8010503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105040:	31 c0                	xor    %eax,%eax
80105042:	eb de                	jmp    80105022 <argfd.constprop.0+0x42>
80105044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010504a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105050 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105050:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105051:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	56                   	push   %esi
80105056:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105057:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010505a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010505d:	e8 7e ff ff ff       	call   80104fe0 <argfd.constprop.0>
80105062:	85 c0                	test   %eax,%eax
80105064:	78 1a                	js     80105080 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105066:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105068:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010506b:	e8 40 e7 ff ff       	call   801037b0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105070:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105074:	85 d2                	test   %edx,%edx
80105076:	74 18                	je     80105090 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105078:	83 c3 01             	add    $0x1,%ebx
8010507b:	83 fb 10             	cmp    $0x10,%ebx
8010507e:	75 f0                	jne    80105070 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105080:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105088:	5b                   	pop    %ebx
80105089:	5e                   	pop    %esi
8010508a:	5d                   	pop    %ebp
8010508b:	c3                   	ret    
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105090:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105094:	83 ec 0c             	sub    $0xc,%esp
80105097:	ff 75 f4             	pushl  -0xc(%ebp)
8010509a:	e8 41 bd ff ff       	call   80100de0 <filedup>
  return fd;
8010509f:	83 c4 10             	add    $0x10,%esp
}
801050a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801050a5:	89 d8                	mov    %ebx,%eax
}
801050a7:	5b                   	pop    %ebx
801050a8:	5e                   	pop    %esi
801050a9:	5d                   	pop    %ebp
801050aa:	c3                   	ret    
801050ab:	90                   	nop
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050b0 <sys_read>:

int
sys_read(void)
{
801050b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050b1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801050b3:	89 e5                	mov    %esp,%ebp
801050b5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050bb:	e8 20 ff ff ff       	call   80104fe0 <argfd.constprop.0>
801050c0:	85 c0                	test   %eax,%eax
801050c2:	78 4c                	js     80105110 <sys_read+0x60>
801050c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050c7:	83 ec 08             	sub    $0x8,%esp
801050ca:	50                   	push   %eax
801050cb:	6a 02                	push   $0x2
801050cd:	e8 1e fc ff ff       	call   80104cf0 <argint>
801050d2:	83 c4 10             	add    $0x10,%esp
801050d5:	85 c0                	test   %eax,%eax
801050d7:	78 37                	js     80105110 <sys_read+0x60>
801050d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050dc:	83 ec 04             	sub    $0x4,%esp
801050df:	ff 75 f0             	pushl  -0x10(%ebp)
801050e2:	50                   	push   %eax
801050e3:	6a 01                	push   $0x1
801050e5:	e8 56 fc ff ff       	call   80104d40 <argptr>
801050ea:	83 c4 10             	add    $0x10,%esp
801050ed:	85 c0                	test   %eax,%eax
801050ef:	78 1f                	js     80105110 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801050f1:	83 ec 04             	sub    $0x4,%esp
801050f4:	ff 75 f0             	pushl  -0x10(%ebp)
801050f7:	ff 75 f4             	pushl  -0xc(%ebp)
801050fa:	ff 75 ec             	pushl  -0x14(%ebp)
801050fd:	e8 4e be ff ff       	call   80100f50 <fileread>
80105102:	83 c4 10             	add    $0x10,%esp
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_write>:

int
sys_write(void)
{
80105120:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105121:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105128:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010512b:	e8 b0 fe ff ff       	call   80104fe0 <argfd.constprop.0>
80105130:	85 c0                	test   %eax,%eax
80105132:	78 4c                	js     80105180 <sys_write+0x60>
80105134:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105137:	83 ec 08             	sub    $0x8,%esp
8010513a:	50                   	push   %eax
8010513b:	6a 02                	push   $0x2
8010513d:	e8 ae fb ff ff       	call   80104cf0 <argint>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	85 c0                	test   %eax,%eax
80105147:	78 37                	js     80105180 <sys_write+0x60>
80105149:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010514c:	83 ec 04             	sub    $0x4,%esp
8010514f:	ff 75 f0             	pushl  -0x10(%ebp)
80105152:	50                   	push   %eax
80105153:	6a 01                	push   $0x1
80105155:	e8 e6 fb ff ff       	call   80104d40 <argptr>
8010515a:	83 c4 10             	add    $0x10,%esp
8010515d:	85 c0                	test   %eax,%eax
8010515f:	78 1f                	js     80105180 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105161:	83 ec 04             	sub    $0x4,%esp
80105164:	ff 75 f0             	pushl  -0x10(%ebp)
80105167:	ff 75 f4             	pushl  -0xc(%ebp)
8010516a:	ff 75 ec             	pushl  -0x14(%ebp)
8010516d:	e8 6e be ff ff       	call   80100fe0 <filewrite>
80105172:	83 c4 10             	add    $0x10,%esp
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105185:	c9                   	leave  
80105186:	c3                   	ret    
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <sys_close>:

int
sys_close(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105196:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105199:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010519c:	e8 3f fe ff ff       	call   80104fe0 <argfd.constprop.0>
801051a1:	85 c0                	test   %eax,%eax
801051a3:	78 2b                	js     801051d0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801051a5:	e8 06 e6 ff ff       	call   801037b0 <myproc>
801051aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801051ad:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
801051b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051b7:	00 
  fileclose(f);
801051b8:	ff 75 f4             	pushl  -0xc(%ebp)
801051bb:	e8 70 bc ff ff       	call   80100e30 <fileclose>
  return 0;
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	31 c0                	xor    %eax,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801051d5:	c9                   	leave  
801051d6:	c3                   	ret    
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <sys_fstat>:

int
sys_fstat(void)
{
801051e0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051e1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051eb:	e8 f0 fd ff ff       	call   80104fe0 <argfd.constprop.0>
801051f0:	85 c0                	test   %eax,%eax
801051f2:	78 2c                	js     80105220 <sys_fstat+0x40>
801051f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f7:	83 ec 04             	sub    $0x4,%esp
801051fa:	6a 14                	push   $0x14
801051fc:	50                   	push   %eax
801051fd:	6a 01                	push   $0x1
801051ff:	e8 3c fb ff ff       	call   80104d40 <argptr>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	78 15                	js     80105220 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010520b:	83 ec 08             	sub    $0x8,%esp
8010520e:	ff 75 f4             	pushl  -0xc(%ebp)
80105211:	ff 75 f0             	pushl  -0x10(%ebp)
80105214:	e8 e7 bc ff ff       	call   80100f00 <filestat>
80105219:	83 c4 10             	add    $0x10,%esp
}
8010521c:	c9                   	leave  
8010521d:	c3                   	ret    
8010521e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105230 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	57                   	push   %edi
80105234:	56                   	push   %esi
80105235:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105236:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105239:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010523c:	50                   	push   %eax
8010523d:	6a 00                	push   $0x0
8010523f:	e8 5c fb ff ff       	call   80104da0 <argstr>
80105244:	83 c4 10             	add    $0x10,%esp
80105247:	85 c0                	test   %eax,%eax
80105249:	0f 88 fb 00 00 00    	js     8010534a <sys_link+0x11a>
8010524f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105252:	83 ec 08             	sub    $0x8,%esp
80105255:	50                   	push   %eax
80105256:	6a 01                	push   $0x1
80105258:	e8 43 fb ff ff       	call   80104da0 <argstr>
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	0f 88 e2 00 00 00    	js     8010534a <sys_link+0x11a>
    return -1;

  begin_op();
80105268:	e8 e3 d8 ff ff       	call   80102b50 <begin_op>
  if((ip = namei(old)) == 0){
8010526d:	83 ec 0c             	sub    $0xc,%esp
80105270:	ff 75 d4             	pushl  -0x2c(%ebp)
80105273:	e8 48 cc ff ff       	call   80101ec0 <namei>
80105278:	83 c4 10             	add    $0x10,%esp
8010527b:	85 c0                	test   %eax,%eax
8010527d:	89 c3                	mov    %eax,%ebx
8010527f:	0f 84 f3 00 00 00    	je     80105378 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	50                   	push   %eax
80105289:	e8 e2 c3 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105296:	0f 84 c4 00 00 00    	je     80105360 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010529c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801052a1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801052a4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801052a7:	53                   	push   %ebx
801052a8:	e8 13 c3 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
801052ad:	89 1c 24             	mov    %ebx,(%esp)
801052b0:	e8 9b c4 ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801052b5:	58                   	pop    %eax
801052b6:	5a                   	pop    %edx
801052b7:	57                   	push   %edi
801052b8:	ff 75 d0             	pushl  -0x30(%ebp)
801052bb:	e8 20 cc ff ff       	call   80101ee0 <nameiparent>
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	85 c0                	test   %eax,%eax
801052c5:	89 c6                	mov    %eax,%esi
801052c7:	74 5b                	je     80105324 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801052c9:	83 ec 0c             	sub    $0xc,%esp
801052cc:	50                   	push   %eax
801052cd:	e8 9e c3 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	8b 03                	mov    (%ebx),%eax
801052d7:	39 06                	cmp    %eax,(%esi)
801052d9:	75 3d                	jne    80105318 <sys_link+0xe8>
801052db:	83 ec 04             	sub    $0x4,%esp
801052de:	ff 73 04             	pushl  0x4(%ebx)
801052e1:	57                   	push   %edi
801052e2:	56                   	push   %esi
801052e3:	e8 18 cb ff ff       	call   80101e00 <dirlink>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	78 29                	js     80105318 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801052ef:	83 ec 0c             	sub    $0xc,%esp
801052f2:	56                   	push   %esi
801052f3:	e8 08 c6 ff ff       	call   80101900 <iunlockput>
  iput(ip);
801052f8:	89 1c 24             	mov    %ebx,(%esp)
801052fb:	e8 a0 c4 ff ff       	call   801017a0 <iput>

  end_op();
80105300:	e8 bb d8 ff ff       	call   80102bc0 <end_op>

  return 0;
80105305:	83 c4 10             	add    $0x10,%esp
80105308:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010530a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010530d:	5b                   	pop    %ebx
8010530e:	5e                   	pop    %esi
8010530f:	5f                   	pop    %edi
80105310:	5d                   	pop    %ebp
80105311:	c3                   	ret    
80105312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	56                   	push   %esi
8010531c:	e8 df c5 ff ff       	call   80101900 <iunlockput>
    goto bad;
80105321:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105324:	83 ec 0c             	sub    $0xc,%esp
80105327:	53                   	push   %ebx
80105328:	e8 43 c3 ff ff       	call   80101670 <ilock>
  ip->nlink--;
8010532d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105332:	89 1c 24             	mov    %ebx,(%esp)
80105335:	e8 86 c2 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
8010533a:	89 1c 24             	mov    %ebx,(%esp)
8010533d:	e8 be c5 ff ff       	call   80101900 <iunlockput>
  end_op();
80105342:	e8 79 d8 ff ff       	call   80102bc0 <end_op>
  return -1;
80105347:	83 c4 10             	add    $0x10,%esp
}
8010534a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010534d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105352:	5b                   	pop    %ebx
80105353:	5e                   	pop    %esi
80105354:	5f                   	pop    %edi
80105355:	5d                   	pop    %ebp
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	53                   	push   %ebx
80105364:	e8 97 c5 ff ff       	call   80101900 <iunlockput>
    end_op();
80105369:	e8 52 d8 ff ff       	call   80102bc0 <end_op>
    return -1;
8010536e:	83 c4 10             	add    $0x10,%esp
80105371:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105376:	eb 92                	jmp    8010530a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105378:	e8 43 d8 ff ff       	call   80102bc0 <end_op>
    return -1;
8010537d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105382:	eb 86                	jmp    8010530a <sys_link+0xda>
80105384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010538a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105390 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105396:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105399:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010539c:	50                   	push   %eax
8010539d:	6a 00                	push   $0x0
8010539f:	e8 fc f9 ff ff       	call   80104da0 <argstr>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	0f 88 82 01 00 00    	js     80105531 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801053af:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
801053b2:	e8 99 d7 ff ff       	call   80102b50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053b7:	83 ec 08             	sub    $0x8,%esp
801053ba:	53                   	push   %ebx
801053bb:	ff 75 c0             	pushl  -0x40(%ebp)
801053be:	e8 1d cb ff ff       	call   80101ee0 <nameiparent>
801053c3:	83 c4 10             	add    $0x10,%esp
801053c6:	85 c0                	test   %eax,%eax
801053c8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053cb:	0f 84 6a 01 00 00    	je     8010553b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
801053d1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	56                   	push   %esi
801053d8:	e8 93 c2 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053dd:	58                   	pop    %eax
801053de:	5a                   	pop    %edx
801053df:	68 0c 7e 10 80       	push   $0x80107e0c
801053e4:	53                   	push   %ebx
801053e5:	e8 96 c7 ff ff       	call   80101b80 <namecmp>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	85 c0                	test   %eax,%eax
801053ef:	0f 84 fc 00 00 00    	je     801054f1 <sys_unlink+0x161>
801053f5:	83 ec 08             	sub    $0x8,%esp
801053f8:	68 0b 7e 10 80       	push   $0x80107e0b
801053fd:	53                   	push   %ebx
801053fe:	e8 7d c7 ff ff       	call   80101b80 <namecmp>
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	85 c0                	test   %eax,%eax
80105408:	0f 84 e3 00 00 00    	je     801054f1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010540e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105411:	83 ec 04             	sub    $0x4,%esp
80105414:	50                   	push   %eax
80105415:	53                   	push   %ebx
80105416:	56                   	push   %esi
80105417:	e8 84 c7 ff ff       	call   80101ba0 <dirlookup>
8010541c:	83 c4 10             	add    $0x10,%esp
8010541f:	85 c0                	test   %eax,%eax
80105421:	89 c3                	mov    %eax,%ebx
80105423:	0f 84 c8 00 00 00    	je     801054f1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80105429:	83 ec 0c             	sub    $0xc,%esp
8010542c:	50                   	push   %eax
8010542d:	e8 3e c2 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010543a:	0f 8e 24 01 00 00    	jle    80105564 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105440:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105445:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105448:	74 66                	je     801054b0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010544a:	83 ec 04             	sub    $0x4,%esp
8010544d:	6a 10                	push   $0x10
8010544f:	6a 00                	push   $0x0
80105451:	56                   	push   %esi
80105452:	e8 89 f5 ff ff       	call   801049e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105457:	6a 10                	push   $0x10
80105459:	ff 75 c4             	pushl  -0x3c(%ebp)
8010545c:	56                   	push   %esi
8010545d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105460:	e8 eb c5 ff ff       	call   80101a50 <writei>
80105465:	83 c4 20             	add    $0x20,%esp
80105468:	83 f8 10             	cmp    $0x10,%eax
8010546b:	0f 85 e6 00 00 00    	jne    80105557 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105471:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105476:	0f 84 9c 00 00 00    	je     80105518 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010547c:	83 ec 0c             	sub    $0xc,%esp
8010547f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105482:	e8 79 c4 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
80105487:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010548c:	89 1c 24             	mov    %ebx,(%esp)
8010548f:	e8 2c c1 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80105494:	89 1c 24             	mov    %ebx,(%esp)
80105497:	e8 64 c4 ff ff       	call   80101900 <iunlockput>

  end_op();
8010549c:	e8 1f d7 ff ff       	call   80102bc0 <end_op>

  return 0;
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801054a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054a9:	5b                   	pop    %ebx
801054aa:	5e                   	pop    %esi
801054ab:	5f                   	pop    %edi
801054ac:	5d                   	pop    %ebp
801054ad:	c3                   	ret    
801054ae:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054b4:	76 94                	jbe    8010544a <sys_unlink+0xba>
801054b6:	bf 20 00 00 00       	mov    $0x20,%edi
801054bb:	eb 0f                	jmp    801054cc <sys_unlink+0x13c>
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
801054c0:	83 c7 10             	add    $0x10,%edi
801054c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801054c6:	0f 83 7e ff ff ff    	jae    8010544a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054cc:	6a 10                	push   $0x10
801054ce:	57                   	push   %edi
801054cf:	56                   	push   %esi
801054d0:	53                   	push   %ebx
801054d1:	e8 7a c4 ff ff       	call   80101950 <readi>
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	83 f8 10             	cmp    $0x10,%eax
801054dc:	75 6c                	jne    8010554a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
801054de:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054e3:	74 db                	je     801054c0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
801054e5:	83 ec 0c             	sub    $0xc,%esp
801054e8:	53                   	push   %ebx
801054e9:	e8 12 c4 ff ff       	call   80101900 <iunlockput>
    goto bad;
801054ee:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801054f1:	83 ec 0c             	sub    $0xc,%esp
801054f4:	ff 75 b4             	pushl  -0x4c(%ebp)
801054f7:	e8 04 c4 ff ff       	call   80101900 <iunlockput>
  end_op();
801054fc:	e8 bf d6 ff ff       	call   80102bc0 <end_op>
  return -1;
80105501:	83 c4 10             	add    $0x10,%esp
}
80105504:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105507:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010550c:	5b                   	pop    %ebx
8010550d:	5e                   	pop    %esi
8010550e:	5f                   	pop    %edi
8010550f:	5d                   	pop    %ebp
80105510:	c3                   	ret    
80105511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105518:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010551b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010551e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105523:	50                   	push   %eax
80105524:	e8 97 c0 ff ff       	call   801015c0 <iupdate>
80105529:	83 c4 10             	add    $0x10,%esp
8010552c:	e9 4b ff ff ff       	jmp    8010547c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105531:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105536:	e9 6b ff ff ff       	jmp    801054a6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010553b:	e8 80 d6 ff ff       	call   80102bc0 <end_op>
    return -1;
80105540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105545:	e9 5c ff ff ff       	jmp    801054a6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010554a:	83 ec 0c             	sub    $0xc,%esp
8010554d:	68 30 7e 10 80       	push   $0x80107e30
80105552:	e8 19 ae ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105557:	83 ec 0c             	sub    $0xc,%esp
8010555a:	68 42 7e 10 80       	push   $0x80107e42
8010555f:	e8 0c ae ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105564:	83 ec 0c             	sub    $0xc,%esp
80105567:	68 1e 7e 10 80       	push   $0x80107e1e
8010556c:	e8 ff ad ff ff       	call   80100370 <panic>
80105571:	eb 0d                	jmp    80105580 <sys_open>
80105573:	90                   	nop
80105574:	90                   	nop
80105575:	90                   	nop
80105576:	90                   	nop
80105577:	90                   	nop
80105578:	90                   	nop
80105579:	90                   	nop
8010557a:	90                   	nop
8010557b:	90                   	nop
8010557c:	90                   	nop
8010557d:	90                   	nop
8010557e:	90                   	nop
8010557f:	90                   	nop

80105580 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
80105585:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105586:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105589:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010558c:	50                   	push   %eax
8010558d:	6a 00                	push   $0x0
8010558f:	e8 0c f8 ff ff       	call   80104da0 <argstr>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	0f 88 9e 00 00 00    	js     8010563d <sys_open+0xbd>
8010559f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055a2:	83 ec 08             	sub    $0x8,%esp
801055a5:	50                   	push   %eax
801055a6:	6a 01                	push   $0x1
801055a8:	e8 43 f7 ff ff       	call   80104cf0 <argint>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	0f 88 85 00 00 00    	js     8010563d <sys_open+0xbd>
    return -1;

  begin_op();
801055b8:	e8 93 d5 ff ff       	call   80102b50 <begin_op>

  if(omode & O_CREATE){
801055bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055c1:	0f 85 89 00 00 00    	jne    80105650 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055c7:	83 ec 0c             	sub    $0xc,%esp
801055ca:	ff 75 e0             	pushl  -0x20(%ebp)
801055cd:	e8 ee c8 ff ff       	call   80101ec0 <namei>
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	85 c0                	test   %eax,%eax
801055d7:	89 c6                	mov    %eax,%esi
801055d9:	0f 84 8e 00 00 00    	je     8010566d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	50                   	push   %eax
801055e3:	e8 88 c0 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055f0:	0f 84 d2 00 00 00    	je     801056c8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055f6:	e8 75 b7 ff ff       	call   80100d70 <filealloc>
801055fb:	85 c0                	test   %eax,%eax
801055fd:	89 c7                	mov    %eax,%edi
801055ff:	74 2b                	je     8010562c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105601:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105603:	e8 a8 e1 ff ff       	call   801037b0 <myproc>
80105608:	90                   	nop
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105610:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105614:	85 d2                	test   %edx,%edx
80105616:	74 68                	je     80105680 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105618:	83 c3 01             	add    $0x1,%ebx
8010561b:	83 fb 10             	cmp    $0x10,%ebx
8010561e:	75 f0                	jne    80105610 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	57                   	push   %edi
80105624:	e8 07 b8 ff ff       	call   80100e30 <fileclose>
80105629:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	56                   	push   %esi
80105630:	e8 cb c2 ff ff       	call   80101900 <iunlockput>
    end_op();
80105635:	e8 86 d5 ff ff       	call   80102bc0 <end_op>
    return -1;
8010563a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010563d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105645:	5b                   	pop    %ebx
80105646:	5e                   	pop    %esi
80105647:	5f                   	pop    %edi
80105648:	5d                   	pop    %ebp
80105649:	c3                   	ret    
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105656:	31 c9                	xor    %ecx,%ecx
80105658:	6a 00                	push   $0x0
8010565a:	ba 02 00 00 00       	mov    $0x2,%edx
8010565f:	e8 dc f7 ff ff       	call   80104e40 <create>
    if(ip == 0){
80105664:	83 c4 10             	add    $0x10,%esp
80105667:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105669:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010566b:	75 89                	jne    801055f6 <sys_open+0x76>
      end_op();
8010566d:	e8 4e d5 ff ff       	call   80102bc0 <end_op>
      return -1;
80105672:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105677:	eb 43                	jmp    801056bc <sys_open+0x13c>
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105680:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105683:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105687:	56                   	push   %esi
80105688:	e8 c3 c0 ff ff       	call   80101750 <iunlock>
  end_op();
8010568d:	e8 2e d5 ff ff       	call   80102bc0 <end_op>

  f->type = FD_INODE;
80105692:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105698:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010569b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010569e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801056a1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056a8:	89 d0                	mov    %edx,%eax
801056aa:	83 e0 01             	and    $0x1,%eax
801056ad:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056b0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056b3:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056b6:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801056ba:	89 d8                	mov    %ebx,%eax
}
801056bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056bf:	5b                   	pop    %ebx
801056c0:	5e                   	pop    %esi
801056c1:	5f                   	pop    %edi
801056c2:	5d                   	pop    %ebp
801056c3:	c3                   	ret    
801056c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801056c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056cb:	85 c9                	test   %ecx,%ecx
801056cd:	0f 84 23 ff ff ff    	je     801055f6 <sys_open+0x76>
801056d3:	e9 54 ff ff ff       	jmp    8010562c <sys_open+0xac>
801056d8:	90                   	nop
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056e0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056e6:	e8 65 d4 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ee:	83 ec 08             	sub    $0x8,%esp
801056f1:	50                   	push   %eax
801056f2:	6a 00                	push   $0x0
801056f4:	e8 a7 f6 ff ff       	call   80104da0 <argstr>
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	85 c0                	test   %eax,%eax
801056fe:	78 30                	js     80105730 <sys_mkdir+0x50>
80105700:	83 ec 0c             	sub    $0xc,%esp
80105703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105706:	31 c9                	xor    %ecx,%ecx
80105708:	6a 00                	push   $0x0
8010570a:	ba 01 00 00 00       	mov    $0x1,%edx
8010570f:	e8 2c f7 ff ff       	call   80104e40 <create>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	74 15                	je     80105730 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010571b:	83 ec 0c             	sub    $0xc,%esp
8010571e:	50                   	push   %eax
8010571f:	e8 dc c1 ff ff       	call   80101900 <iunlockput>
  end_op();
80105724:	e8 97 d4 ff ff       	call   80102bc0 <end_op>
  return 0;
80105729:	83 c4 10             	add    $0x10,%esp
8010572c:	31 c0                	xor    %eax,%eax
}
8010572e:	c9                   	leave  
8010572f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105730:	e8 8b d4 ff ff       	call   80102bc0 <end_op>
    return -1;
80105735:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
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
  char *path;
  int major, minor;

  begin_op();
80105746:	e8 05 d4 ff ff       	call   80102b50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010574b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010574e:	83 ec 08             	sub    $0x8,%esp
80105751:	50                   	push   %eax
80105752:	6a 00                	push   $0x0
80105754:	e8 47 f6 ff ff       	call   80104da0 <argstr>
80105759:	83 c4 10             	add    $0x10,%esp
8010575c:	85 c0                	test   %eax,%eax
8010575e:	78 60                	js     801057c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105760:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105763:	83 ec 08             	sub    $0x8,%esp
80105766:	50                   	push   %eax
80105767:	6a 01                	push   $0x1
80105769:	e8 82 f5 ff ff       	call   80104cf0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	85 c0                	test   %eax,%eax
80105773:	78 4b                	js     801057c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105775:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105778:	83 ec 08             	sub    $0x8,%esp
8010577b:	50                   	push   %eax
8010577c:	6a 02                	push   $0x2
8010577e:	e8 6d f5 ff ff       	call   80104cf0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	78 36                	js     801057c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010578a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010578e:	83 ec 0c             	sub    $0xc,%esp
80105791:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105795:	ba 03 00 00 00       	mov    $0x3,%edx
8010579a:	50                   	push   %eax
8010579b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010579e:	e8 9d f6 ff ff       	call   80104e40 <create>
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	85 c0                	test   %eax,%eax
801057a8:	74 16                	je     801057c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	50                   	push   %eax
801057ae:	e8 4d c1 ff ff       	call   80101900 <iunlockput>
  end_op();
801057b3:	e8 08 d4 ff ff       	call   80102bc0 <end_op>
  return 0;
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	31 c0                	xor    %eax,%eax
}
801057bd:	c9                   	leave  
801057be:	c3                   	ret    
801057bf:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801057c0:	e8 fb d3 ff ff       	call   80102bc0 <end_op>
    return -1;
801057c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
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
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057d8:	e8 d3 df ff ff       	call   801037b0 <myproc>
801057dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057df:	e8 6c d3 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e7:	83 ec 08             	sub    $0x8,%esp
801057ea:	50                   	push   %eax
801057eb:	6a 00                	push   $0x0
801057ed:	e8 ae f5 ff ff       	call   80104da0 <argstr>
801057f2:	83 c4 10             	add    $0x10,%esp
801057f5:	85 c0                	test   %eax,%eax
801057f7:	78 77                	js     80105870 <sys_chdir+0xa0>
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	ff 75 f4             	pushl  -0xc(%ebp)
801057ff:	e8 bc c6 ff ff       	call   80101ec0 <namei>
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
80105811:	e8 5a be ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
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
80105824:	e8 27 bf ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
80105829:	58                   	pop    %eax
8010582a:	ff 76 68             	pushl  0x68(%esi)
8010582d:	e8 6e bf ff ff       	call   801017a0 <iput>
  end_op();
80105832:	e8 89 d3 ff ff       	call   80102bc0 <end_op>
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
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105850:	83 ec 0c             	sub    $0xc,%esp
80105853:	53                   	push   %ebx
80105854:	e8 a7 c0 ff ff       	call   80101900 <iunlockput>
    end_op();
80105859:	e8 62 d3 ff ff       	call   80102bc0 <end_op>
    return -1;
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105866:	eb d7                	jmp    8010583f <sys_chdir+0x6f>
80105868:	90                   	nop
80105869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105870:	e8 4b d3 ff ff       	call   80102bc0 <end_op>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587a:	eb c3                	jmp    8010583f <sys_chdir+0x6f>
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
80105885:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105886:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010588c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105892:	50                   	push   %eax
80105893:	6a 00                	push   $0x0
80105895:	e8 06 f5 ff ff       	call   80104da0 <argstr>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	85 c0                	test   %eax,%eax
8010589f:	78 7f                	js     80105920 <sys_exec+0xa0>
801058a1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	50                   	push   %eax
801058ab:	6a 01                	push   $0x1
801058ad:	e8 3e f4 ff ff       	call   80104cf0 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 67                	js     80105920 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801058b9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801058bf:	83 ec 04             	sub    $0x4,%esp
801058c2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801058c8:	68 80 00 00 00       	push   $0x80
801058cd:	6a 00                	push   $0x0
801058cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801058d5:	50                   	push   %eax
801058d6:	31 db                	xor    %ebx,%ebx
801058d8:	e8 03 f1 ff ff       	call   801049e0 <memset>
801058dd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058e0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058e6:	83 ec 08             	sub    $0x8,%esp
801058e9:	57                   	push   %edi
801058ea:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801058ed:	50                   	push   %eax
801058ee:	e8 5d f3 ff ff       	call   80104c50 <fetchint>
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 26                	js     80105920 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801058fa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105900:	85 c0                	test   %eax,%eax
80105902:	74 2c                	je     80105930 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105904:	83 ec 08             	sub    $0x8,%esp
80105907:	56                   	push   %esi
80105908:	50                   	push   %eax
80105909:	e8 82 f3 ff ff       	call   80104c90 <fetchstr>
8010590e:	83 c4 10             	add    $0x10,%esp
80105911:	85 c0                	test   %eax,%eax
80105913:	78 0b                	js     80105920 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105915:	83 c3 01             	add    $0x1,%ebx
80105918:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010591b:	83 fb 20             	cmp    $0x20,%ebx
8010591e:	75 c0                	jne    801058e0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105920:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105923:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105928:	5b                   	pop    %ebx
80105929:	5e                   	pop    %esi
8010592a:	5f                   	pop    %edi
8010592b:	5d                   	pop    %ebp
8010592c:	c3                   	ret    
8010592d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105930:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105936:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105939:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105940:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105944:	50                   	push   %eax
80105945:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010594b:	e8 a0 b0 ff ff       	call   801009f0 <exec>
80105950:	83 c4 10             	add    $0x10,%esp
}
80105953:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105956:	5b                   	pop    %ebx
80105957:	5e                   	pop    %esi
80105958:	5f                   	pop    %edi
80105959:	5d                   	pop    %ebp
8010595a:	c3                   	ret    
8010595b:	90                   	nop
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_pipe>:

int
sys_pipe(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
80105965:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105966:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105969:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010596c:	6a 08                	push   $0x8
8010596e:	50                   	push   %eax
8010596f:	6a 00                	push   $0x0
80105971:	e8 ca f3 ff ff       	call   80104d40 <argptr>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	78 4a                	js     801059c7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010597d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	50                   	push   %eax
80105984:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105987:	50                   	push   %eax
80105988:	e8 63 d8 ff ff       	call   801031f0 <pipealloc>
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	85 c0                	test   %eax,%eax
80105992:	78 33                	js     801059c7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105994:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105996:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105999:	e8 12 de ff ff       	call   801037b0 <myproc>
8010599e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801059a0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801059a4:	85 f6                	test   %esi,%esi
801059a6:	74 30                	je     801059d8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801059a8:	83 c3 01             	add    $0x1,%ebx
801059ab:	83 fb 10             	cmp    $0x10,%ebx
801059ae:	75 f0                	jne    801059a0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	ff 75 e0             	pushl  -0x20(%ebp)
801059b6:	e8 75 b4 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
801059bb:	58                   	pop    %eax
801059bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801059bf:	e8 6c b4 ff ff       	call   80100e30 <fileclose>
    return -1;
801059c4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801059c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801059ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801059cf:	5b                   	pop    %ebx
801059d0:	5e                   	pop    %esi
801059d1:	5f                   	pop    %edi
801059d2:	5d                   	pop    %ebp
801059d3:	c3                   	ret    
801059d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801059d8:	8d 73 08             	lea    0x8(%ebx),%esi
801059db:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801059e2:	e8 c9 dd ff ff       	call   801037b0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801059e7:	31 d2                	xor    %edx,%edx
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801059f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059f4:	85 c9                	test   %ecx,%ecx
801059f6:	74 18                	je     80105a10 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801059f8:	83 c2 01             	add    $0x1,%edx
801059fb:	83 fa 10             	cmp    $0x10,%edx
801059fe:	75 f0                	jne    801059f0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105a00:	e8 ab dd ff ff       	call   801037b0 <myproc>
80105a05:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a0c:	00 
80105a0d:	eb a1                	jmp    801059b0 <sys_pipe+0x50>
80105a0f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105a10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105a1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105a22:	31 c0                	xor    %eax,%eax
}
80105a24:	5b                   	pop    %ebx
80105a25:	5e                   	pop    %esi
80105a26:	5f                   	pop    %edi
80105a27:	5d                   	pop    %ebp
80105a28:	c3                   	ret    
80105a29:	66 90                	xchg   %ax,%ax
80105a2b:	66 90                	xchg   %ax,%ax
80105a2d:	66 90                	xchg   %ax,%ax
80105a2f:	90                   	nop

80105a30 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105a33:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105a34:	e9 37 df ff ff       	jmp    80103970 <fork>
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_exit>:
}

int
sys_exit(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a46:	e8 d5 e1 ff ff       	call   80103c20 <exit>
  return 0;  // not reached
}
80105a4b:	31 c0                	xor    %eax,%eax
80105a4d:	c9                   	leave  
80105a4e:	c3                   	ret    
80105a4f:	90                   	nop

80105a50 <sys_wait>:

int
sys_wait(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a53:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105a54:	e9 07 e4 ff ff       	jmp    80103e60 <wait>
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_wait2>:
/*
  this is the actual function being called from syscall.c
  @returns - pidof the terminated child process ‐ if successful
­             -1, upon failure
*/
int sys_wait2(void) {
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
80105a63:	83 ec 1c             	sub    $0x1c,%esp
  int *retime, *rutime, *stime;
  if (argptr(0, (void*)&retime, sizeof(retime)) < 0)
80105a66:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a69:	6a 04                	push   $0x4
80105a6b:	50                   	push   %eax
80105a6c:	6a 00                	push   $0x0
80105a6e:	e8 cd f2 ff ff       	call   80104d40 <argptr>
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	85 c0                	test   %eax,%eax
80105a78:	78 46                	js     80105ac0 <sys_wait2+0x60>
    return -1;
  if (argptr(1, (void*)&rutime, sizeof(retime)) < 0)
80105a7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a7d:	83 ec 04             	sub    $0x4,%esp
80105a80:	6a 04                	push   $0x4
80105a82:	50                   	push   %eax
80105a83:	6a 01                	push   $0x1
80105a85:	e8 b6 f2 ff ff       	call   80104d40 <argptr>
80105a8a:	83 c4 10             	add    $0x10,%esp
80105a8d:	85 c0                	test   %eax,%eax
80105a8f:	78 2f                	js     80105ac0 <sys_wait2+0x60>
    return -1;
  if (argptr(2, (void*)&stime, sizeof(stime)) < 0)
80105a91:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a94:	83 ec 04             	sub    $0x4,%esp
80105a97:	6a 04                	push   $0x4
80105a99:	50                   	push   %eax
80105a9a:	6a 02                	push   $0x2
80105a9c:	e8 9f f2 ff ff       	call   80104d40 <argptr>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 18                	js     80105ac0 <sys_wait2+0x60>
    return -1;
  return wait2(retime, rutime, stime);
80105aa8:	83 ec 04             	sub    $0x4,%esp
80105aab:	ff 75 f4             	pushl  -0xc(%ebp)
80105aae:	ff 75 f0             	pushl  -0x10(%ebp)
80105ab1:	ff 75 ec             	pushl  -0x14(%ebp)
80105ab4:	e8 b7 e4 ff ff       	call   80103f70 <wait2>
80105ab9:	83 c4 10             	add    $0x10,%esp
}
80105abc:	c9                   	leave  
80105abd:	c3                   	ret    
80105abe:	66 90                	xchg   %ax,%ax
­             -1, upon failure
*/
int sys_wait2(void) {
  int *retime, *rutime, *stime;
  if (argptr(0, (void*)&retime, sizeof(retime)) < 0)
    return -1;
80105ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if (argptr(1, (void*)&rutime, sizeof(retime)) < 0)
    return -1;
  if (argptr(2, (void*)&stime, sizeof(stime)) < 0)
    return -1;
  return wait2(retime, rutime, stime);
}
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ad0 <sys_kill>:

int
sys_kill(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 00                	push   $0x0
80105adc:	e8 0f f2 ff ff       	call   80104cf0 <argint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 18                	js     80105b00 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	ff 75 f4             	pushl  -0xc(%ebp)
80105aee:	e8 6d e6 ff ff       	call   80104160 <kill>
80105af3:	83 c4 10             	add    $0x10,%esp
}
80105af6:	c9                   	leave  
80105af7:	c3                   	ret    
80105af8:	90                   	nop
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105b05:	c9                   	leave  
80105b06:	c3                   	ret    
80105b07:	89 f6                	mov    %esi,%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b10 <sys_getpid>:

int
sys_getpid(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b16:	e8 95 dc ff ff       	call   801037b0 <myproc>
80105b1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b1e:	c9                   	leave  
80105b1f:	c3                   	ret    

80105b20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105b27:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b2a:	50                   	push   %eax
80105b2b:	6a 00                	push   $0x0
80105b2d:	e8 be f1 ff ff       	call   80104cf0 <argint>
80105b32:	83 c4 10             	add    $0x10,%esp
80105b35:	85 c0                	test   %eax,%eax
80105b37:	78 27                	js     80105b60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b39:	e8 72 dc ff ff       	call   801037b0 <myproc>
  if(growproc(n) < 0)
80105b3e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105b41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b43:	ff 75 f4             	pushl  -0xc(%ebp)
80105b46:	e8 a5 dd ff ff       	call   801038f0 <growproc>
80105b4b:	83 c4 10             	add    $0x10,%esp
80105b4e:	85 c0                	test   %eax,%eax
80105b50:	78 0e                	js     80105b60 <sys_sbrk+0x40>
    return -1;
  return addr;
80105b52:	89 d8                	mov    %ebx,%eax
}
80105b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b57:	c9                   	leave  
80105b58:	c3                   	ret    
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b65:	eb ed                	jmp    80105b54 <sys_sbrk+0x34>
80105b67:	89 f6                	mov    %esi,%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b70 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105b77:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b7a:	50                   	push   %eax
80105b7b:	6a 00                	push   $0x0
80105b7d:	e8 6e f1 ff ff       	call   80104cf0 <argint>
80105b82:	83 c4 10             	add    $0x10,%esp
80105b85:	85 c0                	test   %eax,%eax
80105b87:	0f 88 8a 00 00 00    	js     80105c17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b8d:	83 ec 0c             	sub    $0xc,%esp
80105b90:	68 60 62 11 80       	push   $0x80116260
80105b95:	e8 d6 ec ff ff       	call   80104870 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b9d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105ba0:	8b 1d a0 6a 11 80    	mov    0x80116aa0,%ebx
  while(ticks - ticks0 < n){
80105ba6:	85 d2                	test   %edx,%edx
80105ba8:	75 27                	jne    80105bd1 <sys_sleep+0x61>
80105baa:	eb 54                	jmp    80105c00 <sys_sleep+0x90>
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105bb0:	83 ec 08             	sub    $0x8,%esp
80105bb3:	68 60 62 11 80       	push   $0x80116260
80105bb8:	68 a0 6a 11 80       	push   $0x80116aa0
80105bbd:	e8 de e1 ff ff       	call   80103da0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bc2:	a1 a0 6a 11 80       	mov    0x80116aa0,%eax
80105bc7:	83 c4 10             	add    $0x10,%esp
80105bca:	29 d8                	sub    %ebx,%eax
80105bcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bcf:	73 2f                	jae    80105c00 <sys_sleep+0x90>
    if(myproc()->killed){
80105bd1:	e8 da db ff ff       	call   801037b0 <myproc>
80105bd6:	8b 40 24             	mov    0x24(%eax),%eax
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	74 d3                	je     80105bb0 <sys_sleep+0x40>
      release(&tickslock);
80105bdd:	83 ec 0c             	sub    $0xc,%esp
80105be0:	68 60 62 11 80       	push   $0x80116260
80105be5:	e8 a6 ed ff ff       	call   80104990 <release>
      return -1;
80105bea:	83 c4 10             	add    $0x10,%esp
80105bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105bf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bf5:	c9                   	leave  
80105bf6:	c3                   	ret    
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105c00:	83 ec 0c             	sub    $0xc,%esp
80105c03:	68 60 62 11 80       	push   $0x80116260
80105c08:	e8 83 ed ff ff       	call   80104990 <release>
  return 0;
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	31 c0                	xor    %eax,%eax
}
80105c12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105c17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c1c:	eb d4                	jmp    80105bf2 <sys_sleep+0x82>
80105c1e:	66 90                	xchg   %ax,%ax

80105c20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	53                   	push   %ebx
80105c24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c27:	68 60 62 11 80       	push   $0x80116260
80105c2c:	e8 3f ec ff ff       	call   80104870 <acquire>
  xticks = ticks;
80105c31:	8b 1d a0 6a 11 80    	mov    0x80116aa0,%ebx
  release(&tickslock);
80105c37:	c7 04 24 60 62 11 80 	movl   $0x80116260,(%esp)
80105c3e:	e8 4d ed ff ff       	call   80104990 <release>
  return xticks;
}
80105c43:	89 d8                	mov    %ebx,%eax
80105c45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c48:	c9                   	leave  
80105c49:	c3                   	ret    
80105c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c50 <sys_getptable>:

// copy elements from the kernel ptable to the user space
extern struct proc * getptable_proc(void);

int sys_getptable(void){
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	56                   	push   %esi
80105c54:	53                   	push   %ebx
  int size;
  char *buf;
  char *s;
  struct proc *p = '\0';

  if (argint(0, &size) <0){
80105c55:	8d 45 f0             	lea    -0x10(%ebp),%eax
}

// copy elements from the kernel ptable to the user space
extern struct proc * getptable_proc(void);

int sys_getptable(void){
80105c58:	83 ec 18             	sub    $0x18,%esp
  int size;
  char *buf;
  char *s;
  struct proc *p = '\0';

  if (argint(0, &size) <0){
80105c5b:	50                   	push   %eax
80105c5c:	6a 00                	push   $0x0
80105c5e:	e8 8d f0 ff ff       	call   80104cf0 <argint>
80105c63:	83 c4 10             	add    $0x10,%esp
80105c66:	85 c0                	test   %eax,%eax
80105c68:	0f 88 92 00 00 00    	js     80105d00 <sys_getptable+0xb0>
    return -1;
  }
  if (argptr(1, &buf,size) <0){
80105c6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c71:	83 ec 04             	sub    $0x4,%esp
80105c74:	ff 75 f0             	pushl  -0x10(%ebp)
80105c77:	50                   	push   %eax
80105c78:	6a 01                	push   $0x1
80105c7a:	e8 c1 f0 ff ff       	call   80104d40 <argptr>
80105c7f:	83 c4 10             	add    $0x10,%esp
80105c82:	85 c0                	test   %eax,%eax
80105c84:	78 7a                	js     80105d00 <sys_getptable+0xb0>
    return -1;
  }

  s = buf;
80105c86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  p = getptable_proc();
80105c89:	e8 22 e6 ff ff       	call   801042b0 <getptable_proc>

  while(buf + size > s && p->state != UNUSED){
80105c8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c91:	03 55 f4             	add    -0xc(%ebp),%edx
80105c94:	39 d3                	cmp    %edx,%ebx
80105c96:	73 5f                	jae    80105cf7 <sys_getptable+0xa7>
80105c98:	8b 50 0c             	mov    0xc(%eax),%edx
80105c9b:	85 d2                	test   %edx,%edx
80105c9d:	74 58                	je     80105cf7 <sys_getptable+0xa7>
80105c9f:	8d 70 6c             	lea    0x6c(%eax),%esi
80105ca2:	eb 11                	jmp    80105cb5 <sys_getptable+0x65>
80105ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ca8:	81 c6 94 00 00 00    	add    $0x94,%esi
80105cae:	8b 56 a0             	mov    -0x60(%esi),%edx
80105cb1:	85 d2                	test   %edx,%edx
80105cb3:	74 42                	je     80105cf7 <sys_getptable+0xa7>
    *(int *)s = p->state;
80105cb5:	89 13                	mov    %edx,(%ebx)
    s+=4;
    *(int *)s = p->pid;
80105cb7:	8b 46 a4             	mov    -0x5c(%esi),%eax
    s+=4;
    *(int *)s = p->tickets;
    s+=4;
    *(int *)s = p->ctime;
    s+=4;
    memmove(s,p->name,16);
80105cba:	83 ec 04             	sub    $0x4,%esp
  p = getptable_proc();

  while(buf + size > s && p->state != UNUSED){
    *(int *)s = p->state;
    s+=4;
    *(int *)s = p->pid;
80105cbd:	89 43 04             	mov    %eax,0x4(%ebx)
    s+=4;
    *(int *)s = p->parent->pid;
80105cc0:	8b 46 a8             	mov    -0x58(%esi),%eax
80105cc3:	8b 40 10             	mov    0x10(%eax),%eax
80105cc6:	89 43 08             	mov    %eax,0x8(%ebx)
    s+=4;
    *(int *)s = p->priority;
80105cc9:	8b 46 10             	mov    0x10(%esi),%eax
80105ccc:	89 43 0c             	mov    %eax,0xc(%ebx)
    s+=4;
    *(int *)s = p->tickets;
80105ccf:	8b 46 24             	mov    0x24(%esi),%eax
80105cd2:	89 43 10             	mov    %eax,0x10(%ebx)
    s+=4;
    *(int *)s = p->ctime;
80105cd5:	8b 46 14             	mov    0x14(%esi),%eax
80105cd8:	89 43 14             	mov    %eax,0x14(%ebx)
    s+=4;
    memmove(s,p->name,16);
80105cdb:	8d 43 18             	lea    0x18(%ebx),%eax
80105cde:	6a 10                	push   $0x10
80105ce0:	56                   	push   %esi
80105ce1:	83 c3 28             	add    $0x28,%ebx
80105ce4:	50                   	push   %eax
80105ce5:	e8 a6 ed ff ff       	call   80104a90 <memmove>
  }

  s = buf;
  p = getptable_proc();

  while(buf + size > s && p->state != UNUSED){
80105cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ced:	03 45 f4             	add    -0xc(%ebp),%eax
80105cf0:	83 c4 10             	add    $0x10,%esp
80105cf3:	39 c3                	cmp    %eax,%ebx
80105cf5:	72 b1                	jb     80105ca8 <sys_getptable+0x58>
    s+=4;
    memmove(s,p->name,16);
    s+=16;
    p++;
  }
  return 0;
80105cf7:	31 c0                	xor    %eax,%eax
}
80105cf9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cfc:	5b                   	pop    %ebx
80105cfd:	5e                   	pop    %esi
80105cfe:	5d                   	pop    %ebp
80105cff:	c3                   	ret    
  char *buf;
  char *s;
  struct proc *p = '\0';

  if (argint(0, &size) <0){
    return -1;
80105d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d05:	eb f2                	jmp    80105cf9 <sys_getptable+0xa9>
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d10 <sys_getppid>:
  return 0;
}

int
sys_getppid(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->parent->pid;
80105d16:	e8 95 da ff ff       	call   801037b0 <myproc>
80105d1b:	8b 40 14             	mov    0x14(%eax),%eax
80105d1e:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d21:	c9                   	leave  
80105d22:	c3                   	ret    
80105d23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_chpr>:
extern int chpr(int, int);
extern int chtickets(int, int);

int
sys_chpr(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
80105d36:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d39:	50                   	push   %eax
80105d3a:	6a 00                	push   $0x0
80105d3c:	e8 af ef ff ff       	call   80104cf0 <argint>
80105d41:	83 c4 10             	add    $0x10,%esp
80105d44:	85 c0                	test   %eax,%eax
80105d46:	78 28                	js     80105d70 <sys_chpr+0x40>
    return -1;
  if(argint(1, &pr) < 0)
80105d48:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d4b:	83 ec 08             	sub    $0x8,%esp
80105d4e:	50                   	push   %eax
80105d4f:	6a 01                	push   $0x1
80105d51:	e8 9a ef ff ff       	call   80104cf0 <argint>
80105d56:	83 c4 10             	add    $0x10,%esp
80105d59:	85 c0                	test   %eax,%eax
80105d5b:	78 13                	js     80105d70 <sys_chpr+0x40>
    return -1;

  return chpr(pid, pr);
80105d5d:	83 ec 08             	sub    $0x8,%esp
80105d60:	ff 75 f4             	pushl  -0xc(%ebp)
80105d63:	ff 75 f0             	pushl  -0x10(%ebp)
80105d66:	e8 55 e5 ff ff       	call   801042c0 <chpr>
80105d6b:	83 c4 10             	add    $0x10,%esp
}
80105d6e:	c9                   	leave  
80105d6f:	c3                   	ret    
int
sys_chpr(void)
{
  int pid, pr;
  if(argint(0, &pid) < 0)
    return -1;
80105d70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argint(1, &pr) < 0)
    return -1;

  return chpr(pid, pr);
}
80105d75:	c9                   	leave  
80105d76:	c3                   	ret    
80105d77:	89 f6                	mov    %esi,%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d80 <sys_yield>:

int sys_yield(void) {
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 08             	sub    $0x8,%esp
  yield();
80105d86:	e8 c5 df ff ff       	call   80103d50 <yield>
  return 0;
}
80105d8b:	31 c0                	xor    %eax,%eax
80105d8d:	c9                   	leave  
80105d8e:	c3                   	ret    
80105d8f:	90                   	nop

80105d90 <sys_chtickets>:

int
sys_chtickets(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 20             	sub    $0x20,%esp
  int pid, tickets;
  if(argint(0, &pid) < 0)
80105d96:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d99:	50                   	push   %eax
80105d9a:	6a 00                	push   $0x0
80105d9c:	e8 4f ef ff ff       	call   80104cf0 <argint>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	85 c0                	test   %eax,%eax
80105da6:	78 28                	js     80105dd0 <sys_chtickets+0x40>
    return -1;
  if(argint(1, &tickets) < 0)
80105da8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dab:	83 ec 08             	sub    $0x8,%esp
80105dae:	50                   	push   %eax
80105daf:	6a 01                	push   $0x1
80105db1:	e8 3a ef ff ff       	call   80104cf0 <argint>
80105db6:	83 c4 10             	add    $0x10,%esp
80105db9:	85 c0                	test   %eax,%eax
80105dbb:	78 13                	js     80105dd0 <sys_chtickets+0x40>
    return -1;

  return chtickets(pid, tickets);
80105dbd:	83 ec 08             	sub    $0x8,%esp
80105dc0:	ff 75 f4             	pushl  -0xc(%ebp)
80105dc3:	ff 75 f0             	pushl  -0x10(%ebp)
80105dc6:	e8 45 e5 ff ff       	call   80104310 <chtickets>
80105dcb:	83 c4 10             	add    $0x10,%esp
}
80105dce:	c9                   	leave  
80105dcf:	c3                   	ret    
int
sys_chtickets(void)
{
  int pid, tickets;
  if(argint(0, &pid) < 0)
    return -1;
80105dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(argint(1, &tickets) < 0)
    return -1;

  return chtickets(pid, tickets);
}
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    

80105dd7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105dd7:	1e                   	push   %ds
  pushl %es
80105dd8:	06                   	push   %es
  pushl %fs
80105dd9:	0f a0                	push   %fs
  pushl %gs
80105ddb:	0f a8                	push   %gs
  pushal
80105ddd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105dde:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105de2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105de4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105de6:	54                   	push   %esp
  call trap
80105de7:	e8 e4 00 00 00       	call   80105ed0 <trap>
  addl $4, %esp
80105dec:	83 c4 04             	add    $0x4,%esp

80105def <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105def:	61                   	popa   
  popl %gs
80105df0:	0f a9                	pop    %gs
  popl %fs
80105df2:	0f a1                	pop    %fs
  popl %es
80105df4:	07                   	pop    %es
  popl %ds
80105df5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105df6:	83 c4 08             	add    $0x8,%esp
  iret
80105df9:	cf                   	iret   
80105dfa:	66 90                	xchg   %ax,%ax
80105dfc:	66 90                	xchg   %ax,%ax
80105dfe:	66 90                	xchg   %ax,%ax

80105e00 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105e00:	31 c0                	xor    %eax,%eax
80105e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e08:	8b 14 85 18 b0 10 80 	mov    -0x7fef4fe8(,%eax,4),%edx
80105e0f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105e14:	c6 04 c5 a4 62 11 80 	movb   $0x0,-0x7fee9d5c(,%eax,8)
80105e1b:	00 
80105e1c:	66 89 0c c5 a2 62 11 	mov    %cx,-0x7fee9d5e(,%eax,8)
80105e23:	80 
80105e24:	c6 04 c5 a5 62 11 80 	movb   $0x8e,-0x7fee9d5b(,%eax,8)
80105e2b:	8e 
80105e2c:	66 89 14 c5 a0 62 11 	mov    %dx,-0x7fee9d60(,%eax,8)
80105e33:	80 
80105e34:	c1 ea 10             	shr    $0x10,%edx
80105e37:	66 89 14 c5 a6 62 11 	mov    %dx,-0x7fee9d5a(,%eax,8)
80105e3e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105e3f:	83 c0 01             	add    $0x1,%eax
80105e42:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e47:	75 bf                	jne    80105e08 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e49:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e4a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e4f:	89 e5                	mov    %esp,%ebp
80105e51:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e54:	a1 18 b1 10 80       	mov    0x8010b118,%eax

  initlock(&tickslock, "time");
80105e59:	68 51 7e 10 80       	push   $0x80107e51
80105e5e:	68 60 62 11 80       	push   $0x80116260
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e63:	66 89 15 a2 64 11 80 	mov    %dx,0x801164a2
80105e6a:	c6 05 a4 64 11 80 00 	movb   $0x0,0x801164a4
80105e71:	66 a3 a0 64 11 80    	mov    %ax,0x801164a0
80105e77:	c1 e8 10             	shr    $0x10,%eax
80105e7a:	c6 05 a5 64 11 80 ef 	movb   $0xef,0x801164a5
80105e81:	66 a3 a6 64 11 80    	mov    %ax,0x801164a6

  initlock(&tickslock, "time");
80105e87:	e8 e4 e8 ff ff       	call   80104770 <initlock>
}
80105e8c:	83 c4 10             	add    $0x10,%esp
80105e8f:	c9                   	leave  
80105e90:	c3                   	ret    
80105e91:	eb 0d                	jmp    80105ea0 <idtinit>
80105e93:	90                   	nop
80105e94:	90                   	nop
80105e95:	90                   	nop
80105e96:	90                   	nop
80105e97:	90                   	nop
80105e98:	90                   	nop
80105e99:	90                   	nop
80105e9a:	90                   	nop
80105e9b:	90                   	nop
80105e9c:	90                   	nop
80105e9d:	90                   	nop
80105e9e:	90                   	nop
80105e9f:	90                   	nop

80105ea0 <idtinit>:

void
idtinit(void)
{
80105ea0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105ea1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ea6:	89 e5                	mov    %esp,%ebp
80105ea8:	83 ec 10             	sub    $0x10,%esp
80105eab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105eaf:	b8 a0 62 11 80       	mov    $0x801162a0,%eax
80105eb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105eb8:	c1 e8 10             	shr    $0x10,%eax
80105ebb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105ebf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ec2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ec5:	c9                   	leave  
80105ec6:	c3                   	ret    
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ed0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	83 ec 1c             	sub    $0x1c,%esp
80105ed9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105edc:	8b 47 30             	mov    0x30(%edi),%eax
80105edf:	83 f8 40             	cmp    $0x40,%eax
80105ee2:	0f 84 88 01 00 00    	je     80106070 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ee8:	83 e8 20             	sub    $0x20,%eax
80105eeb:	83 f8 1f             	cmp    $0x1f,%eax
80105eee:	77 10                	ja     80105f00 <trap+0x30>
80105ef0:	ff 24 85 f8 7e 10 80 	jmp    *-0x7fef8108(,%eax,4)
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f00:	e8 ab d8 ff ff       	call   801037b0 <myproc>
80105f05:	85 c0                	test   %eax,%eax
80105f07:	0f 84 dc 01 00 00    	je     801060e9 <trap+0x219>
80105f0d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f11:	0f 84 d2 01 00 00    	je     801060e9 <trap+0x219>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f17:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f1a:	8b 57 38             	mov    0x38(%edi),%edx
80105f1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105f20:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105f23:	e8 68 d8 ff ff       	call   80103790 <cpuid>
80105f28:	8b 77 34             	mov    0x34(%edi),%esi
80105f2b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105f2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f31:	e8 7a d8 ff ff       	call   801037b0 <myproc>
80105f36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f39:	e8 72 d8 ff ff       	call   801037b0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f44:	51                   	push   %ecx
80105f45:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f46:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f49:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f4c:	56                   	push   %esi
80105f4d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f4e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f51:	52                   	push   %edx
80105f52:	ff 70 10             	pushl  0x10(%eax)
80105f55:	68 b4 7e 10 80       	push   $0x80107eb4
80105f5a:	e8 01 a7 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f5f:	83 c4 20             	add    $0x20,%esp
80105f62:	e8 49 d8 ff ff       	call   801037b0 <myproc>
80105f67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105f6e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f70:	e8 3b d8 ff ff       	call   801037b0 <myproc>
80105f75:	85 c0                	test   %eax,%eax
80105f77:	74 0c                	je     80105f85 <trap+0xb5>
80105f79:	e8 32 d8 ff ff       	call   801037b0 <myproc>
80105f7e:	8b 50 24             	mov    0x24(%eax),%edx
80105f81:	85 d2                	test   %edx,%edx
80105f83:	75 4b                	jne    80105fd0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105f85:	e8 26 d8 ff ff       	call   801037b0 <myproc>
80105f8a:	85 c0                	test   %eax,%eax
80105f8c:	74 0b                	je     80105f99 <trap+0xc9>
80105f8e:	e8 1d d8 ff ff       	call   801037b0 <myproc>
80105f93:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f97:	74 4f                	je     80105fe8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f99:	e8 12 d8 ff ff       	call   801037b0 <myproc>
80105f9e:	85 c0                	test   %eax,%eax
80105fa0:	74 1d                	je     80105fbf <trap+0xef>
80105fa2:	e8 09 d8 ff ff       	call   801037b0 <myproc>
80105fa7:	8b 40 24             	mov    0x24(%eax),%eax
80105faa:	85 c0                	test   %eax,%eax
80105fac:	74 11                	je     80105fbf <trap+0xef>
80105fae:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fb2:	83 e0 03             	and    $0x3,%eax
80105fb5:	66 83 f8 03          	cmp    $0x3,%ax
80105fb9:	0f 84 da 00 00 00    	je     80106099 <trap+0x1c9>
    exit();
}
80105fbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc2:	5b                   	pop    %ebx
80105fc3:	5e                   	pop    %esi
80105fc4:	5f                   	pop    %edi
80105fc5:	5d                   	pop    %ebp
80105fc6:	c3                   	ret    
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fd0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fd4:	83 e0 03             	and    $0x3,%eax
80105fd7:	66 83 f8 03          	cmp    $0x3,%ax
80105fdb:	75 a8                	jne    80105f85 <trap+0xb5>
    exit();
80105fdd:	e8 3e dc ff ff       	call   80103c20 <exit>
80105fe2:	eb a1                	jmp    80105f85 <trap+0xb5>
80105fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105fe8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105fec:	75 ab                	jne    80105f99 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105fee:	e8 5d dd ff ff       	call   80103d50 <yield>
80105ff3:	eb a4                	jmp    80105f99 <trap+0xc9>
80105ff5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105ff8:	e8 93 d7 ff ff       	call   80103790 <cpuid>
80105ffd:	85 c0                	test   %eax,%eax
80105fff:	0f 84 ab 00 00 00    	je     801060b0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106005:	e8 06 c7 ff ff       	call   80102710 <lapiceoi>
    break;
8010600a:	e9 61 ff ff ff       	jmp    80105f70 <trap+0xa0>
8010600f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106010:	e8 bb c5 ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
80106015:	e8 f6 c6 ff ff       	call   80102710 <lapiceoi>
    break;
8010601a:	e9 51 ff ff ff       	jmp    80105f70 <trap+0xa0>
8010601f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106020:	e8 6b 02 00 00       	call   80106290 <uartintr>
    lapiceoi();
80106025:	e8 e6 c6 ff ff       	call   80102710 <lapiceoi>
    break;
8010602a:	e9 41 ff ff ff       	jmp    80105f70 <trap+0xa0>
8010602f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106030:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106034:	8b 77 38             	mov    0x38(%edi),%esi
80106037:	e8 54 d7 ff ff       	call   80103790 <cpuid>
8010603c:	56                   	push   %esi
8010603d:	53                   	push   %ebx
8010603e:	50                   	push   %eax
8010603f:	68 5c 7e 10 80       	push   $0x80107e5c
80106044:	e8 17 a6 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106049:	e8 c2 c6 ff ff       	call   80102710 <lapiceoi>
    break;
8010604e:	83 c4 10             	add    $0x10,%esp
80106051:	e9 1a ff ff ff       	jmp    80105f70 <trap+0xa0>
80106056:	8d 76 00             	lea    0x0(%esi),%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106060:	e8 eb bf ff ff       	call   80102050 <ideintr>
80106065:	eb 9e                	jmp    80106005 <trap+0x135>
80106067:	89 f6                	mov    %esi,%esi
80106069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106070:	e8 3b d7 ff ff       	call   801037b0 <myproc>
80106075:	8b 58 24             	mov    0x24(%eax),%ebx
80106078:	85 db                	test   %ebx,%ebx
8010607a:	75 2c                	jne    801060a8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010607c:	e8 2f d7 ff ff       	call   801037b0 <myproc>
80106081:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106084:	e8 57 ed ff ff       	call   80104de0 <syscall>
    if(myproc()->killed)
80106089:	e8 22 d7 ff ff       	call   801037b0 <myproc>
8010608e:	8b 48 24             	mov    0x24(%eax),%ecx
80106091:	85 c9                	test   %ecx,%ecx
80106093:	0f 84 26 ff ff ff    	je     80105fbf <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010609c:	5b                   	pop    %ebx
8010609d:	5e                   	pop    %esi
8010609e:	5f                   	pop    %edi
8010609f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801060a0:	e9 7b db ff ff       	jmp    80103c20 <exit>
801060a5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801060a8:	e8 73 db ff ff       	call   80103c20 <exit>
801060ad:	eb cd                	jmp    8010607c <trap+0x1ac>
801060af:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801060b0:	83 ec 0c             	sub    $0xc,%esp
801060b3:	68 60 62 11 80       	push   $0x80116260
801060b8:	e8 b3 e7 ff ff       	call   80104870 <acquire>
      ticks++;
801060bd:	83 05 a0 6a 11 80 01 	addl   $0x1,0x80116aa0
      updatestatistics(); //will update proc statistic every clock tick
801060c4:	e8 97 e2 ff ff       	call   80104360 <updatestatistics>
      wakeup(&ticks);
801060c9:	c7 04 24 a0 6a 11 80 	movl   $0x80116aa0,(%esp)
801060d0:	e8 2b e0 ff ff       	call   80104100 <wakeup>
      release(&tickslock);
801060d5:	c7 04 24 60 62 11 80 	movl   $0x80116260,(%esp)
801060dc:	e8 af e8 ff ff       	call   80104990 <release>
801060e1:	83 c4 10             	add    $0x10,%esp
801060e4:	e9 1c ff ff ff       	jmp    80106005 <trap+0x135>
801060e9:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060ec:	8b 5f 38             	mov    0x38(%edi),%ebx
801060ef:	e8 9c d6 ff ff       	call   80103790 <cpuid>
801060f4:	83 ec 0c             	sub    $0xc,%esp
801060f7:	56                   	push   %esi
801060f8:	53                   	push   %ebx
801060f9:	50                   	push   %eax
801060fa:	ff 77 30             	pushl  0x30(%edi)
801060fd:	68 80 7e 10 80       	push   $0x80107e80
80106102:	e8 59 a5 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106107:	83 c4 14             	add    $0x14,%esp
8010610a:	68 56 7e 10 80       	push   $0x80107e56
8010610f:	e8 5c a2 ff ff       	call   80100370 <panic>
80106114:	66 90                	xchg   %ax,%ax
80106116:	66 90                	xchg   %ax,%ax
80106118:	66 90                	xchg   %ax,%ax
8010611a:	66 90                	xchg   %ax,%ax
8010611c:	66 90                	xchg   %ax,%ax
8010611e:	66 90                	xchg   %ax,%ax

80106120 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106120:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106125:	55                   	push   %ebp
80106126:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106128:	85 c0                	test   %eax,%eax
8010612a:	74 1c                	je     80106148 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010612c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106131:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106132:	a8 01                	test   $0x1,%al
80106134:	74 12                	je     80106148 <uartgetc+0x28>
80106136:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010613b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010613c:	0f b6 c0             	movzbl %al,%eax
}
8010613f:	5d                   	pop    %ebp
80106140:	c3                   	ret    
80106141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010614d:	5d                   	pop    %ebp
8010614e:	c3                   	ret    
8010614f:	90                   	nop

80106150 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	57                   	push   %edi
80106154:	56                   	push   %esi
80106155:	53                   	push   %ebx
80106156:	89 c7                	mov    %eax,%edi
80106158:	bb 80 00 00 00       	mov    $0x80,%ebx
8010615d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106162:	83 ec 0c             	sub    $0xc,%esp
80106165:	eb 1b                	jmp    80106182 <uartputc.part.0+0x32>
80106167:	89 f6                	mov    %esi,%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	6a 0a                	push   $0xa
80106175:	e8 b6 c5 ff ff       	call   80102730 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010617a:	83 c4 10             	add    $0x10,%esp
8010617d:	83 eb 01             	sub    $0x1,%ebx
80106180:	74 07                	je     80106189 <uartputc.part.0+0x39>
80106182:	89 f2                	mov    %esi,%edx
80106184:	ec                   	in     (%dx),%al
80106185:	a8 20                	test   $0x20,%al
80106187:	74 e7                	je     80106170 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106189:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010618e:	89 f8                	mov    %edi,%eax
80106190:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106191:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106194:	5b                   	pop    %ebx
80106195:	5e                   	pop    %esi
80106196:	5f                   	pop    %edi
80106197:	5d                   	pop    %ebp
80106198:	c3                   	ret    
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061a0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801061a0:	55                   	push   %ebp
801061a1:	31 c9                	xor    %ecx,%ecx
801061a3:	89 c8                	mov    %ecx,%eax
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	57                   	push   %edi
801061a8:	56                   	push   %esi
801061a9:	53                   	push   %ebx
801061aa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801061af:	89 da                	mov    %ebx,%edx
801061b1:	83 ec 0c             	sub    $0xc,%esp
801061b4:	ee                   	out    %al,(%dx)
801061b5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801061ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801061bf:	89 fa                	mov    %edi,%edx
801061c1:	ee                   	out    %al,(%dx)
801061c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801061c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061cc:	ee                   	out    %al,(%dx)
801061cd:	be f9 03 00 00       	mov    $0x3f9,%esi
801061d2:	89 c8                	mov    %ecx,%eax
801061d4:	89 f2                	mov    %esi,%edx
801061d6:	ee                   	out    %al,(%dx)
801061d7:	b8 03 00 00 00       	mov    $0x3,%eax
801061dc:	89 fa                	mov    %edi,%edx
801061de:	ee                   	out    %al,(%dx)
801061df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801061e4:	89 c8                	mov    %ecx,%eax
801061e6:	ee                   	out    %al,(%dx)
801061e7:	b8 01 00 00 00       	mov    $0x1,%eax
801061ec:	89 f2                	mov    %esi,%edx
801061ee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061f4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801061f5:	3c ff                	cmp    $0xff,%al
801061f7:	74 5a                	je     80106253 <uartinit+0xb3>
    return;
  uart = 1;
801061f9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106200:	00 00 00 
80106203:	89 da                	mov    %ebx,%edx
80106205:	ec                   	in     (%dx),%al
80106206:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010620b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010620c:	83 ec 08             	sub    $0x8,%esp
8010620f:	bb 78 7f 10 80       	mov    $0x80107f78,%ebx
80106214:	6a 00                	push   $0x0
80106216:	6a 04                	push   $0x4
80106218:	e8 83 c0 ff ff       	call   801022a0 <ioapicenable>
8010621d:	83 c4 10             	add    $0x10,%esp
80106220:	b8 78 00 00 00       	mov    $0x78,%eax
80106225:	eb 13                	jmp    8010623a <uartinit+0x9a>
80106227:	89 f6                	mov    %esi,%esi
80106229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106230:	83 c3 01             	add    $0x1,%ebx
80106233:	0f be 03             	movsbl (%ebx),%eax
80106236:	84 c0                	test   %al,%al
80106238:	74 19                	je     80106253 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010623a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106240:	85 d2                	test   %edx,%edx
80106242:	74 ec                	je     80106230 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106244:	83 c3 01             	add    $0x1,%ebx
80106247:	e8 04 ff ff ff       	call   80106150 <uartputc.part.0>
8010624c:	0f be 03             	movsbl (%ebx),%eax
8010624f:	84 c0                	test   %al,%al
80106251:	75 e7                	jne    8010623a <uartinit+0x9a>
    uartputc(*p);
}
80106253:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106256:	5b                   	pop    %ebx
80106257:	5e                   	pop    %esi
80106258:	5f                   	pop    %edi
80106259:	5d                   	pop    %ebp
8010625a:	c3                   	ret    
8010625b:	90                   	nop
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106260 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106260:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106266:	55                   	push   %ebp
80106267:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106269:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010626b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010626e:	74 10                	je     80106280 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106270:	5d                   	pop    %ebp
80106271:	e9 da fe ff ff       	jmp    80106150 <uartputc.part.0>
80106276:	8d 76 00             	lea    0x0(%esi),%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106280:	5d                   	pop    %ebp
80106281:	c3                   	ret    
80106282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106290 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106296:	68 20 61 10 80       	push   $0x80106120
8010629b:	e8 50 a5 ff ff       	call   801007f0 <consoleintr>
}
801062a0:	83 c4 10             	add    $0x10,%esp
801062a3:	c9                   	leave  
801062a4:	c3                   	ret    

801062a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $0
801062a7:	6a 00                	push   $0x0
  jmp alltraps
801062a9:	e9 29 fb ff ff       	jmp    80105dd7 <alltraps>

801062ae <vector1>:
.globl vector1
vector1:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $1
801062b0:	6a 01                	push   $0x1
  jmp alltraps
801062b2:	e9 20 fb ff ff       	jmp    80105dd7 <alltraps>

801062b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $2
801062b9:	6a 02                	push   $0x2
  jmp alltraps
801062bb:	e9 17 fb ff ff       	jmp    80105dd7 <alltraps>

801062c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $3
801062c2:	6a 03                	push   $0x3
  jmp alltraps
801062c4:	e9 0e fb ff ff       	jmp    80105dd7 <alltraps>

801062c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $4
801062cb:	6a 04                	push   $0x4
  jmp alltraps
801062cd:	e9 05 fb ff ff       	jmp    80105dd7 <alltraps>

801062d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $5
801062d4:	6a 05                	push   $0x5
  jmp alltraps
801062d6:	e9 fc fa ff ff       	jmp    80105dd7 <alltraps>

801062db <vector6>:
.globl vector6
vector6:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $6
801062dd:	6a 06                	push   $0x6
  jmp alltraps
801062df:	e9 f3 fa ff ff       	jmp    80105dd7 <alltraps>

801062e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $7
801062e6:	6a 07                	push   $0x7
  jmp alltraps
801062e8:	e9 ea fa ff ff       	jmp    80105dd7 <alltraps>

801062ed <vector8>:
.globl vector8
vector8:
  pushl $8
801062ed:	6a 08                	push   $0x8
  jmp alltraps
801062ef:	e9 e3 fa ff ff       	jmp    80105dd7 <alltraps>

801062f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $9
801062f6:	6a 09                	push   $0x9
  jmp alltraps
801062f8:	e9 da fa ff ff       	jmp    80105dd7 <alltraps>

801062fd <vector10>:
.globl vector10
vector10:
  pushl $10
801062fd:	6a 0a                	push   $0xa
  jmp alltraps
801062ff:	e9 d3 fa ff ff       	jmp    80105dd7 <alltraps>

80106304 <vector11>:
.globl vector11
vector11:
  pushl $11
80106304:	6a 0b                	push   $0xb
  jmp alltraps
80106306:	e9 cc fa ff ff       	jmp    80105dd7 <alltraps>

8010630b <vector12>:
.globl vector12
vector12:
  pushl $12
8010630b:	6a 0c                	push   $0xc
  jmp alltraps
8010630d:	e9 c5 fa ff ff       	jmp    80105dd7 <alltraps>

80106312 <vector13>:
.globl vector13
vector13:
  pushl $13
80106312:	6a 0d                	push   $0xd
  jmp alltraps
80106314:	e9 be fa ff ff       	jmp    80105dd7 <alltraps>

80106319 <vector14>:
.globl vector14
vector14:
  pushl $14
80106319:	6a 0e                	push   $0xe
  jmp alltraps
8010631b:	e9 b7 fa ff ff       	jmp    80105dd7 <alltraps>

80106320 <vector15>:
.globl vector15
vector15:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $15
80106322:	6a 0f                	push   $0xf
  jmp alltraps
80106324:	e9 ae fa ff ff       	jmp    80105dd7 <alltraps>

80106329 <vector16>:
.globl vector16
vector16:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $16
8010632b:	6a 10                	push   $0x10
  jmp alltraps
8010632d:	e9 a5 fa ff ff       	jmp    80105dd7 <alltraps>

80106332 <vector17>:
.globl vector17
vector17:
  pushl $17
80106332:	6a 11                	push   $0x11
  jmp alltraps
80106334:	e9 9e fa ff ff       	jmp    80105dd7 <alltraps>

80106339 <vector18>:
.globl vector18
vector18:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $18
8010633b:	6a 12                	push   $0x12
  jmp alltraps
8010633d:	e9 95 fa ff ff       	jmp    80105dd7 <alltraps>

80106342 <vector19>:
.globl vector19
vector19:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $19
80106344:	6a 13                	push   $0x13
  jmp alltraps
80106346:	e9 8c fa ff ff       	jmp    80105dd7 <alltraps>

8010634b <vector20>:
.globl vector20
vector20:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $20
8010634d:	6a 14                	push   $0x14
  jmp alltraps
8010634f:	e9 83 fa ff ff       	jmp    80105dd7 <alltraps>

80106354 <vector21>:
.globl vector21
vector21:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $21
80106356:	6a 15                	push   $0x15
  jmp alltraps
80106358:	e9 7a fa ff ff       	jmp    80105dd7 <alltraps>

8010635d <vector22>:
.globl vector22
vector22:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $22
8010635f:	6a 16                	push   $0x16
  jmp alltraps
80106361:	e9 71 fa ff ff       	jmp    80105dd7 <alltraps>

80106366 <vector23>:
.globl vector23
vector23:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $23
80106368:	6a 17                	push   $0x17
  jmp alltraps
8010636a:	e9 68 fa ff ff       	jmp    80105dd7 <alltraps>

8010636f <vector24>:
.globl vector24
vector24:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $24
80106371:	6a 18                	push   $0x18
  jmp alltraps
80106373:	e9 5f fa ff ff       	jmp    80105dd7 <alltraps>

80106378 <vector25>:
.globl vector25
vector25:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $25
8010637a:	6a 19                	push   $0x19
  jmp alltraps
8010637c:	e9 56 fa ff ff       	jmp    80105dd7 <alltraps>

80106381 <vector26>:
.globl vector26
vector26:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $26
80106383:	6a 1a                	push   $0x1a
  jmp alltraps
80106385:	e9 4d fa ff ff       	jmp    80105dd7 <alltraps>

8010638a <vector27>:
.globl vector27
vector27:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $27
8010638c:	6a 1b                	push   $0x1b
  jmp alltraps
8010638e:	e9 44 fa ff ff       	jmp    80105dd7 <alltraps>

80106393 <vector28>:
.globl vector28
vector28:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $28
80106395:	6a 1c                	push   $0x1c
  jmp alltraps
80106397:	e9 3b fa ff ff       	jmp    80105dd7 <alltraps>

8010639c <vector29>:
.globl vector29
vector29:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $29
8010639e:	6a 1d                	push   $0x1d
  jmp alltraps
801063a0:	e9 32 fa ff ff       	jmp    80105dd7 <alltraps>

801063a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $30
801063a7:	6a 1e                	push   $0x1e
  jmp alltraps
801063a9:	e9 29 fa ff ff       	jmp    80105dd7 <alltraps>

801063ae <vector31>:
.globl vector31
vector31:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $31
801063b0:	6a 1f                	push   $0x1f
  jmp alltraps
801063b2:	e9 20 fa ff ff       	jmp    80105dd7 <alltraps>

801063b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $32
801063b9:	6a 20                	push   $0x20
  jmp alltraps
801063bb:	e9 17 fa ff ff       	jmp    80105dd7 <alltraps>

801063c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $33
801063c2:	6a 21                	push   $0x21
  jmp alltraps
801063c4:	e9 0e fa ff ff       	jmp    80105dd7 <alltraps>

801063c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $34
801063cb:	6a 22                	push   $0x22
  jmp alltraps
801063cd:	e9 05 fa ff ff       	jmp    80105dd7 <alltraps>

801063d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $35
801063d4:	6a 23                	push   $0x23
  jmp alltraps
801063d6:	e9 fc f9 ff ff       	jmp    80105dd7 <alltraps>

801063db <vector36>:
.globl vector36
vector36:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $36
801063dd:	6a 24                	push   $0x24
  jmp alltraps
801063df:	e9 f3 f9 ff ff       	jmp    80105dd7 <alltraps>

801063e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $37
801063e6:	6a 25                	push   $0x25
  jmp alltraps
801063e8:	e9 ea f9 ff ff       	jmp    80105dd7 <alltraps>

801063ed <vector38>:
.globl vector38
vector38:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $38
801063ef:	6a 26                	push   $0x26
  jmp alltraps
801063f1:	e9 e1 f9 ff ff       	jmp    80105dd7 <alltraps>

801063f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $39
801063f8:	6a 27                	push   $0x27
  jmp alltraps
801063fa:	e9 d8 f9 ff ff       	jmp    80105dd7 <alltraps>

801063ff <vector40>:
.globl vector40
vector40:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $40
80106401:	6a 28                	push   $0x28
  jmp alltraps
80106403:	e9 cf f9 ff ff       	jmp    80105dd7 <alltraps>

80106408 <vector41>:
.globl vector41
vector41:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $41
8010640a:	6a 29                	push   $0x29
  jmp alltraps
8010640c:	e9 c6 f9 ff ff       	jmp    80105dd7 <alltraps>

80106411 <vector42>:
.globl vector42
vector42:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $42
80106413:	6a 2a                	push   $0x2a
  jmp alltraps
80106415:	e9 bd f9 ff ff       	jmp    80105dd7 <alltraps>

8010641a <vector43>:
.globl vector43
vector43:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $43
8010641c:	6a 2b                	push   $0x2b
  jmp alltraps
8010641e:	e9 b4 f9 ff ff       	jmp    80105dd7 <alltraps>

80106423 <vector44>:
.globl vector44
vector44:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $44
80106425:	6a 2c                	push   $0x2c
  jmp alltraps
80106427:	e9 ab f9 ff ff       	jmp    80105dd7 <alltraps>

8010642c <vector45>:
.globl vector45
vector45:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $45
8010642e:	6a 2d                	push   $0x2d
  jmp alltraps
80106430:	e9 a2 f9 ff ff       	jmp    80105dd7 <alltraps>

80106435 <vector46>:
.globl vector46
vector46:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $46
80106437:	6a 2e                	push   $0x2e
  jmp alltraps
80106439:	e9 99 f9 ff ff       	jmp    80105dd7 <alltraps>

8010643e <vector47>:
.globl vector47
vector47:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $47
80106440:	6a 2f                	push   $0x2f
  jmp alltraps
80106442:	e9 90 f9 ff ff       	jmp    80105dd7 <alltraps>

80106447 <vector48>:
.globl vector48
vector48:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $48
80106449:	6a 30                	push   $0x30
  jmp alltraps
8010644b:	e9 87 f9 ff ff       	jmp    80105dd7 <alltraps>

80106450 <vector49>:
.globl vector49
vector49:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $49
80106452:	6a 31                	push   $0x31
  jmp alltraps
80106454:	e9 7e f9 ff ff       	jmp    80105dd7 <alltraps>

80106459 <vector50>:
.globl vector50
vector50:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $50
8010645b:	6a 32                	push   $0x32
  jmp alltraps
8010645d:	e9 75 f9 ff ff       	jmp    80105dd7 <alltraps>

80106462 <vector51>:
.globl vector51
vector51:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $51
80106464:	6a 33                	push   $0x33
  jmp alltraps
80106466:	e9 6c f9 ff ff       	jmp    80105dd7 <alltraps>

8010646b <vector52>:
.globl vector52
vector52:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $52
8010646d:	6a 34                	push   $0x34
  jmp alltraps
8010646f:	e9 63 f9 ff ff       	jmp    80105dd7 <alltraps>

80106474 <vector53>:
.globl vector53
vector53:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $53
80106476:	6a 35                	push   $0x35
  jmp alltraps
80106478:	e9 5a f9 ff ff       	jmp    80105dd7 <alltraps>

8010647d <vector54>:
.globl vector54
vector54:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $54
8010647f:	6a 36                	push   $0x36
  jmp alltraps
80106481:	e9 51 f9 ff ff       	jmp    80105dd7 <alltraps>

80106486 <vector55>:
.globl vector55
vector55:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $55
80106488:	6a 37                	push   $0x37
  jmp alltraps
8010648a:	e9 48 f9 ff ff       	jmp    80105dd7 <alltraps>

8010648f <vector56>:
.globl vector56
vector56:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $56
80106491:	6a 38                	push   $0x38
  jmp alltraps
80106493:	e9 3f f9 ff ff       	jmp    80105dd7 <alltraps>

80106498 <vector57>:
.globl vector57
vector57:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $57
8010649a:	6a 39                	push   $0x39
  jmp alltraps
8010649c:	e9 36 f9 ff ff       	jmp    80105dd7 <alltraps>

801064a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $58
801064a3:	6a 3a                	push   $0x3a
  jmp alltraps
801064a5:	e9 2d f9 ff ff       	jmp    80105dd7 <alltraps>

801064aa <vector59>:
.globl vector59
vector59:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $59
801064ac:	6a 3b                	push   $0x3b
  jmp alltraps
801064ae:	e9 24 f9 ff ff       	jmp    80105dd7 <alltraps>

801064b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $60
801064b5:	6a 3c                	push   $0x3c
  jmp alltraps
801064b7:	e9 1b f9 ff ff       	jmp    80105dd7 <alltraps>

801064bc <vector61>:
.globl vector61
vector61:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $61
801064be:	6a 3d                	push   $0x3d
  jmp alltraps
801064c0:	e9 12 f9 ff ff       	jmp    80105dd7 <alltraps>

801064c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $62
801064c7:	6a 3e                	push   $0x3e
  jmp alltraps
801064c9:	e9 09 f9 ff ff       	jmp    80105dd7 <alltraps>

801064ce <vector63>:
.globl vector63
vector63:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $63
801064d0:	6a 3f                	push   $0x3f
  jmp alltraps
801064d2:	e9 00 f9 ff ff       	jmp    80105dd7 <alltraps>

801064d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $64
801064d9:	6a 40                	push   $0x40
  jmp alltraps
801064db:	e9 f7 f8 ff ff       	jmp    80105dd7 <alltraps>

801064e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $65
801064e2:	6a 41                	push   $0x41
  jmp alltraps
801064e4:	e9 ee f8 ff ff       	jmp    80105dd7 <alltraps>

801064e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $66
801064eb:	6a 42                	push   $0x42
  jmp alltraps
801064ed:	e9 e5 f8 ff ff       	jmp    80105dd7 <alltraps>

801064f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $67
801064f4:	6a 43                	push   $0x43
  jmp alltraps
801064f6:	e9 dc f8 ff ff       	jmp    80105dd7 <alltraps>

801064fb <vector68>:
.globl vector68
vector68:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $68
801064fd:	6a 44                	push   $0x44
  jmp alltraps
801064ff:	e9 d3 f8 ff ff       	jmp    80105dd7 <alltraps>

80106504 <vector69>:
.globl vector69
vector69:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $69
80106506:	6a 45                	push   $0x45
  jmp alltraps
80106508:	e9 ca f8 ff ff       	jmp    80105dd7 <alltraps>

8010650d <vector70>:
.globl vector70
vector70:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $70
8010650f:	6a 46                	push   $0x46
  jmp alltraps
80106511:	e9 c1 f8 ff ff       	jmp    80105dd7 <alltraps>

80106516 <vector71>:
.globl vector71
vector71:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $71
80106518:	6a 47                	push   $0x47
  jmp alltraps
8010651a:	e9 b8 f8 ff ff       	jmp    80105dd7 <alltraps>

8010651f <vector72>:
.globl vector72
vector72:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $72
80106521:	6a 48                	push   $0x48
  jmp alltraps
80106523:	e9 af f8 ff ff       	jmp    80105dd7 <alltraps>

80106528 <vector73>:
.globl vector73
vector73:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $73
8010652a:	6a 49                	push   $0x49
  jmp alltraps
8010652c:	e9 a6 f8 ff ff       	jmp    80105dd7 <alltraps>

80106531 <vector74>:
.globl vector74
vector74:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $74
80106533:	6a 4a                	push   $0x4a
  jmp alltraps
80106535:	e9 9d f8 ff ff       	jmp    80105dd7 <alltraps>

8010653a <vector75>:
.globl vector75
vector75:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $75
8010653c:	6a 4b                	push   $0x4b
  jmp alltraps
8010653e:	e9 94 f8 ff ff       	jmp    80105dd7 <alltraps>

80106543 <vector76>:
.globl vector76
vector76:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $76
80106545:	6a 4c                	push   $0x4c
  jmp alltraps
80106547:	e9 8b f8 ff ff       	jmp    80105dd7 <alltraps>

8010654c <vector77>:
.globl vector77
vector77:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $77
8010654e:	6a 4d                	push   $0x4d
  jmp alltraps
80106550:	e9 82 f8 ff ff       	jmp    80105dd7 <alltraps>

80106555 <vector78>:
.globl vector78
vector78:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $78
80106557:	6a 4e                	push   $0x4e
  jmp alltraps
80106559:	e9 79 f8 ff ff       	jmp    80105dd7 <alltraps>

8010655e <vector79>:
.globl vector79
vector79:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $79
80106560:	6a 4f                	push   $0x4f
  jmp alltraps
80106562:	e9 70 f8 ff ff       	jmp    80105dd7 <alltraps>

80106567 <vector80>:
.globl vector80
vector80:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $80
80106569:	6a 50                	push   $0x50
  jmp alltraps
8010656b:	e9 67 f8 ff ff       	jmp    80105dd7 <alltraps>

80106570 <vector81>:
.globl vector81
vector81:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $81
80106572:	6a 51                	push   $0x51
  jmp alltraps
80106574:	e9 5e f8 ff ff       	jmp    80105dd7 <alltraps>

80106579 <vector82>:
.globl vector82
vector82:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $82
8010657b:	6a 52                	push   $0x52
  jmp alltraps
8010657d:	e9 55 f8 ff ff       	jmp    80105dd7 <alltraps>

80106582 <vector83>:
.globl vector83
vector83:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $83
80106584:	6a 53                	push   $0x53
  jmp alltraps
80106586:	e9 4c f8 ff ff       	jmp    80105dd7 <alltraps>

8010658b <vector84>:
.globl vector84
vector84:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $84
8010658d:	6a 54                	push   $0x54
  jmp alltraps
8010658f:	e9 43 f8 ff ff       	jmp    80105dd7 <alltraps>

80106594 <vector85>:
.globl vector85
vector85:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $85
80106596:	6a 55                	push   $0x55
  jmp alltraps
80106598:	e9 3a f8 ff ff       	jmp    80105dd7 <alltraps>

8010659d <vector86>:
.globl vector86
vector86:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $86
8010659f:	6a 56                	push   $0x56
  jmp alltraps
801065a1:	e9 31 f8 ff ff       	jmp    80105dd7 <alltraps>

801065a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $87
801065a8:	6a 57                	push   $0x57
  jmp alltraps
801065aa:	e9 28 f8 ff ff       	jmp    80105dd7 <alltraps>

801065af <vector88>:
.globl vector88
vector88:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $88
801065b1:	6a 58                	push   $0x58
  jmp alltraps
801065b3:	e9 1f f8 ff ff       	jmp    80105dd7 <alltraps>

801065b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $89
801065ba:	6a 59                	push   $0x59
  jmp alltraps
801065bc:	e9 16 f8 ff ff       	jmp    80105dd7 <alltraps>

801065c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $90
801065c3:	6a 5a                	push   $0x5a
  jmp alltraps
801065c5:	e9 0d f8 ff ff       	jmp    80105dd7 <alltraps>

801065ca <vector91>:
.globl vector91
vector91:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $91
801065cc:	6a 5b                	push   $0x5b
  jmp alltraps
801065ce:	e9 04 f8 ff ff       	jmp    80105dd7 <alltraps>

801065d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $92
801065d5:	6a 5c                	push   $0x5c
  jmp alltraps
801065d7:	e9 fb f7 ff ff       	jmp    80105dd7 <alltraps>

801065dc <vector93>:
.globl vector93
vector93:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $93
801065de:	6a 5d                	push   $0x5d
  jmp alltraps
801065e0:	e9 f2 f7 ff ff       	jmp    80105dd7 <alltraps>

801065e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $94
801065e7:	6a 5e                	push   $0x5e
  jmp alltraps
801065e9:	e9 e9 f7 ff ff       	jmp    80105dd7 <alltraps>

801065ee <vector95>:
.globl vector95
vector95:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $95
801065f0:	6a 5f                	push   $0x5f
  jmp alltraps
801065f2:	e9 e0 f7 ff ff       	jmp    80105dd7 <alltraps>

801065f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $96
801065f9:	6a 60                	push   $0x60
  jmp alltraps
801065fb:	e9 d7 f7 ff ff       	jmp    80105dd7 <alltraps>

80106600 <vector97>:
.globl vector97
vector97:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $97
80106602:	6a 61                	push   $0x61
  jmp alltraps
80106604:	e9 ce f7 ff ff       	jmp    80105dd7 <alltraps>

80106609 <vector98>:
.globl vector98
vector98:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $98
8010660b:	6a 62                	push   $0x62
  jmp alltraps
8010660d:	e9 c5 f7 ff ff       	jmp    80105dd7 <alltraps>

80106612 <vector99>:
.globl vector99
vector99:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $99
80106614:	6a 63                	push   $0x63
  jmp alltraps
80106616:	e9 bc f7 ff ff       	jmp    80105dd7 <alltraps>

8010661b <vector100>:
.globl vector100
vector100:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $100
8010661d:	6a 64                	push   $0x64
  jmp alltraps
8010661f:	e9 b3 f7 ff ff       	jmp    80105dd7 <alltraps>

80106624 <vector101>:
.globl vector101
vector101:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $101
80106626:	6a 65                	push   $0x65
  jmp alltraps
80106628:	e9 aa f7 ff ff       	jmp    80105dd7 <alltraps>

8010662d <vector102>:
.globl vector102
vector102:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $102
8010662f:	6a 66                	push   $0x66
  jmp alltraps
80106631:	e9 a1 f7 ff ff       	jmp    80105dd7 <alltraps>

80106636 <vector103>:
.globl vector103
vector103:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $103
80106638:	6a 67                	push   $0x67
  jmp alltraps
8010663a:	e9 98 f7 ff ff       	jmp    80105dd7 <alltraps>

8010663f <vector104>:
.globl vector104
vector104:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $104
80106641:	6a 68                	push   $0x68
  jmp alltraps
80106643:	e9 8f f7 ff ff       	jmp    80105dd7 <alltraps>

80106648 <vector105>:
.globl vector105
vector105:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $105
8010664a:	6a 69                	push   $0x69
  jmp alltraps
8010664c:	e9 86 f7 ff ff       	jmp    80105dd7 <alltraps>

80106651 <vector106>:
.globl vector106
vector106:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $106
80106653:	6a 6a                	push   $0x6a
  jmp alltraps
80106655:	e9 7d f7 ff ff       	jmp    80105dd7 <alltraps>

8010665a <vector107>:
.globl vector107
vector107:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $107
8010665c:	6a 6b                	push   $0x6b
  jmp alltraps
8010665e:	e9 74 f7 ff ff       	jmp    80105dd7 <alltraps>

80106663 <vector108>:
.globl vector108
vector108:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $108
80106665:	6a 6c                	push   $0x6c
  jmp alltraps
80106667:	e9 6b f7 ff ff       	jmp    80105dd7 <alltraps>

8010666c <vector109>:
.globl vector109
vector109:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $109
8010666e:	6a 6d                	push   $0x6d
  jmp alltraps
80106670:	e9 62 f7 ff ff       	jmp    80105dd7 <alltraps>

80106675 <vector110>:
.globl vector110
vector110:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $110
80106677:	6a 6e                	push   $0x6e
  jmp alltraps
80106679:	e9 59 f7 ff ff       	jmp    80105dd7 <alltraps>

8010667e <vector111>:
.globl vector111
vector111:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $111
80106680:	6a 6f                	push   $0x6f
  jmp alltraps
80106682:	e9 50 f7 ff ff       	jmp    80105dd7 <alltraps>

80106687 <vector112>:
.globl vector112
vector112:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $112
80106689:	6a 70                	push   $0x70
  jmp alltraps
8010668b:	e9 47 f7 ff ff       	jmp    80105dd7 <alltraps>

80106690 <vector113>:
.globl vector113
vector113:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $113
80106692:	6a 71                	push   $0x71
  jmp alltraps
80106694:	e9 3e f7 ff ff       	jmp    80105dd7 <alltraps>

80106699 <vector114>:
.globl vector114
vector114:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $114
8010669b:	6a 72                	push   $0x72
  jmp alltraps
8010669d:	e9 35 f7 ff ff       	jmp    80105dd7 <alltraps>

801066a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $115
801066a4:	6a 73                	push   $0x73
  jmp alltraps
801066a6:	e9 2c f7 ff ff       	jmp    80105dd7 <alltraps>

801066ab <vector116>:
.globl vector116
vector116:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $116
801066ad:	6a 74                	push   $0x74
  jmp alltraps
801066af:	e9 23 f7 ff ff       	jmp    80105dd7 <alltraps>

801066b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $117
801066b6:	6a 75                	push   $0x75
  jmp alltraps
801066b8:	e9 1a f7 ff ff       	jmp    80105dd7 <alltraps>

801066bd <vector118>:
.globl vector118
vector118:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $118
801066bf:	6a 76                	push   $0x76
  jmp alltraps
801066c1:	e9 11 f7 ff ff       	jmp    80105dd7 <alltraps>

801066c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $119
801066c8:	6a 77                	push   $0x77
  jmp alltraps
801066ca:	e9 08 f7 ff ff       	jmp    80105dd7 <alltraps>

801066cf <vector120>:
.globl vector120
vector120:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $120
801066d1:	6a 78                	push   $0x78
  jmp alltraps
801066d3:	e9 ff f6 ff ff       	jmp    80105dd7 <alltraps>

801066d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $121
801066da:	6a 79                	push   $0x79
  jmp alltraps
801066dc:	e9 f6 f6 ff ff       	jmp    80105dd7 <alltraps>

801066e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $122
801066e3:	6a 7a                	push   $0x7a
  jmp alltraps
801066e5:	e9 ed f6 ff ff       	jmp    80105dd7 <alltraps>

801066ea <vector123>:
.globl vector123
vector123:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $123
801066ec:	6a 7b                	push   $0x7b
  jmp alltraps
801066ee:	e9 e4 f6 ff ff       	jmp    80105dd7 <alltraps>

801066f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $124
801066f5:	6a 7c                	push   $0x7c
  jmp alltraps
801066f7:	e9 db f6 ff ff       	jmp    80105dd7 <alltraps>

801066fc <vector125>:
.globl vector125
vector125:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $125
801066fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106700:	e9 d2 f6 ff ff       	jmp    80105dd7 <alltraps>

80106705 <vector126>:
.globl vector126
vector126:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $126
80106707:	6a 7e                	push   $0x7e
  jmp alltraps
80106709:	e9 c9 f6 ff ff       	jmp    80105dd7 <alltraps>

8010670e <vector127>:
.globl vector127
vector127:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $127
80106710:	6a 7f                	push   $0x7f
  jmp alltraps
80106712:	e9 c0 f6 ff ff       	jmp    80105dd7 <alltraps>

80106717 <vector128>:
.globl vector128
vector128:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $128
80106719:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010671e:	e9 b4 f6 ff ff       	jmp    80105dd7 <alltraps>

80106723 <vector129>:
.globl vector129
vector129:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $129
80106725:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010672a:	e9 a8 f6 ff ff       	jmp    80105dd7 <alltraps>

8010672f <vector130>:
.globl vector130
vector130:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $130
80106731:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106736:	e9 9c f6 ff ff       	jmp    80105dd7 <alltraps>

8010673b <vector131>:
.globl vector131
vector131:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $131
8010673d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106742:	e9 90 f6 ff ff       	jmp    80105dd7 <alltraps>

80106747 <vector132>:
.globl vector132
vector132:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $132
80106749:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010674e:	e9 84 f6 ff ff       	jmp    80105dd7 <alltraps>

80106753 <vector133>:
.globl vector133
vector133:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $133
80106755:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010675a:	e9 78 f6 ff ff       	jmp    80105dd7 <alltraps>

8010675f <vector134>:
.globl vector134
vector134:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $134
80106761:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106766:	e9 6c f6 ff ff       	jmp    80105dd7 <alltraps>

8010676b <vector135>:
.globl vector135
vector135:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $135
8010676d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106772:	e9 60 f6 ff ff       	jmp    80105dd7 <alltraps>

80106777 <vector136>:
.globl vector136
vector136:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $136
80106779:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010677e:	e9 54 f6 ff ff       	jmp    80105dd7 <alltraps>

80106783 <vector137>:
.globl vector137
vector137:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $137
80106785:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010678a:	e9 48 f6 ff ff       	jmp    80105dd7 <alltraps>

8010678f <vector138>:
.globl vector138
vector138:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $138
80106791:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106796:	e9 3c f6 ff ff       	jmp    80105dd7 <alltraps>

8010679b <vector139>:
.globl vector139
vector139:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $139
8010679d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067a2:	e9 30 f6 ff ff       	jmp    80105dd7 <alltraps>

801067a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $140
801067a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067ae:	e9 24 f6 ff ff       	jmp    80105dd7 <alltraps>

801067b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $141
801067b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067ba:	e9 18 f6 ff ff       	jmp    80105dd7 <alltraps>

801067bf <vector142>:
.globl vector142
vector142:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $142
801067c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067c6:	e9 0c f6 ff ff       	jmp    80105dd7 <alltraps>

801067cb <vector143>:
.globl vector143
vector143:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $143
801067cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067d2:	e9 00 f6 ff ff       	jmp    80105dd7 <alltraps>

801067d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $144
801067d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067de:	e9 f4 f5 ff ff       	jmp    80105dd7 <alltraps>

801067e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $145
801067e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ea:	e9 e8 f5 ff ff       	jmp    80105dd7 <alltraps>

801067ef <vector146>:
.globl vector146
vector146:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $146
801067f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067f6:	e9 dc f5 ff ff       	jmp    80105dd7 <alltraps>

801067fb <vector147>:
.globl vector147
vector147:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $147
801067fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106802:	e9 d0 f5 ff ff       	jmp    80105dd7 <alltraps>

80106807 <vector148>:
.globl vector148
vector148:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $148
80106809:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010680e:	e9 c4 f5 ff ff       	jmp    80105dd7 <alltraps>

80106813 <vector149>:
.globl vector149
vector149:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $149
80106815:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010681a:	e9 b8 f5 ff ff       	jmp    80105dd7 <alltraps>

8010681f <vector150>:
.globl vector150
vector150:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $150
80106821:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106826:	e9 ac f5 ff ff       	jmp    80105dd7 <alltraps>

8010682b <vector151>:
.globl vector151
vector151:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $151
8010682d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106832:	e9 a0 f5 ff ff       	jmp    80105dd7 <alltraps>

80106837 <vector152>:
.globl vector152
vector152:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $152
80106839:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010683e:	e9 94 f5 ff ff       	jmp    80105dd7 <alltraps>

80106843 <vector153>:
.globl vector153
vector153:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $153
80106845:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010684a:	e9 88 f5 ff ff       	jmp    80105dd7 <alltraps>

8010684f <vector154>:
.globl vector154
vector154:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $154
80106851:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106856:	e9 7c f5 ff ff       	jmp    80105dd7 <alltraps>

8010685b <vector155>:
.globl vector155
vector155:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $155
8010685d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106862:	e9 70 f5 ff ff       	jmp    80105dd7 <alltraps>

80106867 <vector156>:
.globl vector156
vector156:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $156
80106869:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010686e:	e9 64 f5 ff ff       	jmp    80105dd7 <alltraps>

80106873 <vector157>:
.globl vector157
vector157:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $157
80106875:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010687a:	e9 58 f5 ff ff       	jmp    80105dd7 <alltraps>

8010687f <vector158>:
.globl vector158
vector158:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $158
80106881:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106886:	e9 4c f5 ff ff       	jmp    80105dd7 <alltraps>

8010688b <vector159>:
.globl vector159
vector159:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $159
8010688d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106892:	e9 40 f5 ff ff       	jmp    80105dd7 <alltraps>

80106897 <vector160>:
.globl vector160
vector160:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $160
80106899:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010689e:	e9 34 f5 ff ff       	jmp    80105dd7 <alltraps>

801068a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $161
801068a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068aa:	e9 28 f5 ff ff       	jmp    80105dd7 <alltraps>

801068af <vector162>:
.globl vector162
vector162:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $162
801068b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068b6:	e9 1c f5 ff ff       	jmp    80105dd7 <alltraps>

801068bb <vector163>:
.globl vector163
vector163:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $163
801068bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068c2:	e9 10 f5 ff ff       	jmp    80105dd7 <alltraps>

801068c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $164
801068c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068ce:	e9 04 f5 ff ff       	jmp    80105dd7 <alltraps>

801068d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $165
801068d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068da:	e9 f8 f4 ff ff       	jmp    80105dd7 <alltraps>

801068df <vector166>:
.globl vector166
vector166:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $166
801068e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068e6:	e9 ec f4 ff ff       	jmp    80105dd7 <alltraps>

801068eb <vector167>:
.globl vector167
vector167:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $167
801068ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068f2:	e9 e0 f4 ff ff       	jmp    80105dd7 <alltraps>

801068f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $168
801068f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068fe:	e9 d4 f4 ff ff       	jmp    80105dd7 <alltraps>

80106903 <vector169>:
.globl vector169
vector169:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $169
80106905:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010690a:	e9 c8 f4 ff ff       	jmp    80105dd7 <alltraps>

8010690f <vector170>:
.globl vector170
vector170:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $170
80106911:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106916:	e9 bc f4 ff ff       	jmp    80105dd7 <alltraps>

8010691b <vector171>:
.globl vector171
vector171:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $171
8010691d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106922:	e9 b0 f4 ff ff       	jmp    80105dd7 <alltraps>

80106927 <vector172>:
.globl vector172
vector172:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $172
80106929:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010692e:	e9 a4 f4 ff ff       	jmp    80105dd7 <alltraps>

80106933 <vector173>:
.globl vector173
vector173:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $173
80106935:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010693a:	e9 98 f4 ff ff       	jmp    80105dd7 <alltraps>

8010693f <vector174>:
.globl vector174
vector174:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $174
80106941:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106946:	e9 8c f4 ff ff       	jmp    80105dd7 <alltraps>

8010694b <vector175>:
.globl vector175
vector175:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $175
8010694d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106952:	e9 80 f4 ff ff       	jmp    80105dd7 <alltraps>

80106957 <vector176>:
.globl vector176
vector176:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $176
80106959:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010695e:	e9 74 f4 ff ff       	jmp    80105dd7 <alltraps>

80106963 <vector177>:
.globl vector177
vector177:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $177
80106965:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010696a:	e9 68 f4 ff ff       	jmp    80105dd7 <alltraps>

8010696f <vector178>:
.globl vector178
vector178:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $178
80106971:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106976:	e9 5c f4 ff ff       	jmp    80105dd7 <alltraps>

8010697b <vector179>:
.globl vector179
vector179:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $179
8010697d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106982:	e9 50 f4 ff ff       	jmp    80105dd7 <alltraps>

80106987 <vector180>:
.globl vector180
vector180:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $180
80106989:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010698e:	e9 44 f4 ff ff       	jmp    80105dd7 <alltraps>

80106993 <vector181>:
.globl vector181
vector181:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $181
80106995:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010699a:	e9 38 f4 ff ff       	jmp    80105dd7 <alltraps>

8010699f <vector182>:
.globl vector182
vector182:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $182
801069a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069a6:	e9 2c f4 ff ff       	jmp    80105dd7 <alltraps>

801069ab <vector183>:
.globl vector183
vector183:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $183
801069ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069b2:	e9 20 f4 ff ff       	jmp    80105dd7 <alltraps>

801069b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $184
801069b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069be:	e9 14 f4 ff ff       	jmp    80105dd7 <alltraps>

801069c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $185
801069c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069ca:	e9 08 f4 ff ff       	jmp    80105dd7 <alltraps>

801069cf <vector186>:
.globl vector186
vector186:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $186
801069d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069d6:	e9 fc f3 ff ff       	jmp    80105dd7 <alltraps>

801069db <vector187>:
.globl vector187
vector187:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $187
801069dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069e2:	e9 f0 f3 ff ff       	jmp    80105dd7 <alltraps>

801069e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $188
801069e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069ee:	e9 e4 f3 ff ff       	jmp    80105dd7 <alltraps>

801069f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $189
801069f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069fa:	e9 d8 f3 ff ff       	jmp    80105dd7 <alltraps>

801069ff <vector190>:
.globl vector190
vector190:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $190
80106a01:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a06:	e9 cc f3 ff ff       	jmp    80105dd7 <alltraps>

80106a0b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $191
80106a0d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a12:	e9 c0 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a17 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $192
80106a19:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a1e:	e9 b4 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a23 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $193
80106a25:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a2a:	e9 a8 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a2f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $194
80106a31:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a36:	e9 9c f3 ff ff       	jmp    80105dd7 <alltraps>

80106a3b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $195
80106a3d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a42:	e9 90 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a47 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $196
80106a49:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a4e:	e9 84 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a53 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $197
80106a55:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a5a:	e9 78 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a5f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $198
80106a61:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a66:	e9 6c f3 ff ff       	jmp    80105dd7 <alltraps>

80106a6b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $199
80106a6d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a72:	e9 60 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a77 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $200
80106a79:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a7e:	e9 54 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a83 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $201
80106a85:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a8a:	e9 48 f3 ff ff       	jmp    80105dd7 <alltraps>

80106a8f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $202
80106a91:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a96:	e9 3c f3 ff ff       	jmp    80105dd7 <alltraps>

80106a9b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $203
80106a9d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106aa2:	e9 30 f3 ff ff       	jmp    80105dd7 <alltraps>

80106aa7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $204
80106aa9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106aae:	e9 24 f3 ff ff       	jmp    80105dd7 <alltraps>

80106ab3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $205
80106ab5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106aba:	e9 18 f3 ff ff       	jmp    80105dd7 <alltraps>

80106abf <vector206>:
.globl vector206
vector206:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $206
80106ac1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ac6:	e9 0c f3 ff ff       	jmp    80105dd7 <alltraps>

80106acb <vector207>:
.globl vector207
vector207:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $207
80106acd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ad2:	e9 00 f3 ff ff       	jmp    80105dd7 <alltraps>

80106ad7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $208
80106ad9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ade:	e9 f4 f2 ff ff       	jmp    80105dd7 <alltraps>

80106ae3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $209
80106ae5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aea:	e9 e8 f2 ff ff       	jmp    80105dd7 <alltraps>

80106aef <vector210>:
.globl vector210
vector210:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $210
80106af1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106af6:	e9 dc f2 ff ff       	jmp    80105dd7 <alltraps>

80106afb <vector211>:
.globl vector211
vector211:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $211
80106afd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b02:	e9 d0 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $212
80106b09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b0e:	e9 c4 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $213
80106b15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b1a:	e9 b8 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $214
80106b21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b26:	e9 ac f2 ff ff       	jmp    80105dd7 <alltraps>

80106b2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $215
80106b2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b32:	e9 a0 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $216
80106b39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b3e:	e9 94 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $217
80106b45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b4a:	e9 88 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $218
80106b51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b56:	e9 7c f2 ff ff       	jmp    80105dd7 <alltraps>

80106b5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $219
80106b5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b62:	e9 70 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $220
80106b69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b6e:	e9 64 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $221
80106b75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b7a:	e9 58 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $222
80106b81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b86:	e9 4c f2 ff ff       	jmp    80105dd7 <alltraps>

80106b8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $223
80106b8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b92:	e9 40 f2 ff ff       	jmp    80105dd7 <alltraps>

80106b97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $224
80106b99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b9e:	e9 34 f2 ff ff       	jmp    80105dd7 <alltraps>

80106ba3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $225
80106ba5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106baa:	e9 28 f2 ff ff       	jmp    80105dd7 <alltraps>

80106baf <vector226>:
.globl vector226
vector226:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $226
80106bb1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106bb6:	e9 1c f2 ff ff       	jmp    80105dd7 <alltraps>

80106bbb <vector227>:
.globl vector227
vector227:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $227
80106bbd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106bc2:	e9 10 f2 ff ff       	jmp    80105dd7 <alltraps>

80106bc7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $228
80106bc9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bce:	e9 04 f2 ff ff       	jmp    80105dd7 <alltraps>

80106bd3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $229
80106bd5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bda:	e9 f8 f1 ff ff       	jmp    80105dd7 <alltraps>

80106bdf <vector230>:
.globl vector230
vector230:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $230
80106be1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106be6:	e9 ec f1 ff ff       	jmp    80105dd7 <alltraps>

80106beb <vector231>:
.globl vector231
vector231:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $231
80106bed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bf2:	e9 e0 f1 ff ff       	jmp    80105dd7 <alltraps>

80106bf7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $232
80106bf9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bfe:	e9 d4 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c03 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $233
80106c05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c0a:	e9 c8 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c0f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $234
80106c11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c16:	e9 bc f1 ff ff       	jmp    80105dd7 <alltraps>

80106c1b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $235
80106c1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c22:	e9 b0 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c27 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $236
80106c29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c2e:	e9 a4 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c33 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $237
80106c35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c3a:	e9 98 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c3f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $238
80106c41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c46:	e9 8c f1 ff ff       	jmp    80105dd7 <alltraps>

80106c4b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $239
80106c4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c52:	e9 80 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c57 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $240
80106c59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c5e:	e9 74 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c63 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $241
80106c65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c6a:	e9 68 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c6f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $242
80106c71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c76:	e9 5c f1 ff ff       	jmp    80105dd7 <alltraps>

80106c7b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $243
80106c7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c82:	e9 50 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c87 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $244
80106c89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c8e:	e9 44 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c93 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $245
80106c95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c9a:	e9 38 f1 ff ff       	jmp    80105dd7 <alltraps>

80106c9f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $246
80106ca1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ca6:	e9 2c f1 ff ff       	jmp    80105dd7 <alltraps>

80106cab <vector247>:
.globl vector247
vector247:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $247
80106cad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106cb2:	e9 20 f1 ff ff       	jmp    80105dd7 <alltraps>

80106cb7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $248
80106cb9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cbe:	e9 14 f1 ff ff       	jmp    80105dd7 <alltraps>

80106cc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $249
80106cc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106cca:	e9 08 f1 ff ff       	jmp    80105dd7 <alltraps>

80106ccf <vector250>:
.globl vector250
vector250:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $250
80106cd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106cd6:	e9 fc f0 ff ff       	jmp    80105dd7 <alltraps>

80106cdb <vector251>:
.globl vector251
vector251:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $251
80106cdd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ce2:	e9 f0 f0 ff ff       	jmp    80105dd7 <alltraps>

80106ce7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $252
80106ce9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cee:	e9 e4 f0 ff ff       	jmp    80105dd7 <alltraps>

80106cf3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $253
80106cf5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cfa:	e9 d8 f0 ff ff       	jmp    80105dd7 <alltraps>

80106cff <vector254>:
.globl vector254
vector254:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $254
80106d01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d06:	e9 cc f0 ff ff       	jmp    80105dd7 <alltraps>

80106d0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $255
80106d0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d12:	e9 c0 f0 ff ff       	jmp    80105dd7 <alltraps>
80106d17:	66 90                	xchg   %ax,%ax
80106d19:	66 90                	xchg   %ax,%ax
80106d1b:	66 90                	xchg   %ax,%ax
80106d1d:	66 90                	xchg   %ax,%ax
80106d1f:	90                   	nop

80106d20 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106d28:	c1 ea 16             	shr    $0x16,%edx
80106d2b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d2e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106d31:	8b 07                	mov    (%edi),%eax
80106d33:	a8 01                	test   $0x1,%al
80106d35:	74 29                	je     80106d60 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d3c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d45:	c1 eb 0a             	shr    $0xa,%ebx
80106d48:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106d4e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106d51:	5b                   	pop    %ebx
80106d52:	5e                   	pop    %esi
80106d53:	5f                   	pop    %edi
80106d54:	5d                   	pop    %ebp
80106d55:	c3                   	ret    
80106d56:	8d 76 00             	lea    0x0(%esi),%esi
80106d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106d60:	85 c9                	test   %ecx,%ecx
80106d62:	74 2c                	je     80106d90 <walkpgdir+0x70>
80106d64:	e8 27 b7 ff ff       	call   80102490 <kalloc>
80106d69:	85 c0                	test   %eax,%eax
80106d6b:	89 c6                	mov    %eax,%esi
80106d6d:	74 21                	je     80106d90 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106d6f:	83 ec 04             	sub    $0x4,%esp
80106d72:	68 00 10 00 00       	push   $0x1000
80106d77:	6a 00                	push   $0x0
80106d79:	50                   	push   %eax
80106d7a:	e8 61 dc ff ff       	call   801049e0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106d7f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d85:	83 c4 10             	add    $0x10,%esp
80106d88:	83 c8 07             	or     $0x7,%eax
80106d8b:	89 07                	mov    %eax,(%edi)
80106d8d:	eb b3                	jmp    80106d42 <walkpgdir+0x22>
80106d8f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106d93:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106d95:	5b                   	pop    %ebx
80106d96:	5e                   	pop    %esi
80106d97:	5f                   	pop    %edi
80106d98:	5d                   	pop    %ebp
80106d99:	c3                   	ret    
80106d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106da0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106da6:	89 d3                	mov    %edx,%ebx
80106da8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106dae:	83 ec 1c             	sub    $0x1c,%esp
80106db1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106db4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106db8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106dbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dc6:	29 df                	sub    %ebx,%edi
80106dc8:	83 c8 01             	or     $0x1,%eax
80106dcb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106dce:	eb 15                	jmp    80106de5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106dd0:	f6 00 01             	testb  $0x1,(%eax)
80106dd3:	75 45                	jne    80106e1a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106dd5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106dd8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ddb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106ddd:	74 31                	je     80106e10 <mappages+0x70>
      break;
    a += PGSIZE;
80106ddf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106de8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106ded:	89 da                	mov    %ebx,%edx
80106def:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106df2:	e8 29 ff ff ff       	call   80106d20 <walkpgdir>
80106df7:	85 c0                	test   %eax,%eax
80106df9:	75 d5                	jne    80106dd0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106dfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106e03:	5b                   	pop    %ebx
80106e04:	5e                   	pop    %esi
80106e05:	5f                   	pop    %edi
80106e06:	5d                   	pop    %ebp
80106e07:	c3                   	ret    
80106e08:	90                   	nop
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106e13:	31 c0                	xor    %eax,%eax
}
80106e15:	5b                   	pop    %ebx
80106e16:	5e                   	pop    %esi
80106e17:	5f                   	pop    %edi
80106e18:	5d                   	pop    %ebp
80106e19:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106e1a:	83 ec 0c             	sub    $0xc,%esp
80106e1d:	68 80 7f 10 80       	push   $0x80107f80
80106e22:	e8 49 95 ff ff       	call   80100370 <panic>
80106e27:	89 f6                	mov    %esi,%esi
80106e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e30 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e36:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e3c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e3e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e44:	83 ec 1c             	sub    $0x1c,%esp
80106e47:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e4a:	39 d3                	cmp    %edx,%ebx
80106e4c:	73 66                	jae    80106eb4 <deallocuvm.part.0+0x84>
80106e4e:	89 d6                	mov    %edx,%esi
80106e50:	eb 3d                	jmp    80106e8f <deallocuvm.part.0+0x5f>
80106e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106e58:	8b 10                	mov    (%eax),%edx
80106e5a:	f6 c2 01             	test   $0x1,%dl
80106e5d:	74 26                	je     80106e85 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106e5f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106e65:	74 58                	je     80106ebf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106e67:	83 ec 0c             	sub    $0xc,%esp
80106e6a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106e70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e73:	52                   	push   %edx
80106e74:	e8 67 b4 ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e7c:	83 c4 10             	add    $0x10,%esp
80106e7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106e85:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e8b:	39 f3                	cmp    %esi,%ebx
80106e8d:	73 25                	jae    80106eb4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106e8f:	31 c9                	xor    %ecx,%ecx
80106e91:	89 da                	mov    %ebx,%edx
80106e93:	89 f8                	mov    %edi,%eax
80106e95:	e8 86 fe ff ff       	call   80106d20 <walkpgdir>
    if(!pte)
80106e9a:	85 c0                	test   %eax,%eax
80106e9c:	75 ba                	jne    80106e58 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e9e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ea4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106eaa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eb0:	39 f3                	cmp    %esi,%ebx
80106eb2:	72 db                	jb     80106e8f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106eb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eba:	5b                   	pop    %ebx
80106ebb:	5e                   	pop    %esi
80106ebc:	5f                   	pop    %edi
80106ebd:	5d                   	pop    %ebp
80106ebe:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106ebf:	83 ec 0c             	sub    $0xc,%esp
80106ec2:	68 06 79 10 80       	push   $0x80107906
80106ec7:	e8 a4 94 ff ff       	call   80100370 <panic>
80106ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ed0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106ed6:	e8 b5 c8 ff ff       	call   80103790 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106edb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ee1:	31 c9                	xor    %ecx,%ecx
80106ee3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ee8:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
80106eef:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106ef6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106efb:	31 c9                	xor    %ecx,%ecx
80106efd:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f04:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f09:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f10:	31 c9                	xor    %ecx,%ecx
80106f12:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106f19:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f20:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106f25:	31 c9                	xor    %ecx,%ecx
80106f27:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f2e:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106f35:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f3a:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106f41:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106f48:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f4f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80106f56:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
80106f5d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80106f64:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f6b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80106f72:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80106f79:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80106f80:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f87:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
80106f8e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80106f95:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
80106f9c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80106fa3:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106faa:	05 f0 37 11 80       	add    $0x801137f0,%eax
80106faf:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106fb3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fb7:	c1 e8 10             	shr    $0x10,%eax
80106fba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106fbe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fc1:	0f 01 10             	lgdtl  (%eax)
}
80106fc4:	c9                   	leave  
80106fc5:	c3                   	ret    
80106fc6:	8d 76 00             	lea    0x0(%esi),%esi
80106fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fd0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fd0:	a1 a4 6a 11 80       	mov    0x80116aa4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106fd5:	55                   	push   %ebp
80106fd6:	89 e5                	mov    %esp,%ebp
80106fd8:	05 00 00 00 80       	add    $0x80000000,%eax
80106fdd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106fe0:	5d                   	pop    %ebp
80106fe1:	c3                   	ret    
80106fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ff0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ffc:	85 f6                	test   %esi,%esi
80106ffe:	0f 84 cd 00 00 00    	je     801070d1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107004:	8b 46 08             	mov    0x8(%esi),%eax
80107007:	85 c0                	test   %eax,%eax
80107009:	0f 84 dc 00 00 00    	je     801070eb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010700f:	8b 7e 04             	mov    0x4(%esi),%edi
80107012:	85 ff                	test   %edi,%edi
80107014:	0f 84 c4 00 00 00    	je     801070de <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010701a:	e8 11 d8 ff ff       	call   80104830 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010701f:	e8 ec c6 ff ff       	call   80103710 <mycpu>
80107024:	89 c3                	mov    %eax,%ebx
80107026:	e8 e5 c6 ff ff       	call   80103710 <mycpu>
8010702b:	89 c7                	mov    %eax,%edi
8010702d:	e8 de c6 ff ff       	call   80103710 <mycpu>
80107032:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107035:	83 c7 08             	add    $0x8,%edi
80107038:	e8 d3 c6 ff ff       	call   80103710 <mycpu>
8010703d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107040:	83 c0 08             	add    $0x8,%eax
80107043:	ba 67 00 00 00       	mov    $0x67,%edx
80107048:	c1 e8 18             	shr    $0x18,%eax
8010704b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107052:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107059:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107060:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107067:	83 c1 08             	add    $0x8,%ecx
8010706a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107070:	c1 e9 10             	shr    $0x10,%ecx
80107073:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107079:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010707e:	e8 8d c6 ff ff       	call   80103710 <mycpu>
80107083:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010708a:	e8 81 c6 ff ff       	call   80103710 <mycpu>
8010708f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107094:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107098:	e8 73 c6 ff ff       	call   80103710 <mycpu>
8010709d:	8b 56 08             	mov    0x8(%esi),%edx
801070a0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801070a6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070a9:	e8 62 c6 ff ff       	call   80103710 <mycpu>
801070ae:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801070b2:	b8 28 00 00 00       	mov    $0x28,%eax
801070b7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070ba:	8b 46 04             	mov    0x4(%esi),%eax
801070bd:	05 00 00 00 80       	add    $0x80000000,%eax
801070c2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801070c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c8:	5b                   	pop    %ebx
801070c9:	5e                   	pop    %esi
801070ca:	5f                   	pop    %edi
801070cb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801070cc:	e9 4f d8 ff ff       	jmp    80104920 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801070d1:	83 ec 0c             	sub    $0xc,%esp
801070d4:	68 86 7f 10 80       	push   $0x80107f86
801070d9:	e8 92 92 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801070de:	83 ec 0c             	sub    $0xc,%esp
801070e1:	68 b1 7f 10 80       	push   $0x80107fb1
801070e6:	e8 85 92 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801070eb:	83 ec 0c             	sub    $0xc,%esp
801070ee:	68 9c 7f 10 80       	push   $0x80107f9c
801070f3:	e8 78 92 ff ff       	call   80100370 <panic>
801070f8:	90                   	nop
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107100 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	56                   	push   %esi
80107105:	53                   	push   %ebx
80107106:	83 ec 1c             	sub    $0x1c,%esp
80107109:	8b 75 10             	mov    0x10(%ebp),%esi
8010710c:	8b 45 08             	mov    0x8(%ebp),%eax
8010710f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107112:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107118:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010711b:	77 49                	ja     80107166 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010711d:	e8 6e b3 ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80107122:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107125:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107127:	68 00 10 00 00       	push   $0x1000
8010712c:	6a 00                	push   $0x0
8010712e:	50                   	push   %eax
8010712f:	e8 ac d8 ff ff       	call   801049e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107134:	58                   	pop    %eax
80107135:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010713b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107140:	5a                   	pop    %edx
80107141:	6a 06                	push   $0x6
80107143:	50                   	push   %eax
80107144:	31 d2                	xor    %edx,%edx
80107146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107149:	e8 52 fc ff ff       	call   80106da0 <mappages>
  memmove(mem, init, sz);
8010714e:	89 75 10             	mov    %esi,0x10(%ebp)
80107151:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107154:	83 c4 10             	add    $0x10,%esp
80107157:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010715a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010715d:	5b                   	pop    %ebx
8010715e:	5e                   	pop    %esi
8010715f:	5f                   	pop    %edi
80107160:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107161:	e9 2a d9 ff ff       	jmp    80104a90 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107166:	83 ec 0c             	sub    $0xc,%esp
80107169:	68 c5 7f 10 80       	push   $0x80107fc5
8010716e:	e8 fd 91 ff ff       	call   80100370 <panic>
80107173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107189:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107190:	0f 85 91 00 00 00    	jne    80107227 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107196:	8b 75 18             	mov    0x18(%ebp),%esi
80107199:	31 db                	xor    %ebx,%ebx
8010719b:	85 f6                	test   %esi,%esi
8010719d:	75 1a                	jne    801071b9 <loaduvm+0x39>
8010719f:	eb 6f                	jmp    80107210 <loaduvm+0x90>
801071a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801071b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801071b7:	76 57                	jbe    80107210 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801071bc:	8b 45 08             	mov    0x8(%ebp),%eax
801071bf:	31 c9                	xor    %ecx,%ecx
801071c1:	01 da                	add    %ebx,%edx
801071c3:	e8 58 fb ff ff       	call   80106d20 <walkpgdir>
801071c8:	85 c0                	test   %eax,%eax
801071ca:	74 4e                	je     8010721a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801071cc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801071d1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801071d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071e1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071e4:	01 d9                	add    %ebx,%ecx
801071e6:	05 00 00 00 80       	add    $0x80000000,%eax
801071eb:	57                   	push   %edi
801071ec:	51                   	push   %ecx
801071ed:	50                   	push   %eax
801071ee:	ff 75 10             	pushl  0x10(%ebp)
801071f1:	e8 5a a7 ff ff       	call   80101950 <readi>
801071f6:	83 c4 10             	add    $0x10,%esp
801071f9:	39 c7                	cmp    %eax,%edi
801071fb:	74 ab                	je     801071a8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801071fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107210:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107213:	31 c0                	xor    %eax,%eax
}
80107215:	5b                   	pop    %ebx
80107216:	5e                   	pop    %esi
80107217:	5f                   	pop    %edi
80107218:	5d                   	pop    %ebp
80107219:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010721a:	83 ec 0c             	sub    $0xc,%esp
8010721d:	68 df 7f 10 80       	push   $0x80107fdf
80107222:	e8 49 91 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107227:	83 ec 0c             	sub    $0xc,%esp
8010722a:	68 80 80 10 80       	push   $0x80108080
8010722f:	e8 3c 91 ff ff       	call   80100370 <panic>
80107234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010723a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107240 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	53                   	push   %ebx
80107246:	83 ec 0c             	sub    $0xc,%esp
80107249:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010724c:	85 ff                	test   %edi,%edi
8010724e:	0f 88 ca 00 00 00    	js     8010731e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107254:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107257:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010725a:	0f 82 82 00 00 00    	jb     801072e2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107260:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107266:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010726c:	39 df                	cmp    %ebx,%edi
8010726e:	77 43                	ja     801072b3 <allocuvm+0x73>
80107270:	e9 bb 00 00 00       	jmp    80107330 <allocuvm+0xf0>
80107275:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107278:	83 ec 04             	sub    $0x4,%esp
8010727b:	68 00 10 00 00       	push   $0x1000
80107280:	6a 00                	push   $0x0
80107282:	50                   	push   %eax
80107283:	e8 58 d7 ff ff       	call   801049e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107288:	58                   	pop    %eax
80107289:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010728f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107294:	5a                   	pop    %edx
80107295:	6a 06                	push   $0x6
80107297:	50                   	push   %eax
80107298:	89 da                	mov    %ebx,%edx
8010729a:	8b 45 08             	mov    0x8(%ebp),%eax
8010729d:	e8 fe fa ff ff       	call   80106da0 <mappages>
801072a2:	83 c4 10             	add    $0x10,%esp
801072a5:	85 c0                	test   %eax,%eax
801072a7:	78 47                	js     801072f0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801072a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072af:	39 df                	cmp    %ebx,%edi
801072b1:	76 7d                	jbe    80107330 <allocuvm+0xf0>
    mem = kalloc();
801072b3:	e8 d8 b1 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
801072b8:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801072ba:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801072bc:	75 ba                	jne    80107278 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
801072be:	83 ec 0c             	sub    $0xc,%esp
801072c1:	68 fd 7f 10 80       	push   $0x80107ffd
801072c6:	e8 95 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801072cb:	83 c4 10             	add    $0x10,%esp
801072ce:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801072d1:	76 4b                	jbe    8010731e <allocuvm+0xde>
801072d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072d6:	8b 45 08             	mov    0x8(%ebp),%eax
801072d9:	89 fa                	mov    %edi,%edx
801072db:	e8 50 fb ff ff       	call   80106e30 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801072e0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801072e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e5:	5b                   	pop    %ebx
801072e6:	5e                   	pop    %esi
801072e7:	5f                   	pop    %edi
801072e8:	5d                   	pop    %ebp
801072e9:	c3                   	ret    
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801072f0:	83 ec 0c             	sub    $0xc,%esp
801072f3:	68 15 80 10 80       	push   $0x80108015
801072f8:	e8 63 93 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801072fd:	83 c4 10             	add    $0x10,%esp
80107300:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107303:	76 0d                	jbe    80107312 <allocuvm+0xd2>
80107305:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107308:	8b 45 08             	mov    0x8(%ebp),%eax
8010730b:	89 fa                	mov    %edi,%edx
8010730d:	e8 1e fb ff ff       	call   80106e30 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107312:	83 ec 0c             	sub    $0xc,%esp
80107315:	56                   	push   %esi
80107316:	e8 c5 af ff ff       	call   801022e0 <kfree>
      return 0;
8010731b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
8010731e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107321:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80107323:	5b                   	pop    %ebx
80107324:	5e                   	pop    %esi
80107325:	5f                   	pop    %edi
80107326:	5d                   	pop    %ebp
80107327:	c3                   	ret    
80107328:	90                   	nop
80107329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107330:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107333:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80107335:	5b                   	pop    %ebx
80107336:	5e                   	pop    %esi
80107337:	5f                   	pop    %edi
80107338:	5d                   	pop    %ebp
80107339:	c3                   	ret    
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107340 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	8b 55 0c             	mov    0xc(%ebp),%edx
80107346:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107349:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010734c:	39 d1                	cmp    %edx,%ecx
8010734e:	73 10                	jae    80107360 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107350:	5d                   	pop    %ebp
80107351:	e9 da fa ff ff       	jmp    80106e30 <deallocuvm.part.0>
80107356:	8d 76 00             	lea    0x0(%esi),%esi
80107359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107360:	89 d0                	mov    %edx,%eax
80107362:	5d                   	pop    %ebp
80107363:	c3                   	ret    
80107364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010736a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107370 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107370:	55                   	push   %ebp
80107371:	89 e5                	mov    %esp,%ebp
80107373:	57                   	push   %edi
80107374:	56                   	push   %esi
80107375:	53                   	push   %ebx
80107376:	83 ec 0c             	sub    $0xc,%esp
80107379:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010737c:	85 f6                	test   %esi,%esi
8010737e:	74 59                	je     801073d9 <freevm+0x69>
80107380:	31 c9                	xor    %ecx,%ecx
80107382:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107387:	89 f0                	mov    %esi,%eax
80107389:	e8 a2 fa ff ff       	call   80106e30 <deallocuvm.part.0>
8010738e:	89 f3                	mov    %esi,%ebx
80107390:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107396:	eb 0f                	jmp    801073a7 <freevm+0x37>
80107398:	90                   	nop
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073a0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801073a3:	39 fb                	cmp    %edi,%ebx
801073a5:	74 23                	je     801073ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801073a7:	8b 03                	mov    (%ebx),%eax
801073a9:	a8 01                	test   $0x1,%al
801073ab:	74 f3                	je     801073a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801073ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073b2:	83 ec 0c             	sub    $0xc,%esp
801073b5:	83 c3 04             	add    $0x4,%ebx
801073b8:	05 00 00 00 80       	add    $0x80000000,%eax
801073bd:	50                   	push   %eax
801073be:	e8 1d af ff ff       	call   801022e0 <kfree>
801073c3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801073c6:	39 fb                	cmp    %edi,%ebx
801073c8:	75 dd                	jne    801073a7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801073ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d0:	5b                   	pop    %ebx
801073d1:	5e                   	pop    %esi
801073d2:	5f                   	pop    %edi
801073d3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801073d4:	e9 07 af ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801073d9:	83 ec 0c             	sub    $0xc,%esp
801073dc:	68 31 80 10 80       	push   $0x80108031
801073e1:	e8 8a 8f ff ff       	call   80100370 <panic>
801073e6:	8d 76 00             	lea    0x0(%esi),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	56                   	push   %esi
801073f4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801073f5:	e8 96 b0 ff ff       	call   80102490 <kalloc>
801073fa:	85 c0                	test   %eax,%eax
801073fc:	74 6a                	je     80107468 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801073fe:	83 ec 04             	sub    $0x4,%esp
80107401:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107403:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107408:	68 00 10 00 00       	push   $0x1000
8010740d:	6a 00                	push   $0x0
8010740f:	50                   	push   %eax
80107410:	e8 cb d5 ff ff       	call   801049e0 <memset>
80107415:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107418:	8b 43 04             	mov    0x4(%ebx),%eax
8010741b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010741e:	83 ec 08             	sub    $0x8,%esp
80107421:	8b 13                	mov    (%ebx),%edx
80107423:	ff 73 0c             	pushl  0xc(%ebx)
80107426:	50                   	push   %eax
80107427:	29 c1                	sub    %eax,%ecx
80107429:	89 f0                	mov    %esi,%eax
8010742b:	e8 70 f9 ff ff       	call   80106da0 <mappages>
80107430:	83 c4 10             	add    $0x10,%esp
80107433:	85 c0                	test   %eax,%eax
80107435:	78 19                	js     80107450 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107437:	83 c3 10             	add    $0x10,%ebx
8010743a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107440:	75 d6                	jne    80107418 <setupkvm+0x28>
80107442:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107444:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107447:	5b                   	pop    %ebx
80107448:	5e                   	pop    %esi
80107449:	5d                   	pop    %ebp
8010744a:	c3                   	ret    
8010744b:	90                   	nop
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107450:	83 ec 0c             	sub    $0xc,%esp
80107453:	56                   	push   %esi
80107454:	e8 17 ff ff ff       	call   80107370 <freevm>
      return 0;
80107459:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010745c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010745f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107461:	5b                   	pop    %ebx
80107462:	5e                   	pop    %esi
80107463:	5d                   	pop    %ebp
80107464:	c3                   	ret    
80107465:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107468:	31 c0                	xor    %eax,%eax
8010746a:	eb d8                	jmp    80107444 <setupkvm+0x54>
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107470 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107476:	e8 75 ff ff ff       	call   801073f0 <setupkvm>
8010747b:	a3 a4 6a 11 80       	mov    %eax,0x80116aa4
80107480:	05 00 00 00 80       	add    $0x80000000,%eax
80107485:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107488:	c9                   	leave  
80107489:	c3                   	ret    
8010748a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107490 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107490:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107491:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107493:	89 e5                	mov    %esp,%ebp
80107495:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107498:	8b 55 0c             	mov    0xc(%ebp),%edx
8010749b:	8b 45 08             	mov    0x8(%ebp),%eax
8010749e:	e8 7d f8 ff ff       	call   80106d20 <walkpgdir>
  if(pte == 0)
801074a3:	85 c0                	test   %eax,%eax
801074a5:	74 05                	je     801074ac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801074a7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074aa:	c9                   	leave  
801074ab:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801074ac:	83 ec 0c             	sub    $0xc,%esp
801074af:	68 42 80 10 80       	push   $0x80108042
801074b4:	e8 b7 8e ff ff       	call   80100370 <panic>
801074b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074c9:	e8 22 ff ff ff       	call   801073f0 <setupkvm>
801074ce:	85 c0                	test   %eax,%eax
801074d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074d3:	0f 84 b2 00 00 00    	je     8010758b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074dc:	85 c9                	test   %ecx,%ecx
801074de:	0f 84 9c 00 00 00    	je     80107580 <copyuvm+0xc0>
801074e4:	31 f6                	xor    %esi,%esi
801074e6:	eb 4a                	jmp    80107532 <copyuvm+0x72>
801074e8:	90                   	nop
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801074f0:	83 ec 04             	sub    $0x4,%esp
801074f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801074f9:	68 00 10 00 00       	push   $0x1000
801074fe:	57                   	push   %edi
801074ff:	50                   	push   %eax
80107500:	e8 8b d5 ff ff       	call   80104a90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107505:	58                   	pop    %eax
80107506:	5a                   	pop    %edx
80107507:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010750d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107510:	ff 75 e4             	pushl  -0x1c(%ebp)
80107513:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107518:	52                   	push   %edx
80107519:	89 f2                	mov    %esi,%edx
8010751b:	e8 80 f8 ff ff       	call   80106da0 <mappages>
80107520:	83 c4 10             	add    $0x10,%esp
80107523:	85 c0                	test   %eax,%eax
80107525:	78 3e                	js     80107565 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107527:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010752d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107530:	76 4e                	jbe    80107580 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107532:	8b 45 08             	mov    0x8(%ebp),%eax
80107535:	31 c9                	xor    %ecx,%ecx
80107537:	89 f2                	mov    %esi,%edx
80107539:	e8 e2 f7 ff ff       	call   80106d20 <walkpgdir>
8010753e:	85 c0                	test   %eax,%eax
80107540:	74 5a                	je     8010759c <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107542:	8b 18                	mov    (%eax),%ebx
80107544:	f6 c3 01             	test   $0x1,%bl
80107547:	74 46                	je     8010758f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107549:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010754b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107551:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107554:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010755a:	e8 31 af ff ff       	call   80102490 <kalloc>
8010755f:	85 c0                	test   %eax,%eax
80107561:	89 c3                	mov    %eax,%ebx
80107563:	75 8b                	jne    801074f0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107565:	83 ec 0c             	sub    $0xc,%esp
80107568:	ff 75 e0             	pushl  -0x20(%ebp)
8010756b:	e8 00 fe ff ff       	call   80107370 <freevm>
  return 0;
80107570:	83 c4 10             	add    $0x10,%esp
80107573:	31 c0                	xor    %eax,%eax
}
80107575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107578:	5b                   	pop    %ebx
80107579:	5e                   	pop    %esi
8010757a:	5f                   	pop    %edi
8010757b:	5d                   	pop    %ebp
8010757c:	c3                   	ret    
8010757d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107580:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107583:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107586:	5b                   	pop    %ebx
80107587:	5e                   	pop    %esi
80107588:	5f                   	pop    %edi
80107589:	5d                   	pop    %ebp
8010758a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010758b:	31 c0                	xor    %eax,%eax
8010758d:	eb e6                	jmp    80107575 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
8010758f:	83 ec 0c             	sub    $0xc,%esp
80107592:	68 66 80 10 80       	push   $0x80108066
80107597:	e8 d4 8d ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010759c:	83 ec 0c             	sub    $0xc,%esp
8010759f:	68 4c 80 10 80       	push   $0x8010804c
801075a4:	e8 c7 8d ff ff       	call   80100370 <panic>
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075b1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075b3:	89 e5                	mov    %esp,%ebp
801075b5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075bb:	8b 45 08             	mov    0x8(%ebp),%eax
801075be:	e8 5d f7 ff ff       	call   80106d20 <walkpgdir>
  if((*pte & PTE_P) == 0)
801075c3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801075c5:	89 c2                	mov    %eax,%edx
801075c7:	83 e2 05             	and    $0x5,%edx
801075ca:	83 fa 05             	cmp    $0x5,%edx
801075cd:	75 11                	jne    801075e0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801075cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801075d4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801075d5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801075da:	c3                   	ret    
801075db:	90                   	nop
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801075e0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801075e2:	c9                   	leave  
801075e3:	c3                   	ret    
801075e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801075f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	57                   	push   %edi
801075f4:	56                   	push   %esi
801075f5:	53                   	push   %ebx
801075f6:	83 ec 1c             	sub    $0x1c,%esp
801075f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801075fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801075ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107602:	85 db                	test   %ebx,%ebx
80107604:	75 40                	jne    80107646 <copyout+0x56>
80107606:	eb 70                	jmp    80107678 <copyout+0x88>
80107608:	90                   	nop
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107613:	89 f1                	mov    %esi,%ecx
80107615:	29 d1                	sub    %edx,%ecx
80107617:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010761d:	39 d9                	cmp    %ebx,%ecx
8010761f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107622:	29 f2                	sub    %esi,%edx
80107624:	83 ec 04             	sub    $0x4,%esp
80107627:	01 d0                	add    %edx,%eax
80107629:	51                   	push   %ecx
8010762a:	57                   	push   %edi
8010762b:	50                   	push   %eax
8010762c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010762f:	e8 5c d4 ff ff       	call   80104a90 <memmove>
    len -= n;
    buf += n;
80107634:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107637:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010763a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107640:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107642:	29 cb                	sub    %ecx,%ebx
80107644:	74 32                	je     80107678 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107646:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107648:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010764b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010764e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107654:	56                   	push   %esi
80107655:	ff 75 08             	pushl  0x8(%ebp)
80107658:	e8 53 ff ff ff       	call   801075b0 <uva2ka>
    if(pa0 == 0)
8010765d:	83 c4 10             	add    $0x10,%esp
80107660:	85 c0                	test   %eax,%eax
80107662:	75 ac                	jne    80107610 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107664:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010766c:	5b                   	pop    %ebx
8010766d:	5e                   	pop    %esi
8010766e:	5f                   	pop    %edi
8010766f:	5d                   	pop    %ebp
80107670:	c3                   	ret    
80107671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107678:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010767b:	31 c0                	xor    %eax,%eax
}
8010767d:	5b                   	pop    %ebx
8010767e:	5e                   	pop    %esi
8010767f:	5f                   	pop    %edi
80107680:	5d                   	pop    %ebp
80107681:	c3                   	ret    
