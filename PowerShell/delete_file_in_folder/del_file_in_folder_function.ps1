# adddays - дни, addmonths -месяцы
function deletefile ($path,$days)
{
$date = (Get-Date).AddDays(-$days)  
# Свойство PSisContainer показывает является-ли объект контейнером, т.е. каталогом ! - отрицание
Get-ChildItem -Path $path | where {!$_.PSIsContainer} |
	foreach {
		if ($_.LastWriteTime -lt $date) {
            Set-Location $path
# в тестовых целях указываем -whatif, когда убедимся что все корректно работает то убираем его
			Remove-Item $_ 
            }
}
}
deletefile -path $args[0] -days $args[1]