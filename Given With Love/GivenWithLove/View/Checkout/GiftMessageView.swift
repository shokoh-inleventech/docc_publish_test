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

/// Gift message `Focusable` cases used to toggle focus inside ``GiftMessageView``.
enum GiftMessageFocusable: Hashable {
  case message
  case row(id: UUID)
}

/// Gift message view including ``CheckoutData/giftMessage`` that user send to ``CheckoutData/recipientEmails``.
struct GiftMessageView: View {
  @Binding var rootIsActive: Bool
  @ObservedObject var giftMessageViewModel: GiftMessageViewModel
  @FocusState private var giftMessageInFocus: GiftMessageFocusable?
  @State private var showingAlert = false

  @ViewBuilder var recipientEmailsView: some View {
    Section(header: Text("Recipient Emails")) {
      List {
        ForEach($giftMessageViewModel.recipientEmails) { recipientEmail in
          EntryTextField(
            sfSymbolName: "envelope",
            placeHolder: "Recipient Email",
            prompt: giftMessageViewModel.validateEmailsPrompts[recipientEmail.id] ?? "",
            field: recipientEmail.email
          )
          .font(.body)
          .keyboardType(.emailAddress)
          .focused($giftMessageInFocus, equals: .row(id: recipientEmail.id))
        }
      }

      Button {
        giftMessageViewModel.addNewEmail()
      } label: {
        HStack {
          Image(systemName: "plus.circle.fill")
            .font(.system(size: 16, weight: .bold))
          Text("Add new email")
          Spacer()
        }
      }
      .padding()
    }
  }

  var body: some View {
    VStack {
      Form {
        Section(header: Text("Gift Message")) {
          TextEditor(text: $giftMessageViewModel.checkoutData.giftMessage)
            .font(.body)
            .focused($giftMessageInFocus, equals: .message)
            .focusedValue(\.messageValue, $giftMessageViewModel.checkoutData.giftMessage)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.giftMessageInFocus = .message
              }
            }
          Text(giftMessageViewModel.validateMessagePrompt)
            .fixedSize(horizontal: false, vertical: true)
            .font(.caption)
        }

        recipientEmailsView
      }
      .onSubmit {
        giftMessageViewModel.toggleFocus()
      }
      .onChange(of: giftMessageInFocus) { giftMessageViewModel.giftMessageInFocus = $0 }
      .onChange(of: giftMessageViewModel.giftMessageInFocus ) { giftMessageInFocus = $0 }

      CustomButton(text: "Send the Gift") {
        if giftMessageViewModel.validateFields() {
          showingAlert = true
        }
      }
      .alert("Congratulations. \n Your gift is on its way.", isPresented: $showingAlert) {
        Button("OK") {
          rootIsActive = false
        }
      }
    }
#if os(iOS)
  .navigationTitle("Gift Message")
  .navigationBarTitleDisplayMode(.inline)
#endif
  }
}

struct GiftMessageView_Previews: PreviewProvider {
  static var previews: some View {
    let gift = Gift(name: "Watch", price: 100)
    let giftMessageViewModel = GiftMessageViewModel(checkoutData: CheckoutData(gift: gift))
    GiftMessageView(rootIsActive: .constant(false), giftMessageViewModel: giftMessageViewModel)
  }
}
