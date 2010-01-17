class ScanController < Controller
  layout :secure
  helper :scan_helper

  def index
    @user = session_user
    @scans = []
    @user.scanners.each do |scanner|
      scanner.scans.each {|scan| @scans << scan}
    end
  end
end
