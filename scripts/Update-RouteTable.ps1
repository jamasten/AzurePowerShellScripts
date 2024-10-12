[CmdletBinding()]
param (
    [Parameter()]
    [string]$AzureFirewallPrivateIpAddress,

    [Parameter()]
    [string]$RouteTableName,

    [Parameter()]
    [string]$RouteTableResourceGroupName,

    [Parameter()]
    [string]$VirtualNetworkAddressSpace
    
)

$Configuration = Get-AzRouteTable `
    -ResourceGroupName $RouteTableResourceGroupName `
    -Name $RouteTableName

$Configuration | Remove-AzRouteConfig `
    -Name 'default_route'

$AddressPrefixes = $VirtualNetworkAddressSpace.Split(',')
for ($i = 0; $i -lt $AddressPrefixes.Length; $i++)
{
    $Configuration | Add-AzRouteConfig `
        -Name "SuperNetwork$i" `
        -AddressPrefix $AddressPrefixes[$i] `
        -NextHopType 'VirtualAppliance' `
        -NextHopIpAddress $AzureFirewallPrivateIpAddress
}

Set-AzRouteTable `
    -RouteTable $Configuration