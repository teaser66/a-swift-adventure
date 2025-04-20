//
//  Protocols.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import SwiftUI
import UIKit

protocol CodeShowable {
    var codeKey: String { get }
}

protocol WidgetDemo {
    var title: String { get }
    func makeUIKitView() -> UIView
    func makeSwiftUIView() -> AnyView
}

