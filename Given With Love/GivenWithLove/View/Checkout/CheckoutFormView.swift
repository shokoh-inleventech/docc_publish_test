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

/// Checkout `Focusable` cases used to toggle focus inside ``CheckoutFormView``.
enum CheckoutFocusable: Hashable {
  case name
  case address
  case phone
}

/// Checkout form including recipient's data and payment method.
struct CheckoutFormView: View {
  @Binding var rootIsActive: Bool
  @State private var isShowingGiftMessageView = false
  @ObservedObject var checkoutViewModel: CheckoutViewModel
  @FocusState private var checkoutInFocus: CheckoutFocusable?

  @ViewBuilder var recipientDataView: some View {
    Section(header: Text("Recipient Data")) {
      EntryTextField(
        sfSymbolName: "person",
        placeHolder: "Name",
        prompt: checkoutViewModel.validateNamePrompt,
        field: $checkoutViewModel.checkoutData.recipientName
      )
        .focused($checkoutInFocus, equals: .name)
        .onAppear {
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.checkoutInFocus = .name
          }
        }

      EntryTextField(
        sfSymbolName: "house",
        placeHolder: "Address",
        prompt: checkoutViewModel.validateAddressPrompt,
        field: $checkoutViewModel.checkoutData.recipientAddress
      )
      .focused($checkoutInFocus, equals: .address)

      EntryTextField(
        sfSymbolName: "phone",
        placeHolder: "Phone",
        prompt: checkoutViewModel.validatePhonePrompt,
        field: $checkoutViewModel.checkoutData.recipientPhone
      )
      .keyboardType(.phonePad)
      .focused($checkoutInFocus, equals: .phone)
    }
    .onChange(of: checkoutInFocus) { checkoutViewModel.checkoutInFocus = $0 }
    .onChange(of: checkoutViewModel.checkoutInFocus) { checkoutInFocus = $0 }
  }

  /// Custom view showing the button leading to ``GiftMessageView``after all textfields ``CheckoutFormView`` inside are valid.
  @ViewBuilder var giftMessageButton: some View {
    ZStack {
      if checkoutViewModel.allFieldsValid {
        NavigationLink(
          destination: getNextNavigation(),
          isActive: $isShowingGiftMessageView
        ) {
          EmptyView()
        }
      }

      CustomButton(text: "Proceed to Gift Message") {
        checkoutViewModel.validateAllFields()
        isShowingGiftMessageView = true
      }
    }
  }

  /// Function that manages the device-specific navigation from this page. When using an `iPad`, the next view includes both the message view and the message preview on each page half, as opposed to just the message view on an `iPhone`.
  /// - Returns: The next navigation view.
  func getNextNavigation() -> AnyView {
    let giftMessageViewModel = GiftMessageViewModel(checkoutData: checkoutViewModel.checkoutData)

    if UIDevice.current.userInterfaceIdiom == .phone {
      return AnyView(GiftMessageView(rootIsActive: $rootIsActive, giftMessageViewModel: giftMessageViewModel))
    } else {
      return AnyView(HStack {
        GiftMessageView(rootIsActive: $rootIsActive, giftMessageViewModel: giftMessageViewModel)
        GiftMessagePreview(giftMessageViewModel: giftMessageViewModel)
      }.navigationViewStyle(.columns)
      )
    }
  }

  var body: some View {
    VStack {
      Form {
        recipientDataView
        Section(header: Text("Payment Method")) {
          Toggle(isOn: self.$checkoutViewModel.checkoutData.payWithCash) {
            Text("Pay with cash")
          }
        }
        .navigationTitle("Checkout Form")
        .navigationBarTitleDisplayMode(.inline)
      }

      giftMessageButton
    }
    .onSubmit {
      checkoutViewModel.toggleFocus()
    }
  }
}

struct CheckoutFormView_Previews: PreviewProvider {
  static var previews: some View {
    let gift = Gift(name: "Watch", price: 100)
    let checkoutViewModel = CheckoutViewModel(checkoutData: CheckoutData(gift: gift))
    CheckoutFormView(rootIsActive: .constant(false), checkoutViewModel: checkoutViewModel)
  }
}
