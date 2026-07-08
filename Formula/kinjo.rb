class Kinjo < Formula
  desc "mDNS TUI and command launcher for local network services"
  homepage "https://github.com/abbyssoul/kinjo"
  license "MIT"

  # `version`, and the sha256 below, are bumped automatically by kinjo's
  # `update-homebrew-tap.yml` release workflow after each tagged release
  # finishes uploading its artifacts. Hand edits to those fields will be
  # overwritten by the next release.
  version "0.1.0"

  on_macos do
    on_arm do
      url "https://github.com/abbyssoul/kinjo/releases/download/v#{version}/kinjo-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000" # kinjo-macos-arm64-sha256
    end

    on_intel do
      url "https://github.com/abbyssoul/kinjo/releases/download/v#{version}/kinjo-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "0000000000000000000000000000000000000000000000000000000000000000" # kinjo-macos-intel-sha256
    end
  end

  on_linux do
    url "https://github.com/abbyssoul/kinjo/archive/refs/tags/v#{version}.tar.gz"
    sha256 "1e2093e1ce58c600e652ac0963736569fda1a091f29aed2fb26d0eff7f062945" # kinjo-source-sha256

    depends_on "rust" => :build
  end

  def install
    if OS.mac?
      bin.install "kinjo"
      pkgshare.install Dir["commands/*.toml"]
    else
      system "cargo", "install", *std_cargo_args
      pkgshare.install Dir["actions/*.toml"]
    end
  end

  def caveats
    <<~EOS
      Sample command definitions were installed to:
        #{opt_pkgshare}

      kinjo loads user commands from ~/.config/kinjo/commands (or
      $XDG_CONFIG_HOME/kinjo/commands). Copy the ones you want to use:
        mkdir -p ~/.config/kinjo/commands
        cp #{opt_pkgshare}/*.toml ~/.config/kinjo/commands/
    EOS
  end

  test do
    assert_match "NAME", shell_output("#{bin}/kinjo list-commands")
  end
end
