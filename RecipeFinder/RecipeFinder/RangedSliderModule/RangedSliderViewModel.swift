//
//  RangedSliderViewModel.swift
//  RecipeFinder
//
//  Created by Isiah Marie Ramos Malit on 2023-02-06.
//

import Foundation
import SwiftUI

protocol RangedSliderViewModel: ObservableObject {
    var sliderPosition: ClosedRange<Float> { get set }
    func leftThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat) -> CGPoint
    func rightThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat) -> CGPoint
    func newThumbLocation(dragLocation: CGPoint, width: CGFloat) -> Float
}

//https://stackoverflow.com/a/72774150/5049840
class RangedSliderViewModelImp: RangedSliderViewModel {
    @Published var sliderPosition: ClosedRange<Float>
    let sliderBounds: ClosedRange<Int>

    let sliderBoundDifference: Int

    init(sliderPosition: ClosedRange<Float>,
         sliderBounds: ClosedRange<Int>) {
        self.sliderPosition = sliderPosition
        self.sliderBounds = sliderBounds
        self.sliderBoundDifference = sliderBounds.count - 1
    }

    func leftThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat = 0) -> CGPoint {
        let sliderLeftPosition = CGFloat(sliderPosition.lowerBound - Float(sliderBounds.lowerBound))
        return .init(x: sliderLeftPosition * stepWidthInPixel(width: width),
                     y: sliderViewYCenter)
    }

    func rightThumbLocation(width: CGFloat, sliderViewYCenter: CGFloat = 0) -> CGPoint {
        let sliderRightPosition = CGFloat(sliderPosition.upperBound - Float(sliderBounds.lowerBound))
        
        return .init(x: sliderRightPosition * stepWidthInPixel(width: width),
                     y: sliderViewYCenter)
    }

    func newThumbLocation(dragLocation: CGPoint, width: CGFloat) -> Float {
        let xThumbOffset = min(max(0, dragLocation.x), width)
        let exact = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel(width: width))
        return 15*((exact/15.0).rounded())
    }

    private func stepWidthInPixel(width: CGFloat) -> CGFloat {
        width / CGFloat(sliderBoundDifference)
    }
}
