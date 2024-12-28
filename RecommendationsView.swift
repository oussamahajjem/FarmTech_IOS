import SwiftUI

struct RecommendationsView: View {
    let weather: WeatherDto
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Agricultural Recommendations".localized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .foregroundColor(.primary) // Adjust text color for readability
                
                RecommendationCard(title: "Irrigation".localized, recommendation: getIrrigationRecommendation(weather: weather))
                RecommendationCard(title: "Planting".localized, recommendation: getPlantingRecommendation(weather: weather))
                RecommendationCard(title: "Plant Disease Risk".localized,recommendation: getPlantDiseaseRisk(weather: weather))
                RecommendationCard(title: "Fruit Trees".localized, recommendation: getFruitTreeRecommendation(weather: weather))
                RecommendationCard(title: "Crop Selection".localized, recommendation: getCropSelectionRecommendation(weather: weather))
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all)) // Ensures background adapts to dark/light mode
        .navigationBarTitle("Recommendations", displayMode: .inline)
    }
    
    private func getIrrigationRecommendation(weather: WeatherDto) -> String {
        guard let forecast = weather.forecasts.first else { return "No forecast data available." }
        let precipitation = forecast.day.totalLiquid.value
        let temperature = forecast.temperature.maximum.value

        switch (precipitation, temperature) {
        case (let p, _) where p > 15.0:
            return "Natural rainfall is sufficient. No irrigation needed. Consider drainage management for excess water."
        case (let p, _) where p > 10.0:
            return "Light irrigation may be needed for water-intensive crops like tomatoes and cucumbers."
        case (let p, _) where p > 5.0:
            return "Moderate irrigation recommended. Focus on deep-rooted crops like olives and grapes."
        case (_, let t) where t > 35.0:
            return "High temperatures expected. Increase irrigation frequency for all crops, especially for citrus trees and vegetables."
        case (_, let t) where t > 30.0:
            return "Warm conditions. Ensure regular irrigation for fruit trees and heat-sensitive crops."
        default:
            return "Regular irrigation recommended. Monitor soil moisture levels, particularly for young plantings and shallow-rooted crops."
        }
    }

    private func getPlantingRecommendation(weather: WeatherDto) -> String {
        guard let forecast = weather.forecasts.first else { return "No forecast data available." }
        let temperature = forecast.temperature.maximum.value
        let precipitation = forecast.day.totalLiquid.value

        switch (temperature, precipitation) {
        case (let t, _) where t < 10.0:
            return "Too cold for most plantings. Consider cold-resistant crops like spinach, carrots, or plant cover crops to protect soil."
        case (10.0...15.0, _):
            return "Good conditions for planting cool-season crops like peas, lettuce, and brassicas. Protect tender seedlings from frost."
        case (15.0...25.0, _):
            return "Ideal planting conditions for a wide range of crops. Good time for tomatoes, peppers, and eggplants."
        case (25.0...30.0, _):
            return "Suitable for heat-loving crops like melons, squash, and okra. Ensure adequate irrigation for new plantings."
        case (let t, _) where t > 30.0:
            return "High temperatures may stress new plantings. Focus on drought-tolerant crops like sorghum or millet. Provide shade and extra water if planting."
        case (_, let p) where p > 20.0:
            return "Soil may be too wet for planting. Wait for drier conditions. Consider raised beds or improve drainage."
        case (_, let p) where p < 5.0:
            return "Dry conditions. Ensure irrigation is available before planting. Consider drought-resistant varieties."
        default:
            return "Good conditions for planting. Ensure proper soil preparation and choose crops suitable for the season."
        }
    }

    private func getPlantDiseaseRisk(weather: WeatherDto) -> String {
        guard let forecast = weather.forecasts.first else { return "No forecast data available." }
        let precipitationProbability = forecast.day.precipitationProbability
        let temperature = forecast.temperature.maximum.value
        let cloudCover = forecast.day.cloudCover

        switch (precipitationProbability, temperature, cloudCover) {
        case (let p, let t, let c) where p > 70 && t > 20 && c > 70:
            return "High risk of fungal diseases, especially for grapes and tomatoes. Monitor crops closely and consider preventive fungicide application. Ensure good air circulation in orchards and vineyards."
        case (let p, 15.0...25.0, _) where p > 50:
            return "Moderate risk of plant diseases. Watch for early blight in tomatoes and potatoes. Ensure good air circulation in crops and avoid overhead irrigation."
        case (let p, let t, _) where t > 30 && p < 30:
            return "Low fungal disease risk, but watch for heat stress and sunscald, especially in fruit trees and peppers. Monitor for insect pests which may thrive in hot conditions."
        default:
            return "Low risk of plant diseases. Maintain regular monitoring practices. Focus on general plant health to improve disease resistance."
        }
    }

    private func getFruitTreeRecommendation(weather: WeatherDto) -> String {
        guard let forecast = weather.forecasts.first else { return "No forecast data available." }
        let temperature = forecast.temperature.maximum.value
        let precipitation = forecast.day.totalLiquid.value
        let windSpeed = forecast.day.wind.speed.value

        var recommendation = ""

        switch temperature {
        case let t where t > 35:
            recommendation += "Extreme heat stress for fruit trees. Increase irrigation and consider shade cloth for sensitive trees like avocados. "
        case 30.0...35.0:
            recommendation += "High temperatures may stress fruit trees. Ensure adequate irrigation, especially for citrus and stone fruits. "
        case 20.0...30.0:
            recommendation += "Optimal temperature range for most fruit trees. Good conditions for fruit development. "
        case let t where t < 10:
            recommendation += "Cold stress possible. Protect sensitive trees like young citrus. Delay pruning of deciduous fruit trees. "
        default:
            break
        }

        switch precipitation {
        case let p where p > 20:
            recommendation += "Heavy rain may lead to waterlogging. Ensure good drainage in orchards. Watch for fungal diseases in susceptible fruits like peaches. "
        case let p where p < 5 && temperature > 25:
            recommendation += "Dry conditions. Prioritize irrigation for fruit trees, especially those with developing fruits. "
        default:
            break
        }

        if windSpeed > 30 {
            recommendation += "High winds forecasted. Secure young trees and consider wind breaks for orchards. "
        }

        recommendation += "Regular monitoring for pests and diseases is always recommended."

        return recommendation
    }

    private func getCropSelectionRecommendation(weather: WeatherDto) -> String {
        guard let forecast = weather.forecasts.first else { return "No forecast data available." }
        let averageTemp = (forecast.temperature.maximum.value + forecast.temperature.minimum.value) / 2
        let precipitation = forecast.day.totalLiquid.value
        let sunHours = forecast.hoursOfSun

        switch (averageTemp, precipitation, sunHours) {
        case (let t, let p, let s) where t > 25 && p < 10 && s > 8:
            return "Hot and dry conditions forecasted. Consider drought-tolerant crops like olives, figs, almonds, and pomegranates. For vegetables, okra, sweet potatoes, and heat-resistant tomato varieties are good choices."
        case (20.0...25.0, 10.0...20.0, _):
            return "Moderate temperatures with adequate rainfall. Excellent conditions for a wide range of crops including citrus fruits, grapes, tomatoes, peppers, and eggplants. Consider planting herbs like thyme and rosemary which thrive in Mediterranean climates."
        case (15.0...20.0, let p, _) where p > 20:
            return "Cool temperatures with high rainfall expected. Good conditions for leafy greens, brassicas (cabbage, cauliflower), and root vegetables. Consider planting cover crops to prevent soil erosion."
        case (let t, _, _) where t < 15:
            return "Cool conditions forecasted. Focus on cold-hardy crops like spinach, kale, carrots, and onions. It's a good time to plant deciduous fruit trees while they're dormant."
        default:
            return "Varied conditions expected. Diversify your crop selection to mitigate risks. Consider intercropping compatible plants to maximize land use and resilience."
        }
    }
}

struct RecommendationCard: View {
    let title: String
    let recommendation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary) // Adjust text color for readability
            Text(recommendation)
                .font(.body)
                .foregroundColor(.secondary) // Adjust text color for readability
        }
        .padding()
        .background(Color(UIColor.systemBackground)) // Background adapts to dark/light mode
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
