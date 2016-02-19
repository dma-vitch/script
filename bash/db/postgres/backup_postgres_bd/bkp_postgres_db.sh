#!/bin/sh
# Для инструкций по восстановлению см. postgresql.org/docs/8.1/static/backup.html
# Путь, куда будем складывать резервные копии
dump_path="/mnt/"
# Устанавливаем разделитель для элементов массива, предварительно резервируя системный:
oldIFS==$IFS
IFS=";"
# Названия баз данных, которые будем сохранять, перечисленные через разделитель, заданный выше
dump_bases="rtr;uprav_rtr;zup3"
# Срок хранения резервных копий, дней:
dump_keepdays="7"
# Создаём информационный файл в каталоге назначения ("для будущих поколений")
echo Backup dumps of current databases. For restoring see postgresql.org/docs/9.3/static/backup.html > $dump_path/readme.txt
echo All data keeps $dump_keepdays days, older files will be removed automatically. >> $dump_path/readme.txt
for dump_base in $dump_bases; do
# Создаём дамп от имени пользователя postgres, в сжатый файл с именем вида %dbname%-yyyy-mm-dd.pgdump
  sudo -u postgres pg_dump -F c -Z 9 -f $dump_path/$dump_base-`date \+\%Y-\%m-\%d`.pgdump $dump_base
# Ищем в каталоге резервных копий все файлы с именами похожими на бэкап текущей БД и старше срока хранения и удаляем
# -regextype posix-basic ! \( -regex '.*/[a-Z]*-\{0,1\}[0-9]\{4\}-[0-9]\{2\}-01\.pgdump' -or -regex '.*/[a-Z]*-*[0-9]\{4\}-[0-9]\{2\}-15\.pgdump' \) -type f исключаем бекапы за 1 и 15 число каждого месяца
  find $dump_path/$dump_base*.pgdump -regextype posix-basic ! \( -regex '.*/[a-Z]*-\{0,1\}[0-9]\{4\}-[0-9]\{2\}-01\.pgdump' -or -regex '.*/[a-Z]*-*[0-9]\{4\}-[0-9]\{2\}-15\.pgdump' \) -type f -mtime +$dump_keepdays -exec /bin/rm '{}' \;
done
# Восстанавливаем стандартный (системный) разделитель списков
IFS=$oldIFS