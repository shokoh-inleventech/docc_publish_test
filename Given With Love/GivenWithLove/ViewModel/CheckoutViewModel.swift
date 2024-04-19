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

/// Checkout view model that handles toggling focus between ``CheckoutData`` views, and validate textfields.
class CheckoutViewModel: ObservableObject {
  // MARK: - Variables
  @Published var checkoutData: CheckoutData
  @Published var allFieldsValid = false
  @Published var checkoutInFocus: CheckoutFocusable?

  init(checkoutData: CheckoutData) {
    self.checkoutData = checkoutData
  }

  // MARK: - Intent(s)

  /// Toggle focus between checkout views by changing  `checkoutInFocus` variable inside ``CheckoutFormView``.
  func toggleFocus() {
    if checkoutInFocus == .name {
      checkoutInFocus = .address
    } else if checkoutInFocus == .address {
      checkoutInFocus = .phone
    } else if checkoutInFocus == .phone {
      checkoutInFocus = nil
    }
  }

  // MARK: Validation

  var validateNamePrompt: String {
    return Validation.validateIsNonEmpty(for: checkoutData.recipientName)
  }

  var validateAddressPrompt: String {
    return Validation.validateIsNonEmpty(for: checkoutData.recipientAddress)
  }

  var validatePhonePrompt: String {
    return Validation.validateIsPhone(for: checkoutData.recipientPhone)
  }

  /// Validate all textfields in ``CheckoutFormView``. Set focus on first invalid textfield.
  func validateAllFields() {
    let isNameValid = validateNamePrompt.isEmpty
    let isAddressValid = validateAddressPrompt.isEmpty
    let isPhoneValid = validatePhonePrompt.isEmpty

    allFieldsValid = isNameValid && isAddressValid && isPhoneValid

    if !isNameValid {
      checkoutInFocus = .name
    } else if !isAddressValid {
      checkoutInFocus = .address
    } else if !isPhoneValid {
      checkoutInFocus = .phone
    }
  }
}
