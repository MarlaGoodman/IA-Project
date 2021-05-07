import pymysql
import group2setting


hostName        = group2setting.rds_hostName
userName        = group2setting.rds_userName
userPassword    = group2setting.rds_userPassword
databaseName    = group2setting.rds_databaseName_311dw

databaseConnection   = pymysql.connect(host=hostName,
                                       user=userName,
                                       password=userPassword,
                                       db=databaseName)

def lambda_handler(event, context):
    try:
        cursor = databaseConnection.cursor()
        
        result = cursor.callproc('updateDimensionsProc')

        print(result)
        
    except Exception as e:
        
        print("Exeception occured:{}".format(e))

    finally:

        databaseConnection.close()