import Foundation
import UIKit

final class UploadPhoto: Sendable {
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size

        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    class func uploadImage(paramName: String, fileName: String, image: UIImage) async throws -> [String: Any] {
        let url = URL(string: "https://api.pinata.cloud/pinning/pinFileToIPFS")
        let boundary = UUID().uuidString

        let session = URLSession.shared

        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySW5mb3JtYXRpb24iOnsiaWQiOiJlYWZiZDU5Mi1kODgyLTQyOTUtYWFmMi1kYmVmMDA5NTE5MWUiLCJlbWFpbCI6Imp1bkBtZW93YXV0aC54eXoiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGluX3BvbGljeSI6eyJyZWdpb25zIjpbeyJpZCI6IkZSQTEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX0seyJpZCI6Ik5ZQzEiLCJkZXNpcmVkUmVwbGljYXRpb25Db3VudCI6MX1dLCJ2ZXJzaW9uIjoxfSwibWZhX2VuYWJsZWQiOmZhbHNlLCJzdGF0dXMiOiJBQ1RJVkUifSwiYXV0aGVudGljYXRpb25UeXBlIjoic2NvcGVkS2V5Iiwic2NvcGVkS2V5S2V5IjoiM2RiZDIwNzYxNWRlNWIwMjM1M2IiLCJzY29wZWRLZXlTZWNyZXQiOiI2ZjZlMTI0MmY3YTIyNjFmYmI0YTcxYjM5Y2Y2NWFmNjEyZGFlNWU3ZGUwNTE1MDdmZWE1ZjljM2RmYzc4MzExIiwiaWF0IjoxNjg5NTg5NjIwfQ.51jLn5_rwO3pzW-YnHhCtdQdt6QsOYjXHxjM7h9xGLk", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(UploadPhoto.resizeImage(image: image, targetSize: CGSize(width: 1024, height: 1024))!.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        return try await withUnsafeThrowingContinuation { continuation in
            // Send a POST request to the URL, with the data we created earlier
            session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, _, error in
                if error == nil {
                    let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                    if let json = jsonData as? [String: Any] {
                        continuation.resume(returning: json)
                    }
                } else {
                    continuation.resume(throwing: error!)
                }
            }).resume()
        }
    }

    class func getIpfsHashToUrl(_ hashString: String) -> URL {
        return URL(string: "https://gateway.pinata.cloud/ipfs/\(hashString)")!
    }
}
