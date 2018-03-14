# Retry for Swift exceptions

## Motivation

Sometimes, when a function throws an error, we want to repeat calling it, maybe with some delay. Here is example of such function:

```swift
// AVCaptureDevice
func lockForConfiguration() throws
```

This was the case for me when I needed to access the camera in one of my apps. I discovered that the camera may not be available right away due to multithreading or after using different camera app. And it makes sense to retry attempt to acquire the lock after a small delay.

```swift
do {
    // Try to acquire the lock of the system resource
    try resource.lockForConfiguration()
    // The lock acquired, perform operation with the system resource
    // ..
    // Release the lock
    resource.unlockForConfiguration()
}
catch {
    // Retry after delay
}
```

## Solution

Solution is pretty simple: wrap `do/catch` block in a loop, that repeats for some number of retries and every n milliseconds, and breaks when the function succeeds. Because the solution fits well similar cases and overall for clear code I created `retry` function.

```swift
@discardableResult
public func retry<T>(times retryCount: UInt = 0,
                      withDelay delay: TimeInterval = 0.0,
                            _ closure: () throws -> T) rethrows -> T
```

The function executes the closure till it succeeds or exceeds number of retries. It rethrows the exception catched at the final attempt to execute the closure. And returns the closure result. Using Swift generics lets the `retry` function conveniently infer return type from the closure.

## Usage

Here is the example of use for my case. This will repeat attempt to acquire the lock at least 11 times (initial attempt + 10 retries) with 100ms delay.

```swift
do {
    try retry(times: 10, withDelay: 0.1, {
        // Try to acquire the lock of the system resource.
        try resource.lockForConfiguration()
        // The lock acquired, perform operation with the system resource.
        // ..
        // Release the lock.
        resource.unlockForConfiguration()
    })
}
catch {
    // Handle error
}
```

This repository contains Swift 4.0 playground demonstrating the retry function. Future steps for this can be implementing simple exponential backoff algorithm for the delay.

---

2018 Dmytro Anokhin. MIT license.
