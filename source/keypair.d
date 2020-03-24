module keypair;

import stellar;

import libsodium;

/// Structure to return result to program main
struct KeyPairResult { 
    ///status code to return (0 if success)
    int sts; 
    ///stellar forammted seedKey
    string seedKey; 
    ///stellar forammted publicKey
    string publicKey; 
    }

/**
Create and output Stellar-encoded, randomly generated Ed25519 keypair.
 **/
KeyPairResult keypair() @trusted
{
    ubyte[32] seed;
    randombytes(&seed[0], 32);
    string seedKey = stellarFormat(&seed[0], STELLAR_TYPE.SEED);
    assert(seedKey.length == 56);
    ubyte[SK_BYTES] sk;
    ubyte[PK_BYTES] pk;
    const int res = crypto_sign_seed_keypair(&pk[0], &sk[0], &seed[0]);
    string publicKey = stellarFormat(&pk[0], STELLAR_TYPE.ACCOUNT_ID);
    assert(publicKey.length == 56);
    return KeyPairResult(res, seedKey, publicKey);
}
