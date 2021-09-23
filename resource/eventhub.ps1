
function CreateEventHubIfNotExists () {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)][hashtable]$map  
  )

  $namespace = ("spark-{0}-{1}" -f $geoStamp, $map.name)
  $rgname = GetGroupName -groupname $map.groupname

  CreateResourceGroupIfNotExists -groupname $rgname

  if (-Not $Global:debug) {
    $resourceExists = (isResourceExists $namespace $rgname $Tags.eventhub)
    if (-Not $resourceExists) {

      $provision_eventhub = New-AzEventHub -ResourceGroupName $rgname -Name $namespace -MessageRetentionInDays 7 -PartitionCount 512
                
      logVerbose ("Successfully Provisioned EventHub : {0}" -f $provision_eventhub.Name)
    }
    else {
      logVerbose ("Event Hub already exists: $namespace")
    }
  }
  else {
    logVerbose "Successfully Provisioned EventHub in debug mode: $namespace"        
  }
}