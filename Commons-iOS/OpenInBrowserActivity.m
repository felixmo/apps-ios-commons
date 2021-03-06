//
//  OpenInBrowserActivity.m
//  Commons-iOS
//
//  Created by Linas Valiukas on 2013-08-07.
//  Copyright (c) 2013 Wikimedia. All rights reserved.
//

#import "OpenInBrowserActivity.h"
#import "CommonsApp.h"
#import "MWMessage.h"

@interface OpenInBrowserActivity (Private)

+ (BOOL)activityItemsAreValid:(NSArray *)activityItems;

@end

@implementation OpenInBrowserActivity (Private)

+ (BOOL)activityItemsAreValid:(NSArray *)activityItems {
    
    return ([activityItems count] == 2 &&
    [activityItems[0] isKindOfClass:[UIImage class]] &&
    [activityItems[1] isKindOfClass:[NSURL class]] &&
            [[UIApplication sharedApplication] canOpenURL:(NSURL *)activityItems[1]]);
}

@end


@implementation OpenInBrowserActivity
{
	UIImage *_image;
    NSURL *_wikiURL;
}

- (NSString *)activityType
{
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle
{
    NSString *desiredBrowserName = [CommonsApp.singleton desiredBrowserName];
    return [MWMessage forKey:@"web-open-in" param:desiredBrowserName].text;
}

- (UIImage *)activityImage
{
    // "browser.png" is symlinked to "../Libraries/TUSafariActivity/TUSafariActivity/Safari.png";
    // "Safari.png" looks generic and doesn't denote Safari in particular
	return [UIImage imageNamed:@"browser"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return ([[self class] activityItemsAreValid:activityItems]);
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    if ([[self class] activityItemsAreValid:activityItems]) {
        
        _image = (UIImage *)activityItems[0];
        _wikiURL = (NSURL *)activityItems[1];
    }
}

- (void)performActivity
{
    [CommonsApp.singleton openURLWithDefaultBrowser:_wikiURL];
	
	[self activityDidFinish:YES];
}

@end
