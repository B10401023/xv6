
_SMLsanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"


int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
	if (argc != 2){
  14:	83 39 02             	cmpl   $0x2,(%ecx)
#include "user.h"


int
main(int argc, char *argv[])
{
  17:	8b 41 04             	mov    0x4(%ecx),%eax
	if (argc != 2){
  1a:	74 13                	je     2f <main+0x2f>
				printf(1, "Usage: SMLsanity <n>\n");
  1c:	50                   	push   %eax
  1d:	50                   	push   %eax
  1e:	68 40 09 00 00       	push   $0x940
  23:	6a 01                	push   $0x1
  25:	e8 f6 05 00 00       	call   620 <printf>
				exit();
  2a:	e8 73 04 00 00       	call   4a2 <exit>
	int stime;
	int sums[3][3];
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;
	n = atoi(argv[1]);
  2f:	83 ec 0c             	sub    $0xc,%esp
  32:	ff 70 04             	pushl  0x4(%eax)
	int rutime;
	int stime;
	int sums[3][3];
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;
  35:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  3c:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  43:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  4a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  51:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  58:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  5f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	n = atoi(argv[1]);
  74:	e8 b7 03 00 00       	call   430 <atoi>
	int pid;
	for (i = 0; i < n; i++) {
  79:	83 c4 10             	add    $0x10,%esp
  7c:	85 c0                	test   %eax,%eax
	int stime;
	int sums[3][3];
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;
	n = atoi(argv[1]);
  7e:	89 c3                	mov    %eax,%ebx
	int pid;
	for (i = 0; i < n; i++) {
  80:	0f 8e 46 01 00 00    	jle    1cc <main+0x1cc>
  86:	31 f6                	xor    %esi,%esi
		j = i % 3;
		pid = fork();
  88:	e8 0d 04 00 00       	call   49a <fork>
		if (pid == 0) {//child
  8d:	85 c0                	test   %eax,%eax
  8f:	0f 84 c7 00 00 00    	je     15c <main+0x15c>
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;
	n = atoi(argv[1]);
	int pid;
	for (i = 0; i < n; i++) {
  95:	83 c6 01             	add    $0x1,%esi
  98:	39 f3                	cmp    %esi,%ebx
  9a:	75 ec                	jne    88 <main+0x88>
  9c:	31 f6                	xor    %esi,%esi
  9e:	eb 4d                	jmp    ed <main+0xed>
		continue; // father continues to spawn the next child
	}
	for (i = 0; i < n; i++) {
		pid = wait2(&retime, &rutime, &stime);
		int res = (pid - 4) % 3; // correlates to j in the dispatching loop
		switch(res) {
  a0:	83 ff 02             	cmp    $0x2,%edi
  a3:	0f 84 e9 00 00 00    	je     192 <main+0x192>
  a9:	85 ff                	test   %edi,%edi
  ab:	75 35                	jne    e2 <main+0xe2>
			case 0: // CPU bound processes
				printf(1, "Priority 1, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
  ad:	8b 55 b8             	mov    -0x48(%ebp),%edx
  b0:	8b 7d bc             	mov    -0x44(%ebp),%edi
  b3:	50                   	push   %eax
  b4:	8d 04 3a             	lea    (%edx,%edi,1),%eax
  b7:	03 45 c0             	add    -0x40(%ebp),%eax
  ba:	50                   	push   %eax
  bb:	ff 75 c0             	pushl  -0x40(%ebp)
  be:	57                   	push   %edi
  bf:	52                   	push   %edx
  c0:	51                   	push   %ecx
  c1:	68 58 09 00 00       	push   $0x958
  c6:	6a 01                	push   $0x1
  c8:	e8 53 05 00 00       	call   620 <printf>
				sums[0][0] += retime;
  cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
  d0:	01 45 c4             	add    %eax,-0x3c(%ebp)
				sums[0][1] += rutime;
				sums[0][2] += stime;
				break;
  d3:	83 c4 20             	add    $0x20,%esp
		int res = (pid - 4) % 3; // correlates to j in the dispatching loop
		switch(res) {
			case 0: // CPU bound processes
				printf(1, "Priority 1, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[0][0] += retime;
				sums[0][1] += rutime;
  d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  d9:	01 45 c8             	add    %eax,-0x38(%ebp)
				sums[0][2] += stime;
  dc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  df:	01 45 cc             	add    %eax,-0x34(%ebp)
      }
			exit(); // children exit here
		}
		continue; // father continues to spawn the next child
	}
	for (i = 0; i < n; i++) {
  e2:	83 c6 01             	add    $0x1,%esi
  e5:	39 f3                	cmp    %esi,%ebx
  e7:	0f 84 df 00 00 00    	je     1cc <main+0x1cc>
		pid = wait2(&retime, &rutime, &stime);
  ed:	8d 45 c0             	lea    -0x40(%ebp),%eax
  f0:	83 ec 04             	sub    $0x4,%esp
  f3:	50                   	push   %eax
  f4:	8d 45 bc             	lea    -0x44(%ebp),%eax
  f7:	50                   	push   %eax
  f8:	8d 45 b8             	lea    -0x48(%ebp),%eax
  fb:	50                   	push   %eax
  fc:	e8 59 04 00 00       	call   55a <wait2>
		int res = (pid - 4) % 3; // correlates to j in the dispatching loop
		switch(res) {
 101:	8d 78 fc             	lea    -0x4(%eax),%edi
			exit(); // children exit here
		}
		continue; // father continues to spawn the next child
	}
	for (i = 0; i < n; i++) {
		pid = wait2(&retime, &rutime, &stime);
 104:	89 c1                	mov    %eax,%ecx
		int res = (pid - 4) % 3; // correlates to j in the dispatching loop
		switch(res) {
 106:	b8 56 55 55 55       	mov    $0x55555556,%eax
 10b:	83 c4 10             	add    $0x10,%esp
 10e:	f7 ef                	imul   %edi
 110:	89 f8                	mov    %edi,%eax
 112:	c1 f8 1f             	sar    $0x1f,%eax
 115:	29 c2                	sub    %eax,%edx
 117:	8d 04 52             	lea    (%edx,%edx,2),%eax
 11a:	29 c7                	sub    %eax,%edi
 11c:	83 ff 01             	cmp    $0x1,%edi
 11f:	0f 85 7b ff ff ff    	jne    a0 <main+0xa0>
				sums[0][0] += retime;
				sums[0][1] += rutime;
				sums[0][2] += stime;
				break;
			case 1: // CPU bound processes, short tasks
				printf(1, "Priority 2, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
 125:	8b 55 b8             	mov    -0x48(%ebp),%edx
 128:	8b 7d bc             	mov    -0x44(%ebp),%edi
 12b:	50                   	push   %eax
 12c:	8d 04 3a             	lea    (%edx,%edi,1),%eax
 12f:	03 45 c0             	add    -0x40(%ebp),%eax
 132:	50                   	push   %eax
 133:	ff 75 c0             	pushl  -0x40(%ebp)
 136:	57                   	push   %edi
 137:	52                   	push   %edx
 138:	51                   	push   %ecx
 139:	68 a4 09 00 00       	push   $0x9a4
 13e:	6a 01                	push   $0x1
 140:	e8 db 04 00 00       	call   620 <printf>
				sums[1][0] += retime;
 145:	8b 45 b8             	mov    -0x48(%ebp),%eax
				sums[1][1] += rutime;
				sums[1][2] += stime;
				break;
 148:	83 c4 20             	add    $0x20,%esp
				sums[0][1] += rutime;
				sums[0][2] += stime;
				break;
			case 1: // CPU bound processes, short tasks
				printf(1, "Priority 2, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[1][0] += retime;
 14b:	01 45 d0             	add    %eax,-0x30(%ebp)
				sums[1][1] += rutime;
 14e:	8b 45 bc             	mov    -0x44(%ebp),%eax
 151:	01 45 d4             	add    %eax,-0x2c(%ebp)
				sums[1][2] += stime;
 154:	8b 45 c0             	mov    -0x40(%ebp),%eax
 157:	01 45 d8             	add    %eax,-0x28(%ebp)
				break;
 15a:	eb 86                	jmp    e2 <main+0xe2>
	int pid;
	for (i = 0; i < n; i++) {
		j = i % 3;
		pid = fork();
		if (pid == 0) {//child
			j = (getpid() - 4) % 3; // ensures independence from the first son's pid when gathering the results in the second part of the program
 15c:	e8 c1 03 00 00       	call   522 <getpid>
          chpr(getpid(), 3);
					break;
			}
			#endif
      for (k = 0; k < 100; k++){
        for (double z = 0; z < 10000.0; z+= 0.1){
 161:	dd 05 a8 0b 00 00    	fldl   0xba8
	int pid;
	for (i = 0; i < n; i++) {
		j = i % 3;
		pid = fork();
		if (pid == 0) {//child
			j = (getpid() - 4) % 3; // ensures independence from the first son's pid when gathering the results in the second part of the program
 167:	b8 64 00 00 00       	mov    $0x64,%eax
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] = 0;
	n = atoi(argv[1]);
	int pid;
	for (i = 0; i < n; i++) {
 170:	d9 ee                	fldz   
 172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          chpr(getpid(), 3);
					break;
			}
			#endif
      for (k = 0; k < 100; k++){
        for (double z = 0; z < 10000.0; z+= 0.1){
 178:	d8 c1                	fadd   %st(1),%st
 17a:	d9 05 b0 0b 00 00    	flds   0xbb0
 180:	df e9                	fucomip %st(1),%st
 182:	77 f4                	ja     178 <main+0x178>
 184:	dd d8                	fstp   %st(0)
				case 2:
          chpr(getpid(), 3);
					break;
			}
			#endif
      for (k = 0; k < 100; k++){
 186:	83 e8 01             	sub    $0x1,%eax
 189:	75 e5                	jne    170 <main+0x170>
 18b:	dd d8                	fstp   %st(0)
		for (j = 0; j < 3; j++)
			sums[i][j] /= n;
  printf(1, "\n\nPriority 1:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[0][0], sums[0][1], sums[0][2], sums[0][0] + sums[0][1] + sums[0][2]);
	printf(1, "Priority 2:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[1][0], sums[1][1], sums[1][2], sums[1][0] + sums[1][1] + sums[1][2]);
	printf(1, "Priority 3:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[2][0], sums[2][1], sums[2][2], sums[2][0] + sums[2][1] + sums[2][2]);
	exit();
 18d:	e8 10 03 00 00       	call   4a2 <exit>
				sums[1][0] += retime;
				sums[1][1] += rutime;
				sums[1][2] += stime;
				break;
			case 2: // simulating I/O bound processes
				printf(1, "Priority 3, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
 192:	8b 55 b8             	mov    -0x48(%ebp),%edx
 195:	8b 7d bc             	mov    -0x44(%ebp),%edi
 198:	50                   	push   %eax
 199:	8d 04 3a             	lea    (%edx,%edi,1),%eax
 19c:	03 45 c0             	add    -0x40(%ebp),%eax
 19f:	50                   	push   %eax
 1a0:	ff 75 c0             	pushl  -0x40(%ebp)
 1a3:	57                   	push   %edi
 1a4:	52                   	push   %edx
 1a5:	51                   	push   %ecx
 1a6:	68 f0 09 00 00       	push   $0x9f0
 1ab:	6a 01                	push   $0x1
 1ad:	e8 6e 04 00 00       	call   620 <printf>
				sums[2][0] += retime;
 1b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
				sums[2][1] += rutime;
				sums[2][2] += stime;
				break;
 1b5:	83 c4 20             	add    $0x20,%esp
				sums[1][1] += rutime;
				sums[1][2] += stime;
				break;
			case 2: // simulating I/O bound processes
				printf(1, "Priority 3, pid: %d, ready: %d, running: %d, sleeping: %d, turnaround: %d\n", pid, retime, rutime, stime, retime + rutime + stime);
				sums[2][0] += retime;
 1b8:	01 45 dc             	add    %eax,-0x24(%ebp)
				sums[2][1] += rutime;
 1bb:	8b 45 bc             	mov    -0x44(%ebp),%eax
 1be:	01 45 e0             	add    %eax,-0x20(%ebp)
				sums[2][2] += stime;
 1c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
 1c4:	01 45 e4             	add    %eax,-0x1c(%ebp)
				break;
 1c7:	e9 16 ff ff ff       	jmp    e2 <main+0xe2>
 1cc:	8d 4d c4             	lea    -0x3c(%ebp),%ecx
 1cf:	8d 75 e8             	lea    -0x18(%ebp),%esi
		}
	}
	for (i = 0; i < 3; i++)
		for (j = 0; j < 3; j++)
			sums[i][j] /= n;
 1d2:	8b 01                	mov    (%ecx),%eax
 1d4:	83 c1 0c             	add    $0xc,%ecx
 1d7:	99                   	cltd   
 1d8:	f7 fb                	idiv   %ebx
 1da:	89 41 f4             	mov    %eax,-0xc(%ecx)
 1dd:	8b 41 f8             	mov    -0x8(%ecx),%eax
 1e0:	99                   	cltd   
 1e1:	f7 fb                	idiv   %ebx
 1e3:	89 41 f8             	mov    %eax,-0x8(%ecx)
 1e6:	8b 41 fc             	mov    -0x4(%ecx),%eax
 1e9:	99                   	cltd   
 1ea:	f7 fb                	idiv   %ebx
 1ec:	89 41 fc             	mov    %eax,-0x4(%ecx)
				sums[2][1] += rutime;
				sums[2][2] += stime;
				break;
		}
	}
	for (i = 0; i < 3; i++)
 1ef:	39 ce                	cmp    %ecx,%esi
 1f1:	75 df                	jne    1d2 <main+0x1d2>
		for (j = 0; j < 3; j++)
			sums[i][j] /= n;
  printf(1, "\n\nPriority 1:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[0][0], sums[0][1], sums[0][2], sums[0][0] + sums[0][1] + sums[0][2]);
 1f3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 1f6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
 1f9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
 1fc:	50                   	push   %eax
 1fd:	50                   	push   %eax
 1fe:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 201:	01 d8                	add    %ebx,%eax
 203:	50                   	push   %eax
 204:	53                   	push   %ebx
 205:	51                   	push   %ecx
 206:	52                   	push   %edx
 207:	68 3c 0a 00 00       	push   $0xa3c
 20c:	6a 01                	push   $0x1
 20e:	e8 0d 04 00 00       	call   620 <printf>
	printf(1, "Priority 2:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[1][0], sums[1][1], sums[1][2], sums[1][0] + sums[1][1] + sums[1][2]);
 213:	8b 55 d0             	mov    -0x30(%ebp),%edx
 216:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 219:	83 c4 18             	add    $0x18,%esp
 21c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
 21f:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 222:	01 d8                	add    %ebx,%eax
 224:	50                   	push   %eax
 225:	53                   	push   %ebx
 226:	51                   	push   %ecx
 227:	52                   	push   %edx
 228:	68 b4 0a 00 00       	push   $0xab4
 22d:	6a 01                	push   $0x1
 22f:	e8 ec 03 00 00       	call   620 <printf>
	printf(1, "Priority 3:\nAverage ready time: %d\nAverage running time: %d\nAverage sleeping time: %d\nAverage turnaround time: %d\n\n\n", sums[2][0], sums[2][1], sums[2][2], sums[2][0] + sums[2][1] + sums[2][2]);
 234:	8b 55 dc             	mov    -0x24(%ebp),%edx
 237:	8b 4d e0             	mov    -0x20(%ebp),%ecx
 23a:	83 c4 18             	add    $0x18,%esp
 23d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
 240:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
 243:	01 d8                	add    %ebx,%eax
 245:	50                   	push   %eax
 246:	53                   	push   %ebx
 247:	51                   	push   %ecx
 248:	52                   	push   %edx
 249:	68 2c 0b 00 00       	push   $0xb2c
 24e:	6a 01                	push   $0x1
 250:	e8 cb 03 00 00       	call   620 <printf>
	exit();
 255:	83 c4 20             	add    $0x20,%esp
 258:	e9 30 ff ff ff       	jmp    18d <main+0x18d>
 25d:	66 90                	xchg   %ax,%ax
 25f:	90                   	nop

00000260 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	53                   	push   %ebx
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 26a:	89 c2                	mov    %eax,%edx
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 270:	83 c1 01             	add    $0x1,%ecx
 273:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 277:	83 c2 01             	add    $0x1,%edx
 27a:	84 db                	test   %bl,%bl
 27c:	88 5a ff             	mov    %bl,-0x1(%edx)
 27f:	75 ef                	jne    270 <strcpy+0x10>
    ;
  return os;
}
 281:	5b                   	pop    %ebx
 282:	5d                   	pop    %ebp
 283:	c3                   	ret    
 284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 28a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000290 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
 295:	8b 55 08             	mov    0x8(%ebp),%edx
 298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 29b:	0f b6 02             	movzbl (%edx),%eax
 29e:	0f b6 19             	movzbl (%ecx),%ebx
 2a1:	84 c0                	test   %al,%al
 2a3:	75 1e                	jne    2c3 <strcmp+0x33>
 2a5:	eb 29                	jmp    2d0 <strcmp+0x40>
 2a7:	89 f6                	mov    %esi,%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2b0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2b6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2b9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 2bd:	84 c0                	test   %al,%al
 2bf:	74 0f                	je     2d0 <strcmp+0x40>
 2c1:	89 f1                	mov    %esi,%ecx
 2c3:	38 d8                	cmp    %bl,%al
 2c5:	74 e9                	je     2b0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2c7:	29 d8                	sub    %ebx,%eax
}
 2c9:	5b                   	pop    %ebx
 2ca:	5e                   	pop    %esi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2d0:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2d2:	29 d8                	sub    %ebx,%eax
}
 2d4:	5b                   	pop    %ebx
 2d5:	5e                   	pop    %esi
 2d6:	5d                   	pop    %ebp
 2d7:	c3                   	ret    
 2d8:	90                   	nop
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002e0 <strlen>:

uint
strlen(char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 2e6:	80 39 00             	cmpb   $0x0,(%ecx)
 2e9:	74 12                	je     2fd <strlen+0x1d>
 2eb:	31 d2                	xor    %edx,%edx
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
 2f0:	83 c2 01             	add    $0x1,%edx
 2f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2f7:	89 d0                	mov    %edx,%eax
 2f9:	75 f5                	jne    2f0 <strlen+0x10>
    ;
  return n;
}
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 2fd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	eb 0d                	jmp    310 <memset>
 303:	90                   	nop
 304:	90                   	nop
 305:	90                   	nop
 306:	90                   	nop
 307:	90                   	nop
 308:	90                   	nop
 309:	90                   	nop
 30a:	90                   	nop
 30b:	90                   	nop
 30c:	90                   	nop
 30d:	90                   	nop
 30e:	90                   	nop
 30f:	90                   	nop

00000310 <memset>:

void*
memset(void *dst, int c, uint n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 317:	8b 4d 10             	mov    0x10(%ebp),%ecx
 31a:	8b 45 0c             	mov    0xc(%ebp),%eax
 31d:	89 d7                	mov    %edx,%edi
 31f:	fc                   	cld    
 320:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 322:	89 d0                	mov    %edx,%eax
 324:	5f                   	pop    %edi
 325:	5d                   	pop    %ebp
 326:	c3                   	ret    
 327:	89 f6                	mov    %esi,%esi
 329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000330 <strchr>:

char*
strchr(const char *s, char c)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 33a:	0f b6 10             	movzbl (%eax),%edx
 33d:	84 d2                	test   %dl,%dl
 33f:	74 1d                	je     35e <strchr+0x2e>
    if(*s == c)
 341:	38 d3                	cmp    %dl,%bl
 343:	89 d9                	mov    %ebx,%ecx
 345:	75 0d                	jne    354 <strchr+0x24>
 347:	eb 17                	jmp    360 <strchr+0x30>
 349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 350:	38 ca                	cmp    %cl,%dl
 352:	74 0c                	je     360 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 354:	83 c0 01             	add    $0x1,%eax
 357:	0f b6 10             	movzbl (%eax),%edx
 35a:	84 d2                	test   %dl,%dl
 35c:	75 f2                	jne    350 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 35e:	31 c0                	xor    %eax,%eax
}
 360:	5b                   	pop    %ebx
 361:	5d                   	pop    %ebp
 362:	c3                   	ret    
 363:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <gets>:

char*
gets(char *buf, int max)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	57                   	push   %edi
 374:	56                   	push   %esi
 375:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 376:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 378:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 37b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37e:	eb 29                	jmp    3a9 <gets+0x39>
    cc = read(0, &c, 1);
 380:	83 ec 04             	sub    $0x4,%esp
 383:	6a 01                	push   $0x1
 385:	57                   	push   %edi
 386:	6a 00                	push   $0x0
 388:	e8 2d 01 00 00       	call   4ba <read>
    if(cc < 1)
 38d:	83 c4 10             	add    $0x10,%esp
 390:	85 c0                	test   %eax,%eax
 392:	7e 1d                	jle    3b1 <gets+0x41>
      break;
    buf[i++] = c;
 394:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 398:	8b 55 08             	mov    0x8(%ebp),%edx
 39b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 39d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 39f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 3a3:	74 1b                	je     3c0 <gets+0x50>
 3a5:	3c 0d                	cmp    $0xd,%al
 3a7:	74 17                	je     3c0 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a9:	8d 5e 01             	lea    0x1(%esi),%ebx
 3ac:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3af:	7c cf                	jl     380 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bb:	5b                   	pop    %ebx
 3bc:	5e                   	pop    %esi
 3bd:	5f                   	pop    %edi
 3be:	5d                   	pop    %ebp
 3bf:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c3:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3c5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 3c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3cc:	5b                   	pop    %ebx
 3cd:	5e                   	pop    %esi
 3ce:	5f                   	pop    %edi
 3cf:	5d                   	pop    %ebp
 3d0:	c3                   	ret    
 3d1:	eb 0d                	jmp    3e0 <stat>
 3d3:	90                   	nop
 3d4:	90                   	nop
 3d5:	90                   	nop
 3d6:	90                   	nop
 3d7:	90                   	nop
 3d8:	90                   	nop
 3d9:	90                   	nop
 3da:	90                   	nop
 3db:	90                   	nop
 3dc:	90                   	nop
 3dd:	90                   	nop
 3de:	90                   	nop
 3df:	90                   	nop

000003e0 <stat>:

int
stat(char *n, struct stat *st)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	56                   	push   %esi
 3e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e5:	83 ec 08             	sub    $0x8,%esp
 3e8:	6a 00                	push   $0x0
 3ea:	ff 75 08             	pushl  0x8(%ebp)
 3ed:	e8 f0 00 00 00       	call   4e2 <open>
  if(fd < 0)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	78 27                	js     420 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3f9:	83 ec 08             	sub    $0x8,%esp
 3fc:	ff 75 0c             	pushl  0xc(%ebp)
 3ff:	89 c3                	mov    %eax,%ebx
 401:	50                   	push   %eax
 402:	e8 f3 00 00 00       	call   4fa <fstat>
 407:	89 c6                	mov    %eax,%esi
  close(fd);
 409:	89 1c 24             	mov    %ebx,(%esp)
 40c:	e8 b9 00 00 00       	call   4ca <close>
  return r;
 411:	83 c4 10             	add    $0x10,%esp
 414:	89 f0                	mov    %esi,%eax
}
 416:	8d 65 f8             	lea    -0x8(%ebp),%esp
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5d                   	pop    %ebp
 41c:	c3                   	ret    
 41d:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 425:	eb ef                	jmp    416 <stat+0x36>
 427:	89 f6                	mov    %esi,%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 437:	0f be 11             	movsbl (%ecx),%edx
 43a:	8d 42 d0             	lea    -0x30(%edx),%eax
 43d:	3c 09                	cmp    $0x9,%al
 43f:	b8 00 00 00 00       	mov    $0x0,%eax
 444:	77 1f                	ja     465 <atoi+0x35>
 446:	8d 76 00             	lea    0x0(%esi),%esi
 449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 450:	8d 04 80             	lea    (%eax,%eax,4),%eax
 453:	83 c1 01             	add    $0x1,%ecx
 456:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 45a:	0f be 11             	movsbl (%ecx),%edx
 45d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 460:	80 fb 09             	cmp    $0x9,%bl
 463:	76 eb                	jbe    450 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 465:	5b                   	pop    %ebx
 466:	5d                   	pop    %ebp
 467:	c3                   	ret    
 468:	90                   	nop
 469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000470 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	56                   	push   %esi
 474:	53                   	push   %ebx
 475:	8b 5d 10             	mov    0x10(%ebp),%ebx
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	85 db                	test   %ebx,%ebx
 480:	7e 14                	jle    496 <memmove+0x26>
 482:	31 d2                	xor    %edx,%edx
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 488:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 48c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 48f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 492:	39 da                	cmp    %ebx,%edx
 494:	75 f2                	jne    488 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 496:	5b                   	pop    %ebx
 497:	5e                   	pop    %esi
 498:	5d                   	pop    %ebp
 499:	c3                   	ret    

0000049a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49a:	b8 01 00 00 00       	mov    $0x1,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <exit>:
SYSCALL(exit)
 4a2:	b8 02 00 00 00       	mov    $0x2,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <wait>:
SYSCALL(wait)
 4aa:	b8 03 00 00 00       	mov    $0x3,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <pipe>:
SYSCALL(pipe)
 4b2:	b8 04 00 00 00       	mov    $0x4,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <read>:
SYSCALL(read)
 4ba:	b8 05 00 00 00       	mov    $0x5,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <write>:
SYSCALL(write)
 4c2:	b8 10 00 00 00       	mov    $0x10,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <close>:
SYSCALL(close)
 4ca:	b8 15 00 00 00       	mov    $0x15,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <kill>:
SYSCALL(kill)
 4d2:	b8 06 00 00 00       	mov    $0x6,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <exec>:
SYSCALL(exec)
 4da:	b8 07 00 00 00       	mov    $0x7,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <open>:
SYSCALL(open)
 4e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <mknod>:
SYSCALL(mknod)
 4ea:	b8 11 00 00 00       	mov    $0x11,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <unlink>:
SYSCALL(unlink)
 4f2:	b8 12 00 00 00       	mov    $0x12,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <fstat>:
SYSCALL(fstat)
 4fa:	b8 08 00 00 00       	mov    $0x8,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <link>:
SYSCALL(link)
 502:	b8 13 00 00 00       	mov    $0x13,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <mkdir>:
SYSCALL(mkdir)
 50a:	b8 14 00 00 00       	mov    $0x14,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <chdir>:
SYSCALL(chdir)
 512:	b8 09 00 00 00       	mov    $0x9,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <dup>:
SYSCALL(dup)
 51a:	b8 0a 00 00 00       	mov    $0xa,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <getpid>:
SYSCALL(getpid)
 522:	b8 0b 00 00 00       	mov    $0xb,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <sbrk>:
SYSCALL(sbrk)
 52a:	b8 0c 00 00 00       	mov    $0xc,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <sleep>:
SYSCALL(sleep)
 532:	b8 0d 00 00 00       	mov    $0xd,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <uptime>:
SYSCALL(uptime)
 53a:	b8 0e 00 00 00       	mov    $0xe,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <getptable>:
SYSCALL(getptable)
 542:	b8 16 00 00 00       	mov    $0x16,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <getppid>:
SYSCALL(getppid)
 54a:	b8 17 00 00 00       	mov    $0x17,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <chpr>:
SYSCALL(chpr)
 552:	b8 18 00 00 00       	mov    $0x18,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <wait2>:
SYSCALL(wait2)
 55a:	b8 19 00 00 00       	mov    $0x19,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <yield>:
SYSCALL(yield)
 562:	b8 1a 00 00 00       	mov    $0x1a,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <chtickets>:
SYSCALL(chtickets)
 56a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    
 572:	66 90                	xchg   %ax,%ax
 574:	66 90                	xchg   %ax,%ax
 576:	66 90                	xchg   %ax,%ax
 578:	66 90                	xchg   %ax,%ax
 57a:	66 90                	xchg   %ax,%ax
 57c:	66 90                	xchg   %ax,%ax
 57e:	66 90                	xchg   %ax,%ax

00000580 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
 586:	89 c6                	mov    %eax,%esi
 588:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 58b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 58e:	85 db                	test   %ebx,%ebx
 590:	74 7e                	je     610 <printint+0x90>
 592:	89 d0                	mov    %edx,%eax
 594:	c1 e8 1f             	shr    $0x1f,%eax
 597:	84 c0                	test   %al,%al
 599:	74 75                	je     610 <printint+0x90>
    neg = 1;
    x = -xx;
 59b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 59d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 5a4:	f7 d8                	neg    %eax
 5a6:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5a9:	31 ff                	xor    %edi,%edi
 5ab:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5ae:	89 ce                	mov    %ecx,%esi
 5b0:	eb 08                	jmp    5ba <printint+0x3a>
 5b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 5b8:	89 cf                	mov    %ecx,%edi
 5ba:	31 d2                	xor    %edx,%edx
 5bc:	8d 4f 01             	lea    0x1(%edi),%ecx
 5bf:	f7 f6                	div    %esi
 5c1:	0f b6 92 bc 0b 00 00 	movzbl 0xbbc(%edx),%edx
  }while((x /= base) != 0);
 5c8:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 5ca:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 5cd:	75 e9                	jne    5b8 <printint+0x38>
  if(neg)
 5cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5d2:	8b 75 c0             	mov    -0x40(%ebp),%esi
 5d5:	85 c0                	test   %eax,%eax
 5d7:	74 08                	je     5e1 <printint+0x61>
    buf[i++] = '-';
 5d9:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 5de:	8d 4f 02             	lea    0x2(%edi),%ecx
 5e1:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 5e5:	8d 76 00             	lea    0x0(%esi),%esi
 5e8:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5eb:	83 ec 04             	sub    $0x4,%esp
 5ee:	83 ef 01             	sub    $0x1,%edi
 5f1:	6a 01                	push   $0x1
 5f3:	53                   	push   %ebx
 5f4:	56                   	push   %esi
 5f5:	88 45 d7             	mov    %al,-0x29(%ebp)
 5f8:	e8 c5 fe ff ff       	call   4c2 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	39 df                	cmp    %ebx,%edi
 602:	75 e4                	jne    5e8 <printint+0x68>
    putc(fd, buf[i]);
}
 604:	8d 65 f4             	lea    -0xc(%ebp),%esp
 607:	5b                   	pop    %ebx
 608:	5e                   	pop    %esi
 609:	5f                   	pop    %edi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret    
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 610:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 612:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 619:	eb 8b                	jmp    5a6 <printint+0x26>
 61b:	90                   	nop
 61c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000620 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 626:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 629:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 62c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 62f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 632:	89 45 d0             	mov    %eax,-0x30(%ebp)
 635:	0f b6 1e             	movzbl (%esi),%ebx
 638:	83 c6 01             	add    $0x1,%esi
 63b:	84 db                	test   %bl,%bl
 63d:	0f 84 b0 00 00 00    	je     6f3 <printf+0xd3>
 643:	31 d2                	xor    %edx,%edx
 645:	eb 39                	jmp    680 <printf+0x60>
 647:	89 f6                	mov    %esi,%esi
 649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 650:	83 f8 25             	cmp    $0x25,%eax
 653:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 656:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 65b:	74 18                	je     675 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 65d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 660:	83 ec 04             	sub    $0x4,%esp
 663:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 666:	6a 01                	push   $0x1
 668:	50                   	push   %eax
 669:	57                   	push   %edi
 66a:	e8 53 fe ff ff       	call   4c2 <write>
 66f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 672:	83 c4 10             	add    $0x10,%esp
 675:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 678:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 67c:	84 db                	test   %bl,%bl
 67e:	74 73                	je     6f3 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 680:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 682:	0f be cb             	movsbl %bl,%ecx
 685:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 688:	74 c6                	je     650 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 68a:	83 fa 25             	cmp    $0x25,%edx
 68d:	75 e6                	jne    675 <printf+0x55>
      if(c == 'd'){
 68f:	83 f8 64             	cmp    $0x64,%eax
 692:	0f 84 f8 00 00 00    	je     790 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 698:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 69e:	83 f9 70             	cmp    $0x70,%ecx
 6a1:	74 5d                	je     700 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6a3:	83 f8 73             	cmp    $0x73,%eax
 6a6:	0f 84 84 00 00 00    	je     730 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ac:	83 f8 63             	cmp    $0x63,%eax
 6af:	0f 84 ea 00 00 00    	je     79f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6b5:	83 f8 25             	cmp    $0x25,%eax
 6b8:	0f 84 c2 00 00 00    	je     780 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6c1:	83 ec 04             	sub    $0x4,%esp
 6c4:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6c8:	6a 01                	push   $0x1
 6ca:	50                   	push   %eax
 6cb:	57                   	push   %edi
 6cc:	e8 f1 fd ff ff       	call   4c2 <write>
 6d1:	83 c4 0c             	add    $0xc,%esp
 6d4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6d7:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6da:	6a 01                	push   $0x1
 6dc:	50                   	push   %eax
 6dd:	57                   	push   %edi
 6de:	83 c6 01             	add    $0x1,%esi
 6e1:	e8 dc fd ff ff       	call   4c2 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e6:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6ea:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6ed:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ef:	84 db                	test   %bl,%bl
 6f1:	75 8d                	jne    680 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f6:	5b                   	pop    %ebx
 6f7:	5e                   	pop    %esi
 6f8:	5f                   	pop    %edi
 6f9:	5d                   	pop    %ebp
 6fa:	c3                   	ret    
 6fb:	90                   	nop
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	b9 10 00 00 00       	mov    $0x10,%ecx
 708:	6a 00                	push   $0x0
 70a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 70d:	89 f8                	mov    %edi,%eax
 70f:	8b 13                	mov    (%ebx),%edx
 711:	e8 6a fe ff ff       	call   580 <printint>
        ap++;
 716:	89 d8                	mov    %ebx,%eax
 718:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 71b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 71d:	83 c0 04             	add    $0x4,%eax
 720:	89 45 d0             	mov    %eax,-0x30(%ebp)
 723:	e9 4d ff ff ff       	jmp    675 <printf+0x55>
 728:	90                   	nop
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 730:	8b 45 d0             	mov    -0x30(%ebp),%eax
 733:	8b 18                	mov    (%eax),%ebx
        ap++;
 735:	83 c0 04             	add    $0x4,%eax
 738:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 73b:	b8 b4 0b 00 00       	mov    $0xbb4,%eax
 740:	85 db                	test   %ebx,%ebx
 742:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 745:	0f b6 03             	movzbl (%ebx),%eax
 748:	84 c0                	test   %al,%al
 74a:	74 23                	je     76f <printf+0x14f>
 74c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 750:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 753:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 756:	83 ec 04             	sub    $0x4,%esp
 759:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 75b:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 75e:	50                   	push   %eax
 75f:	57                   	push   %edi
 760:	e8 5d fd ff ff       	call   4c2 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 765:	0f b6 03             	movzbl (%ebx),%eax
 768:	83 c4 10             	add    $0x10,%esp
 76b:	84 c0                	test   %al,%al
 76d:	75 e1                	jne    750 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 76f:	31 d2                	xor    %edx,%edx
 771:	e9 ff fe ff ff       	jmp    675 <printf+0x55>
 776:	8d 76 00             	lea    0x0(%esi),%esi
 779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
 783:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 786:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 789:	6a 01                	push   $0x1
 78b:	e9 4c ff ff ff       	jmp    6dc <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 790:	83 ec 0c             	sub    $0xc,%esp
 793:	b9 0a 00 00 00       	mov    $0xa,%ecx
 798:	6a 01                	push   $0x1
 79a:	e9 6b ff ff ff       	jmp    70a <printf+0xea>
 79f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 7a2:	83 ec 04             	sub    $0x4,%esp
 7a5:	8b 03                	mov    (%ebx),%eax
 7a7:	6a 01                	push   $0x1
 7a9:	88 45 e4             	mov    %al,-0x1c(%ebp)
 7ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7af:	50                   	push   %eax
 7b0:	57                   	push   %edi
 7b1:	e8 0c fd ff ff       	call   4c2 <write>
 7b6:	e9 5b ff ff ff       	jmp    716 <printf+0xf6>
 7bb:	66 90                	xchg   %ax,%ax
 7bd:	66 90                	xchg   %ax,%ax
 7bf:	90                   	nop

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c1:	a1 60 0e 00 00       	mov    0xe60,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c6:	89 e5                	mov    %esp,%ebp
 7c8:	57                   	push   %edi
 7c9:	56                   	push   %esi
 7ca:	53                   	push   %ebx
 7cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d3:	39 c8                	cmp    %ecx,%eax
 7d5:	73 19                	jae    7f0 <free+0x30>
 7d7:	89 f6                	mov    %esi,%esi
 7d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 7e0:	39 d1                	cmp    %edx,%ecx
 7e2:	72 1c                	jb     800 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	39 d0                	cmp    %edx,%eax
 7e6:	73 18                	jae    800 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e8:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ec:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	72 f0                	jb     7e0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	39 d0                	cmp    %edx,%eax
 7f2:	72 f4                	jb     7e8 <free+0x28>
 7f4:	39 d1                	cmp    %edx,%ecx
 7f6:	73 f0                	jae    7e8 <free+0x28>
 7f8:	90                   	nop
 7f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 800:	8b 73 fc             	mov    -0x4(%ebx),%esi
 803:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 806:	39 d7                	cmp    %edx,%edi
 808:	74 19                	je     823 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 80a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 80d:	8b 50 04             	mov    0x4(%eax),%edx
 810:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 813:	39 f1                	cmp    %esi,%ecx
 815:	74 23                	je     83a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 817:	89 08                	mov    %ecx,(%eax)
  freep = p;
 819:	a3 60 0e 00 00       	mov    %eax,0xe60
}
 81e:	5b                   	pop    %ebx
 81f:	5e                   	pop    %esi
 820:	5f                   	pop    %edi
 821:	5d                   	pop    %ebp
 822:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 823:	03 72 04             	add    0x4(%edx),%esi
 826:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 829:	8b 10                	mov    (%eax),%edx
 82b:	8b 12                	mov    (%edx),%edx
 82d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 830:	8b 50 04             	mov    0x4(%eax),%edx
 833:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 836:	39 f1                	cmp    %esi,%ecx
 838:	75 dd                	jne    817 <free+0x57>
    p->s.size += bp->s.size;
 83a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 83d:	a3 60 0e 00 00       	mov    %eax,0xe60
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 842:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 845:	8b 53 f8             	mov    -0x8(%ebx),%edx
 848:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 84a:	5b                   	pop    %ebx
 84b:	5e                   	pop    %esi
 84c:	5f                   	pop    %edi
 84d:	5d                   	pop    %ebp
 84e:	c3                   	ret    
 84f:	90                   	nop

00000850 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	57                   	push   %edi
 854:	56                   	push   %esi
 855:	53                   	push   %ebx
 856:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 859:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 85c:	8b 15 60 0e 00 00    	mov    0xe60,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	8d 78 07             	lea    0x7(%eax),%edi
 865:	c1 ef 03             	shr    $0x3,%edi
 868:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 86b:	85 d2                	test   %edx,%edx
 86d:	0f 84 a3 00 00 00    	je     916 <malloc+0xc6>
 873:	8b 02                	mov    (%edx),%eax
 875:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 878:	39 cf                	cmp    %ecx,%edi
 87a:	76 74                	jbe    8f0 <malloc+0xa0>
 87c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 882:	be 00 10 00 00       	mov    $0x1000,%esi
 887:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 88e:	0f 43 f7             	cmovae %edi,%esi
 891:	ba 00 80 00 00       	mov    $0x8000,%edx
 896:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 89c:	0f 46 da             	cmovbe %edx,%ebx
 89f:	eb 10                	jmp    8b1 <malloc+0x61>
 8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8aa:	8b 48 04             	mov    0x4(%eax),%ecx
 8ad:	39 cf                	cmp    %ecx,%edi
 8af:	76 3f                	jbe    8f0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b1:	39 05 60 0e 00 00    	cmp    %eax,0xe60
 8b7:	89 c2                	mov    %eax,%edx
 8b9:	75 ed                	jne    8a8 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 8bb:	83 ec 0c             	sub    $0xc,%esp
 8be:	53                   	push   %ebx
 8bf:	e8 66 fc ff ff       	call   52a <sbrk>
  if(p == (char*)-1)
 8c4:	83 c4 10             	add    $0x10,%esp
 8c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 8ca:	74 1c                	je     8e8 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 8cc:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 8cf:	83 ec 0c             	sub    $0xc,%esp
 8d2:	83 c0 08             	add    $0x8,%eax
 8d5:	50                   	push   %eax
 8d6:	e8 e5 fe ff ff       	call   7c0 <free>
  return freep;
 8db:	8b 15 60 0e 00 00    	mov    0xe60,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 8e1:	83 c4 10             	add    $0x10,%esp
 8e4:	85 d2                	test   %edx,%edx
 8e6:	75 c0                	jne    8a8 <malloc+0x58>
        return 0;
 8e8:	31 c0                	xor    %eax,%eax
 8ea:	eb 1c                	jmp    908 <malloc+0xb8>
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 8f0:	39 cf                	cmp    %ecx,%edi
 8f2:	74 1c                	je     910 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 8f4:	29 f9                	sub    %edi,%ecx
 8f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8fc:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 8ff:	89 15 60 0e 00 00    	mov    %edx,0xe60
      return (void*)(p + 1);
 905:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 908:	8d 65 f4             	lea    -0xc(%ebp),%esp
 90b:	5b                   	pop    %ebx
 90c:	5e                   	pop    %esi
 90d:	5f                   	pop    %edi
 90e:	5d                   	pop    %ebp
 90f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 910:	8b 08                	mov    (%eax),%ecx
 912:	89 0a                	mov    %ecx,(%edx)
 914:	eb e9                	jmp    8ff <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 916:	c7 05 60 0e 00 00 64 	movl   $0xe64,0xe60
 91d:	0e 00 00 
 920:	c7 05 64 0e 00 00 64 	movl   $0xe64,0xe64
 927:	0e 00 00 
    base.s.size = 0;
 92a:	b8 64 0e 00 00       	mov    $0xe64,%eax
 92f:	c7 05 68 0e 00 00 00 	movl   $0x0,0xe68
 936:	00 00 00 
 939:	e9 3e ff ff ff       	jmp    87c <malloc+0x2c>
