import UIKit

class ViewController: UIViewController {
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let loadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load Image", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let clearCacheButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear Cache", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let imageURL = URL(string: "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        observeMemoryWarning()
        
        loadButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        clearCacheButton.addTarget(self, action: #selector(clearCache), for: .touchUpInside)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(loadButton)
        view.addSubview(clearCacheButton)
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            loadButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            clearCacheButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            clearCacheButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func loadImage() {
        ImageCacheManager.shared.image(for: imageURL) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    @objc func clearCache() {
        ImageCacheManager.shared.clearCache()
        imageView.image = nil
    }
    
    func observeMemoryWarning() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(systemMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc func systemMemoryWarning() {
        print("Memory warning! Clearing cache!")
        ImageCacheManager.shared.clearCache()
    }
}

