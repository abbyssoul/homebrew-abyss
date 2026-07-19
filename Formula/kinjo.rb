class Kinjo < Formula
  desc "TUI and command launcher for local network mDNS services"
  homepage "https://github.com/abbyssoul/kinjo"
  # The version embedded in the URLs, and the sha256 fields, are bumped
  # automatically by kinjo's `update-homebrew-tap.yml` release workflow after
  # each tagged release finishes uploading its artifacts. Hand edits to those
  # fields will be overwritten by the next release.
  url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.7/kinjo-0.3.7.tar.gz"
  sha256 "6f5f1fa2e04fd74eeab862ce60665991755f01d877a27e8edc4ef16d2bba90bf" # kinjo-source-sha256
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.7/kinjo-0.3.7-aarch64-apple-darwin.tar.gz"
      sha256 "3cbb0d0672caa08c54f72fd6361b1cdb40076f55bf456a3e3ed12150ac6050b8" # kinjo-macos-arm64-sha256
    end

    on_intel do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.7/kinjo-0.3.7-x86_64-apple-darwin.tar.gz"
      sha256 "2de13fa829a4dc472a7a78d6487d3ab06663e40723e28bbed29bdb4faf335ef6" # kinjo-macos-intel-sha256
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
