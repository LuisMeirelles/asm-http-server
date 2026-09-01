#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>

#define ENDPOINT_POSITION_IN_REQUEST 2

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

    if ((client_fd & 0x0100) == 0x0100) {
      dprintf(2, "erro na criação do socket\n");
      client_fd = 0x0100 ^ client_fd;
    } else if ((client_fd & 0x0200) == 0x0200) {
      dprintf(2, "erro no bind do socket\n");
      client_fd = 0x0200 ^ client_fd;
    } else if ((client_fd & 0x0300) == 0x0300) {
      dprintf(2, "erro no listen do socket\n");
      client_fd = 0x0300 ^ client_fd;
    } else if ((client_fd & 0x0400) == 0x0400) {
      dprintf(2, "erro no accept do socket\n");
      client_fd = 0x0400 ^ client_fd;
    }

    return -client_fd;
  }

  char buf[1024] = {0};
 
  read(client_fd, buf, 1024);
 
  handle_request(buf, client_fd);

  return 0;
}

