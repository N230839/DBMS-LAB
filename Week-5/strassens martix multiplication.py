def add(A, B):
    n = len(A)
    C = []
    for i in range(n):
        row = []
        for j in range(n):
            row.append(A[i][j] + B[i][j])
        C.append(row)
    return C

def sub(A, B):
    n = len(A)
    C = []
    for i in range(n):
        row = []
        for j in range(n):
            row.append(A[i][j] - B[i][j])
        C.append(row)
    return C

def strassen(A, B):
    n = len(A)

    if n == 1:
        return [[A[0][0] * B[0][0]]]

    m = n // 2

    A11 = [row[:m] for row in A[:m]]
    A12 = [row[m:] for row in A[:m]]
    A21 = [row[:m] for row in A[m:]]
    A22 = [row[m:] for row in A[m:]]

    B11 = [row[:m] for row in B[:m]]
    B12 = [row[m:] for row in B[:m]]
    B21 = [row[:m] for row in B[m:]]
    B22 = [row[m:] for row in B[m:]]

    P1 = strassen(A11, sub(B12, B22))
    P2 = strassen(add(A11, A12), B22)
    P3 = strassen(add(A21, A22), B11)
    P4 = strassen(A22, sub(B21, B11))
    P5 = strassen(add(A11, A22), add(B11, B22))
    P6 = strassen(sub(A12, A22), add(B21, B22))
    P7 = strassen(sub(A11, A21), add(B11, B12))

    C11 = add(sub(add(P5, P4), P2), P6)
    C12 = add(P1, P2)
    C21 = add(P3, P4)
    C22 = sub(sub(add(P5, P1), P3), P7)

    C = []

    for i in range(m):
        C.append(C11[i] + C12[i])

    for i in range(m):
        C.append(C21[i] + C22[i])

    return C

# Main Program

n = int(input("Enter order of matrix: "))

A = []
print("Enter Matrix A:")
for i in range(n):
    row = []
    for j in range(n):
        x = int(input())
        row.append(x)
    A.append(row)

B = []
print("Enter Matrix B:")
for i in range(n):
    row = []
    for j in range(n):
        x = int(input())
        row.append(x)
    B.append(row)

C = strassen(A, B)

print("Resultant Matrix:")
for i in range(n):
    for j in range(n):
        print(C[i][j], end=" ")
    print()