class Awake < Formula
  desc "Cleanly see (and act on) what is keeping your Mac awake"
  homepage "https://github.com/grigarr/awake"
  url "https://github.com/grigarr/awake/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "742b928cc22e14860eed2d90fa92f28da1b5718c38bba827e19432a242f8c7bc"
  license "MIT"
  head "https://github.com/grigarr/awake.git", branch: "main"

  depends_on :macos

  def install
    bin.install "awake.sh" => "awake"
    bin.install "awake-night.sh" => "awake-night"
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"awake-night"]
    run_type :cron
    cron "0 3 * * *"
    environment_variables FORCE_SLEEP: "0",
                          AWAKE_LOG: "#{var}/log/awake.log",
                          PATH: "/usr/bin:/bin:/usr/sbin:/sbin"
    log_path "#{var}/log/awake.log"
    error_log_path "#{var}/log/awake.log"
  end

  def caveats
    <<~EOS
      To run the nightly 03:00 check via launchd:
        brew services start awake

      By default it only logs + notifies (FORCE_SLEEP=0); it will NOT sleep your
      Mac. Logs: #{var}/log/awake.log

      To make it force sleep when something is still keeping the Mac awake,
      start the service with:
        FORCE_SLEEP=1 brew services start awake
    EOS
  end

  test do
    assert_match "awake", shell_output("#{bin}/awake --help")
  end
end
