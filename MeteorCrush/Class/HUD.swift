import SpriteKit

class HUD: SKNode {
    let powerupSize: CGFloat = 60.0
    
    private let scoreLabel = SKLabelNode()
    private let fuelLabel  = SKLabelNode()
    private let fuelBarBackground = SKSpriteNode(color: .gray, size: CGSize(width: 55, height: 225)) // Background bar (vertikal)
    private let fuelBarFill = SKSpriteNode() // Correcting fuelBarFill to SKSpriteNode
    private let scoreBackground = SKSpriteNode()

    
    
    private let shieldLabel = SKSpriteNode(imageNamed: "casingShield")
    private let shieldTimerLabel = SKShapeNode()
    private let multiplierLabel = SKSpriteNode(imageNamed: "casing2x")
    private let multiplierTimerLabel = SKShapeNode()
    

    var score: Int = 0
    var fuel: CGFloat = 100
    
    var shieldPos: CGPoint
    var multiplierPos: CGPoint
    
    init(size: CGSize) {
        self.shieldPos = CGPoint(x: size.width - 50, y: size.height - 140)
        self.multiplierPos = CGPoint(x: self.shieldPos.x, y: self.shieldPos.y - powerupSize - 20)

        super.init()
        // Score Background
        scoreBackground.texture = SKTexture(imageNamed: "casingStar")
        scoreBackground.size = CGSize(width: 130, height: 60)
        scoreBackground.position = CGPoint(x: size.width - 80, y: size.height - 70)
        scoreBackground.zPosition = 10
        addChild(scoreBackground)
        
        // Score Label
        scoreLabel.fontName = "Baloo2-ExtraBold"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width - 60, y: size.height - 80)
        scoreLabel.zPosition = 20
        scoreLabel.text = "0"
        addChild(scoreLabel)
        
        // Fuel Label
        fuelLabel.fontName = "Baloo2-ExtraBold"
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
        
        shieldLabel.size = CGSize(width: powerupSize, height: powerupSize)
        shieldLabel.position = shieldPos
        shieldLabel.zPosition = 20
        shieldLabel.isHidden = true
        addChild(shieldLabel)
        
        shieldTimerLabel.strokeColor = .white
        shieldTimerLabel.zPosition = 21
        shieldTimerLabel.lineWidth = 8
        shieldTimerLabel.lineCap = .round
        shieldTimerLabel.isHidden = true
        shieldTimerLabel.alpha = 0.5
        addChild(shieldTimerLabel)
        
        multiplierLabel.size = CGSize(width: powerupSize, height: powerupSize)
        multiplierLabel.position = self.multiplierPos
        multiplierLabel.zPosition = 20
        multiplierLabel.isHidden = true
        addChild(multiplierLabel)
        
        multiplierTimerLabel.strokeColor = .white
        multiplierTimerLabel.zPosition = 21
        multiplierTimerLabel.lineWidth = 8
        multiplierTimerLabel.lineCap = .round
        multiplierTimerLabel.isHidden = true
        multiplierTimerLabel.alpha = 0.5
        addChild(multiplierTimerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabels() {
        // Update text untuk score dan fuel
        scoreLabel.text = "\(score)"
        fuelLabel.text  = "\(Int(fuel))"
        
        // Tentukan tinggi maksimum untuk bar bahan bakar
        let maxBarHeight: CGFloat = 120
        
        // Menghitung tinggi berdasarkan bahan bakar
        let fuelBarHeight = maxBarHeight * (fuel / 100)
        
        // Update ukuran fuelBarFill sesuai dengan tinggi bahan bakar
        fuelBarFill.size = CGSize(width: 24, height: fuelBarHeight) // Sesuaikan ukuran sprite fuelBarFill
    }
    
    func updatePowerupState(in scene: GameScene){
        shieldLabel.isHidden = !scene.isShield
        shieldTimerLabel.isHidden = !scene.isShield
        if(!shieldTimerLabel.isHidden){
            let path = CGMutablePath()
            let currentAngle: CGFloat = (scene.shieldTimer / 10) * (.pi * 2)
            path.addArc(center: self.shieldPos, radius: 30, startAngle: .pi / 2, endAngle: currentAngle + .pi / 2, clockwise: false)
            shieldTimerLabel.path = path
        }
        
        multiplierLabel.isHidden = !scene.isDoublePoint
        multiplierTimerLabel.isHidden = !scene.isDoublePoint
        if(!multiplierTimerLabel.isHidden){
            let path = CGMutablePath()
            let currentAngle: CGFloat = (scene.multiplierTimer / 10) * (.pi * 2)
            path.addArc(center: self.multiplierPos, radius: 30, startAngle: .pi / 2, endAngle: currentAngle + .pi / 2, clockwise: false)
            multiplierTimerLabel.path = path
        }
    }
    
}
