# Changelog

## Unreleased

### Added

- Add .gitattributes file

### Changed

- Replace the ✅/❌ emoji by the plain marks ✓/✗ so the status line has a
predictable width and can carry a color
- Color the status mark: `✓` is wrapped in `cSuccess`, `✗` in `cError`. The
message stays neutral. The new `colorize` constructor flag turns it off.
- Make status less offensive. Replace emojis.

## 1.1.4 - 2024-04-13

### Removed

- dependency to gg_install_gg, remove ./check script
- dependency pana

## 1.1.3 - 2024-04-11

### Changed

- upgrade dependencies

## 1.1.2 - 2024-04-09

### Removed

- 'Pipline: Disable cache'

## 1.1.1 - 2024-04-09

### Changed

- Rework changelog
- 'Github Actions Pipeline'
- 'Github Actions Pipeline: Add SDK file containing flutter into .github/workflows to make github installing flutter and not dart SDK'

## 1.1.0 - 2024-01-01

- Add `logStatus()` to log a status directly.

## 1.0.8 - 2024-01-01

- Add `GgLog`

## 1.0.7 - 2024-01-01

- Initial version.
