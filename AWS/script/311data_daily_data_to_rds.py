import pandas as pd
from datetime import datetime, timedelta, date
import group2setting
import boto3
from sqlalchemy import create_engine
from io import StringIO


def load_311_daily_data_from_s3(selected_date_str):
    
    
    bucket = group2setting.s3_bucket
    file_name = "Group_2_311_daily{}.csv".format(selected_date_str)
    print(file_name)
    
    s3 = boto3.client('s3') 
    obj = s3.get_object(Bucket= bucket, Key= file_name) 
    
    data_sample = pd.read_csv(obj['Body'])
    
    print(data_sample.shape)
    
    #print(data_sample.columns)
    sub_df = data_sample.loc[:, ['unique_key', 'created_date','closed_date',
                                'agency','agency_name','complaint_type',
                                'descriptor','incident_zip','city',
                                'status','resolution_description',
                                'resolution_action_updated_date','borough','open_data_channel_type',
                                'latitude','longitude']]
    return sub_df


def save_into_rds_by_name(sub_df, table_name = 't_311_items'):
    
    print(sub_df.shape)
    
    # create engine by sqlalchemy + pymysql
    engine = create_engine(group2setting.rds_mysql_engine)
    
    # to transfer csv to mysql by pandas.to_sql
    sub_df.to_sql(con=engine, name=table_name, if_exists='append', index=False)
    
    print(table_name + " save into rds successfully")

    
# Defining lambda_handler function
def lambda_handler(event, context):
    selected_date = datetime.today() - timedelta(days = 1)
    selected_date_str = selected_date.strftime('%Y%m%d')
    
    sub_df = load_311_daily_data_from_s3(selected_date_str)
    
    save_into_rds_by_name(sub_df)