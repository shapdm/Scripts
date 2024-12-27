# Функция для получения информации о батарее
function Get-BatteryInfo() {
    $batclass = Get-WmiObject -Namespace ROOT\WMI -Class "BatteryStaticData" -List
    if (!$batclass) {
        return "Нет аккумулятора, либо скрипт запущен на компьютере!"
    }
    $DesignedCapacity = (Get-WmiObject -Namespace ROOT\WMI -ClassName "BatteryStaticData").DesignedCapacity
    $FullChargedCapacity = (Get-CimInstance -Namespace ROOT\WMI -ClassName "BatteryFullChargedCapacity").FullChargedCapacity
    return [math]::Round(100 - ($FullChargedCapacity / $DesignedCapacity * 100))
}

# Основной блок скрипта
$result = Get-BatteryInfo

# Определяем цвет текста на основе процента износа
if ($result -is [string]) {
    # Если аккумулятор отсутствует
    $color = "Red"
} elseif ($result -gt 60) {
    $color = "Red"
} elseif ($result -gt 40) {
    $color = "Yellow"
} else {
    $color = "Green"
}

# Генерация строки результата
if ($result -is [string]) {
    # Если аккумулятора нет
    Write-Host "====================================="
    Write-Host "  $result" -ForegroundColor $color
    Write-Host "====================================="
} else {
    # Вывод информации об износе
    Write-Host "====================================="
    Write-Host "  Степень износа аккумулятора:" -ForegroundColor White
    Write-Host "  Износ: $result%" -ForegroundColor $color
    Write-Host "====================================="
}