import Foundation

struct WeatherDto: Codable {
    let summary: SummaryDto
    let forecasts: [ForecastDto]
}

struct SummaryDto: Codable {
    let startDate: String
    let severity: Int
    let phrase: String
    let category: String
}

struct ForecastDto: Codable {
    let date: String
    let temperature: TemperatureRangeDto
    let realFeelTemperature: TemperatureRangeDto
    let realFeelTemperatureShade: TemperatureRangeDto
    let hoursOfSun: Double
    let degreeDaySummary: DegreeDaySummaryDto
    let airAndPollen: [AirAndPollenDto]
    let day: PeriodDto
    let night: PeriodDto
    let sources: [String]
}

struct TemperatureRangeDto: Codable {
    let minimum: TemperatureDto
    let maximum: TemperatureDto
}

struct TemperatureDto: Codable {
    let value: Double
    let unit: String
    let unitType: Int
}

struct DegreeDaySummaryDto: Codable {
    let heating: TemperatureDto
    let cooling: TemperatureDto
}

struct AirAndPollenDto: Codable {
    let name: String
    let value: Int
    let category: String
    let categoryValue: Int
    let type: String?
}

struct PeriodDto: Codable {
    let iconCode: Int
    let iconPhrase: String
    let hasPrecipitation: Bool
    let precipitationType: String?
    let precipitationIntensity: String?
    let shortPhrase: String
    let longPhrase: String
    let precipitationProbability: Int
    let thunderstormProbability: Int
    let rainProbability: Int
    let snowProbability: Int
    let iceProbability: Int
    let wind: WindDto
    let windGust: WindDto
    let totalLiquid: PrecipitationDto
    let rain: PrecipitationDto
    let snow: PrecipitationDto
    let ice: PrecipitationDto
    let hoursOfPrecipitation: Double
    let hoursOfRain: Double
    let hoursOfSnow: Double
    let hoursOfIce: Double
    let cloudCover: Int
}

struct WindDto: Codable {
    let direction: DirectionDto
    let speed: SpeedDto
}

struct DirectionDto: Codable {
    let degrees: Int
    let localizedDescription: String
}

struct SpeedDto: Codable {
    let value: Double
    let unit: String
    let unitType: Int
}

struct PrecipitationDto: Codable {
    let value: Double
    let unit: String
    let unitType: Int
}

extension WeatherDto {
    static var mockData: WeatherDto {
        WeatherDto(
            summary: SummaryDto(
                startDate: "2024-12-05",
                severity: 3,
                phrase: "Partly cloudy with a chance of rain",
                category: "Cloudy"
            ),
            forecasts: [
                ForecastDto(
                    date: "2024-12-05",
                    temperature: TemperatureRangeDto(
                        minimum: TemperatureDto(value: 18.0, unit: "C", unitType: 1),
                        maximum: TemperatureDto(value: 30.0, unit: "C", unitType: 1)
                    ),
                    realFeelTemperature: TemperatureRangeDto(
                        minimum: TemperatureDto(value: 19.0, unit: "C", unitType: 1),
                        maximum: TemperatureDto(value: 32.0, unit: "C", unitType: 1)
                    ),
                    realFeelTemperatureShade: TemperatureRangeDto(
                        minimum: TemperatureDto(value: 17.0, unit: "C", unitType: 1),
                        maximum: TemperatureDto(value: 28.0, unit: "C", unitType: 1)
                    ),
                    hoursOfSun: 8.0,
                    degreeDaySummary: DegreeDaySummaryDto(
                        heating: TemperatureDto(value: 0.0, unit: "C", unitType: 1),
                        cooling: TemperatureDto(value: 5.0, unit: "C", unitType: 1)
                    ),
                    airAndPollen: [
                        AirAndPollenDto(
                            name: "Tree Pollen",
                            value: 2,
                            category: "Low",
                            categoryValue: 1,
                            type: nil
                        )
                    ],
                    day: PeriodDto(
                        iconCode: 3,
                        iconPhrase: "Partly sunny",
                        hasPrecipitation: true,
                        precipitationType: "Rain",
                        precipitationIntensity: "Moderate",
                        shortPhrase: "Partly sunny with a chance of rain",
                        longPhrase: "Partly sunny with scattered showers in the afternoon",
                        precipitationProbability: 40,
                        thunderstormProbability: 20,
                        rainProbability: 40,
                        snowProbability: 0,
                        iceProbability: 0,
                        wind: WindDto(
                            direction: DirectionDto(degrees: 180, localizedDescription: "South"),
                            speed: SpeedDto(value: 15.0, unit: "km/h", unitType: 1)
                        ),
                        windGust: WindDto(
                            direction: DirectionDto(degrees: 180, localizedDescription: "South"),
                            speed: SpeedDto(value: 25.0, unit: "km/h", unitType: 1)
                        ),
                        totalLiquid: PrecipitationDto(value: 5.0, unit: "mm", unitType: 1),
                        rain: PrecipitationDto(value: 5.0, unit: "mm", unitType: 1),
                        snow: PrecipitationDto(value: 0.0, unit: "mm", unitType: 1),
                        ice: PrecipitationDto(value: 0.0, unit: "mm", unitType: 1),
                        hoursOfPrecipitation: 2.0,
                        hoursOfRain: 2.0,
                        hoursOfSnow: 0.0,
                        hoursOfIce: 0.0,
                        cloudCover: 50
                    ),
                    night: PeriodDto(
                        iconCode: 33,
                        iconPhrase: "Clear",
                        hasPrecipitation: false,
                        precipitationType: nil,
                        precipitationIntensity: nil,
                        shortPhrase: "Clear and cool",
                        longPhrase: "Clear and cool throughout the night",
                        precipitationProbability: 0,
                        thunderstormProbability: 0,
                        rainProbability: 0,
                        snowProbability: 0,
                        iceProbability: 0,
                        wind: WindDto(
                            direction: DirectionDto(degrees: 180, localizedDescription: "South"),
                            speed: SpeedDto(value: 10.0, unit: "km/h", unitType: 1)
                        ),
                        windGust: WindDto(
                            direction: DirectionDto(degrees: 180, localizedDescription: "South"),
                            speed: SpeedDto(value: 15.0, unit: "km/h", unitType: 1)
                        ),
                        totalLiquid: PrecipitationDto(value: 0.0, unit: "mm", unitType: 1),
                        rain: PrecipitationDto(value: 0.0, unit: "mm", unitType: 1),
                        snow: PrecipitationDto(value: 0.0, unit: "mm", unitType: 1),
                        ice: PrecipitationDto(value: 0.0, unit: "mm", unitType: 1),
                        hoursOfPrecipitation: 0.0,
                        hoursOfRain: 0.0,
                        hoursOfSnow: 0.0,
                        hoursOfIce: 0.0,
                        cloudCover: 10
                    ),
                    sources: ["MockSource"]
                )
            ]
        )
    }
}
