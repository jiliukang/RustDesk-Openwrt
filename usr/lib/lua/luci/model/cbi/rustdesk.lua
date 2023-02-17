
local i="rustdesk"

m = Map(i, translate("RustDesk Server Setting"), translate("Configure RustDesk server program."))
m:section(SimpleSection).template="rustdesk/rustdesk_status"

t=m:section(TypedSection,"rustdesk")
t.addremove = false
t.anonymous = true


t:tab("service",translate("Service Settings"))
t:tab("relay",translate("Relay Settings"))
t:tab("log",translate("Client Log"))

enable = t:taboption("service", Flag, "enabled", translate("Enable server"))
enable.rmempty=false

port = t:taboption("service", Value, "server_port", translate("Port"))
port.datatype = "range(1,65535)"
port.default = 21116
port.rmempty = false
port.description = translate("Sets the listening port")

key = t:taboption("service",Value, "server_key", translate("key"))
key.datatype = "string"
key.description = translate("Only allow the client with the same key")


relay_server = t:taboption("service",Value, "server_relay-servers", translate("Relay servers"))
relay_server.datatype = "string"
relay_server.description = translate("Sets the default relay servers, seperated by colon")

rendezvous_server = t:taboption("service",Value, "server_rendezvous-servers", translate("Rendezvous servers"))
rendezvous_server.datatype = "string"
rendezvous_server.description = translate("Sets rendezvous servers, seperated by colon")

rmem = t:taboption("service",Value, "server_rmem", translate("UDP recv buffer"))
rmem.datatype = "range(0,52428800)"
rmem.description = translate("Sets UDP recv buffer size, set system rmem_max first")

serial = t:taboption("service",Value, "server_serial", translate("Serial"))
serial.default = 0
serial.description = translate("Sets configure update serial number")

software_url = t:taboption("service",Value,"server_software-url", translate("Software url"))
software_url.datatype = "string"
software_url.description = translate("Sets download url of RustDesk software of newest version")

enable = t:taboption("relay", Flag, "enabled_relay", translate("Enable relay"))
enable.rmempty=false
relay_port = t:taboption("relay", Value, "relay_port", translate("Relay Port"))
relay_port.datatype = "range(1,65535)"
relay_port.default = 21117
relay_port.rmempty = false
relay_port.description = translate("Sets the listening port")

relay_key = t:taboption("relay",Value, "relay_key", translate("Relay key"))
relay_key.datatype = "string"
relay_key.description = translate("Only allow the client with the same key")

local pid = luci.util.exec("/usr/bin/pgrep hbbs")
function openvpn_process_status()
  local status = "OpenVPN is not running now "

  if pid ~= "" then
      status = "OpenVPN is running with the PID " .. pid .. ""
  end

  local status = { status=status }
  local table = { pid=status }
  return table
end

function m.on_after_commit(self)
	-- os.execute("uci set firewall.openvpn.dest_port=$(uci get openvpn.myvpn.port) && uci commit firewall &&  /etc/init.d/firewall restart")
	os.execute("/etc/init.d/rustdesk restart")
end

return m
