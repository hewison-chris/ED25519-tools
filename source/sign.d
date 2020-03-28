module sign;

import hex;
import stellar;

import libsodium;

/// Structure to return result to program main
struct SignResult
{
    ///status code to return (0 if success)
    int sts;
    ///hex representation of the signature and message concatenated
    string txt;
}

/**
output the signature of data using seed.
**/
SignResult sign(string stellarSeed, string message) @safe
{
    const ubyte[SEED_BYTES] seed = stellarParse(stellarSeed, STELLAR_TYPE.SEED);
    ubyte[SK_BYTES] sk = getSecretKeyFromSeed(seed);
    return createSignature(message, &sk[0]);
}

///
unittest
{
    const auto r = sign("SDSBQZ7BD2XZZPEUFWS7WQGB7BFUI7TCH474S6C5OQTNBICD7AZ2FDN6",
            "I love BOSAGORA");
    assert(r.sts == 0);
    assert(r.txt == "CED308BE013B95030752DD223F960DEC02735201F4E238274959ABA09C36D3542E01A0CBD2A342E349DD934A8D51564A08A8ADF9D92487E4D3362D83E9C6890D49206C6F766520424F5341474F5241");
}

private ubyte[SK_BYTES] getSecretKeyFromSeed(ubyte[SEED_BYTES] seed) @trusted
{
    ubyte[PK_BYTES] pk;
    ubyte[SK_BYTES] sk;
    crypto_sign_seed_keypair(&pk[0], &sk[0], &seed[0]);
    return sk;
}

private SignResult createSignature(const string message, const ubyte* sk) @trusted
{
    const ubyte[] m = textToBuf(message);
    ulong smlen;
    ubyte[] sm = new ubyte[](m.length + SIG_BYTES); //Allocate the required memory
    const ulong mlen = m.length;
    const int res = crypto_sign(&sm[0], &smlen, &m[0], mlen, &sk[0]);
    string signature = writeHex(sm[0 .. smlen]);
    sm = null; //Free the allocated memory
    return SignResult(res, signature);
}
