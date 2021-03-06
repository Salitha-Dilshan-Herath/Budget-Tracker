//
//  Helper.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-16.
//

import Foundation
import UIKit
import EventKit

struct Helper {
    
    //MARK: - Creates an event in the Calendar
    static func createEvent(title: String, endDate: Date, occur: Int, completion: @escaping (Bool, String) -> Void){
        
        ///MARK: - initiate event parameters
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = Date()
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        if let recurrent = Helper.recurrenceRules(occur: occur, end: endDate){
            event.recurrenceRules = [recurrent]
        }
        
        ///MARK: - check permission
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                
                if !granted{
                    
                    completion(false, "No permission to create a calendar event")
                    
                } else {
                    
                    do {
                        
                        try eventStore.save(event, span: .thisEvent)
                        completion(true, event.eventIdentifier)
                        
                    } catch  (let error) {
                        
                        completion(false, error.localizedDescription)
                        
                    }
                }
            })
        } else {
            
            do {
                try eventStore.save(event, span: .thisEvent)
                
                completion(true, event.eventIdentifier)
                
            } catch (let error){
                
                print("Error on create event: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            }
            
        }
    }
    
    //MARK: - Removes an event from the Calendar
    static func deleteEvent(eventIdentifier: String) {
        
        let eventStore = EKEventStore()
        
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                
                if granted  {
                    
                    let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
                    if eventToRemove != nil {
                        do {
                            try eventStore.remove(eventToRemove!, span: .thisEvent)
                        } catch (let error){
                            
                            print("Error on delete event: \(error.localizedDescription)")
                        }
                    }
                    
                }
            })
            
        } else {
            
            let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
            if eventToRemove != nil {
                do {
                    try eventStore.remove(eventToRemove!, span: .thisEvent)
                    
                } catch  (let error){
                    
                    print("Error on delete event: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    static func updateEvent(title: String, endDate: Date, eventIdentifier: String, occur: Int,  completion: @escaping (Bool, String) -> Void){
        
        ///MARK: - initiate event parameter
        let eventStore = EKEventStore()

        
        ///MARK: - check permission
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                
                if !granted{
                    
                    completion(false, "No permission to create a calendar event")
                    
                } else {
                    
                    do {
                        
                        let eventToUpdate = eventStore.event(withIdentifier: eventIdentifier)
                        
                        if let updateObj = eventToUpdate {
                            updateObj.title = title
                            updateObj.endDate = endDate
                            
                            if let recurrent = Helper.recurrenceRules(occur: occur, end: endDate){
                                updateObj.recurrenceRules = [recurrent]
                            } else {
                                updateObj.recurrenceRules = nil
                            }
                            
                            try eventStore.save(updateObj, span: .thisEvent)
                            completion(true, updateObj.eventIdentifier)
                        } else {
                            completion(false, "")
                        }
                       
                        
                    } catch  (let error) {
                        
                        completion(false, error.localizedDescription)
                        
                    }
                }
            })
        } else {
            
            do {
                let eventToUpdate = eventStore.event(withIdentifier: eventIdentifier)
                
                if let updateObj = eventToUpdate {
                    updateObj.title = title
                    updateObj.endDate = endDate
                    try eventStore.save(updateObj, span: .thisEvent)
                    completion(true, updateObj.eventIdentifier)
                } else {
                    completion(false, "")
                }
                
            } catch (let error){
                
                print("Error on update event: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            }
            
        }
    }
    
    ///MARK: Implement recurrenceRules
    private static func recurrenceRules(occur: Int, end: Date) -> EKRecurrenceRule? {
        
        if occur == 1 {
            return EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: EKRecurrenceEnd(end: end))
        } else if occur == 2 {
            return EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: EKRecurrenceEnd(end: end))
        } else if occur == 3{
            return EKRecurrenceRule(recurrenceWith: .monthly, interval: 1, end: EKRecurrenceEnd(end: end))
            
          
        }
        return nil
    }
}
