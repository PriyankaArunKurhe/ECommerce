import UIKit
class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var productTableView: UITableView!
    //MARK: Variables and Array
    var rate: Float?
    var count: Int?
    var productArray: [ProductModel] = []
    //MARK: ViewController Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productTableView.dataSource = self
        self.productTableView.delegate = self
        let nibFile = UINib(nibName: "ItemsTableViewCell", bundle: nil)
        self.productTableView.register(nibFile, forCellReuseIdentifier: "ItemsTableViewCell")
        self.title = "Items"
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productTableView.reloadData()
    }
    //MARK: URLSession Method
    func fetchData() {
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error received from URL is: \(error)")
            } else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else {
                          print("Data is invalid OR Status code is not proper")
                          return
                      }
                do{
                    self.productArray = try JSONDecoder().decode([ProductModel].self,
                                                                 from: data)
                    DispatchQueue.main.async {
                        self.productTableView.reloadData()
                    }
                }catch let myError {
                    print("Got error while converting Data to JSON - \(myError.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
}
//MARK: DataSource Protocol
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.productTableView.dequeueReusableCell(withIdentifier: "ItemsTableViewCell") as? ItemsTableViewCell else
        {
            return  UITableViewCell()
        }
        cell.layer.borderWidth = 3.0
        let productIndexPoath = productArray[indexPath.row]
        cell.titleLabel.text = productIndexPoath.title
        let rateFloat = String(format: "%.2f", productIndexPoath.rating.rate!)
        cell.ratingLabel.text = rateFloat
        cell.countLabel.text = String(productIndexPoath.rating.count )
        let img = productIndexPoath.image
        let imageURL = URL(string: img)!
        cell.productImage.downloadImage(from: imageURL)
        return cell
    }
}
//MARK: Delegate Protocol
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        430
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        let descriptionToPass = productArray[indexPath.row].description
        secondVC!.containerDescription = descriptionToPass
        let ratingToPass = String(format: "%.2f", productArray[indexPath.row].rating.rate!)
        secondVC!.containerRating = Float(ratingToPass)
        let countToPass = productArray[indexPath.row].rating.count
        secondVC?.containerCount = Int(countToPass)
        self.navigationController?.pushViewController(secondVC!, animated: true)
        secondVC?.passDataClosure = { [weak self] (ratingFromVC2) in
            if ratingFromVC2! <= 5 {
                self!.productArray[indexPath.row].rating.rate =  Float(ratingFromVC2!)
            }
        }
    }
}
//MARK: UIImage
extension UIImageView {
    func downloadImage(from url: URL){
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        dataTask.resume()
    }
}
