# Add-MyDhcpV4Reservation
Add DHCP reservation to more that one server with one PowerShell line

## Description
This Cmdlet add an dhcp reservation on both dhcp servers

## PARAMETER ScopeID
Defines the DHCP Scope where you want to add the reservation

## PARAMETER IPv4Address
Defines the IP v4 Address for the new DHCP reservation

## PARAMETER MACAddress
Defines the MAC Address for the new reservation

Format:
001122334455
00:11:22:33:44:55
00-11-22-33-44-55

### EXAMPLE
Add-MyDHCPv4Reservation -ScopeID 10.10.10.0 -IPv4Address 10.10.10.4 -MACAddress 005056b02066 -Name Server1
