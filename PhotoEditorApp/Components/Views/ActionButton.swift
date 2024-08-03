//
//  ActionButton.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 03/08/24.
//

import Foundation
import SwiftUI

private enum Constants{
    static let color = Color.primary
    static let font = Font.system(size: 17)
    static let vOffset: CGFloat = 13.0
}

public struct ActionButton: View {
    
    private let title: String
    private let action: () -> Void

    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }
    @ViewBuilder
    public var body: some View {
        Button {
            action()
        } label: {
            HStack() {
                Text(title)
                    .font(Constants.font)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.backgroundPrimary)
            .padding(.vertical, Constants.vOffset)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primary)
            )
            .padding(.horizontal)
        }
    }
}
