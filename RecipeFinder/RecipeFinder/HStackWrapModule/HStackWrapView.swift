//
//  HStackWrapView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-03.
//

import SwiftUI

//https://stackoverflow.com/a/58876712/5049840
struct HStackWrapView<ViewModel>: View where ViewModel: HStackWrapViewModel {
    
    @ObservedObject var hStackWrapVM: ViewModel

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            let list = Array(self.hStackWrapVM.switchToggles.keys)
            ForEach(list, id: \.self) { item in
                self.item(for: item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == list.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if item == list.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }

    func item(for text: String) -> some View {
        Text(text)
            .padding([.all], 5)
            .font(.body)
            .background(hStackWrapVM.switchToggles[text] ?? false ? Color.inactiveRed : Color.red)
            .foregroundColor(Color.white)
            .cornerRadius(5)
            .onTapGesture {
                hStackWrapVM.isItemTapped(item: text)
            }
    }
}

//struct HStackWrapView_Previews: PreviewProvider {
//    static var previews: some View {
//        HStackWrapView(list: ["Ninetendo", "XBox", "PlayStation", "PlayStation 2", "PlayStation 3", "PlayStation 4"])
//            .previewLayout(.sizeThatFits)
//    }
//}
