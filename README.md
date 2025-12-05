- profile は自分の環境にあわせて設定すること
- 開発者を追加する場合、template-developerをコピーし、tfvarsを変更する

# dockerfileをECRにpushするときのコマンド
docker buildx build --platform linux/amd64 -t devenv-base-ecr:latest .

docker tag devenv-base-ecr:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/devenv-base-ecr:latest

aws ecr get-login-password --region ap-northeast-1 --profile <プロファイル名> --no-verify-ssl | docker login --username AWS --password-stdin <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com

docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/devenv-base-ecr:latest