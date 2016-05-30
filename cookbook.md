vim cookbook
============

Удалить пустые строки: `%s/^[\ \t]*\n//g`

Поставить/перейти/посмотреть все метки: ```m{a-zA-Z}/`{a-zA-Z}/:marks```

Перейти на строку номер X/к символу номер Y: `:X/:goto Y`

Изменение размеров split`а: Ctrl-W +/- по вертикали (Ctrl-W _ – максимум), Ctrl-W >/< – по горизонтали, Ctrl-W = – сделать равными

При поиске смещение относительно начала/конца совпадения: /b[+-num] или /s[+-num] / /e[+-num]
[:help search-offset](http://vimdoc.sourceforge.net/htmldoc/pattern.html#search-offset)
