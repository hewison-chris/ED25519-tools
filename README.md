# Ed25519-signer
Program to create a keypair, sign and verify using Ed25519 algorithm.

# To Build and unit test:
```
./build.sh
```

# To run:
## Output the help:
```
./signer
```

## Output Stellar-encoded, randomly generated Ed25519 keypair:
```
./signer keypair
```

## Output the signature of $DATA using $SEED:
```
./signer sign $SEED $DATA
```

## Verify $SIGNATURE using $PUBLIC_KEY:
```
./signer verify $PUBLIC_KEY $SIGNATURE
```
