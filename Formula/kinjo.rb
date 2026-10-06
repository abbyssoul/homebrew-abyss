class Kinjo < Formula
  desc "TUI and command launcher for local network mDNS services"
  homepage "https://github.com/abbyssoul/kinjo"
  # The version embedded in the URLs, and the sha256 fields, are bumped
  # automatically by kinjo's `update-homebrew-tap.yml` release workflow after
  # each tagged release finishes uploading its artifacts. Hand edits to those
  # fields will be overwritten by the next release.
  url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.9/kinjo-0.3.9.tar.gz"
  sha256 "28e88f00e3ab061d8a1078f2ed00115bf14a2cd84ec31440a739a0203ac90e59" # kinjo-source-sha256
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.9/kinjo-0.3.9-aarch64-apple-darwin.tar.gz"
      sha256 "708f9a7356f72d0cfdf759972a8d5d5eb4a273813a2d80eb0c0e140a9f35cc2c" # kinjo-macos-arm64-sha256
    end

    on_intel do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.9/kinjo-0.3.9-x86_64-apple-darwin.tar.gz"
      sha256 "f3b6e4a64f6425f6af1ca2af827854c8123c5656f278d0c45e595b7d69c9d5cb" # kinjo-macos-intel-sha256
    end
  end

  on_linux do
    depends_on "rust" => :build
  end

  # kinjo discovers commands in `share/kinjo/commands` relative to its own
  # binary, so installing into pkgshare/"commands" makes the bundled defaults
  # work out of the box — no post-install copying.
  def install
    if OS.mac?
      bin.install "kinjo"
      (pkgshare/"commands").install Dir["commands/*.toml"]
    else
      system "cargo", "install", *std_cargo_args
      (pkgshare/"commands").install Dir["actions/*.toml"]
    end
  end

  def caveats
    <<~EOS
      Default command definitions were installed to:
        #{opt_pkgshare}/commands

      kinjo discovers them there automatically. To customize a command, copy
      it to ~/.config/kinjo/commands (or $XDG_CONFIG_HOME/kinjo/commands) and
      edit it; a user command with the same name overrides the bundled one.
    EOS
  end

  test do
    # `ssh` is one of the bundled defaults; seeing it proves the binary
    # discovered the commands installed under pkgshare.
    assert_match "ssh", shell_output("#{bin}/kinjo list-commands")
  end
end
