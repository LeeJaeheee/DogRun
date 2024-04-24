//
//  CardStackViewWrapper.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import SwiftUI
import UIKit

struct CardStackWrapper<Data, Content>: UIViewControllerRepresentable where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    typealias UIViewControllerType = UIHostingController<CardStack<Data, Content>>
    
    let data: Data
    let currentIndex: Binding<Int>
    let content: (Data.Element) -> Content
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let hostingController = UIHostingController(rootView: CardStack(data, currentIndex: currentIndex, content: content))
        return hostingController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.rootView = CardStack(data, currentIndex: currentIndex, content: content)
    }
}
