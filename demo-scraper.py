import sqlite3

# Connect to the SQLite database
conn = sqlite3.connect('test.db')

# Create a cursor object
cursor = conn.cursor()

# Execute the query to retrieve column names
table_name = 'staging_table2'
query = f"SELECT name FROM pragma_table_info('{table_name}')"
cursor.execute(query)

# Fetch all the column names
column_names = cursor.fetchall()

# Print the column names
for name in column_names:
    print(name[0])

# Close the cursor and the database connection
cursor.close()
conn.close()
