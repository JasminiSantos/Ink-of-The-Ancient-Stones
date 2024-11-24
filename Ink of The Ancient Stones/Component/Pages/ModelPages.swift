//
//  ModelPages.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import SwiftUI

@available(iOS 13.0, *)
public struct ModelPages<Data, Content>: View where Data: RandomAccessCollection, Content: View {

    @Binding var currentPage: Int
    @Binding var backPageTransitionDisabled: Bool
    @Binding var nextPageTransitionDisabled: Bool
    
    var items: [Data.Element]

    private var template: (Int, Data.Element) -> Content
    private var navigationOrientation: UIPageViewController.NavigationOrientation
    private var transitionStyle: UIPageViewController.TransitionStyle
    private var bounce: Bool
    private var wrap: Bool
    private var hasControl: Bool
    private var pageControl: UIPageControl? = nil
    private var controlAlignment: Alignment


    public init(
        _ items: Data,
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
        template: @escaping (Int, Data.Element) -> Content
    ) {
        self._currentPage = currentPage
        self.navigationOrientation = navigationOrientation
        self.transitionStyle = transitionStyle
        self.bounce = bounce
        self.wrap = wrap
        self.hasControl = hasControl
        self.pageControl = control
        self.controlAlignment = controlAlignment
        self.items = items.map { $0 }
        self.template = template
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
                controllers: (0..<items.count).map { i in
                    let h = UIHostingController(rootView: template(i, items[i]))
                    h.view.backgroundColor = CustomColors.customBeige.uicolor
                    return h
                }
            )
            if self.hasControl {
                PageControl(
                    numberOfPages: items.count,
                    pageControl: pageControl,
                    currentPage: $currentPage
                ).padding()
            }
        }
    }

}
