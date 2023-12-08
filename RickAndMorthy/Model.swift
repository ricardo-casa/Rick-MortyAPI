import Foundation
import UIKit

protocol ViewModelDelegate: AnyObject {
    func shouldRealoadTable()
}

class ViewModel {
    
    // MARK: Delegate
    weak var delegate: ViewModelDelegate?
    
    // MARK: Variables
    private var characters: [Character] = []
    private var info: Info? = nil
    private let restClient = RESTClient<PaginatedResponse<Character>>(client: Client("https://rickandmortyapi.com"))
    
    // MARK: Pagination variables
    /// no logre settear el valor haciendo una espera al objeto info de la API
    private var numberOfPages: Int = 42
    private var currentPage: Int = 1
    
    // MARK: Cell Configuration
    let cellIdentifier = "characterCell"
    let cellSize: CGFloat = 180
    
    init() {
        loadCharacters(onPage: self.currentPage)
    }
    
    func loadCharacters(onPage page:Int) {
        restClient.show("/api/character", page: String(page)) { response in
            self.info = response.info
            self.characters = response.results
            self.delegate?.shouldRealoadTable()
        }
    }
    
    // MARK: Pagination funcs
    func getNumberOfPages() -> Double {
        print(numberOfPages)
        return Double(numberOfPages)
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func setCurrentPage(_ page: Int) {
        currentPage = page
    }
    
    
    // MARK: Characters funcs
    func getNumberOfCharacters() -> Int {
        return characters.count
    }
    
    func getCharacterId(at indexPath: IndexPath) -> String {
        guard indexPath.row >= 0 && indexPath.row < characters.count else {
            return "N/A"
        }
        return "ID: \(characters[indexPath.row].id)"
    }
    
    func getCharacterName(at indexPath: IndexPath) -> String {
        guard indexPath.row >= 0 && indexPath.row < characters.count else {
            return "N/A"
        }
        return characters[indexPath.row].name
    }
    
    func getCharacterType(at indexPath: IndexPath) -> String {
        guard indexPath.row >= 0 && indexPath.row < characters.count else {
            return "Type: N/A"
        }
        return "Type: \(characters[indexPath.row].type)"
    }
    
    func getCharacterSpecies(at indexPath: IndexPath) -> String {
        guard indexPath.row >= 0 && indexPath.row < characters.count else {
            return "N/A"
        }
        return "Species: \(characters[indexPath.row].species)"
    }
    
    private func resolveImageURL(path imageURL: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: imageURL) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    func getCharacterImage(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        guard indexPath.row >= 0 && indexPath.row < characters.count else {
            completion(nil)
            return
        }
        resolveImageURL(path: characters[indexPath.row].image, completion: completion)
    }
}
