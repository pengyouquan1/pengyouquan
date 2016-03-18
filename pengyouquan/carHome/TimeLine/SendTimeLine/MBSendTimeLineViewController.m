//
//  MBSendTimeLineViewController.m
//  朋友圈发布
//
//  Created by 巫筠 on 16/3/18.
//  Copyright © 2016年 巫筠. All rights reserved.
//

#import "MBSendTimeLineViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"



#define GrayColor [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0]
#define PATH @"http://115.28.108.41:8080/yueche/yuecheApp/appAddCircles"

@interface MBSendTimeLineViewController ()<AVCaptureMetadataOutputObjectsDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITextView * _textView;
    UILabel * placeHolderLab;
    int i;
    UIImage * image222;
    UIButton * addImgButton;
    UIButton * rightButton;
    
}

@end

@implementation MBSendTimeLineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    i = 0;

    self.view.backgroundColor = [UIColor whiteColor];
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.alpha = 0.4;
    rightButton.userInteractionEnabled = NO;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton * leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.30)];
    _textView.font = [UIFont systemFontOfSize:19];
    _textView.delegate = self;
//    _textView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_textView];
    
    placeHolderLab = [[UILabel alloc] initWithFrame:CGRectMake(4, 6, _textView.frame.size.width, 21)];
    placeHolderLab.text = @"  这一刻的想法";
    placeHolderLab.textColor = GrayColor;
    [_textView addSubview:placeHolderLab];
    
    CGFloat buttonHeight = 0.35 * _textView.frame.size.height;
    addImgButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _textView.frame.size.height, buttonHeight, buttonHeight)];
    addImgButton.layer.borderWidth = 1.2;
    addImgButton.layer.borderColor = GrayColor.CGColor;
    [addImgButton addTarget:self action:@selector(addImg) forControlEvents:UIControlEventTouchUpInside];
    [addImgButton setImage:[UIImage imageNamed:@"iconfont-jiahao"] forState:UIControlStateNormal];
    [self.view addSubview:addImgButton];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(20, addImgButton.frame.origin.y + buttonHeight + 20, _textView.frame.size.width - 20, 1)];
    lineView.backgroundColor  =GrayColor;
    [self.view addSubview:lineView];
    
    UIView * blankView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.frame.origin.y + 1, self.view.frame.size.width, self.view.frame.size.height - lineView.frame.origin.y - 1)];
    blankView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
    [self.view addSubview:blankView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    
    NSString * customeId = @"1";
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    NSData * data;
    if (image222) {
       data =  UIImageJPEGRepresentation(image222,0.5);
    }
    
    [session POST:PATH parameters:@{@"customerId":customeId,@"circlesContext":_textView.text} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image222) {
            [formData appendPartWithFileData:data name:@"img" fileName:@"1234567.jpeg" mimeType:@"image/jpeg"];
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([[dic objectForKey:@"msg"] isEqualToString:@"接口：车友圈-发布信息--成功..."]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败");
    }];

    
    
}

-(void)addImg
{
    [_textView resignFirstResponder];
    if (i==0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择图片来源"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"拍照"
                                      otherButtonTitles:@"从相册选择",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag=1000;
        [actionSheet showInView:self.view];
        
    }else if (i==1){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择图片来源"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"拍照"
                                      otherButtonTitles:@"从相册选择",@"撤销",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        actionSheet.tag=1001;
        [actionSheet showInView:self.view];
        
    }
    

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1000) {
        if (buttonIndex == 0) {
            [self camera];
        }else if (buttonIndex == 1) {
            [self PhotoLibrary];
        }
    }else if (actionSheet.tag==1001){
        if (buttonIndex == 0) {
            
            [self camera];
        }else if (buttonIndex == 1) {
            [self PhotoLibrary];
        }else if (buttonIndex == 2){
            [self deletePictur];
        }
    }
    
    
}
-(void)camera
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //Input
    NSError *error;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //判断是否有输入
    if (!input)
    {
        NSLog(@"error info:%@", error.description);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请手动打开相机访问权限" message:@"设置-->隐私-->相机" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        alert.delegate =self;
        [alert setTag:100];
        [alert show];
        
        return;
    }
    
    UIImagePickerControllerSourceType sourceType =UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:^{}];//进入照相界面
}
-(void)PhotoLibrary
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    //    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    //    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:^{}];
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

-(void)deletePictur
{
    image222 = nil;
    [addImgButton setImage:[UIImage imageNamed:@"iconfont-jiahao"] forState:UIControlStateNormal];
    i=0;
}

#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image222= [[UIImage alloc] init];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    image222 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [addImgButton setImage:image222 forState:UIControlStateNormal];
    i=1;
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}


#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    placeHolderLab.hidden = YES;
}
//3.在结束编辑的代理方法中进行如下操作
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_textView.text.length<1) {
        placeHolderLab.hidden = NO;
        rightButton.userInteractionEnabled = NO;
        rightButton.titleLabel.alpha = 0.4;
    }
    else
    {
        rightButton.userInteractionEnabled = YES;
        rightButton.titleLabel.alpha = 1.0;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (_textView.text.length<1) {
        placeHolderLab.hidden = NO;
        rightButton.userInteractionEnabled = NO;
        rightButton.titleLabel.alpha = 0.4;
    }
    else{
        placeHolderLab.hidden = YES;
        rightButton.userInteractionEnabled = YES;
        rightButton.titleLabel.alpha = 1.0;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
