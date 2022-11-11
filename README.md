# nix-sbom-test

Test generating SBOM (both SPDX and CycloneDX) from nix package.
For now, this is simply a wrapper around https://github.com/mstone/nixbom and https://github.com/sudo-bmitch/convert-nix-cyclonedx.

### Example usage
```
./sbom.sh

[+] This script demonstrates generating SBOM from nix package
[+] Using target '/home/jdoe/nix-sbom-test/nix-hello/default.nix'
[+] Building nixbom
[+] Generating SBOM (SPDX) with nixbom
[+] Building convert-nix-cyclonedx
[+] Generating SBOM (CycloneDX) with convert-nix-cyclonedx
[+] Wrote the following results:

    /home/jdoe/nix-sbom-test/SPDX.json
    /home/jdoe/nix-sbom-test/CycloneDX.json
```
