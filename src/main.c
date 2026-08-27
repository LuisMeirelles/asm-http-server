#include <stdio.h>

extern int sock();

int main(void)
{
  int sock_success = sock();

  printf("%d\n", sock_success);
  sleep(5);
  
  // struct sockaddr addr = {0};
  // socklen_t socket_length;
  //
  // const int client_fd = accept(socket_fd, &addr, &socket_length);
  //
  // printf("%d\n", client_fd);
  
  // parse
  // resposta

  return 0;
}
