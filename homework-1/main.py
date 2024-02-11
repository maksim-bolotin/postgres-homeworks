"""Скрипт для заполнения данными таблиц в БД Postgres."""

import psycopg2
import csv

conn = psycopg2.connect(
    host="localhost",
    database="north",
    user="postgres",
    password="sqlUSER"
)

try:
    with conn:
        with conn.cursor() as cur:
            # Заполнение таблицы employees данными из CSV файла.
            with open('north_data/employees_data.csv', 'r', encoding='utf8') as file:
                csv_reader = csv.DictReader(file)
                for row in csv_reader:
                    cur.execute('INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s)',
                                (row["employee_id"], row["first_name"], row["last_name"],
                                 row["title"], row["birth_date"], row["notes"]))

            # Заполнение таблицы customers данными из CSV файла.
            with open('north_data/customers_data.csv', 'r', encoding='utf8') as file:
                csv_reader = csv.DictReader(file)
                for row in csv_reader:
                    cur.execute('INSERT INTO customers VALUES (%s, %s, %s)',
                                (row["customer_id"], row["company_name"], row["contact_name"]))

            # Заполнение таблицы orders данными из CSV файла.
            with open('north_data/orders_data.csv', 'r', encoding='utf8') as file:
                csv_reader = csv.DictReader(file)
                for row in csv_reader:
                    cur.execute('INSERT INTO orders VALUES (%s, %s, %s, %s, %s)',
                                (row["order_id"], row["customer_id"], row["employee_id"],
                                 row["order_date"], row["ship_city"]))

            # Вывод данных из таблицы employees.
            cur.execute("SELECT * FROM employees")
            rows = cur.fetchall()
            print("Data in employees table:")
            for row in rows:
                print(row)

            # Вывод данных из таблицы customers.
            cur.execute("SELECT * FROM customers")
            rows = cur.fetchall()
            print("\nData in customers table:")
            for row in rows:
                print(row)

            # Вывод данных из таблицы orders.
            cur.execute("SELECT * FROM orders")
            rows = cur.fetchall()
            print("\nData in orders table:")
            for row in rows:
                print(row)

finally:
    conn.close()
