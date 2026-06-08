sed \
	  -e 's|@ARCHIVE_URL@|https://github.com/the-hcma/rusty-jack/archive/refs/tags/rusty-jack-v0.2.0.tar.gz|g' \
	  -e 's|@ARCHIVE_SHA256@|3877edd03b617f8f151fcadef9a9e5df190852199dfc8e1101f1bb30711d3379|g' \
	  'packaging/homebrew/rusty-jack.formula.in'
class RustyJack < Formula
  desc "Route HDMI audio for volume keys and wake ScalarWebAPI-compatible speakers"
  homepage "https://github.com/the-hcma/rusty-jack"
  url "https://github.com/the-hcma/rusty-jack/archive/refs/tags/rusty-jack-v0.2.0.tar.gz"
  sha256 "3877edd03b617f8f151fcadef9a9e5df190852199dfc8e1101f1bb30711d3379"
  license "MIT"
  head "https://github.com/the-hcma/rusty-jack.git", branch: "main"

  depends_on "rust" => :build
  depends_on macos: :monterey

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "12.0"
    system "cargo", "install", *std_cargo_args, "--locked"
    system "make", "driver-bundle"
    pkgshare.install "config.example.json", "config.example.scalar-webapi-device.json", "launchd"
    pkgshare.install "target/share/rusty-jack/RustyJack.driver"
  end

  def uninstall
    safe_system bin/"rusty-jack", "disable", "--json"
  end

  def caveats
    <<~EOS
      To create config and install the per-user LaunchAgent:
        rusty-jack install

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
