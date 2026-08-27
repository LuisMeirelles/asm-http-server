#include <stdio.h>
#include <sys/socket.h>

extern int sock();

int main(void)
{
  int socket_fd = sock();

  printf("%d\n", socket_fd);
  
  struct sockaddr addr = {0};
  socklen_t socket_length;

  const int client_fd = accept(socket_fd, &addr, &socket_length);

  printf("%d\n", client_fd);
  
  // parse
  // resposta

  return 0;
}
