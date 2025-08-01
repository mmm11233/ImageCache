import UIKit

class TableViewController: UIViewController, UITableViewDataSource {
    
    var images: [String] = []
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        if let list = loadJSONFromFile() {
            images = list.images
            tableView.reloadData()
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageCell")
        tableView.rowHeight = 100
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as? ImageTableViewCell else {
            return UITableViewCell()
        }
        
        let imageName = images[indexPath.row]
        cell.customImageView.image = UIImage(named: imageName)
        cell.titleLabel.text = "name: \(imageName)"
        return cell
    }
    
    
}
