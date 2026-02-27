//
//  FontFamilyType.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 7/14/25.
//

import SwiftUI

public protocol FontFamilyType {
  associatedtype Weight: CaseIterable & RawRepresentable where Weight.RawValue == String

  var `extension`: FontFileExtension { get }
  static var name: String { get }
}
