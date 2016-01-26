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
    
    self.detailTitleTextView.delegate = self;
    
    
    self.title = @"Note Details";
    
    // iOS7 adds content offset automatically to scroll views (which text views inherit from)
    // set to NO on view controller to turn off behavior
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSURL *url = [NSURL URLWithString:self.currentNote.urlString];
    
    [self setupTitleText];
    
    if (url && url.scheme && url.host) {
        [self setupWebView];
    } else {
        [self setupDetailBodyTextView];
    }
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self
                                    action:@selector(sharePressed:)];
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
    
}


- (void)setupTitleText
{
    self.detailTitleTextView.textColor = [UIColor blueColor];
    self.detailTitleTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.detailTitleTextView.text = self.currentNote.title;
    
    UITapGestureRecognizer *titleTapRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(titleTapFired:)];
    titleTapRecognizer.delegate = self;
    titleTapRecognizer.numberOfTapsRequired = 1;
    [self.detailTitleTextView addGestureRecognizer:titleTapRecognizer];
    
}


- (void)setupDetailBodyTextView
{
    
    self.detailBodyTextView.editable = NO;
    self.detailBodyTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    [self addGestureRecognizersToTextView];
   
    self.detailWebView.hidden = YES;
    self.detailBodyTextView.hidden = NO;
    self.detailBodyTextView.textAlignment = NSTextAlignmentLeft;
    
    self.detailBodyTextView.textColor = [UIColor blackColor];
    self.detailBodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.detailBodyTextView.text = self.currentNote.body;
    
}

- (void)addGestureRecognizersToTextView
{
    UITapGestureRecognizer *textViewDoubleTapRecognizer = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(textViewDoubleTapFired:)];
    textViewDoubleTapRecognizer.delegate = self;
    textViewDoubleTapRecognizer.numberOfTapsRequired = 2;
    [self.detailBodyTextView addGestureRecognizer:textViewDoubleTapRecognizer];
}

- (void)setupWebView
{
    self.detailWebView.hidden = NO;
    self.detailBodyTextView.hidden = YES;
    
    self.detailWebView.delegate = self;
    NSURL *url = [[NSURL alloc] initWithString:self.currentNote.urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.detailWebView loadRequest:request];
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


- (void)titleTapFired:(UITapGestureRecognizer *)titleGestureRecognizer
{
    [self.detailBodyTextView resignFirstResponder];
    self.detailBodyTextView.editable = NO;
    self.detailBodyTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self addGestureRecognizersToTextView];
    
}


- (void)textViewDoubleTapFired:(UITapGestureRecognizer *)gr
{
    [self.detailTitleTextView resignFirstResponder];
    self.detailBodyTextView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.detailBodyTextView.editable = YES;
    [self.detailBodyTextView becomeFirstResponder];
}



@end

