import mysql.connector as connector

connection = connector.connect (
    user = "***",
    password = "****",
    db = "LittleLemonDM"
)

showtables = "SHOW tables"

cursor = connection.cursor()
cursor.execute(showtables)

for x in cursor:
    print(x)


# Testing
    
orders_query = """SELECT * FROM Orders""" 
cursor.execute(orders_query)

results = cursor.fetchall()

cols = cursor.column_names

print(cols)
for result in results:
    print(result)


# Task 3
    
orders60 = """
SELECT c.CustomerID, c.FullName, c.ContactNumber, o.TotalCost
FROM Orders o
INNER JOIN Customers c
  ON o.CustomerID = c.CustomerID
WHERE o.TotalCost > 60
"""

cursor.execute(orders60)
results = cursor.fetchall()

cols = cursor.column_names

# print the cols and results
print("Customers with orders greater than $60:")
print("---------------------------------------")
print(cols)
for result in results:
    print(result)
    