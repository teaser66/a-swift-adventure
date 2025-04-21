//
//  SwiftUICodeWrapper.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/21/25.
//

import SwiftUI

class SwiftUICodeWrapper<Content: View>: UIHostingController<Content>, CodeShowable {
    var codeKey: String = ""

    init(rootView: Content, codeKey: String) {
        self.codeKey = codeKey
        super.init(rootView: rootView)
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
