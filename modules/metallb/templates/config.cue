package templates

import (
	timoniv1 "cuebernetes.orvis.io/timoni/core/v1alpha1"
)

// Config defines the schema and defaults for the Instance values.
#Config: timoniv1.#Module & timoniv1.#HelmReleaseConfig & {
}

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config & {}

	_release: timoniv1.#HelmRelease & {#config: config}
	objects: _release.objects
}