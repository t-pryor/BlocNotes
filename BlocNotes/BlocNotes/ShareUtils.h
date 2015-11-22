//
//  ShareUtils.h
//  BlocNotes
//
//  Created by Tim Pryor on 2015-11-21.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareUtils : UIViewController

/**
 This class method returns an Activity View Controller in a pleasing format, given a note's title and body
 Both the Detail VC and AddNote VC create an ActivityVC to share a note's title and body within the application
 and in other apps.
 */

+(UIActivityViewController *)createActivityViewControllerWithTitle: (NSString *)title andBody: (NSString *)body;

@end
