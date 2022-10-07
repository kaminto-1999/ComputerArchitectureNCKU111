#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
bool isLongPressedName(char *name, char *typed){
    int i = 0, j = 0;
    if(name[0]!=typed[0]) return false;
    while(i < strlen(name))
    {
        if(name[i] == typed[j]){
            j++; i++;
        }
        else{
            if(typed[j] == name[i-1])/* long typing */
                j++;
            else
                return false;
        }
    }
    while(j < strlen(typed))
    {
        if(typed[j++]!=name[strlen(name)-1])
            return false;
    }
    return true;
}

int main()
{    
    char name[] ="alex";
    char typed0[]="aalexx";
    char typed1[]="aalleexx";
    char typed2[]="aalewx";
    bool a;
    a= isLongPressedName(name,typed0);
    printf("a is %d \n",a);
    a= isLongPressedName(name,typed1);
    printf("a is %d \n",a);
    a= isLongPressedName(name,typed2);
    printf("a is %d \n",a);
}