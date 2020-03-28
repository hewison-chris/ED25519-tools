module app;

import sign : sign, SignResult;
import verify : verify, VerifyResult;
import keypair : keypair, KeyPairResult;

import std.stdio;
import std.exception;

int main(string[] args)
{
    try
    {
        if (args.length == 2)
        {
            switch (args[1])
            {
            case "keypair":
                auto keypairResult = keypair();
                writeln("Private: ", keypairResult.seedKey);
                writeln("Public:  ", keypairResult.publicKey);
                return keypairResult.sts;
            default:
                throw new Exception("Invalid program args. Read help above.");
            }
        }
        else if (args.length == 4)
        {
            switch (args[1])
            {
            case "sign":
                auto signResult = sign(args[2], args[3]);
                if (signResult.sts == 0)
                {
                    writeln(signResult.txt);
                }
                else
                {
                    writeln("Failed to sign with error status:", signResult.sts);
                }
                return signResult.sts;
            case "verify":
                auto verifyResult = verify(args[2], args[3]);
                if (verifyResult.sts == 0)
                {
                    writeln("Verification succeeded");
                    writeln(verifyResult.txt);
                }
                else
                {
                    writeln("Verification failed");
                    writeln("Status code =", verifyResult.sts);
                    writeln(verifyResult.txt);
                }

                return verifyResult.sts;
            default:
                throw new Exception("Invalid program args. Read help above.");
            }
        }
        else
        {
            outputHelp();
        }
    }
    catch (Exception e)
    {
        outputHelp();
        writeln(e.msg);
        return -1;
    }
    return 0;
}

private void outputHelp()
{
    writeln("============================================");
    writeln("Options to run this Ed25519 Signer Program:-");
    writeln("============================================");
    writeln(
            "./signer keypair                         - create Stellar encoded Ed25519 keypair (Seed and Public key)");
    writeln("./signer sign $SEED $DATA                - sign $DATA using $SEED");
    writeln("./signer verify $PUBLIC_KEY $SIGNATURE   - verify $SIGNATURE using $PUBLIC_KEY");
    writeln("============================================");
}
