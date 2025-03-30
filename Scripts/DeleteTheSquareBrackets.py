# Этот скрипт удаляет текст в квадратных скобках в каждой строке. Удобно для обработки списков длинных и коротких статей (Special:LongPages / Special:ShortPages)
import re

def remove_bracketed_text(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as infile, open(output_file, 'w', encoding='utf-8') as outfile:
        for line in infile:
            cleaned_line = re.sub(r'\s*\[.*?\]', '', line).strip()
            if cleaned_line:
                outfile.write(cleaned_line + '\n')

input_filename = 'input.txt'
output_filename = 'output.txt'

remove_bracketed_text(input_filename, output_filename)
print(f'Обработанный текст сохранён в {output_filename}')
