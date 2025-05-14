import UIKit

class ReorderableCollectionViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private var dataSource: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
    private var isEditingMode = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reorderable List"
        view.backgroundColor = .systemBackground
        setupCollectionView()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        // Create a list layout that resembles a table view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: 60)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(ReorderableCollectionViewCell.self, forCellWithReuseIdentifier: "ReorderableCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Add long press gesture for reordering
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.1 // Short duration so it feels responsive
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(toggleEditMode)
        )
    }
    
    // MARK: - Actions
    @objc private func toggleEditMode() {
        isEditingMode = !isEditingMode
        
        // Update navigation bar button
        navigationItem.rightBarButtonItem?.title = isEditingMode ? "Done" : "Edit"
        
        // Show/hide reorder controls
        for cell in collectionView.visibleCells {
            if let reorderableCell = cell as? ReorderableCollectionViewCell {
                reorderableCell.setEditing(isEditingMode)
            }
        }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        
        // Only proceed if we're in editing mode
        if !isEditingMode {
            if gesture.state == .began {
                // If not in editing mode and long press begins, switch to editing mode
                toggleEditMode()
            }
            return
        }
        
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            if gesture.state == .ended {
                // If finger is lifted in an empty area, cancel any ongoing drag
                collectionView.cancelInteractiveMovement()
            }
            return
        }
        
        switch gesture.state {
        case .began:
            // Check if the touch is within the reorder control area
            if let cell = collectionView.cellForItem(at: indexPath) as? ReorderableCollectionViewCell,
               cell.isPointInReorderControl(point: collectionView.convert(point, to: cell)) {
                
                // Highlight the cell being moved
                cell.startDragging()
                
                // Begin the move operation
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
            
        case .changed:
            // Update position during drag
            collectionView.updateInteractiveMovementTargetPosition(point)
            
        case .ended:
            // End the move operation
            collectionView.endInteractiveMovement()
            
            // Reset all cells
            for cell in collectionView.visibleCells {
                if let reorderableCell = cell as? ReorderableCollectionViewCell {
                    reorderableCell.stopDragging()
                }
            }
            
        default:
            // Cancel the move operation
            collectionView.cancelInteractiveMovement()
            
            // Reset all cells
            for cell in collectionView.visibleCells {
                if let reorderableCell = cell as? ReorderableCollectionViewCell {
                    reorderableCell.stopDragging()
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ReorderableCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReorderableCell", for: indexPath) as? ReorderableCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: dataSource[indexPath.row], isEditing: isEditingMode)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return isEditingMode
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the data source when an item is moved
        let item = dataSource.remove(at: sourceIndexPath.row)
        dataSource.insert(item, at: destinationIndexPath.row)
    }
}

// MARK: - UICollectionViewDelegate
extension ReorderableCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if !isEditingMode {
            print("Selected item: \(dataSource[indexPath.row])")
        } else {
            // In editing mode, tapping a cell does nothing special
        }
    }
}

// MARK: - Custom CollectionViewCell
class ReorderableCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let reorderControl = UIView()
    private var isEditing = false
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Background
        contentView.backgroundColor = .systemBackground
        
        // Add separator line at the bottom
//        let separator = UIView()
//        separator.backgroundColor = .systemGray5
//        separator.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(separator)
        
        // Setup reorder control - three horizontal lines on the left
        reorderControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reorderControl)
        
        // Customize the reorder control
        setupReorderControl()
        
        // Initially hide the reorder control
        reorderControl.isHidden = true
        
        // Add title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Separator constraints
//            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            // Reorder control constraints
            reorderControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            reorderControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            reorderControl.widthAnchor.constraint(equalToConstant: 24),
            reorderControl.heightAnchor.constraint(equalToConstant: 24),
            
            // Title label constraints - adjusts based on whether reorder control is visible
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: reorderControl.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupReorderControl() {
        // Create three horizontal lines for the reorder indicator
        for i in 0..<3 {
            let line = UIView()
            line.backgroundColor = .systemGray3
            line.translatesAutoresizingMaskIntoConstraints = false
            reorderControl.addSubview(line)
            
            NSLayoutConstraint.activate([
                line.leadingAnchor.constraint(equalTo: reorderControl.leadingAnchor),
                line.trailingAnchor.constraint(equalTo: reorderControl.trailingAnchor),
                line.heightAnchor.constraint(equalToConstant: 2),
                line.centerYAnchor.constraint(equalTo: reorderControl.centerYAnchor, constant: CGFloat(i - 1) * 6)
            ])
        }
    }
    
    // MARK: - Public Methods
    func configure(with title: String, isEditing: Bool) {
        titleLabel.text = title
        setEditing(isEditing)
    }
    
    func setEditing(_ editing: Bool) {
        isEditing = editing
        reorderControl.isHidden = !editing
        
        // Adjust title label constraint if needed
        if editing {
            // Make sure title is properly positioned when reorder control is visible
            titleLabel.leadingAnchor.constraint(equalTo: reorderControl.trailingAnchor, constant: 16).isActive = true
        } else {
            // Reset any dragging visual effects
            stopDragging()
        }
    }
    
    func isPointInReorderControl(point: CGPoint) -> Bool {
        // Check if the touch point is within the reorder control area
        // Add some padding to make it easier to grab
        let expandedFrame = reorderControl.frame.insetBy(dx: -10, dy: -10)
        return expandedFrame.contains(point)
    }
    
    func startDragging() {
        // Visual feedback when cell is being dragged
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    func stopDragging() {
        // Reset visual effects
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
            self.contentView.backgroundColor = .systemBackground
            self.layer.shadowOpacity = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setEditing(false)
        stopDragging()
    }
}


