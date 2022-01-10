# kube-trial

お試し k8s

## やりたいこと

- front は apache
- back は spring
- ProxyPass で apache へのアクセスを spring に流す

### front

1. `t45k/httpd`に ProxyPass を設定した httpd のイメージを push
2. `kubectl apply -f front-deployment.yaml`
3. `kubectl expose deploy/httpd-deployment --port=80 --type=NodePort`
   - TODO: `service.yaml`を書く
4. `minikube service httpd-deployment --url`で url を取得
5. url にアクセスして、apache の初期画面が表示されることを確認

### back

1. Spring Initializer で適当なプロジェクトを作成
2. `kubectl apply -f back-deployment.yaml`
3. `kubectl expose deploy/spring-deployment --port=8080 --type=NodePort`
4. `minikue service spring-deployment --url`
5. url アクセス。spring の初期画面が表示されることを確認

### ProxyPass

- メモ
  - `service.namespace.svc.cluster.local`で名前解決ができる
    - minikube の namespace は`default`
  - pod の更新は`kubectl set image deployment/httpd-deployment httpd=t45k/httpd:latest --record`でいけそう

1. httpd の`httpd.conf`内で ProxyPass を設定する

```
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so

ProxyPass /spring http://spring-deployment.default.svc.cluster.local:8080
```

2. 両サービスを deploy、svc 起動
3. `minikube service httpd-deployment -url`
4. url/spring にアクセス

お疲れ様でした
