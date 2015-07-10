#import "ImageProvider.h"

@interface ImageProvider ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation ImageProvider


#pragma mark
#pragma mark Singletons

+ (ImageProvider *)defaultProvider {
    static dispatch_once_t onceToken;
    static ImageProvider *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageProvider alloc] init];
        sharedInstance.providerName = @"DefaultProvider";
        sharedInstance.customUserAgent = @"ps-mobile-request";
    });
    
    return sharedInstance;
}


#pragma mark -
#pragma mark Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
        self.cache.countLimit = 15;
    }
    return self;
}


#pragma mark -
#pragma mark Public Methods

- (void)imageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock {
    if (!url) {
        if(completionBlock != NULL)
            completionBlock(NO, nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // SOURCE 1 - MEMCACHE
        UIImage *image = (UIImage *)[self.cache objectForKey:url];
        
        // SOURCE 2 - FILESYSTEM
        if (!image) {
            image = [self imageFromFileSystemWithURL:url];
        }
        
        // SOURCE 3 - INTERNET
        if (!image) {
            image = [self downloadImageFromURL:url];
        }
        
        BOOL succeeded = (image != nil);
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completionBlock != NULL)
                completionBlock(succeeded, image);
        });
        
    });
}


#pragma mark -
#pragma mark Internal Access Methods

- (UIImage *)imageFromFileSystemWithURL:(NSURL *)url {
    NSData *imageData = [NSData dataWithContentsOfFile:[self filePathForUrl:url]];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (image) {
        [self storeImage:image inMemoryCacheWithKey:url];
    }
    
    return image;
}

- (UIImage *)downloadImageFromURL:(NSURL *)url {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    if (self.customUserAgent) {
        [request addValue:self.customUserAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    NSData *imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (image && imageData) {
        [self storeData:imageData inFileSystemWithKey:url];
        [self storeImage:image inMemoryCacheWithKey:url];
    }
    
    return image;
}


#pragma mark -
#pragma mark Internal Storage Methods

- (void)storeData:(NSData *)imageData inFileSystemWithKey:(NSURL *)url {
    [imageData writeToFile:[self filePathForUrl:url] atomically:YES];
}

- (void)storeImage:(UIImage *)image inMemoryCacheWithKey:(NSURL *)url {
    [self.cache setObject:image forKey:url];
}


#pragma mark -
#pragma mark Key Transformations

- (NSString *)filePathForUrl:(NSURL *)url {
    NSString *filename = [url path];
    filename = [filename stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    filename = [filename stringByReplacingOccurrencesOfString:@"https:" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"http:" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    filename = [filename stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
    
    NSString *path = [[self temporaryFileSystem] stringByAppendingPathComponent:filename];
    return path;
}


#pragma mark -
#pragma mark Filesystem Paths

- (NSString *)temporaryFileSystem {
    NSString *temporaryDir = NSTemporaryDirectory();
    temporaryDir = [temporaryDir stringByAppendingPathComponent:@"ImageCaches"];
    temporaryDir = [temporaryDir stringByAppendingPathComponent:self.providerName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:temporaryDir isDirectory:nil]) {
        [fileManager createDirectoryAtPath:temporaryDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return temporaryDir;
}

@end
