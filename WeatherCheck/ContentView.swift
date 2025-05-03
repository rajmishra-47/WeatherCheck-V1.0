import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    

    @StateObject var obj = checkWeather()
    
    @State private var TextFieldValue = ""
    @State private var currentPlace = "Mumbai"
    @State private var lat: Double = 0.0
    @State private var lon: Double = 0.0
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.075, longitude: 72.87),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    var body: some View {
        ScrollView {
            
            VStack(alignment: .leading, spacing: 20) {
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Welcome User")
                        .font(.largeTitle)
                        .bold()
                    Text("Look how the day will be")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                
                HStack(spacing: 12) {
                    TextField("Enter location", text: $TextFieldValue)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity)
                    
                    Button("Search") {
                        if !TextFieldValue.isEmpty {
                            Task {
                                
                                await obj.getSearchData(name: TextFieldValue)
                                
                                currentPlace = TextFieldValue
                                TextFieldValue = ""
                                
                                lat = obj.weatherData?.location.lat ?? 0
                                lon = obj.weatherData?.location.lon ?? 0
                                
                                region = MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                    span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                                )
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
               
                HStack(spacing:30){
                    AsyncImage(url: URL(string: "\(obj.weatherData?.current.condition.img ?? "")")) {
                        $0.resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(obj.weatherData?.current.tempCRounded ?? 0)°C")
                            .font(.title2)
                            .bold()
                        Text(currentPlace)
                            .font(.headline)
                        Text(obj.weatherData?.current.condition.text ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    
                    VStack {
                        Image(systemName: "wind")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(obj.weatherData?.current.windSpeed ?? 0) kmph")
                            .font(.caption)
                    }
                }
                .padding(.horizontal)
                
               
                VStack(alignment: .leading, spacing: 10) {
                    Text("Forecast")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(obj.weatherData?.forecast.forecastday ?? []) { day in
                                VStack(spacing: 8) {
                                    Text(day.date)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                        .frame(width: 80)
                                    
                                    AsyncImage(url: URL(string: day.day.condition.img)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 40, height: 40)
                                    
                                    Text("Max: \(Int(day.day.maxtempCRounded))°C")
                                        .font(.caption)
                                    Text("Min: \(Int(day.day.mintempCRounded))°C")
                                        .font(.caption)
                                }
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Map Section
                VStack(alignment: .leading) {
                    Text("Location Map")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Map(coordinateRegion: $region)
                        .frame(height: 300)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .cyan.opacity(0.4)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
        .onAppear {
            Task {
                await obj.getWeather()
            }
        }
    }
}

#Preview {
    ContentView()
}
