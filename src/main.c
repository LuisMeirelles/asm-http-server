#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>

extern int sock();

int bind_socket(const int fd)
{
  struct sockaddr_in addr = {
    .sin_family = AF_INET,
    .sin_port = htons(8000),
    .sin_addr = {
      .s_addr = INADDR_ANY,
    }
  };

  return bind(fd, (struct sockaddr *) &addr, sizeof(addr));
}

int listen_connections(const int fd)
{
  return listen(fd, 3);
}

int main(void)
{
  int socket_fd = sock();

  bind_socket(socket_fd);
  
  printf("%d\n", socket_fd);

  return 0;

  listen_connections(socket_fd);

  struct sockaddr addr = {0};
  socklen_t socket_length;

  const int client_fd = accept(socket_fd, &addr, &socket_length);
  
  printf("%d\n", client_fd);
  
  // parse
  // resposta

  // sleep(5);
  return 0;
}
