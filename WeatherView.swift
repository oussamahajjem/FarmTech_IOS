import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.white]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    switch viewModel.weatherState {
                    case .loading:
                        ProgressView("Loading weather data...")
                            .padding()
                    case .success(let weatherData):
                        Text(weatherData.summary.phrase)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ForEach(weatherData.forecasts, id: \.date) { forecast in
                            ForecastCard(forecast: forecast)
                        }
                        
                        RecommendationsView(weather: weatherData)
                    case .error(let errorMessage):
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.top, 50)
            }
        }
        .navigationBarTitle("Weather Forecast", displayMode: .inline)
        .onAppear {
            viewModel.fetchWeatherData(latitude: 36.8065, longitude: 10.1815) // Coordinates for Tunis, Tunisia
        }
    }
}
    
struct ForecastCard: View {
    let forecast: ForecastDto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(formatDate(forecast.date))
                .font(.headline)
                .foregroundColor(.primary) // Ensure the text color adapts to dark mode
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Temperature")
                        .font(.subheadline)
                        .foregroundColor(.secondary) // Use secondary color for better contrast
                    Text("\(Int(forecast.temperature.minimum.value))°C - \(Int(forecast.temperature.maximum.value))°C")
                        .font(.title2)
                        .foregroundColor(.primary) // Ensure the text color adapts to dark mode
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Image(systemName: iconForWeatherCondition(forecast.day.iconPhrase))
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    Text(forecast.day.iconPhrase)
                        .font(.caption)
                        .foregroundColor(.secondary) // Ensure the text color adapts to dark mode
                }
            }
            
            HStack {
                WeatherInfoItem(title: "Precipitation", value: "\(forecast.day.precipitationProbability)%", icon: "cloud.rain.fill")
                Spacer()
                WeatherInfoItem(title: "Wind", value: "\(Int(forecast.day.wind.speed.value)) \(forecast.day.wind.speed.unit)", icon: "wind")
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Use system background color to adapt to dark mode
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}


struct WeatherInfoItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
    }
}
class WeatherViewModel: ObservableObject {
    @Published private(set) var weatherState: WeatherState = .loading

    private let networkService = NetworkService.shared

    func fetchWeatherData(latitude: Double, longitude: Double) {
        weatherState = .loading

        networkService.getWeather(latitude: latitude, longitude: longitude) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.weatherState = .success(data)
                case .failure(let error):
                    self.weatherState = .error(error.localizedDescription)
                }
            }
        }
    }
}

enum WeatherState {
    case loading
    case success(WeatherDto)
    case error(String)
}

func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "EEEE, MMM d"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    return dateString
}

func iconForWeatherCondition(_ condition: String) -> String {
    switch condition.lowercased() {
    case _ where condition.contains("sun"):
        return "sun.max.fill"
    case _ where condition.contains("cloud"):
        return "cloud.fill"
    case _ where condition.contains("rain"):
        return "cloud.rain.fill"
    case _ where condition.contains("storm"):
        return "cloud.bolt.rain.fill"
    default:
        return "cloud.fill"
    }
}

