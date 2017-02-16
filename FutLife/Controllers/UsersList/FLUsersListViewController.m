//
//  UsersListViewController.m
//  FutLife
//
//  Created by Rene Santis on 1/23/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLUsersListViewController.h"
#import "FLUserListCell.h"
//#import "FLTabsViewController.h"
#import "FLTimeLineHomeViewController.h"

typedef NS_ENUM(NSInteger, UYLWorldFactsSearchScope)
{
    searchScopeCountry = 0,
    searchScopeCapital = 1
};

@interface FLUsersListViewController () <UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *users;

@property (strong, nonatomic) NSNumberFormatter *decimalFormatter;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) FLViewController *parentVC;

@end

@implementation FLUsersListViewController

- (id)initWithUsers:(NSArray *)users parentViewController:(FLViewController *)parentViewController
{
    self = [super initWithNibName:@"FLUsersListViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.users = users;
        self.parentVC = parentViewController;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;    
    
    // No search results controller to display the search results in the current view
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView registerNib:[FLUserListCell nib] forCellReuseIdentifier:[FLUserListCell cellIdentifier]];
    
    // The search bar does not seem to set its size automatically
    // which causes it to have zero height when there is no scope
    // bar. If you remove the scopeButtonTitles above and the
    // search bar is no longer visible make sure you force the
    // search bar to size itself (make sure you do this after
    // you add it to the view hierarchy).
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.contentOffset = CGPointMake(0.0f, 44.0f);
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.showNavigationBar = true;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.4f/255.0f green:21.0f/255.0f blue:35.0f/255.0f alpha:1.0f]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.tableView layoutSubviews];
}

- (NSNumberFormatter *)decimalFormatter
{
    if (!_decimalFormatter) {
        _decimalFormatter = [[NSNumberFormatter alloc] init];
        [_decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    return _decimalFormatter;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

#pragma mark - UISearchResultsUpdating methods

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText scope:(UYLWorldFactsSearchScope)scopeOption
{
    if (self.managedObjectContext)
    {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"name";
        
        if (scopeOption == searchScopeCapital)
        {
            searchAttribute = @"capital";
        }
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
//        [self.searchFetchRequest setPredicate:predicate];
//        
//        NSError *error = nil;
//        self.filteredList = [self.managedObjectContext executeFetchRequest:self.searchFetchRequest error:&error];
//        if (error)
//        {
//            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
//        }
    }
}

#pragma mark - UITableView delegate methods

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    if (self.searchController.active) {
//        return 1;
//    } else {
//        return self.users.count;
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [self.filteredList count];
    } else {
        
        return self.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLUserListCell *cell =  [tableView dequeueReusableCellWithIdentifier:[FLUserListCell cellIdentifier]];
    if (cell) {
        //cell.delegate = [[FLTabsViewController alloc] initWithIsFromProtocol:YES];
        cell.delegate = (FLTimeLineHomeViewController *)self.parentVC;
        FLUserModel *user = nil;
        if (self.searchController.active) {
            user = [self.filteredList objectAtIndex:indexPath.row];
        } else {
            user = [self.users objectAtIndex:indexPath.row];
        }
        
        cell.user = user;
        [cell setUserName:user.userName];
        [cell setName:user.name];
        [cell setUserAvatarWithUrl:[NSURL URLWithString:user.avatar]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (!self.searchController.active)
//    {
//        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
//        return [sectionInfo name];
//    }
//    return nil;
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if (!self.searchController.active)
//    {
//        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
//        NSArray *initials = [self.fetchedResultsController sectionIndexTitles];
//        [index addObjectsFromArray:initials];
//        return index;
//    }
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if (!self.searchController.active)
//    {
//        if (index > 0)
//        {
//            // The index is offset by one to allow for the extra search icon inserted at the front
//            // of the index
//            
//            return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index-1];
//        }
//        else
//        {
//            // The first entry in the index is for the search icon so we return section not found
//            // and force the table to scroll to the top.
//            
//            CGRect searchBarFrame = self.searchController.searchBar.frame;
//            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
//            return NSNotFound;
//        }
//    }
//    return 0;
//}

//#pragma mark - FLUserListCell protocol methods
//
//- (void)onUserOptionsTouch:(id)sender
//{
//    NSLog(@"superClass: %@", self.superclass);
//    NSLog(@"superView: %@", self.view.superview);
//}


- (void)localize
{
    
}

@end
