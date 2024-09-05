// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f crds.yaml

package v1alpha1

import "strings"

// MigrationPolicy holds migration policy (i.e. configurations) to
// apply to a VM or group of VMs
#MigrationPolicy: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "migrations.kubevirt.io/v1alpha1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "MigrationPolicy"
	metadata!: {
		name!: strings.MaxRunes(253) & strings.MinRunes(1) & {
			string
		}
		namespace?: strings.MaxRunes(63) & strings.MinRunes(1) & {
			string
		}
		labels?: {
			[string]: string
		}
		annotations?: {
			[string]: string
		}
	}
	spec!: #MigrationPolicySpec
}
#MigrationPolicySpec: {
	allowAutoConverge?: bool
	allowPostCopy?:     bool
	bandwidthPerMigration?: (int | string) & {
		=~"^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
	}
	completionTimeoutPerGiB?: int
	selectors: {
		namespaceSelector?: {
			[string]: string
		}
		virtualMachineInstanceSelector?: {
			[string]: string
		}
	}
}
