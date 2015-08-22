//
//  ViewController.m
//  ImageCropper
//
//  Created by abhayam rastogi on 5/13/15.
//  Copyright (c) 2015 Itelligrape. All rights reserved.
//

#import "ViewController.h"
#import "BFCropInterface.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) BFCropInterface *cropper;
- (IBAction)crop:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@implementation ViewController

@synthesize profileImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self cropSetting];
    /**
     UIImagePickerController *pickerFirLibrary=[[UIImagePickerController alloc] init];
     
     pickerFirLibrary.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
     pickerFirLibrary.delegate=self;
     [self presentViewController:pickerFirLibrary animated:YES completion:nil];
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cropSetting {
    // allocate crop interface with frame and image being cropped
    self.cropper = [[BFCropInterface alloc]initWithFrame:CGRectMake(20, 20, 200, 200) andImage:self.profileImageView.image];
    // this is the default color even if you don't set it
    self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
    // white is the default border color.
    self.cropper.borderColor = [UIColor redColor];
    
    self.cropper.layer.borderWidth = 2.0;
    self.cropper.layer.borderColor = [UIColor redColor].CGColor;
    // add interface to superview. here we are covering the main image view.
    [self.profileImageView addSubview:self.cropper];
    self.cropper.alpha = 0.0;

}

-(BOOL)startMediaBrowserWithSource:(UIImagePickerControllerSourceType)source usingDelegate:(id )delegate {
    // 1 - Validations
    if (([UIImagePickerController isSourceTypeAvailable:source] == NO)
        || (delegate == nil)) {
        return NO;
    }
    
    if (source == UIImagePickerControllerSourceTypeCamera) {
//        [Utility showToastWithMessage:@"Camera is not accessible. Please check the settings."];
        return NO;
    }
    
    // 2 - Get image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = source;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    // 3 - Display image picker
    [self presentViewController:mediaUI animated:YES completion:nil];
    return YES;
}

#pragma mark - UIImagePickerController Delegate methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 1 - Get media type
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    // 2 - Dismiss image picker
    [self dismissViewControllerAnimated:YES completion:nil];
    // Handle a movie capture
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *tempImage = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
        
//        float height = tempImage.size.height;
//        float width = tempImage.size.width;
//        
//        if (width > height) {
//            height = height/2;
//        }
//        else {
//            if (height < kMinImageContainerHeight) {
//                height = kMinImageContainerHeight;
//            }
//            else if (height >= CGRectGetWidth(_viewImageContainer.frame)) {
//                height = CGRectGetWidth(_viewImageContainer.frame);
//            }
//            else {
//                height = kMinImageContainerHeight;
//            }
//        }
        
        [profileImageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [profileImageView setImage:tempImage];
    }
    
    mediaType = nil;
}

/*
 Called to dismiss the Image Picker controller when tapped on Cancel button.
 */

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)crop:(id)sender {
    // crop image
    UIImage *croppedImage = [self.cropper getCroppedImage];
    // remove crop interface from superview
    [self.cropper removeFromSuperview];
    self.cropper = nil;
    //    self.originalImage = self.displayImage.image;
    // display new cropped image
    self.profileImageView.image = croppedImage;

}

- (IBAction)takePhoto:(id)sender {
    [self startMediaBrowserWithSource:UIImagePickerControllerSourceTypePhotoLibrary usingDelegate:self];
}
@end
