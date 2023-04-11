### Добро пожаловать

----

**Манифесты для создания Cloud Native приложения c помощью Kubernetes и DBaaS**

----

### Stage 0

Создать в панели управления проект, пользователя и выдать ему права администратора проекта.
В дальнейшем нам понадобятся имя пользователя, пароль, его ID.

Добыть в настройках профиль ключ API.

Заполнить secrets.tfvars по подобию secrets-example.tfvars.

Сгенерировать логин/пароль для DBaaS.

Создать новый реестр Container registry и получить новый токен.

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

Создать кластер MKS

```
terraform apply -var-file=secrets.tfvars -target=module.MKS

```

Сходить в панель управления и в нужном проекте на вкладке Kubernetes выбрать свой кластерт, скачать kubeconfig и положить его с именем config в директорию files/kube текущего репозитория.


### Stage 3

## Cloud

```
terraform apply -var-file=secrets.tfvars -target=module.Cloud

```

### Stage 4

До встречи в эфире!

### Stage 5

Для удаления всех ресурсов используйте команду destroy

```
terraform destroy -var-file=secrets.tfvars
```
