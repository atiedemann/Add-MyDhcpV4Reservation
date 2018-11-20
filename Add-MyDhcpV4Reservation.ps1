function Add-MyDHCPv4Reservation
{
<#
.SYNOPSIS
This Cmdlet add an dhcp reservation on both dhcp servers

.DESCRIPTION
This Cmdlet add an dhcp reservation on both dhcp servers

.PARAMETER ScopeID
Defines the DHCP Scope where you want to add the reservation

.PARAMETER IPv4Address
Defines the IP v4 Address for the new DHCP reservation

.PARAMETER MACAddress
Defines the MAC Address for the new reservation

Format:
001122334455
00:11:22:33:44:55
00-11-22-33-44-55

.EXAMPLE
Add-MyDHCPv4Reservation -ScopeID 10.10.10.0 -IPv4Address 10.10.10.4 -MACAddress 005056b02066 -Name Server1

#>
    Param(
        [Parameter(Mandatory=$true)]
        [STRING]$ScopeID,

        [Parameter(Mandatory=$true)]
        [STRING]$IPv4Address,

        [Parameter(Mandatory=$true)]
        [STRING]$MACAddress,

        [Parameter(Mandatory=$true)]
        [STRING]$Name
    )

    # Define Server Addresses
    $Server = @('Server1','Server2')

    # Convrtz MAC Address
    if ($MACAddress.Length -eq 12 -and $MACAddress -notmatch ':' -and $MACAddress -notmatch '-') {
        $MACAddress = $MACAddress -replace "([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])([0-9A-Fa-f])", '$1$2-$3$4-$5$6-$7$8-$9$10-$11$12'
    }

    if ($MACAddress -match ':') {
        $MACAddress = $MACAddress -replace(':','-')
    }


    foreach($S in $Server) {
        $Reservation = $false
        # Get reservation from Server
        $Reservation = Get-DhcpServerv4Reservation -ScopeId $ScopeID -ComputerName $S -ErrorAction SilentlyContinue | ? { $_.IPAddress -eq $IPv4Address -or $_.ClientID -eq $MACAddress }

        if ($Reservation) {
            Write-Host ('Reservation exists on Server {2}: IPv4Address ({0}) and MAC ({1})' -f $IPv4Address, $MACAddress, $S)
        } else {
            Add-DhcpServerv4Reservation -ComputerName $S -ScopeId $ScopeID -IPAddress $IPv4Address -ClientId $MACAddress -Name $Name -Type Both
            Set-DhcpServerv4DnsSetting -ComputerName $S -ScopeId $ScopeID -IPAddress $IPv4Address -UpdateDnsRRForOlderClients:$true -DynamicUpdates Always -DeleteDnsRROnLeaseExpiry:$false

            if ($?) {
                Write-Host ('Reservation added on Server {2}: IPv4Address ({0}) and MAC ({1})' -f $IPv4Address, $MACAddress, $S)
            }
        }
    }
}
