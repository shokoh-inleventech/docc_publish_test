/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

public enum Validation {
    /// Check if the input string is valid compared to the specified regex.
    /// - Parameters:
    ///   - input: Input string under test.
    ///   - regex: The regex that compared to the input string.
    /// - Returns: True if the input string is valid compared to the specified regex and false otherwise.
    public static func isValid(input: String?, with regex: String) -> Bool {
        if let input = input {
            let test = NSPredicate(format: "SELF MATCHES %@", regex)
            return test.evaluate(with: input)
        }
        return false
    }

    /// Validate if the input string is not empty.
    /// - Parameter input: Input string under test.
    /// - Returns: True if the input string is not empty and false otherwise.
    public static func validateIsNonEmpty(for input: String?) -> String {
        let isNonEmptyText = input?.isEmpty ?? false
        let errorMessage = isNonEmptyText ? ValidationErrors.emptyText.rawValue : ""
        return errorMessage
    }

    /// Validate if the input string is a phone number.
    /// - Parameter input: Input string under test.
    /// - Returns: True if the input string is a phone number and false otherwise.
    public static func validateIsPhone(for input: String?) -> String {
        let emptyTextError = validateIsNonEmpty(for: input)
        if !emptyTextError.isEmpty {
            return emptyTextError
        } else {
            let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
            let isValidPhone = isValid(input: input, with: phoneRegex)
            let errorMessage = isValidPhone ? "" : ValidationErrors.phone.rawValue
            return errorMessage
        }
    }

    /// Validate if the input string is an email.
    /// - Parameter input: Input string under test.
    /// - Returns: True if the input string is an email and false otherwise.
    public static func validateIsEmail(for input: String?) -> String {
        let emptyTextError = validateIsNonEmpty(for: input)
        if !emptyTextError.isEmpty {
            return emptyTextError
        } else {
            let mailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let isValidEmail = isValid(input: input, with: mailRegex)
            let errorMessage = isValidEmail ? "" : ValidationErrors.email.rawValue
            return errorMessage
        }
    }
}
