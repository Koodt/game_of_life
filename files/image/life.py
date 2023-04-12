#!/usr/bin/python3
import time
import psycopg2
import string
import random
import sys


def id_generator(size=13, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))


try:
    conn = psycopg2.connect(
        host="master.e8bfe452-3e4f-2f36-b13e-51c19486fb3c.c.dbaas.selcloud.ru",
        port="6432",
        database="game_of_life"
        user="bdrtrbhf67buj6r7jbrrb6he5vg4g5e6h",
        password="e56bh56bhr67bj6bjr67bhve56vh65vge65hv56"
    )
except SystemExit:
    print("I am unable to connect to the database.")
    sys.exit(404)

tableName = 'incredible_live'

cur = conn.cursor()
cells = 50

string.ascii_letters.capitalize

sqlGetTable = "select * from "+tableName+" order by id asc;"

while True:
    cur.execute(sqlGetTable)
    data = cur.fetchall()
    for firstIter in range(len(data)):  # 0 - 29
        if firstIter == 0:
            previousRaw = len(data) - 1
            nextRaw = firstIter + 1
        elif firstIter == len(data) - 1:
            previousRaw = firstIter - 1
            nextRaw = 0
        else:
            previousRaw = firstIter - 1
            nextRaw = firstIter + 1
        currentRaw = firstIter
        for secondIter in range(1, len(data[firstIter])):  # 1 - 30
            if secondIter == 1:
                previousColumn = len(data[firstIter]) - 1
                nextColumn = secondIter + 1
            elif secondIter == len(data[firstIter]) - 1:
                previousColumn = secondIter - 1
                nextColumn = 1
            else:
                previousColumn = secondIter - 1
                nextColumn = secondIter + 1
            currentColumn = secondIter
            surviverCount = 0
            for raw in previousRaw, currentRaw, nextRaw:
                for column in previousColumn, currentColumn, nextColumn:
                    if raw != currentRaw or column != currentColumn:
                        if (
                                data[raw][column] != '' and
                                data[raw][column] != 'Null' and
                                data[raw][column] is not None
                        ):
                            surviverCount += 1

            print("=========")
            print("   Raw - ", currentRaw, "Column - ", currentColumn)
            print("  Data - ", data[currentRaw][currentColumn])
            print("Result - ", surviverCount)

            ''' update incredible_live set
                "4" = 'X',
                "5" = 'Х',
                "3" = 'X',
                "16" = 'X' where "id"='14';
            '''
            if (
                    data[currentRaw][currentColumn] == "" or
                    data[currentRaw][currentColumn] == "Null" or
                    data[currentRaw][currentColumn] == " " or
                    data[currentRaw][currentColumn] is None
            ):
                # Classic Conway
                if surviverCount == 3:
                    cur.execute("update "+
                                tableName+
                                " set \""+
                                str(currentColumn) +
                                "\" = '" +
                                random.choice(string.ascii_letters) +
                                "' where \"id\" = '" +
                                str(currentRaw + 1) +
                                "';")
            elif str(data[currentRaw][currentColumn]).isalpha():
                if surviverCount < 2 or surviverCount > 3:
                    cur.execute("update "+tableName+" set \"" +
                                str(currentColumn) +
                                "\" = '' where \"id\" = '" +
                                str(currentRaw + 1) +
                                "';")
            else:
                cur.execute("update "+tableName+" set \"" +
                            str(currentColumn) +
                            "\" = '' where \"id\" = '"+str(currentRaw + 1) +
                            "';")

    time.sleep(0.3
    conn.commit()
