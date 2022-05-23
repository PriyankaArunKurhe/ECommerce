import Foundation
class ProductModel: Decodable {
    let image: String
    let title: String
    let description: String
    let rating: Rating
    init(image: String, title: String, description: String,rating: Rating) {
        self.image = image
        self.title = title
        self.rating = rating
        self.description = description
    }
}
class Rating: Decodable {
    
    var rate: Float?
    var count: Int
    init(rate: Float, count: Int)
    {
        self.rate = rate
        self.count = count
    }
}

