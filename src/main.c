#include <stdio.h>
#include <stdint.h>

extern int listen(uint16_t port);

int main(void)
{
  int client_fd = listen(8001);

  printf("%d\n", client_fd);
  
  // parse
  // resposta

  return 0;
}
