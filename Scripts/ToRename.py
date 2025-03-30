# Этот скрипт дублирует содержание каждой строки через пробел. Используется для переименования статей через MassRename
# Не забудьте заменить все пробелы на нижние подчёркивания в оригинальном списке статей и заменить «Пространство/» на нужное вам пространство имён
def add_article_suffix(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as infile, open(output_file, 'w', encoding='utf-8') as outfile:
        for line in infile:
            cleaned_line = line.strip()
            if cleaned_line:
                new_line = f"{cleaned_line} Пространство/{cleaned_line}"
                outfile.write(new_line + '\n')

input_filename = 'input.txt'
output_filename = 'output.txt'

add_article_suffix(input_filename, output_filename)
print(f'Обработанный текст сохранён в {output_filename}')
