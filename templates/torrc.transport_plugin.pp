# transport plugin
<% if @servertransport_plugin != '' -%>
ServerTransportPlugin <%= @servertransport_plugin %>
<% end -%>
<% if @servertransport_listenaddr != '' -%>
ServerTransportListenAddr <%= @servertransport_listenaddr %>
<% end -%>
<% if @servertransport_options != '' -%>
ServerTransportOptions <%= @servertransport_options %>
<% end -%>
<% if @ext_port != '' -%>
ExtORPort <%= @ext_port %>
<% end -%>
