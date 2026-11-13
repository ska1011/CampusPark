import SwiftUI
import MapKit
public import Combine

struct ContentView: View {

    @State private var showSplash = true
    @State private var seconds = 0

    @AppStorage("isDarkMode") private var isDarkMode = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {

        ZStack {

            if showSplash {
                SplashView()
            } else {
                MainTabView()
            }

        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onReceive(timer) { _ in

            if showSplash {
                seconds += 1

                if seconds >= 3 {
                    showSplash = false
                }
            }
        }
    }
}


// MARK: - Splash Screen

struct SplashView: View {

    var body: some View {

        ZStack {

            Color.blue.opacity(0.10)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Image(systemName: "car.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("CampusPark")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)

                Text("HCT Sharjah Parking Finder")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
    }
}


// MARK: - Main Navigation

struct MainTabView: View {

    var body: some View {

        TabView {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationStack {
                ParkingMapView()
            }
            .tabItem {
                Image(systemName: "map")
                Text("Map")
            }

            NavigationStack {
                ParkingHistoryView()
            }
            .tabItem {
                Image(systemName: "clock")
                Text("History")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape.fill")
                Text("Settings")
            }
        }
        .tint(.blue)
    }
}


// MARK: - Home Screen

struct HomeView: View {

    var body: some View {

        ZStack {

            Color.blue.opacity(0.05)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {

                Text("Good morning,")
                    .font(.title3)

                Text("HCT Student!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)

                Text("Easily save, find and remember your parking location on campus.")
                    .foregroundColor(.gray)

                Spacer()

                NavigationLink(destination: SaveMyCarView()) {

                    HStack {
                        Image(systemName: "car.fill")
                        Text("Save My Car")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                NavigationLink(destination: ParkingMapView()) {

                    HStack {
                        Image(systemName: "mappin.circle.fill")
                        Text("Find My Car")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                }

                NavigationLink(destination: SaveMyCarView()) {

                    HStack {
                        Image(systemName: "bell.fill")
                        Text("Set Reminder")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.15))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("CampusPark")
    }
}


// MARK: - Parking Map

struct ParkingMapView: View {
    
    @ObservedObject var locationManager = LocationManager()

    let campus = CLLocationCoordinate2D(
        latitude: 25.29419,
        longitude: 55.47637
    )

    var body: some View {

        Map(
            initialPosition: .region(
                MKCoordinateRegion(
                    center: campus,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.008,
                        longitudeDelta: 0.008
                    )
                )
            ),
            interactionModes: .all
        ) {

            Marker(
                "HCT Sharjah",
                coordinate: campus
            )
            .tint(.blue)

        }
        .mapStyle(.standard)
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
        .navigationTitle("Parking Map")
        .onAppear {
            locationManager.requestPermission()
        }
    }
}

// MARK: - Save My Car (Next Step)

struct SaveMyCarView: View {

    var body: some View {

        VStack(spacing: 20) {

            Image(systemName: "car.fill")
                .font(.system(size: 70))
                .foregroundColor(.blue)

            Text("Save My Car")
                .font(.largeTitle)

            Text("Parking form will be added next.")
                .foregroundColor(.gray)
        }
        .navigationTitle("Save My Car")
    }
}


// MARK: - Parking History (Next Step)

struct ParkingHistoryView: View {

    var body: some View {

        VStack(spacing: 20) {

            Image(systemName: "clock.fill")
                .font(.system(size: 70))
                .foregroundColor(.blue)

            Text("Parking History")
                .font(.largeTitle)

            Text("Your saved parking records will appear here.")
                .foregroundColor(.gray)
        }
        .navigationTitle("Parking History")
    }
}


// MARK: - Settings

struct SettingsView: View {

    @AppStorage("favoriteParkingArea")
    private var favoriteParkingArea = "Parking Area A"

    @AppStorage("notificationsEnabled")
    private var notificationsEnabled = true

    @AppStorage("isDarkMode")
    private var isDarkMode = false

    let parkingAreas = [
        "Parking Area A",
        "Parking Area B",
        "Parking Area C"
    ]

    var body: some View {

        Form {

            Section("Parking Preferences") {

                Picker("Favorite Parking Area",
                       selection: $favoriteParkingArea) {

                    ForEach(parkingAreas, id: \.self) { area in
                        Text(area)
                    }
                }
            }

            Section("General") {

                Toggle("Notifications",
                       isOn: $notificationsEnabled)

                Toggle("Dark Mode",
                       isOn: $isDarkMode)
            }
        }
        .navigationTitle("Settings")
    }
}
