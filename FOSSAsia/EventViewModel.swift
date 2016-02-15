//
//  EventViewModel.swift
//  FOSSAsia
//
//  Created by Jurvis Tan on 29/1/16.
//  Copyright © 2016 FossAsia. All rights reserved.
//

import Foundation


protocol EventTypePresentable {
    var typeColor: UIColor {get}
}

protocol EventDetailsPresentable {
    var eventName: String {get}
    var speakerName: String {get}
    var timing: String {get}
    var isFavorite: Bool {get}
}

protocol EventDescriptionPresentable {
    var eventDescription: String {get }
}

protocol EventAddToCalendarPresentable {
    var eventStartTime: String {get}
    var eventEndTime: String {get}
    var eventDay: String {get}
    var eventDate: String {get}
    var eventMonth: String {get}
    var eventStartDate: NSDate {get}
    var eventEndDate: NSDate {get}
}

struct EventViewModel: EventTypePresentable, EventDetailsPresentable, EventDescriptionPresentable, EventAddToCalendarPresentable {
    let sessionId: Observable<Int>
    let track: Observable<UIColor>
    let title: Observable<String>
    let shortDescription: Observable<String>
    let speaker: Observable<Speaker?>
    let location: Observable<String>
    let startDateTime: Observable<NSDate>
    let endDateTime: Observable<NSDate>
    let favorite: Observable<Bool>
    
    init (_ event: Event) {
        sessionId = Observable(event.id)
        track = Observable(event.trackCode.getTrackColor())
        title = Observable(event.title)
        shortDescription = Observable(event.shortDescription)
        speaker = Observable(event.speaker)
        location = Observable(event.location)
        startDateTime = Observable(event.startDateTime)
        endDateTime = Observable(event.endDateTime)
        favorite = Observable(event.favorite)
    }
    
    func updateFavorite() {
        favorite.value = !favorite.value
    }
}

// MARK: - EventDescriptionPresentable Conformance
extension EventViewModel {
    var eventDescription: String { return shortDescription.value }
}

// MARK: - TypePresentable Conformance
extension EventViewModel {
    var typeColor: UIColor { return self.track.value }
}

// MARK: - EventPresentable Conformance
extension EventViewModel {
    var eventName: String { return self.title.value }
    var speakerName: String { return (self.speaker.value?.name)! }
    var timing: String {
        let startTime = self.startDateTime.value.formattedDateWithFormat("HH:mm")
        let endTime = self.endDateTime.value.formattedDateWithFormat("HH:mm")
        return  "\(startTime) - \(endTime) - \(self.location.value)"
    }
    var isFavorite: Bool { return self.favorite.value }
}

// MARK: - EventAddToCalendar Conformance
extension EventViewModel {
    var eventStartTime: String { return self.startDateTime.value.formattedDateWithFormat("HH:mm") }
    var eventEndTime: String { return self.endDateTime.value.formattedDateWithFormat("HH:mm") }
    var eventDate: String { return self.startDateTime.value.formattedDateWithFormat("dd") }
    var eventDay: String { return self.startDateTime.value.formattedDateWithFormat("EEEE") }
    var eventMonth: String { return self.startDateTime.value.formattedDateWithFormat("MMM") }
    var eventStartDate: NSDate { return self.startDateTime.value }
    var eventEndDate: NSDate { return self.endDateTime.value }
}