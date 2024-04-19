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

/// Gifts view model that handles choosing one ``Gift`` to be sent to recipient.
class GiftsViewModel: ObservableObject {
  // MARK: - Variables
  @Published var gifts = [
    Gift(name: "Bracelet", price: 100),
    Gift(name: "Camera", price: 500),
    Gift(name: "Earbud", price: 200),
    Gift(name: "Headphone", price: 100),
    Gift(name: "Makeup Bag", price: 5000),
    Gift(name: "Perfume", price: 300),
    Gift(name: "Phone case", price: 40),
    Gift(name: "Playstation", price: 10),
    Gift(name: "Watch", price: 80)
  ]

  var chosenGift: Gift?

  // MARK: - Intent(s)

  /// Choose a ``Gift`` from the gifts list.
  /// - Parameter gift: The ``Gift`` selected by user.
  func chooseGift(gift: Gift) {
    for index in gifts.indices {
      if gift.id == gifts[index].id {
        gifts[index].isChosenGift = true
        chosenGift = gift
      } else {
        gifts[index].isChosenGift = false
      }
    }
  }
}
