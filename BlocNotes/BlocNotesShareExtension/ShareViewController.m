//
//  ShareViewController.m
//  BlocNotesShareExtension
//
//  Created by Tim Pryor on 2015-11-25.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

@import Foundation;
#import "ShareViewController.h"
#import "NoteStore.h"

@import MobileCoreServices;

#define kTitleCharacterLimit    (31)

@interface ShareViewController ()

@property NSString *postToShare;
@property UIDocumentInteractionController *documentInteractionController;
@property NSString *urlString;

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    NSString *filePath = [[NoteStore sharedInstance] sharedResourceFilePath];
    
    NSInteger postLength = self.contentText.length;
     
    if (postLength > kTitleCharacterLimit) {
        self.postToShare = [self.contentText substringToIndex:kTitleCharacterLimit];
    } else {
        self.postToShare = self.contentText;
    }
    
    
 
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    if ([itemProvider hasItemConformingToTypeIdentifier:@"public.url"]) {
        [itemProvider loadItemForTypeIdentifier:@"public.url"
                                        options:nil
                              completionHandler:^(NSURL *url, NSError *error) {
                                  self.urlString = url.absoluteString;
                                  // send url to server to share the link
                                  
                                  [self.urlString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                  // this needs to be put in the block (unlike in stub method Apple provides)
                                  // If outside block, it dismisses the ShareVC and deallocates it
                                  // So NSItemProvider is deallocated is destroyed before it can access the URL
                                  [self.extensionContext completeRequestReturningItems:@[]
                                                                     completionHandler:nil];
                              }];
    }
    
    
    
    
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
