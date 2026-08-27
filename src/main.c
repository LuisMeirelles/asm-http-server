#include <stdio.h>
#include <sys/socket.h>

extern int sock();

int main(void)
{
  int client_fd = sock();

  printf("%d\n", client_fd);
  
  // parse
  // resposta

  return 0;
}
