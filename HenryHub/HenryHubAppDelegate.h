//
//  HenryHubAppDelegate.h
//  HenryHub
//
//  Created by jeroen on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHubViewController;

@interface HenryHubAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// start/root view = HHubViewController
@property (nonatomic, retain) HHubViewController *startView;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
