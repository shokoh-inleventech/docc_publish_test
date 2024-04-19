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

/// Enum that translates and replaces english characters into corresponding emoji.
public enum TextToEmojiTranslator {
    /// Check if the provided string has a corresponding emoji and return this emoji.
    /// - Parameter text: The string under test.
    /// - Returns: Return the corresponding emoji if exists.
    public static func checkEmoji(for text: String) -> String? {
        return textToEmoji[text]
    }

    /// Capture the last word in a string then check if it has a corresponding emoji then return this emoji.
    /// - Parameter text: The full string under text.
    /// - Returns: The input text after replacing the last word with an emoji ( if exists).
    public static func replaceLastWord(from text: String) -> String {
        if let lastWord = text.components(separatedBy: [" "]).last, !lastWord.isEmpty {
            if let emoji = textToEmoji[lastWord] {
                let newText = text.replacingOccurrences(of: lastWord, with: emoji)
                return (newText)
            } else {
                return text
            }
        } else {
            return text
        }
    }

    /// English strings and their corresponding emojis.
    public static let textToEmoji = [
        "<3": "❤️",
        ":*": "😘",
        ":D": "😃",
        "8D": "😄",
        "=D": "😍",
        ":->": "😊",
        "*<|:‑)": "🎅",
        ":E": "😬",
        "XD": "😂"
    ]
}
