//
//  NotificationPeek.m
//  NotificationPeek
//
//  Created by Ben Yellin on 8/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotificationPeek.h"
#import "NotificationPanelController.h"

// Thank You MegaZoomer
// https://github.com/mattmatt/megazoomer
@interface NSMenu(TopSecretMethods)
- (NSString *)_menuName;
@end

@implementation NotificationPeek

- (id)init {
    self = [super init];
    if (self) {
        // Setup Menu Item
        NSMenu *mainMenu = [NSApp mainMenu];
        NSMenuItem *windowMenuItem = [mainMenu itemWithTitle:@"Window"];
        if (windowMenuItem != nil) {        
            [[windowMenuItem menu] addItemWithTitle:@"Notifications" 
                                             action:@selector(openNotifications:) 
                                      keyEquivalent:@""];
        }

    }    
    return self;
}

// Thank You MegaZoomer
// https://github.com/mattmatt/megazoomer
+ (NSMenu *)windowMenu {
	NSMenu *mainMenu = [NSApp mainMenu];
    NSEnumerator *menuEnumerator = [[mainMenu itemArray] objectEnumerator];
	NSMenu *windowMenu;
    while ((windowMenu = [[menuEnumerator nextObject] submenu]) != nil) {
        // Let's hope Apple doesn't change this...
        if ([[windowMenu _menuName] isEqualToString:@"NSWindowsMenu"]) {
            return windowMenu;
        }
    }
    return windowMenu;
}

// Thank You MegaZoomer
// https://github.com/mattmatt/megazoomer
- (void)insertMenu {
	NSMenu *windowMenu = [[self class] windowMenu];
    
	NSMenuItem *item = [[[NSMenuItem alloc] init] autorelease];
    [item setRepresentedObject:self]; // So I can validate it without having to check the title.
	[item setTitle:@"Notifications"];
	[item setAction:@selector(openNotifications:)];
	[item setTarget:self];
	[windowMenu insertItem:item atIndex:[windowMenu indexOfItemWithTarget:nil andAction:@selector(performZoom:)]+1];
}

- (IBAction)openNotifications:(id)sender {
    NotificationPanelController *panelController = [[NotificationPanelController alloc] 
                                                    initWithWindowNibName:@"NotificationPanel"];
    [panelController showWindow:nil];
}

+ (void)load {
    NotificationPeek *peek = [[NotificationPeek alloc] init];
    [peek insertMenu];
}

@end
