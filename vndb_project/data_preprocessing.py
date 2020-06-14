import mysql.connector
import pandas as pd
import sqlalchemy
import pymysql
import numpy as np
import os

root_config = {
    'user': 'root',
    'password': 'meiyoumima666',
    'host': '127.0.0.1',
    'database': 'vndb_dev'
}


def main():
    # vn
    extract_to_csv('vn', 'vn.header', ['id', 'title', 'original', 'alias', 'desc'], destination='vn.csv',
                   column_rename=['vn_id', 'en_title', 'original_tite', 'alias', 'intro'])
    # producer
    extract_to_csv('producers', 'producers.header',
                   ['id', 'type', 'name', 'original', 'alias', 'website', 'desc', 'lang'],
                   destination='producer.csv',
                   column_rename=['producer_id', 'type', 'en_name', 'original_name', 'alias', 'website', 'intro',
                                  'language_code'])
    # chars
    extract_to_csv('chars', 'chars.header',
                   ['id', 'name', 'original', 'alias', 'desc', 'gender', 'b_month', 'b_day', 'height', 'weight',
                    'bloodt', 'age'],
                   destination='vn_char.csv',
                   column_rename=['char_id', 'en_name', 'original_name', 'alias', 'intro', 'gender', 'b_month', 'b_day',
                                  'height', 'weight', 'blood_type', 'age'])
    # staff
    extract_to_csv('staff', 'staff.header', ['id', 'gender', 'desc', 'l_site', 'l_twitter'], 'staff.csv',
                   ['staff_id', 'gender', 'intro', 'website', 'twitter'])
    # release
    extract_to_csv('releases', 'releases.header', ['id', 'title', 'original', 'website', 'notes'], 'release.csv',
                   ['release_id', 'en_title', 'original_title', 'website', 'notes'])
    # staff_stage_name
    extract_to_csv('staff_alias', 'staff_alias.header', ['aid', 'name', 'original', 'id'], 'staff_stage_name.csv',
                   ['staff_name_id', 'en_name', 'original_name', 'staff_id'])

    # n:m relations
    # vn:producer
    extract_to_csv('releases_vn', 'releases_vn.header', ['id', 'vid'], 'vn_has_producer.csv',
                   ['producer_id', 'vn_id'])
    # vn:staff
    extract_to_csv('vn_staff', 'vn_staff.header', ['id', 'aid', 'role', 'note'], 'vn_staff.csv',
                   ['vn_id', 'staff_id', 'position', 'note'])
    # vn:char
    extract_to_csv('chars_vns', 'chars_vns.header', ['id', 'vid', 'role'], 'vn_char_relation.csv',
                   ['char_id', 'vn_id', 'role'])
    # release:lang
    extract_to_csv('releases_lang', 'releases_lang.header', ['id', 'lang'], 'releases_lang.csv',
                   ['release_id', 'language_code'])


def extract_to_csv(table, header, columns, destination, column_rename=None):
    data = './data'
    dump = './vn_dump'
    header_path = os.path.join(dump, header)
    table_path = os.path.join(dump, table)
    df_selected = extract_from_file(table_path, header_path, selected_column=columns)
    if column_rename:
        df_selected.columns = column_rename
    print(destination)
    df_selected.to_csv(os.path.join(data, destination), index=False)


def extract_from_file(table_path, header_path, selected_column=None):
    df_header = list(pd.read_csv(header_path, sep='\t').columns)
    df = pd.read_csv(table_path, sep='\t', header=0)
    df.columns = df_header
    if selected_column:
        return df[selected_column]
    return df


def handle_release():
    connection = sqlalchemy.create_engine('mysql+pymysql://root:meiyoumima666@127.0.0.1/vndb_dev')
    data = './data'
    dump = './vn_dump'
    header_path = os.path.join(dump, 'releases.header')
    table_path = os.path.join(dump, 'releases')
    release = extract_from_file(table_path, header_path,
                                selected_column=['id', 'title', 'original', 'website', 'notes'])
    release.columns = ['release_id', 'en_title', 'original_title', 'website', 'notes']
    release.to_sql(con=connection, name='vn_release', if_exists='replace')
    # language
    language = extract_from_file(os.path.join(dump, 'releases_lang'), os.path.join(dump, 'releases_lang.header'),
                                 selected_column=['id', 'lang'])
    language.columns = ['release_id', 'lang']
    language.to_sql(con=connection, name='release_language', if_exists='replace')
    # platform
    platform = extract_from_file(os.path.join(dump, 'releases_platforms'),
                                 os.path.join(dump, 'releases_platforms.header'),
                                 selected_column=['id', 'platform'])
    platform.columns = ['release_id', 'platform']
    platform.to_sql(con=connection, name='release_platform', if_exists='replace')
    # producer
    producer = extract_from_file(os.path.join(dump, 'releases_producers'),
                                 os.path.join(dump, 'releases_producers.header'),
                                 selected_column=['id', 'pid'])
    producer.columns = ['release_id', 'producer_id']
    producer.to_sql(con=connection, name='release_producer', if_exists='replace')


def fetch_release():
    vndb_dev_con = sqlalchemy.create_engine('mysql+pymysql://root:meiyoumima666@127.0.0.1/vndb_dev')
    df = pd.read_sql('SELECT * FROM release_with_plt_producer', con=vndb_dev_con)
    print(df)
    df.to_csv('./data/release_all_info.csv', index=False, float_format='%g')


if __name__ == '__main__':
    handle_release()
    # extract_to_csv('releases_lang', 'releases_lang.header', ['id', 'lang'], 'releases_lang.csv',
    #     #                ['release_id', 'language_code'])
