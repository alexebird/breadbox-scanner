#!/usr/bin/ruby

require 'socket'
require 'gtk2'

class Scanner
  def initialize(textbuf)
    @user_id = 1
    @host, @port = "localhost", 7001
    @output = textbuf
  end

  def send_scan(rfid)
    cmd = "#@user_id #{rfid}"
    begin
      TCPSocket.open(@host, @port) do |s|
        @output.append "Sending: #{cmd}"
        s.puts cmd
        resp = ""
        while line = s.gets
          resp << line
        end
        @output.append resp
      end
    rescue Exception => e
      @output.append e
    end
  end

  def server_to_s
     "Scan server: #@host:#@port"
  end
end

scan_white = Gtk::Button.new("Scan Lettuce")
scan_black = Gtk::Button.new("Scan Orange")
scan_blue = Gtk::Button.new("Scan Milk")
scan_vbox = Gtk::VButtonBox.new
scan_vbox.layout_style = Gtk::ButtonBox::START
scan_vbox.spacing = 3
scan_vbox.add(scan_white)
scan_vbox.add(scan_black)
scan_vbox.add(scan_blue)

server_label = Gtk::Label.new

output = Gtk::TextView.new
def output.append(text)
  self.buffer.text = self.buffer.text + text + "\n"
end
output.editable = false

scanner = Scanner.new(output)
server_label.text = scanner.server_to_s

scrolled_win = Gtk::ScrolledWindow.new
scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
scrolled_win.add(output)

user_action = Gtk::Button.new("User Action")
user_vbox = Gtk::VBox.new(false, 3)
user_vbox.pack_start(server_label, false, false, 0)
user_vbox.pack_start(scrolled_win, true, true, 3)
user_hbutton_box = Gtk::HButtonBox.new
user_hbutton_box.add(user_action)
user_vbox.pack_start(user_hbutton_box, false, false, 3)

window_hbox = Gtk::HBox.new(false, 8)
window_hbox.pack_start(scan_vbox, false, false, 0)
window_hbox.pack_start(user_vbox, true, true , 0)

window = Gtk::Window.new("Scanner")
window.signal_connect("delete_event") { Gtk.main_quit }
window.border_width = 10
window.add(window_hbox)
window.set_size_request(600, 300)
window.resizable = false
window.show_all

user_action.signal_connect("clicked") {
  output.append("user_action")
}
scan_white.signal_connect("clicked") {
  scanner.send_scan '36008B60F7'
}
scan_black.signal_connect("clicked") {
  scanner.send_scan '0415ED52CF'
}
scan_blue.signal_connect("clicked") {
  scanner.send_scan '17007E24F3'
}

Gtk.main
