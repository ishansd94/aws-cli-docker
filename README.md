```
    docker run -it -v $(pwd)/AWS_SECRET_ACCESS_KEY:<SECRETS_DIR>/AWS_SECRET_ACCESS_KEY -v $(pwd)/AWS_ACCESS_KEY_ID:<SECRETS_DIR>/AWS_ACCESS_KEY_ID aws-cli aws s3 ls
```