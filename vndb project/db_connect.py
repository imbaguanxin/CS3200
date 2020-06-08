import mysql.connector

root_config = {
    'user': 'root',
    'password': 'meiyoumima666',
    'host': '127.0.0.1',
    'database': 'ade'
}

if __name__ == '__main__':
    cnx = mysql.connector.connect(**root_config)
    cursor = cnx.cursor()

    query = ('SELECT * FROM diagnosis')
