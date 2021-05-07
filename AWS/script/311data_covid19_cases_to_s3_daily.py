import requests
import pandas as pd
import boto3
from datetime import datetime, timedelta
from io import StringIO

import group2setting

def load_daily_covid_case():
    file_name = 'https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/cases-by-day.csv'
    data_sample =pd.read_csv(file_name) 

    pd.set_option('display.max_columns', None)
    print(data_sample.shape)
    
    return data_sample

def save_daily_covid_case_into_s3(data_sample):

    filename = 'Group_2_nyc_covid19_cases_by_day.csv'
    bucketname = group2setting.s3_bucket
    
    print(bucketname)
    
    csv_buffer = StringIO()
    data_sample.to_csv(csv_buffer)
    
    client = boto3.client('s3')
    
    response = client.put_object(
        Body = csv_buffer.getvalue(),
        Bucket = bucketname,
        Key = filename
    )
    
    print(response)
    #print success message
    print("Successfull uploaded file to location:"+str(filename))

def load_daily_covid_caserate():
    file_name = 'https://raw.githubusercontent.com/nychealth/coronavirus-data/master/trends/caserate-by-modzcta.csv'
    data_sample =pd.read_csv(file_name) 

    pd.set_option('display.max_columns', None)
    print(data_sample.shape)
    
    return data_sample


def save_daily_covid_caserate_into_s3(data_sample):
    filename = 'Group_2_nyc_covid19_caserate_by_zipcode.csv'
    bucketname = group2setting.s3_bucket
    
    
    csv_buffer = StringIO()
    data_sample.to_csv(csv_buffer)
    
    client = boto3.client('s3')
    
    response = client.put_object(
        Body = csv_buffer.getvalue(),
        Bucket = bucketname,
        Key = filename
    )
    
    print(response)
    #print success message
    print("Successfull uploaded file to location:"+str(filename))


def lambda_handler(event, context):
    # load covid case
    case_sample = load_daily_covid_case()
    # save covid case to s3
    save_daily_covid_case_into_s3(case_sample)
    
    # load covid rate
    caserate_sample = load_daily_covid_caserate()
    # save covid case rate to s3
    save_daily_covid_caserate_into_s3(caserate_sample)