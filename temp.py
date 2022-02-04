import json

with open('C:/git/Automation/Automation/scout/properties/scout.json') as f:

    data = json.load(f)
    list(data)

l = '#stored(\'filedate\', \'20200101\'); \n #stored(\'build_month\',\'202001\'); \n import scout; \n \n sequential( '

for X in data:
    l = l + (X['AttributeToCall']) + ', \n'

final_list = l[:-3] + ');'
print(final_list)
s_file = open('scout/compile_scout.ecl', "w")
s_file.write(final_list)
s_file.close()
