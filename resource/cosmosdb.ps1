<#
Creates Cosmos DB Account 
#>
function CreateCosmosDbIfNotExists {
  param(
    [Parameter(Mandatory = $true)][hashtable]$map
  )

  $accountname = $map.accountname + $geoStamp
  $rgname = GetGroupName -groupname $map.groupname

  CreateResourceGroupIfNotExists -groupname $rgname
  logVerbose ("Checking for Cosmos account : $accountname")
  $resourceExists = (isResourceExists -namespace $accountname -verifytag $Tags.cosmosdbaccount -verifyrg $rgname)
  if (-Not $resourceExists) {
    logVerbose ("Started provisioning a Cosmos Db account : $accountname")
    $provision = New-AzCosmosDBAccount -ResourceGroupName $rgname `
        -Name $accountname `
        -Location @($geoLocation, $azRegionalPair[$geoLocation]) `
        -EnableAutomaticFailover `
        -DefaultConsistencyLevel Strong `
        -ev error `
        -ea Continue

    $resourceName = $provision.Name
    
    if ($error) {
      Write-Error "Error Occurred while provisioning : "$error
    }
    else {
      waitForCosmosDbAccountComplete -resourceGroupName $rgname -accountName $resourceName 
    }
  } 
  else {
    logVerbose ("Cosmos account already exists: $accountname")
  }

  $dbname = $map.dbname
  logVerbose ("Checking for Cosmos SQL DB : $dbname")
  $resourceExists = (isResourceExists -namespace $dbname -verifytag $Tags.cosmosdbsqldb -verifyrg $rgname -verifyServer $accountname)
  if (-Not $resourceExists) {
    logVerbose ("Started provisioning a Cosmos Db SQL DB : $dbname")
    $provision = New-AzCosmosDBSqlDatabase -ResourceGroupName $rgname `
        -AccountName $accountname `
        -Name $dbname `
        -ev error `
        -ea Continue

    $resourceName = $provision.Name    
    if ($error) {
      Write-Error "Error Occurred while provisioning : "$error
    }
    else {
      logVerbose ("Waiting for two minutes to ensure provisiong of $resourceName is complete... ")          
      Start-Sleep -Seconds 120
    }
  } 
  else {
    logVerbose ("Cosmos SQLDB already exists: $dbname")
  }

  if (-Not $containerThroughput) 
  {
    logVerbose "No throughput specified for the container. You might want to change it later..."
    $containerThroughput = 400
  }
  else
  {
    logVerbose "Creating containers with throughput set to $($containerThroughput)."
  }

  $alecontname = $map.alecontname
  logVerbose ("Checking for ALE container : $alecontname")
  $resourceExists = (isResourceExists -namespace $alecontname -verifytag $Tags.cosmosdbsqlcontainer -verifyrg $rgname -verifyServer $accountname -verifyDbName $dbname)
  if (-Not $resourceExists) 
  {
    logVerbose ("Started provisioning a Cosmos Db SQL container : $alecontname")
    $provision = New-AzCosmosDBSqlContainer -ResourceGroupName $rgname `
        -AccountName $accountname `
        -DatabaseName $dbname `
        -Name $alecontname `
        -PartitionKeyKind Hash `
        -PartitionKeyPath /id `
        -Throughput $containerThroughput `
        -TtlInSeconds -1 `
        -ev error `
        -ea Continue

    $resourceName = $provision.Name    
    if ($error) 
    {
      Write-Error "Error Occurred while provisioning : "$error
    }
    else 
    {
      logVerbose ("Waiting for two minutes to ensure provisiong of $resourceName is complete... ")          
      Start-Sleep -Seconds 120
    }
  } 
  else 
  {
    logVerbose ("Cosmos SQL container already exists: $alecontname")
  }

  $keyscontname = $map.keyscontname
  logVerbose ("Checking for ALE container : $keyscontname")
  $resourceExists = (isResourceExists -namespace $keyscontname -verifytag $Tags.cosmosdbsqlcontainer -verifyrg $rgname -verifyServer $accountname -verifyDbName $dbname)
  if (-Not $resourceExists) 
  {
    logVerbose ("Started provisioning a Cosmos Db SQL container : $keyscontname")
    $provision = New-AzCosmosDBSqlContainer -ResourceGroupName $rgname `
        -AccountName $accountname `
        -DatabaseName $dbname `
        -Name $keyscontname `
        -PartitionKeyKind Hash `
        -PartitionKeyPath /id `
        -Throughput $containerThroughput `
        -TtlInSeconds -1 `
        -ev error `
        -ea Continue

    $resourceName = $provision.Name
    if ($error) 
    {
      Write-Error "Error Occurred while provisioning : "$error
    }
    else 
    {
      logVerbose ("Waiting for two minutes to ensure provisiong of $resourceName is complete... ")          
      Start-Sleep -Seconds 120
    }
  } 
  else 
  {
    logVerbose ("Cosmos SQL container already exists: $keyscontname")
  }

 }
 
 function waitForCosmosDbAccountComplete($resourceGroupName, $accountName) {
  try {

    $resourceName = $accountName
    $GetResourceInstance = Get-AzCosmosDBAccount -Name $accountName -ResourceGroupName $resourceGroupName

    $state = $GetResourceInstance.ProvisioningState
    logVerbose ("Provisioning State : $state")
    if ($state -ne 'Failed') 
    {
      Do 
      {
        $success = $false
        if ($state -eq 'Succeeded') 
        {
          $success = $true          
          logVerbose ("The resource is successfully provisioned and ready to use. Resource : $resourceName")
        }
        else 
        {          
          logVerbose ("The resource is still provisioning, please wait and an update will be provided in 2 minutes.. ")
          
          Start-Sleep -Seconds 120
          $GetResourceInstance = Get-AzCosmosDBAccount -Name $accountName -ResourceGroupName $resourceGroupName          
          $state = $GetResourceInstance.ProvisioningState
        }
      } While (-Not $success)
    }
    else 
    {
      logVerbose ("Failed to provision the resource")
    }
  }
  catch 
  {
    Write-Error $_
  }
}