# transport plugin
<% if @servertransport_plugin != '' -%>
ServerTransportPlugin <%= @servertransport_plugin %>
<% if @servertransport_listenaddr != '' -%>
ServerTransportListenAddr <%= @servertransport_listenaddr %>
<% if @servertransport_options != '' -%>
ServerTransportOptions <%= @servertransport_options %>
<% if @ext_port != '' -%>
ExtORPort <%= @ext_port %>
<% end -%>
