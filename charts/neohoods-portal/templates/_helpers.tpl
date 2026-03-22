{{/*
  JSON for DOMAIN_TENANT_MAP_JSON (frontend): host -> tenant slug for / → /tenants/<slug>/residents and post-login redirect.

  - Auto: each entry in tenants.ingress with host + enabled adds map[host]=slug.
  - Merge: frontend.domainTenantMap overwrites (extra hosts or override).

  Keep tenants.ingress and domainTenantMap aligned with Auth0 Allowed Callback URLs (https://<host>/token-exchange per host).
*/}}
{{- define "neohoods-portal.domainTenantMapJson" -}}
{{- $fromIngress := dict }}
{{- range $slug, $cfg := (.Values.tenants.ingress | default dict) }}
{{- if and $cfg (kindIs "map" $cfg) $cfg.host (default true $cfg.enabled) }}
{{- $_ := set $fromIngress $cfg.host $slug }}
{{- end }}
{{- end }}
{{- $explicit := .Values.frontend.domainTenantMap | default dict }}
{{- mergeOverwrite $fromIngress $explicit | toJson }}
{{- end }}
