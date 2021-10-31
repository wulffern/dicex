
#include <stdint.h>
#include <stdio.h>

int main(){

    uint32_t val = 1;
    uint32_t tmp = 0;

    for(int i=1;i<17;i++){
        tmp = val << i;
        printf("Shift right by %d = %d\n",i,tmp);
    }

    val = tmp;

    printf("New val %d\n",tmp);

    for(int i=1;i<17;i++){
        tmp = val >> i;
        printf("Shift left by %d = %d\n",i,tmp);
    }

}
