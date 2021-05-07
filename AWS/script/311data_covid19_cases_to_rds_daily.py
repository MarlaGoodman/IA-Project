import pandas as pd
import boto3
from sqlalchemy import create_engine
from io import StringIO
import group2setting
    
def save_borough_case_rds(data_sample):
    
    sub_df = data_sample.loc[:, ['date_of_interest', 'BX_CASE_COUNT']]
    sub_df.rename(columns={'BX_CASE_COUNT':'case_count'}, inplace=True)
    sub_df['borough'] = 'Bronx'
    
    sub_df1 = data_sample.loc[:, ['date_of_interest', 'BK_CASE_COUNT']]
    sub_df1.rename(columns={'BK_CASE_COUNT':'case_count'}, inplace=True)
    sub_df1['borough'] = 'Brookly'

    sub_df2 = data_sample.loc[:, ['date_of_interest', 'MN_CASE_COUNT']]
    sub_df2.rename(columns={'MN_CASE_COUNT':'case_count'}, inplace=True)
    sub_df2['borough'] = 'Manhattan'

    sub_df3 = data_sample.loc[:, ['date_of_interest', 'QN_CASE_COUNT']]
    sub_df3.rename(columns={'QN_CASE_COUNT':'case_count'}, inplace=True)
    sub_df3['borough'] = 'Queens'

    sub_df4 = data_sample.loc[:, ['date_of_interest', 'SI_CASE_COUNT']]
    sub_df4.rename(columns={'SI_CASE_COUNT':'case_count'}, inplace=True)
    sub_df4['borough'] = 'Staten Island'

    sub_df = pd.concat([sub_df, sub_df1, sub_df2, sub_df3, sub_df4], ignore_index=True, sort=False)
    
    print(sub_df.head(2))
    save_into_rds_by_name(sub_df, "covid19_borough_cases_by_day")


def save_into_rds_by_name(sub_df, table_name):
    
    print(sub_df.shape)
    
    # create engine by sqlalchemy + pymysql
    engine = create_engine(group2setting.rds_mysql_engine)
    
    print(engine)
    
    # to transfer csv to mysql by pandas.to_sql
    sub_df.to_sql(con=engine, name=table_name, if_exists='replace')
    
    print(table_name + " save into rds successfully")


def load_case_from_rds():
    bucket = group2setting.s3_bucket
    file_name = 'Group_2_nyc_covid19_cases_by_day.csv'
    
    s3 = boto3.client('s3') 
    obj = s3.get_object(Bucket= bucket, Key= file_name) 
    
    case_sample = pd.read_csv(obj['Body'])
    
    print(case_sample.shape)
    
    return case_sample


def city_caserate(data_sample):
    
    sub_df = data_sample.loc[:, ['week_ending', 'CASERATE_CITY']]
    
    save_into_rds_by_name(sub_df, "covid19_city_caserate")
    

def borough_caserate(data_sample):
    
    sub_df = data_sample.loc[:, ['week_ending', 'CASERATE_BX']]
    sub_df.rename(columns={'CASERATE_BX':'caserate'}, inplace=True)
    sub_df['borough'] = 'Bronx'
    
    sub_df1 = data_sample.loc[:, ['week_ending', 'CASERATE_BK']]
    sub_df1.rename(columns={'CASERATE_BK':'caserate'}, inplace=True)
    sub_df1['borough'] = 'Brookly'

    sub_df2 = data_sample.loc[:, ['week_ending', 'CASERATE_MN']]
    sub_df2.rename(columns={'CASERATE_MN':'caserate'}, inplace=True)
    sub_df2['borough'] = 'Manhattan'

    sub_df3 = data_sample.loc[:, ['week_ending', 'CASERATE_QN']]
    sub_df3.rename(columns={'CASERATE_QN':'caserate'}, inplace=True)
    sub_df3['borough'] = 'Queens'

    sub_df4 = data_sample.loc[:, ['week_ending', 'CASERATE_SI']]
    sub_df4.rename(columns={'CASERATE_SI':'caserate'}, inplace=True)
    sub_df4['borough'] = 'Staten Island'

    sub_df = pd.concat([sub_df, sub_df1, sub_df2, sub_df3, sub_df4], ignore_index=True, sort=False)
    
    save_into_rds_by_name(sub_df, "covid19_borough_caserate")
    
def zipcode_caserate(data_sample):
    sub_arr = []
    for col in data_sample.columns[7:]:

        sub_df = data_sample.loc[:, ['week_ending', col]]
        zipcode = col[9:]

        sub_df.rename(columns={col:'caserate'}, inplace=True)
        sub_df['zipcode'] = zipcode

        sub_arr.append(sub_df)

    zipcode_sub_df = pd.concat(sub_arr, ignore_index=True, sort=False)
    
    save_into_rds_by_name(zipcode_sub_df, "covid19_zipcode_caserate")
    
    
def load_caserate_from_rds():
    
    bucket = group2setting.s3_bucket
    file_name = 'Group_2_nyc_covid19_caserate_by_zipcode.csv'
    
    s3 = boto3.client('s3') 
    obj = s3.get_object(Bucket= bucket, Key= file_name) 
    
    caserate_sample = pd.read_csv(obj['Body'])
    
    print(caserate_sample.shape)
    
    return caserate_sample


def lambda_handler(event, context):
    
    # load covid case
    case_sample = load_case_from_rds()
    # save borough
    save_borough_case_rds(case_sample)
    

    # load covid caserate
    caserate_sample = load_caserate_from_rds()
    # save city caserate
    city_caserate(caserate_sample)
    # save borough caserate
    borough_caserate(caserate_sample)
    # save zipcode caserate
    zipcode_caserate(caserate_sample)