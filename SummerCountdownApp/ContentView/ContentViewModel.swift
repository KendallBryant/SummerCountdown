//
//  ContentViewModel.swift
//  SummerCountdownApp
//
//  Created by Kendall Bryant on 1/16/24.
//

import SwiftUI
import SwiftyGif
import Pow

final class ContentViewModel: ObservableObject {
    
    @Published var niceMessage = String()
    @Published var niceGIF = String()
    
    let niceMessages: [String]  // Declare niceMessages as an array of strings
    let niceGIFs: [String]
    

    init() {
        niceMessages = [   // Initialize niceMessages with array of messages
            "Have a great day!",
            "You're doing great!",
            "Keep going!",
            "You can do it!",
            "You've got this!"
        ]
        niceMessage = niceMessages.randomElement()!
        
        niceGIFs = [   // Initialize niceGIFs with your array of GIF file name strings
            "g01",
            "g02",
            "g04",
            "g05",
            "g06",
            "g09",
            "g10",
            "g12",
            "g14",
            "g22",
            "g24",
            "g25",
        ]
        niceGIF = niceGIFs.randomElement()!
    }
    

    // starting update GIF functions
    // this function gets a new random GIF
    @objc func updateNiceGif() {
        self.niceGIF = niceGIFs.randomElement()!
        saveLastGifUpdateTime()
    }
    
    // everything below is for running updateNiceGif at 5am
    func scheduleDailyGifRefresh() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 5
        components.minute = 0
        components.second = 0
        
        guard let scheduledDateToday = calendar.date(from: components) else {
            return
        }

        // If 5 AM today has already passed, schedule for 5 AM the next day
        let scheduledDate = scheduledDateToday > Date() ? scheduledDateToday : calendar.date(byAdding: .day, value: 1, to: scheduledDateToday)!
        
        let timer = Timer(fireAt: scheduledDate, interval: 86400, target: self, selector: #selector(updateNiceGif), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func saveLastGifUpdateTime() {
        UserDefaults.standard.set(Date(), forKey: "lastGifUpdateTime")
    }

    func getLastGifUpdateTime() -> Date? {
        return UserDefaults.standard.object(forKey: "lastGifUpdateTime") as? Date
    }

    // Step 3: Check Last Update Time on App Launch
    func checkAndUpdateGifIfNeeded() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 5
        components.minute = 0
        components.second = 0
        let fiveAMToday = calendar.date(from: components)!

        if let lastGifUpdateTime = getLastGifUpdateTime() {
            if lastGifUpdateTime < fiveAMToday {
                updateNiceGif()
            }
        } else {
            // If there's no recorded last update time, update immediately
            updateNiceGif()
        }
    }
    // end updating GIF at 5am
    
    // everything below is the same as the GIF refresh but for messages
    @objc func updateNiceMessage() {
        self.niceMessage = niceMessages.randomElement()!
        saveLastMessageUpdateTime()
    }
    func scheduleDailyMessageRefresh() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 5
        components.minute = 0
        components.second = 0
        
        guard let scheduledDateToday = calendar.date(from: components) else {
            return
        }
        
        // If 5 AM today has already passed, schedule for 5 AM the next day
        let scheduledDate = scheduledDateToday > Date() ? scheduledDateToday : calendar.date(byAdding: .day, value: 1, to: scheduledDateToday)!

        let timer = Timer(fireAt: scheduledDate, interval: 86400, target: self, selector: #selector(updateNiceMessage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    
    func saveLastMessageUpdateTime() {
        UserDefaults.standard.set(Date(), forKey: "lastMessageUpdateTime")
    }

    func getLastMessageUpdateTime() -> Date? {
        return UserDefaults.standard.object(forKey: "lastMessageUpdateTime") as? Date
    }

    // Step 3: Check Last Update Time on App Launch
    func checkAndUpdateMessageIfNeeded() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 5
        components.minute = 0
        components.second = 0
        let fiveAMToday = calendar.date(from: components)!

        if let lastMessageUpdateTime = getLastMessageUpdateTime() {
            if lastMessageUpdateTime < fiveAMToday {
                updateNiceMessage()
            }
        } else {
            // If there's no recorded last update time, update immediately
            updateNiceMessage()
        }
    }
    // end updating messages
    
    // this function decides if we get a reminder to check official school calendar
    func shouldShowMonthlyAlert() -> Bool {
        let lastAlertDate = UserDefaults.standard.object(forKey: "lastAlertDate") as? Date ?? Date.distantPast
        let currentDate = Date()
        
        // Compare months to check if a month has passed since the last alert
        let calendar = Calendar.current
        if let lastMonth = calendar.dateComponents([.month], from: lastAlertDate).month,
           let currentMonth = calendar.dateComponents([.month], from: currentDate).month,
           lastMonth != currentMonth {
            // Update last alert date and return true to show the alert
            UserDefaults.standard.set(currentDate, forKey: "lastAlertDate")
            return true
        }
        return false
    }
}


// this is what should show during the school year
struct CountdownView: View {
    @ObservedObject var datesViewModel: DatesViewModel
    @ObservedObject var contentViewModel: ContentViewModel
    
    var body: some View {
        ScrollView {
            CountDownText(countDownText: "You have")
            Text(datesViewModel.foundValue)
                .frame(width: 200, height: 85)
                .font(.custom("ByteBounce", size: 210))
                .foregroundColor(Color("darkPurple"))
                .padding(.bottom, 15)
            CountDownText(countDownText: "school days left\nuntil summer break.")
                .multilineTextAlignment(.center)
            GifViewControllerRepresentable(gifName: contentViewModel.niceGIF)
                .frame(width: 360, height: 360)
                .padding(.bottom, 15)
            CountDownText(countDownText: contentViewModel.niceMessage)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .refreshable {
            datesViewModel.updateFoundValue()
            // the below would be if I wanted to update the GIF and message
            // on refresh instead of at 5am
//            contentViewModel.updateNiceMessage()
//            contentViewModel.updateNiceGif()
        }
    }
}

// this is what should show if it's summer
struct SummerView: View {
    @ObservedObject var datesViewModel: DatesViewModel
    @ObservedObject var contentViewModel: ContentViewModel
    @State private var viewCount = 0 //remove this if I decide against fireworks
    
    var body: some View {
        ScrollView {
            Text("Have a")
                .font(.custom("AldotheApache", size: 70))
                .foregroundColor(Color("darkPurple"))
                .padding(.top, 25)
            Text("wonderful")
                .font(.custom("AldotheApache", size: 80))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .onAppear {
                    viewCount += 1
                } //remove this if I decide against fireworks
                .changeEffect(.spray { Image(systemName: "sparkle")
                    .foregroundStyle(Color("alienGreen"))
                    .font(.system(size: 50))
                }, value: viewCount, isEnabled: viewCount == 1)
            //also remove the whole change effect above if I decide against
            //fireworks
            Text("summer!")
                .font(.custom("AldotheApache", size: 70))
                .foregroundColor(Color("darkPurple"))
                .multilineTextAlignment(.center)
            GifViewControllerRepresentable(gifName: contentViewModel.niceGIF)
                .frame(width: 360, height: 360)
                .padding(.bottom, 15)
            Spacer()
        }
        .refreshable {
            datesViewModel.updateFoundValue()
//            contentViewModel.updateNiceGif()
        }
    }
}

// this is my GIF controller
class GifViewController: UIViewController {
    let gifImageView = UIImageView()
    var gifName: String
    
    init(gifName: String) {
        self.gifName = gifName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(gifImageView)
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //   gifImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor), //I commented this out to move my GIF
            // down the screen, this line was putting
            // his feet right in the center
            gifImageView.widthAnchor.constraint(equalToConstant: 360),
            gifImageView.heightAnchor.constraint(equalToConstant: 360)
        ])
        updateGifImage()
        do {
            let gif = try UIImage(gifName: gifName)
            gifImageView.setGifImage(gif)
            gifImageView.loopCount = -1 // Infinite loop
        } catch {
            print(error)
        }
    }
}

struct GifViewControllerRepresentable: UIViewControllerRepresentable {
    var gifName: String
    func makeUIViewController(context: Context) -> GifViewController {
        GifViewController(gifName: gifName)
    }
    func updateUIViewController(_ uiViewController: GifViewController, context: Context) {
        if uiViewController.gifName != gifName {
            uiViewController.gifName = gifName
            uiViewController.updateGifImage()
        }
    }
}
extension GifViewController {
    func updateGifImage() {
        do {
            let gif = try UIImage(gifName: gifName)
            gifImageView.setGifImage(gif)
            gifImageView.loopCount = -1 // Infinite loop
        } catch {
            print(error)
        }
    }
}
// end GIF controller


// this formats all the white text to make my views a little cleaner
struct CountDownText: View {
    var countDownText: String
    var body: some View {
        Text(countDownText)
            .font(.custom("AldotheApache", size: 35))
            .foregroundColor(.white)
    }
}
