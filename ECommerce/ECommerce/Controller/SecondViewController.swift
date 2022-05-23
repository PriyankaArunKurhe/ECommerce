import UIKit
class SecondViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingTF: UITextField!
    @IBOutlet weak var countTF: UITextField!
    @IBOutlet weak var editButton: UIButton!
    //MARK: Container Variables for FDP
    var containerDescription: String?
    var containerRating: Float?
    var containerCount: Int?
    //MARK: Closure Declaration
    var passDataClosure: ((Float?) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = containerDescription
        ratingTF.text = String(containerRating!)
        countTF.text = String(containerCount!)
        self.navigationItem.hidesBackButton = true
        self.title = "Product Description"
    }
    //MARK: Button Action Method
    @IBAction func editButton(_ sender: Any) {
        guard let closure = passDataClosure else {
            return
        }
        let ratingToPass = Float((self.ratingTF.text)!)
        if ratingToPass! > 6
        {
            ratingLimitAlert()
        } else {
        closure(ratingToPass)
        succededAlert()
        }
    }
    @IBAction private func backButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    private func ratingLimitAlert(){
        let dialogMessage = UIAlertController(title: "Failed", message: "Rating Should be less than 5", preferredStyle: .alert)
        let edit = UIAlertAction(title: "Ok", style: .default, handler: nil)
        dialogMessage.addAction(edit)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    private func succededAlert(){
        let dialogMessage = UIAlertController(title: "Succeded", message: "Rating Updated", preferredStyle: .alert)
        let edit = UIAlertAction(title: "Ok", style: .default, handler: nil)
        dialogMessage.addAction(edit)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

