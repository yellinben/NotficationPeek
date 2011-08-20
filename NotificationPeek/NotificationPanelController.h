//
//  NotificationPanelController.h
//  NotificationPeek
//
//  Created by Ben Yellin on 8/19/11.
//  Copyright 2011 Been Yelling. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NotificationPanelController : NSWindowController {
    IBOutlet NSTableView *notificationTable;
    IBOutlet NSTableView *infoTable;
    
    NSMutableArray *notifications;
    NSMutableArray *excludeFilter;
}

- (IBAction)clear:(id)sender;
- (void)notificationPosted:(NSNotification *)notification;

@end
