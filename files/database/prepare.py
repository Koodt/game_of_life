#!/usr/bin/python3

from datetime import datetime
from logging import NullHandler

import time

import string
import random
import sys
from unittest import result

def id_generator(size=13, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

import psycopg2
try:
    conn = psycopg2.connect(host="master.e8bfe452-3e4f-2f36-b13e-51c19486fb3c.c.dbaas.selcloud.ru",
                            port="6432",
                            database="game_of_life",
                            user="bdrtrbhf67buj6r7jbrrb6he5vg4g5e6h",
                            password="e56bh56bhr67bj6bjr67bhve56vh65vge65hv56")
except:
    print("I am unable to connect to the database.")
    sys.exit(404)

tableName = 'incredible_live'

cur = conn.cursor()
cells = 50

cur.execute("drop table if exists "+tableName+";")

sqlCreateTable = "create table if not exists "+tableName+" (id SERIAL PRIMARY KEY"
sqlZeroGeneration = "insert into "+tableName+" (id) VALUES ("

for cell in range(1, cells + 1):
    sqlCreateTable = sqlCreateTable + ", \""+str(cell)+"\" text"

sqlCreateTable = sqlCreateTable + ");"

sqlGetTable = "select * from "+tableName+" order by id asc;"

cur.execute(sqlCreateTable)

for cell in range(1, cells + 1):
    cur.execute(sqlZeroGeneration + "'"+str(cell)+"') on conflict do nothing;")

generation = [0] * cell
for i in range(cell):
    generation[i] = [0] * cell

SWITCH = "4bo$3b4o2bo6bobo$4b4obo9bo$b2o3b3o6bo2bo$2o2bo9b3o$2obo$2bo3$26bo$25bobo2$24bo2bo$24b2o$24bo5$26b2o$25bo$25b2o$25b3o$26b2o$24bob3o$23bo3bo$22bo2bo$23b3o$23b2o!"
BURLOAFERIMETER = "4b2o4b$5bo4b$4bo5b$3bob3o2b$3bobo2bob$2obo3bobo$2obo4bob$4b4o2b2$4b2o4b$4b2o!"
DINNERTABLE = "bo$b3o7b2o$4bo6bo$3b2o4bobo$9b2o2$5b3o$5b3o$2b2o$bobo4b2o$bo6bo$2o7b3o$11bo!"
GLIDER = "2o4bo7bo4bo6bo3bobo6bo5bo$b2o3b2o7bo4b2o2bobo4b2o6bobo2bo$o4bobo5b3o3b2o4b2o4bo7b2o3b3o4$3o3b2o7bo4b2o4b2o3b3o5bobo4bo$2bo2bobo6b2o4bobo2b2o4bo7b2o3b2o$bo5bo6bobo3bo6bo4bo7bo4b2o!"
PUFFER = "2b2o$2ob2o$4o$b2o3$o$2o$b2o$2o5$2b2o$2ob2o$4o$b2o!"
PIHASLE = "6b3o$6bo$6b3o3$b2o10b2o$o2bo8bo2bo$3o2b6o2b3o$3b2o6b2o$2bo10bo$2b2obo4bob2o$7b2o!"
PIPORTRAITOR = "11b2o$6b2obo4bob2o$6bo10bo$7b2o6b2o$4b3o2b6o2b3o$4bo2bo8bo2bo$b2obobo10bobob2o$bobobo12bobobo$3bo16bo$bo2bo14bo2bo$4bo14bo$o3bo14bo3bo$o3bo5b3o6bo3bo$4bo5bo8bo$bo2bo5b3o6bo2bo$3bo16bo$bobobo12bobobo$b2obobo10bobob2o$4bo2bo8bo2bo$4b3o2b6o2b3o$7b2o6b2o$6bo10bo$6b2obo4bob2o$11b2o!"
QUEENBEESEQ = "bo4b2o$2bo2bobo$3o2b2o!"
HWSSSEQ = "4bo20bobo8bobo$5bo19b2o10b2o$3b3o10bo9bo10bo10bo$14bobo29b2o$15b2o30b2o$4b2o32b2o$4b2o31bobo3b2o$2o22b3o10b2o5bo$b2o31bo6b3o$o6b2o25b2o5bo$6b2o25bobo$8bo12b2o$20bo2bo$21bobo$22bo3bo$25b2o$25bobo!"
SCHICKENGINESYNTH = "4bo$5bo$3b3o$21bo$19b2o$20b2o3$12bo$6bo5bobo$5bo6b2o$b2o2b3o$o2bo10b3o$bobo10bo$2bo12bo2$11b2o$11b2o4$20b2o$19b2o$21bo$3b3o$5bo$4bo!"
ANYWSSTOGLIDER = "18bo$16bo3bo$b6o14bo11b4o$o5bo9bo4bo10bo3bo10b2o$6bo10b5o14bo10bobo$o4bo26bo2bo6b2o6bo$2b2o37bo2bo2bo2bo7b2o$42b2o6bo7b2o$47bobo$47b2o2$41b3o$41b3o$40bo3bo$39bo5bo$40bo3bo$41b3o5$2o$2o$2o$2o$2o$41b2o$41b2o!"

def relToArray(relString):
    if relString[-1] == '!':
        relString = relString[:-1]

    relString = relString.split('$')

    arraySize = range(len(relString) - 1) # 0..9

    # Here, no double digit in the end!
    for someIterator in arraySize:
        if relString[someIterator] != '':
            if relString[someIterator][-1].isdigit():
                counter = int(relString[someIterator][-1])
                relString[someIterator] = relString[someIterator][:-1]
                for loops in range(1, counter):
                    relString.insert(someIterator + 1, " ")

    cells = 50

    resultArray = [""] * cells
    for i in range(cells):
        resultArray[i] = [""] * cells

    for rawCount in range(0, len(relString)):
        resultRaw = ""
        veryResultString = ""

        for colPos in range(len(relString[rawCount])): #4b2o4b - 0..5
            # 1 - if digit or last character in string
            if relString[rawCount][colPos].isdigit() or colPos == range(len(relString[rawCount])):
                resultRaw = resultRaw + str(relString[rawCount][colPos])
            # 2 - if letter and start string
            elif relString[rawCount][colPos].isalpha() and colPos == 0:
                resultRaw = resultRaw + "1" + str(relString[rawCount][colPos])
            # 3 - if previous symbol is letter
            elif relString[rawCount][colPos - 1].isalpha():
                resultRaw = resultRaw + "1" + str(relString[rawCount][colPos])
            # 4 - others
            else:
                resultRaw = resultRaw + str(relString[rawCount][colPos])

        for letter in range(0, len(resultRaw) - 1):
            if letter == 0:
                if resultRaw[letter].isdigit() and resultRaw[letter + 1].isalpha() and letter < len(resultRaw):
                    for letterIter in range(int(resultRaw[letter])):
                            veryResultString = veryResultString + resultRaw[letter + 1]
                elif resultRaw[letter].isdigit() and resultRaw[letter + 1].isdigit():
                    doubleDigit = int(resultRaw[letter] + resultRaw[letter + 1])
                    for letterIter in range(doubleDigit):
                            veryResultString = veryResultString + resultRaw[letter + 2]
            else:
                if resultRaw[letter].isdigit() and resultRaw[letter + 1].isalpha() and letter < len(resultRaw) and resultRaw[letter - 1].isalpha():
                    for letterIter in range(int(resultRaw[letter])):
                            veryResultString = veryResultString + resultRaw[letter + 1]
                elif resultRaw[letter].isdigit() and resultRaw[letter + 1].isdigit():
                    doubleDigit = int(resultRaw[letter] + resultRaw[letter + 1])
                    for letterIter in range(doubleDigit):
                            veryResultString = veryResultString + resultRaw[letter + 2]

        for letterPos in range(len(veryResultString)):
            if veryResultString[letterPos] == 'o':
                resultArray[rawCount][letterPos] = random.choice(string.ascii_letters)
            if veryResultString[letterPos] == 'b':
                resultArray[rawCount][letterPos] = ""

    return resultArray

def landing(figure):
    randomRaw = random.randint(1, len(data) + 1)
    randomColumn = random.randint(1, len(data[randomRaw]))

    for cellRawCoord in range(len(figure)):
        if int(randomRaw) + int(cellRawCoord) > len(data):
            rawCoord = (len(data) - cellRawCoord - randomRaw) * - 1
        else:
            rawCoord = int(cellRawCoord) + int(randomRaw)
        #print(figure[cellRawCoord])
        for cellColumnCoord in range(len(figure[cellRawCoord])):
            if int(randomColumn) + int(cellColumnCoord) > len(data):
                colCoord = (len(data) - cellColumnCoord - randomColumn) * - 1
            else:
                colCoord = int(cellColumnCoord) + int(randomColumn)
            if figure[cellRawCoord][cellColumnCoord].isalpha():
                cur.execute("update "+tableName+" set \""+ str(colCoord) +"\" = '"+random.choice(string.ascii_letters)+"' where \"id\" = '"+str(rawCoord)+"';")

cur.execute(sqlGetTable)
data = cur.fetchall()

#landing(relToArray(GLIDER))
landing(relToArray(PUFFER))
landing(relToArray(PUFFER))
#landing(relToArray(PUFFER))

time.sleep(2)
conn.commit()

cur.close()
conn.close()
