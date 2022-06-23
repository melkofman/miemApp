//
//  TimetableDataSource.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 10.01.2021.
//

import Alamofire
import Foundation

private struct TimetableResponse: Decodable {
  let Lessons: [TimetableItemModel]
}

struct TimetableItemModel: Decodable, Equatable {
  let auditorium: String
  let lessonNumberStart: Int
  let beginLesson: String
  let endLesson: String
  let date: String
  let dayOfWeekString: String
  let building: String
  let discipline: String
  let kindOfWork: String?
  let url1: String?
  let lecturer: String
}

final class TimetableDataSource {
  private let user: Variable<User>
  private let session = makeDefaultSession()
  
  private var onUpdate: (([TimetableDayModel]) -> Void)?
  private var isUpdating: Bool = false
  
  var dates: (Date, Date) {
    didSet {
      setNeedsUpdate()
    }
  }
  
  init(initialDates: (Date, Date), user: Variable<User>) {
    dates = initialDates
    self.user = user
  }
  
  func setOnUpdate(onUpdate: @escaping ([TimetableDayModel]) -> Void) {
    self.onUpdate = onUpdate
  }
  
  func setNeedsUpdate() {
    guard !isUpdating else {
      return
    }
    update()
  }
  
  private func update() {
    isUpdating = true
    var status = user.value.hseEmail.components(separatedBy: "@")[1]
    switch status {
    case "edu.hse.ru":
      status = "student"
    case "hse.ru":
      status = "lecturer"
    default:
      status = "person"
    }
    let url = "https://ruz.hse.ru/api/schedule/\(status)/?email=\(user.value.hseEmail)&\(makeDates())&lng=1"
    session.request(url).response { response in
      
      
      guard let data = response.data,
            let parsedResponse = try? JSONDecoder().decode([TimetableItemModel].self, from: data) else {
              self.isUpdating = false
              return
            }
      var dayModels = [TimetableDayModel]()
      
      
      var currentDate = parsedResponse.first?.date.toDate()
      var currentLessons = [TimetableItemModel]()
      parsedResponse.forEach {
        let date = $0.date.toDate()
        if date == currentDate {
          currentLessons.append($0)
        } else {
          dayModels.append(TimetableDayModel(date: currentDate, dayOfWeek: currentLessons[0].dayOfWeekString, items: currentLessons))
          currentDate = date
          currentLessons = [$0]
        }
      }
      if !currentLessons.isEmpty {
        dayModels.append(
          TimetableDayModel(date: currentDate, dayOfWeek: currentLessons[0].dayOfWeekString, items: currentLessons)
        )
      }
      self.onUpdate?(dayModels)
      self.isUpdating = false
    }
  }
  
  private func makeDates() -> String {
    let format = "yyyy-MM-dd"
    return "start=\(dates.0.string(format: format))&finish=\(dates.1.string(format: format))"
  }
}

private extension String {
  func toDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: self)
  }
}
