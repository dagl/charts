{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "wopiserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "wopiserver.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "wopiserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "wopiserver.labels" -}}
helm.sh/chart: {{ include "wopiserver.chart" . }}
{{ include "wopiserver.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "wopiserver.selectorLabels" -}}
app.kubernetes.io/name: {{ include "wopiserver.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "wopiserver.ingress.apiVersion" -}}
{{- if .Capabilities.APIVersions.Has "networking.k8s.io/v1/ingress" }}
{{- print "networking.k8s.io/v1" -}}
{{- else }}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end }}
{{- end -}}

{{/*
Returns the WOPI Server external URL
*/}}
{{- define "wopiserver.url" -}}
  {{- if .Values.wopiserverUrl -}}
    {{- .Values.wopiserverUrl }}
  {{- else }}
    {{- if .Values.ingress.hostname -}}
      {{- if .Values.ingress.tls -}}
        https://{{ .Values.ingress.hostname }}
      {{- else -}}
        http://{{ .Values.ingress.hostname }}
      {{- end -}}
    {{- else -}}
        http://{{ template "wopiserver.fullname" . }}:{{ .Values.service.port }}
    {{- end -}}
  {{- end -}}
{{- end -}}
