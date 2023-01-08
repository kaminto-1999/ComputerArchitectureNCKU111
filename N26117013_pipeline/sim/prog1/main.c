#include <stdio.h>
int main()
    {
        extern int array_addr ;
        extern int array_size ;
        extern int _test_start;
        int array[64];
        int i, j, a;
        for (i = 0; i < array_size; i++){
            array[i] = *(&array_addr + i);
        }
        for (i = 0; i < array_size; ++i) 
        {
            for (j = i + 1; j < array_size; ++j)
            {
                if (array[i] > array[j]) 
                {
                    a =  array[i];
                    array[i] = array[j];
                    array[j] = a;
                }
            }
        }
        for (i = 0; i < array_size; i++){
            *(&_test_start + i) = array[i];
        }
        return 0;
    }