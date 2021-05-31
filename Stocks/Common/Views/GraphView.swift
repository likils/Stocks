//
//  GraphView.swift
//  Stocks
//
//  Created by likils on 27.05.2021.
//

import UIKit

class GraphView: UIView {
    
    // MARK: - Public properties
    var candles: CompanyCandles! {
        didSet {
            minPrice = candles.lowPrices.min()
            maxPrice = candles.highPrices.max()
            averagePrices = candles.highPrices.enumerated().map { index, highPrice in
                (highPrice + candles.lowPrices[index]) / 2
            }
            
            setNeedsDisplay()
        }
    }
    
    private(set) var minPrice: Double?
    private(set) var maxPrice: Double?
    
    // MARK: - Private properties
    private var averagePrices = [Double]()
    private let graphColor = UIColor.View.defaultAppColor
    private let cornerRadius = 16
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard candles != nil, candles.responseStatus == "ok" else { return }
        
        clipCorners(in: rect)
        let graphPath = drawGraph(in: rect)
        clipGradient(in: rect, withPath: graphPath)
        addGradient(in: rect)
    }
    
    // MARK: - Private methods
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    private func drawGraph(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        var xPoint = rect.minX
        let xStep = rect.maxX / CGFloat(averagePrices.count - 1)
        
        averagePrices.forEach {
            let yPoint = yPoint($0, in: rect)
            if $0 == averagePrices.first {
                path.move(to: CGPoint(x: xPoint, y: yPoint))
            } else {
                xPoint += xStep
                path.addLine(to: CGPoint(x: xPoint, y: yPoint))
            }
        }
        
        graphColor.setStroke()
        path.lineWidth = 1.4
        path.stroke()
        
        return path
    }
    
    private func yPoint(_ point: Double, in rect: CGRect) -> CGFloat {
        let diff = maxPrice! - point
        let divisor = (maxPrice! - minPrice!) / diff
        let yPoint = rect.maxY / CGFloat(divisor)
        return yPoint
    }
    
    private func clipCorners(in rect: CGRect) {
        let cornerPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        cornerPath.addClip()
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
        
        let startYPoint = yPoint(averagePrices.max()!, in: rect)
        
        let graphStartPoint = CGPoint(x: rect.minX, y: startYPoint)
        let graphEndPoint = CGPoint(x: rect.minX, y: rect.maxY)
        
        context.drawLinearGradient(
            gradient,
            start: graphStartPoint,
            end: graphEndPoint,
            options: [])
    }

}
