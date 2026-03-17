import os
import sys

from minio import Minio
from minio.error import S3Error

def upload_to_s3(s3_endpoint, s3_access_key, s3_secret_key, s3_bucket, path_file):
    client = Minio(s3_endpoint,
        access_key=s3_access_key,
        secret_key=s3_secret_key,
        secure=False,
    )

    path_file_split = path_file.split('/')

    path_in_storage = str('recordings/') + str(path_file_split[-1])

    client.fput_object(
        s3_bucket, path_in_storage, path_file,
    )

    os.remove(path_file)
if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python upload_s3.py <s3_endpoint> <s3_access_key> <s3_secret_key> <s3_bucket> <path_file>")
        sys.exit(1)

    s3_endpoint = sys.argv[1]
    s3_access_key = sys.argv[2]
    s3_secret_key = sys.argv[3]
    s3_bucket = sys.argv[4]
    path_file = sys.argv[5]    

    upload_to_s3(s3_endpoint, s3_access_key, s3_secret_key, s3_bucket, path_file)