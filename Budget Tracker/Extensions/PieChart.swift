//
//  PieChart.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-10.
//

import Foundation
import UIKit

struct Piece {

    /// the color of a particular piece
    var color: UIColor

    /// the usage of a particular piece – will be used to measure a ratio automatically
    var usage: CGFloat
}

class PieChartView: UIView {

    /// An array of structs representing the pieces of the pie chart
    var pieces = [Piece]() {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        let gctx = UIGraphicsGetCurrentContext()

        let radius = min(frame.size.width, frame.size.height) * 0.5

        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)

        let usageCount = pieces.reduce(0, {$0 + $1.usage})

     
        var startAngle = -CGFloat.pi * 0.5

        for piece in pieces { // loop through the values list

            gctx?.setFillColor(piece.color.cgColor)
            let endAngle = startAngle + 2 * .pi * (piece.usage / usageCount)

            gctx?.move(to: viewCenter)
            gctx?.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)

            gctx?.fillPath()

            startAngle = endAngle
        }
        
        self.backgroundColor = .white
    }
}
