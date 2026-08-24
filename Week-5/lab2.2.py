def quick_sort(arr,low,high):
    if low < high:
        p = partition(arr,low,high)
        quick_sort(arr,low,p-1)
        quick_sort(arr,p+1,high)
def partition(arr,low,high):
    pivot = arr[low]
    left = low+1
    right = high
    while True:
        while left <= right and arr[left] <= pivot:
            left +=1
        while left <= right and arr[right] > pivot:
            right -=1
        if left > right:
            break
        arr[left],arr[right] = arr[right],arr[left]
    arr[low],arr[right] = arr[right],arr[low]
    return right

# Main Program
n = int(input("Enter number of elements: "))

arr = []

for i in range(n):
    x = int(input("Enter element: "))
    arr.append(x)

quick_sort(arr, 0, n - 1)

print("Sorted array:")
print(arr)