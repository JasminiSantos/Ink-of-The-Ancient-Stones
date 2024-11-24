//
//  ImageComparator.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI
import Vision

class ImageComparator: ObservableObject {
    @Published var points: String = ""
    @Published var contouredImage: UIImage? = nil
    @Published var currentScore: Double = .infinity
    @Published var initialScore: Double = .infinity
    @Published var showingOverlay: OverlayType? = nil
    
    private var blankImage: UIImage? = nil
    @Published var processing: Bool = false

    func detectVisionContours(selectedImage: UIImage, simplified: Bool = false, epsilon: Float = 0.003, completion: @escaping (UIImage) -> Void) {
        guard let cgImage = selectedImage.cgImage else {
            print("UIImage must have an underlying CGImage for contour detection.")
            completion(selectedImage)
            return
        }

        let inputCIImage = CIImage(cgImage: cgImage)
        let contourRequest = VNDetectContoursRequest()
        contourRequest.revision = VNDetectContourRequestRevision1
        contourRequest.contrastAdjustment = 1.5
        contourRequest.detectDarkOnLight = true
        contourRequest.maximumImageDimension = 512

        let requestHandler = VNImageRequestHandler(ciImage: inputCIImage, options: [:])

        do {
            try requestHandler.perform([contourRequest])
            if let contoursObservation = contourRequest.results?.first as? VNContoursObservation {
                let contouredImage = self.drawContours(on: cgImage, using: contoursObservation, simplified: simplified, epsilon: epsilon)
                DispatchQueue.main.async {
                    self.contouredImage = contouredImage
                    completion(contouredImage)
                }
            } else {
                DispatchQueue.main.async {
                    print("No contours were detected.")
                    completion(selectedImage)
                }
            }
        } catch {
            DispatchQueue.main.async {
                print("Failed to perform contour detection: \(error)")
                completion(selectedImage)
            }
        }
    }

    public func drawContours(on sourceImage: CGImage, using observation: VNContoursObservation, simplified: Bool, epsilon: Float = 0.003) -> UIImage {
        let size = CGSize(width: sourceImage.width, height: sourceImage.height)
        let renderer = UIGraphicsImageRenderer(size: size)

        let renderedImage = renderer.image { context in
            let renderingContext = context.cgContext
            
            renderingContext.translateBy(x: 0, y: size.height)
            renderingContext.scaleBy(x: 1, y: -1)

            renderingContext.draw(sourceImage, in: CGRect(origin: .zero, size: size))

            renderingContext.setStrokeColor(UIColor.black.cgColor)
            renderingContext.setLineWidth(2.0)

            for i in 0..<observation.contourCount {
                guard let contour = try? observation.contour(at: i) else { continue }
                let contourToDraw = simplified ? (try? contour.polygonApproximation(epsilon: epsilon)) ?? contour : contour
                
                let path = CGMutablePath()
                let points = contourToDraw.normalizedPoints
                guard let firstPoint = points.first else { continue }

                path.move(to: CGPoint(x: CGFloat(firstPoint.x) * CGFloat(size.width), y: CGFloat(firstPoint.y) * CGFloat(size.height)))

                for point in points.dropFirst() {
                    path.addLine(to: CGPoint(x: CGFloat(point.x) * CGFloat(size.width), y: CGFloat(point.y) * CGFloat(size.height)))
                }

                path.closeSubpath()

                renderingContext.addPath(path)
                renderingContext.strokePath()
            }
        }

        return renderedImage
    }

    private func compareImages(image1: UIImage, image2: UIImage) -> Double {
        guard let features1 = extractFeatures(from: image1),
              let features2 = extractFeatures(from: image2) else {
            return 0.0
        }

        return calculateSimilarity(features1: features1, features2: features2)
    }

    private func extractFeatures(from image: UIImage) -> VNFeaturePrintObservation? {
        guard let cgImage = image.cgImage else { return nil}

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        request.usesCPUOnly = true
        
        do {
            try requestHandler.perform([request])
            if let result = request.results?.first as? VNFeaturePrintObservation {
                print("Feature extraction successful for image")
                return result
            } else {
                print("Feature extraction returned no result")
                return nil
            }
        } catch {
            print("Failed to perform feature print request: \(error)")
            return nil
        }
    }

    private func calculateSimilarity(features1: VNFeaturePrintObservation, features2: VNFeaturePrintObservation) -> Double {
        var distance = Float(0)
        do {
            try features1.computeDistance(&distance, to: features2)
            print("Computed distance: \(distance)")
        } catch {
            print("Error in computing distance: \(error)")
        }
        return Double(distance)
    }
    
    func getComparisonScore(originalImage1: UIImage, originalImage2: UIImage, backgroundColor: UIColor = .white, completion: @escaping (_ initialScore: Double, _ currentScore: Double) -> Void) {
        let blankImage = createBlankImage(withSize: originalImage2.size, backgroundColor: backgroundColor)
        
        let bgImage2 = addBackgroundToImage(image: originalImage2, backgroundColor: backgroundColor)
        
        detectVisionContours(selectedImage: bgImage2, simplified: true) { simplifiedSVGImage in
            let initialComparisonScore = self.compareImages(image1: simplifiedSVGImage, image2: blankImage)
            DispatchQueue.main.async {
                self.initialScore = initialComparisonScore
                print("Initial Comparison Score (SVG to Blank): \(initialComparisonScore)")
                
                let bgImage1 = self.addBackgroundToImage(image: originalImage1, backgroundColor: backgroundColor)
                self.detectVisionContours(selectedImage: bgImage1, simplified: false) { simplifiedDrawingImage in
                    let currentComparisonScore = self.compareImages(image1: simplifiedSVGImage, image2: simplifiedDrawingImage)
                    DispatchQueue.main.async {
                        self.currentScore = currentComparisonScore
                        self.showingOverlay = .score
                        print("Current Comparison Score (SVG to Drawing): \(currentComparisonScore)")
                        completion(initialComparisonScore, currentComparisonScore)
                    }
                }
            }
        }
    }



    
    func getScorePercentage() -> Double {
        guard self.initialScore > 0 else { return 0.0 }

        let proportionalDifference = (self.initialScore - self.currentScore) / self.initialScore

        let percentageScore = max(0, min(proportionalDifference * 100, 100))

        return percentageScore
    }

    private func addBackgroundToImage(image: UIImage, backgroundColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        backgroundColor.setFill()
        let rect = CGRect(origin: .zero, size: image.size)
        UIRectFill(rect)
        image.draw(in: rect)
        let imageWithBackground = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithBackground ?? image
    }
    
    func createBlankImage(withSize size: CGSize, backgroundColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let blankImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return blankImage
    }
}
