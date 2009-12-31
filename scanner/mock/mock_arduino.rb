#!/usr/bin/ruby

require 'socket'
require 'gtk2'

scan_white = Gtk::Button.new("Scan White")
scan_black = Gtk::Button.new("Scan Black")
scan_blue = Gtk::Button.new("Scan Blue")
scan_vbox = Gtk::VButtonBox.new
scan_vbox.layout_style = Gtk::ButtonBox::START
scan_vbox.spacing = 3
scan_vbox.add(scan_white)
scan_vbox.add(scan_black)
scan_vbox.add(scan_blue)

output = Gtk::TextView.new
def output.append(text)
  self.buffer.text = self.buffer.text + "\n" + text
end
output.editable = false
output.buffer.text = "Hello world."
output.append("hey")

scrolled_win = Gtk::ScrolledWindow.new
#scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)
scrolled_win.add(output)

user_action = Gtk::Button.new("User Action")
user_action.signal_connect("clicked") {
  output.append("user_action")
}
user_vbox = Gtk::VBox.new(false, 3)
user_vbox.pack_start(scrolled_win, true, true, 3)
user_hbutton_box = Gtk::HButtonBox.new
user_hbutton_box.add(user_action)
user_vbox.pack_start(user_hbutton_box, false, false, 3)

window_hbox = Gtk::HBox.new(false, 8)
window_hbox.pack_start(scan_vbox, false, false, 0)
window_hbox.pack_start(user_vbox, true, true , 0)

window = Gtk::Window.new
window.signal_connect("delete_event") { Gtk.main_quit }
window.border_width = 10
window.add(window_hbox)
window.set_size_request(600, 300)
window.resizable = false
window.show_all

Gtk.main

#host, port = "localhost", 7001
#puts "Starting mock arduino.",
     #"Talking to #{host}:#{port}."

#TCPSocket.open(host, port) do |s|
  #cmd = "1 36008B60F7"
  #puts "Sending RFID: #{cmd}"
  #s.puts cmd
#end
