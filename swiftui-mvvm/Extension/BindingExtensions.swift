//
//  BindingExtensions.swift
//  swiftui-mvvm
//
//  Created by Cicero Camargo on 17/09/20.
//  Copyright © 2020 Cicero Camargo. All rights reserved.
//

import Foundation
import SwiftUI

extension Binding {
    init<ObjectType: AnyObject>(
        to path: ReferenceWritableKeyPath<ObjectType, Value>,
        on object: ObjectType
    ) {
        self.init(
            get: { object[keyPath: path] },
            set: { object[keyPath: path] = $0 }
        )
    }
}

