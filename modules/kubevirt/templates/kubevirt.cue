package templates

import (
	kubevirtv1 "kubevirt.io/kubevirt/v1"
)

#KubeVirt: kubevirtv1.#KubeVirt & {
	#config: #Config
	metadata: {
		name: #config.metadata.name
		namespace: #config.targetNamespace
		labels:    #config.metadata.labels
		if #config.metadata.annotations != _|_ {
			annotations: #config.metadata.annotations
		}
	}
	spec: {
		certificateRotateStrategy: {}
		configuration: developerConfiguration: featureGates: []
		customizeComponents: {}
		imagePullPolicy: "IfNotPresent"
		workloadUpdateStrategy: {}
	}
}
