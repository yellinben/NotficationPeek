//
//  NotificationPanelController.m
//  NotificationPeek
//
//  Created by Ben Yellin on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationPanelController.h"

@interface NotificationPanelController (Private)
- (BOOL)isNotificationExcluded:(NSNotification *)notification;
@end

@implementation NotificationPanelController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        notifications = [[NSMutableArray alloc] init];
        excludeFilter = [[NSMutableArray alloc] init];
        
        [excludeFilter addObject:@"NSView"];
        [excludeFilter addObject:@"NSWindow"];
        [excludeFilter addObject:@"NSApplication"];
    }
    
    return self;
}
                         
- (void)dealloc {
    [super dealloc];
    [notifications release];
}

- (void)windowDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(notificationPosted:) 
                                                 name:nil 
                                               object:nil];
}

- (void)notificationPosted:(NSNotification *)notification {
    if (![self isNotificationExcluded:notification]) {
        [notifications addObject:notification];
        [notificationTable reloadData];
        [infoTable reloadData];
    }
}

- (BOOL)isNotificationExcluded:(NSNotification *)notification {
    for (NSString *filterItem in excludeFilter) {
        if ([[notification name] hasPrefix:filterItem]) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)clear:(id)sender {
    [notifications removeAllObjects];
    [notificationTable reloadData];
    [infoTable reloadData];
}

#pragma mark Table View Data Source

- (NSUInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSUInteger count = 0;
    if (tableView == notificationTable) {
        count = [notifications count];
    } else if (tableView == infoTable) {
        if ([notificationTable selectedRow] > -1) {
            NSNotification *selectedNotification = [notifications 
                                                    objectAtIndex:[notificationTable selectedRow]];
            if ([selectedNotification userInfo] != nil) {
                count = [[[selectedNotification userInfo] allKeys] count];
            }
        }
    }
    return count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn 
            row:(int)rowIndex {
	NSString *columnId = [tableColumn identifier];
    NSNotification *notification;
    
    if (tableView == notificationTable) {
        notification = [notifications objectAtIndex:rowIndex];
        if ([columnId isEqualToString:@"name"]) {
            return [notification name];
        } else if ([notification object] != nil) {
            return [[notification object] description];
        }
    } else {
        if ([notificationTable selectedRow] > -1) {
            notification = [notifications objectAtIndex:[notificationTable selectedRow]];
            
            if ([notification userInfo] != nil) {
                NSDictionary *userInfo = [notification userInfo];
                if (rowIndex < [userInfo count]) {
                    NSString *key = [[userInfo allKeys] objectAtIndex:rowIndex];
                    if ([columnId isEqualToString:@"key"]) {
                        return key;
                    } else {
                        return [[userInfo objectForKey:key] description];
                    }
                }
            }
        }
    }
    
    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [infoTable reloadData];
}

@end
