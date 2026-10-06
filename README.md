# homebrew-abyss

## How do I install these formulae?

`brew install abbyssoul/abyss/<formula>`

Or `brew tap abbyssoul/abyss` and then `brew install <formula>`.

Or, in a [`brew bundle`](https://github.com/Homebrew/homebrew-bundle) `Brewfile`:

```ruby
tap "abbyssoul/abyss"
brew "<formula>"
```

## Formulae

| Formula | What | Updated by |
|---|---|---|
| `kinjo` | TUI and command launcher for local network mDNS services | [kinjo](https://github.com/abbyssoul/kinjo)'s release workflow, one pull request per release |

The formulae install each project's prebuilt release archives on macOS and
Linux, so installing never needs a compiler or language toolchain. A release's
pull request rewrites the whole formula from a template in the project's
repository; change the template there, since the next release overwrites hand
edits here.

Every pull request runs `brew test-bot`, which audits, installs and tests the
changed formulae on macOS (Apple silicon and Intel) and Linux.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
