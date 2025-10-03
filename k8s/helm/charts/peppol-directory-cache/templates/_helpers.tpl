{{/*
Copyright Peinser BV

Generic utilities methods for Helm.
*/}}


{{/*
Yields to configured pullSecrets associated with the service. Currently,
the template will only yield the pullSecrets configured in the `defaults`
section of Values.yaml.
*/}}
{{- define "image.pullSecrets" -}}
{{- if $.Values.image.pullSecrets }}
imagePullSecrets:
{{ toYaml $.Values.image.pullSecrets }}
{{ end -}}
{{- end -}}


{{/*
A template returning the name of a service.
*/}}
{{- define "service.name" -}}
{{- printf "%s-service-%s" .release .name -}}
{{- end -}}


{{/*
Default annotations for the ingress resource.
*/}}
{{- define "ingress.defaultAnnotations" }}
nginx.archive.ingress.kubernetes.io/proxy-body-size: {{ $.Values.defaults.ingress.maxBodySize | quote }}
{{ if $.Values.defaults.ingress.clusterIssuer -}}
cert-manager.io/cluster-issuer: {{ $.Values.defaults.ingress.clusterIssuer | quote }}
{{- else -}}
{{- fail "defaults.ingress.clusterIssuer cannot be unspecified." -}}
{{- end }}
kubernetes.io/ingress.class: {{ $.Values.defaults.ingress.class | quote }}
{{- if $.Values.defaults.ingress.whitelist }}
nginx.ingress.kubernetes.io/whitelist-source-range: {{ $.Values.defaults.ingress.whitelist }}
{{- end -}}
{{- end -}}


{{/*
Yields the image tag with an optional digest, if specified.
*/}}
{{- define "image" -}}
{{- $tag := $.Values.image.tag | default "latest" -}}
{{- if $.Values.image.digest -}}
{{- $tag = $.Values.image.digest -}}
{{- end -}}
{{- $tag -}}
{{- end -}}


{{/*
Utility method yielding the number of configured replicas for a
service or worker.
*/}}
{{- define "deploy.replicas" -}}
{{- if .replicas -}}
{{- .replicas -}}
{{- else -}}
{{- $.Values.defaults.replicas -}}
{{- end -}}
{{- end -}}


{{/*
Configures health probes for a deployment based on the defaults,
or on the configuration, if it is present.

Note that, whenever the `debug` mode has been specified, health
probes will be disabled.
*/}}
{{- define "probes" -}}
{{- if not $.Values.image.debug -}}
{{- if .probes -}}
{{- fail "Service specific probes not implemented in template!" -}}
{{- end -}}
{{- with $.Values.defaults.probes -}}
{{- if .readiness.enabled -}}
readinessProbe: {{ omit .readiness "enabled" | toYaml | nindent 2 -}}
{{- end -}}
{{- if .liveness.enabled }}
livenessProbe: {{ omit .liveness "enabled" | toYaml | nindent 2 -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Configures the nodeSelector, affinity and tolerations based on
the defaults specification. Service specific configurations
are not yet supported.
*/}}
{{- define "service.constraints" -}}
{{- with .Values.defaults.nodeSelector }}
nodeSelector:
{{- toYaml . | nindent 2 }}
{{- end -}}
{{- with $.Values.defaults.affinity }}
affinity:
{{- toYaml . | nindent 2 }}
{{- end -}}
{{- with $.Values.defaults.tolerations }}
tolerations:
{{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}


{{/*
Yields to configured pullSecrets associated with the service. Currently,
the template will only yield the pullSecrets configured in the `defaults`
section of Values.yaml.
*/}}
{{- define "service.pullSecrets" -}}
{{- if $.Values.image.pullSecrets }}
imagePullSecrets:
{{ toYaml $.Values.image.pullSecrets }}
{{ end -}}
{{- end -}}
