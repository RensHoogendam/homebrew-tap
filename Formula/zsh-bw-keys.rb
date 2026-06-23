class ZshBwKeys < Formula
  desc "Lazy Bitwarden secret injection for zsh environment variables"
  homepage "https://github.com/RensHoogendam/zsh-bw-keys"
  url "https://github.com/RensHoogendam/zsh-bw-keys/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "fce59a4038d6de1d2a93aca6685f93f35bc7a54a1c41a64e4a441e3332296446"
  license "MIT"

  depends_on "bitwarden-cli"

  def install
    pkgshare.install "zsh-bw-keys.plugin.zsh"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      To activate zsh-bw-keys, add this line to your ~/.zshrc:
        source "#{opt_pkgshare}/zsh-bw-keys.plugin.zsh"

      Then register your secrets, e.g.:
        bw-key-register GITHUB_TOKEN github-pat npm pnpm bun yarn
    EOS
  end

  test do
    assert_path_exists pkgshare/"zsh-bw-keys.plugin.zsh"
    # The plugin must source cleanly and expose its public function.
    output = shell_output(
      "/bin/zsh -fc 'source #{pkgshare}/zsh-bw-keys.plugin.zsh; " \
      "(( $+functions[bw-key-register] )) && echo ok'",
    )
    assert_match "ok", output
  end
end
