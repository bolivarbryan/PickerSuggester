import UIKit
import SnapKit
import ActionSheetPicker_3_0

protocol SuggesterViewDelegate {
    func didSelect(values: Any?)
}

class SuggesterView {

    enum Style {
        case dark
        case light
    }

    enum PickerDataSource {
        case weight
        case meters

        //ActionSheetPicker requires an array of arrays for its own datasource
        func fetchData() -> [[String]] {
            switch self {
            case .weight:
                return [["50 g", "100 g", "200 g", "300 g"]]
            case .meters:
                return [["50 cm", "100 cm", "200 cm", "300 cm"]]
            }
        }

        func fetchSuggestions() -> [String] {
            switch self {
            case .weight:
                return ["50 g", "100 g", "200 g"]
            case .meters:
                return ["50 cm", "100 cm", "200 cm"]

            }
        }
    }

    var datasource: PickerDataSource?
    var delegate: SuggesterViewDelegate?
    var picker: ActionSheetMultipleStringPicker?

    //MARK: - UI Configuration

    func presentPicker(_ sender: Any, datasource: PickerDataSource) {

        picker = ActionSheetMultipleStringPicker.init(title: "aaa",
                                                                rows: datasource.fetchData(),
                                                                initialSelection: [2],
                                                                doneBlock: { picker, indexes, values in
                                                                    self.delegate?.didSelect(values: values)
                                                                    return
        },
                                                                cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)


        guard let picker = self.picker else {
            assertionFailure("A picker instance should be implemented before to continue")
            return
        }

        let suggester = UIView(frame: CGRect.zero)
        picker.configuredPickerView()
        picker.show()
        picker.toolbar.superview?.addSubview(suggester)
        suggester.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.bottom.equalTo(picker.toolbar.snp.top)
            $0.left.right.equalToSuperview()
        }

        //Transforming data for suggesterView
        let items = datasource.fetchSuggestions().map( { title -> SuggesterViewItem in
            let item = SuggesterViewItem(title: title)
            item.delegate = self
            return item
        })

        //FixMe: removing last divider for keeping a good style. suggestion: add dividers in stackview too or use a for loop instead of map
        items.last?.subviews.last?.removeFromSuperview()

        let stackView = UIStackView(arrangedSubviews: items)
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.axis = .horizontal
        suggester.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.top.equalToSuperview()
        }
        suggester.backgroundColor = .darkGray
    }
}

extension SuggesterView: SuggesterViewItemDelegate {
    func didSelect(title: String) {
        delegate?.didSelect(values: [title])
        picker?.hideWithCancelAction()
    }
}

protocol SuggesterViewItemDelegate {
    func didSelect(title: String)
}

class SuggesterViewItem: UIView {
    let button: UIButton = UIButton(frame: CGRect.zero)
    let title: String
    var delegate: SuggesterViewItemDelegate?

    //MARK: - Required
    init(title: String) {
        self.title = title
        super.init(frame: CGRect.zero)
        addSubview(button)

        button.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }

        button.setTitle(title, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)

        let divider = UIView(frame: CGRect.zero)
        addSubview(divider)
        divider.backgroundColor = .lightGray
        divider.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(0.5)
            $0.right.equalToSuperview()
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

