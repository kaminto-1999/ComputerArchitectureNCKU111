    #include <stdio.h>
    int main()
    {
        extern int mul1 ;
        extern int mul2 ;
        extern int _test_start;
        long long num1 = 0;
        long long num2 = 0;
        long long result_db;
        int a = *(&mul1);
        int b = *(&mul2);
        int result_l = a*b;
        *(&_test_start) = result_l;
        if (a<0){
            num1 = a|0xFFFFFFF00000000;
        } else num1 = a;
        if (b<0){
            num2 = b|0xFFFFFFF00000000;
        } else num2 = b;  
        result_db = num1*num2;
        int result_h = result_db >>32;
        *(&_test_start+1) = result_h;
        return 0;
    }