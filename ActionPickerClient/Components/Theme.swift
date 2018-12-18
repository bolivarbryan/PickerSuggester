//
//  Theme.swift
//  ActionPickerClient
//
//  Created by Bryan A Bolivar M on 12/18/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

//MARK: - Enums

enum Style {
    case dark
    case light

    var backgroundColor: UIColor {
        switch self {
        case .dark:
            return .darkGray
        case .light:
            return .white
        }
    }

    var textColor: UIColor {
        switch self {
        case .dark:
            return .white
        case .light:
            return .darkGray
        }
    }

}

