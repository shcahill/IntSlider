//
//  IntSlider.swift
//  IntSlider
//
//  Created by kosuke matsumura on 2020/08/03.
//  Copyright © 2020 kosuke matsumura. All rights reserved.
//

import UIKit
import TinyConstraints

final class IntSlider: UISlider {
    private let labelSize: CGFloat = 4.0
    /// Slideの値変更通知(四捨五入して整数で通知されます)
    var onValueChanged: ((Int) -> Void)?
    private var labelList = [UIView]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setup(max: 1)
    }
    
    private func setup(max: Int) {
        minimumValue = 0
        maximumValue = Float(max)
        
        // リアルタイムの値変更通知
        addTarget(self, action: #selector(onChange), for: .valueChanged)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // つまみ部分以外でもスライド可能
        return true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        // スライド終了後に位置を調整する
        fixSliderPosition()
    }

    @objc func onChange(_ sender: UISlider) {
        // スライダーの値が変更された時の処理
        onValueChanged?(Int(round(sender.value)))
    }
    
    func updateMaxValue(_ max: Int) {
        maximumValue = Float(max)
        value = min(value, maximumValue)
        updateScaleLabel()
    }
}

private extension IntSlider {
    func fixSliderPosition() {
        let index = round(self.value)
        self.value = index
        onValueChanged?(Int(index))
    }
    
    /// 目盛りを貼りなおします
    func updateScaleLabel() {
        labelList.forEach({ $0.removeFromSuperview() })
        labelList.removeAll()
        let labelArea = UIStackView()
        labelArea.axis = .horizontal
        labelArea.distribution = .equalSpacing
        labelArea.alignment = .fill
        insertSubview(labelArea, at: 0)
        // trackの少し下方
        labelArea.centerYToSuperview(offset: 16)
        // 左右のマージン
        let offset = thumbCenterOffset
        labelArea.leadingToSuperview(offset: offset)
        labelArea.trailingToSuperview(offset: offset)
        let max = Int(maximumValue) + 1
        for _ in 0..<max {
            let label = createLabel()
            labelArea.addArrangedSubview(label)
            labelList.append(label)
        }
    }
    
    /// 目盛りViewの生成
    func createLabel() -> UIView {
        let label = UIView()
        label.backgroundColor = .black
        label.layer.cornerRadius = CGFloat(labelSize / 2)
        label.width(labelSize)
        label.height(labelSize)
        return label
    }
    
    /// trackの左右両端に対する、thumb中心X座標のマージン
    var thumbCenterOffset: CGFloat {
        let startOffset = trackBounds.origin.x
        let firstThumbPosition = positionX(at: 0)
        return firstThumbPosition - startOffset - labelSize / 2
    }
    
    /// [index]のときのthumbのX中心座標を取得します
    func positionX(at index: Int) -> CGFloat {
        let rect = thumbRect(forBounds: bounds, trackRect: trackBounds, value: Float(index))
        return rect.midX
    }
    
    var trackBounds: CGRect {
        return trackRect(forBounds: bounds)
    }
}
