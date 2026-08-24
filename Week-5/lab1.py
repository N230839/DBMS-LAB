def insertion_sort(arr):
    n = len(arr)
    for i in range(1,n):
        key = arr[i]
        j=i-1
        while j>=0 and arr[j]>key:
            arr[j+1] = arr[j]
            j=j-1
        arr[j+1] = key
n = int(input("Enter no.of elements:"))
arr = []
for i in range(n):
    x=int(input("Enter element:"))
    arr.append(x)
insertion_sort(arr)
print("Sorted array:")
print(arr)