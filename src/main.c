#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>

#define ENDPOINT_POSITION_IN_REQUEST 2

#define ORIGEM_SOCKET 1
#define ORIGEM_BIND   2
#define ORIGEM_LISTEN 3
#define ORIGEM_ACCEPT 4

extern int listen(uint16_t port);

char *parse_request(char buf[])
{
  printf("Request:\n%s\n", buf);

  char *endpoint;

  int i;
  char *str;

  for (i = 0, str = buf; i < ENDPOINT_POSITION_IN_REQUEST; i++, str = NULL)
    endpoint = strtok(str, " \n");

  if (strcmp(endpoint, "/ping") == 0) {
    return "pong";
  }

  return "";
}

void handle_request(char buf[], int fd) {
  char *response = parse_request(buf);

  printf("\nResponse:\n%s\n", response);
  dprintf(fd, "%s", response);
}

int main(void)
{
  int client_fd = listen(8001);

  if (client_fd < 0) {
    client_fd = -client_fd;

    int origin = (client_fd >> 8) & 0xFF;
    int error = client_fd & 0xFF;

    switch (origin) {
      case ORIGEM_SOCKET:
        dprintf(2, "erro na criação do socket\n");
        break;

      case ORIGEM_BIND:
        dprintf(2, "erro no bind do socket\n");
        break;

      case ORIGEM_LISTEN:
        dprintf(2, "erro no listen do socket\n");
        break;

      case ORIGEM_ACCEPT:
        dprintf(2, "erro no accept do socket\n");
        break;
    }

    return -error;
  }

  char buf[1024] = {0};
 
  read(client_fd, buf, 1024);
 
  handle_request(buf, client_fd);

  return 0;
}

