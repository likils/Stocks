//
//  GraphView.swift
//  Stocks
//
//  Created by likils on 27.05.2021.
//

import UIKit

class GraphView: UIView {
    
    // MARK: - Public properties
    var candles: CandlesModel! {
        didSet {
            minPrice = candles.lowPrices.min() ?? 0
            maxPrice = candles.highPrices.max() ?? 0
            setNeedsDisplay()
        }
    }
    private(set) var minPrice: Double = 0
    private(set) var maxPrice: Double = 0
    
    // MARK: - Private properties
    private var maxAveragePrice: Double = 0
    
    private let graphColor = UIColor.View.defaultAppColor
    private let viewCornerRadius = 16
    
    // MARK: - Construction
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard candles != nil else { return }
        
        clipCorners(in: rect)
        let graphPath = drawGraph(in: rect)
        clipGradient(in: rect, withPath: graphPath)
        addGradient(in: rect)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    private func clipCorners(in rect: CGRect) {
        let cornerPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: viewCornerRadius, height: viewCornerRadius)
        )
        cornerPath.addClip()
    }
    
    private func drawGraph(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        var averagePricePoints = candles.highPrices.enumerated().map { ($1 + candles.lowPrices[$0]) / 2 }
        maxAveragePrice = averagePricePoints.max() ?? 0
        
        let xStep = rect.maxX / CGFloat(averagePricePoints.count - 1)
        
        var xPoint = rect.minX
        var yPoint = calculateYPoint(averagePricePoints.removeFirst(), in: rect) // remove first point cause it's a start point
        path.move(to: CGPoint(x: xPoint, y: yPoint))
        
        averagePricePoints.forEach {
            xPoint += xStep
            yPoint = calculateYPoint($0, in: rect)
            path.addLine(to: CGPoint(x: xPoint, y: yPoint))
        }
        
        graphColor.setStroke()
        path.lineWidth = 1.4
        path.stroke()
        
        return path
    }
    
    private func calculateYPoint(_ point: Double, in rect: CGRect) -> CGFloat {
        if point == minPrice {
            return rect.maxY
        } else if point == maxPrice {
            return rect.minY
        } else {
            let diff = maxPrice - point
            let divisor = (maxPrice - minPrice) / diff
            let yPoint = rect.maxY / CGFloat(divisor)
            return yPoint
        }
    }
    
    private func clipGradient(in rect: CGRect, withPath path: UIBezierPath) {
        guard let clippingPath = path.copy() as? UIBezierPath else { return }
        
        clippingPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        clippingPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        clippingPath.close()
        clippingPath.addClip()
    }
    
    private func addGradient(in rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let colors = [graphColor.cgColor, UIColor.white.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: colors as CFArray,
                locations: colorLocations)
        else { return }
        
        let startYPoint = calculateYPoint(maxAveragePrice, in: rect)
        
        let graphStartPoint = CGPoint(x: rect.minX, y: startYPoint)
        let graphEndPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        context.drawLinearGradient(
            gradient,
            start: graphStartPoint,
            end: graphEndPoint,
            options: [])
    }

}
