//
//  SuggesterViewItem.swift
//  ActionPickerClient
//
//  Created by Bryan A Bolivar M on 12/18/18.
//  Copyright © 2018 Dev. All rights reserved.
//

import UIKit

protocol SuggesterViewItemDelegate {
    func didSelect(title: String)
}

class SuggesterViewItem: UIView {
    let button: UIButton = UIButton(frame: CGRect.zero)
    let title: String
    var delegate: SuggesterViewItemDelegate?

    //MARK: - Required
    init(title: String, style: Style) {
        self.title = title
        super.init(frame: CGRect.zero)
        addSubview(button)

        button.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }

        button.setTitle(title, for: .normal)
        button.setTitleColor(style.backgroundColor, for: .highlighted)
        button.setTitleColor(style.textColor, for: .normal)

        let divider = UIView(frame: CGRect.zero)
        addSubview(divider)
        divider.backgroundColor = style.textColor
        divider.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(1)
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        button.addTarget(self, action: #selector(selectItem), for: .touchUpInside)
    }

    @objc func selectItem() {
        delegate?.didSelect(title: title)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

