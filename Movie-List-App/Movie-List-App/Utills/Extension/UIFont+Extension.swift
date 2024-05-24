//
//  UIFont+Extension.swift
//  Movie-List-App
//
//  Created by Doogie on 5/24/24.
//

import UIKit

extension UIFont {
    enum Family: String {
        case SemiBold, Regular, Bold
    }
    
    static func pretendard(_ family: Family, _ size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-\(family)", size: size) ?? UIFont.preferredFont(forTextStyle: .body)
    }
}

