### Добро пожаловать

----

**Манифесты для создания Cloud Native приложения c помощью Kubernetes и DBaaS**

----
![image](https://user-images.githubusercontent.com/58259937/231564744-7e03bfb2-7ceb-46b9-a90f-1e05620b4dc7.png)

Приложение работает в Managed Kubernetes, образ контейнера в Container Registry. Визуализация в Grafana , которая развернута на отдельной виртуальной машине, на которой также развернут GitLab.
Данные для приложения в PostgreSQL, которая работает в Managed Database.

Наша задача:
Подготовить pipeline в Gitlab, с помощью которого будет автоматизирован процесс сборки и деплоя приложения (build → push → deploy)


### Stage 0

Создать в панели управления [проект](https://docs.selectel.ru/cloud/servers/about/projects/#создать-проект), [пользователя](https://docs.selectel.ru/cloud/servers/about/projects/#добавить-пользователя-с-доступом-к-проекту) и выдать ему права администратора проекта.
В дальнейшем нам понадобятся имя пользователя, пароль, его ID.

Добыть в настройках профиля [ключ API](https://docs.selectel.ru/control-panel-actions/account/api-keys/).

Заполнить secrets.tfvars по подобию secrets-example.tfvars.

Сгенерировать логин/пароль для DBaaS.

[Создать новый](https://docs.selectel.ru/cloud/craas/quickstart/) реестр Container registry и получить новый токен.

## Prerequisites

Выполнить подготовку инфраструктуры

```
terraform init
terraform apply -var-file=secrets.tfvars -target=module.Pre_Cloud

```

### Stage 1

## DBaaS

Создать Базу данных

```
terraform apply -var-file=secrets.tfvars -target=module.DBaaS

```

### Stage 2

## MKS

Создать кластер Managed Kubernetes Selectel (MKS).

```
terraform apply -var-file=secrets.tfvars -target=module.MKS

```

Во время выполнения этой части, будет локально сохранен kubeconfig. Он будет скопирован на control node в следующем шаге.

### Stage 3

## Cloud

```
terraform apply -var-file=secrets.tfvars -target=module.Cloud

```

Для того, чтобы кластер MKS мог скачивать образы из CRaaS, нужно добавить ключ. Для этого потребуется выполнить две команды. Обратите внимание, что во второй команде нужно передать путь до конифга находящегося в домашней папке пользователя.

```
docker login cr.selcloud.ru

kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=~/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson

```

### Stage 4

До встречи в эфире!

### Stage 5

Для удаления всех ресурсов используйте команду `destroy`

```
terraform destroy -var-file=secrets.tfvars
```
