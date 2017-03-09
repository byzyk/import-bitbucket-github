import sys, json;
repos = json.load(sys.stdin)['values'];
str = ''
for r in repos:
    str += r['name']+' '
print(str)