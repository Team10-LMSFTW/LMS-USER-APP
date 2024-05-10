//import SwiftUI
//import VisionKit
//import Vision
//import Foundation
//
//
//struct ScanData:Identifiable {
//    var id = UUID()
//    let content:String
//    
//    init(content:String) {
//        self.content = content
//    }
//}
//
//
//final class TextRecognizer{
//    let cameraScan: VNDocumentCameraScan
//    init(cameraScan:VNDocumentCameraScan) {
//        self.cameraScan = cameraScan
//    }
//    private let queue = DispatchQueue(label: "scan-codes",qos: .default,attributes: [],autoreleaseFrequency: .workItem)
//    func recognizeText(withCompletionHandler completionHandler:@escaping ([String])-> Void) {
//        queue.async {
//            let images = (0..<self.cameraScan.pageCount).compactMap({
//                self.cameraScan.imageOfPage(at: $0).cgImage
//            })
//            let imagesAndRequests = images.map({(image: $0, request:VNRecognizeTextRequest())})
//            let textPerPage = imagesAndRequests.map{image,request->String in
//                let handler = VNImageRequestHandler(cgImage: image, options: [:])
//                do{
//                    try handler.perform([request])
//                    guard let observations = request.results as? [VNRecognizedTextObservation] else{return ""}
//                    return observations.compactMap({$0.topCandidates(1).first?.string}).joined(separator: "\n")
//                }
//                catch{
//                    print(error)
//                    return ""
//                }
//            }
//            DispatchQueue.main.async {
//                completionHandler(textPerPage)
//            }
//        }
//    }
//}
//
//
//struct ScannerView: UIViewControllerRepresentable {
//    private let completionHandler: ([String]?) -> Void
//     
//    init(completion: @escaping ([String]?) -> Void) {
//        self.completionHandler = completion
//    }
//     
//    typealias UIViewControllerType = VNDocumentCameraViewController
//     
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
//        let viewController = VNDocumentCameraViewController()
//        viewController.delegate = context.coordinator
//        return viewController
//    }
//     
//    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}
//     
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(completion: completionHandler)
//    }
//     
//    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
//        private let completionHandler: ([String]?) -> Void
//         
//        init(completion: @escaping ([String]?) -> Void) {
//            self.completionHandler = completion
//        }
//         
//        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//            print("Document camera view controller did finish with ", scan)
//            let recognizer = TextRecognizer(cameraScan: scan)
//            recognizer.recognizeText(withCompletionHandler: completionHandler)
//        }
//         
//        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//            completionHandler(nil)
//        }
//         
//        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
//            print("Document camera view controller did finish with error ", error)
//            completionHandler(nil)
//        }
//    }
//}
//
//
//
//struct Content1View: View {
//    @State private var showScannerSheet = false
//    @State private var texts:[ScanData] = []
//    var body: some View {
//        NavigationView{
//            VStack{
//                if texts.count > 0{
//                    List{
//                        ForEach(texts){text in
//                            NavigationLink(
//                                destination:ScrollView{Text(text.content)},
//                                label: {
//                                    Text(text.content).lineLimit(1)
//                                })
//                        }
//                    }
//                }
//                else{
//                    Text("No scan yet").font(.title)
//                }
//            }
//                .navigationTitle("Scan OCR")
//                .navigationBarItems(trailing: Button(action: {
//                    self.showScannerSheet = true
//                }, label: {
//                    Image(systemName: "doc.text.viewfinder")
//                        .font(.title)
//                })
//                .sheet(isPresented: $showScannerSheet, content: {
//                    self.makeScannerView()
//                })
//                )
//        }
//    }
//    private func makeScannerView()-> ScannerView {
//        ScannerView(completion: {
//            textPerPage in
//            if let outputText = textPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines){
//                let newScanData = ScanData(content: outputText)
//                self.texts.append(newScanData)
//            }
//            self.showScannerSheet = false
//        })
//    }
//}
//struct Content1View_Previews: PreviewProvider {
//    static var previews: some View {
//        Content1View()
//    }
//}
