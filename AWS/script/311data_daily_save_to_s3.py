import requests
import pandas as pd
import boto3
from datetime import datetime, timedelta
from io import StringIO
import group2setting

def fetch_yesterday_311(yesterday):
    
    yesterday_start = yesterday.strftime('%Y-%m-%dT00:00:00')
    yesterday_end = yesterday.strftime('%Y-%m-%dT23:59:59')
    
    url = "https://data.cityofnewyork.us/resource/erm2-nwe9.json?$where=created_date between '{0}' and '{1}'&$limit=50000".format(yesterday_start,yesterday_end)

    print(url)
    
    r = requests.get(
        url,
        headers={"X-App-Token":"V1jlhtPUjWC0Lb3sr1QYKPCmm"}
    )
    
    df1 = pd.DataFrame()
    if r.status_code == 200:
        df1 = pd.DataFrame(r.json())
    
    print(df1.shape)
    
    df1 = df1[(df1['complaint_type'] == 'Noise - Residential') | (df1['complaint_type'] == 'Noise - Street/Sidewalk') | (df1['complaint_type'] == 'Noise - Vehicle')]
    
    print(df1.shape)
    
    return df1



def save_to_s3(df, yesterday):
    
    yesterday_start = yesterday.strftime('%Y%m%d')
    
    # s3://g2-final/readme.txt
    groupname= 'Group_2_311_daily' #name of your group
    
    filenames3 = "%s%s.csv"%(groupname, yesterday_start) #name of the filepath and csv file
    print(filenames3)
    
    bucketname = group2setting.s3_bucket
    
    csv_buffer = StringIO()
    df.to_csv(csv_buffer)
    
    client = boto3.client('s3')
    
    response = client.put_object(
        Body = csv_buffer.getvalue(),
        Bucket = bucketname,
        Key = filenames3
    )
    
    print(response)
    
    #print success message
    print("Successfull uploaded file to location:"+str(filenames3))


# Defining lambda_handler function
def lambda_handler(event, context):
    
    yesterday = datetime.today() - timedelta(days = 1)
    yesterday_start = yesterday.strftime('%Y-%m-%dT00:00:00')
    
    yesterday_df = fetch_yesterday_311(yesterday)

    save_to_s3(yesterday_df, yesterday)