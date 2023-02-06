//
//  RangedSliderView.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-06.
//

import SwiftUI

//https://stackoverflow.com/a/72774150/5049840
struct RangedSliderView<ViewModel>: View where ViewModel: RangedSliderViewModel {
    @ObservedObject var viewModel: ViewModel
    @State private var isActive: Bool = false
    
    let width = Constants.ScreenSize.width
    
    let sliderPositionChanged: (ClosedRange<Float>) -> Void

    var body: some View {
        GeometryReader { geometry in
            sliderView(sliderSize: geometry.size,
                       sliderViewYCenter: geometry.size.height / 2)
            
            let rangeEnd = viewModel.sliderPosition.upperBound
            let rangeBegin = viewModel.sliderPosition.lowerBound
            
            Text("Time: \(rangeBegin, specifier: "%0.f") min to \(rangeEnd, specifier: "%.0f") min")
                .font(.footnote)
                .padding([.top], 40)
                .position(x: geometry.frame(in: .local).midX)
                .foregroundColor(.red)
        }
        .frame(width: width - 30, height: 5)
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize, sliderViewYCenter: CGFloat) -> some View {
        lineBetweenThumbs(
            from: viewModel.leftThumbLocation(
                width: sliderSize.width,
                sliderViewYCenter: sliderViewYCenter
            ), to: viewModel.rightThumbLocation(
                width: sliderSize.width,
                sliderViewYCenter: sliderViewYCenter)
        )

        thumbView(
            position: viewModel.leftThumbLocation(
                width: sliderSize.width,
                sliderViewYCenter: sliderViewYCenter
            ), value: Float(viewModel.sliderPosition.lowerBound)
        )
        .highPriorityGesture(DragGesture()
            .onChanged { dragValue in
                let newValue = viewModel.newThumbLocation(
                    dragLocation: dragValue.location,
                    width: sliderSize.width
                )
            
            if newValue < viewModel.sliderPosition.upperBound {
                viewModel.sliderPosition = newValue...viewModel.sliderPosition.upperBound
                sliderPositionChanged(viewModel.sliderPosition)
                isActive = true
            }
        })

        thumbView(
            position: viewModel.rightThumbLocation(
                width: sliderSize.width,
                sliderViewYCenter: sliderViewYCenter
            ), value: Float(viewModel.sliderPosition.upperBound)
        )
        .highPriorityGesture(DragGesture()
            .onChanged { dragValue in
                let newValue = viewModel.newThumbLocation(
                    dragLocation: dragValue.location,
                    width: sliderSize.width
                )
            
            if newValue > viewModel.sliderPosition.lowerBound {
                viewModel.sliderPosition = viewModel.sliderPosition.lowerBound...newValue
                sliderPositionChanged(viewModel.sliderPosition)
                isActive = true
            }
        })
    }

    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.inactiveRed)
                .frame(height: 4)

            Path { path in
                path.move(to: from)
                path.addLine(to: to)
            }
            .stroke(.red, lineWidth: 4)
            
        }
    }

    @ViewBuilder func thumbView(position: CGPoint, value: Float) -> some View {
     Circle()
        .frame(width: 24, height: 24)
        .foregroundColor(.red)
        .contentShape(Rectangle())
        .position(x: position.x, y: position.y)
        .animation(.spring(), value: isActive)
    }
}

struct RangedSliderView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = RangedSliderViewModelImp(
            sliderPosition: 10...45,
            sliderBounds: 5...120
        )
        
        RangedSliderView(
            viewModel: viewModel,
            sliderPositionChanged: { _ in }
        )
    }
}
