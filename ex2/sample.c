int even (int num, int i){
    return num << i;
}
int go (int A[10]) {
    int sum = 0;
    int i = 0;
    while (i < 10) {
        if (A[i] % 2 == 0) {
            int num = even (A[i], i);
            sum += num;
        } else {
            sum += A[i];
        }
        i++;
    }
    return sum;
}