//
//  Decimal+Extension.swift
//  flexair
//
//  Created by Nikolai on 08/12/2025.
//

import Foundation

extension Decimal {
    /// To Convert Decimal Price to Int
    var intValue: Int {
        NSDecimalNumber(decimal: self).intValue
    }
}
