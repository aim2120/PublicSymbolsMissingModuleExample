import SwiftUI
import PublicSymbolsMissingModuleExample_PackageA

public struct ContentView: View {
    public init() {}

    let packageA: PackageA? = nil

    public var body: some View {
        Text("Hello, World!")
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
