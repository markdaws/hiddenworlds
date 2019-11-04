import ARKit
import Foundation
import SceneKit

final class Box: SCNNode {

  private static let boxMaterial: SCNMaterial = {
    let m = SCNMaterial()
    m.lightingModel = .physicallyBased

    let materialName = "bathroomtile2"
    m.diffuse.contents = UIImage(named: "\(materialName)-albedo")
    m.roughness.contents = UIImage(named: "\(materialName)-roughness")
    m.metalness.contents = UIImage(named: "\(materialName)-metalness")
    m.normal.contents = UIImage(named: "\(materialName)-normal")
    m.diffuse.mipFilter = .linear
    m.writesToDepthBuffer = true
    return m
  }()

  private static let screenMaterial: SCNMaterial = {
    let m = SCNMaterial()
    m.diffuse.contents = UIImage(named: "screenshot-full")
    return m
  }()

  private var isOpen = false
  private let frontWall: Wall
  private let screenSize: (width: Float, height: Float)

  /// The depth of the box in meters
  let boxDepth: Float = 0.3

  /**
   The thickness of the walls in meters. We need some thickness vs.
   using a SCNPlane for the physics simulation to work correctly.
  */
  let wallThickness: Float = 0.001

  init(imageAnchor: ARImageAnchor) {
    screenSize = (
      width: Float(imageAnchor.referenceImage.physicalSize.width),
      height: Float(imageAnchor.referenceImage.physicalSize.height)
    )

    frontWall = Wall(
      width: wallThickness,
      height: screenSize.height,
      length: screenSize.width,
      material: Box.screenMaterial)
    frontWall.simdTransform =
      float4x4.translate(0, 0, screenSize.height/2.0) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [1,0,0])) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [0,1,0]))

    super.init()
    self.addChildNode(frontWall)

    // Sits below the front wall so that when the screen shot slides
    // down, it is hidden behind this occluder
    let frontWallOccluder = Wall(
      width: wallThickness,
      height: screenSize.height,
      length: screenSize.width,
      material: Wall.transparentMaterial)
    frontWallOccluder.simdTransform =
      float4x4.translate(0, 0.005, screenSize.height*1.5) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [1,0,0])) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [0,1,0]))
    self.addChildNode(frontWallOccluder)

    let backWall = Wall(
      width: wallThickness,
      height: screenSize.height,
      length: screenSize.width,
      material: Box.boxMaterial)
    backWall.simdTransform =
      float4x4.translate(0, -boxDepth, screenSize.height/2.0) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [1,0,0])) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [0,1,0]))
    self.addChildNode(backWall)

    let leftWall = Wall(
      width: wallThickness,
      height: boxDepth,
      length: screenSize.height,
      material: Box.boxMaterial
    )
    leftWall.simdTransform = float4x4.translate(-screenSize.width/2.0, -boxDepth, 0)
    self.addChildNode(leftWall)

    let rightWall = Wall(
      width: wallThickness,
      height: boxDepth,
      length: screenSize.height,
      material: Box.boxMaterial
    )
    rightWall.simdTransform =
      float4x4.translate(screenSize.width/2.0, -boxDepth, 0) *
      float4x4(simd_quatf(angle: .pi, axis: [0,1,0]))
    self.addChildNode(rightWall)

    let bottomWall = Wall(
      width: wallThickness,
      height: boxDepth,
      length: screenSize.width,
      material: Box.boxMaterial
    )
    bottomWall.simdTransform =
      float4x4.translate(0, -boxDepth, screenSize.height/2.0) *
      float4x4(simd_quatf(angle: .pi/2.0, axis: [0,1,0]))
    self.addChildNode(bottomWall)

    let topWall = Wall(
      width: wallThickness,
      height: boxDepth,
      length: screenSize.width,
      material: Box.boxMaterial
    )
    topWall.simdTransform =
      float4x4.translate(0, -boxDepth, -screenSize.height/2.0) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [0,1,0]))
    self.addChildNode(topWall)

    // Add the car model inside the box
    let node2 = SCNReferenceNode(url: Bundle.main.url(forResource: "car", withExtension: "usdz")!)
    node2?.load()

    // Have to move the car around to get it inside the box
    node2?.simdTransform =
      float4x4.translate(0, -boxDepth/2.0, screenSize.height * 0.4) *
      float4x4.scale(0.0004) *
      float4x4(simd_quatf(angle: -.pi/2, axis: [1,0,0])) *
      float4x4(simd_quatf(angle: .pi/4, axis: [0,1,0]))
    self.addChildNode(node2!)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func toggleOpen() {
    let zOffset = isOpen
      ? screenSize.height/2.0
      : screenSize.height * 1.5

    // We hide the front wall once it has opened so that there
    // aren't any visual artifacts, so if it is currently open
    // we need to show it again before we animate it back up
    if isOpen {
      frontWall.isHidden = false
    }

    SCNTransaction.begin()
    SCNTransaction.animationDuration = 1
    frontWall.simdTransform =
      float4x4.translate(0, 0, zOffset) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [1,0,0])) *
      float4x4(simd_quatf(angle: -.pi/2.0, axis: [0,1,0]))
    SCNTransaction.completionBlock = {
      self.frontWall.isHidden = self.isOpen
    }
    SCNTransaction.commit()

    isOpen = !isOpen
  }
}
