import UIKit
import SnapKit
import ActionSheetPicker_3_0

protocol SuggesterViewDelegate {
    func didSelect(values: Any?)
}

class SuggesterView {

    //MARK: - Properties

    var datasource: PickerDataSource?
    var delegate: SuggesterViewDelegate?
    var picker: ActionSheetMultipleStringPicker?
    var style = Style.light

    //ActionSheetPicker requires an array of arrays for its own datasource

    enum PickerDataSource: String {
        case weight = "Weight"
        case size = "Size"

        func fetchData() -> [[String]] {
            switch self {
            case .weight:
                return [["50 g", "100 g", "200 g", "300 g"]]
            case .size:
                return [["50 cm", "100 cm", "200 cm", "300 cm"]]
            }
        }

        func fetchSuggestions() -> [String] {
            switch self {
            case .weight:
                return ["50 g", "100 g", "200 g"]
            case .size:
                return ["50 cm", "100 cm", "200 cm"]

            }
        }
    }

    //MARK: - UI Configuration

    func presentPicker(_ sender: Any, datasource: PickerDataSource) {

        picker = ActionSheetMultipleStringPicker.init(title: datasource.rawValue,
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
            let item = SuggesterViewItem(title: title, style: style)
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

        suggester.backgroundColor = style.backgroundColor
    }

}

extension SuggesterView: SuggesterViewItemDelegate {
    func didSelect(title: String) {
        delegate?.didSelect(values: [title])
        picker?.hideWithCancelAction()
    }
}
