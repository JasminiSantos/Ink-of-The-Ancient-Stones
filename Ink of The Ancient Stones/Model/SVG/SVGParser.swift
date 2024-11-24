//
//  SVGParser.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import Foundation
import SwiftUI

class SVGParser: NSObject, XMLParserDelegate {
    var shapes: [SVGShape] = []
    
    private var currentElement: String = ""
    private var currentPathDAttribute: String = ""
    
    func loadSVGPathFromFile(named fileName: String) -> [SVGShape] {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "svg") else {
            fatalError("Failed to find \(fileName).svg in the app bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data from \(fileName).svg")
        }

        return parse(data: data)
    }

    func parse(data: Data) -> [SVGShape] {
        self.shapes = []
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return shapes
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        switch elementName {
        case "path":
            if let d = attributeDict["d"] {
                currentPathDAttribute = d
            }
        case "circle":
            if let cxString = attributeDict["cx"],
               let cyString = attributeDict["cy"],
               let rString = attributeDict["r"],
               let cx = Double(cxString),
               let cy = Double(cyString),
               let r = Double(rString) {
                let circle = SVGCircle(center: CGPoint(x: cx, y: cy), radius: CGFloat(r))
                shapes.append(circle)
            }
        case "rect":
            if let xString = attributeDict["x"],
               let yString = attributeDict["y"],
               let widthString = attributeDict["width"],
               let heightString = attributeDict["height"],
               let x = Double(xString),
               let y = Double(yString),
               let width = Double(widthString),
               let height = Double(heightString) {
                let rectangle = SVGRectangle(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
                shapes.append(rectangle)
            }
        case "ellipse":
            if let cxString = attributeDict["cx"],
               let cyString = attributeDict["cy"],
               let rxString = attributeDict["rx"],
               let ryString = attributeDict["ry"],
               let cx = Double(cxString),
               let cy = Double(cyString),
               let rx = Double(rxString),
               let ry = Double(ryString) {
                    let ellipse = SVGEllipse(cx: CGFloat(cx), cy: CGFloat(cy), rx: CGFloat(rx), ry: CGFloat(ry))
                    shapes.append(ellipse)
                }
        case "line":
            if let x1String = attributeDict["x1"],
               let y1String = attributeDict["y1"],
               let x2String = attributeDict["x2"],
               let y2String = attributeDict["y2"],
               let x1 = Double(x1String),
               let y1 = Double(y1String),
               let x2 = Double(x2String),
               let y2 = Double(y2String) {
                let line = SVGLine(x1: CGFloat(x1), y1: CGFloat(y1), x2: CGFloat(x2), y2: CGFloat(y2))
                shapes.append(line)
            }
        case "polygon", "polyline":
            if let pointsString = attributeDict["points"] {
                let points = pointsString.split(separator: " ").compactMap { pointString -> CGPoint? in
                    let coords = pointString.split(separator: ",").compactMap { Double($0) }
                    guard coords.count == 2 else { return nil }
                    return CGPoint(x: coords[0], y: coords[1])
                }
                if elementName == "polygon" {
                    let polygon = SVGPolygon(points: points)
                    shapes.append(polygon)
                } else {
                    let polyline = SVGPolyline(points: points)
                    shapes.append(polyline)
                }
            }
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
            case "path":
                let path = SVGPath(dAttribute: currentPathDAttribute)
                shapes.append(path)
                currentPathDAttribute = ""
            default:
                break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parse error: \(parseError.localizedDescription)")
    }

    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
