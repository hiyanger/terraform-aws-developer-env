# dockerfileをECRにpushするときのコマンド

# ローカル
dockerfile 配置

# コマンド
docker buildx build --platform linux/amd64 -t devenv-base-ecr:latest .

docker tag devenv-base-ecr:latest <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/devenv-base-ecr:latest

aws ecr get-login-password --region ap-northeast-1 --profile <プロファイル名> --no-verify-ssl | docker login --username AWS --password-stdin <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com

docker push <アカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/devenv-base-ecr:latest

# タスク置き換え
ECSサービスからサービスの更新→「新しいデプロイの強制」にチェックして更新すれば
新しいECRが配置される（単純にタスク落としてあげなおしてもダメ）