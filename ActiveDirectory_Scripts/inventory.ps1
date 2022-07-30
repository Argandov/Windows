# Get all computer objects in a domain and output an inventory csv containing:
# Name, Serial No, Storage Available/Used, RAM, CPU, Cores, Threads, System + OS


FUNCTION GetSystemInventory ($ServerNamesStartWith) {
    FUNCTION GetSystemNames ($convention) {
        # $convention = "$convention" + "*"
        Get-ADComputer -Filter {(ObjectClass -like $convention)}| select -ExpandProperty Name
        }
    FUNCTION GetSize($Servername) {
        Invoke-Command -ScriptBlock {
        $size = get-volume | Foreach { $_.Size }
        $sumA = 0
        $size | Foreach { $sumA += $_}
        $size = [math]::Round($sumA/1GB,0)

        $remaining = get-volume | ForEach {$_.SizeRemaining }
        $sumB = 0
        $remaining | Foreach { $sumB += $_}
        $remaining = [math]::Round($sumB/1GB,0)
        $usedspace = $size - $remaining
        $usedspace = [math]::Round($usedspace,0)

        $ram = gwmi Win32_OperatingSystem | Measure-Object -Property TotalVisibleMemorySize -Sum | % {[Math]::Round($_.sum/1024/1024)}
        $CPUcores = Get-WmiObject Win32_Processor |Select-Object -ExpandProperty NumberOfCores
        $CPUthreads = Get-WmiObject Win32_Processor |Select-Object -ExpandProperty NumberOfLogicalProcessors
        $CPUname = Get-WmiObject Win32_Processor |Select-Object -ExpandProperty Name
        $SystemType = get-wmiobject win32_computersystem | Select-Object -ExpandProperty model
        $OSname = Get-WmiObject win32_operatingsystem | Select-Object -ExpandProperty caption
        $SerialNo = Get-WmiObject win32_bios | select Serialnumber
        $SerialNo = $SerialNo.replace("@{Serialnumber=","")
        $SerialNo = $SerialNo.replace("}","")
        $out = "$SerialNo" + "`t" + "$size" + "`t" + "$usedspace" + "`t" + "$ram" + "`t" + "$CPUname" + "`t" + "$CPUcores" + "`t" + "$CPUthreads" + "`t" + "$SystemType" + "`t" + "$OSname"
        $out
        } -ComputerName $servername -ErrorAction SilentlyContinue
        }
    $output = @(GetSystemNames $ServerNamesStartWith)

    $head = "SERVER" + "`t" + "SERIAL NO" + "`t" + "STORAGE ALLOCATED" + "`t" + "STORAGE USED" + "`t" + "RAM" + "`t" + "CPU" + "`t" + "CORES" + "`t" + "THREADS" + "`t" + "SYSTEM" + "`t" + "OS"
    $head
    ForEach($name in $output) {
        $size = GetSize $name
        $info = "$name" + "`t" + "$size"
        $info
    }
}

GetSystemInventory computer | Out-File \path\to\out.csv
