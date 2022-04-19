// ----------------------------------------------------------------------------
//
//  GraphView.swift
//
//  @likils <likils@icloud.com>
//  Copyright (c) 2021. All rights reserved.
//
// ----------------------------------------------------------------------------

import StocksData
import StocksSystem
import UIKit

// ----------------------------------------------------------------------------

final class GraphView: UIView {

    // MARK: - Private Properties

    private var graphModel = GraphModel()

    // MARK: - Construction

    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func draw(_ rect: CGRect) {
        if !self.graphModel.prices.isEmpty {
            drawGraph(in: rect)
        }
    }

    func updateView(with graphModel: GraphModel) {
        self.graphModel = graphModel
        setNeedsDisplay()
    }

    // MARK: - Private Methods

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    private func drawGraph(in rect: CGRect) {

        UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Const.cornerRadii)
            .addClip()

        let path = UIBezierPath()
        drawGraph(in: rect, with: path)
        drawGradient(in: rect, with: path)
    }

    private func drawGraph(in rect: CGRect, with path: UIBezierPath) {
        let prices = self.graphModel.prices

        let xStep = rect.maxX / CGFloat(prices.count - 1)
        var xPoint = rect.minX

        let firstPrice = prices[0]
        var yPoint = calculateYPoint(for: firstPrice, in: rect)

        path.move(to: CGPoint(x: xPoint, y: yPoint))

        for price in prices[1...] {
            xPoint += xStep
            yPoint = calculateYPoint(for: price, in: rect)
            path.addLine(to: CGPoint(x: xPoint, y: yPoint))
        }

        StocksColor.brand.setStroke()
        path.lineWidth = Const.pathLineWidth
        path.stroke()
    }

    private func calculateYPoint(for price: Double, in rect: CGRect) -> CGFloat {
        let minPrice = self.graphModel.minPrice
        let maxPrice = self.graphModel.maxPrice

        if price == minPrice {
            return rect.maxY
        } else if price == maxPrice {
            return rect.minY
        } else {
            let diff = maxPrice - price
            let divisor = (maxPrice - minPrice) / diff
            let yPoint = rect.maxY / divisor
            return yPoint
        }
    }

    private func drawGradient(in rect: CGRect, with path: UIBezierPath) {
        guard let clippingPath = path.copy() as? UIBezierPath else { return }

        clippingPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        clippingPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        clippingPath.close()
        clippingPath.addClip()

        drawGradient(in: rect)
    }

    private func drawGradient(in rect: CGRect) {

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [StocksColor.brand.cgColor, UIColor.white.cgColor]
        let locations: [CGFloat] = [0.0, 1.0]

        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        else {
            return
        }

        let startPoint = CGPoint(x: rect.minX, y: rect.minY)
        let endPoint = CGPoint(x: rect.minX, y: rect.maxY)

        UIGraphicsGetCurrentContext()?.drawLinearGradient(
            gradient,
            start: startPoint,
            end: endPoint,
            options: []
        )
    }

// MARK: - Inner Types

    private enum Const {
        static let cornerRadii = CGSize(width: 16, height: 16)
        static let pathLineWidth: Double = 1.4
    }
}
