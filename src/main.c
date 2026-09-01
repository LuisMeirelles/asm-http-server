#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>

#define ENDPOINT_POSITION_IN_REQUEST 2

#define ORIGEM_SOCKET 1
#define ORIGEM_BIND   2
#define ORIGEM_LISTEN 3
#define ORIGEM_ACCEPT 4

extern void listen(uint16_t port, const char *(*handler)(char*));

const char *parse_request(char *buf)
{
  char *endpoint;

  int i;
  char *str;

  for (i = 0, str = buf; i < ENDPOINT_POSITION_IN_REQUEST; i++, str = NULL)
    endpoint = strtok(str, " \n");

  if (strcmp(endpoint, "/ping") == 0) {
    const char *response =
        "HTTP/1.1 200 OK\r\n"
        "Content-Type: text/plain\r\n"
        "Content-Length: 4\r\n"
        "\r\n"
        "pong";

    return response;
  }

  return "";
}

int main(void)
{
  listen(8001, parse_request);
  return 0;
}

