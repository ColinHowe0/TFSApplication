//
//  TFSAppDelegate.m
//  TFSPartApplicationPrototype
//
//  Created by utdesign on 3/20/15.
//  Copyright (c) 2015 Total Facility Solutions. All rights reserved.
//  Author: Colin Howe

#import "TFSAppDelegate.h"
#import "TFSPartResultsViewController.h"
#import "TFSSearchPageViewController.h"
#import "TFSApplicationLoadingScreen.h"
#import "TFSPartDetailsViewController.h"
#import "TFSPart.h"

@implementation TFSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //set the window's tint color to gray
    [self.window setTintColor:[UIColor redColor]];
    // Override point for customization after application launch.
    
    //first produce a notification object that will warn this application of when the configuration data has been loaded, then create the loading screen and show it. The selector continueWithApplication will create the navigation controller for use in the application and begin with the search screen.

    
    TFSApplicationLoadingScreen *loadingScreen = [[TFSApplicationLoadingScreen alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueWithApplication) name:@"Done Loading" object:loadingScreen];
    self.window.rootViewController = loadingScreen;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)continueWithApplication
{
    //Search page view controller, initially root view controller until user presses search buton, then results view controller pushed onto the view
    
    TFSSearchPageViewController *searchPageController = [[TFSSearchPageViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchPageController];
    //if the app is running on an ipad, then push a detail view controller as well to a split view controller
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        UISplitViewController *svc = [[UISplitViewController alloc] init];
        svc.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
        svc.minimumPrimaryColumnWidth = self.window.frame.size.width / 2.0;
        svc.maximumPrimaryColumnWidth = self.window.frame.size.width / 2.0;
        [svc.view setBackgroundColor:[UIColor clearColor]];
        //TFSPartDetailsViewController *dvc = [[TFSPartDetailsViewController alloc] init];
        TFSApplicationLoadingScreen *otherScreen = [[TFSApplicationLoadingScreen alloc] init];
        otherScreen.view.frame = CGRectMake(0, 0, self.window.frame.size.width / 2.0, self.window.frame.size.height);
        UINavigationController *dvcNav = [[UINavigationController alloc] initWithRootViewController:otherScreen];
        //initialize the dvc with an empty part
        //dvc.part = [[TFSPart alloc] initWithFields:@{}];
        svc.viewControllers = @[navController, dvcNav];
        
        self.window.rootViewController = svc;
        [self.window makeKeyAndVisible];
        
    } else {
        
        self.window.rootViewController = navController;
        [self.window makeKeyAndVisible];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
