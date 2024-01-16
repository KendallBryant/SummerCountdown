//
//  GIFimageView.swift
//  SummerCountdownApp
//
//  Created by Kendall Bryant on 1/16/24.
//
//
//import SwiftUI
//import WebKit
//


// I will delete this file once I'm sure everything works with my current GIF display method 



//// the below code is from chatGPT on Jan 17,
//// I just gave chatGPT the old YouTube version
//// and asked it to improve it
//struct GIFimageView: UIViewRepresentable {
//    private let name: String
//    
//    init(_ name: String) {
//        self.name = name
//    }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        if let url = Bundle.main.url(forResource: name, withExtension: "gif"),
//           let data = try? Data(contentsOf: url) {
//            webView.load(
//                data,
//                mimeType: "image/gif",
//                characterEncodingName: "UTF-8",
//                baseURL: url.deletingLastPathComponent()
//            )
//        }
//        webView.isOpaque = false
//        return webView
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        uiView.reload()
//    }
//}
//
//struct GifImage_Previews: PreviewProvider {
//    static var previews: some View {
//        GIFimageView("g02")
//    }
//}



// this code is from a youtube video that looks at pokeball gifs
//struct GIFimageView: UIViewRepresentable {
//    private let name: String
//    
//    init(_ name: String) {
//        self.name = name
//    }
//    
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
//        let data = try! Data(contentsOf: url)
//        
//        webView.load(
//            data,
//            mimeType: "image/gif",
//            characterEncodingName: "UTF-8",
//            baseURL: url.deletingLastPathComponent()
//        )
//        webView.isOpaque = false
//        return webView
//        
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        uiView.reload()
//        
//    }
//}
//
//struct GifImage_Previews: PreviewProvider {
//    static var previews: some View {
//        GIFimageView("g02")
//    }
//}
