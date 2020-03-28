module verify;

import stellar;
import hex;

import libsodium;

/// Structure to return result to program main
struct VerifyResult
{
    ///status code to return (0 if success)
    int sts;
    ///message that was signed
    string txt;
}

/**
Create, store and output Stellar-encoded, randomly generated Ed25519 keypair.
**/
VerifyResult verify(string publicKey, string signedMessage) @safe
{
    const ubyte[PK_BYTES] pk = stellarParse(publicKey, STELLAR_TYPE.ACCOUNT_ID);
    return verifySignature(signedMessage, &pk[0]);
}

///
unittest
{
    const auto r = verify("GASG2JFZI4XKNQFF5FH2QGBXCROVJBNE43QNJWMXQQIDZZPYP3UVGTW6", "CED308BE013B95030752DD223F960DEC02735201F4E238274959ABA09C36D3542E01A0CBD2A342E349DD934A8D51564A08A8ADF9D92487E4D3362D83E9C6890D49206C6F766520424F5341474F5241");
    assert(r.sts == 0);
    assert(r.txt == "I love BOSAGORA");
}

private VerifyResult verifySignature(string signedMessage, const ubyte* pk) @trusted
{
    const ubyte[] sm = readHex(signedMessage);
    ubyte[] m = new ubyte[](sm.length + SIG_BYTES); //Allocate the required memory
    ulong mlen;
    const ulong smlen = sm.length;
    const int res = crypto_sign_open(&m[0], &mlen, &sm[0], smlen, &pk[0]);
    const ubyte[] msg = m[0 .. mlen];
    const string actualMessage = hexToText(msg);
    m = null; //Free the allocated memory
    return VerifyResult(res, actualMessage);
}
