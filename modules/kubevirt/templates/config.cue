package templates

import (
	timoniv1 "cuebernetes.orvis.io/timoni/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: timoniv1.#Module & {
	targetNamespace: string
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config & {}

	_operator: #KubeVirtOperator & {#config: config}
	objects: _operator.objects
	objects: kubevirt: #KubeVirt & {#config: config}
}
