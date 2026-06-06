#!/usr/bin/env bash
# ==============================================================================
# Script: common-env.sh
# Purpose: Define common environment variables and toolchain settings for iOS arm64 builds.
# Usage: Sourced by other scripts.
# ==============================================================================

set -euo pipefail

# ------------------------------------------------------------------------------
# Parallelization
# ------------------------------------------------------------------------------
# Determine number of CPU cores for parallel make jobs.
JOBS="$(sysctl -n hw.ncpu)"

# Default iOS version target (can be overridden by environment)
MIN_IOS="${MIN_IOS:-14.5}"

# ------------------------------------------------------------------------------
# Directory Structure
# ------------------------------------------------------------------------------
# WORKDIR: Root for all build artifacts (default: <repo>/work)
# DEPS:    Dependency build directory
# BUILD:   Main build directory
# STAGE:   Final staging directory for packaging
# ROOTLESS_PREFIX: Rootless jailbreak prefix inside package payload
WORKDIR="${WORKDIR:-$PWD/work}"
DEPS="$WORKDIR/deps"
BUILD="$WORKDIR/build"
STAGE="$WORKDIR/stage"
ROOTLESS_PREFIX="${ROOTLESS_PREFIX:-/var/jb}"
STAGE_ROOT="$STAGE$ROOTLESS_PREFIX"

# Create directories if they don't exist
mkdir -p "$DEPS" "$BUILD" "$STAGE" "$STAGE_ROOT"

# ------------------------------------------------------------------------------
# iOS Toolchain Configuration
# ------------------------------------------------------------------------------
# Locate the iOS SDK and toolchain binaries using xcrun.
IOS_SDK="$(xcrun --sdk iphoneos --show-sdk-path)"
CC="$(xcrun --sdk iphoneos -f clang)"
CXX="$(xcrun --sdk iphoneos -f clang++)"
AR="$(xcrun --sdk iphoneos -f ar)"
RANLIB="$(xcrun --sdk iphoneos -f ranlib)"
STRIP="$(xcrun --sdk iphoneos -f strip)"
HOST_TRIPLE="aarch64-apple-darwin"

# ------------------------------------------------------------------------------
# Compiler Flags
# ------------------------------------------------------------------------------
# CFLAGS/LDFLAGS: Set architecture to arm64, point to SDK, and set min iOS version.
# -fPIC is required for building shared libraries/extensions.
export CFLAGS="-arch arm64 -isysroot ${IOS_SDK} -miphoneos-version-min=${MIN_IOS} -fPIC"
export LDFLAGS="-arch arm64 -isysroot ${IOS_SDK} -miphoneos-version-min=${MIN_IOS}"

# ------------------------------------------------------------------------------
# Exports
# ------------------------------------------------------------------------------
# Export variables for use in child scripts.
export JOBS WORKDIR DEPS BUILD STAGE ROOTLESS_PREFIX STAGE_ROOT IOS_SDK HOST_TRIPLE
