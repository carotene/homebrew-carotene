# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Carotene < Formula
  desc "Real Time Server"
  homepage "http://carotene-project.com"
  url "http://carotene-project.com/releases/carotene-0.2.2.tar.gz"
  version "0.2.2"
  sha256 "44020312b97c7a3add3f59c99c98d51186c5cc7d5f9a71d7ceca9c1a40e7064d"

  def install
      prefix.install Dir['*']

      sbin.mkpath
      mv prefix/"carotene/sbin/carotene", sbin/"carotene"
      inreplace sbin/'carotene' do |s|
          s.gsub! 'RELEASE_ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"', "RELEASE_ROOT_DIR=\"#{prefix}\"/carotene"
          s.gsub! 'CONFIG_HOME="$RELEASE_ROOT_DIR/etc"', "CONFIG_HOME=\"#{etc}/carotene\""
      end

      (etc/"carotene").mkpath
      etc.install prefix+'carotene/etc/carotene.config' => 'carotene/carotene.config' unless File.exists? etc+'carotene/carotene.config'
      etc.install prefix+'carotene/etc/vm.args' => 'carotene/vm.args' unless File.exists? etc+'carotene/vm.args'
  end

  plist_options :startup => "true", :manual => "carotene start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/carotene</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test carotene`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
