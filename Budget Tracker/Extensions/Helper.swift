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
    static func createEvent(title: String, endDate: Date, completion: @escaping (Bool, String) -> Void){
        
        ///MARK: - initiate event parameters
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = Date()
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
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
                
                print(error)
                completion(false, error.localizedDescription)
            }
            
        }
    }
    
    //MARK: - Removes an event from the Calendar
    static func deleteEvent(eventIdentifier: String, vc: UIViewController) -> Bool {
        
        let eventStore = EKEventStore()
        
        var isHavePermission = true
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                
                if error != nil {
                    isHavePermission = false
                }
            })
        }
        
        if !isHavePermission {
            Alert.showMessage(msg: "No permission to delete a calendar event.", on: vc)
            return false
        }
        
        
        var success = false
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if eventToRemove != nil {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
                success = true
            } catch {
                
                Alert.showMessage(msg: "Unable to delete calendar event", on: vc)
                
            }
        }
        return success
    }
}
