import UIKit
import ActionSheetPicker_3_0

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showPicker(_ sender: Any) {
        let s = SuggesterView()
        s.presentPicker(sender, datasource: .size)
    }
}

