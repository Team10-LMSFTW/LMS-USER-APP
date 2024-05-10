// ScannerView.swift
import SwiftUI
import VisionKit
import Vision
import Foundation

struct ScanData: Identifiable {
    var id = UUID()
    let content: String
    
    init(content: String) {
        self.content = content
    }
}

struct Content1View: View {
    @Binding var scannedText: String // Binding for scanned text
    @State private var showScannerSheet = false
    @State private var texts: [ScanData] = []

    var body: some View {
        NavigationView {
            VStack {
                if texts.count > 0 {
                    List {
                        ForEach(texts) { text in
                            NavigationLink(
                                destination: ScrollView { Text(text.content) },
                                label: {
                                    Text(text.content).lineLimit(1)
                                })
                        }
                    }
                } else {
                    Text("No scan yet").font(.title)
                }
            }
            .navigationTitle("Scan Barcode")
            .navigationBarItems(trailing: Button(action: {
                self.showScannerSheet = true
            }, label: {
                Image(systemName: "barcode.viewfinder")
                    .font(.title)
            })
            .sheet(isPresented: $showScannerSheet, content: {
                self.makeScannerView()
            })
            )
        }
    }
    
    private func makeScannerView() -> ScannerView {
        ScannerView(completion: { barcodeString in
            if let outputText = barcodeString?.trimmingCharacters(in: .whitespacesAndNewlines) {
                let newScanData = ScanData(content: outputText)
                self.texts.append(newScanData)
            }
            self.showScannerSheet = false
        }, scannedText: $scannedText) // Pass scanned text binding
    }
}

struct ScannerView: UIViewControllerRepresentable {
    private let completionHandler: (String?) -> Void
    @Binding var scannedText: String // Binding for scanned text

    init(completion: @escaping (String?) -> Void, scannedText: Binding<String>) {
        self.completionHandler = completion
        self._scannedText = scannedText
    }

    typealias UIViewControllerType = VNDocumentCameraViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> VNDocumentCameraViewController {
        let viewController = VNDocumentCameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: UIViewControllerRepresentableContext<ScannerView>) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(completion: completionHandler, scannedText: $scannedText)
    }
    
    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
            private let completionHandler: (String?) -> Void
            @Binding var scannedText: String

            init(completion: @escaping (String?) -> Void, scannedText: Binding<String>) {
                self.completionHandler = completion
                self._scannedText = scannedText
            }

            func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
                guard scan.pageCount >= 1 else {
                    completionHandler(nil)
                    return
                }

                let image = scan.imageOfPage(at: 0)
                let request = VNDetectBarcodesRequest { request, error in
                    guard error == nil else {
                        self.completionHandler(nil)
                        return
                    }

                    guard let barcodes = request.results as? [VNBarcodeObservation],
                          let payload = barcodes.first?.payloadStringValue else {
                        self.completionHandler(nil)
                        return
                    }

                    self.completionHandler(payload)
                    self.scannedText = payload
                    print("Scanned ISBN: \(payload)") // Print the scanned ISBN
                }

                let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
                try? handler.perform([request])
            }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            completionHandler(nil)
        }
        
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            print("Document camera view controller did finish with error ", error)
            completionHandler(nil)
        }
    }
}

struct Content1View_Previews: PreviewProvider {
    static var previews: some View {
        Content1View(scannedText: .constant(""))
    }
}
