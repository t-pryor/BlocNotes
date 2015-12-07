//
//  DetailViewController.m
//  BlocNotes
//
//  Created by Tim Pryor on 2015-06-15.
//  Copyright (c) 2015 Tim Pryor. All rights reserved.
//

#import "DetailViewController.h"
#import "NoteStore.h"
#import "ShareUtils.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Note Details";
    
    // iOS7 adds content offset automatically to scroll views (which text views inherit from)
    // set to NO on view controller to turn off behavior
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    
    NSURL *url = [NSURL URLWithString:self.currentNote.urlString];
    
    [self setupTitleText];
    
    if (url && url.scheme && url.host) {
        [self setupWebView];
    } else {
        [self setupBodyText];
    }
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePressed:)];
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
}


- (void)setupTitleText
{
    self.detailTitleTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.detailTitleTextView.text = self.currentNote.title;
    self.detailTitleTextView.textColor = [UIColor blueColor];
}



- (void)setupBodyText
{
//    self.detailBodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
//    self.detailBodyTextView.text = self.currentNote.title;
//
//    // like Evernote, if user did not enter text during
//    // initial note creation, show placeholder text in light gray
//    if ([self.detailBodyTextView.text isEqualToString:@"Tap to edit"]) {
//        self.detailBodyTextView.textColor = [UIColor lightGrayColor];
//    } else {
//        self.detailBodyTextView.textColor = [UIColor blackColor];
//    }
//
    self.detailWebView.hidden = YES;
    self.detailBodyTextView.hidden = NO;
    self.detailBodyTextView.textAlignment = NSTextAlignmentLeft;
    self.detailBodyTextView.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

}

- (void)setupWebView
{
    self.detailWebView.hidden = NO;
    self.detailBodyTextView.hidden = YES;
    
    self.detailWebView.delegate = self;
    NSURL *url = [[NSURL alloc] initWithString:self.currentNote.urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.detailWebView loadRequest:request];
   // self.detailWebView.scalesPageToFit = YES;
    [self.detailWebView.scrollView setShowsHorizontalScrollIndicator:NO];
    self.detailWebView.opaque = NO;


}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   
    //[webView.scrollView setContentSize: CGSizeMake((webView.frame.size.width-20), webView.scrollView.contentSize.height)];

    
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = webView.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = rw;
    webView.scrollView.maximumZoomScale = rw;
    webView.scrollView.zoomScale = rw;
   
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    if (scrollView.contentOffset.x < 0)
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
}


- (void)saveEdits
{
    if (![self.currentNote.body isEqualToString:self.detailBodyTextView.text] || ![self.currentNote.title isEqualToString:self.detailTitleTextView.text]) {
        
        self.currentNote.title = self.detailTitleTextView.text;
        self.currentNote.body = self.detailBodyTextView.text;
        self.currentNote.dateModified = [NSDate date];
        
    
        NSError *error = nil;
        NSManagedObjectContext *context = [[NoteStore sharedInstance]managedObjectContext];
        if (![context save:&error]) {
            NSLog(@"Error! %@", error);
        }
    }
}


- (void)sharePressed:(id)sender
{
    UIActivityViewController *activityVC = [ShareUtils createActivityViewControllerWithTitle:self.detailTitleTextView.text andBody:self.detailBodyTextView.text];
    [self presentViewController:activityVC animated:YES completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    // only commit edits if currentNote exists
    // currentNote won't exist after deleting note in master
    if (self.currentNote) [self saveEdits];
    
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end

