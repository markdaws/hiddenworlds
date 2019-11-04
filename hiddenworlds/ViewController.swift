import UIKit
import SceneKit
import ARKit

final class ViewController: UIViewController, ARSCNViewDelegate {

  @IBOutlet var sceneView: ARSCNView!
  private var box: Box?

  override func viewDidLoad() {
    super.viewDidLoad()
    sceneView.delegate = self

    sceneView.autoenablesDefaultLighting = false
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
    sceneView.addGestureRecognizer(tapRecognizer)

    //sceneView.showsStatistics = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let configuration = ARWorldTrackingConfiguration()
    configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR", bundle: nil)

    // Improves tracking perf
    configuration.maximumNumberOfTrackedImages = 1

    sceneView.session.run(configuration)
    sceneView.scene.lightingEnvironment.contents = UIImage(named: "spherical")
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }

  @objc func onTap(_ recognizer: UITapGestureRecognizer) {
    guard let box = box else { return }

    box.toggleOpen()
  }

  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let imageAnchor = anchor as? ARImageAnchor else {
      return
    }

    box = Box(imageAnchor: imageAnchor)
    node.addChildNode(box!)
  }

}
