//
//  FLProfileViewController.m
//  FutLife
//
//  Created by Rene Santis on 12/1/16.
//  Copyright © 2016 IdeamosWeb S.A.S. All rights reserved.
//

#import "FLProfileViewController.h"
#import "FLProfileCell.h"
#import "FLConsoleModel.h"
#import "FLGameModel.h"
#import "FLUserModel.h"
#import "FLRegisterRequestModel.h"
#import "AssetsLibrary/AssetsLibrary.h"

@interface FLProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImage;
@property (weak, nonatomic) IBOutlet UIButton *userAvatarButtom;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *consolesButton;
@property (weak, nonatomic) IBOutlet UIButton *gamesButton;
@property (weak, nonatomic) IBOutlet UIView *selectedButtonView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSIndexPath *selectedCellIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *completeRegisterButtom;

@property (strong, nonatomic) UITableView *consolesTableView;
@property (strong, nonatomic) UITableView *gamesTableView;

@property (strong, nonatomic) NSArray *games;
@property (strong, nonatomic) NSArray *consoles;

@property (assign, nonatomic) BOOL confirmButton;

@property (nonatomic, copy) void (^profileCompletedBlock)();

@end

static float const kTableViewHeight = 480.0f;
static const CGFloat kProfileCellHeight = 44.0f;
static const CGFloat kProfileCellConsolesHeight = 22.0f;

@implementation FLProfileViewController

- (id)initWithConsoles:(NSArray *)consoles games:(NSArray *)games confirmButton:(BOOL)confirmButton completedBlock:(void (^)())profileCompletedBlock
{
    self = [super initWithNibName:@"FLProfileViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.consoles = consoles;
        self.games = games;
        self.profileCompletedBlock = profileCompletedBlock;
        self.confirmButton = confirmButton;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showNavigationBar = YES;
    
    if ([FLLocalDataManager sharedInstance].user) {        
        FLUserModel *user = [FLLocalDataManager sharedInstance].user;
        self.nameLabel.text = user.name;
        self.userNameLabel.text = user.userName;        
    }
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationItem.title = (self.confirmButton) ? @"Resumen" : @"Perfil";
    
    if (self.confirmButton) {
        self.completeRegisterButtom.hidden = false;
    }
    
    [self.userAvatarImage fl_MakeCircularView];
    
    [self configTablesAndScrollView];
}

- (void)configTablesAndScrollView
{
    CGRect consolesTableViewFrame = CGRectMake(0, 0, [FLMiscUtils screenViewFrame].size.width, kTableViewHeight);
    self.consolesTableView = [[UITableView alloc] initWithFrame:consolesTableViewFrame];
    self.consolesTableView.backgroundColor = [UIColor clearColor];
    self.consolesTableView.delegate = self;
    self.consolesTableView.dataSource = self;
    self.consolesTableView.scrollEnabled = YES;
    self.consolesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.consolesTableView.clipsToBounds = NO;
    [self.consolesTableView registerNib:[FLProfileCell nib] forCellReuseIdentifier:[FLProfileCell cellIdentifier]];
    
    CGRect gamesTableViewFrame = CGRectMake(CGRectGetMaxX(self.consolesTableView.frame), 0, [FLMiscUtils screenViewFrame].size.width, kTableViewHeight);
    self.gamesTableView = [[UITableView alloc] initWithFrame:gamesTableViewFrame];
    self.gamesTableView.backgroundColor = [UIColor clearColor];
    self.gamesTableView.delegate = self;
    self.gamesTableView.dataSource = self;
    self.gamesTableView.scrollEnabled = YES;
    self.gamesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.gamesTableView.clipsToBounds = NO;
    [self.gamesTableView registerNib:[FLProfileCell nib] forCellReuseIdentifier:[FLProfileCell cellIdentifier]];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.consolesTableView.frame) + CGRectGetWidth(self.gamesTableView.frame), CGRectGetHeight(self.scrollView.frame));
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    [self.scrollView addSubview:self.consolesTableView];
    [self.scrollView addSubview:self.gamesTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage *avatar = [FLLocalDataManager sharedInstance].avatar;
    if (avatar) {
        self.userAvatarImage.image = avatar;
    }   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.completeRegisterButtom];
}

- (IBAction)onUserAvatarButtonTouch:(id)sender
{
    NSString *deletePhotoStr = nil;
    if ([FLLocalDataManager sharedInstance].avatar) {
        deletePhotoStr = @"Eliminar Photo";
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:deletePhotoStr otherButtonTitles:@"Tomar Photo", @"Escoger Photo", nil];
    actionSheet.tag = 1;
    
    [actionSheet showInView:self.view];
}

- (IBAction)onConsolesButtonTouch:(id)sender
{
    CGPoint point = CGPointMake(CGRectGetMinX(self.consolesTableView.frame), 0.0f);
    [self.scrollView setContentOffset:point animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect selectedButtonViewFrame = self.selectedButtonView.frame;
        selectedButtonViewFrame.origin.x = CGRectGetMinX(self.consolesButton.frame);
        self.selectedButtonView.frame = selectedButtonViewFrame;
    }];
}

- (IBAction)onGamesButtonTouch:(id)sender
{
    CGPoint point = CGPointMake(CGRectGetMinX(self.gamesTableView.frame), 0.0f);
    [self.scrollView setContentOffset:point animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect selectedButtonViewFrame = self.selectedButtonView.frame;
        selectedButtonViewFrame.origin.x = CGRectGetMinX(self.gamesButton.frame);
        self.selectedButtonView.frame = selectedButtonViewFrame;
    }];
}

- (IBAction)onConfirmButtonTouch:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    
    FLUserModel *userModel = [FLLocalDataManager sharedInstance].user;
    FLRegisterPreferencesRequestModel *requestModel = [FLRegisterPreferencesRequestModel new];
    requestModel.userId = userModel.userId;
    
    /*** TODO improve this or move to other side ***/
    NSArray *games = [FLLocalDataManager sharedInstance].games;
    NSMutableArray *gamesRequest = [NSMutableArray new];
    NSMutableArray *consolesRequest = [NSMutableArray new];
    for (FLGameModel *game in games) {
        FLGameRequestModel *gameRequest = [FLGameRequestModel new];
        gameRequest.gameId = game.gameId;
        gameRequest.active = game.active;
        for (FLConsoleModel *console in game.consoles) {
            FLConsoleRequestModel *consoleRequest = [FLConsoleRequestModel new];
            consoleRequest.consoleId = console.consoleId;
            consoleRequest.active = console.active;
            
            [consolesRequest addObject:consoleRequest];
        }
        
        gameRequest.consoles = consolesRequest;
        [gamesRequest addObject:gameRequest];
    }
    
    requestModel.games = gamesRequest;
    
    [FLAppDelegate showLoadingHUD];
    [[FLApiManager sharedInstance] registerPreferencesRequestWithModel:requestModel success:^(FLRegisterPreferencesResponseModel *responseModel) {
        [FLAppDelegate hideLoadingHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Felicidades!" message:responseModel.message buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                [FLLocalDataManager sharedInstance].sessionToken = responseModel.token;
                
                [FLLocalDataManager sharedInstance].completedRegister = true;
                strongSelf.profileCompletedBlock();
            }];
            [alert show];
        });
    } failure:^(FLApiError *error) {
        [FLAppDelegate hideLoadingHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:[error errorMessage] buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

- (void)performAvatarRequestWithUrl:(NSURL *)imageUrl imageData:(NSData *)imageData
{
    __weak __typeof(self)weakSelf = self;
    [FLAppDelegate showLoadingHUD];
    [[FLApiManager sharedInstance] avatarRequestWithImageUrl:imageUrl imageData:imageData success:^(FLRegisterResponseModel *responseModel) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [FLAppDelegate hideLoadingHUD];
        [FLLocalDataManager sharedInstance].avatar = [UIImage imageWithData:imageData];
        strongSelf.userAvatarImage.image = [FLLocalDataManager sharedInstance].avatar;
    } failure:^(FLApiError *error) {
        [FLAppDelegate hideLoadingHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAlertView *alert = [[FLAlertView alloc] initWithTitle:@"Estimado jugador" message:[error errorMessage] buttonTitles:@[@"Aceptar"] buttonTypes:@[] clickedButtonAtIndex:^(NSUInteger clickedButtonIndex) {
                
            }];
            [alert show];
        });
    }];
}

- (void)openPhotoLibrary
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)openCameraView
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)deleteAvatarPhoto
{
    self.userAvatarImage.image = [UIImage imageNamed:@"avatar_placeholder"];
    
    [FLLocalDataManager sharedInstance].avatar = nil;
}

#pragma mark - UITableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.consolesTableView) {
        return [self.consoles count];
    } else {
        return [self.games count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FLProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:[FLProfileCell cellIdentifier]];
    if (cell) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (tableView == self.consolesTableView) {
            FLConsoleModel *console = self.consoles[indexPath.row];
            
            [cell setGameImageName:console.avatar gameName:console.name gameYear:console.year gameNumber:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]];
            cell.userInteractionEnabled = false;
        } else {
            FLGameModel *game = self.games[indexPath.row];
            
            [cell setGameImageName:game.avatar gameName:game.name gameYear:game.year gameNumber:[NSString stringWithFormat:@"%ld", (long)indexPath.row + 1]];
            if (game.consoles) {
                // Autolayout bug (?) pass tableView width for get the expected width of cell
                [cell setConsoles:game.consoles width:tableView.frame.size.width];
            }
            
            cell.userInteractionEnabled = true;
            
        }        
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedCellIndexPath) {
        if ([self.selectedCellIndexPath compare:indexPath] == NSOrderedSame) {
            self.selectedCellIndexPath = nil;
            [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return nil;
        } else {
            [tableView reloadRowsAtIndexPaths:@[self.selectedCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    } else {
        self.selectedCellIndexPath = indexPath;
        [tableView reloadRowsAtIndexPaths:@[self.selectedCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    return indexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedCellIndexPath && [self.selectedCellIndexPath compare:indexPath] == NSOrderedSame) {
        if (tableView == self.gamesTableView) {
            FLGameModel *game = [self.games fl_objectAtIndex:indexPath.row];
            if (!(game.consoles) || [game.consoles count] == 0) {
                return kProfileCellHeight;
            }
            
            return kProfileCellHeight + kProfileCellConsolesHeight;
        }
        
        return kProfileCellHeight;
    } else {
        return kProfileCellHeight;
    }
}

#pragma mark - UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //Retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    //Get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (path) {
            NSData *imageFileData = UIImageJPEGRepresentation(image, 0.33f);
            
            [self performAvatarRequestWithUrl:path imageData:imageFileData];
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (popup.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    if ([FLLocalDataManager sharedInstance].avatar) {
                        [self deleteAvatarPhoto];
                    } else {
                        [self openCameraView];
                    }
                    
                    break;
                case 1:
                    if ([FLLocalDataManager sharedInstance].avatar) {
                        [self openCameraView];
                    } else {
                        [self openPhotoLibrary];
                    }
                    
                    break;
                case 2:
                    if ([FLLocalDataManager sharedInstance].avatar) {
                        [self openPhotoLibrary];
                    }                    
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

- (void)localize
{
    
}

@end
