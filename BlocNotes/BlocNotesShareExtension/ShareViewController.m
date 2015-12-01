//
//  ShareViewController.m
//  BlocNotesShareExtension
//
//  Created by Tim Pryor on 2015-11-25.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "ShareViewController.h"
#import "NoteStore.h"

#define kTitleCharacterLimit    (31)

@interface ShareViewController ()

@property NSString *postToShare;
@property UIDocumentInteractionController *documentInteractionController;

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

   /* Using NSUserDefaults: not recommended for this purpose
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc]initWithSuiteName: @"group.com.example.BlocNotes"];
    
    NSInteger postLength = self.contentText.length;
    
    if (postLength > kTitleCharacterLimit) {
        self.postToShare = [self.contentText substringToIndex:kTitleCharacterLimit];
    } else {
        self.postToShare = self.contentText;
    }
    
    NSLog(@"svm, didSelectPost, post title, shared defaults: %@", self.postToShare);

    
    [sharedDefaults setObject:self.postToShare forKey:@"postTitleKey"];
    [sharedDefaults synchronize];
    
    */
    
    NSURL *containerURL = [[NoteStore sharedInstance] applicationDocumentsDirectory];
    NSString *dirPath = containerURL.path;
    
    NSString *filePath = [dirPath stringByAppendingPathComponent: @"datafile.dat"];
    
    NSInteger postLength = self.contentText.length;
     
    if (postLength > kTitleCharacterLimit) {
        self.postToShare = [self.contentText substringToIndex:kTitleCharacterLimit];
    } else {
        self.postToShare = self.contentText;
    }
    
    
    [self.postToShare writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"postToShare%@", self.postToShare);
    
    ////////
    NSError *error;
    NSString *postTitle = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"postTitle %@", postTitle);
    NSLog(@"ERRRORRORROR: %@", error);
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
