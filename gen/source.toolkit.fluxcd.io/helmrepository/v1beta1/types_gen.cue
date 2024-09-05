// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

package v1beta1

import "strings"

// HelmRepository is the Schema for the helmrepositories API
#HelmRepository: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "source.toolkit.fluxcd.io/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "HelmRepository"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace!: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}

	// HelmRepositorySpec defines the reference to a Helm repository.
	spec!: #HelmRepositorySpec
}

// HelmRepositorySpec defines the reference to a Helm repository.
#HelmRepositorySpec: {
	accessFrom?: {
		// NamespaceSelectors is the list of namespace selectors to which
		// this ACL applies.
		// Items in this list are evaluated using a logical OR operation.
		namespaceSelectors: [...{
			// MatchLabels is a map of {key,value} pairs. A single {key,value}
			// in the matchLabels
			// map is equivalent to an element of matchExpressions, whose key
			// field is "key", the
			// operator is "In", and the values array contains only "value".
			// The requirements are ANDed.
			matchLabels?: {
				[string]: string
			}
		}]
	}

	// The interval at which to check the upstream for updates.
	interval: string

	// PassCredentials allows the credentials from the SecretRef to be
	// passed on to
	// a host that does not match the host as defined in URL.
	// This may be required if the host of the advertised chart URLs
	// in the index
	// differ from the defined URL.
	// Enabling this should be done with caution, as it can
	// potentially result in
	// credentials getting stolen in a MITM-attack.
	passCredentials?: bool
	secretRef?: {
		// Name of the referent.
		name: string
	}

	// This flag tells the controller to suspend the reconciliation of
	// this source.
	suspend?: bool

	// The timeout of index downloading, defaults to 60s.
	timeout?: string | *"60s"

	// The Helm repository URL, a valid URL contains at least a
	// protocol and host.
	url: string
}
