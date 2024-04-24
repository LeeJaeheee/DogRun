//
//  CardStackView.swift
//  DogRun
//
//  Created by 이재희 on 4/22/24.
//

import SwiftUI

public struct CardStack<Data, Content>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View {
    @State private var currentIndex: Double = 0.0
    @State private var previousIndex: Double = 0.0
    
    private let data: Data
    @ViewBuilder private let content: (Data.Element) -> Content
    @Binding var finalCurrentIndex: Int
    
    public init(_ data: Data, currentIndex: Binding<Int> = .constant(0), @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.content = content
        _finalCurrentIndex = currentIndex
    }
    
    public var body: some View {
        ZStack {
            ForEach(Array(data.enumerated()), id: \.element.id) { (index, element) in
                content(element)
                    .zIndex(zIndex(for: index))
                    .offset(x: xOffset(for: index), y: 0)
                    .scaleEffect(scale(for: index), anchor: .center)
                    .rotationEffect(.degrees(rotationDegrees(for: index)))
            }
        }
        .highPriorityGesture(dragGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation(.interactiveSpring()) {
                    let x = (value.translation.width / 300) - previousIndex
                    self.currentIndex = -x
                }
            }
            .onEnded { value in
                self.snapToNearestAbsoluteIndex(value.predictedEndTranslation)
                self.previousIndex = self.currentIndex
            }
    }
    
    private func snapToNearestAbsoluteIndex(_ predictedEndTranslation: CGSize) {
        withAnimation(.interpolatingSpring(stiffness: 300, damping: 40)) {
            let translation = predictedEndTranslation.width
            if abs(translation) > 200 {
                if translation > 0 {
                    self.goTo(round(self.previousIndex) - 1)
                } else {
                    self.goTo(round(self.previousIndex) + 1)
                }
            } else {
                self.currentIndex = round(currentIndex)
            }
        }
    }
    
    private func goTo(_ index: Double) {
        let maxIndex = Double(data.count - 1)
        if index < 0 {
            self.currentIndex = 0
        } else if index > maxIndex {
            self.currentIndex = maxIndex
        } else {
            self.currentIndex = index
        }
        self.finalCurrentIndex = Int(self.currentIndex)
    }
    
    private func zIndex(for index: Int) -> Double {
        if (Double(index) + 0.5) < currentIndex {
            return -Double(data.count - index)
        } else {
            return Double(data.count - index)
        }
    }
    
    private func xOffset(for index: Int) -> CGFloat {
        let topCardProgress = currentPosition(for: index)
        let padding = 35.0
        let x = ((CGFloat(index) - currentIndex) * padding)
        if topCardProgress > 0 && topCardProgress < 0.99 && index < (data.count - 1) {
            return x * swingOutMultiplier(topCardProgress)
        }
        return x
    }
    
    private func scale(for index: Int) -> CGFloat {
        return 1.0 - (0.1 * abs(currentPosition(for: index)))
    }
    
    private func rotationDegrees(for index: Int) -> Double {
        return -currentPosition(for: index) * 2
    }
    
    private func currentPosition(for index: Int) -> Double {
        currentIndex - Double(index)
    }
    
    private func swingOutMultiplier(_ progress: Double) -> Double {
        return sin(Double.pi * progress) * 15
    }
}

/*
struct DemoItem {
    var id = UUID()
    var name: String
    var color: UIColor
}

class CardStackView: UIView {
    private var currentIndex: Double = 0.0
    private var previousIndex: Double = 0.0
    private var data: [DemoItem]
    private var contentViews: [UIView] = []
    var finalCurrentIndex: Int = 0
    
    init(frame: CGRect, data: [DemoItem]) {
        self.data = data
        super.init(frame: frame)
        setupCardStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCardStack() {
        for (index, item) in data.enumerated() {
            let cardView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width - CGFloat(index) * 35, height: 400))
            cardView.backgroundColor = item.color
            let nameLabel = UILabel(frame: CGRect(x: 50, y: 50, width: cardView.frame.width - 100, height: 50))
            nameLabel.text = item.name
            nameLabel.textColor = .white
            nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
            cardView.addSubview(nameLabel)
            addSubview(cardView)
            contentViews.append(cardView)
        }
        
        updateCardStack()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    
    private func updateCardStack() {
        for (index, view) in contentViews.enumerated() {
            let xOffset = (CGFloat(index) - currentIndex) * 35
            view.frame.origin.x = xOffset
            view.layer.zPosition = zIndex(for: index)
            let scale = self.scale(for: index)
            let rotationDegrees = self.rotationDegrees(for: index)
            view.transform = CGAffineTransform(rotationAngle: CGFloat(rotationDegrees * Double.pi / 180)).scaledBy(x: scale, y: scale)
        }
    }
    
    private func zIndex(for index: Int) -> CGFloat {
        if (CGFloat(index) + 0.5) < CGFloat(currentIndex) {
            return CGFloat(-data.count + index)
        } else {
            return CGFloat(data.count - index)
        }
    }
    
    private func scale(for index: Int) -> CGFloat {
        return 1.0 - (0.1 * abs(currentPosition(for: index)))
    }
    
    private func rotationDegrees(for index: Int) -> CGFloat {
        return -currentPosition(for: index) * 2
    }
    
    private func currentPosition(for index: Int) -> CGFloat {
        return CGFloat(currentIndex - Double(index))
    }
    
    private func swingOutMultiplier(_ progress: CGFloat) -> CGFloat {
        return sin(CGFloat.pi * progress) * 15
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let velocity = gesture.velocity(in: self)
        
        switch gesture.state {
        case .began:
            previousIndex = currentIndex
        case .changed:
            let scale = 1 - abs(translation.x) / bounds.width * 0.1
            contentViews[Int(currentIndex)].transform = CGAffineTransform(translationX: translation.x, y: 0).scaledBy(x: scale, y: scale)
            
            for i in 1..<contentViews.count {
                let nextIndex = Int(currentIndex) + i
                if nextIndex >= 0 && nextIndex < contentViews.count {
                    let scaleFactor = max(0, 1 - CGFloat(i) * 0.05)
                    contentViews[nextIndex].transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                }
            }
            
            for i in 1..<contentViews.count {
                let nextIndex = Int(currentIndex) - i
                if nextIndex >= 0 && nextIndex < contentViews.count {
                    let scaleFactor = max(0, 1 - CGFloat(i) * 0.05)
                    contentViews[nextIndex].transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
                }
            }
        case .ended:
            if abs(translation.x) > 100 || abs(velocity.x) > 500 {
                let direction: Int = translation.x > 0 ? -1 : 1
                let nextIndex = max(min(Int(currentIndex) + direction, contentViews.count - 1), 0)
                currentIndex = Double(nextIndex)
            }
            UIView.animate(withDuration: 0.3) {
                self.updateCardStack()
            }
        default:
            break
        }
    }
    
    private func snapToNearestAbsoluteIndex(_ translation: CGPoint) {
        let absTranslation = abs(translation.x)
        if absTranslation > 200 {
            if translation.x > 0 {
                goTo(round(Double(previousIndex)) - 1)
            } else {
                goTo(round(Double(previousIndex)) + 1)
            }
        } else {
            currentIndex = round(currentIndex)
        }
        UIView.animate(withDuration: 0.4) {
            self.updateCardStack()
        }
    }
    
    private func goTo(_ index: Double) {
        let maxIndex = Double(data.count - 1)
        if index < 0 {
            currentIndex = 0
        } else if index > maxIndex {
            currentIndex = maxIndex
        } else {
            currentIndex = index
        }
        finalCurrentIndex = Int(currentIndex)
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = [
            DemoItem(name: "Red", color: .red),
            DemoItem(name: "Orange", color: .orange),
            DemoItem(name: "Yellow", color: .yellow),
            DemoItem(name: "Green", color: .green),
            DemoItem(name: "Blue", color: .blue),
            DemoItem(name: "Purple", color: .purple)
        ]
        
        let cardStackView = CardStackView(frame: CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 400), data: items)
        view.addSubview(cardStackView)
    }
}
*/
