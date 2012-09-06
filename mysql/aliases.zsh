alias m="mysql -D paiq0000 -h heat-int --port=3306 -u paiq0000 -p"
alias mrepl="mysql -D paiq0000 -h snatch-int -u paiq0000 -p"
alias mtest="mysql -D paiqtest -h snatch-int -u test -p"

alias mtj="mysql -D tjetter -h heat-int --port=3306 -u tjetter -p"
alias msandtj="mysql -h memento-int -u tjetter_sandbox -D tjetter_sandbox -p"
alias miml="mysql -D iml -h snatch-int -u iml -p"

export MYSQL_PS1="\u@\h > "

