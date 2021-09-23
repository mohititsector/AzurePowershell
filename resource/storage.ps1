<#
Creates Storage account and a container. 
#>
function CreateStorageIfNotExists {
    param(
        [Parameter(Mandatory = $true)][hashtable]$map
    )

    $name = $map.name + $geoStamp
    $count = $map.instances
    $rgname = GetGroupName -groupname $map.groupname

    CreateResourceGroupIfNotExists -groupname $rgname

    for ($k = 0; $k -lt $count; $k++) {
        $namespace = $name + (($count |? {$count -gt 1} |% {$k}))
#		 $namespace = "adtapisbcrstoemea3901"
        if (-Not $Global:debug) {
            $resourceExists = (isResourceExists $namespace $rgname $Tags.blobstorage)

            if (-Not $resourceExists) {

                $provision = New-AzStorageAccount `
                    -ResourceGroupName $rgname `
                    -Name $namespace `
                    -Location $geoLocation `
                    -SkuName $map.sku `
                    -Kind $map.kind `
                    -ev error `
                    -ea Continue
    
                $resourceName = $provision.StorageAccountName
                logVerbose ("Started provisioning a Storage Account : $resourceName")
                if($error) {
                    Write-Error "Error Occurred while provisioning : "$error
                } else {
                    waitForStorageComplete -resourceName $namespace -resourceGroupName $rgname
                }
            }
            else {
                logVerbose ("Storage account exists: $namespace")
            }
        }
        else {
            logVerbose ("Successfully Provisioned Storage in debug mode: $namespace")
        }
    } 
}


function waitForStorageComplete($resourceName, $resourceGroupName) {
    try {
        $GetResourceInstance = Get-AzStorageAccount -Name $resourceName -ResourceGroupName $resourceGroupName
        $state = $GetResourceInstance.ProvisioningState
        Write-Verbose "Provisioning State : $state" -Verbose
        if ($state -ne 'Failed') {
            Do {
                $success = $false
                if ($state -eq 'Succeeded') {
                    $success = $true
                    storeStorageConnectionString -resourceName $resourceName -rgname $resourceGroupName -instance $GetResourceInstance
                    logVerbose ("The resource is successfully provisioned and ready to use. The resource name : $resourceName")
                }
                else {
                    Write-Verbose "The resource is still provisioning, please wait an update will be provided in 2 minutes.." -Verbose
                    Start-Sleep -Seconds 120
                    $GetResourceInstance = Get-AzStorageAccount -Name $resourceName -ResourceGroupName $resourceGroupName
                    $state = $GetResourceInstance.ProvisioningState
                }
            } While (-Not $success)
        }
        else {
            logVerbose "Failed to provision the resource. The resource name : $resourceName"
        }
    }
    catch {
        Write-Error $_
    }
}


function storeStorageConnectionString($resourceName, $rgname, $instance) {
    $default = "DefaultEndpointsProtocol=https;"
    $accountNameTag = "AccountName="
    $accountKeyTag = ";AccountKey="
    $endpointValue = GetEndPointSuffix
    $endpoint = ";EndpointSuffix=$endpointValue"

    $accountName = $instance.StorageAccountName
    $accountKey = Get-AzStorageAccountKey -ResourceGroupName $rgname -AccountName $resourceName | Where-Object { $_.KeyName -eq "key1" }
    $ConnectionString = $default + $accountNameTag + $accountName + $accountKeyTag + $accountKey.Value + $endpoint
    $connectionName = GetName -name $resourceName -kvId "Storage"               
    storeKeyVault -connectionString $ConnectionString -name $connectionName
}