#!/bin/bash

# Script pour tester le backup manuellement pour le portal
# Usage: ./test-backup.sh [namespace] [cronjob-name]

NAMESPACE="${1:-platform}"
CRONJOB_NAME="${2:-portal-terresdelaya-db-backup}"

echo "🔍 Recherche du CronJob: $CRONJOB_NAME dans le namespace: $NAMESPACE"

# Vérifier que le CronJob existe
if ! kubectl get cronjob "$CRONJOB_NAME" -n "$NAMESPACE" &>/dev/null; then
    echo "❌ CronJob '$CRONJOB_NAME' introuvable dans le namespace '$NAMESPACE'"
    echo "💡 Vérifiez que le backup est activé et que le chart a été déployé"
    echo ""
    echo "📋 CronJobs disponibles dans $NAMESPACE:"
    kubectl get cronjobs -n "$NAMESPACE" 2>/dev/null || echo "Aucun CronJob trouvé"
    exit 1
fi

echo "✅ CronJob trouvé"
echo "🚀 Création d'un Job à partir du CronJob..."

# Créer un Job à partir du CronJob
JOB_NAME="backup-test-$(date +%s)"
kubectl create job "$JOB_NAME" --from=cronjob/"$CRONJOB_NAME" -n "$NAMESPACE"

echo "✅ Job créé: $JOB_NAME"
echo "📊 Suivi du Job (Ctrl+C pour arrêter le suivi)..."
echo ""

# Suivre les logs du Job
kubectl wait --for=condition=ready pod -l job-name="$JOB_NAME" -n "$NAMESPACE" --timeout=60s || true

# Attendre que le pod soit créé
sleep 2

# Récupérer le nom du pod
POD_NAME=$(kubectl get pods -l job-name="$JOB_NAME" -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ -z "$POD_NAME" ]; then
    echo "⏳ Attente de la création du pod..."
    sleep 5
    POD_NAME=$(kubectl get pods -l job-name="$JOB_NAME" -n "$NAMESPACE" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
fi

if [ -n "$POD_NAME" ]; then
    echo "📝 Affichage des logs du pod: $POD_NAME"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    kubectl logs -f "$POD_NAME" -n "$NAMESPACE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Vérifier le statut du Job
    echo ""
    echo "📊 Statut du Job:"
    kubectl get job "$JOB_NAME" -n "$NAMESPACE"
    
    # Vérifier le statut du pod
    echo ""
    echo "📊 Statut du Pod:"
    kubectl get pod "$POD_NAME" -n "$NAMESPACE"
    
    # Afficher les événements si le job a échoué
    JOB_STATUS=$(kubectl get job "$JOB_NAME" -n "$NAMESPACE" -o jsonpath='{.status.conditions[?(@.type=="Complete")].status}' 2>/dev/null)
    if [ "$JOB_STATUS" != "True" ]; then
        echo ""
        echo "⚠️  Le Job semble avoir échoué. Événements:"
        kubectl describe job "$JOB_NAME" -n "$NAMESPACE" | grep -A 10 "Events:"
    fi
else
    echo "❌ Impossible de trouver le pod du Job"
    echo "📊 État du Job:"
    kubectl describe job "$JOB_NAME" -n "$NAMESPACE"
fi

echo ""
echo "💡 Pour nettoyer le Job de test:"
echo "   kubectl delete job $JOB_NAME -n $NAMESPACE"

