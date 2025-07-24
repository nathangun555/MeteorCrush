import SpriteKit

class HUD: SKNode {
    private let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let fuelLabel  = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let fuelBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: 55, height: 225)) // Background bar (vertikal)
    private let fuelBarFill = SKSpriteNode() // Correcting fuelBarFill to SKSpriteNode
    
    var score: Int = 0
    var fuel: CGFloat = 100
    var starCount: Int = 0
    
    init(size: CGSize) {
        super.init()
        
        // Score Label
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width - 80, y: size.height - 70)
        scoreLabel.zPosition = 20
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        // Fuel Label
        fuelLabel.fontSize = 24
        fuelLabel.fontColor = .yellow
        fuelLabel.position = CGPoint(x: 40, y: size.height - 250)
        fuelLabel.zPosition = 20
        fuelLabel.text = "\(Int(fuel))"
        addChild(fuelLabel)
        
        // Fuel Bar Background
        fuelBarBackground.texture = SKTexture(imageNamed: "casingFuel")
        fuelBarBackground.size = CGSize(width: 55, height: 225)
        fuelBarBackground.position = CGPoint(x: 40, y: size.height - 160)
        fuelBarBackground.zPosition = 10
        addChild(fuelBarBackground)
        
        // Fuel Bar Fill (Menggunakan SKSpriteNode dengan gradasi warna)
        let gradientTexture = SKTexture(imageNamed: "fuelLevel") // Gunakan file gambar gradasi Anda
        fuelBarFill.texture = gradientTexture
        fuelBarFill.size = CGSize(width: 24, height: 0) // Sesuaikan ukuran dengan tinggi fuel yang diinginkan
        fuelBarFill.position = CGPoint(x: 40, y: size.height - 220)
        fuelBarFill.zPosition = 11
        fuelBarFill.anchorPoint = CGPoint(x: 0.5, y: 0)
        addChild(fuelBarFill)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabels() {
        // Update text untuk score dan fuel
        scoreLabel.text = "Score: \(score)"
        fuelLabel.text  = "\(Int(fuel))"
        
        // Tentukan tinggi maksimum untuk bar bahan bakar
        let maxBarHeight: CGFloat = 120
        
        // Menghitung tinggi berdasarkan bahan bakar
        let fuelBarHeight = maxBarHeight * (fuel / 100)
        
        // Update ukuran fuelBarFill sesuai dengan tinggi bahan bakar
        fuelBarFill.size = CGSize(width: 24, height: fuelBarHeight) // Sesuaikan ukuran sprite fuelBarFill
    }
}
