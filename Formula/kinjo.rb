class Kinjo < Formula
  desc "TUI and command launcher for local network mDNS services"
  homepage "https://github.com/abbyssoul/kinjo"
  # The version embedded in the URLs, and the sha256 fields, are bumped
  # automatically by kinjo's `update-homebrew-tap.yml` release workflow after
  # each tagged release finishes uploading its artifacts. Hand edits to those
  # fields will be overwritten by the next release.
  url "https://github.com/abbyssoul/kinjo/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "bda2f88476d086c1263e657c7534c8d42c8fe959d2e0afffa57625b4607a2967" # kinjo-source-sha256
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.1.6/kinjo-0.1.6-aarch64-apple-darwin.tar.gz"
      sha256 "441de60b05b0062b6fd7ee09dda642f069c0f425540742a2f1c462051360db2f" # kinjo-macos-arm64-sha256
    end

    on_intel do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.1.6/kinjo-0.1.6-x86_64-apple-darwin.tar.gz"
      sha256 "076d11c88a09a54e56557b3a48ecd693dde8d776720257b668fc1102f2c7b576" # kinjo-macos-intel-sha256
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
