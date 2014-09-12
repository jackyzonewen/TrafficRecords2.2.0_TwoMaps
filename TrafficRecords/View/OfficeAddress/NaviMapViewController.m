//
//  NaviMapViewController.m
//  TrafficRecords
//
//  Created by qiao on 14-3-18.
//  Copyright (c) 2014年 AutoHome. All rights reserved.
//

#import "NaviMapViewController.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"

@interface NaviMapViewController ()

@end

@implementation NaviMapViewController

@synthesize busLineData;
@synthesize pathData;
@synthesize type;
@synthesize startPos;
@synthesize endPos;
@synthesize mytitle;
@synthesize subtitle;
@synthesize infoView;

//-(NSString *) naviTitle{
//    return @"路线导航";
//}
//
//-(NSString *) naviLeftIcon{
//    return @"back.png";
//}

-(void) naviLeftClick:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) naviRightClick:(id)sender{
    if (_mapView) {
        _mapView.showsUserLocation = !_mapView.showsUserLocation;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dealloc
{
    [self clear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (infoView == nil) {
        float height = 302;
        self.infoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom - height, self.view.width, height)];
        infoView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:infoView];
        UIImage *shadow = TRImage(@"shadow.png");
        shadow = [TRUtility image:shadow rotation:UIImageOrientationDown];
        UIImageView *shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, infoView.width, 2)];
        shadowView.image = shadow;
        [infoView addSubview:shadowView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, shadowView.height, infoView.width, height - shadowView.height)];
        bgView.backgroundColor = [UIColor whiteColor];
        [infoView addSubview:bgView];
        
        UIImage *openImage = TRImage(@"openIcon.png");
        UIImage *closeImage = TRImage(@"closeIcon.png");
        UIButton *openCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openCloseBtn.frame = CGRectMake(0, 0, bgView.width, openImage.size.height);
        [openCloseBtn setImage:openImage forState:UIControlStateNormal];
        [openCloseBtn setImage:closeImage forState:UIControlStateSelected];
        [openCloseBtn addTarget:self action:@selector(openCloseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:openCloseBtn];
        dragBtn = openCloseBtn;
        if (type == 0) {
            UIFont *font1 = [UIFont systemFontOfSize:15];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, openCloseBtn.bottom, bgView.width - 16*2, 80 - openCloseBtn.bottom)];
            label.text = self.mytitle;
            label.font = font1;
            label.numberOfLines = 0;
            label.textColor = [TRSkinManager colorWithInt:0x666666];
            label.backgroundColor = [UIColor clearColor];
            [bgView addSubview:label];
        } else {
            UIFont *font1 = [UIFont systemFontOfSize:15];
            UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, openCloseBtn.bottom + 10, bgView.width - 16*2, font1.lineHeight)];
            textLabel.text = self.mytitle;
            textLabel.textColor = [TRSkinManager colorWithInt:0x666666];
            textLabel.font = font1;
            textLabel.backgroundColor = [UIColor clearColor];
            [bgView addSubview:textLabel];
            font1 = [UIFont systemFontOfSize:14];
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, textLabel.bottom + 10, bgView.width - 16*2, font1.lineHeight)];
            textLabel.textColor = [TRSkinManager colorWithInt:0x999999];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.font = font1;
            textLabel.text = self.subtitle;
            [bgView addSubview:textLabel];
        }
        float lineH = [TRUtility lineHeight];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 80, bgView.width - 15 * 2, lineH)];
        line.backgroundColor = [TRSkinManager colorWithInt:0xd9d9d9];
        [bgView addSubview:line];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(line.left, line.bottom, line.width, bgView.height - line.bottom)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [bgView addSubview:scrollView];
        
        UIView *blueline = [[UIView alloc] initWithFrame:CGRectMake(11, 0 , 1, 0)];
        blueline.backgroundColor = [TRSkinManager colorWithInt:0x1d97f1];
        [scrollView addSubview:blueline];
        
        float containH = 21 * 2;//上下留出来21个高德像素
        float gapH = 35;
        float currentH = 21;
        float blueS = 0;
        float blueH = 0;
        float endh = 0;
        if (type == 0) {
            UIImage *busIcon = TRImage(@"busIcon.png");
            UIImage *walkIcon = TRImage(@"walkingIcon.png");
            for (AMapSegment *segment in busLineData.segments) {
                //segment中同时包含 walking和 busline，总是先走
                if (segment.walking) {
                    NSString *str = segment.busline.departureStop.name;
                    if (str.length == 0 && segment.busline == nil) {//抵到终点
                        NSString *dis = nil;
                        if (segment.walking.distance >= 1000) {
                            dis = [NSString stringWithFormat:@"%0.1f公里", segment.walking.distance/1000.0];
                        } else {
                            dis = [NSString stringWithFormat:@"%d米", segment.walking.distance];
                        }
                        str = [NSString stringWithFormat:@"步行%@到达目的地", dis];
                    } else{
                        str = [NSString stringWithFormat:@"步行至%@", str];
                    }
                    float h = [self addIcon:walkIcon Text:str toView:scrollView atPos:currentH];
                    if (blueS == 0) {
                        blueS = h/2 + currentH;
                        blueH += h/2 + gapH;
                    } else {
                        blueH += h + gapH;
                    }
                    currentH += h + gapH;
                    containH += h + gapH;
                    endh = h;
                }
                if (segment.busline) {
                    NSString * str = [NSString stringWithFormat:@"乘坐%@，经过%d站，到达%@", segment.busline.name, segment.busline.busStops.count + 1, segment.busline.arrivalStop.name];
                    float h = [self addIcon:busIcon Text:str toView:scrollView atPos:currentH];
                    if (blueS == 0) {
                        blueS = h/2 + currentH;
                        blueH += h/2 + gapH;
                    } else {
                        blueH += h + gapH;
                    }
                    currentH += h + gapH;
                    containH += h + gapH;
                    endh = h;
                }
            }
        } else {
            UIImage *icon = TRImage(@"carIcon.png");
            if (type == 2) {
                icon = TRImage(@"walkingIcon.png");
            }
            for (AMapStep *step in pathData.steps) {
                float h = [self addIcon:icon Text:step.instruction toView:scrollView atPos:currentH];
                if (blueS == 0) {
                    blueS = h/2 + currentH;
                    blueH += h/2 + gapH;
                } else {
                    blueH += h + gapH;
                }
                currentH += h + gapH;
                containH += h + gapH;
                endh = h;
            }
        }
        blueH -= (gapH + endh/2);
        containH -= gapH;
        [blueline setTop:blueS];
        [blueline setHeight:blueH];
        [scrollView setContentSize:CGSizeMake(scrollView.width, containH)];
        if (containH < 300 - 80) {
            infViewHeight = 80 + lineH + containH + 2;
        } else {
            infViewHeight = 302;
        }
    }
    [self.infoView setTop:self.view.bottom - 92];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePan:)];
    [self.infoView addGestureRecognizer:panGestureRecognizer];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint touchPoint = [recognizer translationInView:self.infoView];
    float min = self.view.bottom - infViewHeight;
    float max = self.view.bottom - 92;
    if (UIGestureRecognizerStateBegan == recognizer.state) {
        lastTouchPos = touchPoint;
    } else if(UIGestureRecognizerStateChanged == recognizer.state)
    {
        float len = touchPoint.y - lastTouchPos.y;
        lastTouchPos = touchPoint;
        float top = self.infoView.top;
        top += len;
        if (top < min) {
            top = min;
        } else if(top > max){
            top = max;
        }
        [self.infoView setTop:top];
    }else if (recognizer.state == UIGestureRecognizerStateEnded) {
        float len = touchPoint.y - lastTouchPos.y;
        float top = self.infoView.top;
        top += len;
        if (ABS(min -top) < ABS(max - top)) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.infoView setTop:min];
                dragBtn.selected = YES;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                [self.infoView setTop:max];
                dragBtn.selected = NO;
            }];
        }
    }else if(recognizer.state == UIGestureRecognizerStateCancelled ||
                     recognizer.state == UIGestureRecognizerStateFailed)
    {
        float top = self.infoView.top;
        if (ABS(min -top) < ABS(max - top)) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.infoView setTop:min];
                dragBtn.selected = YES;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                [self.infoView setTop:max];
                dragBtn.selected = NO;
            }];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}

-(void) viewWillAppear:(BOOL)animated
{
    // Do any additional setup after loading the view.
    CGRect frame = self.view.bounds;
    _mapView = [[MAMapView alloc] initWithFrame:frame];
    _mapView.delegate = self;
    _mapView.showsScale = NO;
    _mapView.showsCompass = NO;
    [self.view insertSubview:_mapView belowSubview:[self infoView]];
    
    UIImage *image = TRImage(@"mapBack.png");
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:TRImage(@"mapBack.png") forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(14, 15, image.size.width, image.size.height)];
    [backBtn addTarget:self action:@selector(naviLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    UIButton * locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setBackgroundImage:TRImage(@"showUserLocation.png") forState:UIControlStateNormal];
    [locationBtn setFrame:CGRectMake(self.view.width - backBtn.width  - 14, 15, image.size.width, image.size.height)];
    [locationBtn addTarget:self action:@selector(naviRightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];
    
    [self presentCurrentCourse];
    [self addDefaultAnnotations];
}


- (void)presentCurrentCourse
{
    NSArray *polylines = nil;
    
    /* 公交导航. */
    if (type == 0)
    {
        polylines = [CommonUtility polylinesForTransit:self.busLineData];
    }
    /* 步行，驾车导航. */
    else
    {
        polylines = [CommonUtility polylinesForPath:self.pathData];
    }
    
    [_mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. */
     MAMapRect rect = [CommonUtility mapRectForOverlays:polylines];
    rect.origin.x -= rect.size.width * 0.25/2;
    rect.origin.y -= rect.size.height * 0.25/2;
    rect.size.width += rect.size.width * 0.25;
    rect.size.height += rect.size.height * 0.25;
    _mapView.visibleMapRect = rect;
}

- (void)addDefaultAnnotations
{
    CLLocationCoordinate2D lineStart = CLLocationCoordinate2DMake(0, 0);
    CLLocationCoordinate2D lineEnd = CLLocationCoordinate2DMake(0, 0);
    if (type == 0) {
        for (int i = 0; i < busLineData.segments.count; i++) {
            AMapSegment *segment = [busLineData.segments objectAtIndex:i];
            if ( i== 0) {
                if (segment.walking) {
                    lineStart = CLLocationCoordinate2DMake(segment.walking.origin.latitude, segment.walking.origin.longitude);
                }
            }
            if (i == busLineData.segments.count - 1) {
                if (segment.walking) {
                    lineEnd = CLLocationCoordinate2DMake(segment.walking.destination.latitude, segment.walking.destination.longitude);
                    
                    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                    annotation.coordinate = CLLocationCoordinate2DMake(segment.walking.origin.latitude, segment.walking.origin.longitude);
                    annotation.title = @"步行";
                    [_mapView addAnnotation:annotation];
                }
            }
            
            if(segment.busline != nil){
                MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(segment.busline.departureStop.location.latitude, segment.busline.departureStop.location.longitude);
                annotation.title = @"公交";
                [_mapView addAnnotation:annotation];
            }
        }
    } else if(type == 1 || type == 2)
    {
        for (int i = 0; i < pathData.steps.count; i++) {
            AMapStep *step = [pathData.steps objectAtIndex:i];
            if (i == 0) {
                NSUInteger count = 0;
                CLLocationCoordinate2D *coordinates = [CommonUtility coordinatesForString:step.polyline
                                                                          coordinateCount:&count
                                                                               parseToken:@";"];
                lineStart.latitude = coordinates->latitude;
                lineStart.longitude = coordinates->longitude;
                free(coordinates), coordinates = NULL;
            }
            if(i == pathData.steps.count - 1)
            {
                NSUInteger count = 0;
                CLLocationCoordinate2D *coordinates = [CommonUtility coordinatesForString:step.polyline
                                                                          coordinateCount:&count
                                                                               parseToken:@";"];
                lineEnd.latitude = (coordinates + count - 1)->latitude;
                lineEnd.longitude = (coordinates + count - 1)->longitude;
                free(coordinates), coordinates = NULL;
            }
        }
    }
    
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = lineStart;
    annotation.title = @"起点";
    [_mapView addAnnotation:annotation];
    
    annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = lineEnd;
    annotation.title = @"终点";
    [_mapView addAnnotation:annotation];
    
}

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        overlayView.lineWidth   = 4;
        overlayView.strokeColor = [TRSkinManager colorWithInt:0x0683ee];
        
        return overlayView;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.lineWidth   = 4;
        overlayView.strokeColor = [TRSkinManager colorWithInt:0x0683ee];
        
        return overlayView;
    }
    
    return nil;
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
            
            poiAnnotationView.canShowCallout = NO;
        }
        
//        /* 起点. */
        if ([[annotation title] isEqualToString:@"起点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"start.png"];
        }
        else if([[annotation title] isEqualToString:@"终点"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"end.png"];
        } else if([[annotation title] isEqualToString:@"步行"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"walkingMap.png"];
        } else if([[annotation title] isEqualToString:@"公交"])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"busMap.png"];
        }
        return poiAnnotationView;
    }
    
    return nil;
}

/* 清空地图上的overlay. */
- (void)clear
{
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    
    _mapView.delegate = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) openCloseBtnClick:(UIButton *) btn
{
    if (infoView == nil) {
        return;
    }
    //selected == YES,显示关闭图片，即当前处于打开状态
    if (btn.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            btn.selected = NO;
            [infoView setTop:self.view.bottom - 92];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            btn.selected = YES;
            [infoView setTop:self.view.bottom - infViewHeight];
        }];
    }
}

-(float) addIcon:(UIImage *)icon Text:(NSString *) text toView:(UIView *) parentView atPos:(float) pos;
{
    float gap = 12;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize iconsize = icon.size;
    float labelW = parentView.width - iconsize.width - gap;
    float labelH = [text sizeWithFont:font constrainedToSize:CGSizeMake(labelW, 99999)].height;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, pos + labelH/2 - iconsize.height/2, iconsize.width, iconsize.height)];
    iconView.image = icon;
    [parentView addSubview:iconView];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right + gap, pos, labelW, labelH)];
    textLabel.textColor = [TRSkinManager colorWithInt:0x666666];
    textLabel.font = font;
    textLabel.text = text;
    textLabel.numberOfLines = 0;
    textLabel.backgroundColor = [UIColor clearColor];
    [parentView addSubview:textLabel];
    return labelH;
}

@end
