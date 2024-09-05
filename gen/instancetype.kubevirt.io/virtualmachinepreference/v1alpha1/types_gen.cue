// Code generated by timoni. DO NOT EDIT.

//timoni:generate timoni vendor crd -f crds.yaml

package v1alpha1

import "strings"

// VirtualMachinePreference resource contains optional preferences
// related to the VirtualMachine.
#VirtualMachinePreference: {
	// APIVersion defines the versioned schema of this representation
	// of an object.
	// Servers should convert recognized schemas to the latest
	// internal value, and
	// may reject unrecognized values.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	apiVersion: "instancetype.kubevirt.io/v1alpha1"

	// Kind is a string value representing the REST resource this
	// object represents.
	// Servers may infer this from the endpoint the client submits
	// requests to.
	// Cannot be updated.
	// In CamelCase.
	// More info:
	// https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	kind: "VirtualMachinePreference"
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

	// Required spec describing the preferences
	spec!: #VirtualMachinePreferenceSpec
}

// Required spec describing the preferences
#VirtualMachinePreferenceSpec: {
	// Optionally defines preferred Annotations to be applied to the
	// VirtualMachineInstance
	annotations?: {
		[string]: string
	}

	// Clock optionally defines preferences associated with the Clock
	// attribute of a VirtualMachineInstance DomainSpec
	clock?: {
		// ClockOffset allows specifying the UTC offset or the timezone of
		// the guest clock.
		preferredClockOffset?: {
			// Timezone sets the guest clock to the specified timezone.
			// Zone name follows the TZ environment variable format (e.g.
			// 'America/New_York').
			timezone?: string
			utc?: {
				// OffsetSeconds specifies an offset in seconds, relative to UTC.
				// If set,
				// guest changes to the clock will be kept during reboots and not
				// reset.
				offsetSeconds?: int
			}
		}

		// Timer specifies whih timers are attached to the vmi.
		preferredTimer?: {
			// HPET (High Precision Event Timer) - multiple timers with
			// periodic interrupts.
			hpet?: {
				// Enabled set to false makes sure that the machine type or a
				// preset can't add the timer.
				// Defaults to true.
				present?: bool

				// TickPolicy determines what happens when QEMU misses a deadline
				// for injecting a tick to the guest.
				// One of "delay", "catchup", "merge", "discard".
				tickPolicy?: string
			}
			hyperv?: {
				// Enabled set to false makes sure that the machine type or a
				// preset can't add the timer.
				// Defaults to true.
				present?: bool
			}
			kvm?: {
				// Enabled set to false makes sure that the machine type or a
				// preset can't add the timer.
				// Defaults to true.
				present?: bool
			}

			// PIT (Programmable Interval Timer) - a timer with periodic
			// interrupts.
			pit?: {
				// Enabled set to false makes sure that the machine type or a
				// preset can't add the timer.
				// Defaults to true.
				present?: bool

				// TickPolicy determines what happens when QEMU misses a deadline
				// for injecting a tick to the guest.
				// One of "delay", "catchup", "discard".
				tickPolicy?: string
			}

			// RTC (Real Time Clock) - a continuously running timer with
			// periodic interrupts.
			rtc?: {
				// Enabled set to false makes sure that the machine type or a
				// preset can't add the timer.
				// Defaults to true.
				present?: bool

				// TickPolicy determines what happens when QEMU misses a deadline
				// for injecting a tick to the guest.
				// One of "delay", "catchup".
				tickPolicy?: string

				// Track the guest or the wall clock.
				track?: string
			}
		}
	}

	// CPU optionally defines preferences associated with the CPU
	// attribute of a VirtualMachineInstance DomainSpec
	cpu?: {
		// PreferredCPUFeatures optionally defines a slice of preferred
		// CPU features.
		preferredCPUFeatures?: [...{
			// Name of the CPU feature
			name: string

			// Policy is the CPU feature attribute which can have the
			// following attributes:
			// force - The virtual CPU will claim the feature is supported
			// regardless of it being supported by host CPU.
			// require - Guest creation will fail unless the feature is
			// supported by the host CPU or the hypervisor is able to emulate
			// it.
			// optional - The feature will be supported by virtual CPU if and
			// only if it is supported by host CPU.
			// disable - The feature will not be supported by virtual CPU.
			// forbid - Guest creation will fail if the feature is supported
			// by host CPU.
			// Defaults to require
			policy?: string
		}]

		// PreferredCPUTopology optionally defines the preferred guest
		// visible CPU topology, defaults to PreferSockets.
		preferredCPUTopology?: string
		spreadOptions?: {
			// Across optionally defines how to spread vCPUs across the guest
			// visible topology.
			// Default: SocketsCores
			across?: string

			// Ratio optionally defines the ratio to spread vCPUs across the
			// guest visible topology:
			//
			//
			// CoresThreads - 1:2 - Controls the ratio of cores to threads.
			// Only a ratio of 2 is currently accepted.
			// SocketsCores - 1:N - Controls the ratio of socket to cores.
			// SocketsCoresThreads - 1:N:2 - Controls the ratio of socket to
			// cores. Each core providing 2 threads.
			//
			//
			// Default: 2
			ratio?: int
		}
	}

	// Devices optionally defines preferences associated with the
	// Devices attribute of a VirtualMachineInstance DomainSpec
	devices?: {
		// PreferredAutoattachGraphicsDevice optionally defines the
		// preferred value of AutoattachGraphicsDevice
		preferredAutoattachGraphicsDevice?: bool

		// PreferredAutoattachInputDevice optionally defines the preferred
		// value of AutoattachInputDevice
		preferredAutoattachInputDevice?: bool

		// PreferredAutoattachMemBalloon optionally defines the preferred
		// value of AutoattachMemBalloon
		preferredAutoattachMemBalloon?: bool

		// PreferredAutoattachPodInterface optionally defines the
		// preferred value of AutoattachPodInterface
		preferredAutoattachPodInterface?: bool

		// PreferredAutoattachSerialConsole optionally defines the
		// preferred value of AutoattachSerialConsole
		preferredAutoattachSerialConsole?: bool

		// PreferredBlockMultiQueue optionally enables the vhost
		// multiqueue feature for virtio disks.
		preferredBlockMultiQueue?: bool

		// PreferredCdromBus optionally defines the preferred bus for
		// Cdrom Disk devices.
		preferredCdromBus?: string

		// PreferredDisableHotplug optionally defines the preferred value
		// of DisableHotplug
		preferredDisableHotplug?: bool

		// PreferredBlockSize optionally defines the block size of Disk
		// devices.
		preferredDiskBlockSize?: {
			// CustomBlockSize represents the desired logical and physical
			// block size for a VM disk.
			custom?: {
				logical:  int
				physical: int
			}
			matchVolume?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
		}

		// PreferredDiskBus optionally defines the preferred bus for Disk
		// Disk devices.
		preferredDiskBus?: string

		// PreferredCache optionally defines the DriverCache to be used by
		// Disk devices.
		preferredDiskCache?: string

		// PreferredDedicatedIoThread optionally enables dedicated IO
		// threads for Disk devices using the virtio bus.
		preferredDiskDedicatedIoThread?: bool

		// PreferredIo optionally defines the QEMU disk IO mode to be used
		// by Disk devices.
		preferredDiskIO?: string

		// PreferredInputBus optionally defines the preferred bus for
		// Input devices.
		preferredInputBus?: string

		// PreferredInputType optionally defines the preferred type for
		// Input devices.
		preferredInputType?: string

		// PreferredInterfaceMasquerade optionally defines the preferred
		// masquerade configuration to use with each network interface.
		preferredInterfaceMasquerade?: {}

		// PreferredInterfaceModel optionally defines the preferred model
		// to be used by Interface devices.
		preferredInterfaceModel?: string

		// PreferredLunBus optionally defines the preferred bus for Lun
		// Disk devices.
		preferredLunBus?: string

		// PreferredNetworkInterfaceMultiQueue optionally enables the
		// vhost multiqueue feature for virtio interfaces.
		preferredNetworkInterfaceMultiQueue?: bool

		// PreferredRng optionally defines the preferred rng device to be
		// used.
		preferredRng?: {}

		// PreferredSoundModel optionally defines the preferred model for
		// Sound devices.
		preferredSoundModel?: string
		preferredTPM?: {
			// Persistent indicates the state of the TPM device should be kept
			// accross reboots
			// Defaults to false
			persistent?: bool
		}

		// PreferredUseVirtioTransitional optionally defines the preferred
		// value of UseVirtioTransitional
		preferredUseVirtioTransitional?: bool
		preferredVirtualGPUOptions?: {
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
	}

	// Features optionally defines preferences associated with the
	// Features attribute of a VirtualMachineInstance DomainSpec
	features?: {
		preferredAcpi?: {
			// Enabled determines if the feature should be enabled or disabled
			// on the guest.
			// Defaults to true.
			enabled?: bool
		}

		// PreferredApic optionally enables and configures the APIC
		// feature
		preferredApic?: {
			// Enabled determines if the feature should be enabled or disabled
			// on the guest.
			// Defaults to true.
			enabled?: bool

			// EndOfInterrupt enables the end of interrupt notification in the
			// guest.
			// Defaults to false.
			endOfInterrupt?: bool
		}

		// PreferredHyperv optionally enables and configures HyperV
		// features
		preferredHyperv?: {
			evmcs?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
			frequencies?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
			ipi?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
			reenlightenment?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
			relaxed?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
			reset?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
			runtime?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}

			// Spinlocks allows to configure the spinlock retry attempts.
			spinlocks?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool

				// Retries indicates the number of retries.
				// Must be a value greater or equal 4096.
				// Defaults to 4096.
				spinlocks?: int
			}
			synic?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}

			// SyNICTimer enables Synthetic Interrupt Controller Timers,
			// reducing CPU load.
			// Defaults to the machine type setting.
			synictimer?: {
				direct?: {
					// Enabled determines if the feature should be enabled or disabled
					// on the guest.
					// Defaults to true.
					enabled?: bool
				}
				enabled?: bool
			}
			tlbflush?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
			vapic?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}

			// VendorID allows setting the hypervisor vendor id.
			// Defaults to the machine type setting.
			vendorid?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool

				// VendorID sets the hypervisor vendor id, visible to the vmi.
				// String up to twelve characters.
				vendorid?: string
			}
			vpindex?: {
				// Enabled determines if the feature should be enabled or disabled
				// on the guest.
				// Defaults to true.
				enabled?: bool
			}
		}
		preferredKvm?: {
			// Hide the KVM hypervisor from standard MSR based discovery.
			// Defaults to false
			hidden?: bool
		}
		preferredPvspinlock?: {
			// Enabled determines if the feature should be enabled or disabled
			// on the guest.
			// Defaults to true.
			enabled?: bool
		}
		preferredSmm?: {
			// Enabled determines if the feature should be enabled or disabled
			// on the guest.
			// Defaults to true.
			enabled?: bool
		}
	}

	// Firmware optionally defines preferences associated with the
	// Firmware attribute of a VirtualMachineInstance DomainSpec
	firmware?: {
		// PreferredUseBios optionally enables BIOS
		preferredUseBios?: bool

		// PreferredUseBiosSerial optionally transmitts BIOS output over
		// the serial.
		//
		//
		// Requires PreferredUseBios to be enabled.
		preferredUseBiosSerial?: bool

		// PreferredUseEfi optionally enables EFI
		preferredUseEfi?: bool

		// PreferredUseSecureBoot optionally enables SecureBoot and the
		// OVMF roms will be swapped for SecureBoot-enabled ones.
		//
		//
		// Requires PreferredUseEfi and PreferredSmm to be enabled.
		preferredUseSecureBoot?: bool
	}
	machine?: {
		// PreferredMachineType optionally defines the preferred machine
		// type to use.
		preferredMachineType?: string
	}

	// PreferSpreadSocketToCoreRatio defines the ratio to spread vCPUs
	// between cores and sockets, it defaults to 2.
	preferSpreadSocketToCoreRatio?: int

	// Subdomain of the VirtualMachineInstance
	preferredSubdomain?: string

	// Grace period observed after signalling a VirtualMachineInstance
	// to stop after which the VirtualMachineInstance is force
	// terminated.
	preferredTerminationGracePeriodSeconds?: int

	// Requirements defines the minium amount of instance type defined
	// resources required by a set of preferences
	requirements?: {
		cpu?: {
			// Minimal number of vCPUs required by the preference.
			guest: int
		}
		memory?: {
			// Minimal amount of memory required by the preference.
			guest: (int | string) & {
				=~"^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
			}
		}
	}
	volumes?: {
		// PreffereedStorageClassName optionally defines the preferred
		// storageClass
		preferredStorageClassName?: string
	}
}
