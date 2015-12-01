//
//  AppDelegate.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "NoteStore.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationControllerForDetailVC = [splitViewController.viewControllers lastObject];
    navigationControllerForDetailVC.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    // Like Evernote, keep Master visible in iPad portrait mode
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    // Initialize our Note Store
    [NoteStore sharedInstance];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
//    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName: @"group.com.example.BlocNotes"];
//    
//    NSString *postTitle = [sharedDefaults objectForKey:@"postTitleKey"];
//    
//    if (postTitle != nil) {
//        [[NoteStore sharedInstance] createNoteWithTitle: [sharedDefaults objectForKey:@"postTitleKey"]];
//        [[NoteStore sharedInstance] saveContext];
//        [sharedDefaults removeObjectForKey:@"postTitleKey"];
//    }

//    NSURL *containerURL = [[NoteStore sharedInstance] applicationDocumentsDirectory];
//    NSMutableString *postTitle = [[NSMutableString alloc] initWithContentsOfURL:containerURL encoding:NSUTF8StringEncoding error:nil];
//    
//    if (postTitle != nil) {
//        [[NoteStore sharedInstance] createNoteWithTitle: postTitle];
//        [[NoteStore sharedInstance] saveContext];
//    }
    
    NSLog(@"IN aapDidBecomeActive");
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  // Saves changes in the application's managed object context before the application terminates.

    [[NoteStore sharedInstance] saveContext];

}

#pragma mark - Split View Delegate

-(BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
    // for iPhone, second VC thrown away
    return YES;
}

// for iPhone 6 plus in portrait, default behavior is to expand to show detail view controller. We leave it as is.


- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager]
            containerURLForSecurityApplicationGroupIdentifier:@"group.com.example.BlocNotes"];
}




@end
