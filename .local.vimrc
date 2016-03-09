
let g:syntastic_python_pep8_args = ['--max-line-length=95']
let g:syntastic_python_pylint_args = ['--disable=C0325', '--max-line-length=95']

if has('win32')
    let python_scripts = 'C:\\dev\\python\\Scripts\\'

    let g:syntastic_python_pep8_exec = python_scripts + 'pep8.bat'
    let g:syntastic_python_pylint_exec = python_scripts + 'pylint.bat'
else
    let g:syntastic_python_checkers=['pep8', 'pylint', 'pyflakes']
    let g:syntastic_python_pylint_exe = 'python -m pylint'
    let g:syntastic_python_pep8_exe = 'python -m pep8'
endif

" vim: ts=4 sw=4
