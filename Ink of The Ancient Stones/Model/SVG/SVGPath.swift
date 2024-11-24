//
//  SVGPath.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

protocol SVGShape {
    func createBezierPath() -> UIBezierPath
}

struct SVGPath: SVGShape {
    var dAttribute: String
    
    func parsePathCommands(from dAttribute: String) -> [(command: String, points: [CGPoint])] {
        var result: [(command: String, points: [CGPoint])] = []
        
//        let pattern = "([MmZzLlHhVvCcSsQqTtAa])|(-?\\d+\\.?\\d*)"
//        let pattern = "([MmZzLlHhVvCcSsQqTtAa])|(-?\\d+(?:\\.\\d+)?(?:e[+-]?\\d+)?)"
        let pattern = "([MmZzLlHhVvCcSsQqTtAa])|([-+]?\\d*\\.?\\d+(?:[eE][-+]?\\d+)?|[-+]?\\.\\d+(?:[eE][-+]?\\d+)?)"

        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        let nsString = NSString(string: dAttribute)
        let matches = regex.matches(in: dAttribute, options: [], range: NSRange(location: 0, length: nsString.length))

        var currentCommand: String?
        var points: [CGPoint] = []
        var currentPoint: [CGFloat] = []

        for match in matches {
            let matchString = nsString.substring(with: match.range)
            
            if let _ = Double(matchString) {
                currentPoint.append(CGFloat(Double(matchString)!))
                if currentPoint.count == 2 {
                    points.append(CGPoint(x: currentPoint[0], y: currentPoint[1]))
                    currentPoint.removeAll()
                }
            } else {
                if let command = currentCommand {
                    result.append((command: command, points: points))
                }
                currentCommand = matchString
                points.removeAll()
            }
        }

        if let command = currentCommand {
            result.append((command: command, points: points))
        }

        return result
    }

    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.usesEvenOddFillRule = true
        let commands = parsePathCommands(from: dAttribute)
        var lastPoint: CGPoint = CGPoint(x: 0, y: 0)
        var lastControlPoint: CGPoint? = nil
        
        for (command, points) in commands {
            switch command {
            case "M":
                if let firstPoint = points.first {
                    path.move(to: firstPoint)
                    lastPoint = firstPoint
                }
            case "m":
                if let firstPoint = points.first {
                    let newPoint = CGPoint(x: lastPoint.x + firstPoint.x, y: lastPoint.y + firstPoint.y)
                    path.move(to: newPoint)
                    lastPoint = newPoint
                }
            case "L":
                for point in points {
                    path.addLine(to: point)
                    lastPoint = point
                }
            case "l":
                for point in points {
                    let newPoint = CGPoint(x: lastPoint.x + point.x, y: lastPoint.y + point.y)
                    path.addLine(to: newPoint)
                    lastPoint = newPoint
                }
            case "H":
                for x in points.map({ $0.x }) {
                    let newPoint = CGPoint(x: x, y: lastPoint.y)
                    path.addLine(to: newPoint)
                    lastPoint = newPoint
                }
            case "h":
                for dx in points.map({ $0.x }) {
                    let newPoint = CGPoint(x: lastPoint.x + dx, y: lastPoint.y)
                    path.addLine(to: newPoint)
                    lastPoint = newPoint
                }
            case "V":
                for y in points.map({ $0.y }) {
                    let newPoint = CGPoint(x: lastPoint.x, y: y)
                    path.addLine(to: newPoint)
                    lastPoint = newPoint
                }
            case "v":
                for dy in points.map({ $0.y }) {
                    let newPoint = CGPoint(x: lastPoint.x, y: lastPoint.y + dy)
                    path.addLine(to: newPoint)
                    lastPoint = newPoint
                }
            case "C":
                for i in stride(from: 0, to: points.count, by: 3) {
                    if i + 2 < points.count {
                        path.addCurve(to: points[i + 2], controlPoint1: points[i], controlPoint2: points[i + 1])
                        lastControlPoint = points[i + 1]
                        lastPoint = points[i + 2]
                    }
                }
            case "c":
                for i in stride(from: 0, to: points.count, by: 3) {
                    if i + 2 < points.count {
                        let endPoint = CGPoint(x: lastPoint.x + points[i + 2].x, y: lastPoint.y + points[i + 2].y)
                        let controlPoint1 = CGPoint(x: lastPoint.x + points[i].x, y: lastPoint.y + points[i].y)
                        let controlPoint2 = CGPoint(x: lastPoint.x + points[i + 1].x, y: lastPoint.y + points[i + 1].y)
                        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                        lastControlPoint = controlPoint2
                        lastPoint = endPoint
                    }
                }
            case "S":
                for i in stride(from: 0, to: points.count, by: 2) {
                    if i + 1 < points.count {
                        let controlPoint1 = lastControlPoint != nil ? CGPoint(x: 2 * lastPoint.x - lastControlPoint!.x, y: 2 * lastPoint.y - lastControlPoint!.y) : lastPoint
                        let controlPoint2 = points[i]
                        let endPoint = points[i + 1]
                        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                        lastControlPoint = controlPoint2
                        lastPoint = endPoint
                    }
                }
            case "s":
                for i in stride(from: 0, to: points.count, by: 2) {
                    if i + 1 < points.count {
                        let controlPoint1 = lastControlPoint != nil ? CGPoint(x: 2 * lastPoint.x - lastControlPoint!.x, y: 2 * lastPoint.y - lastControlPoint!.y) : lastPoint
                        let controlPoint2 = CGPoint(x: lastPoint.x + points[i].x, y: lastPoint.y + points[i].y)
                        let endPoint = CGPoint(x: lastPoint.x + points[i + 1].x, y: lastPoint.y + points[i + 1].y)
                        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                        lastControlPoint = controlPoint2
                        lastPoint = endPoint
                    }
                }
            case "Q":
                for i in stride(from: 0, to: points.count, by: 2) {
                    if i + 1 < points.count {
                        path.addQuadCurve(to: points[i + 1], controlPoint: points[i])
                        lastControlPoint = points[i]
                        lastPoint = points[i + 1]
                    }
                }
            case "q":
                for i in stride(from: 0, to: points.count, by: 2) {
                    if i + 1 < points.count {
                        let controlPoint = CGPoint(x: lastPoint.x + points[i].x, y: lastPoint.y + points[i].y)
                        let endPoint = CGPoint(x: lastPoint.x + points[i + 1].x, y: lastPoint.y + points[i + 1].y)
                        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
                        lastControlPoint = controlPoint
                        lastPoint = endPoint
                    }
                }
            case "A", "a":
                break
            case "Z", "z":
                path.close()
            default:
                print("Unsupported command \(command)")
                break
            }
        }
        path.close()
        return path
    }
}

struct SVGCircle: SVGShape {
    var center: CGPoint
    var radius: CGFloat

    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        return path
    }
}
    

struct SVGRectangle: SVGShape {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat

    func createBezierPath() -> UIBezierPath {
        return UIBezierPath(rect: CGRect(x: x, y: y, width: width, height: height))
    }
}

struct SVGPolygon: SVGShape {
    var points: [CGPoint]

    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.close()
        return path
    }
}

struct SVGPolyline: SVGShape {
    var points: [CGPoint]

    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        return path
    }
}

struct SVGLine: SVGShape {
    var x1: CGFloat
    var y1: CGFloat
    var x2: CGFloat
    var y2: CGFloat

    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x1, y: y1))
        path.addLine(to: CGPoint(x: x2, y: y2))
        return path
    }
}

struct SVGEllipse: SVGShape {
    var cx: CGFloat
    var cy: CGFloat
    var rx: CGFloat
    var ry: CGFloat

    func createBezierPath() -> UIBezierPath {
        let path = UIBezierPath(ovalIn: CGRect(x: cx - rx, y: cy - ry, width: 2 * rx, height: 2 * ry))
        return path
    }
}
