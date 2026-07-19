class Kinjo < Formula
  desc "TUI and command launcher for local network mDNS services"
  homepage "https://github.com/abbyssoul/kinjo"
  # The version embedded in the URLs, and the sha256 fields, are bumped
  # automatically by kinjo's `update-homebrew-tap.yml` release workflow after
  # each tagged release finishes uploading its artifacts. Hand edits to those
  # fields will be overwritten by the next release.
  url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.6/kinjo-0.3.6.tar.gz"
  sha256 "128ca609451c70986995c76a59671f12f34bd5086d361d181d95104364c4ccc7" # kinjo-source-sha256
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.6/kinjo-0.3.6-aarch64-apple-darwin.tar.gz"
      sha256 "3f8382699f360c87204df8d8aabad0d1db21eaedbdc179177db0e77d6cdd529c" # kinjo-macos-arm64-sha256
    end

    on_intel do
      url "https://github.com/abbyssoul/kinjo/releases/download/v0.3.6/kinjo-0.3.6-x86_64-apple-darwin.tar.gz"
      sha256 "04e52879fb81f804f634d7e4a457b0f7968a398093ffbab5f0c12050f7cecf3d" # kinjo-macos-intel-sha256
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
