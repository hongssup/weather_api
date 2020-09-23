//
//  ViewController.swift
//  weather_api
//
//  Created by SeoYeon on 2020/09/06.
//  Copyright © 2020 SeoYeon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let cities = ["Seoul", "Incheon", "Daegu", "Busan", "Ulsan", "Gwangju"]
    
    @IBOutlet weak var tableView: UITableView!
    
    func fetchWeather(_ cityName: String) -> (temp: Float, humid: Int, wind: Float) {
        let headers = [
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
            "x-rapidapi-key": "809d751bb2msh012338b6953c756p169d82jsn314e7888acbc"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://community-open-weather-map.p.rapidapi.com/weather?callback=test&id=2172797&units=%2522metric%2522%20or%20%2522imperial%2522&mode=xml%252C%20html&q=\(cityName)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        var temperature: Float = 0
        
        let session = URLSession.shared
           let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
               if (error != nil) {
                   print(error)
               } else {
                   let httpResponse = response as? HTTPURLResponse
                   //print(httpResponse)
                   // Try to parse out the data
    
                   let jsonString = String(String(data: data!, encoding: .utf8)!.dropFirst().dropFirst().dropFirst().dropFirst().dropFirst().dropLast())
                   let result = try! JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: []) as! [String:Any]
                   //print(result)
    
                   let main = result["main"]! as! [String:NSNumber]
                   let temperature = main["temp"]!.floatValue
                   let humidity = main["humidity"]!.intValue
    
                   let wind = result["wind"]! as! [String:NSNumber]
                   let windDegree = wind["deg"]!.intValue
                   let windSpeed = wind["speed"]!.floatValue
    
                   print("cityName: \(cityName) temperature: \(temperature) humidity: \(humidity) windDegree: \(windDegree) windSpeed: \(windSpeed)")
                
                    
                }
            })
        
            dataTask.resume()
        return (temperature, 0, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let headers = [
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
            "x-rapidapi-key": "809d751bb2msh012338b6953c756p169d82jsn314e7888acbc"
        ]
        let city = "Daegu"
        let request = NSMutableURLRequest(url: NSURL(string: "https://community-open-weather-map.p.rapidapi.com/weather?callback=test&id=2172797&units=%2522metric%2522%20or%20%2522imperial%2522&mode=xml%252C%20html&q=\(city)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
               let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                   if (error != nil) {
                       print(error)
                   } else {
                       let httpResponse = response as? HTTPURLResponse
                       //print(httpResponse)
                       // Try to parse out the data
        
                       let jsonString = String(String(data: data!, encoding: .utf8)!.dropFirst().dropFirst().dropFirst().dropFirst().dropFirst().dropLast())
                       let result = try! JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: []) as! [String:Any]
                       print(result)
        
                       let main = result["main"]! as! [String:NSNumber]
                       let temperature = main["temp"]!.floatValue
                       let humidity = main["humidity"]!.intValue
        
                       let wind = result["wind"]! as! [String:NSNumber]
                       let windDegree = wind["deg"]!.intValue
                       let windSpeed = wind["speed"]!.floatValue
        
                       print("temperature: \(temperature) humidity: \(humidity) windDegree: \(windDegree) windSpeed: \(windSpeed)")
                   }
               })
        
               dataTask.resume()
/*
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                //print(httpResponse)
                // Try to parse out the data
                
                var parsed = String(String(data: data!, encoding:.utf8)!.dropFirst().dropFirst().dropFirst().dropFirst().dropFirst().dropLast())
                //print(parsed)
                //print(parsed["coord"])
                let result = try? JSONSerialization.jsonObject(with: Data(parsed.utf8)) as? [String:Any]
                //let result = try? JSONSerialization.jsonObject(with: Data(parsed.utf8), options: .mutableContainers) as? [String:Any]
                print(result)
                print(result!["wind"]["speed"])
//                do {
//                    //let dictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
//                    //print(dictionary)
//                    print(String(data: data!, encoding: .utf8))
//                }
//                catch{
//                    print("Error parsing response data")
//                }
                //print(data)
            }
        })

        dataTask.resume()
 */
    }


}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = 6
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        let city = cities[indexPath.row]
        cell.cityTextLabel?.text = city
         //city.temp
//        cell.humidTextLabel?.text = city.humid
//        cell.windImageView?.image = UIImage()
        DispatchQueue.main.async {
            let result = self.fetchWeather(city)
            
            cell.tempTextLabel?.text = "\(result.temp)"
            print(result)
        }
        return cell
    }
    
    
}
class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var cityTextLabel: UILabel!
    @IBOutlet weak var tempTextLabel: UILabel!
    @IBOutlet weak var humidTextLabel: UILabel!
    @IBOutlet weak var windImageView: UIImageView!
}
