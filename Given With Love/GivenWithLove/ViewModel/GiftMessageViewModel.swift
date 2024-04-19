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

import SwiftUI
import GivenWithLoveHelper

/// Gifts message view model that handles adding new ``CheckoutData/recipientEmails``, toggling focus between message views, validate textfields, and replace english text with its corresponding emoji.
class GiftMessageViewModel: ObservableObject {
  // MARK: - Variables
  @Published var checkoutData: CheckoutData
  // swiftlint: disable array_constructor
  @Published var recipientEmails = [RecipientEmail(email: "")]
  // swiftlint: enable array_constructor
  @Published var giftMessageInFocus: GiftMessageFocusable?
  @Published var suggestedEmoji = ""

  init(checkoutData: CheckoutData) {
    self.checkoutData = checkoutData
  }

  // MARK: - Intent(s)

  /// Add new ``CheckoutData/recipientEmails`` for the recipient.
  func addNewEmail() {
    let newEmail = RecipientEmail(email: "")
    recipientEmails.append(newEmail)
    giftMessageInFocus = .row(id: newEmail.id)
  }

  /// Toggle focus between ``GiftMessageView`` email textfields by changing **FocusState** variable. The view release focus if it reaches the last email textfield.
  func toggleFocus() {
    guard let currentFocus = recipientEmails.first(where: { giftMessageInFocus == .row(id: $0.id) }) else { return }
    for index in recipientEmails.indices where currentFocus.id == recipientEmails[index].id {
      if index == recipientEmails.indices.count - 1 {
        giftMessageInFocus = nil
      } else {
        giftMessageInFocus = .row(id: recipientEmails[index + 1].id)
      }
    }
  }

  // MARK: Validation

  /// Validate that the message textfield is not empty.
  var validateMessagePrompt: String {
    return Validation.validateIsNonEmpty(for: checkoutData.giftMessage)
  }

  /// Validate that all email textfields in ``GiftMessageView`` have valid emails.
  var validateEmailsPrompts: [UUID: String] {
    return recipientEmails.reduce([UUID: String]()) { dict, recipientEmail in
      var dict = dict
      dict[recipientEmail.id] = Validation.validateIsEmail(for: recipientEmail.email)
      return dict
    }
  }

  /// Validate all textfields inside ``GiftMessageView``. Set focus to first invalid textfield.
  /// - Returns: True if all textfields is valid and false otherwise.
  func validateFields() -> Bool {
    if !validateMessagePrompt.isEmpty {
      giftMessageInFocus = .message
      return false
    } else {
      for (key, value) in validateEmailsPrompts where !value.isEmpty {
        giftMessageInFocus = .row(id: key)
        return false
      }
      giftMessageInFocus = nil
      return true
    }
  }

  /// Check if the last word of the ``CheckoutData/giftMessage``corresponds to an emoji and if so then replace it with its corresponding emoji.
  func checkTextToEmoji() {
    if let lastWord = checkoutData.giftMessage.components(separatedBy: [" "]).last, !lastWord.isEmpty {
      if let emoji = TextToEmojiTranslator.checkEmoji(for: lastWord) {
        suggestedEmoji = emoji
      } else {
        suggestedEmoji = ""
      }
    } else {
      suggestedEmoji = ""
    }
  }
}
