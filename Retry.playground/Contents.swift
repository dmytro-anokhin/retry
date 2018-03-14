/*

Copyright 2018 Dmytro Anokhin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

import Foundation

enum RetryError: Error {
    case generic
}

// Probability of success on every try in range of 0..100%
let probability = 5

// Number of times closure executed
var count = 0

// Results of the execution
var resultValue: Int?
var resultError: Error?

do {
    resultValue = try retry(times: 10, withDelay: 0.1) {
        
        // Throwing Closure
        
        count += 1
        
        let random = Int(arc4random_uniform(99)) + 1
        
        if random < probability {
            return 42
        }
        else {
            throw RetryError.generic
        }
    }
}
catch {
    resultError = error
}

print("Closure executed \(count) time(s) and the result is \( ( resultValue != nil ? String(describing: resultValue!) : "'\(resultError!) error'" ) )")
