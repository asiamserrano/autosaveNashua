//
//  GameImageView.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 2/5/26.
//

import SwiftUI
import SwiftUI
import PhotosUI
import autosaveNashuaPackage

public enum ImagePickerEnum: Enumerable {
    case picker, paste
}

struct GameImageView: View {
    
    @State private var photosPickerItem: PhotosPickerItem? = nil
    @State private var picker: ImagePickerEnum = .picker
    
    @Binding var uiimage: UIImage?
    
    private var isEmpty: Bool {
        self.uiimage == nil
    }
    
    var body: some View {
        
        Section {
            VStack(alignment: .center) {
                ImageView()
                    .onTapGesture(count: 2, perform: self.tapAction)
                HStack {
                    PhotosPicker(selection: $photosPickerItem, matching: .images, photoLibrary: .shared()) {
                        Text(self.isEmpty ? "Add" : "Edit")
                    }
                    .onChange(of: self.photosPickerItem, self.pickerAction)
                    
                    Button(action: self.resetPhotosPickerItem, label: {
                        Text("Delete")
                    })
                    .hide(isEmpty)
                }

                .buttonStyle(.borderless)
            }
        }
        
    }
    
}

private extension GameImageView {
        
    func setUIImage(_ data: Data?, _ picker: ImagePickerEnum) -> Void {
        withAnimation {
            if let data = data, let ui = UIImage(data: data) {
                self.uiimage = ui
                self.saveUIImage(ui)
            }
            self.setPicker(picker)
        }
    }
    
//    func getInt(from data: Data) -> Int {
//        // 1. Ensure we have enough bytes (8 bytes for a 64-bit Int)
//        guard data.count >= MemoryLayout<Int>.size else {
//            return 0 // Or handle as an error
//        }
//        
//        // 2. Create a local variable to hold the result
//        var value: Int = 0
//        
//        // 3. Copy the specific range of bytes into the variable
//        _ = withUnsafeMutableBytes(of: &value) {
//            data.copyBytes(to: $0, count: MemoryLayout<Int>.size)
//        }
//        
//        // 4. Return with correct endianness (PNG/Network data is usually Big Endian)
//        return Int(bigEndian: value)
//    }

    func saveUIImage(_ ui: UIImage) -> Void {
        print("saving ui image")
        
        if let pngData = ui.pngData() {
            let encodedString = pngData.base64EncodedString()
            let mask = pngData.toUInt8
            let ns = UUID.Namespace.defaultValue
            let uuid = ns.uuid(encodedString, mask: mask)
            
            print("encodedString: \(encodedString.count)")
            print("mask: \(mask)")
            print("ns: \(ns.namespaceString)")
            print("uuid: \(uuid)")

            
//            let mask = pngData.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Int in
//                // Ensure data is long enough to avoid an out-of-bounds crash
//                guard pointer.count >= MemoryLayout<Int>.size else { return 0 }
//                
//                // Use loadUnaligned to prevent alignment-related crashes
//                let rawValue = pointer.loadUnaligned(as: Int.self)
//                
//                // Return with proper endianness (use .bigEndian for network/file data)
//                let r = Int(bigEndian: rawValue)
//                print("returning: \(r)")
//                return r
//            }
            
//            let mask2 = getInt(from: pngData)

   
//            print("mask2: \(mask2)")
//            do {
//                // This is the correct way to write a String with encoding
//                try encodedString.write(to: url, atomically: true, encoding: .utf8)
//                print("Successfully wrote to file: \(filePath)")
//            } catch {
//                print("Failed to write to disk: \(error.localizedDescription)")
//            }
            
            
//            let url = URL(fileURLWithPath: "/Users/asiaserrano/output_image.txt")
//            let filePath = url.path
//            
//            if Files.fileExsists(filePath) {
//                Files.deleteFile(filePath)
//            }
//            
//            if Files.createFile(filePath) {
//
//            }
        }
    }
    
    func setPicker(_ picker: ImagePickerEnum) -> Void {
        self.picker = picker
    }
    
    func resetPhotosPickerItem() -> Void {
        self.photosPickerItem = nil
        self.uiimage = nil
    }
    
    func tapAction() -> Void {
        if let image: UIImage = UIPasteboard.general.images?.first {
//            self.setData(image.pngData, .paste)
            self.setUIImage(image.pngData, .paste)
            self.resetPhotosPickerItem()
        }
    }
    
    func pickerAction(_ old: PhotosPickerItem?, _ new: PhotosPickerItem?) -> Void {
        if self.picker == .paste {
            self.setPicker(.picker)
        } else {
            Task {
                let data: Data? = try? await self.photosPickerItem?.loadTransferable(type: Data.self)
                self.setUIImage(data, .picker)
            }
        }
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        let deviceImage = Image(uiimage)
        BooleanView(isEmpty, trueView: {
            deviceImage
                .resizable()
                .scaledToFit()
                .frame(alignment: .center)
                .foregroundColor(.gray)
                .padding()
        }, falseView: {
            deviceImage
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
        })
    }
    
}

//#Preview {
//    NavigationStack {
//        Form {
//            GameImageView()
//            SpacedLabel("String", "Test")
//        }
//        .navigationTitle("Image Picker View")
//    }
//}
