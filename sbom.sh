#!/bin/sh

################################################################################

MYDIR=$(dirname "$(readlink -f "$0")")
TARGET_NIX_EXPRESSION_FILE="$MYDIR/nix-hello/default.nix"

################################################################################

main () {
    echo "[+] This script demonstrates generating SBOM from nix package"
    echo "[+] Using target '$TARGET_NIX_EXPRESSION_FILE'"
    exit_unless_file_exists "$TARGET_NIX_EXPRESSION_FILE"
    exit_unless_command_exists "nix"
    exit_unless_command_exists "nix-instantiate"
    exit_unless_command_exists "git"
    DERIVATION=$(nix-instantiate "$TARGET_NIX_EXPRESSION_FILE" 2>/dev/null)
    exit_unless_file_exists "$DERIVATION"

    run_nixbom
    run_convert_nix_cyclonedx

    echo "[+] Wrote the following results:"
    echo ""
    if [ -n "$run_nixbom_result" ]; then
        echo "    $run_nixbom_result"
    fi
    if [ -n "$run_convert_nix_cyclonedx_result" ]; then
        echo "    $run_convert_nix_cyclonedx_result"
    fi
    echo ""
}

run_nixbom () {
    echo "[+] Building nixbom"
    if ! [ -d "$MYDIR"/nixbom ]; then
        git clone --quiet https://github.com/henrirosten/nixbom "$MYDIR"/nixbom
    fi
    cd "$MYDIR"/nixbom || exit 1
    if ! nix build; then
        err_print "building nixbom failed"
        exit 1
    fi
    exit_unless_file_exists "result/bin/spdnix"
    echo "[+] Generating SBOM (SPDX) with nixbom"
    if ! result/bin/spdnix "$DERIVATION" --authors "John Doe" --name "nix-hello" >/dev/null; then
        err_print "nixbom failed"
        exit 1
    fi
    exit_unless_file_exists "nixpkgs.json"
    run_nixbom_result="$MYDIR/SPDX.json"
    mv nixpkgs.json "$run_nixbom_result"
}

run_convert_nix_cyclonedx () {
    echo "[+] Building convert-nix-cyclonedx"
    if ! [ -d "$MYDIR"/convert-nix-cyclonedx ]; then
        git clone --quiet https://github.com/henrirosten/convert-nix-cyclonedx.git "$MYDIR"/convert-nix-cyclonedx
    fi
    cd "$MYDIR"/convert-nix-cyclonedx || exit 1
    if ! nix build; then
        err_print "building convert-nix-cyclonedx failed"
        exit 1
    fi
    exit_unless_file_exists "result/bin/convert-nix-cyclonedx"
    echo "[+] Generating SBOM (CycloneDX) with convert-nix-cyclonedx"
    run_convert_nix_cyclonedx_result="$MYDIR/CycloneDX.json"
    if ! nix show-derivation "$DERIVATION" --recursive | result/bin/convert-nix-cyclonedx > "$run_convert_nix_cyclonedx_result"; then
        err_print "convert-nix-cyclonedx failed"
        exit 1
    fi
    exit_unless_file_exists "$run_convert_nix_cyclonedx_result"
}

################################################################################

exit_unless_command_exists () {
    if ! [ -x "$(command -v "$1")" ]; then
        err_print "$1 is not installed" >&2
        exit 1
    fi
}

exit_unless_file_exists () {
    if ! [ -f "$1" ]; then
        err_print "file not found: \"$1\"" >&2
        exit 1
    fi
}

err_print () {
    RED_BOLD='\033[1;31m'
    NC='\033[0m'
    # If stdout is to terminal print colorized error message, otherwise print
    # with no colors
    if [ -t 1 ]; then
        printf "${RED_BOLD}Error:${NC} %s\n" "$1"
    else
        printf "Error: %s\n" "$1"
    fi
}

################################################################################

main "$@"

################################################################################
