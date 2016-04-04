functions
-----------
Для использования в скриптах необходимо подключить  файл с функциями.
add this command to your script
source pathto/functional_local

# Пример вызова функции
#color_str "Красный Текст" red

functions getpath
#for use in your scripts  call getpath:
после вызова в переменной $DIRECTORY будет полный путь до скрипта

# example usage validate_url:
# if `validate_url $url >/dev/null`; then dosomething; else echo "does not exist"; fi