//
//  WidgetDemoProtocol.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import UIKit
import SwiftUI


protocol WidgetDemo {
    var title: String { get }
    func makeUIKitView() -> UIView
    func makeSwiftUIView() -> AnyView
}
