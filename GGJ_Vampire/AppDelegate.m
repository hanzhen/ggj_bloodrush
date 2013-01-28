//
//  AppDelegate.m
//  GGJ_Vimpire
//
//  Created by Gem on 13年1月25日.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "MainGameLayer.h"
#import "MainMenuLayer.h"
#import "RootViewController.h"
#import "HighscoreObject.h"
#import "StatisticLayer.h"

@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];

//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
    
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
//	[director setDisplayFPS:YES];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
    //Required in iOS6, recommended in 4 and 5
    [window setRootViewController:viewController];
    
	// make the View Controller a child of the main window, needed for iOS 4 and 5
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenuLayer scene]];
    
    //default scoore
    NSMutableArray* array = [[NSUserDefaults standardUserDefaults] objectForKey:@"highscore"];
    
    if(array == nil){
        NSMutableArray* array = [NSMutableArray array];
        
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Gary" withScore:100000 withGrade:Grade_S];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Marc" withScore:90000 withGrade:Grade_AAA];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Gem" withScore:80000 withGrade:Grade_AA];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Gary" withScore:70000 withGrade:Grade_A];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Marc" withScore:60000 withGrade:Grade_B];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Gem" withScore:50000 withGrade:Grade_C];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Gary" withScore:40000 withGrade:Grade_D];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Marc" withScore:30000 withGrade:Grade_E];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Gem" withScore:20000 withGrade:Grade_F];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        {
            HighscoreObject* tempObject = [HighscoreObject objectWithName:@"Gary" withScore:10000 withGrade:Grade_F];
            [array addObject:[HighscoreObject encodeWithKeyedArchiver:tempObject]];
        }
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"highscore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] end];
	[window release];
	[super dealloc];
}

@end
