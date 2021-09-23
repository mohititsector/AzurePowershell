<#
Creates Redis Cache 
#>
function CreateRedisIfNotExists {
  param(
    [Parameter(Mandatory = $true)][hashtable]$map
  )

  $namespace = $map.name + $geoStamp
  $rgname = GetGroupName -groupname $map.groupname

  CreateResourceGroupIfNotExists -groupname $rgname

  if (-Not $Global:debug) {
    $resourceExists = (isResourceExists -namespace $namespace -verifytag $Tags.redis -verifyrg $rgname)
    if (-Not $resourceExists) {

      $provision = New-AzRedisCache -ResourceGroupName $rgname `
        -Name $namespace `
        -Location $geoLocation `
        -Size $map.size `
        -Sku $map.sku `
        -ShardCount $map.SharedCount `
        -ev error `
        -ea Continue

      $resourceName = $provision.Name
      logVerbose ("Started provisioning a redis cache : $resourceName")
      if ($error) {
        Write-Error "Error Occurred while provisioning : "$error
      }
      else {
        waitForRedisComplete -resourceName $resourceName -resourceGroupName $rgname
      }
    } 
    else {
      logVerbose ("Redis Cache already exists: $namespace")
    }        
  }
  else { 
    logVerbose ("Provisioned Redis in debug mode: $namespace")
  }
}

function waitForRedisComplete($resourceName, $resourceGroupName) {
  try {
    $GetResourceInstance = Get-AzRedisCache -Name $resourceName -ResourceGroupName $resourceGroupName
    $state = $GetResourceInstance.ProvisioningState
    Write-Verbose "Provisioning State : $state" -Verbose
    if ($state -ne 'Failed') {
      Do {
        $success = $false
        if ($state -eq 'Succeeded') {
          $success = $true
          storeRedisConnectionString -resourceName $resourceName -rgname $resourceGroupName -instance $GetResourceInstance
          logVerbose ("The resource is successfully provisioned and ready to use. Resource : $resourceName")
        }
        else {
          Write-Verbose "The resource is still provisioning, please wait and an update will be provided in 2 minutes.." -Verbose
          Start-Sleep -Seconds 120
          $GetResourceInstance = Get-AzRedisCache -Name $resourceName -ResourceGroupName $resourceGroupName
          $state = $GetResourceInstance.ProvisioningState
        }
      } While (-Not $success)
    }
    else {
      logVerbose ("Failed to provision the resource")
    }
  }
  catch {
    Write-Error $_
  }
}


function storeRedisConnectionString($resourceName, $rgname, $instance) {
  $ConnectionString = Get-AzRedisCacheKey -ResourceGroupName $rgname -Name $resourceName
  $endpoint = $instance.HostName + ":" + $instance.SslPort + ",password=" + $ConnectionString.PrimaryKey + ",ssl=True,abortConnect=False"
  $connectionName = GetName -name $resourceName -kvId "Redis"
  storeKeyVault -name $connectionName -connectionString $endpoint
}
