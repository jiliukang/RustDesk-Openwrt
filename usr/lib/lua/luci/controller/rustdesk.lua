module("luci.controller.rustdesk", package.seeall)

function index()

        entry({"admin", "services", "rustdesk-server"}, cbi("rustdesk"), _("RustDesk Server"), 100).dependent = false
        entry({"admin", "services", "rustdesk-server", "config"}, cbi("rustdesk")).leaf = true
        entry({"admin", "services", "rustdesk-server", "status"}, call("status")).leaf = true
end

function status()
        local e={}
        e.running=luci.sys.call("pidof hbbs > /dev/null")==0
        e.relay_running=luci.sys.call("pidof hbbr > /dev/null")==0
        luci.http.prepare_content("application/json")
        luci.http.write_json(e)
end
