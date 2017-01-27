//
//  FLNavMenuViewController.m
//  FutLife
//
//  Created by Rene Santis on 1/9/17.
//  Copyright © 2017 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLNavMenuViewController.h"
#import "FLMenuManager.h"

// TableView sections
static NSInteger kMainNavNumberOfSections = 3;
static const NSInteger kMainNavMenuUserDataSection = 0;
static const NSInteger kMainNavMenuContactSection = 1;
static const NSInteger kMainNavMenuLogoutSection = 2;

static const NSInteger kMainNavMenuHeightRow = 55;

NSString * const kMainNavMenuResuseIdentifierCell = @"NavMainMenuCell";

@interface FLNavMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *navMenuTableView;
@property (weak, nonatomic) IBOutlet UIView *headerTableView;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *email;

@property (strong, nonatomic) FLMenuManager *menuManager;

@property (strong, nonatomic) NSMutableArray *navMenuDatasource;

@property (strong, nonatomic) NSMutableArray *userDataRowsData;
@property (strong, nonatomic) NSMutableArray *contactRowsData;
@property (strong, nonatomic) NSMutableArray *logOutRowsData;

@end

@implementation FLNavMenuViewController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([FLNavMenuViewController class]) bundle:nil];
    if (self) {
        self.menuManager = [FLMenuManager sharedInstance];
        
    }
    
    return self;
}

- (void)setUpUserDataRowsData
{
    self.userDataRowsData = [NSMutableArray new];
    
    [self.userDataRowsData addObject:@[@"Menú principal", @"homeMenu.leftMenuIcon", @"onHomeTapped:"]];
    [self.userDataRowsData addObject:@[@"Mi Perfil", @"profile.leftMenuIcon", @"onProfileTapped:"]];
    [self.userDataRowsData addObject:@[@"Ajustes", @"settings.leftMenuIcon", @"onSettingsTapped:"]];
    [self.userDataRowsData addObject:@[@"Quienes Somos", @"aboutUs.leftMenuIcon", @"onAboutUsTapped:"]];
    [self.userDataRowsData addObject:@[@"Ayuda", @"help.leftMenuIcon", @"onHelpTapped:"]];
}

- (void)setUpContactDataRowsData
{
    self.contactRowsData = [NSMutableArray new];
    
    [self.contactRowsData addObject:@[@"Comentarios y Sugerencias", @"suggestion.leftMenuIcon", @"onSuggestionTapped:"]];
    [self.contactRowsData addObject:@[@"Enviar Correo", @"mail.leftMenuIcon", @"onSendEmailTapped:"]];
}

- (void)setUpLogOutRowsData
{
    self.logOutRowsData = [NSMutableArray new];
    
    [self.logOutRowsData addObject:@[@"Cerrar Sesión", @"logout.leftMenuIcon", @"onLogOutTapped:"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userName.text = [FLLocalDataManager sharedInstance].user.name;
    self.email.text = [FLLocalDataManager sharedInstance].user.email;
    
    self.navMenuTableView.tableHeaderView = self.headerTableView;
    self.navMenuTableView.tableHeaderView.autoresizesSubviews = YES;
    [self.navMenuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMainNavMenuResuseIdentifierCell];
    
    self.navMenuDatasource = [NSMutableArray new];
    
    [self setUpUserDataRowsData];
    [self setUpContactDataRowsData];
    [self setUpLogOutRowsData];
}

#pragma MARK - UITableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return amount of sections, but the double of it, to achieve the sections to not
    // be anchored (little trick found in Stackoverflow).
    // http://stackoverflow.com/a/8350326/2502716
    return kMainNavNumberOfSections * 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section % 2 == 1) {
        NSInteger realSection = section / 2;
        if (realSection == kMainNavMenuUserDataSection) {
            return [self.userDataRowsData count];
        } else if (realSection == kMainNavMenuContactSection) {
            return [self.contactRowsData count];
        } else if (realSection == kMainNavMenuLogoutSection) {
            return 1;
        }
        return 0;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section % 2 == 0) {
        NSInteger realSection = section / 2;
        if (realSection != kMainNavMenuLogoutSection) {
            return 44.0f;
        } else {
            return 2.0f;
        }
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMainNavMenuHeightRow;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section % 2 == 0) {
        NSInteger realSection = section / 2;
        CGFloat headerHeight = [self tableView:tableView heightForHeaderInSection:section];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.navMenuTableView.frame), headerHeight)];
        
        headerView.backgroundColor = [UIColor colorWithRed:2.0f/255.0f green:14.0f/255.0f blue:23.0f/255.0f alpha:1.0f];
        
        if (realSection != kMainNavMenuLogoutSection) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, CGRectGetWidth(self.navMenuTableView.frame) - 10.0f, (headerHeight - 5.0))];
            title.font = [UIFont fl_bebasFontOfSize:17.0f];
            [title setBackgroundColor:[UIColor colorWithRed:2.0f/255.0f green:14.0f/255.0f blue:23.0f/255.0f alpha:1.0f]];
            title.textColor = [UIColor lightGrayColor];
            title.textAlignment = NSTextAlignmentLeft;
            title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            if (realSection == kMainNavMenuUserDataSection) {
                [title setText:@"Menu"];
            } else if (realSection == kMainNavMenuContactSection) {
                [title setText:@"Contacto"];
            }
            
            [headerView addSubview:title];
        }
        
        if (realSection != kMainNavMenuUserDataSection) {
            UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navMenuTableView.frame.size.width, 1.0)];
            separator.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:66.0f/255.0f blue:62.0f/255.0f alpha:1.0f];
            
            [headerView addSubview:separator];
        }
        
        return headerView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:kMainNavMenuResuseIdentifierCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMainNavMenuResuseIdentifierCell];
    }
    
    [cell setBackgroundColor:[UIColor colorWithRed:2.0f/255.0f green:14.0f/255.0f blue:23.0f/255.0f alpha:1.0f]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fl_boldHelveticaFontOfSize:15.0];
    if (indexPath.section % 2 == 1) {
        NSInteger realSection = indexPath.section / 2;
        if (realSection == kMainNavMenuUserDataSection) {
            cell.textLabel.text = self.userDataRowsData[indexPath.row][0];
            cell.imageView.image = [UIImage imageNamed:self.userDataRowsData[indexPath.row][1]];
        } else if (realSection == kMainNavMenuContactSection) {
            cell.textLabel.text = self.contactRowsData[indexPath.row][0];
            cell.imageView.image = [UIImage imageNamed:self.contactRowsData[indexPath.row][1]];
        } else if (realSection == kMainNavMenuLogoutSection) {
            cell.textLabel.text = self.logOutRowsData[indexPath.row][0];
            cell.imageView.image = [UIImage imageNamed:self.logOutRowsData[indexPath.row][1]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger realSection = indexPath.section / 2;
    SEL selector = nil;
    if (realSection == kMainNavMenuUserDataSection) {
        selector = NSSelectorFromString(self.userDataRowsData[indexPath.row][2]);
    } else if (realSection == kMainNavMenuContactSection) {
        selector = NSSelectorFromString(self.contactRowsData[indexPath.row][2]);
    } else {
        selector = NSSelectorFromString(self.logOutRowsData[indexPath.row][2]);
        [[FLLoginManager sharedInstance] logOut];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
    
//    self.menuManager.currentViewController = nil;
//    
//    
//    
//    if ([self.menuManager respondsToSelector:selector]) {
//        IMP imp = [self.menuManager methodForSelector:selector];
//        void (*func)(id, SEL, id) = (void *)imp;
//        func(self.menuManager, selector, nil);
//        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
//    }
}

- (void)localize
{
    
}

@end
