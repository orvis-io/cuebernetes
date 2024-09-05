package v1alpha1

import (
	"strings"

	helmv2 "helm.toolkit.fluxcd.io/helmrelease/v2"
	sourcev1 "source.toolkit.fluxcd.io/helmrepository/v1"
	sourcev1beta2 "source.toolkit.fluxcd.io/ocirepository/v1beta2"
	timoniv1 "timoni.sh/core/v1alpha1"
	corev1 "k8s.io/api/core/v1"
)

#HelmReleaseConfig: {
	repository: {
		url!: string & =~"^(http|https|oci)://.*$"
		auth?: {
			username!: string
			password!: string
		}
		provider: *"generic" | "aws" | "azure" | "gcp"
		insecure: *false | bool
	}
	chart: {
		name!:   string
		version: string | *"*"
	}
	sync: {
		retries:             int | *-1
		interval:            int | *60
		timeout:             int | *5
		serviceAccountName?: string
		targetNamespace?:    string
	}
	driftDetection?: "enabled" | "warn" | "disabled"
	dependsOn?: [...{
		name:       string
		namespace?: string
	}]
	helmValues?: {...}
	...
}

_Namespace: corev1.#Namespace & {
	_config: #HelmReleaseConfig
	apiVersion: "v1"
	kind: "Namespace"
	if _config.sync.targetNamespace != _|_ {
		metadata: name: _config.sync.targetNamespace
	}
}

_HelmRelease: helmv2.#HelmRelease & {
	_config:  #HelmReleaseConfig
	metadata: _config.metadata
	spec: helmv2.#HelmReleaseSpec & {
		releaseName: "\(_config.metadata.name)"
		interval:    "\(_config.sync.interval)m"
		timeout:     "\(_config.sync.timeout)m"

		if _config.sync.targetNamespace != _|_ {
			targetNamespace:  "\(_config.sync.targetNamespace)"
			storageNamespace: "\(_config.sync.targetNamespace)"
		}

		if _config.sync.serviceAccountName != _|_ {
			serviceAccountName: _config.sync.serviceAccountName
		}

		if !strings.HasPrefix(_config.repository.url, "oci://") {
			chart: {
				metadata: {
					labels: _config.metadata.labels
					if _config.metadata.annotations != _|_ {
						annotations: _config.metadata.annotations
					}
				}
				spec: {
					chart:   "\(_config.chart.name)"
					version: "\(_config.chart.version)"
					sourceRef: {
						kind: "HelmRepository"
						name: "\(_config.metadata.name)"
					}
					interval: "\(_config.sync.interval)m"
				}
			}
		}

		if strings.HasPrefix(_config.repository.url, "oci://") {
			chartRef: {
				kind: "OCIRepository"
				name: "\(_config.metadata.name)"
			}
		}

		install: {
			crds: "Create"
			remediation: retries: _config.sync.retries
		}

		upgrade: {
			crds: "CreateReplace"
			remediation: retries: _config.sync.retries
		}

		if _config.helmValues != _|_ {
			values: _config.helmValues
		}

		if _config.dependsOn != _|_ {
			dependsOn: _config.dependsOn
		}

		if _config.driftDetection != _|_ {
			driftDetection: mode: _config.driftDetection
		}
	}

  ...
}

_HelmRepository: sourcev1.#HelmRepository & {
	_config:  #HelmReleaseConfig
	metadata: _config.metadata
	spec: sourcev1.#HelmRepositorySpec & {
		interval: "12h"
		url:      _config.repository.url
		if _config.repository.auth != _|_ {
			secretRef: name: "\(_config.metadata.name)-helm-auth"
		}
		if _config.repository.insecure {
			insecure: true
		}
		provider: _config.repository.provider
	}
}

_HelmRepositoryAuth: {
	_config:    #HelmReleaseConfig
	apiVersion: "v1"
	kind:       "Secret"
	metadata: {
		name:      "\(_config.metadata.name)-helm-auth"
		namespace: _config.metadata.namespace
		labels:    _config.metadata.labels
		if _config.metadata.annotations != _|_ {
			annotations: _config.metadata.annotations
		}
	}
	stringData: {
		if _config.repository.auth != _|_ {
			username: _config.repository.auth.username
			password: _config.repository.auth.password
		}
	}
}

_OCIRepository: sourcev1beta2.#OCIRepository & {
	_config:  #HelmReleaseConfig
	metadata: _config.metadata
	spec: sourcev1beta2.#OCIRepositorySpec & {
		interval: "\(_config.sync.interval)m"
		url:      _config.repository.url + "/" + _config.chart.name
		ref: semver: _config.chart.version
		provider: _config.repository.provider
		if _config.repository.auth != _|_ {
			secretRef: name: "\(_config.metadata.name)-helm-auth"
		}
		if _config.repository.insecure {
			insecure: _config.repository.insecure
		}
	}
}

_OCIRepositoryAuth: timoniv1.#ImagePullSecret & {
	_config:   #HelmReleaseConfig
	#Meta:     _config.metadata
	#Suffix:   "-helm-auth"
	#Registry: strings.Split(_config.repository.url, "/")[2]
	#Username: _config.repository.auth.username
	#Password: _config.repository.auth.password
}

#HelmRelease: {
	#config: #HelmReleaseConfig

	objects: release: _HelmRelease & {_config: #config}

	if #config.sync.targetNamespace != _|_ {
		objects: namespace: _Namespace & {_config: #config}
	}

	if strings.HasPrefix(#config.repository.url, "oci://") {
		objects: repository: _OCIRepository & {_config: #config}
		if #config.repository.auth != _|_ {
			objects: secret: _OCIRepositoryAuth & {_config: #config}
		}
	}

	if !strings.HasPrefix(#config.repository.url, "oci://") {
		objects: repository: _HelmRepository & {_config: #config}
		if #config.repository.auth != _|_ {
			objects: secret: _HelmRepositoryAuth & {_config: #config}
		}
	}
}
