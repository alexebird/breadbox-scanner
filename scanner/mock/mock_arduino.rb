#!/usr/bin/ruby -w

require 'socket'
require 'gtk2'
require '../../scan_server/lib/scan_server/request'
require '../../scan_server/lib/scan_server/locations'

class Scanner
  def initialize(textbuf)
    @scanner_id = 1
    @host, @port = "192.168.1.29", 5000
    @output = textbuf
  end

  def send_scan_request(rfid)
    send_request(ScanServer::Request::SCAN, rfid, ScanServer::Locations::FRIDGE)
  end

  def send_inventory_request
    send_request(ScanServer::Request::INVENTORY)
  end

  def server_to_s
    "Scan server: #@host:#@port"
  end

  private

  def send_request(type, *body)
    resp = ''
    body = body.join ' '
    request = "%d %d %s" % [type, @scanner_id, body]
    begin
      TCPSocket.open(@host, @port) do |s|
        @output.puts "Request: type=#{type} body=#{body}"
        s.puts(request)
        resp_type = s.read(2)
        @output.puts "Response: type=#{resp_type} body:"
        while line = s.gets
          resp << line
        end
      end
    rescue Exception => e
      @output.puts e.message
    end

    @output.print resp unless resp.empty?
  end
end

scan_white = Gtk::Button.new("Scan _Lettuce", true)
scan_black = Gtk::Button.new("Scan _Orange", true)
scan_blue = Gtk::Button.new("Scan _Milk", true)
scan_vbox = Gtk::VButtonBox.new
scan_vbox.layout_style = Gtk::ButtonBox::START
scan_vbox.spacing = 3
scan_vbox.add(scan_white)
scan_vbox.add(scan_black)
scan_vbox.add(scan_blue)

server_label = Gtk::Label.new

output = Gtk::TextView.new
output.modify_font(Pango::FontDescription.new("Monospace 12"))
class << output
  def print(text)
    self.buffer.insert(self.buffer.end_iter, text)
    self.scroll_to_mark(self.buffer.create_mark(nil, self.buffer.end_iter, true), 0.0, false, 0.0, 1.0)
  end
  
  def puts(text)
    print(text + "\n")
  end
end

output.editable = false

scanner = Scanner.new(output)
server_label.text = scanner.server_to_s

scrolled_win = Gtk::ScrolledWindow.new
scrolled_win.shadow_type = Gtk::SHADOW_IN
scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
scrolled_win.add(output)

user_action = Gtk::Button.new("_User Action", true)
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
window.set_size_request(700, 500)
window.resizable = false
window.show_all

user_action.signal_connect("clicked") {
  scanner.send_inventory_request
}
scan_white.signal_connect("clicked") {
  scanner.send_scan_request '36008B60F7'
}
scan_black.signal_connect("clicked") {
  scanner.send_scan_request '0415ED52CF'
}
scan_blue.signal_connect("clicked") {
  scanner.send_scan_request '17007E24F3'
}

Gtk.main
