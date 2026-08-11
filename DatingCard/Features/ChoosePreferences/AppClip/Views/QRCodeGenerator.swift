//
//  QRCodeGenerator.swift
//  DatingCard
//
//  Created by Arif Fathurrahman on 10/08/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

enum QRCodeGenerator {
    private static let context = CIContext()

    static func generate(
        from text: String,
        scale: CGFloat = 12
    ) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(text.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else {
            return nil
        }

        let scaledImage = outputImage.transformed(
            by: CGAffineTransform(
                scaleX: scale,
                y: scale
            )
        )

        guard let cgImage = context.createCGImage(
            scaledImage,
            from: scaledImage.extent
        ) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
