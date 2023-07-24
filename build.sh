# GHA_RUNNER_SECRETの値は，GitHub側でrunner設定時に表示されるはずだよ
export GHA_RUNNER_SECRET="hogehoge"
export IMAGE_TAG="gha_runner:node18"

docker build -t ${IMAGE_TAG} --build-arg GHA_RUNNER_SECRET=${GHA_RUNNER_SECRET} .
