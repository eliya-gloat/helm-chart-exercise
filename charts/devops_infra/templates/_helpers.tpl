{{- define "devops_infra.labels" -}}
app.kubernetes.io/name: {{ .Values.global.appName }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}
