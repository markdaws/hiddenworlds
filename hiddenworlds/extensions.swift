import simd
import Foundation

extension float4x4 {

  static func translate(_ x: Float, _ y: Float, _ z: Float) -> float4x4 {
    return float4x4(
      [1,0,0,0],
      [0,1,0,0],
      [0,0,1,0],
      [x,y,z,1]
    )
  }

  static func scale(_ s: Float) -> float4x4 {
    return float4x4(
      [s,0,0,0],
      [0,s,0,0],
      [0,0,s,0],
      [0,0,0,1]
    )
  }

}
