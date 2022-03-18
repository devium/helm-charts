{{/*
Expand the name of the chart.
*/}}
{{- define "workadventure.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "workadventure.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "workadventure.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "workadventure.labels" -}}
helm.sh/chart: {{ include "workadventure.chart" . }}
{{ include "workadventure.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "workadventure.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "workadventure.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "workadventure.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workadventure.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Back object names
*/}}
{{- define "workadventure.back.name" -}}
{{- printf "%s-%s" (include "workadventure.fullname" .) "back" }}
{{- end }}

{{/*
Front object names
*/}}
{{- define "workadventure.front.name" -}}
{{- printf "%s-%s" (include "workadventure.fullname" .) "front" }}
{{- end }}

{{/*
Pusher object names
*/}}
{{- define "workadventure.pusher.name" -}}
{{- printf "%s-%s" (include "workadventure.fullname" .) "pusher" }}
{{- end }}

{{/*
Uploader object names
*/}}
{{- define "workadventure.uploader.name" -}}
{{- printf "%s-%s" (include "workadventure.fullname" .) "uploader" }}
{{- end }}

{{/*
Maps object names
*/}}
{{- define "workadventure.maps.name" -}}
{{- printf "%s-%s" (include "workadventure.fullname" .) "maps" }}
{{- end }}

{{- define "workadventure.mapsUrl" -}}
{{- printf "%s.%s" .Values.maps.subdomain .Values.domain }}
{{- end }}

{{- define "workadventure.pusherUrl" -}}
{{- printf "//%s.%s" .Values.pusher.subdomain .Values.domain }}
{{- end }}

{{- define "workadventure.uploaderUrl" -}}
{{- printf "//%s.%s" .Values.uploader.subdomain .Values.domain }}
{{- end }}

{{- define "workadventure.pusher.apiUrl" -}}
{{- printf "%s:%s" (tpl .Values.back.svcUrl $) "50051" }}
{{- end }}

{{- define "workadventure.startRoomUrl" -}}
{{- $path := .Values.front.env.startRoomPath }}
{{- $universe := .Values.front.env.startRoomUniverse }}
{{- printf "/_/%s/%s%s" $universe (include "workadventure.mapsUrl" .) $path }}
{{- end }}