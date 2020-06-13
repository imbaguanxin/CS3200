import mysql.connector
import pandas as pd


# root_config = {
#     'user': 'root',
#     'password': 'meiyoumima666',
#     'host': '127.0.0.1',
#     'database': 'ade'
# }

def main():
    # vn
    vn_header = "./vn_dump/vn.header"
    vn = "./vn_dump/vn"
    df_header = list(pd.read_csv(vn_header, sep='\t').columns)
    df_vn = pd.read_csv(vn, sep='\t', header=0)
    df_vn.columns = df_header
    ex = df_vn.iloc[0, :]
    print(ex)
    # print(df_vn.head())
    # wiki
    wiki_header =


if __name__ == '__main__':
    main()
    # cnx = mysql.connector.connect(**root_config)
    # cursor = cnx.cursor()
    #
    # query = 'SELECT * FROM diagnosis'
