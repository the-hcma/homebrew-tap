class RustyJack < Formula
  desc "Route HDMI audio for volume keys and wake ScalarWebAPI-compatible speakers"
  homepage "https://github.com/the-hcma/rusty-jack"
  url "https://github.com/the-hcma/rusty-jack/archive/refs/tags/rusty-jack-v0.4.1.tar.gz"
  sha256 "e1c575d5a6e156118df9dfb187644f45f760489bb8b77dbaba8773466e0117c4"
  license "MIT"
  head "https://github.com/the-hcma/rusty-jack.git", branch: "main"

  depends_on "rust" => :build
  depends_on macos: :monterey

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "12.0"
    ENV["RUSTY_JACK_GIT_COMMIT"] = "9dc370e"
    system "cargo", "install", *std_cargo_args
    system "make", "driver-bundle"
    pkgshare.install "config.example.json", "config.example.scalar-webapi-device.json", "launchd"
    pkgshare.install "target/share/rusty-jack/RustyJack.driver"
  end

  def uninstall
    safe_system bin/"rusty-jack", "disable", "--json"
  end

  def caveats
    <<~EOS
      After installing the formula, set up config and the per-user LaunchAgent:
        rusty-jack install

      Check routing, daemon state, activity polling, and log path:
        rusty-jack status

      Daemon logs: ~/Library/Logs/rusty-jack.log (one file; rotated by the app).
      After upgrading from older releases, refresh the LaunchAgent once:
        rusty-jack upgrade --force

      Each macOS user who wants auto-routing should run `rusty-jack install`
      in their own account (Homebrew is shared; the LaunchAgent is per-user).

      Before uninstalling the formula, stop and remove the LaunchAgent:
        rusty-jack uninstall --keep-config

      To remove the default config too:
        rusty-jack uninstall --remove-config
    EOS
  end

  test do
    assert_match "rusty-jack", shell_output("#{bin}/rusty-jack --help")
  end
end
