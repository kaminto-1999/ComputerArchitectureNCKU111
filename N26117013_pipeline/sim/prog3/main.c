    #include <stdio.h>
int gcd(int n1, int n2) {
    if (n2 != 0)
        return gcd(n2, n1 % n2);
    else
        return n1;
    }
int main()
{
    extern int div1 ;
    extern int div2 ;
    extern int _test_start; 
    unsigned int a, b;
    a = *(&div1);
    b = *(&div2);
    int c = gcd(a,b);
    *(&_test_start) = c;
    return 0;
}