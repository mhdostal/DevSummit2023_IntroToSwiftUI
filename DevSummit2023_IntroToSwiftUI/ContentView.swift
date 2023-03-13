// Copyright 2023 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import SwiftUI
import ArcGIS

/// RocketLaunch structure defining the data used in the app.
struct RocketLaunch: Identifiable {
    let id = UUID()
    var name: String
    var company: String
    var date: Date
    var pad: String
    var location: Point
}

extension RocketLaunch: Hashable {}

struct ContentView: View {
    /// RocketLaunch data displayed in the list.
    var launches = [
        RocketLaunch(
            name: "Good Luck, Have Fun",
            company: "Relativity Space",
            date: Date(timeIntervalSince1970: 1678298400),
            pad: "SLC-16",
            location: Point(x: -80.5518, y: 28.5017, spatialReference: .wgs84)
        ),
        RocketLaunch(name: "OneWeb-17", company: "SpaceX", date: Date(timeIntervalSince1970: 1678388700), pad: "SLC-40", location: Point(x: -80.57718, y: 28.562106, spatialReference: .wgs84)),
        RocketLaunch(name: "CRS2 (Dragon)", company: "SpaceX", date: Date(timeIntervalSince1970: 1678840200), pad: "LC-39A", location: Point(x: -80.604333, y: 28.608389, spatialReference: .wgs84))
    ]

    var body: some View {
        NavigationStack {
            List(launches) { launch in
                LaunchRow(launch: launch)
            }
            .listStyle(.plain)
            .navigationTitle("Rocket Launches")
            .navigationDestination(for: RocketLaunch.self) { launch in
                LocationView(launch: launch)
                    .navigationTitle(launch.pad)
            }

        }
    }
}

/// Defines a single row of RocketLaunch data.
struct LaunchRow: View {
    var launch: RocketLaunch
    
    var body: some View {
        NavigationLink(value: launch) {
            VStack(alignment: .leading) {
                HStack {
                    Text(launch.name)
                    Spacer()
                    Text(launch.company)
                        .italic()
                }
                Text(launch.date.formatted(date: .abbreviated, time: .standard))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
