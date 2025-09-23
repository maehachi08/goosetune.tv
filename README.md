# goosetunetv

goosetune.tv

## Development Environment

### Prepare

- Docker 及び Docker Compose のインストール

### Run Containers

1. `env.sample` から `.env` を作成しMySQLデータベース ユーザパスワードを設定する
   - docker-compose は `.env` というファイルを環境変数ファイルとして自動的に読み込みます ([refs](https://docs.docker.jp/compose/environment-variables.html))

   ```
   cp env.sample .env
   vim .env
   ```

1. `docker compose up`
   - 起動するapiコンテナはRails codeをボリュームマウントしており、修正が即時に反映されます
   - MySQLデータベースのみコンテナ起動し、`rails s` で起動したい場合は `docker-compose up` の後に `docker-compose stop api`を実行することでrails appコンテナを停止できます

   ```
   docker compose up -d

   # 起動後のログを確認する場合
   docker compose logs -f
   ```

## Production

### Prepare

- packコマンド のインストール
   - https://buildpacks.io/docs/tools/pack/
      - [Cloud Native Buildpacks](https://buildpacks.io/)が公開しているCLI Tool
      - applicationコンテナイメージのビルドには (Dockerfileを必要としない)Cloud Native Buildpacksを利用する

      ```
      brew install buildpacks/tap/pack
      ```

### Build Application Container Image

```
pack build goosetunetv:latest \
  --builder paketobuildpacks/builder-jammy-full \
  --buildpack paketo-buildpacks/ruby \
  --env BP_MRI_VERSION=3.3.5 \
  --pull-policy always
```

### Deploy

```
docker tag goosetunetv:latest ${AWS_ACCOUNT}.dkr.ecr.ap-northeast-1.amazonaws.com/goosetunetv:latest
docker push 375144106126.dkr.ecr.ap-northeast-1.amazonaws.com/goosetunetv:latest
```

### Update the ecs service

```
aws ecs update-service \
  --cluster goosetunetv \
  --service goosetunetv \
  --force-new-deployment
```

