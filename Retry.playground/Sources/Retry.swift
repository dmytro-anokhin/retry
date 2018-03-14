/*

Copyright 2018 Dmytro Anokhin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/


import Foundation


/**
    Executes the closure, that throws an exception, till it succeeds or exceeds number of retries.
    The closure is executed at least once. In worst scenario the closure is executed `retryCount` + 1.
 
    - parameters:
        - retryCount: Number of retries after the first one.
        - delay: Delay between retries in seconds.
        - closure: The closure to execute.
 
    - throws:
    The exception catched at the final attempt to execute the closure. Exceptions catched during previous retries are ignored.
 
    - returns:
    Result returned from the closure.
*/
@discardableResult
public func retry<T>(times retryCount: UInt = 0, withDelay delay: TimeInterval = 0.0, _ closure: () throws -> T) rethrows -> T {

    // Retry executing the closure with delay till the last attempt
    if retryCount > 0 {
        for _ in 1...retryCount {
            do {
                return try closure()
            }
            catch {
                Thread.sleep(forTimeInterval: delay)
            }
        }
    }
    
    // Last attempt to execute the closure
    return try closure()
}
