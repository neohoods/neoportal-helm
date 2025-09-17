# Observabilité avec OpenTelemetry

Ce document explique comment configurer l'observabilité pour l'application NeoHoods Portal avec OpenTelemetry.

## Architecture

L'application utilise OpenTelemetry pour collecter :

- **Traces** : Suivi des requêtes et opérations
- **Métriques** : Métriques d'application et système
- **Logs** : Logs structurés avec corrélation des traces

## Configuration

### Développement Local

En développement local, OpenTelemetry est **désactivé** par défaut pour éviter les erreurs de connexion. Les logs sont affichés au format console lisible.

### Production (Kubernetes)

En production, OpenTelemetry est activé et envoie les données vers votre stack d'observabilité existant :

- **Tempo** : Collecte et stockage des traces
- **Prometheus** : Collecte des métriques
- **Loki** : Collecte des logs
- **Grafana** : Visualisation unifiée

## Déploiement

### Stack d'Observabilité Existant

Votre cluster utilise déjà un stack d'observabilité complet :

- **Tempo** : `tempo-0` dans le namespace `observability`
- **Loki** : `loki-0` dans le namespace `observability`
- **Prometheus** : `prometheus-kube-prom-stack-kube-prome-prometheus-0` dans le namespace `observability`
- **Grafana** : `kube-prom-stack-grafana-c5b5bf7d-s78m5` dans le namespace `observability`

### Déployer l'application avec OpenTelemetry

```bash
helm install neohoods-portal ./charts/neohoods-portal --namespace platform
```

## Configuration des Variables d'Environnement

Les variables d'environnement suivantes contrôlent OpenTelemetry :

- `MANAGEMENT_OTLP_METRICS_ENABLED` : Active/désactive l'export des métriques
- `MANAGEMENT_OTLP_TRACING_ENABLED` : Active/désactive l'export des traces
- `MANAGEMENT_METRICS_EXPORT_OTLP_ENABLED` : Active/désactive l'export des métriques OTLP
- `MANAGEMENT_OTLP_METRICS_URL` : URL du collecteur pour les métriques
- `MANAGEMENT_OTLP_TRACING_URL` : URL du collecteur pour les traces
- `MANAGEMENT_METRICS_EXPORT_OTLP_URL` : URL du collecteur pour l'export des métriques

## Monitoring

### Accès aux interfaces

- **Grafana** : Interface principale pour visualiser traces, métriques et logs
- **Prometheus** : `http://prometheus.observability.svc.cluster.local:9090`
- **Loki** : `http://loki.observability.svc.cluster.local:3100`
- **Tempo** : `http://tempo.observability.svc.cluster.local:3200`

### Métriques disponibles

L'application expose des métriques sur `/api/actuator/prometheus` :

- `http_server_requests_seconds` : Durée des requêtes HTTP
- `jvm_memory_used_bytes` : Utilisation mémoire JVM
- `jvm_gc_pause_seconds` : Pauses du garbage collector
- `hikaricp_connections_active` : Connexions actives à la base de données

## Dépannage

### Erreurs de connexion OTLP

Si vous voyez des erreurs `Connection refused` pour OTLP :

1. Vérifiez que Tempo est accessible sur `tempo.observability.svc.cluster.local:4317`
2. Vérifiez que les URLs de configuration sont correctes
3. En développement local, désactivez OpenTelemetry avec `enabled: false`

### Logs non structurés

Si les logs ne sont pas au format JSON en production :

1. Vérifiez que `SPRING_PROFILES_ACTIVE=production`
2. Vérifiez la configuration `logback-spring.xml`

## Personnalisation

Pour personnaliser la configuration OpenTelemetry, modifiez :

- `application-prod.yml` : Configuration Spring Boot
- `values.yaml` : Variables d'environnement Helm

## Intégration avec Grafana

Votre stack Grafana peut être configuré pour :

1. **Traces** : Ajouter Tempo comme source de données
2. **Métriques** : Ajouter Prometheus comme source de données
3. **Logs** : Ajouter Loki comme source de données
4. **Corrélation** : Utiliser les traceId/spanId pour corréler traces, métriques et logs
