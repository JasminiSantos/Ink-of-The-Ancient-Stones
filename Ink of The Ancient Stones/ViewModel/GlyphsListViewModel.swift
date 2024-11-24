//
//  GlyphsListViewModel.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

class GlyphsListViewModel: ObservableObject {
    @Published var svgImages: [(fileName: String, image: UIImage)] = []
    private var svgDataStore = SVGDataStore()
    
    private var allFileNames: [String] = []
    let maxImagesToFetch = 9
    
    @Published var currentPage = 0 {
        didSet {
            svgImages = fetchSVGImagesForPage(page: currentPage)
        }
    }
    var numberOfPages: Int {
        allFileNames.count / maxImagesToFetch + (allFileNames.count % maxImagesToFetch > 0 ? 1 : 0)
    }
    
    init() {
        allFileNames = fetchSVGFileNamesFromResources()
        svgImages = fetchSVGImagesForPage(page: currentPage)
    }

    private func fetchSVGFileNamesFromResources() -> [String] {
        guard let resourceURL = Bundle.main.resourceURL else {
            print("Resource URL not found.")
            return []
        }
        let fileManager = FileManager.default
        do {
            let resourceContents = try fileManager.contentsOfDirectory(at: resourceURL, includingPropertiesForKeys: nil, options: [])
            let svgFiles = resourceContents.filter { $0.pathExtension == "svg" }
            return svgFiles.map { $0.deletingPathExtension().lastPathComponent }.sorted()
        } catch {
            print("Error while fetching SVG files: \(error)")
            return []
        }
    }
    
    func fetchSVGImagesForPage(page: Int)-> [(fileName: String, image: UIImage)]{
        let startIndex = page * maxImagesToFetch
        let endIndex = min(startIndex + maxImagesToFetch, allFileNames.count)
        let limitedFileNames = Array(allFileNames[startIndex..<endIndex])
        return limitedFileNames.compactMap { fileName in
            guard let image = svgDataStore.createImage(fromSVGNamed: fileName, size: CGSize(width: 300, height: 300)) else { return nil }
            return (fileName, image)
        }
    }
}
