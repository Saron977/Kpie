//
//  BYC_RSA.m
//  kpie
//
//  Created by 元朝 on 15/11/9.
//  Copyright © 2015年 QNWS. All rights reserved.
//

#import "BYC_RSA.h"
#import <Security/Security.h>
#import "BYC_PropertyManager.h"

/**
 *  公钥
 */
static NSString *pubkey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDqB+OB1GMmNsOushhd3nHKO3OsextO+UYjtxUBLViHIQqrwaRnN2NU0vg0WBSpO0qtArglvCDWbThZgdApw1AJvUH3Rl9cMajoMQo3PFZqzJbwd6mwmmaiWmNPOsYL+4pVr/ndG23QjUMthS0h1K99YVtfbwZUW9OkFn0bSk970QIDAQAB";

/**
 *  短信校验公钥
 */
static NSString *pubkey_New = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCcUqyaJgeBEBz+ZSNpxbxXtfPmb5CdMzeXg+UtaHCZWPUUq4ZHbcoR4sQYwTt6hcm2J6wZLxTJLLbdxXo09Cqv2ib999gnB6Ht3XtYb+Nng5u0+tEUaNTZ7CSL2+5PDQNu4/pVz0PqP5hZVx4gJmmnAMWQL1PilivvH1INDErX1wIDAQAB";

@implementation BYC_RSA
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{

    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    

    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (SecKeyRef)addPublicKey:(NSString *)key{

    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    

    NSData *data = base64_decode(key);
    data = [BYC_RSA stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }
    
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    

    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSString *)encryptString:(NSString *)str{
    NSData *data = [BYC_RSA encryptData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSData *)encryptData:(NSData *)data{
    NSString *publicKey =  [BYC_PropertyManager sharedBYC_PropertyManager].isMessageVerification ? pubkey_New : pubkey;
    [BYC_PropertyManager sharedBYC_PropertyManager].isMessageVerification = NO;
    if(!data || !publicKey){
        return nil;
    }
    SecKeyRef keyRef = [BYC_RSA addPublicKey:publicKey];
    if(!keyRef){
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen > outlen - 11){
        CFRelease(keyRef);
        return nil;
    }
    void *outbuf = malloc(outlen);
    
    OSStatus status = noErr;
    status = SecKeyEncrypt(keyRef,
                           kSecPaddingPKCS1,
                           srcbuf,
                           srclen,
                           outbuf,
                           &outlen
                           );
    NSData *ret = nil;
    if (status != 0) {

    }else{
        ret = [NSData dataWithBytes:outbuf length:outlen];
    }
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}
@end
