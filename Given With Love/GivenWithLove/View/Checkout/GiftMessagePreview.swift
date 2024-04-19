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

/// Gift message preview showing how the message written by user appears inside a frame.
struct GiftMessagePreview: View {
  @ObservedObject var giftMessageViewModel: GiftMessageViewModel
  @FocusedBinding(\.messageValue) var messageValue

  /// Custom view showing suggested emoji to replace the last word in the message in case it has a corresponding emoji value.
  @ViewBuilder var emojiSuggestionView: some View {
    HStack {
      Button {
        if let message = messageValue {
          messageValue = TextToEmojiTranslator.replaceLastWord(from: message)
        }
      } label: {
        HStack {
          Text("Suggested Emoji: ")
          Text(giftMessageViewModel.suggestedEmoji)
          Spacer()
        }
      }
      .padding()
    }
  }

  var body: some View {
    VStack {
      Text("Gift Message Preview")
        .foregroundColor(Color("rw-dark"))
        .font(.title3.weight(.bold))
        .padding()
      ZStack {
        GeometryReader { geometry in
          Image("Gift Card Background")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
        Text(messageValue ?? "There is no message")
          .padding()
          .onChange(of: messageValue) { _ in
            giftMessageViewModel.checkTextToEmoji()
          }
      }

      emojiSuggestionView
    }
  }
}

struct GiftMessagePreview_Previews: PreviewProvider {
  static var previews: some View {
    let gift = Gift(name: "Watch", price: 100)
    let giftMessageViewModel = GiftMessageViewModel(checkoutData: CheckoutData(gift: gift))
    GiftMessagePreview(giftMessageViewModel: giftMessageViewModel)
  }
}
