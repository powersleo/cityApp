//
//  SettingsView.swift
//  City
//
//  Created by Leo Powers on 5/8/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isNotificationsEnabled")
    private var isNotificationEnabled = true
    
    @AppStorage("isSleepTrackingEnabled")
    private var isSleepTrackingEnabled = true
    
    @AppStorage("sleepTrackingMode")
    private var sleepTrackingMode = 0
    
    @AppStorage("sleepGoal")
    private var sleepGoal = 8

    var body: some View {
        Form {
                        Section(header: Text("Notifications settings")) {
                            Toggle(isOn: $isNotificationEnabled) {
                                Text("Notification:")
                            }
                        }

                        Section(header: Text("Sleep tracking settings")) {
                            Toggle(isOn: $isSleepTrackingEnabled) {
                                Text("Sleep tracking:")
                            }

                            Picker(
                                selection: $sleepTrackingMode,
                                label: Text("Sleep tracking mode")
                            ) {
                                Text("Dark Mode").tag("yer")
                            }

                            Stepper(value: $sleepGoal, in: 6...12) {
                                Text("Sleep goal is \(sleepGoal) hours")
                            }
                        }
                        
                        Section {
                            Button("Unlock PRO") {}
                            Button("Restore purchase") {}
                        }
                    }
                    .navigationBarTitle(Text("Settings"))
                }
    }


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
