//
//  HTMLText.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 2/12/25.
//


import SwiftUI
import WebKit

struct AttributedText: UIViewRepresentable {
    private let attributedString: NSAttributedString

    init(_ attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }

    func makeUIView(context: Context) -> UITextView {
    
        let uiTextView = UITextView()

        uiTextView.backgroundColor = .clear

        uiTextView.isEditable = false

        uiTextView.isScrollEnabled = false
        uiTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiTextView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiTextView.setContentCompressionResistancePriority(.required, for: .vertical)
        uiTextView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return uiTextView
    }

    func updateUIView(_ uiTextView: UITextView, context: Context) {

        uiTextView.attributedText = attributedString
    }
}



