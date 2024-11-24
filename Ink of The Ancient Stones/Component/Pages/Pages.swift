//
//  Pages.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

@available(iOS 13.0, *)
public struct Pages: View {

    @Binding var currentPage: Int
    @Binding var backPageTransitionDisabled: Bool
    @Binding var nextPageTransitionDisabled: Bool
    
    var pages: [AnyView]

    var navigationOrientation: UIPageViewController.NavigationOrientation
    var transitionStyle: UIPageViewController.TransitionStyle
    var bounce: Bool
    var wrap: Bool
    var hasControl: Bool
    var pageControl: UIPageControl? = nil
    var controlAlignment: Alignment

    public init(
        currentPage: Binding<Int>,
        backPageTransitionDisabled: Binding<Bool>,
        nextPageTransitionDisabled: Binding<Bool>,
        navigationOrientation: UIPageViewController.NavigationOrientation = .horizontal,
        transitionStyle: UIPageViewController.TransitionStyle = .scroll,
        bounce: Bool = true,
        wrap: Bool = false,
        hasControl: Bool = true,
        control: UIPageControl? = nil,
        controlAlignment: Alignment = .bottom,
        @PagesBuilder pages: () -> [AnyView]
    ) {
        self.navigationOrientation = navigationOrientation
        self.transitionStyle = transitionStyle
        self.bounce = bounce
        self.wrap = wrap
        self.hasControl = hasControl
        self.pageControl = control
        self.controlAlignment = controlAlignment
        self.pages = pages()
        self._currentPage = currentPage
        self._backPageTransitionDisabled = backPageTransitionDisabled
        self._nextPageTransitionDisabled = nextPageTransitionDisabled
    }

    public var body: some View {
        ZStack(alignment: self.controlAlignment) {
            PageViewController(
                currentPage: $currentPage,
                backPageTransitionDisabled: $backPageTransitionDisabled,
                nextPageTransitionDisabled: $nextPageTransitionDisabled,
                navigationOrientation: navigationOrientation,
                transitionStyle: transitionStyle,
                bounce: bounce,
                wrap: wrap,
                controllers: pages.map {
                    let h = UIHostingController(rootView: $0)
                    h.view.backgroundColor = CustomColors.customPaperBeige.uicolor
                    return h
                }
            )
            if self.hasControl {
                PageControl(
                    numberOfPages: pages.count,
                    pageControl: pageControl,
                    currentPage: $currentPage
                ).padding()
            }
        }
    }
}
