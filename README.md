# nix-sbom-test

Test generating SBOM (both SPDX and CycloneDX) from nix package.
For now, this is simply a wrapper around https://github.com/mstone/nixbom, https://github.com/sudo-bmitch/convert-nix-cyclonedx, and https://github.com/nikstur/bombon.

### Example usage
```
./sbom.sh

[+] This script demonstrates generating SBOM from nix package
[+] Using target '/home/jdoe/nix-sbom-test/nix-hello/default.nix'
[+] Building nixbom
[+] Generating SBOM (SPDX) with nixbom
[+] Building convert-nix-cyclonedx
[+] Generating SBOM (CycloneDX) with convert-nix-cyclonedx
[+] Generating SBOM (CycloneDX) with bombon
[+] Wrote the following results:

    /home/jdoe/nix-sbom-test/nixbom.spdx.json
    /home/jdoe/nix-sbom-test/convert-nix-cyclonedx.cdx.json
    /home/jdoe/nix-sbom-test/bombon.cdx.json

```
