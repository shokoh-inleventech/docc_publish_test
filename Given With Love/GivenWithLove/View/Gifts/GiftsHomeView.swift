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

/// Home view showing ``Gift`` grid view and the checkout button.
struct GiftsHomeView: View {
  @ObservedObject var giftsViewModel: GiftsViewModel
  @State var isActive = false

  @ViewBuilder var checkoutButton: some View {
    if let chosenGift = giftsViewModel.chosenGift {
      let checkoutViewModel = CheckoutViewModel(checkoutData: CheckoutData(gift: chosenGift))
      let checkoutFormView = CheckoutFormView(rootIsActive: $isActive, checkoutViewModel: checkoutViewModel)
      NavigationLink(
        destination: checkoutFormView,
        isActive: $isActive) {
          EmptyView()
      }
    }
    CustomButton(text: "Checkout") {
      if giftsViewModel.chosenGift != nil {
        isActive = true
      }
    }
    .disabled(giftsViewModel.chosenGift == nil)
  }

  var body: some View {
    NavigationView {
      VStack {
        GiftsGridView(giftsViewModel: giftsViewModel)
        checkoutButton
      }
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Choose your gift")
            .foregroundColor(Color("rw-dark"))
            .font(.title3.weight(.bold))
        }
      }
    }
  }
}

struct GiftsView_Previews: PreviewProvider {
  static var previews: some View {
    let giftsViewModel = GiftsViewModel()
    GiftsHomeView(giftsViewModel: giftsViewModel)
  }
}
