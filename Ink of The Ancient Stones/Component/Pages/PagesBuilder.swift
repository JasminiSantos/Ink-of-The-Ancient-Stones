//
//  PagesBuilder.swift
//  Ink of The Ancient Stones
//
//  Created by Jasmini Rebecca Gomes dos Santos on 28/03/24.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
@resultBuilder
public struct PagesBuilder {


    public static func buildBlock<C0: View>(
        _ c0: C0) -> [AnyView] {
        [AnyView(c0)]
    }

    public static func buildBlock<C0: View, C1: View>(_ c0: C0, _ c1: C1) -> [AnyView] {
        [AnyView(c0), AnyView(c1)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2), AnyView(c3)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2), AnyView(c3), AnyView(c4)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2), AnyView(c3), AnyView(c4), AnyView(c5)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2), AnyView(c3), AnyView(c4), AnyView(c5), AnyView(c6)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2), AnyView(c3), AnyView(c4), AnyView(c5), AnyView(c6), AnyView(c7)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2), AnyView(c3), AnyView(c4), AnyView(c5), AnyView(c6), AnyView(c7), AnyView(c8)]
    }

    public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8,
        _ c9: C9) -> [AnyView] {
        [AnyView(c0), AnyView(c1), AnyView(c2), AnyView(c3), AnyView(c4), AnyView(c5), AnyView(c6), AnyView(c7), AnyView(c8), AnyView(c9)]
    }
}
