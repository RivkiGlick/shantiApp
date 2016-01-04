/*
 
 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 /*NSLocalizedString("", comment: "") as String /*
 */

#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "Shanti-swift.h"
#define ROW_HEIGHT_TABLE 55

@interface RearViewController()

@end

@implementation RearViewController
{
    NSMutableArray *menu;
    NSMutableArray *filter;
    NSMutableArray *profileMenu;
    NSMutableArray *messagesMenu;
    NSMutableArray *groupsArry;
    Generic *generic;
}
@synthesize rearTableView = _rearTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    generic = [[Generic alloc] init];
    SWRevealViewController *parentRevealController = self.revealViewController;
    _grandParentRevealController = parentRevealController.revealViewController;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleDone target:_grandParentRevealController action:@selector(revealToggle:)];//UIBarButtonItemStyleBordered
    
    if ( _grandParentRevealController )
    {
        NSInteger level=0;
        UIViewController *controller = _grandParentRevealController;
        while( nil != (controller = [controller revealViewController]) )
            level++;
        
        [self.navigationController.navigationBar addGestureRecognizer:_grandParentRevealController.panGestureRecognizer];
        self.navigationItem.leftBarButtonItem = revealButtonItem;
    }else{
        self.navigationItem.title = @"";
        self.navigationController.navigationBar.hidden = YES;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self getUserGroupsListFromServer];
    groupsArry = nil;
    filter = Nil;
    //    menu = [[NSMutableArray alloc]initWithObjects:@"ראשי",@"הודעות",@"קבוצות",@"מידע",@"אזור אישי",nil];
    NSString* a = NSLocalizedString(@"Home", @"");//ראשי
    NSString* b = NSLocalizedString(@"Searching for people", @"");//חיפוש אנשים
    NSString* c = NSLocalizedString(@"Messages", @"");//הודעות
    NSString* d = NSLocalizedString(@"Groups", @"");//קבוצות
    NSString* e = NSLocalizedString(@"Information", @"");//מידע
    NSString* f = NSLocalizedString(@"Personal zone", @"");//"אזור אישי"
    //      menu = [[NSMutableArray alloc]initWithObjects: @"ראשי",@"רשימה",@"הודעות",@"קבוצות",@"מידע",@"אזור אישי",nil];
    menu = [[NSMutableArray alloc]initWithObjects:a,b,c,d,e,f, nil];
    
    NSString* profileMenuA = NSLocalizedString(@"People Search settings", @"");//חיפוש אנשים
    NSString* profileMenuB = NSLocalizedString(@"Information Search settings", @"");//"הגדרות חיפוש מידע"
    NSString* profileMenuC = NSLocalizedString(@"Personal zone", @""); //"אזור אישי"
    NSString* profileMenuD = NSLocalizedString(@"My profile", @"");//"הפרופיל שלי"
    NSString* profileMenuE = NSLocalizedString(@"Logout", @"");  //התנתק
    //    NSString* profileMenuF = NSLocalizedString(@"Personal zone", @"");//הגדרות
    profileMenu = [[NSMutableArray alloc]initWithObjects:profileMenuA,profileMenuB,profileMenuC,profileMenuD,profileMenuE,nil];
    
    NSString* messagesMenuA = NSLocalizedString(@"Messages", @"");//הודעות הצטרפות
    NSString* messagesMenuB = NSLocalizedString(@"Previous messages", @"");//" קודמות הודעות"
    NSString* messagesMenuC = NSLocalizedString(@"Joining requests", @"");//בקשות
    //    NSString* messagesMenuD = NSLocalizedString(@"Personal zone", @"");//"אזור אישי"
    
    
    
    
    messagesMenu = [[NSMutableArray alloc]initWithObjects:messagesMenuA,messagesMenuB,messagesMenuC, nil];
    filter = menu;
    self.rearTableView.backgroundColor = [UIColor clearColor];
    [self setSubviewsFrames];
    [self setSubviewsGraphics];
    [self reloadData];
    
}


- (void)setSubviewsFrames{
    [self.imgBg setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.lblUserName setText:[NSString stringWithFormat:@"%@ %@",[[ActiveUser sharedInstace]nvFirstName],[[ActiveUser sharedInstace]nvLastName]]];
    [self.lblUserName setFont:[UIFont fontWithName:@"spacer" size:29.5]];
    [self.lblUserName sizeToFit];
    CGFloat space = 20.0;
    [self.lblUserName setFrame:CGRectMake(self.view.bounds.size.width - self.lblUserName.frame.size.width - space, 100, self.lblUserName.frame.size.width, self.lblUserName.frame.size.height)];
    NSString* a=NSLocalizedString(@"Member in", @"");//חבר ב
    NSString* b=NSLocalizedString(@"and administrator", @"");//מנהל
    NSString* c=NSLocalizedString(@"Groups", @"");//קבוצות
    [self.lblUserInfo setText:[NSString stringWithFormat:@"%@%ld %@, %@ %ld %@",a,(long)[[ActiveUser sharedInstace]iNumGroupAsMemberUser],b,c,(long)[[ActiveUser sharedInstace]iNumGroupAsMainUser],b]];
    
    [self.lblUserInfo setFont:[UIFont fontWithName:@"spacer" size:14]];
    [self.lblUserInfo sizeToFit];
    [self.lblUserInfo setFrame:CGRectMake(self.view.bounds.size.width - self.lblUserInfo.frame.size.width - space, self.lblUserName.frame.origin.y + self.lblUserName.frame.size.height + 10, self.lblUserInfo.frame.size.width, self.lblUserInfo.frame.size.height)];
    
    _rearTableView.frame = CGRectMake(0, self.lblUserInfo.frame.origin.y + self.lblUserInfo.frame.size.height + 10, self.view.bounds.size.width, filter.count * ROW_HEIGHT_TABLE);
}

- (void) setSubviewsGraphics{
    [self.lblUserName setBackgroundColor:[UIColor clearColor]];
    [self.lblUserName setTextColor:[UIColor blackColor]];
    [self.lblUserName setTextAlignment:NSTextAlignmentRight];
    
    [self.lblUserInfo setBackgroundColor:[UIColor clearColor]];
    [self.lblUserInfo setTextColor:[UIColor grayMedium]];
    [self.lblUserInfo setTextAlignment:NSTextAlignmentRight];
    
    [self.rearTableView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5]];
    [self.imgBg setImage:[[ActiveUser sharedInstace]image]];
    self.imgBg.contentMode = UIViewContentModeScaleAspectFill;
    self.imgBg.clipsToBounds = YES;
}

#pragma marl - UITableView Data Source

- (void)reloadData
{
    _rearTableView.frame = CGRectMake(0, self.lblUserInfo.frame.origin.y + self.lblUserInfo.frame.size.height + 10, self.view.bounds.size.width, filter.count * ROW_HEIGHT_TABLE);
    [_rearTableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  ROW_HEIGHT_TABLE;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"spacer" size:24.0];
    cell.textLabel.text = [filter objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor offwhiteBasic];
    cell.selectedBackgroundView = selectionColor;
    
    if (filter == menu){
        if (indexPath.row == 0){
            for (UIView *view in cell.subviews){
                if ([view isKindOfClass:[UIImageView class]]) {
                    [view removeFromSuperview];
                }
            }
        }
        
    }else if (filter == profileMenu){
        if (indexPath.row == 2)
            cell.textLabel.textColor = [UIColor grayMedium];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    UINavigationController *frontNavigationController =nil;
    
    UIStoryboard *storybrd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if ( [frontViewController isKindOfClass:[UINavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    if (filter == menu) {
        switch (indexPath.row) {
            case 1:{
                
                if ( ![frontNavigationController.topViewController isKindOfClass:[UsersListViewController class]] ){
                    GroupsViewController *groupsView =[storybrd instantiateViewControllerWithIdentifier:@"UsersListViewControllerID"];
                    [frontNavigationController pushViewController:groupsView animated:YES];
                }
                [revealController revealToggleAnimated:YES];
                break;
                
                
            }
            case 0:
            {
                if ( ![frontNavigationController.topViewController isKindOfClass:[MainPage class]] ){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        GroupsViewController *groupsView =[storybrd instantiateViewControllerWithIdentifier:@"MainPageId"];
                        [frontNavigationController pushViewController:groupsView animated:YES];
                        [revealController revealToggleAnimated:YES];
                    });
                }
                break;
                break;
                
            }
                
            case 2:
            {
                filter = messagesMenu;
                [self reloadData];
                break;
            }
            case 3:{
                if ( ![frontNavigationController.topViewController isKindOfClass:[GroupsViewController class]] ){
                    GroupsViewController *groupsView =[storybrd instantiateViewControllerWithIdentifier:@"GroupsViewControllerId"];
                    [frontNavigationController pushViewController:groupsView animated:YES];
                    //                    [self getUserGroupsListFromServer:frontNavigationController];
                }
                [revealController revealToggleAnimated:YES];
                break;
            }
            case 4:{
                if ( ![frontNavigationController.topViewController isKindOfClass:[InformationViewController class]] ){
                    InformationViewController *informationView =[storybrd instantiateViewControllerWithIdentifier:@"InformationViewControllerId"];
                    [frontNavigationController pushViewController:informationView animated:YES];
                }
                [revealController revealToggleAnimated:YES];
                break;
            }
            case 5:{
                filter = profileMenu;
                [self reloadData];
                break;
            }
        }
    }else if (filter == profileMenu){
        switch (indexPath.row) {
                //            case 0:{
                //                filter = menu;
                //                [self reloadData];
                //                break;
                //            }
            case 3:{
                if ( ![frontNavigationController.topViewController isKindOfClass:[UserProfileViewController class]] ){
                    UserProfileViewController *userprofileView =[storybrd instantiateViewControllerWithIdentifier:@"UserProfileViewControllerId"];
                    [frontNavigationController pushViewController:userprofileView animated:YES];
                }
                [revealController revealToggleAnimated:YES];
                break;
            }
            case 0:{
                if ( ![frontNavigationController.topViewController isKindOfClass:[SearchSettingsViewController class]] ){
                    SearchSettingsViewController *SearchView =[storybrd instantiateViewControllerWithIdentifier:@"SearchSettingsViewControllerId"];
                    SearchView.userSearchSettings.iUserId = [[ActiveUser sharedInstace] iUserId];
                    [frontNavigationController pushViewController:SearchView animated:YES];
                }
                [revealController revealToggleAnimated:YES];
                break;
            }
            case 4:{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"user"];
               
               
                
                NSArray *controllers = frontNavigationController.viewControllers;
                for (UIViewController* view in controllers){
                    if ([view isKindOfClass:[MainPage class]]){
                        MainPage *mainView = (MainPage*)view;
                        if (mainView.timeInterval != nil){
                            [mainView.timeInterval invalidate];
                        }
                        if (mainView.notificationInterval != nil){
                            [mainView.notificationInterval invalidate];
                        }
                        [mainView.locationManeger stopUpdatingLocation];
                    }
                }
                [self logOut:frontNavigationController AndToogleBy:revealController];
                break;
            }
            default:
                break;
        }
        
    }else if (filter == messagesMenu){
        switch (indexPath.row) {
            case 0:{
                filter = menu;
                [self reloadData];
                break;
            }
            case 1:
            {
                if ( ![frontNavigationController.topViewController isKindOfClass:[AllPriveteChatViewController class]] ){
                    AllPriveteChatViewController *privateChat =[storybrd instantiateViewControllerWithIdentifier:@"AllPriveteChatViewControllerId"];
                    [frontNavigationController pushViewController:privateChat animated:YES];
                }
                [revealController revealToggleAnimated:YES];
                break;
            }
                
            case 2:{
                if ( ![frontNavigationController.topViewController isKindOfClass:[PendingGroupsViewController class]] ){
                    PendingGroupsViewController *pendingGroups =[storybrd instantiateViewControllerWithIdentifier:@"PendingGroupsViewControllerId"];
                    [frontNavigationController pushViewController:pendingGroups animated:YES];
                }
                [revealController revealToggleAnimated:YES];
                break;
            }
            default:
                break;
        }
    }
    
}

-(void)logOut:(UINavigationController*)frontNavigationController AndToogleBy:(SWRevealViewController*)revealController{
    [revealController revealToggleAnimated:YES];
    [generic showNativeActivityIndicator:[self revealViewController].frontViewController];
    
    ChooseLoginWayViewController* chooseLoginWayViewController = [[ChooseLoginWayViewController alloc]init];
    AppDelegate* appDelegate;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString* loginWay = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginWay"];
    if ([loginWay  isEqual: @"google+"]) {
        
           [[GPPSignIn sharedInstance]signOut];
        
//        [chooseLoginWayViewController.googleSignIn signOut];
//        appDelegate.isGoogle = false;
    }
    
//   NSString* loginWay = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginWay"];
    
    if ([loginWay  isEqual: @"faceBook"])
//    if (appDelegate.isFaceBook)
    {
//                GPPSignIn.sharedInstance().signOut();
     
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logOut];
    }
    
    if([[QBChat instance] isLoggedIn]){
        [[QBChat instance] logout];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"loginWay"];
       [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%ld",(long)[[ActiveUser sharedInstace]iUserId]] forKey:@"iUserId"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    SplashViewController *splashViewController = (SplashViewController *)[mainStoryboard
                                                                                                  instantiateViewControllerWithIdentifier:@"SplashViewControllerId"];
    
    UIWindow* wind = [[[UIApplication sharedApplication] delegate] window];
    wind.rootViewController = splashViewController;
    [generic hideNativeActivityIndicator:[self revealViewController].frontViewController];
    [frontNavigationController popToRootViewControllerAnimated:YES];
    [revealController revealToggleAnimated:YES];
    //
}
@end