//
//  CSLogButtton.swift
//  CSLogButtton
//
//  Created by 정민영 on 2021/08/07.
//

import UIKit

public enum CSLogType: Int{
    case basic
    case title
    case tag
}

public class CSButton: UIButton {
    public var logType: CSLogType = .basic
 
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        self.tintColor = .blue
        self.addTarget(self, action: #selector(logging(_:)), for: .touchUpInside)
    }
    
    @objc func logging(_ sender: UIButton) {
        switch self.logType {
        case .basic:
            NSLog("버튼이 눌렸습니다.")
        case .title:
            let btnTitle = sender.titleLabel?.text ?? "타이틀이 없음"
            NSLog(" \(btnTitle)버튼이 클릭되었습니다.")
        case .tag:
            NSLog("\(sender.tag) 버튼이 클릭되었습니다.")
        }
    }
}
