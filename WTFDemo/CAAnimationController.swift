//
//  CAAnimationController.swift
//  WTFDemo
//
//  Created by Nick Grabenstein on 1/16/24.
//

import UIKit

let kKey = "com.test.animlayer"

class CAAnimationController: UIViewController {

    weak var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView(frame: CGRect(x: 80, y: 400, width: 200, height: 20))
        // Do any additional setup after loading the view.
        view.addSubview(v)
        view.backgroundColor = .black
        testView = v
        v.backgroundColor = .red
        let gr = UITapGestureRecognizer(target: self, action: #selector(CAAnimationController.didTap(_:)))
        view.addGestureRecognizer(gr)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emit()
    }
    
    @objc func didTap(_ sender: UIGestureRecognizer) {
        print("TAP TAP TAP TAP TAP")
        self.dismiss(animated: true)
    }
    
    
    func emit() {
        let emitterLayer = MakeEmitter()
        emitterLayer.scale = 10
        var emitterCells: [CAEmitterCell] = [emitterLayer]
        let emitter = makeActualEmitter()
        emitter.emitterCells = emitterCells
        testView.layer.insertSublayer(emitter, at: 0)
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        animation.values = [1, 0 , 0]
        animation.keyTimes = [0, 0.5, 1]
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        emitter.beginTime = CACurrentMediaTime()
        
        let now = Date()
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            print("fade beginning -- delta: \(Date().timeIntervalSince(now))")
            let transition = CATransition()
            transition.delegate = self
            transition.type = .fade
            transition.duration = 1
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.setValue(emitter, forKey: kKey)
            transition.isRemovedOnCompletion = false

            emitter.add(transition, forKey: nil)

            emitter.opacity = 0
        }
        emitter.add(animation, forKey: nil)
        CATransaction.commit()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func makeActualEmitter() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: self.testView.bounds.midX, y: self.testView.bounds.midY)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: testView.bounds.width / 4, height: 0)
        emitter.birthRate = 1
        emitter.beginTime = CACurrentMediaTime()
        emitter.seed = UInt32.random(in: 0..<100000)

        emitter.renderMode = .backToFront
        
        
        let horizontalWaveB = CreateBehavior(type: "wave")
        horizontalWaveB.setValue([100,0,0], forKey: "force")
        horizontalWaveB.setValue(0.5, forKey: "frequency")
        
        emitter.setValue([horizontalWaveB], forKey: "emitterBehaviors")
        return emitter
    }

}

extension CAAnimationController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Animation did stop?")
        if let emitter = anim.value(forKey: kKey) as? CALayer {
            emitter.removeAllAnimations()
            emitter.removeFromSuperlayer()
        }
    }
}

func CreateBehavior(type: String) -> NSObject {
    let behaviorClass = NSClassFromString("CAEmitterBehavior") as! NSObject.Type
    let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))!
    let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to:(@convention(c)(Any?, Selector, Any?) -> NSObject).self)
    return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
}


func MakeEmitter() -> CAEmitterCell {
   let reactjiCell = CAEmitterCell()
   
   reactjiCell.contents = UIImage(systemName: "star.fill")

   reactjiCell.birthRate = 5
   reactjiCell.lifetime = 1.5
   reactjiCell.lifetimeRange = 0.25
   reactjiCell.emissionLongitude = 0//CGFloat(Double.pi/2)
   reactjiCell.emissionRange = 0.2
   reactjiCell.velocity = 250
   reactjiCell.velocityRange = 100
   reactjiCell.scale = 0.08
   reactjiCell.scaleRange = 0.05
   reactjiCell.name = "star"
   
   let fadeDur: Float = 0.25
   let speed = 1.0/fadeDur
   reactjiCell.alphaSpeed = -1.0 * speed
   reactjiCell.color = UIColor.white.cgColor.copy(alpha: CGFloat(1.5 * speed))

   return reactjiCell
}
