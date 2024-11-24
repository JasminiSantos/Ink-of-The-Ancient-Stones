//
//  PageControl.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

@available(iOS 13.0, *)
internal struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    var pageControl: UIPageControl?
    @Binding var currentPage: Int

    func makeCoordinator() -> PageControlCoordinator {
        PageControlCoordinator(self)
    }

    func makeUIView(context: Context) -> UIPageControl {
        if let control = self.pageControl {
            return control
        } else {
            let control = UIPageControl()
            control.numberOfPages = numberOfPages
            control.addTarget(
                context.coordinator,
                action: #selector(Coordinator.updateCurrentPage(sender:)),
                for: .valueChanged
            )
            return control
        }
    }

    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = self.currentPage
    }

}

@available(iOS 13.0, *)
class PageControlCoordinator: NSObject {
    var control: PageControl

    init(_ control: PageControl) {
        self.control = control
    }

    @objc
    func updateCurrentPage(sender: UIPageControl) {
        control.currentPage = sender.currentPage
    }
}
