module stellar;

import hex;
import std.conv;

import base32;
import crypto.Crc16;
import libsodium;

/**
Stellar keys are prefixed with a letter to indicate what they are used for
*/
enum STELLAR_TYPE: ubyte[1] { 
    SEED=[0x90], 
    ACCOUNT_ID=[0x30]
}

///Number of bytes in public key
const PK_BYTES = crypto_sign_ed25519_PUBLICKEYBYTES;
///Number of bytes in seed key
const SEED_BYTES = crypto_sign_ed25519_SEEDBYTES;
///Number of bytes in secret key
const SK_BYTES = crypto_sign_ed25519_SECRETKEYBYTES;
///Number of bytes in public key
const STELLAR_BYTES = 1 + crypto_sign_ed25519_PUBLICKEYBYTES + 2;
///Number of bytes in signature
const SIG_BYTES = 64;

/**
return the bytes encoded in Base32 with S or G prefixed
**/
string stellarFormat(const ubyte* keyBytes, const STELLAR_TYPE stellarType) @trusted {
    ubyte[35] stellarKey;
    stellarKey[0] = stellarType[0];
    assert(PK_BYTES==SEED_BYTES);
    stellarKey[1..PK_BYTES+1] = keyBytes[0..PK_BYTES];
    stellarKey[PK_BYTES+1..$] = checksum(stellarKey[0..PK_BYTES]);
    char[] encodedKey = Base32.encode(stellarKey);
    assert (encodedKey.length==56);
    return to!string(encodedKey);
}

/**
return the actual key bytes from a stellar key checking the type is as expected
**/
ubyte[] stellarParse(const string stellarKey, const STELLAR_TYPE stellarType) @safe {
    return Base32.decode(stellarKey)[1..PK_BYTES+1];
}
