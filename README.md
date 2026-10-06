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

A release's pull request rewrites the formula's URLs and `sha256` fields; hand
edits to those fields are overwritten by the next release.

Every pull request runs `brew test-bot`, which audits, installs and tests the
changed formulae on macOS (Apple silicon and Intel) and Linux.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
