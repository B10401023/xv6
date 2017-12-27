
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  int ctime;
  char name[16];               // Process name
};

int
main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  struct proc ptable[NPROC];
  struct proc *p;
  int err;

  err = getptable(NPROC * sizeof(struct proc), &ptable);
  10:	8d 85 e8 f5 ff ff    	lea    -0xa18(%ebp),%eax
  int ctime;
  char name[16];               // Process name
};

int
main(int argc, char *argv[]){
  16:	81 ec 14 0a 00 00    	sub    $0xa14,%esp
  struct proc ptable[NPROC];
  struct proc *p;
  int err;

  err = getptable(NPROC * sizeof(struct proc), &ptable);
  1c:	50                   	push   %eax
  1d:	68 00 0a 00 00       	push   $0xa00
  22:	e8 9b 04 00 00       	call   4c2 <getptable>
  if (err) {
  27:	83 c4 10             	add    $0x10,%esp
  2a:	85 c0                	test   %eax,%eax
  2c:	74 13                	je     41 <main+0x41>
    printf(1,"Error getting ptable");
  2e:	51                   	push   %ecx
  2f:	51                   	push   %ecx
  30:	68 c0 08 00 00       	push   $0x8c0
  35:	6a 01                	push   $0x1
  37:	e8 64 05 00 00       	call   5a0 <printf>
    exit();
  3c:	e8 e1 03 00 00       	call   422 <exit>
  }

  printf(1, "PID\t\tPPID\t\tSTATE\t\tPRIORITY\tTICKETS\t\tCPUTIME\t\tCMD\n");
  41:	52                   	push   %edx
  42:	52                   	push   %edx
  43:	8d 9d 00 f6 ff ff    	lea    -0xa00(%ebp),%ebx
  49:	68 28 09 00 00       	push   $0x928
  4e:	6a 01                	push   $0x1
  50:	8d 75 d8             	lea    -0x28(%ebp),%esi
  53:	e8 48 05 00 00       	call   5a0 <printf>
  58:	83 c4 10             	add    $0x10,%esp
  5b:	90                   	nop
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable; p != &ptable[NPROC-1]; p++) {
        if (p->state == UNUSED) continue;
  60:	8b 43 e8             	mov    -0x18(%ebx),%eax
  63:	85 c0                	test   %eax,%eax
  65:	0f 84 9e 00 00 00    	je     109 <main+0x109>

	// init does not have ppid!
	if (p->pid == 1)
  6b:	8b 43 ec             	mov    -0x14(%ebx),%eax
  6e:	83 f8 01             	cmp    $0x1,%eax
  71:	0f 84 49 01 00 00    	je     1c0 <main+0x1c0>
	    printf(1, "%d\t\tN/A",p->pid);
	else
	    printf(1, "%d\t\t%d", p->pid, p->ppid);
  77:	ff 73 f0             	pushl  -0x10(%ebx)
  7a:	50                   	push   %eax
  7b:	68 dd 08 00 00       	push   $0x8dd
  80:	6a 01                	push   $0x1
  82:	e8 19 05 00 00       	call   5a0 <printf>
  87:	83 c4 10             	add    $0x10,%esp

  	switch(p->state){
  8a:	83 7b e8 05          	cmpl   $0x5,-0x18(%ebx)
  8e:	77 30                	ja     c0 <main+0xc0>
  90:	8b 43 e8             	mov    -0x18(%ebx),%eax
  93:	ff 24 85 5c 09 00 00 	jmp    *0x95c(,%eax,4)
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  		break;
  	case RUNNABLE:
  		printf(1,"\t\t%s", "RUNNABLE");
  		break;
  	case RUNNING:
  		printf(1,"\t\t%s", "RUNNING ");
  a0:	83 ec 04             	sub    $0x4,%esp
  a3:	68 0d 09 00 00       	push   $0x90d
  a8:	68 ed 08 00 00       	push   $0x8ed
  ad:	6a 01                	push   $0x1
  af:	e8 ec 04 00 00       	call   5a0 <printf>
  		break;
  b4:	83 c4 10             	add    $0x10,%esp
  b7:	89 f6                	mov    %esi,%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  	case ZOMBIE:
  		printf(1,"\t\t%s", "ZOMBIE  ");
  		break;
  	}

    printf(1, "\t%d", p->priority);
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	ff 73 f4             	pushl  -0xc(%ebx)
  c6:	68 e0 08 00 00       	push   $0x8e0
  cb:	6a 01                	push   $0x1
  cd:	e8 ce 04 00 00       	call   5a0 <printf>
    printf(1, "\t\t%d", p->tickets);
  d2:	83 c4 0c             	add    $0xc,%esp
  d5:	ff 73 f8             	pushl  -0x8(%ebx)
  d8:	68 df 08 00 00       	push   $0x8df
  dd:	6a 01                	push   $0x1
  df:	e8 bc 04 00 00       	call   5a0 <printf>
    printf(1, "\t\t%d", p->ctime);
  e4:	83 c4 0c             	add    $0xc,%esp
  e7:	ff 73 fc             	pushl  -0x4(%ebx)
  ea:	68 df 08 00 00       	push   $0x8df
  ef:	6a 01                	push   $0x1
  f1:	e8 aa 04 00 00       	call   5a0 <printf>
  	printf(1,"\t\t%s\n", p->name);
  f6:	83 c4 0c             	add    $0xc,%esp
  f9:	53                   	push   %ebx
  fa:	68 1f 09 00 00       	push   $0x91f
  ff:	6a 01                	push   $0x1
 101:	e8 9a 04 00 00       	call   5a0 <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	83 c3 28             	add    $0x28,%ebx
    printf(1,"Error getting ptable");
    exit();
  }

  printf(1, "PID\t\tPPID\t\tSTATE\t\tPRIORITY\tTICKETS\t\tCPUTIME\t\tCMD\n");
  for(p = ptable; p != &ptable[NPROC-1]; p++) {
 10c:	39 f3                	cmp    %esi,%ebx
 10e:	0f 85 4c ff ff ff    	jne    60 <main+0x60>
    printf(1, "\t%d", p->priority);
    printf(1, "\t\t%d", p->tickets);
    printf(1, "\t\t%d", p->ctime);
  	printf(1,"\t\t%s\n", p->name);
  }
  exit();
 114:	e8 09 03 00 00       	call   422 <exit>
 119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  		break;
  	case RUNNING:
  		printf(1,"\t\t%s", "RUNNING ");
  		break;
  	case ZOMBIE:
  		printf(1,"\t\t%s", "ZOMBIE  ");
 120:	83 ec 04             	sub    $0x4,%esp
 123:	68 16 09 00 00       	push   $0x916
 128:	68 ed 08 00 00       	push   $0x8ed
 12d:	6a 01                	push   $0x1
 12f:	e8 6c 04 00 00       	call   5a0 <printf>
  		break;
 134:	83 c4 10             	add    $0x10,%esp
 137:	eb 87                	jmp    c0 <main+0xc0>
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  		break;
  	case SLEEPING:
  		printf(1,"\t\t%s", "SLEEPING");
  		break;
  	case RUNNABLE:
  		printf(1,"\t\t%s", "RUNNABLE");
 140:	83 ec 04             	sub    $0x4,%esp
 143:	68 04 09 00 00       	push   $0x904
 148:	68 ed 08 00 00       	push   $0x8ed
 14d:	6a 01                	push   $0x1
 14f:	e8 4c 04 00 00       	call   5a0 <printf>
  		break;
 154:	83 c4 10             	add    $0x10,%esp
 157:	e9 64 ff ff ff       	jmp    c0 <main+0xc0>
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  		break;
  	case EMBRYO:
  		printf(1,"\t\t%s", "EMBRYO  ");
  		break;
  	case SLEEPING:
  		printf(1,"\t\t%s", "SLEEPING");
 160:	83 ec 04             	sub    $0x4,%esp
 163:	68 fb 08 00 00       	push   $0x8fb
 168:	68 ed 08 00 00       	push   $0x8ed
 16d:	6a 01                	push   $0x1
 16f:	e8 2c 04 00 00       	call   5a0 <printf>
  		break;
 174:	83 c4 10             	add    $0x10,%esp
 177:	e9 44 ff ff ff       	jmp    c0 <main+0xc0>
 17c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  	switch(p->state){
  	case UNUSED:
  		printf(1,"\t\t%s", "UNUSED  ");
  		break;
  	case EMBRYO:
  		printf(1,"\t\t%s", "EMBRYO  ");
 180:	83 ec 04             	sub    $0x4,%esp
 183:	68 f2 08 00 00       	push   $0x8f2
 188:	68 ed 08 00 00       	push   $0x8ed
 18d:	6a 01                	push   $0x1
 18f:	e8 0c 04 00 00       	call   5a0 <printf>
  		break;
 194:	83 c4 10             	add    $0x10,%esp
 197:	e9 24 ff ff ff       	jmp    c0 <main+0xc0>
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	else
	    printf(1, "%d\t\t%d", p->pid, p->ppid);

  	switch(p->state){
  	case UNUSED:
  		printf(1,"\t\t%s", "UNUSED  ");
 1a0:	83 ec 04             	sub    $0x4,%esp
 1a3:	68 e4 08 00 00       	push   $0x8e4
 1a8:	68 ed 08 00 00       	push   $0x8ed
 1ad:	6a 01                	push   $0x1
 1af:	e8 ec 03 00 00       	call   5a0 <printf>
  		break;
 1b4:	83 c4 10             	add    $0x10,%esp
 1b7:	e9 04 ff ff ff       	jmp    c0 <main+0xc0>
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable; p != &ptable[NPROC-1]; p++) {
        if (p->state == UNUSED) continue;

	// init does not have ppid!
	if (p->pid == 1)
	    printf(1, "%d\t\tN/A",p->pid);
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	6a 01                	push   $0x1
 1c5:	68 d5 08 00 00       	push   $0x8d5
 1ca:	6a 01                	push   $0x1
 1cc:	e8 cf 03 00 00       	call   5a0 <printf>
 1d1:	83 c4 10             	add    $0x10,%esp
 1d4:	e9 b1 fe ff ff       	jmp    8a <main+0x8a>
 1d9:	66 90                	xchg   %ax,%ax
 1db:	66 90                	xchg   %ax,%ax
 1dd:	66 90                	xchg   %ax,%ax
 1df:	90                   	nop

000001e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ea:	89 c2                	mov    %eax,%edx
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f0:	83 c1 01             	add    $0x1,%ecx
 1f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1f7:	83 c2 01             	add    $0x1,%edx
 1fa:	84 db                	test   %bl,%bl
 1fc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1ff:	75 ef                	jne    1f0 <strcpy+0x10>
    ;
  return os;
}
 201:	5b                   	pop    %ebx
 202:	5d                   	pop    %ebp
 203:	c3                   	ret    
 204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 20a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	56                   	push   %esi
 214:	53                   	push   %ebx
 215:	8b 55 08             	mov    0x8(%ebp),%edx
 218:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 21b:	0f b6 02             	movzbl (%edx),%eax
 21e:	0f b6 19             	movzbl (%ecx),%ebx
 221:	84 c0                	test   %al,%al
 223:	75 1e                	jne    243 <strcmp+0x33>
 225:	eb 29                	jmp    250 <strcmp+0x40>
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 230:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 233:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 236:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 239:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 23d:	84 c0                	test   %al,%al
 23f:	74 0f                	je     250 <strcmp+0x40>
 241:	89 f1                	mov    %esi,%ecx
 243:	38 d8                	cmp    %bl,%al
 245:	74 e9                	je     230 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 247:	29 d8                	sub    %ebx,%eax
}
 249:	5b                   	pop    %ebx
 24a:	5e                   	pop    %esi
 24b:	5d                   	pop    %ebp
 24c:	c3                   	ret    
 24d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 250:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 252:	29 d8                	sub    %ebx,%eax
}
 254:	5b                   	pop    %ebx
 255:	5e                   	pop    %esi
 256:	5d                   	pop    %ebp
 257:	c3                   	ret    
 258:	90                   	nop
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000260 <strlen>:

uint
strlen(char *s)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 266:	80 39 00             	cmpb   $0x0,(%ecx)
 269:	74 12                	je     27d <strlen+0x1d>
 26b:	31 d2                	xor    %edx,%edx
 26d:	8d 76 00             	lea    0x0(%esi),%esi
 270:	83 c2 01             	add    $0x1,%edx
 273:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 277:	89 d0                	mov    %edx,%eax
 279:	75 f5                	jne    270 <strlen+0x10>
    ;
  return n;
}
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 27d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 27f:	5d                   	pop    %ebp
 280:	c3                   	ret    
 281:	eb 0d                	jmp    290 <memset>
 283:	90                   	nop
 284:	90                   	nop
 285:	90                   	nop
 286:	90                   	nop
 287:	90                   	nop
 288:	90                   	nop
 289:	90                   	nop
 28a:	90                   	nop
 28b:	90                   	nop
 28c:	90                   	nop
 28d:	90                   	nop
 28e:	90                   	nop
 28f:	90                   	nop

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 297:	8b 4d 10             	mov    0x10(%ebp),%ecx
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	89 d7                	mov    %edx,%edi
 29f:	fc                   	cld    
 2a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2a2:	89 d0                	mov    %edx,%eax
 2a4:	5f                   	pop    %edi
 2a5:	5d                   	pop    %ebp
 2a6:	c3                   	ret    
 2a7:	89 f6                	mov    %esi,%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	84 d2                	test   %dl,%dl
 2bf:	74 1d                	je     2de <strchr+0x2e>
    if(*s == c)
 2c1:	38 d3                	cmp    %dl,%bl
 2c3:	89 d9                	mov    %ebx,%ecx
 2c5:	75 0d                	jne    2d4 <strchr+0x24>
 2c7:	eb 17                	jmp    2e0 <strchr+0x30>
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2d0:	38 ca                	cmp    %cl,%dl
 2d2:	74 0c                	je     2e0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2d4:	83 c0 01             	add    $0x1,%eax
 2d7:	0f b6 10             	movzbl (%eax),%edx
 2da:	84 d2                	test   %dl,%dl
 2dc:	75 f2                	jne    2d0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 2de:	31 c0                	xor    %eax,%eax
}
 2e0:	5b                   	pop    %ebx
 2e1:	5d                   	pop    %ebp
 2e2:	c3                   	ret    
 2e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	56                   	push   %esi
 2f5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f6:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 2f8:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 2fb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2fe:	eb 29                	jmp    329 <gets+0x39>
    cc = read(0, &c, 1);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	6a 01                	push   $0x1
 305:	57                   	push   %edi
 306:	6a 00                	push   $0x0
 308:	e8 2d 01 00 00       	call   43a <read>
    if(cc < 1)
 30d:	83 c4 10             	add    $0x10,%esp
 310:	85 c0                	test   %eax,%eax
 312:	7e 1d                	jle    331 <gets+0x41>
      break;
    buf[i++] = c;
 314:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 318:	8b 55 08             	mov    0x8(%ebp),%edx
 31b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 31d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 31f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 323:	74 1b                	je     340 <gets+0x50>
 325:	3c 0d                	cmp    $0xd,%al
 327:	74 17                	je     340 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 329:	8d 5e 01             	lea    0x1(%esi),%ebx
 32c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 32f:	7c cf                	jl     300 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 338:	8d 65 f4             	lea    -0xc(%ebp),%esp
 33b:	5b                   	pop    %ebx
 33c:	5e                   	pop    %esi
 33d:	5f                   	pop    %edi
 33e:	5d                   	pop    %ebp
 33f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 340:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 343:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 345:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 349:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34c:	5b                   	pop    %ebx
 34d:	5e                   	pop    %esi
 34e:	5f                   	pop    %edi
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    
 351:	eb 0d                	jmp    360 <stat>
 353:	90                   	nop
 354:	90                   	nop
 355:	90                   	nop
 356:	90                   	nop
 357:	90                   	nop
 358:	90                   	nop
 359:	90                   	nop
 35a:	90                   	nop
 35b:	90                   	nop
 35c:	90                   	nop
 35d:	90                   	nop
 35e:	90                   	nop
 35f:	90                   	nop

00000360 <stat>:

int
stat(char *n, struct stat *st)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 365:	83 ec 08             	sub    $0x8,%esp
 368:	6a 00                	push   $0x0
 36a:	ff 75 08             	pushl  0x8(%ebp)
 36d:	e8 f0 00 00 00       	call   462 <open>
  if(fd < 0)
 372:	83 c4 10             	add    $0x10,%esp
 375:	85 c0                	test   %eax,%eax
 377:	78 27                	js     3a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 379:	83 ec 08             	sub    $0x8,%esp
 37c:	ff 75 0c             	pushl  0xc(%ebp)
 37f:	89 c3                	mov    %eax,%ebx
 381:	50                   	push   %eax
 382:	e8 f3 00 00 00       	call   47a <fstat>
 387:	89 c6                	mov    %eax,%esi
  close(fd);
 389:	89 1c 24             	mov    %ebx,(%esp)
 38c:	e8 b9 00 00 00       	call   44a <close>
  return r;
 391:	83 c4 10             	add    $0x10,%esp
 394:	89 f0                	mov    %esi,%eax
}
 396:	8d 65 f8             	lea    -0x8(%ebp),%esp
 399:	5b                   	pop    %ebx
 39a:	5e                   	pop    %esi
 39b:	5d                   	pop    %ebp
 39c:	c3                   	ret    
 39d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 3a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3a5:	eb ef                	jmp    396 <stat+0x36>
 3a7:	89 f6                	mov    %esi,%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	53                   	push   %ebx
 3b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b7:	0f be 11             	movsbl (%ecx),%edx
 3ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 3bd:	3c 09                	cmp    $0x9,%al
 3bf:	b8 00 00 00 00       	mov    $0x0,%eax
 3c4:	77 1f                	ja     3e5 <atoi+0x35>
 3c6:	8d 76 00             	lea    0x0(%esi),%esi
 3c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3d0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3d3:	83 c1 01             	add    $0x1,%ecx
 3d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3da:	0f be 11             	movsbl (%ecx),%edx
 3dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3e0:	80 fb 09             	cmp    $0x9,%bl
 3e3:	76 eb                	jbe    3d0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 3e5:	5b                   	pop    %ebx
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    
 3e8:	90                   	nop
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	56                   	push   %esi
 3f4:	53                   	push   %ebx
 3f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fe:	85 db                	test   %ebx,%ebx
 400:	7e 14                	jle    416 <memmove+0x26>
 402:	31 d2                	xor    %edx,%edx
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 408:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 40c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 40f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 412:	39 da                	cmp    %ebx,%edx
 414:	75 f2                	jne    408 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 416:	5b                   	pop    %ebx
 417:	5e                   	pop    %esi
 418:	5d                   	pop    %ebp
 419:	c3                   	ret    

0000041a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 41a:	b8 01 00 00 00       	mov    $0x1,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <exit>:
SYSCALL(exit)
 422:	b8 02 00 00 00       	mov    $0x2,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <wait>:
SYSCALL(wait)
 42a:	b8 03 00 00 00       	mov    $0x3,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <pipe>:
SYSCALL(pipe)
 432:	b8 04 00 00 00       	mov    $0x4,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <read>:
SYSCALL(read)
 43a:	b8 05 00 00 00       	mov    $0x5,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <write>:
SYSCALL(write)
 442:	b8 10 00 00 00       	mov    $0x10,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <close>:
SYSCALL(close)
 44a:	b8 15 00 00 00       	mov    $0x15,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <kill>:
SYSCALL(kill)
 452:	b8 06 00 00 00       	mov    $0x6,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <exec>:
SYSCALL(exec)
 45a:	b8 07 00 00 00       	mov    $0x7,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <open>:
SYSCALL(open)
 462:	b8 0f 00 00 00       	mov    $0xf,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <mknod>:
SYSCALL(mknod)
 46a:	b8 11 00 00 00       	mov    $0x11,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <unlink>:
SYSCALL(unlink)
 472:	b8 12 00 00 00       	mov    $0x12,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <fstat>:
SYSCALL(fstat)
 47a:	b8 08 00 00 00       	mov    $0x8,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <link>:
SYSCALL(link)
 482:	b8 13 00 00 00       	mov    $0x13,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <mkdir>:
SYSCALL(mkdir)
 48a:	b8 14 00 00 00       	mov    $0x14,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <chdir>:
SYSCALL(chdir)
 492:	b8 09 00 00 00       	mov    $0x9,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <dup>:
SYSCALL(dup)
 49a:	b8 0a 00 00 00       	mov    $0xa,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <getpid>:
SYSCALL(getpid)
 4a2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <sbrk>:
SYSCALL(sbrk)
 4aa:	b8 0c 00 00 00       	mov    $0xc,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <sleep>:
SYSCALL(sleep)
 4b2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <uptime>:
SYSCALL(uptime)
 4ba:	b8 0e 00 00 00       	mov    $0xe,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <getptable>:
SYSCALL(getptable)
 4c2:	b8 16 00 00 00       	mov    $0x16,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <getppid>:
SYSCALL(getppid)
 4ca:	b8 17 00 00 00       	mov    $0x17,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <chpr>:
SYSCALL(chpr)
 4d2:	b8 18 00 00 00       	mov    $0x18,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <wait2>:
SYSCALL(wait2)
 4da:	b8 19 00 00 00       	mov    $0x19,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <yield>:
SYSCALL(yield)
 4e2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <chtickets>:
SYSCALL(chtickets)
 4ea:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    
 4f2:	66 90                	xchg   %ax,%ax
 4f4:	66 90                	xchg   %ax,%ax
 4f6:	66 90                	xchg   %ax,%ax
 4f8:	66 90                	xchg   %ax,%ax
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
 506:	89 c6                	mov    %eax,%esi
 508:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 50b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 50e:	85 db                	test   %ebx,%ebx
 510:	74 7e                	je     590 <printint+0x90>
 512:	89 d0                	mov    %edx,%eax
 514:	c1 e8 1f             	shr    $0x1f,%eax
 517:	84 c0                	test   %al,%al
 519:	74 75                	je     590 <printint+0x90>
    neg = 1;
    x = -xx;
 51b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 51d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 524:	f7 d8                	neg    %eax
 526:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 529:	31 ff                	xor    %edi,%edi
 52b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 52e:	89 ce                	mov    %ecx,%esi
 530:	eb 08                	jmp    53a <printint+0x3a>
 532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 538:	89 cf                	mov    %ecx,%edi
 53a:	31 d2                	xor    %edx,%edx
 53c:	8d 4f 01             	lea    0x1(%edi),%ecx
 53f:	f7 f6                	div    %esi
 541:	0f b6 92 7c 09 00 00 	movzbl 0x97c(%edx),%edx
  }while((x /= base) != 0);
 548:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 54a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 54d:	75 e9                	jne    538 <printint+0x38>
  if(neg)
 54f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 552:	8b 75 c0             	mov    -0x40(%ebp),%esi
 555:	85 c0                	test   %eax,%eax
 557:	74 08                	je     561 <printint+0x61>
    buf[i++] = '-';
 559:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 55e:	8d 4f 02             	lea    0x2(%edi),%ecx
 561:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 565:	8d 76 00             	lea    0x0(%esi),%esi
 568:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56b:	83 ec 04             	sub    $0x4,%esp
 56e:	83 ef 01             	sub    $0x1,%edi
 571:	6a 01                	push   $0x1
 573:	53                   	push   %ebx
 574:	56                   	push   %esi
 575:	88 45 d7             	mov    %al,-0x29(%ebp)
 578:	e8 c5 fe ff ff       	call   442 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 57d:	83 c4 10             	add    $0x10,%esp
 580:	39 df                	cmp    %ebx,%edi
 582:	75 e4                	jne    568 <printint+0x68>
    putc(fd, buf[i]);
}
 584:	8d 65 f4             	lea    -0xc(%ebp),%esp
 587:	5b                   	pop    %ebx
 588:	5e                   	pop    %esi
 589:	5f                   	pop    %edi
 58a:	5d                   	pop    %ebp
 58b:	c3                   	ret    
 58c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 590:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 592:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 599:	eb 8b                	jmp    526 <printint+0x26>
 59b:	90                   	nop
 59c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
 5a5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ac:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5af:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5b5:	0f b6 1e             	movzbl (%esi),%ebx
 5b8:	83 c6 01             	add    $0x1,%esi
 5bb:	84 db                	test   %bl,%bl
 5bd:	0f 84 b0 00 00 00    	je     673 <printf+0xd3>
 5c3:	31 d2                	xor    %edx,%edx
 5c5:	eb 39                	jmp    600 <printf+0x60>
 5c7:	89 f6                	mov    %esi,%esi
 5c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5d0:	83 f8 25             	cmp    $0x25,%eax
 5d3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 5d6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5db:	74 18                	je     5f5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5dd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5e0:	83 ec 04             	sub    $0x4,%esp
 5e3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5e6:	6a 01                	push   $0x1
 5e8:	50                   	push   %eax
 5e9:	57                   	push   %edi
 5ea:	e8 53 fe ff ff       	call   442 <write>
 5ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5f2:	83 c4 10             	add    $0x10,%esp
 5f5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5f8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5fc:	84 db                	test   %bl,%bl
 5fe:	74 73                	je     673 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 600:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 602:	0f be cb             	movsbl %bl,%ecx
 605:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 608:	74 c6                	je     5d0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 60a:	83 fa 25             	cmp    $0x25,%edx
 60d:	75 e6                	jne    5f5 <printf+0x55>
      if(c == 'd'){
 60f:	83 f8 64             	cmp    $0x64,%eax
 612:	0f 84 f8 00 00 00    	je     710 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 618:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 61e:	83 f9 70             	cmp    $0x70,%ecx
 621:	74 5d                	je     680 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 623:	83 f8 73             	cmp    $0x73,%eax
 626:	0f 84 84 00 00 00    	je     6b0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62c:	83 f8 63             	cmp    $0x63,%eax
 62f:	0f 84 ea 00 00 00    	je     71f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 635:	83 f8 25             	cmp    $0x25,%eax
 638:	0f 84 c2 00 00 00    	je     700 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 63e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 641:	83 ec 04             	sub    $0x4,%esp
 644:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 648:	6a 01                	push   $0x1
 64a:	50                   	push   %eax
 64b:	57                   	push   %edi
 64c:	e8 f1 fd ff ff       	call   442 <write>
 651:	83 c4 0c             	add    $0xc,%esp
 654:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 657:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 65a:	6a 01                	push   $0x1
 65c:	50                   	push   %eax
 65d:	57                   	push   %edi
 65e:	83 c6 01             	add    $0x1,%esi
 661:	e8 dc fd ff ff       	call   442 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 666:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 66a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 66d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66f:	84 db                	test   %bl,%bl
 671:	75 8d                	jne    600 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 673:	8d 65 f4             	lea    -0xc(%ebp),%esp
 676:	5b                   	pop    %ebx
 677:	5e                   	pop    %esi
 678:	5f                   	pop    %edi
 679:	5d                   	pop    %ebp
 67a:	c3                   	ret    
 67b:	90                   	nop
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 680:	83 ec 0c             	sub    $0xc,%esp
 683:	b9 10 00 00 00       	mov    $0x10,%ecx
 688:	6a 00                	push   $0x0
 68a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 68d:	89 f8                	mov    %edi,%eax
 68f:	8b 13                	mov    (%ebx),%edx
 691:	e8 6a fe ff ff       	call   500 <printint>
        ap++;
 696:	89 d8                	mov    %ebx,%eax
 698:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 69b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 69d:	83 c0 04             	add    $0x4,%eax
 6a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6a3:	e9 4d ff ff ff       	jmp    5f5 <printf+0x55>
 6a8:	90                   	nop
 6a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 6b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 6b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 6b5:	83 c0 04             	add    $0x4,%eax
 6b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 6bb:	b8 74 09 00 00       	mov    $0x974,%eax
 6c0:	85 db                	test   %ebx,%ebx
 6c2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 6c5:	0f b6 03             	movzbl (%ebx),%eax
 6c8:	84 c0                	test   %al,%al
 6ca:	74 23                	je     6ef <printf+0x14f>
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6d0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6d3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 6d6:	83 ec 04             	sub    $0x4,%esp
 6d9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6db:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6de:	50                   	push   %eax
 6df:	57                   	push   %edi
 6e0:	e8 5d fd ff ff       	call   442 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e5:	0f b6 03             	movzbl (%ebx),%eax
 6e8:	83 c4 10             	add    $0x10,%esp
 6eb:	84 c0                	test   %al,%al
 6ed:	75 e1                	jne    6d0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ef:	31 d2                	xor    %edx,%edx
 6f1:	e9 ff fe ff ff       	jmp    5f5 <printf+0x55>
 6f6:	8d 76 00             	lea    0x0(%esi),%esi
 6f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 706:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 709:	6a 01                	push   $0x1
 70b:	e9 4c ff ff ff       	jmp    65c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 710:	83 ec 0c             	sub    $0xc,%esp
 713:	b9 0a 00 00 00       	mov    $0xa,%ecx
 718:	6a 01                	push   $0x1
 71a:	e9 6b ff ff ff       	jmp    68a <printf+0xea>
 71f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 722:	83 ec 04             	sub    $0x4,%esp
 725:	8b 03                	mov    (%ebx),%eax
 727:	6a 01                	push   $0x1
 729:	88 45 e4             	mov    %al,-0x1c(%ebp)
 72c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 72f:	50                   	push   %eax
 730:	57                   	push   %edi
 731:	e8 0c fd ff ff       	call   442 <write>
 736:	e9 5b ff ff ff       	jmp    696 <printf+0xf6>
 73b:	66 90                	xchg   %ax,%ax
 73d:	66 90                	xchg   %ax,%ax
 73f:	90                   	nop

00000740 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 740:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	a1 1c 0c 00 00       	mov    0xc1c,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 746:	89 e5                	mov    %esp,%ebp
 748:	57                   	push   %edi
 749:	56                   	push   %esi
 74a:	53                   	push   %ebx
 74b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 750:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 753:	39 c8                	cmp    %ecx,%eax
 755:	73 19                	jae    770 <free+0x30>
 757:	89 f6                	mov    %esi,%esi
 759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 760:	39 d1                	cmp    %edx,%ecx
 762:	72 1c                	jb     780 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 764:	39 d0                	cmp    %edx,%eax
 766:	73 18                	jae    780 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	72 f0                	jb     760 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	39 d0                	cmp    %edx,%eax
 772:	72 f4                	jb     768 <free+0x28>
 774:	39 d1                	cmp    %edx,%ecx
 776:	73 f0                	jae    768 <free+0x28>
 778:	90                   	nop
 779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 780:	8b 73 fc             	mov    -0x4(%ebx),%esi
 783:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 786:	39 d7                	cmp    %edx,%edi
 788:	74 19                	je     7a3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 78a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 793:	39 f1                	cmp    %esi,%ecx
 795:	74 23                	je     7ba <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 797:	89 08                	mov    %ecx,(%eax)
  freep = p;
 799:	a3 1c 0c 00 00       	mov    %eax,0xc1c
}
 79e:	5b                   	pop    %ebx
 79f:	5e                   	pop    %esi
 7a0:	5f                   	pop    %edi
 7a1:	5d                   	pop    %ebp
 7a2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a3:	03 72 04             	add    0x4(%edx),%esi
 7a6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a9:	8b 10                	mov    (%eax),%edx
 7ab:	8b 12                	mov    (%edx),%edx
 7ad:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7b0:	8b 50 04             	mov    0x4(%eax),%edx
 7b3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7b6:	39 f1                	cmp    %esi,%ecx
 7b8:	75 dd                	jne    797 <free+0x57>
    p->s.size += bp->s.size;
 7ba:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 7bd:	a3 1c 0c 00 00       	mov    %eax,0xc1c
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7c8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7ca:	5b                   	pop    %ebx
 7cb:	5e                   	pop    %esi
 7cc:	5f                   	pop    %edi
 7cd:	5d                   	pop    %ebp
 7ce:	c3                   	ret    
 7cf:	90                   	nop

000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
 7d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7dc:	8b 15 1c 0c 00 00    	mov    0xc1c,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	8d 78 07             	lea    0x7(%eax),%edi
 7e5:	c1 ef 03             	shr    $0x3,%edi
 7e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7eb:	85 d2                	test   %edx,%edx
 7ed:	0f 84 a3 00 00 00    	je     896 <malloc+0xc6>
 7f3:	8b 02                	mov    (%edx),%eax
 7f5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7f8:	39 cf                	cmp    %ecx,%edi
 7fa:	76 74                	jbe    870 <malloc+0xa0>
 7fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 802:	be 00 10 00 00       	mov    $0x1000,%esi
 807:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 80e:	0f 43 f7             	cmovae %edi,%esi
 811:	ba 00 80 00 00       	mov    $0x8000,%edx
 816:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 81c:	0f 46 da             	cmovbe %edx,%ebx
 81f:	eb 10                	jmp    831 <malloc+0x61>
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 82a:	8b 48 04             	mov    0x4(%eax),%ecx
 82d:	39 cf                	cmp    %ecx,%edi
 82f:	76 3f                	jbe    870 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 831:	39 05 1c 0c 00 00    	cmp    %eax,0xc1c
 837:	89 c2                	mov    %eax,%edx
 839:	75 ed                	jne    828 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 83b:	83 ec 0c             	sub    $0xc,%esp
 83e:	53                   	push   %ebx
 83f:	e8 66 fc ff ff       	call   4aa <sbrk>
  if(p == (char*)-1)
 844:	83 c4 10             	add    $0x10,%esp
 847:	83 f8 ff             	cmp    $0xffffffff,%eax
 84a:	74 1c                	je     868 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 84c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 84f:	83 ec 0c             	sub    $0xc,%esp
 852:	83 c0 08             	add    $0x8,%eax
 855:	50                   	push   %eax
 856:	e8 e5 fe ff ff       	call   740 <free>
  return freep;
 85b:	8b 15 1c 0c 00 00    	mov    0xc1c,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 861:	83 c4 10             	add    $0x10,%esp
 864:	85 d2                	test   %edx,%edx
 866:	75 c0                	jne    828 <malloc+0x58>
        return 0;
 868:	31 c0                	xor    %eax,%eax
 86a:	eb 1c                	jmp    888 <malloc+0xb8>
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 870:	39 cf                	cmp    %ecx,%edi
 872:	74 1c                	je     890 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 874:	29 f9                	sub    %edi,%ecx
 876:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 879:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 87c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 87f:	89 15 1c 0c 00 00    	mov    %edx,0xc1c
      return (void*)(p + 1);
 885:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 888:	8d 65 f4             	lea    -0xc(%ebp),%esp
 88b:	5b                   	pop    %ebx
 88c:	5e                   	pop    %esi
 88d:	5f                   	pop    %edi
 88e:	5d                   	pop    %ebp
 88f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 890:	8b 08                	mov    (%eax),%ecx
 892:	89 0a                	mov    %ecx,(%edx)
 894:	eb e9                	jmp    87f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 896:	c7 05 1c 0c 00 00 20 	movl   $0xc20,0xc1c
 89d:	0c 00 00 
 8a0:	c7 05 20 0c 00 00 20 	movl   $0xc20,0xc20
 8a7:	0c 00 00 
    base.s.size = 0;
 8aa:	b8 20 0c 00 00       	mov    $0xc20,%eax
 8af:	c7 05 24 0c 00 00 00 	movl   $0x0,0xc24
 8b6:	00 00 00 
 8b9:	e9 3e ff ff ff       	jmp    7fc <malloc+0x2c>
