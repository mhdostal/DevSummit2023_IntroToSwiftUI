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
import ArcGISToolkit

/// A view showing a map and the location of the launch pad.
struct LocationView: View {
    /// RocketLaunch data.
    var launch: RocketLaunch
    
    // `viewpoint` is used to display the launch pad location on the map
    // and also to allow the scalebar to compute the map scale.
    @State var viewpoint: Viewpoint?
    
    // The Map we're displaying
    @State var map = Map(basemapStyle: .arcGISImagery)
    
    // These are both used by the Scalebar for its calculations.
    @State private var unitsPerPoint: Double?
    @State private var spatialReference: SpatialReference?

    var body: some View {
        MapView(map: map, viewpoint: viewpoint)
            .onSpatialReferenceChanged { spatialReference = $0 }
            .onUnitsPerPointChanged { unitsPerPoint = $0 }
            .onViewpointChanged(kind: .centerAndScale) { viewpoint = $0 }
            .overlay(alignment: .bottom) {
                HStack {
                    Scalebar(
                        maxWidth: 200,
                        spatialReference: $spatialReference,
                        unitsPerPoint: $unitsPerPoint,
                        viewpoint: $viewpoint
                    )
                    .padding(12)
                    .esriBorder()
                    Spacer()
                }
                .padding([.leading], 12)
                .padding([.bottom], 48)
            }
            .onAppear() {
                // This gets called when the view first appears
                viewpoint = Viewpoint(center: launch.location, scale: 15_000)
            }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var launch = RocketLaunch(
        name: "Good Luck, Have Fun",
        company: "Relativity Space",
        date: Date(timeIntervalSince1970: 1678298400),
        pad: "SLC-16",
        location: Point(x: -80.5518, y: 28.5017, spatialReference: .wgs84)
    )

    static var previews: some View {
        LocationView(launch: launch)
    }
}
