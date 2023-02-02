//
//  DecimalUtil.swift
//  Bankey
//
//  Created by Felipe Vieira Lima on 02/02/23.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
