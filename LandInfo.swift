struct LandInfo: Identifiable, Decodable {
    var id: String
    var latitude: Double
    var longitude: Double
    let area: Double
    let soilType: String
}
struct LandInfoWithWeather {
    let landInfo: LandInfo
    let weather: WeatherDto
}
