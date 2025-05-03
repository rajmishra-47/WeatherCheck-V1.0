import Foundation
import Combine

struct WeatherData: Codable,Identifiable {
    var id:Int?
    let current: CurrentWeather
    let forecast: Forecast
    let location: Location
    
}

struct CurrentWeather: Codable,Identifiable {
    var id:Int?
    let temp_c: Double
    let condition: WeatherCondition
    let wind_kph:Double
    
    var tempCRounded: Int {
           Int(temp_c.rounded())
       }
    
    var windSpeed:Int{
        Int(wind_kph.rounded())
    }
}

struct Forecast: Codable,Identifiable {
    var id:Int?
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable,Identifiable {
    var id:Int?
    let date: String
    let day: DayWeather
}

struct DayWeather: Codable,Identifiable {
    var id:Int?
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: WeatherCondition
    
    var maxtempCRounded: Int {
           Int(maxtemp_c.rounded())
       }
    
    var mintempCRounded: Int {
           Int(mintemp_c.rounded())
       }
}

struct WeatherCondition: Codable,Identifiable {
    var id:Int?
    let text: String
    let icon: String
    
    var img:String{
        String("https://"+icon.dropFirst(2))
    }
}


struct Location:Codable,Identifiable{
    var id:Int?
    let lat:Double
    let lon:Double
}
