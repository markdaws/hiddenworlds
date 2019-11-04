import Foundation
import SceneKit

final class Wall: SCNNode {

  /// A transparent material, that hides all content shown behind it.
  static let transparentMaterial: SCNMaterial = {
    let m = SCNMaterial()
    m.diffuse.contents = UIColor.red
    m.transparency = 0.0000001
    m.writesToDepthBuffer = true
    return m
  }()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /**
   Initiates a new Wall node. A wall node has one side rendered with the material
   passed in to the initializer and the other side is covered with a transparent
   material, which blocks anything from rendering behind it.

   The wall is centered around x==0, z==0 and on the y==0 plane.

   The textured side is on +x and the transparent side on -x.

   - parameters:
      - width: Width of the wall (x)
      - height: Height of the wall (y)
      - length: Length of the wall (z)
      - material: The material to render on the wall
   */
  init(
    width: Float,
    height: Float,
    length: Float,
    material: SCNMaterial,
    transparentMaterial: SCNMaterial = Wall.transparentMaterial) {

    super.init()

    let innerWall = SCNBox(
     width: CGFloat(width),
     height: CGFloat(height),
     length: CGFloat(length),
     chamferRadius: 0
    )
    let innerWallNode = SCNNode(geometry: innerWall)
    innerWall.materials = [material]
    innerWallNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)

    let outerWall = SCNBox(
      width: CGFloat(width),
      height: CGFloat(height * 1.001),
      length: CGFloat(length * 1.001),
      chamferRadius: 0
    )
    outerWall.materials = [transparentMaterial]
    let outerWallNode = SCNNode(geometry: outerWall)

    // Move the wall slightly outside the inner wall
    outerWallNode.simdPosition = [-0.001,0,0]
    outerWallNode.renderingOrder = -10

    let root = SCNNode()
    root.simdPosition = [0, height/2, 0]
    root.addChildNode(innerWallNode)
    root.addChildNode(outerWallNode)
    self.addChildNode(root)
  }
}
