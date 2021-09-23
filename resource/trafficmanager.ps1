<#
Creates Traffic Manager
#>
function CreateTrafficManagerIfNotExists() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)][hashtable]$map  
  )

  if ($map.name.contains('disp')) {
    $namespace = GetDispatcherTrafficManagerName -name $map.name -geo $geoStamp
    $dnsName = GetDispatcherTrafficManagerDNS -name $map.name -geo $geoStamp
  }
  else {
    $namespace = $map.name + ($geoStamp -replace '00', '0')
    $dnsName = $namespace
  }
  $rgname = GetGroupName -groupname $map.groupname

  CreateResourceGroupIfNotExists -groupname $rgname

  if (-Not $Global:debug) {
    $resourceExists = (isResourceExists $namespace $rgname $Tags.trafficManager)
    if (-Not $resourceExists) {

      $provision_trafficManager = New-AzTrafficManagerProfile -Name $namespace `
        -ResourceGroupName $rgname `
        -RelativeDnsName $dnsName `
        -ProfileStatus "Enabled" `
        -TrafficRoutingMethod "Weighted" `
        -TTL 30 `
        -MonitorPath "/page/ping.aspx" `
        -MonitorProtocol HTTPS `
        -MonitorPort 443 `
                
      logVerbose ("Successfully Provisioned TrafficManager : {0}" -f $provision_trafficManager.Name)
    }
    else {
      logVerbose ("Traffic Manager already exists: $namespace")
    }
  }
  else {
    logVerbose "Successfully Provisioned TrafficManager in debug mode: $namespace"        
  }
}


function GetDispatcherTrafficManagerDNS() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)][string]$name,
    [Parameter(Mandatory = $true)][string]$geo 
  )
  $dnsName = $name + ($geo -replace '00', '0')
  if ($env -eq 'l4' -or $env -eq 'gcch') {
    return ("{0}.{1}" -f $dnsName, "l4.dispatcher")
  } elseif ($env -eq 'l5' -or $env -eq 'gccdod') {
    return ("{0}.{1}" -f $dnsName, "l5.dispatcher")
  } else {
    return ("{0}.{1}" -f $dnsName, "dispatcher.auditing")
  }
}

function GetDispatcherTrafficManagerName() {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true)][string]$name,
    [Parameter(Mandatory = $true)][string]$geo  
  )
  $dnsName = $name + ($geo -replace '00', '0')
  if ($env -eq 'l4' -or $env -eq 'gcch') {
    return ("{0}-{1}" -f $dnsName, "l4-dispatcher")
  } elseif ($env -eq 'l5' -or $env -eq 'gccdod') {
    return ("{0}-{1}" -f $dnsName, "l5-dispatcher")
  } else {
    return ("{0}-{1}" -f $dnsName, "dispatcher-auditing")
  }
}