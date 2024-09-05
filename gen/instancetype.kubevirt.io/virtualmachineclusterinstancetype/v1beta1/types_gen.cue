// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f crds.yaml

package v1beta1

import "strings"

// VirtualMachineClusterInstancetype is a cluster scoped version
// of VirtualMachineInstancetype resource.
#VirtualMachineClusterInstancetype: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "instancetype.kubevirt.io/v1beta1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "VirtualMachineClusterInstancetype"
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

	// Required spec describing the instancetype
	spec!: #VirtualMachineClusterInstancetypeSpec
}

// Required spec describing the instancetype
#VirtualMachineClusterInstancetypeSpec: {
	// Optionally defines the required Annotations to be used by the
	// instance type and applied to the VirtualMachineInstance
	annotations?: {
		[string]: string
	}

	// Required CPU related attributes of the instancetype.
	cpu: {
		// DedicatedCPUPlacement requests the scheduler to place the
		// VirtualMachineInstance on a node
		// with enough dedicated pCPUs and pin the vCPUs to it.
		dedicatedCPUPlacement?: bool

		// Required number of vCPUs to expose to the guest.
		//
		//
		// The resulting CPU topology being derived from the optional
		// PreferredCPUTopology attribute of CPUPreferences that itself
		// defaults to PreferSockets.
		guest: int

		// IsolateEmulatorThread requests one more dedicated pCPU to be
		// allocated for the VMI to place
		// the emulator thread on it.
		isolateEmulatorThread?: bool

		// MaxSockets specifies the maximum amount of sockets that can be
		// hotplugged
		maxSockets?: int

		// Model specifies the CPU model inside the VMI.
		// List of available models
		// https://github.com/libvirt/libvirt/tree/master/src/cpu_map.
		// It is possible to specify special cases like "host-passthrough"
		// to get the same CPU as the node
		// and "host-model" to get CPU closest to the node one.
		// Defaults to host-model.
		model?: string
		numa?: {
			// GuestMappingPassthrough will create an efficient guest topology
			// based on host CPUs exclusively assigned to a pod.
			// The created topology ensures that memory and CPUs on the
			// virtual numa nodes never cross boundaries of host numa nodes.
			guestMappingPassthrough?: {}
		}
		realtime?: {
			// Mask defines the vcpu mask expression that defines which vcpus
			// are used for realtime. Format matches libvirt's expressions.
			// Example: "0-3,^1","0,2,3","2-3"
			mask?: string
		}
	}

	// Optionally defines any GPU devices associated with the
	// instancetype.
	gpus?: [...{
		deviceName: string

		// Name of the GPU device as exposed by a device plugin
		name: string

		// If specified, the virtual network interface address and its tag
		// will be provided to the guest via config drive
		tag?: string
		virtualGPUOptions?: {
			display?: {
				// Enabled determines if a display addapter backed by a vGPU
				// should be enabled or disabled on the guest.
				// Defaults to true.
				enabled?: bool
				ramFB?: {
					// Enabled determines if the feature should be enabled or disabled
					// on the guest.
					// Defaults to true.
					enabled?: bool
				}
			}
		}
	}]

	// Optionally defines any HostDevices associated with the
	// instancetype.
	hostDevices?: [...{
		// DeviceName is the resource name of the host device exposed by a
		// device plugin
		deviceName: string
		name:       string

		// If specified, the virtual network interface address and its tag
		// will be provided to the guest via config drive
		tag?: string
	}]

	// Optionally defines the IOThreadsPolicy to be used by the
	// instancetype.
	ioThreadsPolicy?: string
	launchSecurity?: {
		// AMD Secure Encrypted Virtualization (SEV).
		sev?: {
			// If specified, run the attestation process for a vmi.
			attestation?: {}

			// Base64 encoded guest owner's Diffie-Hellman key.
			dhCert?: string
			policy?: {
				// SEV-ES is required.
				// Defaults to false.
				encryptedState?: bool
			}

			// Base64 encoded session blob.
			session?: string
		}
	}

	// Required Memory related attributes of the instancetype.
	memory: {
		// Required amount of memory which is visible inside the guest OS.
		guest: (int | string) & {
			=~"^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
		}
		hugepages?: {
			// PageSize specifies the hugepage size, for x86_64 architecture
			// valid values are 1Gi and 2Mi.
			pageSize?: string
		}

		// MaxGuest allows to specify the maximum amount of memory which
		// is visible inside the Guest OS.
		// The delta between MaxGuest and Guest is the amount of memory
		// that can be hot(un)plugged.
		maxGuest?: (int | string) & {
			=~"^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
		}

		// OvercommitPercent is the percentage of the guest memory which
		// will be overcommitted.
		// This means that the VMIs parent pod (virt-launcher) will
		// request less
		// physical memory by a factor specified by the OvercommitPercent.
		// Overcommits can lead to memory exhaustion, which in turn can
		// lead to crashes. Use carefully.
		// Defaults to 0
		overcommitPercent?: uint & <=100
	}

	// NodeSelector is a selector which must be true for the vmi to
	// fit on a node.
	// Selector which must match a node's labels for the vmi to be
	// scheduled on that node.
	// More info:
	// https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
	//
	//
	// NodeSelector is the name of the custom node selector for the
	// instancetype.
	nodeSelector?: {
		[string]: string
	}

	// If specified, the VMI will be dispatched by specified
	// scheduler.
	// If not specified, the VMI will be dispatched by default
	// scheduler.
	//
	//
	// SchedulerName is the name of the custom K8s scheduler for the
	// instancetype.
	schedulerName?: string
}
