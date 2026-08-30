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

  char buf[1024] = {0};
 
  read(client_fd, buf, 1024);
 
  handle_request(buf, client_fd);

  return 0;
}

