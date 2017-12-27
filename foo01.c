#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int
main(int argc, char *argv[])
{
  int  k, n = 2, id;
  double x = 0,  z;

  if (argc != 2) {
    printf(2, "usage: %s n\n", argv[0]);
  }
  else
    n = atoi ( argv[1] ); //from command line
  for ( k = 0; k < n; k++ ) {
    id = fork ();
    if ( id < 0 ) {
      printf(1, "%d failed in fork!\n", getpid() );
      break;
    } else if ( id > 0 ) {  //parent
      printf(1, "Parent %d creating child  %d\n", getpid(), id );
   } else {   // child
      printf(1, "Child %d created\n",getpid() );
      for ( z = 0; z < 8000000.0; z += 0.001 )
       x =  x + 3.14 * 89.64;   // useless calculations to consume CPU time
      break;
    }
  }
  
  exit();
}

/*int main(int argc, char *argv[]) {
  int pid;
  int k, n;
  int x, z;

  if (argc != 2) {
    printf(2, "usage: %s n\n", argv[0]);
  }

  n = atoi(argv[1]);

  for ( k = 0; k < n; k++ ) {
    pid = fork ();
    if ( pid < 0 ) {
      printf(1, "%d failed in fork!\n", getpid());
      exit();
    } else if (pid > 0) {
      // child
      printf(1, "Child %d created\n",getpid());
      //for ( z = 0; z < 10000.0; z += 0.01 )
         //x =  x + 3.14 * 89.64;   // useless calculations to consume CPU time
      exit();
    }
  }

  for (k = 0; k < n; k++) {
    wait();
  }

  exit();
}*/
