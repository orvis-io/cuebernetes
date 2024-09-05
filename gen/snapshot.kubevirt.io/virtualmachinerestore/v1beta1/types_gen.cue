// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f crds.yaml

package v1beta1

import "strings"

// VirtualMachineRestore defines the operation of restoring a VM
#VirtualMachineRestore: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "snapshot.kubevirt.io/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "VirtualMachineRestore"
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

	// VirtualMachineRestoreSpec is the spec for a
	// VirtualMachineRestoreresource
	spec!: #VirtualMachineRestoreSpec
}

// VirtualMachineRestoreSpec is the spec for a
// VirtualMachineRestoreresource
#VirtualMachineRestoreSpec: {
	// If the target for the restore does not exist, it will be
	// created. Patches holds JSON patches that would be
	// applied to the target manifest before it's created. Patches
	// should fit the target's Kind.
	//
	//
	// Example for a patch: {"op": "replace", "path":
	// "/metadata/name", "value": "new-vm-name"}
	patches?: [...string]

	// initially only VirtualMachine type supported
	target: {
		// APIGroup is the group for the resource being referenced.
		// If APIGroup is not specified, the specified Kind must be in the
		// core API group.
		// For any other third-party types, APIGroup is required.
		apiGroup?: string

		// Kind is the type of resource being referenced
		kind: string

		// Name is the name of resource being referenced
		name: string
	}
	virtualMachineSnapshotName: string
}
