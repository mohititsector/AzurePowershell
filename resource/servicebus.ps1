<#
Creates Service Bus Namespace 
#>
function CreateServiceBusIfNotExists {
    param (
        [Parameter(Mandatory = $false)][hashtable]$map
    )
    $name = $map.name
    $count = $map.instances
    $rgname = GetGroupName -groupname $map.groupname

    CreateResourceGroupIfNotExists -groupname $rgname

    for ($k = 1; $k -le $count; $k++) {
        $namespace = $name + "{0:000}" -f $k + $geoStamp
        if (-Not $Global:debug) {
            $resourceExists = (isResourceExists $namespace $rgname $Tags.servicebus)
            if (-Not $resourceExists) {
                $provision = New-AzServiceBusNamespace `
                    -ResourceGroupName $rgname `
                    -NamespaceName $namespace `
                    -Location $geoLocation `
                    -SkuName $map.tier `
                    -SkuCapacity 8 `
                    -ev error `
                    -ea Continue       
                
                $resourceName = $provision.Name
                logVerbose ("Started provisioning a Service Bus : $resourceName")
                if($error) {
                    Write-Error "Error Occurred while provisioning : "$error
                } else {
                    waitForServiceBusComplete -resourceName $namespace -resourceGroupName $rgname
                }    
            }
            else {
                logVerbose ("The ServiceBus already exists: $namespace")
            }            
        }
        else {
            logVerbose ("Successfully Provisioned Service bus in debug mode: $namespace")
        }
    }
}

function waitForServiceBusComplete($resourceName, $resourceGroupName) {
    try {
        $GetResourceInstance = Get-AzServiceBusNamespace -Name $resourceName -ResourceGroupName $resourceGroupName
        $state = $GetResourceInstance.ProvisioningState
        Write-Verbose "Provisioning State : $state" -Verbose
        if ($state -ne 'Failed') {
            Do {
                $success = $false
                if ($state -eq 'Succeeded') {
                    $success = $true
                    storeServiceBusConnectionString -resourceName $resourceName -rgname $resourceGroupName -instance $GetResourceInstance
                    logVerbose ("The resource is successfully provisioned and ready to use. The resource name: $resourceName")
                }
                else {
                    Write-Verbose "The resource is still provisioning, please wait an update will be provided in 2 minutes.." -Verbose
                    Start-Sleep -Seconds 120
                    $GetResourceInstance = Get-AzServiceBusNamespace -Name $resourceName -ResourceGroupName $resourceGroupName
                    $state = $GetResourceInstance.ProvisioningState
                }
            } While (-Not $success)
        }
        else {
            logVerbose ("Failed to provision the resource. The resource name : $resourceName")
        }
    }
    catch {
        Write-Error $_
    }
}


function storeServiceBusConnectionString($resourceName, $rgname, $instance) {
    $ConnectionString = (Get-AzServiceBusKey -ResourceGroupName $rgname -Namespace $resourceName -Name RootManageSharedAccessKey).PrimaryConnectionString
    $stringName = GetName -name $resourceName -kvId "ServiceBus"
    storeKeyVault -name  $stringName -connectionString $ConnectionString
}