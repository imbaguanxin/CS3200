import os

import pandas as pd
import sqlalchemy

file_table_map = {
    # vn
    'vn.csv': 'vn',
    # characters
    'vn_char.csv': 'vn_char',
    # vn and characters relation
    'vn_char_relation.csv': 'char_vn_relation',
    # language
    'language_codes.csv': 'lang',
    # 'release.csv': 'vn_release',
    # 'staff.csv': 'staff',
    # 'staff_stage_name.csv': 'staff_stage_name',
    # 'producer.csv': 'producer',
    # 'release_all_info.csv': 'vn_release'
}


def main():
    connection = sqlalchemy.create_engine('mysql+pymysql://root:meiyoumima666@127.0.0.1/vn_collection')
    data = './data'
    for key in file_table_map.keys():
        df = pd.read_csv(os.path.join(data, key))
        print(df)
        df.to_sql(con=connection, name=file_table_map[key], index=False, if_exists='append')


if __name__ == '__main__':
    main()
