#!/bin/bash
# Путь, куда будем складывать резервные копии
dump_path="/mnt"
# Устанавливаем разделитель для элементов массива, предварительно резервируя системный:
oldIFS==$IFS
IFS=";"
# Названия баз данных, которые будем востанавливать, перечисленные через разделитель, заданный выше
restore_bases="office_upp;buh_retail;zup"
#какой бекап восстанавливать за какое число относительно текущей даты, по умолчанию вчерашний
#days_ago=${1:-1}
days_ago=1
#получаем массив аргументов на будущее
#restore_bases=( $@ )
#получаем длинну массива
#len=${#restore_bases[@]}
#последний элемент массива
#days_ago=${restore_bases[$len-1]}
#откидываем последний элемент массива
#unset restore_bases[$len-1]

for dump_base in restore_bases; do
# Восстанавливаем дамп от имени пользователя postgres
    sudo -u postgres pg_restore -Fc -c -d $dump_base -f $dump_path/$dump_base-`date -d "-$days_ago day" \+\%Y-\%m-\%d`.pgdump
done
# Восстанавливаем стандартный (системный) разделитель списков
IFS=$oldIFS

#для создания
#Пользователя определяем из бакапа. Ищем строки со словом owner, смотрим от имени какого пользователя создаются объекты базы. Создаем пользователя через createuser 
#createuser -h localhost -U postgres -w username
#Параметры команды могут отличаться для вашего случая. Назначение ролей, пароля и т.д.
#8. Базу данных создаем через createdb
#createdb -h localhost -U username -w nurtau
#9. Теперь можно залить бакап
#psql -h localhost -U username -w nurtau < db.dump