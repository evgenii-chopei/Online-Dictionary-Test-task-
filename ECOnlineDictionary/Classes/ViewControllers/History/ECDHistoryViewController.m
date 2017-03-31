//
//  ECDHistoryViewController.m
//  ECOnlineDictionary
//
//  Created by Evgenii Chopei on 3/30/17.
//  Copyright © 2017 Evgenii Chopei. All rights reserved.
//

#import "ECDHistoryViewController.h"
#import "ECDRestManager.h"
#import "ECDHistoryCell.h"
#import <CoreData/CoreData.h>
#import <RestKit.h>
#import "LoadingView.h"
#import "ECDTranslationPreviewViewController.h"

static NSString *const kHistoryCellIdentifier  = @"ECDHistoryCell";

@interface ECDHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (strong,nonatomic,readonly) NSArray * historyList;
@property (strong,nonatomic) NSArray *filteredList;

@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (strong,nonatomic) LoadingView * loadingView;

@end

@implementation ECDHistoryViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    

    NSError *error;
    [[self fetchedResultsController]performFetch:&error];
    NSLog(@"error %@",error);
    

}

#pragma mark -
#pragma marl - Methods

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
 
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Translation" inManagedObjectContext:   [[[RKObjectManager sharedManager]managedObjectStore]persistentStoreManagedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"responseData" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[[[RKObjectManager sharedManager]managedObjectStore]persistentStoreManagedObjectContext] sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)fetchHistoryFromDatabaseWithKey:(NSString*)key
{
    [self.fetchedResultsController.fetchRequest setPredicate:nil];
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    
    if (key.length)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"responseData.translatedText CONTAINS[cd] %@",key];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    }

    
    NSError *error = nil;
 
    if ( [self.fetchedResultsController performFetch:&error])
   {
       [self changeReturnButton];
   }
    
  
    
}

#pragma mark - 
#pragma mark - Actions
- (IBAction)searchAction:(id)sender {
    
[self.searchTextField performSelector:self.searchTextField.isFirstResponder ? @selector(resignFirstResponder) : @selector(becomeFirstResponder)];
    
}

#pragma mark - 
#pragma mark - TableView DataSource / Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECDHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kHistoryCellIdentifier];
    [cell setupWithTranslation:self.fetchedResultsController.fetchedObjects[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard];
    ECDTranslationPreviewViewController *translation = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ECDTranslationPreviewViewController class])];
    translation.translation = self.fetchedResultsController.fetchedObjects[indexPath.row];
    translation.modalPresentationStyle = UIModalPresentationCustom;
    
   
    [self presentViewController:translation animated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 
#pragma mark - Textfield Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.fetchedResultsController.fetchedObjects.count) [textField resignFirstResponder];
    else [self findAndTranslateWord:textField.text];
    return NO;
}

- (void)textFieldDidChanged:(NSNotification*)notification
{
    [self fetchHistoryFromDatabaseWithKey:self.searchTextField.text];
 
}

- (void)changeReturnButton
{
    self.searchTextField.returnKeyType = self.fetchedResultsController.fetchedObjects.count ? UIReturnKeyDefault : UIReturnKeySearch;
    [self.searchTextField reloadInputViews];
    
    [self.historyTableView reloadData];
    [self.loadingView removeFromSuperview];
}

#pragma mark -
#pragma mark - Requests


- (void)findAndTranslateWord:(NSString*)word
{
    self.loadingView = [[LoadingView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.loadingView presentLoadingView:self];
                
    UITextInputMode *inputMode = [self.searchTextField textInputMode];
    NSString *fromLang = [inputMode.primaryLanguage substringToIndex:2];
    NSString *toLang = [fromLang isEqualToString:@"uk"] || [fromLang isEqualToString:@"ru"]  ? @"en" : @"uk" ;
    
   [[ECDRestManager sharedInstance]translateWord:word fromLang:fromLang toLang:toLang result:^(NSString *wordToTranslate, NSError *error) {
       [self fetchHistoryFromDatabaseWithKey:@""];
    }];
}


@end
