########################################################################
#
# Linux on Hyper-V and Azure Test Code, ver. 1.0.0
# Copyright (c) Microsoft Corporation
#
# All rights reserved. 
# Licensed under the Apache License, Version 2.0 (the ""License"");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0  
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS
# OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
# ANY IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
#
# See the Apache Version 2.0 License for specific language governing
# permissions and limitations under the License.
#
########################################################################


<#
.Synopsis
    

.Description
    

.Parameter vmName
    

.Parameter hvServer
    

.Parameter testParams
    

.Example
    
#>
############################################################################
#
# SimplePS.ps1
#
# Description:
#     This is a PowerShell test case script to validate that
#     PowerShell test case scripts are being invoked correctly.
#
#     Setup scripts (and cleanup scripts) are run in a separate
#     PowerShell environment, so they do not have access to the
#     environment running the ICA scripts.  Since this script uses
#     The PowerShell Hyper-V library, these modules must be loaded
#     by this startup script.
#
#     The .xml entry for this script could look like either of the
#     following:
#
#         <setupScript>SetupScripts\ChangeCPU.ps1</setupScript>
#
#   The LiSA automation scripts will always pass the vmName, hvServer,
#   and a string of testParams.  The testParams is a string of semicolon
#   separated key value pairs.  For example, an example would be:
#
#         "SLEEP_TIME=5; VCPU=2;"
#
#   The setup (and cleanup) scripts need to parse the testParam
#   string to find any parameters it needs.
#
#   All setup and cleanup scripts must return a boolean ($true or $false)
#   to indicate if the script completed successfully or not.
#
############################################################################
param([string] $vmName, [string] $hvServer, [string] $testParams)

$retVal = $false

#
# Check input arguments
#
if (-not $vmName)
{
    "Error: VM name is null"
    return $retVal
}

if (-not $hvServer)
{
    "Error: hvServer is null"
    return $retVal
}

if (-not $testParams)
{
    "Error: No testParams provided"
    "       The script $MyInvocation.InvocationName requires the VCPU test parameter"
    return $retVal
}

if ($testParams.Length -lt 3)
{
    "Error: Malformed testParams: '$testParams'"
    return $retVal
}

#
# for debugging - to be removed
#
"SimplePS.ps1 -vmName $vmName -hvServer $hvServer -testParams $testParams"

#
# Find the testParams we require.  Complain if not found
#
$gPsParam = $null
$tPsParam = $null
$vPsParam = $null

$params = $testParams.Split(";")
foreach ($p in $params)
{
    $fields = $p.Split("=")
    
    if ($fields[0].Trim() -eq "gPsParam")
    {
        $gPsParam = $fields[1].Trim()
    }
    
        if ($fields[0].Trim() -eq "tPsParam")
    {
        $tPsParam = $fields[1].Trim()
    }
    
        if ($fields[0].Trim() -eq "vPsParam")
    {
        $vPsParam = $fields[1].Trim()
    }
}

#
# Make sure we received all three test parameters
#    $gPsParam - From the global section of the .xml file
#    $tPsParam - From the test case section of the .xml file
#    $vPsParam - From the vm section of the .xml file
#
if (-not $gPsParam)
{
    "Error: Missing Global testParams"
    return $retVal
}

if (-not $tPsParam)
{
    "Error: Missing test specific testParams"
    return $retVal
}

if (-not $vPsParam)
{
    "Error: Missing VM specific testParams"
    return $retVal
}

$retVal = $True

return $retVal
