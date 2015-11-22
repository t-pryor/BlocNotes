//
//  ShareUtils.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-11-21.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "ShareUtils.h"

@implementation ShareUtils

+(UIActivityViewController *)createActivityViewControllerWithTitle: (NSString *)title andBody: (NSString *)body
{
    NSString *formattedNote = [NSString stringWithFormat:@"Note Title: %@ \nNote Body: %@", title, body];
    NSArray *objectsToShare = @[formattedNote];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    return activityVC;
}

@end
