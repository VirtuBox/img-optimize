# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),

## [Unreleased]

## [V2.0] - 2020-11-10

### Added

- quiet mode
- option --no-run-if-empty added to xargs
- scripts to compile optipng & libwebp from source
- Avif (AV1 Image Format) support
- Avoid optimizing the same image at the same moment [PR #12](https://github.com/VirtuBox/img-optimize/pull/12)

### Changed

- JPG are optimized as progressive JPG
- WebP and Avif newly created images are deleted in case of failure during conversion

## [V1.1] - 2019-04-05

### Added

- Interactive mode with `img-optimize -i`
- check if optipng, jpegoptim or cwebp executable before optimization
- additional install method

### Fixed

- images path replaced by current directory if empty

## [v1.0] - 2019-03-20

- Initial release
