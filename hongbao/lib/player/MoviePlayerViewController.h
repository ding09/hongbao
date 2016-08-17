//
//  MoviePlayerViewController.h
//  MoviePlayerViewController
//
//  Created by pljhonglu on 13-12-18.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

/*
 依赖框架：AVfoundation.framework
 */
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>
#import "WHC_Banner.h"
@protocol MoviePlayerViewControllerDelegate <NSObject>
- (void)movieFinished:(CGFloat)progress;
@end

@protocol MoviePlayerViewControllerDataSource <NSObject>

//key of dictionary
#define KTitleOfMovieDictionary @"title"
#define KURLOfMovieDicTionary @"url"

@required
- (NSDictionary *)nextMovieURLAndTitleToTheCurrentMovie;
- (NSDictionary *)previousMovieURLAndTitleToTheCurrentMovie;
- (BOOL)isHaveNextMovie;
- (BOOL)isHavePreviousMovie;
@end


@interface MoviePlayerViewController : UIViewController<WHC_BannerDelegate>
typedef enum {
    MoviePlayerViewControllerModeNetwork = 0,
    MoviePlayerViewControllerModeLocal
} MoviePlayerViewControllerMode;
@property (nonatomic,weak)id timeObserver;
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,assign)BOOL isFirstOpenPlayer;//第一次打开需要读取历史观看进度
@property (nonatomic,strong,readonly)NSURL *movieURL;
@property (nonatomic,strong,readonly)NSArray *movieURLList;
@property (readonly,nonatomic,copy)NSString *movieTitle;
@property (nonatomic, assign) id<MoviePlayerViewControllerDelegate> delegate;
@property (nonatomic, assign) id<MoviePlayerViewControllerDataSource> datasource;
@property (nonatomic, assign) MoviePlayerViewControllerMode mode;
@property (nonatomic,strong)NSMutableArray *urlList;
- (id)initNetworkMoviePlayerViewControllerWithURL:(NSURL *)url movieTitle:(NSString *)movieTitle;

- (id)initLocalMoviePlayerViewControllerWithURL:(NSURL *)url movieTitle:(NSString *)movieTitle;
- (id)initLocalMoviePlayerViewControllerWithURLList:(NSArray *)urlList movieTitle:(NSString *)movieTitle;
-(void)returnRecord;
//删除播放记录
-(void)deleteRecord:(NSString *)_id;
@end
