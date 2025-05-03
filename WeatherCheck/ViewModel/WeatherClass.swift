import Foundation

class checkWeather:ObservableObject{
    
    @Published var weatherData:WeatherData?
    
    func getWeather() async{
        
        guard let url=URL(string:"https://api.weatherapi.com/v1/forecast.json?key=c26bcefba300410fad863429252204&q=Mumbai&days=3&aqi=no&alerts=no")else{
            print("Invalid URL")
            return
        }
        
        do{
            let (data,_)=try await URLSession.shared.data(from: url)
            let details=try JSONDecoder().decode(WeatherData.self,from:data)
            weatherData=details
        }
        catch{
            print(error)
            return
        }
    }
    
    
    func getSearchData(name:String) async{
        
        guard let url=URL(string:"https://api.weatherapi.com/v1/forecast.json?key=c26bcefba300410fad863429252204&q=\(name)&days=3&aqi=no&alerts=no")else{
            print("Invalid URL")
            return
        }
        
        do{
            let (data,_)=try await URLSession.shared.data(from: url)
            let details=try JSONDecoder().decode(WeatherData.self,from:data)
            weatherData=details
           
        }
        catch{
            print(error)
            return
        }
    }
    
    
    
}
