package templates

#KubeVirtOperator: {
	#config: #Config

	objects: {
		namespace: {
			apiVersion: "v1"
			kind:       "Namespace"
			metadata: {
				labels: {
					"kubevirt.io":                        ""
					"pod-security.kubernetes.io/enforce": "privileged"
				}
				name: #config.targetNamespace
			}
		}
		"kubevirts.kubevirt.io": {
			apiVersion: "apiextensions.k8s.io/v1"
			kind:       "CustomResourceDefinition"
			metadata: {
				labels: "operator.kubevirt.io": ""
				name: "kubevirts.kubevirt.io"
			}
			spec: {
				group: "kubevirt.io"
				names: {
					categories: ["all"]
					kind:   "KubeVirt"
					plural: "kubevirts"
					shortNames: [
						"kv",
						"kvs",
					]
					singular: "kubevirt"
				}
				scope: "Namespaced"
				versions: [{
					additionalPrinterColumns: [{
						jsonPath: ".metadata.creationTimestamp"
						name:     "Age"
						type:     "date"
					}, {
						jsonPath: ".status.phase"
						name:     "Phase"
						type:     "string"
					}]
					name: "v1"
					schema: openAPIV3Schema: {
						description: "KubeVirt represents the object deploying all KubeVirt resources"
						properties: {
							apiVersion: {
								description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
								type: "string"
							}
							kind: {
								description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
								type: "string"
							}
							metadata: type: "object"
							spec: {
								properties: {
									certificateRotateStrategy: {
										properties: selfSigned: {
											properties: {
												ca: {
													description: """
	CA configuration
	CA certs are kept in the CA bundle as long as they are valid
	"""
													properties: {
														duration: {
															description: "The requested 'duration' (i.e. lifetime) of the Certificate."
															type:        "string"
														}
														renewBefore: {
															description: """
	The amount of time before the currently issued certificate's "notAfter"
	time that we will begin to attempt to renew the certificate.
	"""
															type: "string"
														}
													}
													type: "object"
												}
												caOverlapInterval: {
													description: "Deprecated. Use CA.Duration and CA.RenewBefore instead"
													type:        "string"
												}
												caRotateInterval: {
													description: "Deprecated. Use CA.Duration instead"
													type:        "string"
												}
												certRotateInterval: {
													description: "Deprecated. Use Server.Duration instead"
													type:        "string"
												}
												server: {
													description: """
	Server configuration
	Certs are rotated and discarded
	"""
													properties: {
														duration: {
															description: "The requested 'duration' (i.e. lifetime) of the Certificate."
															type:        "string"
														}
														renewBefore: {
															description: """
	The amount of time before the currently issued certificate's "notAfter"
	time that we will begin to attempt to renew the certificate.
	"""
															type: "string"
														}
													}
													type: "object"
												}
											}
											type: "object"
										}
										type: "object"
									}
									configuration: {
										description: """
	holds kubevirt configurations.
	same as the virt-configMap
	"""
										properties: {
											additionalGuestMemoryOverheadRatio: {
												description: """
	AdditionalGuestMemoryOverheadRatio can be used to increase the virtualization infrastructure
	overhead. This is useful, since the calculation of this overhead is not accurate and cannot
	be entirely known in advance. The ratio that is being set determines by which factor to increase
	the overhead calculated by Kubevirt. A higher ratio means that the VMs would be less compromised
	by node pressures, but would mean that fewer VMs could be scheduled to a node.
	If not set, the default is 1.
	"""
												type: "string"
											}
											apiConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											architectureConfiguration: {
												properties: {
													amd64: {
														properties: {
															emulatedMachines: {
																items: type: "string"
																type:                     "array"
																"x-kubernetes-list-type": "atomic"
															}
															machineType: type: "string"
															ovmfPath: type:    "string"
														}
														type: "object"
													}
													arm64: {
														properties: {
															emulatedMachines: {
																items: type: "string"
																type:                     "array"
																"x-kubernetes-list-type": "atomic"
															}
															machineType: type: "string"
															ovmfPath: type:    "string"
														}
														type: "object"
													}
													defaultArchitecture: type: "string"
													ppc64le: {
														properties: {
															emulatedMachines: {
																items: type: "string"
																type:                     "array"
																"x-kubernetes-list-type": "atomic"
															}
															machineType: type: "string"
															ovmfPath: type:    "string"
														}
														type: "object"
													}
												}
												type: "object"
											}
											autoCPULimitNamespaceLabelSelector: {
												description: """
	When set, AutoCPULimitNamespaceLabelSelector will set a CPU limit on virt-launcher for VMIs running inside
	namespaces that match the label selector.
	The CPU limit will equal the number of requested vCPUs.
	This setting does not apply to VMIs with dedicated CPUs.
	"""
												properties: {
													matchExpressions: {
														description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
														items: {
															description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
															properties: {
																key: {
																	description: "key is the label key that the selector applies to."
																	type:        "string"
																}
																operator: {
																	description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																	type: "string"
																}
																values: {
																	description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																	items: type: "string"
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
															}
															required: [
																"key",
																"operator",
															]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													matchLabels: {
														additionalProperties: type: "string"
														description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
														type: "object"
													}
												}
												type:                    "object"
												"x-kubernetes-map-type": "atomic"
											}
											controllerConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											cpuModel: type: "string"
											cpuRequest: {
												anyOf: [{
													type: "integer"
												}, {
													type: "string"
												}]
												pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
												"x-kubernetes-int-or-string": true
											}
											defaultRuntimeClass: type: "string"
											developerConfiguration: {
												description: "DeveloperConfiguration holds developer options"
												properties: {
													cpuAllocationRatio: {
														description: """
	For each requested virtual CPU, CPUAllocationRatio defines how much physical CPU to request per VMI
	from the hosting node. The value is in fraction of a CPU thread (or core on non-hyperthreaded nodes).
	For example, a value of 1 means 1 physical CPU thread per VMI CPU thread.
	A value of 100 would be 1% of a physical thread allocated for each requested VMI thread.
	This option has no effect on VMIs that request dedicated CPUs. More information at:
	https://kubevirt.io/user-guide/operations/node_overcommit/#node-cpu-allocation-ratio
	Defaults to 10
	"""
														type: "integer"
													}
													diskVerification: {
														description: "DiskVerification holds container disks verification limits"
														properties: memoryLimit: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
															"x-kubernetes-int-or-string": true
														}
														required: ["memoryLimit"]
														type: "object"
													}
													featureGates: {
														description: "FeatureGates is the list of experimental features to enable. Defaults to none"
														items: type: "string"
														type: "array"
													}
													logVerbosity: {
														description: "LogVerbosity sets log verbosity level of  various components"
														properties: {
															nodeVerbosity: {
																additionalProperties: type: "integer"
																description: "NodeVerbosity represents a map of nodes with a specific verbosity level"
																type:        "object"
															}
															virtAPI: type:        "integer"
															virtController: type: "integer"
															virtHandler: type:    "integer"
															virtLauncher: type:   "integer"
															virtOperator: type:   "integer"
														}
														type: "object"
													}
													memoryOvercommit: {
														description: """
	MemoryOvercommit is the percentage of memory we want to give VMIs compared to the amount
	given to its parent pod (virt-launcher). For example, a value of 102 means the VMI will
	"see" 2% more memory than its parent pod. Values under 100 are effectively "undercommits".
	Overcommits can lead to memory exhaustion, which in turn can lead to crashes. Use carefully.
	Defaults to 100
	"""
														type: "integer"
													}
													minimumClusterTSCFrequency: {
														description: """
	Allow overriding the automatically determined minimum TSC frequency of the cluster
	and fixate the minimum to this frequency.
	"""
														format: "int64"
														type:   "integer"
													}
													minimumReservePVCBytes: {
														description: """
	MinimumReservePVCBytes is the amount of space, in bytes, to leave unused on disks.
	Defaults to 131072 (128KiB)
	"""
														format: "int64"
														type:   "integer"
													}
													nodeSelectors: {
														additionalProperties: type: "string"
														description: """
	NodeSelectors allows restricting VMI creation to nodes that match a set of labels.
	Defaults to none
	"""
														type: "object"
													}
													pvcTolerateLessSpaceUpToPercent: {
														description: """
	LessPVCSpaceToleration determines how much smaller, in percentage, disk PVCs are
	allowed to be compared to the requested size (to account for various overheads).
	Defaults to 10
	"""
														type: "integer"
													}
													useEmulation: {
														description: """
	UseEmulation can be set to true to allow fallback to software emulation
	in case hardware-assisted emulation is not available. Defaults to false
	"""
														type: "boolean"
													}
												}
												type: "object"
											}
											emulatedMachines: {
												description: "Deprecated. Use architectureConfiguration instead."
												items: type: "string"
												type: "array"
											}
											evictionStrategy: {
												description: """
	EvictionStrategy defines at the cluster level if the VirtualMachineInstance should be
	migrated instead of shut-off in case of a node drain. If the VirtualMachineInstance specific
	field is set it overrides the cluster level one.
	"""
												type: "string"
											}
											handlerConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											imagePullPolicy: {
												description: "PullPolicy describes a policy for if/when to pull a container image"
												type:        "string"
											}
											ksmConfiguration: {
												description: "KSMConfiguration holds the information regarding the enabling the KSM in the nodes (if available)."
												properties: nodeLabelSelector: {
													description: """
	NodeLabelSelector is a selector that filters in which nodes the KSM will be enabled.
	Empty NodeLabelSelector will enable ksm for every node.
	"""
													properties: {
														matchExpressions: {
															description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
															items: {
																description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																properties: {
																	key: {
																		description: "key is the label key that the selector applies to."
																		type:        "string"
																	}
																	operator: {
																		description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																		type: "string"
																	}
																	values: {
																		description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																		items: type: "string"
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																required: [
																	"key",
																	"operator",
																]
																type: "object"
															}
															type:                     "array"
															"x-kubernetes-list-type": "atomic"
														}
														matchLabels: {
															additionalProperties: type: "string"
															description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
															type: "object"
														}
													}
													type:                    "object"
													"x-kubernetes-map-type": "atomic"
												}
												type: "object"
											}
											liveUpdateConfiguration: {
												description: "LiveUpdateConfiguration holds defaults for live update features"
												properties: {
													maxCpuSockets: {
														description: "MaxCpuSockets holds the maximum amount of sockets that can be hotplugged"
														format:      "int32"
														type:        "integer"
													}
													maxGuest: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	MaxGuest defines the maximum amount memory that can be allocated
	to the guest using hotplug.
	"""
														pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
														"x-kubernetes-int-or-string": true
													}
													maxHotplugRatio: {
														description: """
	MaxHotplugRatio is the ratio used to define the max amount
	of a hotplug resource that can be made available to a VM
	when the specific Max* setting is not defined (MaxCpuSockets, MaxGuest)
	Example: VM is configured with 512Mi of guest memory, if MaxGuest is not
	defined and MaxHotplugRatio is 2 then MaxGuest = 1Gi
	defaults to 4
	"""
														format: "int32"
														type:   "integer"
													}
												}
												type: "object"
											}
											machineType: {
												description: "Deprecated. Use architectureConfiguration instead."
												type:        "string"
											}
											mediatedDevicesConfiguration: {
												description: "MediatedDevicesConfiguration holds information about MDEV types to be defined, if available"
												properties: {
													mediatedDeviceTypes: {
														items: type: "string"
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													mediatedDevicesTypes: {
														description: "Deprecated. Use mediatedDeviceTypes instead."
														items: type: "string"
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													nodeMediatedDeviceTypes: {
														items: {
															description: "NodeMediatedDeviceTypesConfig holds information about MDEV types to be defined in a specific node that matches the NodeSelector field."
															properties: {
																mediatedDeviceTypes: {
																	items: type: "string"
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
																mediatedDevicesTypes: {
																	description: "Deprecated. Use mediatedDeviceTypes instead."
																	items: type: "string"
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
																nodeSelector: {
																	additionalProperties: type: "string"
																	description: """
	NodeSelector is a selector which must be true for the vmi to fit on a node.
	Selector which must match a node's labels for the vmi to be scheduled on that node.
	More info: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
	"""
																	type: "object"
																}
															}
															required: ["nodeSelector"]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
												}
												type: "object"
											}
											memBalloonStatsPeriod: {
												format: "int32"
												type:   "integer"
											}
											migrations: {
												description: """
	MigrationConfiguration holds migration options.
	Can be overridden for specific groups of VMs though migration policies.
	Visit https://kubevirt.io/user-guide/operations/migration_policies/ for more information.
	"""
												properties: {
													allowAutoConverge: {
														description: """
	AllowAutoConverge allows the platform to compromise performance/availability of VMIs to
	guarantee successful VMI live migrations. Defaults to false
	"""
														type: "boolean"
													}
													allowPostCopy: {
														description: """
	AllowPostCopy enables post-copy live migrations. Such migrations allow even the busiest VMIs
	to successfully live-migrate. However, events like a network failure can cause a VMI crash.
	If set to true, migrations will still start in pre-copy, but switch to post-copy when
	CompletionTimeoutPerGiB triggers. Defaults to false
	"""
														type: "boolean"
													}
													bandwidthPerMigration: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	BandwidthPerMigration limits the amount of network bandwidth live migrations are allowed to use.
	The value is in quantity per second. Defaults to 0 (no limit)
	"""
														pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
														"x-kubernetes-int-or-string": true
													}
													completionTimeoutPerGiB: {
														description: """
	CompletionTimeoutPerGiB is the maximum number of seconds per GiB a migration is allowed to take.
	If a live-migration takes longer to migrate than this value multiplied by the size of the VMI,
	the migration will be cancelled, unless AllowPostCopy is true. Defaults to 800
	"""
														format: "int64"
														type:   "integer"
													}
													disableTLS: {
														description: """
	When set to true, DisableTLS will disable the additional layer of live migration encryption
	provided by KubeVirt. This is usually a bad idea. Defaults to false
	"""
														type: "boolean"
													}
													matchSELinuxLevelOnMigration: {
														description: """
	By default, the SELinux level of target virt-launcher pods is forced to the level of the source virt-launcher.
	When set to true, MatchSELinuxLevelOnMigration lets the CRI auto-assign a random level to the target.
	That will ensure the target virt-launcher doesn't share categories with another pod on the node.
	However, migrations will fail when using RWX volumes that don't automatically deal with SELinux levels.
	"""
														type: "boolean"
													}
													network: {
														description: """
	Network is the name of the CNI network to use for live migrations. By default, migrations go
	through the pod network.
	"""
														type: "string"
													}
													nodeDrainTaintKey: {
														description: """
	NodeDrainTaintKey defines the taint key that indicates a node should be drained.
	Note: this option relies on the deprecated node taint feature. Default: kubevirt.io/drain
	"""
														type: "string"
													}
													parallelMigrationsPerCluster: {
														description: """
	ParallelMigrationsPerCluster is the total number of concurrent live migrations
	allowed cluster-wide. Defaults to 5
	"""
														format: "int32"
														type:   "integer"
													}
													parallelOutboundMigrationsPerNode: {
														description: """
	ParallelOutboundMigrationsPerNode is the maximum number of concurrent outgoing live migrations
	allowed per node. Defaults to 2
	"""
														format: "int32"
														type:   "integer"
													}
													progressTimeout: {
														description: """
	ProgressTimeout is the maximum number of seconds a live migration is allowed to make no progress.
	Hitting this timeout means a migration transferred 0 data for that many seconds. The migration is
	then considered stuck and therefore cancelled. Defaults to 150
	"""
														format: "int64"
														type:   "integer"
													}
													unsafeMigrationOverride: {
														description: """
	UnsafeMigrationOverride allows live migrations to occur even if the compatibility check
	indicates the migration will be unsafe to the guest. Defaults to false
	"""
														type: "boolean"
													}
												}
												type: "object"
											}
											minCPUModel: type: "string"
											network: {
												description: "NetworkConfiguration holds network options"
												properties: {
													binding: {
														additionalProperties: {
															properties: {
																computeResourceOverhead: {
																	description: """
	ComputeResourceOverhead specifies the resource overhead that should be added to the compute container when using the binding.
	version: v1alphav1
	"""
																	properties: {
																		claims: {
																			description: """
	Claims lists the names of resources, defined in spec.resourceClaims,
	that are used by this container.


	This is an alpha field and requires enabling the
	DynamicResourceAllocation feature gate.


	This field is immutable. It can only be set for containers.
	"""
																			items: {
																				description: "ResourceClaim references one entry in PodSpec.ResourceClaims."
																				properties: name: {
																					description: """
	Name must match the name of one entry in pod.spec.resourceClaims of
	the Pod where this field is used. It makes that resource available
	inside a container.
	"""
																					type: "string"
																				}
																				required: ["name"]
																				type: "object"
																			}
																			type: "array"
																			"x-kubernetes-list-map-keys": ["name"]
																			"x-kubernetes-list-type": "map"
																		}
																		limits: {
																			additionalProperties: {
																				anyOf: [{
																					type: "integer"
																				}, {
																					type: "string"
																				}]
																				pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																				"x-kubernetes-int-or-string": true
																			}
																			description: """
	Limits describes the maximum amount of compute resources allowed.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																			type: "object"
																		}
																		requests: {
																			additionalProperties: {
																				anyOf: [{
																					type: "integer"
																				}, {
																					type: "string"
																				}]
																				pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																				"x-kubernetes-int-or-string": true
																			}
																			description: """
	Requests describes the minimum amount of compute resources required.
	If Requests is omitted for a container, it defaults to Limits if that is explicitly specified,
	otherwise to an implementation-defined value. Requests cannot exceed Limits.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																			type: "object"
																		}
																	}
																	type: "object"
																}
																domainAttachmentType: {
																	description: """
	DomainAttachmentType is a standard domain network attachment method kubevirt supports.
	Supported values: "tap".
	The standard domain attachment can be used instead or in addition to the sidecarImage.
	version: 1alphav1
	"""
																	type: "string"
																}
																downwardAPI: {
																	description: """
	DownwardAPI specifies what kind of data should be exposed to the binding plugin sidecar.
	Supported values: "device-info"
	version: v1alphav1
	"""
																	type: "string"
																}
																migration: {
																	description: """
	Migration means the VM using the plugin can be safely migrated
	version: 1alphav1
	"""
																	properties: method: {
																		description: """
	Method defines a pre-defined migration methodology
	version: 1alphav1
	"""
																		type: "string"
																	}
																	type: "object"
																}
																networkAttachmentDefinition: {
																	description: """
	NetworkAttachmentDefinition references to a NetworkAttachmentDefinition CR object.
	Format: <name>, <namespace>/<name>.
	If namespace is not specified, VMI namespace is assumed.
	version: 1alphav1
	"""
																	type: "string"
																}
																sidecarImage: {
																	description: """
	SidecarImage references a container image that runs in the virt-launcher pod.
	The sidecar handles (libvirt) domain configuration and optional services.
	version: 1alphav1
	"""
																	type: "string"
																}
															}
															type: "object"
														}
														type: "object"
													}
													defaultNetworkInterface: type:           "string"
													permitBridgeInterfaceOnPodNetwork: type: "boolean"
													permitSlirpInterface: {
														description: """
	DeprecatedPermitSlirpInterface is an alias for the deprecated PermitSlirpInterface.
	Deprecated: Removed in v1.3.
	"""
														type: "boolean"
													}
												}
												type: "object"
											}
											obsoleteCPUModels: {
												additionalProperties: type: "boolean"
												type: "object"
											}
											ovmfPath: {
												description: "Deprecated. Use architectureConfiguration instead."
												type:        "string"
											}
											permittedHostDevices: {
												description: "PermittedHostDevices holds information about devices allowed for passthrough"
												properties: {
													mediatedDevices: {
														items: {
															description: "MediatedHostDevice represents a host mediated device allowed for passthrough"
															properties: {
																externalResourceProvider: type: "boolean"
																mdevNameSelector: type:         "string"
																resourceName: type:             "string"
															}
															required: [
																"mdevNameSelector",
																"resourceName",
															]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													pciHostDevices: {
														items: {
															description: "PciHostDevice represents a host PCI device allowed for passthrough"
															properties: {
																externalResourceProvider: {
																	description: """
	If true, KubeVirt will leave the allocation and monitoring to an
	external device plugin
	"""
																	type: "boolean"
																}
																pciVendorSelector: {
																	description: "The vendor_id:product_id tuple of the PCI device"
																	type:        "string"
																}
																resourceName: {
																	description: """
	The name of the resource that is representing the device. Exposed by
	a device plugin and requested by VMs. Typically of the form
	vendor.com/product_name
	"""
																	type: "string"
																}
															}
															required: [
																"pciVendorSelector",
																"resourceName",
															]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													usb: {
														items: {
															properties: {
																externalResourceProvider: {
																	description: """
	If true, KubeVirt will leave the allocation and monitoring to an
	external device plugin
	"""
																	type: "boolean"
																}
																resourceName: {
																	description: """
	Identifies the list of USB host devices.
	e.g: kubevirt.io/storage, kubevirt.io/bootable-usb, etc
	"""
																	type: "string"
																}
																selectors: {
																	items: {
																		properties: {
																			product: type: "string"
																			vendor: type:  "string"
																		}
																		required: [
																			"product",
																			"vendor",
																		]
																		type: "object"
																	}
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
															}
															required: ["resourceName"]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
												}
												type: "object"
											}
											seccompConfiguration: {
												description: "SeccompConfiguration holds Seccomp configuration for Kubevirt components"
												properties: virtualMachineInstanceProfile: {
													description: "VirtualMachineInstanceProfile defines what profile should be used with virt-launcher. Defaults to none"
													properties: customProfile: {
														description: "CustomProfile allows to request arbitrary profile for virt-launcher"
														properties: {
															localhostProfile: type:      "string"
															runtimeDefaultProfile: type: "boolean"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											selinuxLauncherType: type: "string"
											smbios: {
												properties: {
													family: type:       "string"
													manufacturer: type: "string"
													product: type:      "string"
													sku: type:          "string"
													version: type:      "string"
												}
												type: "object"
											}
											supportContainerResources: {
												description: "SupportContainerResources specifies the resource requirements for various types of supporting containers such as container disks/virtiofs/sidecars and hotplug attachment pods. If omitted a sensible default will be supplied."
												items: {
													description: "SupportContainerResources are used to specify the cpu/memory request and limits for the containers that support various features of Virtual Machines. These containers are usually idle and don't require a lot of memory or cpu."
													properties: {
														resources: {
															description: "ResourceRequirements describes the compute resource requirements."
															properties: {
																claims: {
																	description: """
	Claims lists the names of resources, defined in spec.resourceClaims,
	that are used by this container.


	This is an alpha field and requires enabling the
	DynamicResourceAllocation feature gate.


	This field is immutable. It can only be set for containers.
	"""
																	items: {
																		description: "ResourceClaim references one entry in PodSpec.ResourceClaims."
																		properties: name: {
																			description: """
	Name must match the name of one entry in pod.spec.resourceClaims of
	the Pod where this field is used. It makes that resource available
	inside a container.
	"""
																			type: "string"
																		}
																		required: ["name"]
																		type: "object"
																	}
																	type: "array"
																	"x-kubernetes-list-map-keys": ["name"]
																	"x-kubernetes-list-type": "map"
																}
																limits: {
																	additionalProperties: {
																		anyOf: [{
																			type: "integer"
																		}, {
																			type: "string"
																		}]
																		pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																		"x-kubernetes-int-or-string": true
																	}
																	description: """
	Limits describes the maximum amount of compute resources allowed.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																	type: "object"
																}
																requests: {
																	additionalProperties: {
																		anyOf: [{
																			type: "integer"
																		}, {
																			type: "string"
																		}]
																		pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																		"x-kubernetes-int-or-string": true
																	}
																	description: """
	Requests describes the minimum amount of compute resources required.
	If Requests is omitted for a container, it defaults to Limits if that is explicitly specified,
	otherwise to an implementation-defined value. Requests cannot exceed Limits.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																	type: "object"
																}
															}
															type: "object"
														}
														type: type: "string"
													}
													required: [
														"resources",
														"type",
													]
													type: "object"
												}
												type: "array"
												"x-kubernetes-list-map-keys": ["type"]
												"x-kubernetes-list-type": "map"
											}
											supportedGuestAgentVersions: {
												description: "deprecated"
												items: type: "string"
												type: "array"
											}
											tlsConfiguration: {
												description: "TLSConfiguration holds TLS options"
												properties: {
													ciphers: {
														items: type: "string"
														type:                     "array"
														"x-kubernetes-list-type": "set"
													}
													minTLSVersion: {
														description: """
	MinTLSVersion is a way to specify the minimum protocol version that is acceptable for TLS connections.
	Protocol versions are based on the following most common TLS configurations:


	  https://ssl-config.mozilla.org/


	Note that SSLv3.0 is not a supported protocol version due to well known
	vulnerabilities such as POODLE: https://en.wikipedia.org/wiki/POODLE
	"""
														enum: [
															"VersionTLS10",
															"VersionTLS11",
															"VersionTLS12",
															"VersionTLS13",
														]
														type: "string"
													}
												}
												type: "object"
											}
											virtualMachineInstancesPerNode: type: "integer"
											virtualMachineOptions: {
												description: "VirtualMachineOptions holds the cluster level information regarding the virtual machine."
												properties: {
													disableFreePageReporting: {
														description: """
	DisableFreePageReporting disable the free page reporting of
	memory balloon device https://libvirt.org/formatdomain.html#memory-balloon-device.
	This will have effect only if AutoattachMemBalloon is not false and the vmi is not
	requesting any high performance feature (dedicatedCPU/realtime/hugePages), in which free page reporting is always disabled.
	"""
														type: "object"
													}
													disableSerialConsoleLog: {
														description: """
	DisableSerialConsoleLog disables logging the auto-attached default serial console.
	If not set, serial console logs will be written to a file and then streamed from a container named 'guest-console-log'.
	The value can be individually overridden for each VM, not relevant if AutoattachSerialConsole is disabled.
	"""
														type: "object"
													}
												}
												type: "object"
											}
											vmRolloutStrategy: {
												description: "VMRolloutStrategy defines how changes to a VM object propagate to its VMI"
												enum: [
													"Stage",
													"LiveUpdate",
												]
												nullable: true
												type:     "string"
											}
											vmStateStorageClass: {
												description: """
	VMStateStorageClass is the name of the storage class to use for the PVCs created to preserve VM state, like TPM.
	The storage class must support RWX in filesystem mode.
	"""
												type: "string"
											}
											webhookConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
										}
										type: "object"
									}
									customizeComponents: {
										properties: {
											flags: {
												description: "Configure the value used for deployment and daemonset resources"
												properties: {
													api: {
														additionalProperties: type: "string"
														type: "object"
													}
													controller: {
														additionalProperties: type: "string"
														type: "object"
													}
													handler: {
														additionalProperties: type: "string"
														type: "object"
													}
												}
												type: "object"
											}
											patches: {
												items: {
													properties: {
														patch: type: "string"
														resourceName: {
															minLength: 1
															type:      "string"
														}
														resourceType: {
															minLength: 1
															type:      "string"
														}
														type: type: "string"
													}
													required: [
														"patch",
														"resourceName",
														"resourceType",
														"type",
													]
													type: "object"
												}
												type:                     "array"
												"x-kubernetes-list-type": "atomic"
											}
										}
										type: "object"
									}
									imagePullPolicy: {
										description: "The ImagePullPolicy to use."
										type:        "string"
									}
									imagePullSecrets: {
										description: """
	The imagePullSecrets to pull the container images from
	Defaults to none
	"""
										items: {
											description: """
	LocalObjectReference contains enough information to let you locate the
	referenced object inside the same namespace.
	"""
											properties: name: {
												description: """
	Name of the referent.
	More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
	TODO: Add other useful fields. apiVersion, kind, uid?
	"""
												type: "string"
											}
											type:                    "object"
											"x-kubernetes-map-type": "atomic"
										}
										type:                     "array"
										"x-kubernetes-list-type": "atomic"
									}
									imageRegistry: {
										description: """
	The image registry to pull the container images from
	Defaults to the same registry the operator's container image is pulled from.
	"""
										type: "string"
									}
									imageTag: {
										description: """
	The image tag to use for the continer images installed.
	Defaults to the same tag as the operator's container image.
	"""
										type: "string"
									}
									infra: {
										description: "selectors and tolerations that should apply to KubeVirt infrastructure components"
										properties: {
											nodePlacement: {
												description: """
	nodePlacement describes scheduling configuration for specific
	KubeVirt components
	"""
												properties: {
													affinity: {
														description: """
	affinity enables pod affinity/anti-affinity placement expanding the types of constraints
	that can be expressed with nodeSelector.
	affinity is going to be applied to the relevant kind of pods in parallel with nodeSelector
	See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity
	"""
														properties: {
															nodeAffinity: {
																description: "Describes node affinity scheduling rules for the pod."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node matches the corresponding matchExpressions; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: """
	An empty preferred scheduling term matches all objects with implicit weight 0
	(i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).
	"""
																			properties: {
																				preference: {
																					description: "A node selector term, associated with the corresponding weight."
																					properties: {
																						matchExpressions: {
																							description: "A list of node selector requirements by node's labels."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchFields: {
																							description: "A list of node selector requirements by node's fields."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				weight: {
																					description: "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100."
																					format:      "int32"
																					type:        "integer"
																				}
																			}
																			required: [
																				"preference",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to an update), the system
	may or may not try to eventually evict the pod from its node.
	"""
																		properties: nodeSelectorTerms: {
																			description: "Required. A list of node selector terms. The terms are ORed."
																			items: {
																				description: """
	A null or empty node selector term matches no objects. The requirements of
	them are ANDed.
	The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.
	"""
																				properties: {
																					matchExpressions: {
																						description: "A list of node selector requirements by node's labels."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																					matchFields: {
																						description: "A list of node selector requirements by node's fields."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																				}
																				type:                    "object"
																				"x-kubernetes-map-type": "atomic"
																			}
																			type:                     "array"
																			"x-kubernetes-list-type": "atomic"
																		}
																		required: ["nodeSelectorTerms"]
																		type:                    "object"
																		"x-kubernetes-map-type": "atomic"
																	}
																}
																type: "object"
															}
															podAffinity: {
																description: "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
															podAntiAffinity: {
																description: "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the anti-affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling anti-affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the anti-affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the anti-affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
														}
														type: "object"
													}
													nodeSelector: {
														additionalProperties: type: "string"
														description: """
	nodeSelector is the node selector applied to the relevant kind of pods
	It specifies a map of key-value pairs: for the pod to be eligible to run on a node,
	the node must have each of the indicated key-value pairs as labels
	(it can have additional labels as well).
	See https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
	"""
														type: "object"
													}
													tolerations: {
														description: """
	tolerations is a list of tolerations applied to the relevant kind of pods
	See https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ for more info.
	These are additional tolerations other than default ones.
	"""
														items: {
															description: """
	The pod this Toleration is attached to tolerates any taint that matches
	the triple <key,value,effect> using the matching operator <operator>.
	"""
															properties: {
																effect: {
																	description: """
	Effect indicates the taint effect to match. Empty means match all taint effects.
	When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
	"""
																	type: "string"
																}
																key: {
																	description: """
	Key is the taint key that the toleration applies to. Empty means match all taint keys.
	If the key is empty, operator must be Exists; this combination means to match all values and all keys.
	"""
																	type: "string"
																}
																operator: {
																	description: """
	Operator represents a key's relationship to the value.
	Valid operators are Exists and Equal. Defaults to Equal.
	Exists is equivalent to wildcard for value, so that a pod can
	tolerate all taints of a particular category.
	"""
																	type: "string"
																}
																tolerationSeconds: {
																	description: """
	TolerationSeconds represents the period of time the toleration (which must be
	of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default,
	it is not set, which means tolerate the taint forever (do not evict). Zero and
	negative values will be treated as 0 (evict immediately) by the system.
	"""
																	format: "int64"
																	type:   "integer"
																}
																value: {
																	description: """
	Value is the taint value the toleration matches to.
	If the operator is Exists, the value should be empty, otherwise just a regular string.
	"""
																	type: "string"
																}
															}
															type: "object"
														}
														type: "array"
													}
												}
												type: "object"
											}
											replicas: {
												description: """
	replicas indicates how many replicas should be created for each KubeVirt infrastructure
	component (like virt-api or virt-controller). Defaults to 2.
	WARNING: this is an advanced feature that prevents auto-scaling for core kubevirt components. Please use with caution!
	"""
												type: "integer"
											}
										}
										type: "object"
									}
									monitorAccount: {
										description: """
	The name of the Prometheus service account that needs read-access to KubeVirt endpoints
	Defaults to prometheus-k8s
	"""
										type: "string"
									}
									monitorNamespace: {
										description: """
	The namespace Prometheus is deployed in
	Defaults to openshift-monitor
	"""
										type: "string"
									}
									productComponent: {
										description: """
	Designate the apps.kubevirt.io/component label for KubeVirt components.
	Useful if KubeVirt is included as part of a product.
	If ProductComponent is not specified, the component label default value is kubevirt.
	"""
										type: "string"
									}
									productName: {
										description: """
	Designate the apps.kubevirt.io/part-of label for KubeVirt components.
	Useful if KubeVirt is included as part of a product.
	If ProductName is not specified, the part-of label will be omitted.
	"""
										type: "string"
									}
									productVersion: {
										description: """
	Designate the apps.kubevirt.io/version label for KubeVirt components.
	Useful if KubeVirt is included as part of a product.
	If ProductVersion is not specified, KubeVirt's version will be used.
	"""
										type: "string"
									}
									serviceMonitorNamespace: {
										description: """
	The namespace the service monitor will be deployed
	 When ServiceMonitorNamespace is set, then we'll install the service monitor object in that namespace
	otherwise we will use the monitoring namespace.
	"""
										type: "string"
									}
									uninstallStrategy: {
										description: """
	Specifies if kubevirt can be deleted if workloads are still present.
	This is mainly a precaution to avoid accidental data loss
	"""
										type: "string"
									}
									workloadUpdateStrategy: {
										description: """
	WorkloadUpdateStrategy defines at the cluster level how to handle
	automated workload updates
	"""
										properties: {
											batchEvictionInterval: {
												description: """
	BatchEvictionInterval Represents the interval to wait before issuing the next
	batch of shutdowns


	Defaults to 1 minute
	"""
												type: "string"
											}
											batchEvictionSize: {
												description: """
	BatchEvictionSize Represents the number of VMIs that can be forced updated per
	the BatchShutdownInteral interval


	Defaults to 10
	"""
												type: "integer"
											}
											workloadUpdateMethods: {
												description: """
	WorkloadUpdateMethods defines the methods that can be used to disrupt workloads
	during automated workload updates.
	When multiple methods are present, the least disruptive method takes
	precedence over more disruptive methods. For example if both LiveMigrate and Shutdown
	methods are listed, only VMs which are not live migratable will be restarted/shutdown


	An empty list defaults to no automated workload updating
	"""
												items: type: "string"
												type:                     "array"
												"x-kubernetes-list-type": "atomic"
											}
										}
										type: "object"
									}
									workloads: {
										description: "selectors and tolerations that should apply to KubeVirt workloads"
										properties: {
											nodePlacement: {
												description: """
	nodePlacement describes scheduling configuration for specific
	KubeVirt components
	"""
												properties: {
													affinity: {
														description: """
	affinity enables pod affinity/anti-affinity placement expanding the types of constraints
	that can be expressed with nodeSelector.
	affinity is going to be applied to the relevant kind of pods in parallel with nodeSelector
	See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity
	"""
														properties: {
															nodeAffinity: {
																description: "Describes node affinity scheduling rules for the pod."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node matches the corresponding matchExpressions; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: """
	An empty preferred scheduling term matches all objects with implicit weight 0
	(i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).
	"""
																			properties: {
																				preference: {
																					description: "A node selector term, associated with the corresponding weight."
																					properties: {
																						matchExpressions: {
																							description: "A list of node selector requirements by node's labels."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchFields: {
																							description: "A list of node selector requirements by node's fields."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				weight: {
																					description: "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100."
																					format:      "int32"
																					type:        "integer"
																				}
																			}
																			required: [
																				"preference",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to an update), the system
	may or may not try to eventually evict the pod from its node.
	"""
																		properties: nodeSelectorTerms: {
																			description: "Required. A list of node selector terms. The terms are ORed."
																			items: {
																				description: """
	A null or empty node selector term matches no objects. The requirements of
	them are ANDed.
	The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.
	"""
																				properties: {
																					matchExpressions: {
																						description: "A list of node selector requirements by node's labels."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																					matchFields: {
																						description: "A list of node selector requirements by node's fields."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																				}
																				type:                    "object"
																				"x-kubernetes-map-type": "atomic"
																			}
																			type:                     "array"
																			"x-kubernetes-list-type": "atomic"
																		}
																		required: ["nodeSelectorTerms"]
																		type:                    "object"
																		"x-kubernetes-map-type": "atomic"
																	}
																}
																type: "object"
															}
															podAffinity: {
																description: "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
															podAntiAffinity: {
																description: "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the anti-affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling anti-affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the anti-affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the anti-affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
														}
														type: "object"
													}
													nodeSelector: {
														additionalProperties: type: "string"
														description: """
	nodeSelector is the node selector applied to the relevant kind of pods
	It specifies a map of key-value pairs: for the pod to be eligible to run on a node,
	the node must have each of the indicated key-value pairs as labels
	(it can have additional labels as well).
	See https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
	"""
														type: "object"
													}
													tolerations: {
														description: """
	tolerations is a list of tolerations applied to the relevant kind of pods
	See https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ for more info.
	These are additional tolerations other than default ones.
	"""
														items: {
															description: """
	The pod this Toleration is attached to tolerates any taint that matches
	the triple <key,value,effect> using the matching operator <operator>.
	"""
															properties: {
																effect: {
																	description: """
	Effect indicates the taint effect to match. Empty means match all taint effects.
	When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
	"""
																	type: "string"
																}
																key: {
																	description: """
	Key is the taint key that the toleration applies to. Empty means match all taint keys.
	If the key is empty, operator must be Exists; this combination means to match all values and all keys.
	"""
																	type: "string"
																}
																operator: {
																	description: """
	Operator represents a key's relationship to the value.
	Valid operators are Exists and Equal. Defaults to Equal.
	Exists is equivalent to wildcard for value, so that a pod can
	tolerate all taints of a particular category.
	"""
																	type: "string"
																}
																tolerationSeconds: {
																	description: """
	TolerationSeconds represents the period of time the toleration (which must be
	of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default,
	it is not set, which means tolerate the taint forever (do not evict). Zero and
	negative values will be treated as 0 (evict immediately) by the system.
	"""
																	format: "int64"
																	type:   "integer"
																}
																value: {
																	description: """
	Value is the taint value the toleration matches to.
	If the operator is Exists, the value should be empty, otherwise just a regular string.
	"""
																	type: "string"
																}
															}
															type: "object"
														}
														type: "array"
													}
												}
												type: "object"
											}
											replicas: {
												description: """
	replicas indicates how many replicas should be created for each KubeVirt infrastructure
	component (like virt-api or virt-controller). Defaults to 2.
	WARNING: this is an advanced feature that prevents auto-scaling for core kubevirt components. Please use with caution!
	"""
												type: "integer"
											}
										}
										type: "object"
									}
								}
								type: "object"
							}
							status: {
								description: "KubeVirtStatus represents information pertaining to a KubeVirt deployment."
								properties: {
									conditions: {
										items: {
											description: "KubeVirtCondition represents a condition of a KubeVirt deployment"
											properties: {
												lastProbeTime: {
													format:   "date-time"
													nullable: true
													type:     "string"
												}
												lastTransitionTime: {
													format:   "date-time"
													nullable: true
													type:     "string"
												}
												message: type: "string"
												reason: type:  "string"
												status: type:  "string"
												type: type:    "string"
											}
											required: [
												"status",
												"type",
											]
											type: "object"
										}
										type: "array"
									}
									defaultArchitecture: type: "string"
									generations: {
										items: {
											description: "GenerationStatus keeps track of the generation for a given resource so that decisions about forced updates can be made."
											properties: {
												group: {
													description: "group is the group of the thing you're tracking"
													type:        "string"
												}
												hash: {
													description: "hash is an optional field set for resources without generation that are content sensitive like secrets and configmaps"
													type:        "string"
												}
												lastGeneration: {
													description: "lastGeneration is the last generation of the workload controller involved"
													format:      "int64"
													type:        "integer"
												}
												name: {
													description: "name is the name of the thing you're tracking"
													type:        "string"
												}
												namespace: {
													description: "namespace is where the thing you're tracking is"
													type:        "string"
												}
												resource: {
													description: "resource is the resource type of the thing you're tracking"
													type:        "string"
												}
											}
											required: [
												"group",
												"lastGeneration",
												"name",
												"resource",
											]
											type: "object"
										}
										type:                     "array"
										"x-kubernetes-list-type": "atomic"
									}
									observedDeploymentConfig: type: "string"
									observedDeploymentID: type:     "string"
									observedGeneration: {
										format: "int64"
										type:   "integer"
									}
									observedKubeVirtRegistry: type:                "string"
									observedKubeVirtVersion: type:                 "string"
									operatorVersion: type:                         "string"
									outdatedVirtualMachineInstanceWorkloads: type: "integer"
									phase: {
										description: "KubeVirtPhase is a label for the phase of a KubeVirt deployment at the current time."
										type:        "string"
									}
									targetDeploymentConfig: type: "string"
									targetDeploymentID: type:     "string"
									targetKubeVirtRegistry: type: "string"
									targetKubeVirtVersion: type:  "string"
								}
								type: "object"
							}
						}
						required: ["spec"]
						type: "object"
					}
					served:  true
					storage: true
					subresources: status: {}
				}, {
					additionalPrinterColumns: [{
						jsonPath: ".metadata.creationTimestamp"
						name:     "Age"
						type:     "date"
					}, {
						jsonPath: ".status.phase"
						name:     "Phase"
						type:     "string"
					}]
					deprecated:         true
					deprecationWarning: "kubevirt.io/v1alpha3 is now deprecated and will be removed in a future release."
					name:               "v1alpha3"
					schema: openAPIV3Schema: {
						description: "KubeVirt represents the object deploying all KubeVirt resources"
						properties: {
							apiVersion: {
								description: """
	APIVersion defines the versioned schema of this representation of an object.
	Servers should convert recognized schemas to the latest internal value, and
	may reject unrecognized values.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
	"""
								type: "string"
							}
							kind: {
								description: """
	Kind is a string value representing the REST resource this object represents.
	Servers may infer this from the endpoint the client submits requests to.
	Cannot be updated.
	In CamelCase.
	More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
	"""
								type: "string"
							}
							metadata: type: "object"
							spec: {
								properties: {
									certificateRotateStrategy: {
										properties: selfSigned: {
											properties: {
												ca: {
													description: """
	CA configuration
	CA certs are kept in the CA bundle as long as they are valid
	"""
													properties: {
														duration: {
															description: "The requested 'duration' (i.e. lifetime) of the Certificate."
															type:        "string"
														}
														renewBefore: {
															description: """
	The amount of time before the currently issued certificate's "notAfter"
	time that we will begin to attempt to renew the certificate.
	"""
															type: "string"
														}
													}
													type: "object"
												}
												caOverlapInterval: {
													description: "Deprecated. Use CA.Duration and CA.RenewBefore instead"
													type:        "string"
												}
												caRotateInterval: {
													description: "Deprecated. Use CA.Duration instead"
													type:        "string"
												}
												certRotateInterval: {
													description: "Deprecated. Use Server.Duration instead"
													type:        "string"
												}
												server: {
													description: """
	Server configuration
	Certs are rotated and discarded
	"""
													properties: {
														duration: {
															description: "The requested 'duration' (i.e. lifetime) of the Certificate."
															type:        "string"
														}
														renewBefore: {
															description: """
	The amount of time before the currently issued certificate's "notAfter"
	time that we will begin to attempt to renew the certificate.
	"""
															type: "string"
														}
													}
													type: "object"
												}
											}
											type: "object"
										}
										type: "object"
									}
									configuration: {
										description: """
	holds kubevirt configurations.
	same as the virt-configMap
	"""
										properties: {
											additionalGuestMemoryOverheadRatio: {
												description: """
	AdditionalGuestMemoryOverheadRatio can be used to increase the virtualization infrastructure
	overhead. This is useful, since the calculation of this overhead is not accurate and cannot
	be entirely known in advance. The ratio that is being set determines by which factor to increase
	the overhead calculated by Kubevirt. A higher ratio means that the VMs would be less compromised
	by node pressures, but would mean that fewer VMs could be scheduled to a node.
	If not set, the default is 1.
	"""
												type: "string"
											}
											apiConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											architectureConfiguration: {
												properties: {
													amd64: {
														properties: {
															emulatedMachines: {
																items: type: "string"
																type:                     "array"
																"x-kubernetes-list-type": "atomic"
															}
															machineType: type: "string"
															ovmfPath: type:    "string"
														}
														type: "object"
													}
													arm64: {
														properties: {
															emulatedMachines: {
																items: type: "string"
																type:                     "array"
																"x-kubernetes-list-type": "atomic"
															}
															machineType: type: "string"
															ovmfPath: type:    "string"
														}
														type: "object"
													}
													defaultArchitecture: type: "string"
													ppc64le: {
														properties: {
															emulatedMachines: {
																items: type: "string"
																type:                     "array"
																"x-kubernetes-list-type": "atomic"
															}
															machineType: type: "string"
															ovmfPath: type:    "string"
														}
														type: "object"
													}
												}
												type: "object"
											}
											autoCPULimitNamespaceLabelSelector: {
												description: """
	When set, AutoCPULimitNamespaceLabelSelector will set a CPU limit on virt-launcher for VMIs running inside
	namespaces that match the label selector.
	The CPU limit will equal the number of requested vCPUs.
	This setting does not apply to VMIs with dedicated CPUs.
	"""
												properties: {
													matchExpressions: {
														description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
														items: {
															description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
															properties: {
																key: {
																	description: "key is the label key that the selector applies to."
																	type:        "string"
																}
																operator: {
																	description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																	type: "string"
																}
																values: {
																	description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																	items: type: "string"
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
															}
															required: [
																"key",
																"operator",
															]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													matchLabels: {
														additionalProperties: type: "string"
														description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
														type: "object"
													}
												}
												type:                    "object"
												"x-kubernetes-map-type": "atomic"
											}
											controllerConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											cpuModel: type: "string"
											cpuRequest: {
												anyOf: [{
													type: "integer"
												}, {
													type: "string"
												}]
												pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
												"x-kubernetes-int-or-string": true
											}
											defaultRuntimeClass: type: "string"
											developerConfiguration: {
												description: "DeveloperConfiguration holds developer options"
												properties: {
													cpuAllocationRatio: {
														description: """
	For each requested virtual CPU, CPUAllocationRatio defines how much physical CPU to request per VMI
	from the hosting node. The value is in fraction of a CPU thread (or core on non-hyperthreaded nodes).
	For example, a value of 1 means 1 physical CPU thread per VMI CPU thread.
	A value of 100 would be 1% of a physical thread allocated for each requested VMI thread.
	This option has no effect on VMIs that request dedicated CPUs. More information at:
	https://kubevirt.io/user-guide/operations/node_overcommit/#node-cpu-allocation-ratio
	Defaults to 10
	"""
														type: "integer"
													}
													diskVerification: {
														description: "DiskVerification holds container disks verification limits"
														properties: memoryLimit: {
															anyOf: [{
																type: "integer"
															}, {
																type: "string"
															}]
															pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
															"x-kubernetes-int-or-string": true
														}
														required: ["memoryLimit"]
														type: "object"
													}
													featureGates: {
														description: "FeatureGates is the list of experimental features to enable. Defaults to none"
														items: type: "string"
														type: "array"
													}
													logVerbosity: {
														description: "LogVerbosity sets log verbosity level of  various components"
														properties: {
															nodeVerbosity: {
																additionalProperties: type: "integer"
																description: "NodeVerbosity represents a map of nodes with a specific verbosity level"
																type:        "object"
															}
															virtAPI: type:        "integer"
															virtController: type: "integer"
															virtHandler: type:    "integer"
															virtLauncher: type:   "integer"
															virtOperator: type:   "integer"
														}
														type: "object"
													}
													memoryOvercommit: {
														description: """
	MemoryOvercommit is the percentage of memory we want to give VMIs compared to the amount
	given to its parent pod (virt-launcher). For example, a value of 102 means the VMI will
	"see" 2% more memory than its parent pod. Values under 100 are effectively "undercommits".
	Overcommits can lead to memory exhaustion, which in turn can lead to crashes. Use carefully.
	Defaults to 100
	"""
														type: "integer"
													}
													minimumClusterTSCFrequency: {
														description: """
	Allow overriding the automatically determined minimum TSC frequency of the cluster
	and fixate the minimum to this frequency.
	"""
														format: "int64"
														type:   "integer"
													}
													minimumReservePVCBytes: {
														description: """
	MinimumReservePVCBytes is the amount of space, in bytes, to leave unused on disks.
	Defaults to 131072 (128KiB)
	"""
														format: "int64"
														type:   "integer"
													}
													nodeSelectors: {
														additionalProperties: type: "string"
														description: """
	NodeSelectors allows restricting VMI creation to nodes that match a set of labels.
	Defaults to none
	"""
														type: "object"
													}
													pvcTolerateLessSpaceUpToPercent: {
														description: """
	LessPVCSpaceToleration determines how much smaller, in percentage, disk PVCs are
	allowed to be compared to the requested size (to account for various overheads).
	Defaults to 10
	"""
														type: "integer"
													}
													useEmulation: {
														description: """
	UseEmulation can be set to true to allow fallback to software emulation
	in case hardware-assisted emulation is not available. Defaults to false
	"""
														type: "boolean"
													}
												}
												type: "object"
											}
											emulatedMachines: {
												description: "Deprecated. Use architectureConfiguration instead."
												items: type: "string"
												type: "array"
											}
											evictionStrategy: {
												description: """
	EvictionStrategy defines at the cluster level if the VirtualMachineInstance should be
	migrated instead of shut-off in case of a node drain. If the VirtualMachineInstance specific
	field is set it overrides the cluster level one.
	"""
												type: "string"
											}
											handlerConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											imagePullPolicy: {
												description: "PullPolicy describes a policy for if/when to pull a container image"
												type:        "string"
											}
											ksmConfiguration: {
												description: "KSMConfiguration holds the information regarding the enabling the KSM in the nodes (if available)."
												properties: nodeLabelSelector: {
													description: """
	NodeLabelSelector is a selector that filters in which nodes the KSM will be enabled.
	Empty NodeLabelSelector will enable ksm for every node.
	"""
													properties: {
														matchExpressions: {
															description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
															items: {
																description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																properties: {
																	key: {
																		description: "key is the label key that the selector applies to."
																		type:        "string"
																	}
																	operator: {
																		description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																		type: "string"
																	}
																	values: {
																		description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																		items: type: "string"
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																required: [
																	"key",
																	"operator",
																]
																type: "object"
															}
															type:                     "array"
															"x-kubernetes-list-type": "atomic"
														}
														matchLabels: {
															additionalProperties: type: "string"
															description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
															type: "object"
														}
													}
													type:                    "object"
													"x-kubernetes-map-type": "atomic"
												}
												type: "object"
											}
											liveUpdateConfiguration: {
												description: "LiveUpdateConfiguration holds defaults for live update features"
												properties: {
													maxCpuSockets: {
														description: "MaxCpuSockets holds the maximum amount of sockets that can be hotplugged"
														format:      "int32"
														type:        "integer"
													}
													maxGuest: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	MaxGuest defines the maximum amount memory that can be allocated
	to the guest using hotplug.
	"""
														pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
														"x-kubernetes-int-or-string": true
													}
													maxHotplugRatio: {
														description: """
	MaxHotplugRatio is the ratio used to define the max amount
	of a hotplug resource that can be made available to a VM
	when the specific Max* setting is not defined (MaxCpuSockets, MaxGuest)
	Example: VM is configured with 512Mi of guest memory, if MaxGuest is not
	defined and MaxHotplugRatio is 2 then MaxGuest = 1Gi
	defaults to 4
	"""
														format: "int32"
														type:   "integer"
													}
												}
												type: "object"
											}
											machineType: {
												description: "Deprecated. Use architectureConfiguration instead."
												type:        "string"
											}
											mediatedDevicesConfiguration: {
												description: "MediatedDevicesConfiguration holds information about MDEV types to be defined, if available"
												properties: {
													mediatedDeviceTypes: {
														items: type: "string"
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													mediatedDevicesTypes: {
														description: "Deprecated. Use mediatedDeviceTypes instead."
														items: type: "string"
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													nodeMediatedDeviceTypes: {
														items: {
															description: "NodeMediatedDeviceTypesConfig holds information about MDEV types to be defined in a specific node that matches the NodeSelector field."
															properties: {
																mediatedDeviceTypes: {
																	items: type: "string"
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
																mediatedDevicesTypes: {
																	description: "Deprecated. Use mediatedDeviceTypes instead."
																	items: type: "string"
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
																nodeSelector: {
																	additionalProperties: type: "string"
																	description: """
	NodeSelector is a selector which must be true for the vmi to fit on a node.
	Selector which must match a node's labels for the vmi to be scheduled on that node.
	More info: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/
	"""
																	type: "object"
																}
															}
															required: ["nodeSelector"]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
												}
												type: "object"
											}
											memBalloonStatsPeriod: {
												format: "int32"
												type:   "integer"
											}
											migrations: {
												description: """
	MigrationConfiguration holds migration options.
	Can be overridden for specific groups of VMs though migration policies.
	Visit https://kubevirt.io/user-guide/operations/migration_policies/ for more information.
	"""
												properties: {
													allowAutoConverge: {
														description: """
	AllowAutoConverge allows the platform to compromise performance/availability of VMIs to
	guarantee successful VMI live migrations. Defaults to false
	"""
														type: "boolean"
													}
													allowPostCopy: {
														description: """
	AllowPostCopy enables post-copy live migrations. Such migrations allow even the busiest VMIs
	to successfully live-migrate. However, events like a network failure can cause a VMI crash.
	If set to true, migrations will still start in pre-copy, but switch to post-copy when
	CompletionTimeoutPerGiB triggers. Defaults to false
	"""
														type: "boolean"
													}
													bandwidthPerMigration: {
														anyOf: [{
															type: "integer"
														}, {
															type: "string"
														}]
														description: """
	BandwidthPerMigration limits the amount of network bandwidth live migrations are allowed to use.
	The value is in quantity per second. Defaults to 0 (no limit)
	"""
														pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
														"x-kubernetes-int-or-string": true
													}
													completionTimeoutPerGiB: {
														description: """
	CompletionTimeoutPerGiB is the maximum number of seconds per GiB a migration is allowed to take.
	If a live-migration takes longer to migrate than this value multiplied by the size of the VMI,
	the migration will be cancelled, unless AllowPostCopy is true. Defaults to 800
	"""
														format: "int64"
														type:   "integer"
													}
													disableTLS: {
														description: """
	When set to true, DisableTLS will disable the additional layer of live migration encryption
	provided by KubeVirt. This is usually a bad idea. Defaults to false
	"""
														type: "boolean"
													}
													matchSELinuxLevelOnMigration: {
														description: """
	By default, the SELinux level of target virt-launcher pods is forced to the level of the source virt-launcher.
	When set to true, MatchSELinuxLevelOnMigration lets the CRI auto-assign a random level to the target.
	That will ensure the target virt-launcher doesn't share categories with another pod on the node.
	However, migrations will fail when using RWX volumes that don't automatically deal with SELinux levels.
	"""
														type: "boolean"
													}
													network: {
														description: """
	Network is the name of the CNI network to use for live migrations. By default, migrations go
	through the pod network.
	"""
														type: "string"
													}
													nodeDrainTaintKey: {
														description: """
	NodeDrainTaintKey defines the taint key that indicates a node should be drained.
	Note: this option relies on the deprecated node taint feature. Default: kubevirt.io/drain
	"""
														type: "string"
													}
													parallelMigrationsPerCluster: {
														description: """
	ParallelMigrationsPerCluster is the total number of concurrent live migrations
	allowed cluster-wide. Defaults to 5
	"""
														format: "int32"
														type:   "integer"
													}
													parallelOutboundMigrationsPerNode: {
														description: """
	ParallelOutboundMigrationsPerNode is the maximum number of concurrent outgoing live migrations
	allowed per node. Defaults to 2
	"""
														format: "int32"
														type:   "integer"
													}
													progressTimeout: {
														description: """
	ProgressTimeout is the maximum number of seconds a live migration is allowed to make no progress.
	Hitting this timeout means a migration transferred 0 data for that many seconds. The migration is
	then considered stuck and therefore cancelled. Defaults to 150
	"""
														format: "int64"
														type:   "integer"
													}
													unsafeMigrationOverride: {
														description: """
	UnsafeMigrationOverride allows live migrations to occur even if the compatibility check
	indicates the migration will be unsafe to the guest. Defaults to false
	"""
														type: "boolean"
													}
												}
												type: "object"
											}
											minCPUModel: type: "string"
											network: {
												description: "NetworkConfiguration holds network options"
												properties: {
													binding: {
														additionalProperties: {
															properties: {
																computeResourceOverhead: {
																	description: """
	ComputeResourceOverhead specifies the resource overhead that should be added to the compute container when using the binding.
	version: v1alphav1
	"""
																	properties: {
																		claims: {
																			description: """
	Claims lists the names of resources, defined in spec.resourceClaims,
	that are used by this container.


	This is an alpha field and requires enabling the
	DynamicResourceAllocation feature gate.


	This field is immutable. It can only be set for containers.
	"""
																			items: {
																				description: "ResourceClaim references one entry in PodSpec.ResourceClaims."
																				properties: name: {
																					description: """
	Name must match the name of one entry in pod.spec.resourceClaims of
	the Pod where this field is used. It makes that resource available
	inside a container.
	"""
																					type: "string"
																				}
																				required: ["name"]
																				type: "object"
																			}
																			type: "array"
																			"x-kubernetes-list-map-keys": ["name"]
																			"x-kubernetes-list-type": "map"
																		}
																		limits: {
																			additionalProperties: {
																				anyOf: [{
																					type: "integer"
																				}, {
																					type: "string"
																				}]
																				pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																				"x-kubernetes-int-or-string": true
																			}
																			description: """
	Limits describes the maximum amount of compute resources allowed.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																			type: "object"
																		}
																		requests: {
																			additionalProperties: {
																				anyOf: [{
																					type: "integer"
																				}, {
																					type: "string"
																				}]
																				pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																				"x-kubernetes-int-or-string": true
																			}
																			description: """
	Requests describes the minimum amount of compute resources required.
	If Requests is omitted for a container, it defaults to Limits if that is explicitly specified,
	otherwise to an implementation-defined value. Requests cannot exceed Limits.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																			type: "object"
																		}
																	}
																	type: "object"
																}
																domainAttachmentType: {
																	description: """
	DomainAttachmentType is a standard domain network attachment method kubevirt supports.
	Supported values: "tap".
	The standard domain attachment can be used instead or in addition to the sidecarImage.
	version: 1alphav1
	"""
																	type: "string"
																}
																downwardAPI: {
																	description: """
	DownwardAPI specifies what kind of data should be exposed to the binding plugin sidecar.
	Supported values: "device-info"
	version: v1alphav1
	"""
																	type: "string"
																}
																migration: {
																	description: """
	Migration means the VM using the plugin can be safely migrated
	version: 1alphav1
	"""
																	properties: method: {
																		description: """
	Method defines a pre-defined migration methodology
	version: 1alphav1
	"""
																		type: "string"
																	}
																	type: "object"
																}
																networkAttachmentDefinition: {
																	description: """
	NetworkAttachmentDefinition references to a NetworkAttachmentDefinition CR object.
	Format: <name>, <namespace>/<name>.
	If namespace is not specified, VMI namespace is assumed.
	version: 1alphav1
	"""
																	type: "string"
																}
																sidecarImage: {
																	description: """
	SidecarImage references a container image that runs in the virt-launcher pod.
	The sidecar handles (libvirt) domain configuration and optional services.
	version: 1alphav1
	"""
																	type: "string"
																}
															}
															type: "object"
														}
														type: "object"
													}
													defaultNetworkInterface: type:           "string"
													permitBridgeInterfaceOnPodNetwork: type: "boolean"
													permitSlirpInterface: {
														description: """
	DeprecatedPermitSlirpInterface is an alias for the deprecated PermitSlirpInterface.
	Deprecated: Removed in v1.3.
	"""
														type: "boolean"
													}
												}
												type: "object"
											}
											obsoleteCPUModels: {
												additionalProperties: type: "boolean"
												type: "object"
											}
											ovmfPath: {
												description: "Deprecated. Use architectureConfiguration instead."
												type:        "string"
											}
											permittedHostDevices: {
												description: "PermittedHostDevices holds information about devices allowed for passthrough"
												properties: {
													mediatedDevices: {
														items: {
															description: "MediatedHostDevice represents a host mediated device allowed for passthrough"
															properties: {
																externalResourceProvider: type: "boolean"
																mdevNameSelector: type:         "string"
																resourceName: type:             "string"
															}
															required: [
																"mdevNameSelector",
																"resourceName",
															]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													pciHostDevices: {
														items: {
															description: "PciHostDevice represents a host PCI device allowed for passthrough"
															properties: {
																externalResourceProvider: {
																	description: """
	If true, KubeVirt will leave the allocation and monitoring to an
	external device plugin
	"""
																	type: "boolean"
																}
																pciVendorSelector: {
																	description: "The vendor_id:product_id tuple of the PCI device"
																	type:        "string"
																}
																resourceName: {
																	description: """
	The name of the resource that is representing the device. Exposed by
	a device plugin and requested by VMs. Typically of the form
	vendor.com/product_name
	"""
																	type: "string"
																}
															}
															required: [
																"pciVendorSelector",
																"resourceName",
															]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
													usb: {
														items: {
															properties: {
																externalResourceProvider: {
																	description: """
	If true, KubeVirt will leave the allocation and monitoring to an
	external device plugin
	"""
																	type: "boolean"
																}
																resourceName: {
																	description: """
	Identifies the list of USB host devices.
	e.g: kubevirt.io/storage, kubevirt.io/bootable-usb, etc
	"""
																	type: "string"
																}
																selectors: {
																	items: {
																		properties: {
																			product: type: "string"
																			vendor: type:  "string"
																		}
																		required: [
																			"product",
																			"vendor",
																		]
																		type: "object"
																	}
																	type:                     "array"
																	"x-kubernetes-list-type": "atomic"
																}
															}
															required: ["resourceName"]
															type: "object"
														}
														type:                     "array"
														"x-kubernetes-list-type": "atomic"
													}
												}
												type: "object"
											}
											seccompConfiguration: {
												description: "SeccompConfiguration holds Seccomp configuration for Kubevirt components"
												properties: virtualMachineInstanceProfile: {
													description: "VirtualMachineInstanceProfile defines what profile should be used with virt-launcher. Defaults to none"
													properties: customProfile: {
														description: "CustomProfile allows to request arbitrary profile for virt-launcher"
														properties: {
															localhostProfile: type:      "string"
															runtimeDefaultProfile: type: "boolean"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
											selinuxLauncherType: type: "string"
											smbios: {
												properties: {
													family: type:       "string"
													manufacturer: type: "string"
													product: type:      "string"
													sku: type:          "string"
													version: type:      "string"
												}
												type: "object"
											}
											supportContainerResources: {
												description: "SupportContainerResources specifies the resource requirements for various types of supporting containers such as container disks/virtiofs/sidecars and hotplug attachment pods. If omitted a sensible default will be supplied."
												items: {
													description: "SupportContainerResources are used to specify the cpu/memory request and limits for the containers that support various features of Virtual Machines. These containers are usually idle and don't require a lot of memory or cpu."
													properties: {
														resources: {
															description: "ResourceRequirements describes the compute resource requirements."
															properties: {
																claims: {
																	description: """
	Claims lists the names of resources, defined in spec.resourceClaims,
	that are used by this container.


	This is an alpha field and requires enabling the
	DynamicResourceAllocation feature gate.


	This field is immutable. It can only be set for containers.
	"""
																	items: {
																		description: "ResourceClaim references one entry in PodSpec.ResourceClaims."
																		properties: name: {
																			description: """
	Name must match the name of one entry in pod.spec.resourceClaims of
	the Pod where this field is used. It makes that resource available
	inside a container.
	"""
																			type: "string"
																		}
																		required: ["name"]
																		type: "object"
																	}
																	type: "array"
																	"x-kubernetes-list-map-keys": ["name"]
																	"x-kubernetes-list-type": "map"
																}
																limits: {
																	additionalProperties: {
																		anyOf: [{
																			type: "integer"
																		}, {
																			type: "string"
																		}]
																		pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																		"x-kubernetes-int-or-string": true
																	}
																	description: """
	Limits describes the maximum amount of compute resources allowed.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																	type: "object"
																}
																requests: {
																	additionalProperties: {
																		anyOf: [{
																			type: "integer"
																		}, {
																			type: "string"
																		}]
																		pattern:                      "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$"
																		"x-kubernetes-int-or-string": true
																	}
																	description: """
	Requests describes the minimum amount of compute resources required.
	If Requests is omitted for a container, it defaults to Limits if that is explicitly specified,
	otherwise to an implementation-defined value. Requests cannot exceed Limits.
	More info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/
	"""
																	type: "object"
																}
															}
															type: "object"
														}
														type: type: "string"
													}
													required: [
														"resources",
														"type",
													]
													type: "object"
												}
												type: "array"
												"x-kubernetes-list-map-keys": ["type"]
												"x-kubernetes-list-type": "map"
											}
											supportedGuestAgentVersions: {
												description: "deprecated"
												items: type: "string"
												type: "array"
											}
											tlsConfiguration: {
												description: "TLSConfiguration holds TLS options"
												properties: {
													ciphers: {
														items: type: "string"
														type:                     "array"
														"x-kubernetes-list-type": "set"
													}
													minTLSVersion: {
														description: """
	MinTLSVersion is a way to specify the minimum protocol version that is acceptable for TLS connections.
	Protocol versions are based on the following most common TLS configurations:


	  https://ssl-config.mozilla.org/


	Note that SSLv3.0 is not a supported protocol version due to well known
	vulnerabilities such as POODLE: https://en.wikipedia.org/wiki/POODLE
	"""
														enum: [
															"VersionTLS10",
															"VersionTLS11",
															"VersionTLS12",
															"VersionTLS13",
														]
														type: "string"
													}
												}
												type: "object"
											}
											virtualMachineInstancesPerNode: type: "integer"
											virtualMachineOptions: {
												description: "VirtualMachineOptions holds the cluster level information regarding the virtual machine."
												properties: {
													disableFreePageReporting: {
														description: """
	DisableFreePageReporting disable the free page reporting of
	memory balloon device https://libvirt.org/formatdomain.html#memory-balloon-device.
	This will have effect only if AutoattachMemBalloon is not false and the vmi is not
	requesting any high performance feature (dedicatedCPU/realtime/hugePages), in which free page reporting is always disabled.
	"""
														type: "object"
													}
													disableSerialConsoleLog: {
														description: """
	DisableSerialConsoleLog disables logging the auto-attached default serial console.
	If not set, serial console logs will be written to a file and then streamed from a container named 'guest-console-log'.
	The value can be individually overridden for each VM, not relevant if AutoattachSerialConsole is disabled.
	"""
														type: "object"
													}
												}
												type: "object"
											}
											vmRolloutStrategy: {
												description: "VMRolloutStrategy defines how changes to a VM object propagate to its VMI"
												enum: [
													"Stage",
													"LiveUpdate",
												]
												nullable: true
												type:     "string"
											}
											vmStateStorageClass: {
												description: """
	VMStateStorageClass is the name of the storage class to use for the PVCs created to preserve VM state, like TPM.
	The storage class must support RWX in filesystem mode.
	"""
												type: "string"
											}
											webhookConfiguration: {
												description: """
	ReloadableComponentConfiguration holds all generic k8s configuration options which can
	be reloaded by components without requiring a restart.
	"""
												properties: restClient: {
													description: "RestClient can be used to tune certain aspects of the k8s client in use."
													properties: rateLimiter: {
														description: "RateLimiter allows selecting and configuring different rate limiters for the k8s client."
														properties: tokenBucketRateLimiter: {
															properties: {
																burst: {
																	description: """
	Maximum burst for throttle.
	If it's zero, the component default will be used
	"""
																	type: "integer"
																}
																qps: {
																	description: """
	QPS indicates the maximum QPS to the apiserver from this client.
	If it's zero, the component default will be used
	"""
																	type: "number"
																}
															}
															required: [
																"burst",
																"qps",
															]
															type: "object"
														}
														type: "object"
													}
													type: "object"
												}
												type: "object"
											}
										}
										type: "object"
									}
									customizeComponents: {
										properties: {
											flags: {
												description: "Configure the value used for deployment and daemonset resources"
												properties: {
													api: {
														additionalProperties: type: "string"
														type: "object"
													}
													controller: {
														additionalProperties: type: "string"
														type: "object"
													}
													handler: {
														additionalProperties: type: "string"
														type: "object"
													}
												}
												type: "object"
											}
											patches: {
												items: {
													properties: {
														patch: type: "string"
														resourceName: {
															minLength: 1
															type:      "string"
														}
														resourceType: {
															minLength: 1
															type:      "string"
														}
														type: type: "string"
													}
													required: [
														"patch",
														"resourceName",
														"resourceType",
														"type",
													]
													type: "object"
												}
												type:                     "array"
												"x-kubernetes-list-type": "atomic"
											}
										}
										type: "object"
									}
									imagePullPolicy: {
										description: "The ImagePullPolicy to use."
										type:        "string"
									}
									imagePullSecrets: {
										description: """
	The imagePullSecrets to pull the container images from
	Defaults to none
	"""
										items: {
											description: """
	LocalObjectReference contains enough information to let you locate the
	referenced object inside the same namespace.
	"""
											properties: name: {
												description: """
	Name of the referent.
	More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
	TODO: Add other useful fields. apiVersion, kind, uid?
	"""
												type: "string"
											}
											type:                    "object"
											"x-kubernetes-map-type": "atomic"
										}
										type:                     "array"
										"x-kubernetes-list-type": "atomic"
									}
									imageRegistry: {
										description: """
	The image registry to pull the container images from
	Defaults to the same registry the operator's container image is pulled from.
	"""
										type: "string"
									}
									imageTag: {
										description: """
	The image tag to use for the continer images installed.
	Defaults to the same tag as the operator's container image.
	"""
										type: "string"
									}
									infra: {
										description: "selectors and tolerations that should apply to KubeVirt infrastructure components"
										properties: {
											nodePlacement: {
												description: """
	nodePlacement describes scheduling configuration for specific
	KubeVirt components
	"""
												properties: {
													affinity: {
														description: """
	affinity enables pod affinity/anti-affinity placement expanding the types of constraints
	that can be expressed with nodeSelector.
	affinity is going to be applied to the relevant kind of pods in parallel with nodeSelector
	See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity
	"""
														properties: {
															nodeAffinity: {
																description: "Describes node affinity scheduling rules for the pod."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node matches the corresponding matchExpressions; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: """
	An empty preferred scheduling term matches all objects with implicit weight 0
	(i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).
	"""
																			properties: {
																				preference: {
																					description: "A node selector term, associated with the corresponding weight."
																					properties: {
																						matchExpressions: {
																							description: "A list of node selector requirements by node's labels."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchFields: {
																							description: "A list of node selector requirements by node's fields."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				weight: {
																					description: "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100."
																					format:      "int32"
																					type:        "integer"
																				}
																			}
																			required: [
																				"preference",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to an update), the system
	may or may not try to eventually evict the pod from its node.
	"""
																		properties: nodeSelectorTerms: {
																			description: "Required. A list of node selector terms. The terms are ORed."
																			items: {
																				description: """
	A null or empty node selector term matches no objects. The requirements of
	them are ANDed.
	The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.
	"""
																				properties: {
																					matchExpressions: {
																						description: "A list of node selector requirements by node's labels."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																					matchFields: {
																						description: "A list of node selector requirements by node's fields."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																				}
																				type:                    "object"
																				"x-kubernetes-map-type": "atomic"
																			}
																			type:                     "array"
																			"x-kubernetes-list-type": "atomic"
																		}
																		required: ["nodeSelectorTerms"]
																		type:                    "object"
																		"x-kubernetes-map-type": "atomic"
																	}
																}
																type: "object"
															}
															podAffinity: {
																description: "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
															podAntiAffinity: {
																description: "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the anti-affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling anti-affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the anti-affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the anti-affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
														}
														type: "object"
													}
													nodeSelector: {
														additionalProperties: type: "string"
														description: """
	nodeSelector is the node selector applied to the relevant kind of pods
	It specifies a map of key-value pairs: for the pod to be eligible to run on a node,
	the node must have each of the indicated key-value pairs as labels
	(it can have additional labels as well).
	See https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
	"""
														type: "object"
													}
													tolerations: {
														description: """
	tolerations is a list of tolerations applied to the relevant kind of pods
	See https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ for more info.
	These are additional tolerations other than default ones.
	"""
														items: {
															description: """
	The pod this Toleration is attached to tolerates any taint that matches
	the triple <key,value,effect> using the matching operator <operator>.
	"""
															properties: {
																effect: {
																	description: """
	Effect indicates the taint effect to match. Empty means match all taint effects.
	When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
	"""
																	type: "string"
																}
																key: {
																	description: """
	Key is the taint key that the toleration applies to. Empty means match all taint keys.
	If the key is empty, operator must be Exists; this combination means to match all values and all keys.
	"""
																	type: "string"
																}
																operator: {
																	description: """
	Operator represents a key's relationship to the value.
	Valid operators are Exists and Equal. Defaults to Equal.
	Exists is equivalent to wildcard for value, so that a pod can
	tolerate all taints of a particular category.
	"""
																	type: "string"
																}
																tolerationSeconds: {
																	description: """
	TolerationSeconds represents the period of time the toleration (which must be
	of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default,
	it is not set, which means tolerate the taint forever (do not evict). Zero and
	negative values will be treated as 0 (evict immediately) by the system.
	"""
																	format: "int64"
																	type:   "integer"
																}
																value: {
																	description: """
	Value is the taint value the toleration matches to.
	If the operator is Exists, the value should be empty, otherwise just a regular string.
	"""
																	type: "string"
																}
															}
															type: "object"
														}
														type: "array"
													}
												}
												type: "object"
											}
											replicas: {
												description: """
	replicas indicates how many replicas should be created for each KubeVirt infrastructure
	component (like virt-api or virt-controller). Defaults to 2.
	WARNING: this is an advanced feature that prevents auto-scaling for core kubevirt components. Please use with caution!
	"""
												type: "integer"
											}
										}
										type: "object"
									}
									monitorAccount: {
										description: """
	The name of the Prometheus service account that needs read-access to KubeVirt endpoints
	Defaults to prometheus-k8s
	"""
										type: "string"
									}
									monitorNamespace: {
										description: """
	The namespace Prometheus is deployed in
	Defaults to openshift-monitor
	"""
										type: "string"
									}
									productComponent: {
										description: """
	Designate the apps.kubevirt.io/component label for KubeVirt components.
	Useful if KubeVirt is included as part of a product.
	If ProductComponent is not specified, the component label default value is kubevirt.
	"""
										type: "string"
									}
									productName: {
										description: """
	Designate the apps.kubevirt.io/part-of label for KubeVirt components.
	Useful if KubeVirt is included as part of a product.
	If ProductName is not specified, the part-of label will be omitted.
	"""
										type: "string"
									}
									productVersion: {
										description: """
	Designate the apps.kubevirt.io/version label for KubeVirt components.
	Useful if KubeVirt is included as part of a product.
	If ProductVersion is not specified, KubeVirt's version will be used.
	"""
										type: "string"
									}
									serviceMonitorNamespace: {
										description: """
	The namespace the service monitor will be deployed
	 When ServiceMonitorNamespace is set, then we'll install the service monitor object in that namespace
	otherwise we will use the monitoring namespace.
	"""
										type: "string"
									}
									uninstallStrategy: {
										description: """
	Specifies if kubevirt can be deleted if workloads are still present.
	This is mainly a precaution to avoid accidental data loss
	"""
										type: "string"
									}
									workloadUpdateStrategy: {
										description: """
	WorkloadUpdateStrategy defines at the cluster level how to handle
	automated workload updates
	"""
										properties: {
											batchEvictionInterval: {
												description: """
	BatchEvictionInterval Represents the interval to wait before issuing the next
	batch of shutdowns


	Defaults to 1 minute
	"""
												type: "string"
											}
											batchEvictionSize: {
												description: """
	BatchEvictionSize Represents the number of VMIs that can be forced updated per
	the BatchShutdownInteral interval


	Defaults to 10
	"""
												type: "integer"
											}
											workloadUpdateMethods: {
												description: """
	WorkloadUpdateMethods defines the methods that can be used to disrupt workloads
	during automated workload updates.
	When multiple methods are present, the least disruptive method takes
	precedence over more disruptive methods. For example if both LiveMigrate and Shutdown
	methods are listed, only VMs which are not live migratable will be restarted/shutdown


	An empty list defaults to no automated workload updating
	"""
												items: type: "string"
												type:                     "array"
												"x-kubernetes-list-type": "atomic"
											}
										}
										type: "object"
									}
									workloads: {
										description: "selectors and tolerations that should apply to KubeVirt workloads"
										properties: {
											nodePlacement: {
												description: """
	nodePlacement describes scheduling configuration for specific
	KubeVirt components
	"""
												properties: {
													affinity: {
														description: """
	affinity enables pod affinity/anti-affinity placement expanding the types of constraints
	that can be expressed with nodeSelector.
	affinity is going to be applied to the relevant kind of pods in parallel with nodeSelector
	See https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity
	"""
														properties: {
															nodeAffinity: {
																description: "Describes node affinity scheduling rules for the pod."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node matches the corresponding matchExpressions; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: """
	An empty preferred scheduling term matches all objects with implicit weight 0
	(i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).
	"""
																			properties: {
																				preference: {
																					description: "A node selector term, associated with the corresponding weight."
																					properties: {
																						matchExpressions: {
																							description: "A list of node selector requirements by node's labels."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchFields: {
																							description: "A list of node selector requirements by node's fields."
																							items: {
																								description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "The label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				weight: {
																					description: "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100."
																					format:      "int32"
																					type:        "integer"
																				}
																			}
																			required: [
																				"preference",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to an update), the system
	may or may not try to eventually evict the pod from its node.
	"""
																		properties: nodeSelectorTerms: {
																			description: "Required. A list of node selector terms. The terms are ORed."
																			items: {
																				description: """
	A null or empty node selector term matches no objects. The requirements of
	them are ANDed.
	The TopologySelectorTerm type implements a subset of the NodeSelectorTerm.
	"""
																				properties: {
																					matchExpressions: {
																						description: "A list of node selector requirements by node's labels."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																					matchFields: {
																						description: "A list of node selector requirements by node's fields."
																						items: {
																							description: """
	A node selector requirement is a selector that contains values, a key, and an operator
	that relates the key and values.
	"""
																							properties: {
																								key: {
																									description: "The label key that the selector applies to."
																									type:        "string"
																								}
																								operator: {
																									description: """
	Represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
	"""
																									type: "string"
																								}
																								values: {
																									description: """
	An array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. If the operator is Gt or Lt, the values
	array must have a single element, which will be interpreted as an integer.
	This array is replaced during a strategic merge patch.
	"""
																									items: type: "string"
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																							}
																							required: [
																								"key",
																								"operator",
																							]
																							type: "object"
																						}
																						type:                     "array"
																						"x-kubernetes-list-type": "atomic"
																					}
																				}
																				type:                    "object"
																				"x-kubernetes-map-type": "atomic"
																			}
																			type:                     "array"
																			"x-kubernetes-list-type": "atomic"
																		}
																		required: ["nodeSelectorTerms"]
																		type:                    "object"
																		"x-kubernetes-map-type": "atomic"
																	}
																}
																type: "object"
															}
															podAffinity: {
																description: "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
															podAntiAffinity: {
																description: "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s))."
																properties: {
																	preferredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	The scheduler will prefer to schedule pods to nodes that satisfy
	the anti-affinity expressions specified by this field, but it may choose
	a node that violates one or more of the expressions. The node that is
	most preferred is the one with the greatest sum of weights, i.e.
	for each node that meets all of the scheduling requirements (resource
	request, requiredDuringScheduling anti-affinity expressions, etc.),
	compute a sum by iterating through the elements of this field and adding
	"weight" to the sum if the node has pods which matches the corresponding podAffinityTerm; the
	node(s) with the highest sum are the most preferred.
	"""
																		items: {
																			description: "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)"
																			properties: {
																				podAffinityTerm: {
																					description: "Required. A pod affinity term, associated with the corresponding weight."
																					properties: {
																						labelSelector: {
																							description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						matchLabelKeys: {
																							description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						mismatchLabelKeys: {
																							description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						namespaceSelector: {
																							description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																							properties: {
																								matchExpressions: {
																									description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																									items: {
																										description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																										properties: {
																											key: {
																												description: "key is the label key that the selector applies to."
																												type:        "string"
																											}
																											operator: {
																												description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																												type: "string"
																											}
																											values: {
																												description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																												items: type: "string"
																												type:                     "array"
																												"x-kubernetes-list-type": "atomic"
																											}
																										}
																										required: [
																											"key",
																											"operator",
																										]
																										type: "object"
																									}
																									type:                     "array"
																									"x-kubernetes-list-type": "atomic"
																								}
																								matchLabels: {
																									additionalProperties: type: "string"
																									description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																									type: "object"
																								}
																							}
																							type:                    "object"
																							"x-kubernetes-map-type": "atomic"
																						}
																						namespaces: {
																							description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																							items: type: "string"
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						topologyKey: {
																							description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																							type: "string"
																						}
																					}
																					required: ["topologyKey"]
																					type: "object"
																				}
																				weight: {
																					description: """
	weight associated with matching the corresponding podAffinityTerm,
	in the range 1-100.
	"""
																					format: "int32"
																					type:   "integer"
																				}
																			}
																			required: [
																				"podAffinityTerm",
																				"weight",
																			]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																	requiredDuringSchedulingIgnoredDuringExecution: {
																		description: """
	If the anti-affinity requirements specified by this field are not met at
	scheduling time, the pod will not be scheduled onto the node.
	If the anti-affinity requirements specified by this field cease to be met
	at some point during pod execution (e.g. due to a pod label update), the
	system may or may not try to eventually evict the pod from its node.
	When there are multiple elements, the lists of nodes corresponding to each
	podAffinityTerm are intersected, i.e. all terms must be satisfied.
	"""
																		items: {
																			description: """
	Defines a set of pods (namely those matching the labelSelector
	relative to the given namespace(s)) that this pod should be
	co-located (affinity) or not co-located (anti-affinity) with,
	where co-located is defined as running on a node whose value of
	the label with key <topologyKey> matches that of any node on which
	a pod of the set of pods is running
	"""
																			properties: {
																				labelSelector: {
																					description: """
	A label query over a set of resources, in this case pods.
	If it's null, this PodAffinityTerm matches with no Pods.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				matchLabelKeys: {
																					description: """
	MatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key in (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both matchLabelKeys and labelSelector.
	Also, matchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				mismatchLabelKeys: {
																					description: """
	MismatchLabelKeys is a set of pod label keys to select which pods will
	be taken into consideration. The keys are used to lookup values from the
	incoming pod labels, those key-value labels are merged with 'labelSelector' as 'key notin (value)'
	to select the group of existing pods which pods will be taken into consideration
	for the incoming pod's pod (anti) affinity. Keys that don't exist in the incoming
	pod labels will be ignored. The default value is empty.
	The same key is forbidden to exist in both mismatchLabelKeys and labelSelector.
	Also, mismatchLabelKeys cannot be set when labelSelector isn't set.
	This is an alpha field and requires enabling MatchLabelKeysInPodAffinity feature gate.
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				namespaceSelector: {
																					description: """
	A label query over the set of namespaces that the term applies to.
	The term is applied to the union of the namespaces selected by this field
	and the ones listed in the namespaces field.
	null selector and null or empty namespaces list means "this pod's namespace".
	An empty selector ({}) matches all namespaces.
	"""
																					properties: {
																						matchExpressions: {
																							description: "matchExpressions is a list of label selector requirements. The requirements are ANDed."
																							items: {
																								description: """
	A label selector requirement is a selector that contains values, a key, and an operator that
	relates the key and values.
	"""
																								properties: {
																									key: {
																										description: "key is the label key that the selector applies to."
																										type:        "string"
																									}
																									operator: {
																										description: """
	operator represents a key's relationship to a set of values.
	Valid operators are In, NotIn, Exists and DoesNotExist.
	"""
																										type: "string"
																									}
																									values: {
																										description: """
	values is an array of string values. If the operator is In or NotIn,
	the values array must be non-empty. If the operator is Exists or DoesNotExist,
	the values array must be empty. This array is replaced during a strategic
	merge patch.
	"""
																										items: type: "string"
																										type:                     "array"
																										"x-kubernetes-list-type": "atomic"
																									}
																								}
																								required: [
																									"key",
																									"operator",
																								]
																								type: "object"
																							}
																							type:                     "array"
																							"x-kubernetes-list-type": "atomic"
																						}
																						matchLabels: {
																							additionalProperties: type: "string"
																							description: """
	matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels
	map is equivalent to an element of matchExpressions, whose key field is "key", the
	operator is "In", and the values array contains only "value". The requirements are ANDed.
	"""
																							type: "object"
																						}
																					}
																					type:                    "object"
																					"x-kubernetes-map-type": "atomic"
																				}
																				namespaces: {
																					description: """
	namespaces specifies a static list of namespace names that the term applies to.
	The term is applied to the union of the namespaces listed in this field
	and the ones selected by namespaceSelector.
	null or empty namespaces list and null namespaceSelector means "this pod's namespace".
	"""
																					items: type: "string"
																					type:                     "array"
																					"x-kubernetes-list-type": "atomic"
																				}
																				topologyKey: {
																					description: """
	This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching
	the labelSelector in the specified namespaces, where co-located is defined as running on a node
	whose value of the label with key topologyKey matches that of any node on which any of the
	selected pods is running.
	Empty topologyKey is not allowed.
	"""
																					type: "string"
																				}
																			}
																			required: ["topologyKey"]
																			type: "object"
																		}
																		type:                     "array"
																		"x-kubernetes-list-type": "atomic"
																	}
																}
																type: "object"
															}
														}
														type: "object"
													}
													nodeSelector: {
														additionalProperties: type: "string"
														description: """
	nodeSelector is the node selector applied to the relevant kind of pods
	It specifies a map of key-value pairs: for the pod to be eligible to run on a node,
	the node must have each of the indicated key-value pairs as labels
	(it can have additional labels as well).
	See https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
	"""
														type: "object"
													}
													tolerations: {
														description: """
	tolerations is a list of tolerations applied to the relevant kind of pods
	See https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ for more info.
	These are additional tolerations other than default ones.
	"""
														items: {
															description: """
	The pod this Toleration is attached to tolerates any taint that matches
	the triple <key,value,effect> using the matching operator <operator>.
	"""
															properties: {
																effect: {
																	description: """
	Effect indicates the taint effect to match. Empty means match all taint effects.
	When specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.
	"""
																	type: "string"
																}
																key: {
																	description: """
	Key is the taint key that the toleration applies to. Empty means match all taint keys.
	If the key is empty, operator must be Exists; this combination means to match all values and all keys.
	"""
																	type: "string"
																}
																operator: {
																	description: """
	Operator represents a key's relationship to the value.
	Valid operators are Exists and Equal. Defaults to Equal.
	Exists is equivalent to wildcard for value, so that a pod can
	tolerate all taints of a particular category.
	"""
																	type: "string"
																}
																tolerationSeconds: {
																	description: """
	TolerationSeconds represents the period of time the toleration (which must be
	of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default,
	it is not set, which means tolerate the taint forever (do not evict). Zero and
	negative values will be treated as 0 (evict immediately) by the system.
	"""
																	format: "int64"
																	type:   "integer"
																}
																value: {
																	description: """
	Value is the taint value the toleration matches to.
	If the operator is Exists, the value should be empty, otherwise just a regular string.
	"""
																	type: "string"
																}
															}
															type: "object"
														}
														type: "array"
													}
												}
												type: "object"
											}
											replicas: {
												description: """
	replicas indicates how many replicas should be created for each KubeVirt infrastructure
	component (like virt-api or virt-controller). Defaults to 2.
	WARNING: this is an advanced feature that prevents auto-scaling for core kubevirt components. Please use with caution!
	"""
												type: "integer"
											}
										}
										type: "object"
									}
								}
								type: "object"
							}
							status: {
								description: "KubeVirtStatus represents information pertaining to a KubeVirt deployment."
								properties: {
									conditions: {
										items: {
											description: "KubeVirtCondition represents a condition of a KubeVirt deployment"
											properties: {
												lastProbeTime: {
													format:   "date-time"
													nullable: true
													type:     "string"
												}
												lastTransitionTime: {
													format:   "date-time"
													nullable: true
													type:     "string"
												}
												message: type: "string"
												reason: type:  "string"
												status: type:  "string"
												type: type:    "string"
											}
											required: [
												"status",
												"type",
											]
											type: "object"
										}
										type: "array"
									}
									defaultArchitecture: type: "string"
									generations: {
										items: {
											description: "GenerationStatus keeps track of the generation for a given resource so that decisions about forced updates can be made."
											properties: {
												group: {
													description: "group is the group of the thing you're tracking"
													type:        "string"
												}
												hash: {
													description: "hash is an optional field set for resources without generation that are content sensitive like secrets and configmaps"
													type:        "string"
												}
												lastGeneration: {
													description: "lastGeneration is the last generation of the workload controller involved"
													format:      "int64"
													type:        "integer"
												}
												name: {
													description: "name is the name of the thing you're tracking"
													type:        "string"
												}
												namespace: {
													description: "namespace is where the thing you're tracking is"
													type:        "string"
												}
												resource: {
													description: "resource is the resource type of the thing you're tracking"
													type:        "string"
												}
											}
											required: [
												"group",
												"lastGeneration",
												"name",
												"resource",
											]
											type: "object"
										}
										type:                     "array"
										"x-kubernetes-list-type": "atomic"
									}
									observedDeploymentConfig: type: "string"
									observedDeploymentID: type:     "string"
									observedGeneration: {
										format: "int64"
										type:   "integer"
									}
									observedKubeVirtRegistry: type:                "string"
									observedKubeVirtVersion: type:                 "string"
									operatorVersion: type:                         "string"
									outdatedVirtualMachineInstanceWorkloads: type: "integer"
									phase: {
										description: "KubeVirtPhase is a label for the phase of a KubeVirt deployment at the current time."
										type:        "string"
									}
									targetDeploymentConfig: type: "string"
									targetDeploymentID: type:     "string"
									targetKubeVirtRegistry: type: "string"
									targetKubeVirtVersion: type:  "string"
								}
								type: "object"
							}
						}
						required: ["spec"]
						type: "object"
					}
					served:  true
					storage: false
					subresources: status: {}
				}]
			}
		}
		priorityclass: {
			apiVersion: "scheduling.k8s.io/v1"
			kind:       "PriorityClass"
			metadata: name: "kubevirt-cluster-critical"
			value:         1000000000
			globalDefault: false
			description:   "This priority class should be used for core kubevirt components only."
		}
		clusterrole1: {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRole"
			metadata: {
				name: "kubevirt.io:operator"
				labels: {
					"operator.kubevirt.io":                         ""
					"rbac.authorization.k8s.io/aggregate-to-admin": "true"
				}
			}
			rules: [{
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
					"deletecollection",
				]
			}]
		}
		serviceaccount: {
			apiVersion: "v1"
			kind:       "ServiceAccount"
			metadata: {
				labels: "kubevirt.io": ""
				name:      "kubevirt-operator"
				namespace: #config.targetNamespace
			}
		}
		role: {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "Role"
			metadata: {
				labels: "kubevirt.io": ""
				name:      "kubevirt-operator"
				namespace: #config.targetNamespace
			}
			rules: [{
				apiGroups: [""]
				resourceNames: [
					"kubevirt-ca",
					"kubevirt-export-ca",
					"kubevirt-virt-handler-certs",
					"kubevirt-virt-handler-server-certs",
					"kubevirt-operator-certs",
					"kubevirt-virt-api-certs",
					"kubevirt-controller-certs",
					"kubevirt-exportproxy-certs",
				]
				resources: ["secrets"]
				verbs: [
					"create",
					"get",
					"list",
					"watch",
					"patch",
					"delete",
				]
			}, {
				apiGroups: [""]
				resources: ["configmaps"]
				verbs: [
					"create",
					"get",
					"list",
					"watch",
					"patch",
					"delete",
				]
			}, {
				apiGroups: ["route.openshift.io"]
				resources: ["routes"]
				verbs: [
					"create",
					"get",
					"list",
					"watch",
					"patch",
					"delete",
				]
			}, {
				apiGroups: ["route.openshift.io"]
				resources: ["routes/custom-host"]
				verbs: ["create"]
			}, {
				apiGroups: ["coordination.k8s.io"]
				resources: ["leases"]
				verbs: [
					"get",
					"list",
					"watch",
					"delete",
					"update",
					"create",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: ["configmaps"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["route.openshift.io"]
				resources: ["routes"]
				verbs: [
					"list",
					"get",
					"watch",
				]
			}, {
				apiGroups: [""]
				resources: ["secrets"]
				verbs: [
					"list",
					"get",
					"watch",
				]
			}, {
				apiGroups: ["networking.k8s.io"]
				resources: ["ingresses"]
				verbs: [
					"list",
					"get",
					"watch",
				]
			}, {
				apiGroups: ["coordination.k8s.io"]
				resources: ["leases"]
				verbs: [
					"get",
					"list",
					"watch",
					"delete",
					"update",
					"create",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: ["configmaps"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: [""]
				resourceNames: ["kubevirt-export-ca"]
				resources: ["configmaps"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}]
		}
		rolebinding: {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "RoleBinding"
			metadata: {
				labels: "kubevirt.io": ""
				name:      "kubevirt-operator-rolebinding"
				namespace: #config.targetNamespace
			}
			roleRef: {
				apiGroup: "rbac.authorization.k8s.io"
				kind:     "Role"
				name:     "kubevirt-operator"
			}
			subjects: [{
				kind:      "ServiceAccount"
				name:      "kubevirt-operator"
				namespace: #config.targetNamespace
			}]
		}
		clusterrole2: {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRole"
			metadata: {
				labels: "kubevirt.io": ""
				name: "kubevirt-operator"
			}
			rules: [{
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"get",
					"list",
					"watch",
					"patch",
					"update",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: [
					"serviceaccounts",
					"services",
					"endpoints",
					"pods/exec",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"update",
					"delete",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: ["configmaps"]
				verbs: [
					"patch",
					"delete",
				]
			}, {
				apiGroups: ["batch"]
				resources: ["jobs"]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"delete",
					"patch",
				]
			}, {
				apiGroups: ["apps"]
				resources: ["controllerrevisions"]
				verbs: [
					"watch",
					"list",
					"create",
					"delete",
					"patch",
				]
			}, {
				apiGroups: ["apps"]
				resources: [
					"deployments",
					"daemonsets",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"delete",
					"patch",
				]
			}, {
				apiGroups: ["rbac.authorization.k8s.io"]
				resources: [
					"clusterroles",
					"clusterrolebindings",
					"roles",
					"rolebindings",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"delete",
					"patch",
					"update",
				]
			}, {
				apiGroups: ["apiextensions.k8s.io"]
				resources: ["customresourcedefinitions"]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"delete",
					"patch",
				]
			}, {
				apiGroups: ["security.openshift.io"]
				resources: ["securitycontextconstraints"]
				verbs: [
					"create",
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["security.openshift.io"]
				resourceNames: ["privileged"]
				resources: ["securitycontextconstraints"]
				verbs: [
					"get",
					"patch",
					"update",
				]
			}, {
				apiGroups: ["security.openshift.io"]
				resourceNames: [
					"kubevirt-handler",
					"kubevirt-controller",
				]
				resources: ["securitycontextconstraints"]
				verbs: [
					"get",
					"list",
					"watch",
					"update",
					"delete",
				]
			}, {
				apiGroups: ["admissionregistration.k8s.io"]
				resources: [
					"validatingwebhookconfigurations",
					"mutatingwebhookconfigurations",
					"validatingadmissionpolicybindings",
					"validatingadmissionpolicies",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"delete",
					"update",
					"patch",
				]
			}, {
				apiGroups: ["apiregistration.k8s.io"]
				resources: ["apiservices"]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"delete",
					"update",
					"patch",
				]
			}, {
				apiGroups: ["monitoring.coreos.com"]
				resources: [
					"servicemonitors",
					"prometheusrules",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"delete",
					"update",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: ["namespaces"]
				verbs: [
					"get",
					"list",
					"watch",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: ["pods"]
				verbs: [
					"get",
					"list",
					"delete",
					"patch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: [
					"virtualmachines",
					"virtualmachineinstances",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"patch",
					"update",
				]
			}, {
				apiGroups: [""]
				resources: ["persistentvolumeclaims"]
				verbs: ["get"]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["virtualmachines/status"]
				verbs: ["patch"]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["virtualmachineinstancemigrations"]
				verbs: [
					"create",
					"get",
					"list",
					"watch",
					"patch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["virtualmachineinstancepresets"]
				verbs: [
					"watch",
					"list",
				]
			}, {
				apiGroups: [""]
				resources: ["configmaps"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: [""]
				resources: ["limitranges"]
				verbs: [
					"watch",
					"list",
				]
			}, {
				apiGroups: ["apiextensions.k8s.io"]
				resources: ["customresourcedefinitions"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["snapshot.kubevirt.io"]
				resources: [
					"virtualmachinesnapshots",
					"virtualmachinerestores",
					"virtualmachinesnapshotcontents",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["cdi.kubevirt.io"]
				resources: [
					"datasources",
					"datavolumes",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: [""]
				resources: ["namespaces"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["instancetype.kubevirt.io"]
				resources: [
					"virtualmachineinstancetypes",
					"virtualmachineclusterinstancetypes",
					"virtualmachinepreferences",
					"virtualmachineclusterpreferences",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["migrations.kubevirt.io"]
				resources: ["migrationpolicies"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["apps"]
				resources: ["controllerrevisions"]
				verbs: [
					"create",
					"list",
					"get",
				]
			}, {
				apiGroups: [""]
				resources: ["namespaces"]
				verbs: [
					"get",
					"list",
					"watch",
					"patch",
				]
			}, {
				apiGroups: ["policy"]
				resources: ["poddisruptionbudgets"]
				verbs: [
					"get",
					"list",
					"watch",
					"delete",
					"create",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: [
					"pods",
					"configmaps",
					"endpoints",
					"services",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"delete",
					"update",
					"create",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: ["events"]
				verbs: [
					"update",
					"create",
					"patch",
				]
			}, {
				apiGroups: [""]
				resources: ["secrets"]
				verbs: ["create"]
			}, {
				apiGroups: [""]
				resources: ["pods/finalizers"]
				verbs: ["update"]
			}, {
				apiGroups: [""]
				resources: ["pods/eviction"]
				verbs: ["create"]
			}, {
				apiGroups: [""]
				resources: ["pods/status"]
				verbs: ["patch"]
			}, {
				apiGroups: [""]
				resources: ["nodes"]
				verbs: [
					"get",
					"list",
					"watch",
					"update",
					"patch",
				]
			}, {
				apiGroups: ["apps"]
				resources: ["daemonsets"]
				verbs: ["list"]
			}, {
				apiGroups: ["apps"]
				resources: ["controllerrevisions"]
				verbs: [
					"watch",
					"list",
					"create",
					"delete",
					"get",
					"update",
				]
			}, {
				apiGroups: [""]
				resources: ["persistentvolumeclaims"]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"update",
					"delete",
					"patch",
				]
			}, {
				apiGroups: ["snapshot.kubevirt.io"]
				resources: ["*"]
				verbs: ["*"]
			}, {
				apiGroups: ["export.kubevirt.io"]
				resources: ["*"]
				verbs: ["*"]
			}, {
				apiGroups: ["pool.kubevirt.io"]
				resources: [
					"virtualmachinepools",
					"virtualmachinepools/finalizers",
					"virtualmachinepools/status",
					"virtualmachinepools/scale",
				]
				verbs: [
					"watch",
					"list",
					"create",
					"delete",
					"update",
					"patch",
					"get",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["*"]
				verbs: ["*"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachineinstances/addvolume",
					"virtualmachineinstances/removevolume",
					"virtualmachineinstances/freeze",
					"virtualmachineinstances/unfreeze",
					"virtualmachineinstances/softreboot",
					"virtualmachineinstances/sev/setupsession",
					"virtualmachineinstances/sev/injectlaunchsecret",
				]
				verbs: ["update"]
			}, {
				apiGroups: ["cdi.kubevirt.io"]
				resources: ["*"]
				verbs: ["*"]
			}, {
				apiGroups: ["k8s.cni.cncf.io"]
				resources: ["network-attachment-definitions"]
				verbs: ["get"]
			}, {
				apiGroups: ["apiextensions.k8s.io"]
				resources: ["customresourcedefinitions"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["authorization.k8s.io"]
				resources: ["subjectaccessreviews"]
				verbs: ["create"]
			}, {
				apiGroups: ["snapshot.storage.k8s.io"]
				resources: ["volumesnapshotclasses"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["snapshot.storage.k8s.io"]
				resources: ["volumesnapshots"]
				verbs: [
					"get",
					"list",
					"watch",
					"create",
					"update",
					"delete",
				]
			}, {
				apiGroups: ["storage.k8s.io"]
				resources: ["storageclasses"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["instancetype.kubevirt.io"]
				resources: [
					"virtualmachineinstancetypes",
					"virtualmachineclusterinstancetypes",
					"virtualmachinepreferences",
					"virtualmachineclusterpreferences",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["migrations.kubevirt.io"]
				resources: ["migrationpolicies"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["clone.kubevirt.io"]
				resources: [
					"virtualmachineclones",
					"virtualmachineclones/status",
					"virtualmachineclones/finalizers",
				]
				verbs: [
					"get",
					"list",
					"watch",
					"update",
					"patch",
					"delete",
				]
			}, {
				apiGroups: [""]
				resources: ["namespaces"]
				verbs: ["get"]
			}, {
				apiGroups: [""]
				resources: ["resourcequotas"]
				verbs: [
					"list",
					"watch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["virtualmachineinstances"]
				verbs: [
					"update",
					"list",
					"watch",
				]
			}, {
				apiGroups: [""]
				resources: ["nodes"]
				verbs: [
					"patch",
					"list",
					"watch",
					"get",
				]
			}, {
				apiGroups: [""]
				resources: ["configmaps"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: [""]
				resources: ["events"]
				verbs: [
					"create",
					"patch",
				]
			}, {
				apiGroups: ["apiextensions.k8s.io"]
				resources: ["customresourcedefinitions"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["migrations.kubevirt.io"]
				resources: ["migrationpolicies"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["export.kubevirt.io"]
				resources: ["virtualmachineexports"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"list",
					"watch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"get",
					"list",
				]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"version",
					"guestfs",
				]
				verbs: [
					"get",
					"list",
				]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachineinstances/console",
					"virtualmachineinstances/vnc",
					"virtualmachineinstances/vnc/screenshot",
					"virtualmachineinstances/portforward",
					"virtualmachineinstances/guestosinfo",
					"virtualmachineinstances/filesystemlist",
					"virtualmachineinstances/userlist",
					"virtualmachineinstances/sev/fetchcertchain",
					"virtualmachineinstances/sev/querylaunchmeasurement",
				]
				verbs: ["get"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachineinstances/pause",
					"virtualmachineinstances/unpause",
					"virtualmachineinstances/addvolume",
					"virtualmachineinstances/removevolume",
					"virtualmachineinstances/freeze",
					"virtualmachineinstances/unfreeze",
					"virtualmachineinstances/softreboot",
					"virtualmachineinstances/sev/setupsession",
					"virtualmachineinstances/sev/injectlaunchsecret",
				]
				verbs: ["update"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachines/expand-spec",
					"virtualmachines/portforward",
				]
				verbs: ["get"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachines/start",
					"virtualmachines/stop",
					"virtualmachines/restart",
					"virtualmachines/addvolume",
					"virtualmachines/removevolume",
					"virtualmachines/migrate",
					"virtualmachines/memorydump",
				]
				verbs: ["update"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: ["expand-vm-spec"]
				verbs: ["update"]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: [
					"virtualmachines",
					"virtualmachineinstances",
					"virtualmachineinstancepresets",
					"virtualmachineinstancereplicasets",
					"virtualmachineinstancemigrations",
				]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
					"deletecollection",
				]
			}, {
				apiGroups: ["snapshot.kubevirt.io"]
				resources: [
					"virtualmachinesnapshots",
					"virtualmachinesnapshotcontents",
					"virtualmachinerestores",
				]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
					"deletecollection",
				]
			}, {
				apiGroups: ["export.kubevirt.io"]
				resources: ["virtualmachineexports"]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
					"deletecollection",
				]
			}, {
				apiGroups: ["clone.kubevirt.io"]
				resources: ["virtualmachineclones"]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
					"deletecollection",
				]
			}, {
				apiGroups: ["instancetype.kubevirt.io"]
				resources: [
					"virtualmachineinstancetypes",
					"virtualmachineclusterinstancetypes",
					"virtualmachinepreferences",
					"virtualmachineclusterpreferences",
				]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
					"deletecollection",
				]
			}, {
				apiGroups: ["pool.kubevirt.io"]
				resources: ["virtualmachinepools"]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
					"deletecollection",
				]
			}, {
				apiGroups: ["migrations.kubevirt.io"]
				resources: ["migrationpolicies"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachineinstances/console",
					"virtualmachineinstances/vnc",
					"virtualmachineinstances/vnc/screenshot",
					"virtualmachineinstances/portforward",
					"virtualmachineinstances/guestosinfo",
					"virtualmachineinstances/filesystemlist",
					"virtualmachineinstances/userlist",
					"virtualmachineinstances/sev/fetchcertchain",
					"virtualmachineinstances/sev/querylaunchmeasurement",
				]
				verbs: ["get"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachineinstances/pause",
					"virtualmachineinstances/unpause",
					"virtualmachineinstances/addvolume",
					"virtualmachineinstances/removevolume",
					"virtualmachineinstances/freeze",
					"virtualmachineinstances/unfreeze",
					"virtualmachineinstances/softreboot",
					"virtualmachineinstances/sev/setupsession",
					"virtualmachineinstances/sev/injectlaunchsecret",
				]
				verbs: ["update"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachines/expand-spec",
					"virtualmachines/portforward",
				]
				verbs: ["get"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachines/start",
					"virtualmachines/stop",
					"virtualmachines/restart",
					"virtualmachines/addvolume",
					"virtualmachines/removevolume",
					"virtualmachines/migrate",
					"virtualmachines/memorydump",
				]
				verbs: ["update"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: ["expand-vm-spec"]
				verbs: ["update"]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: [
					"virtualmachines",
					"virtualmachineinstances",
					"virtualmachineinstancepresets",
					"virtualmachineinstancereplicasets",
					"virtualmachineinstancemigrations",
				]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["snapshot.kubevirt.io"]
				resources: [
					"virtualmachinesnapshots",
					"virtualmachinesnapshotcontents",
					"virtualmachinerestores",
				]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["export.kubevirt.io"]
				resources: ["virtualmachineexports"]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["clone.kubevirt.io"]
				resources: ["virtualmachineclones"]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["instancetype.kubevirt.io"]
				resources: [
					"virtualmachineinstancetypes",
					"virtualmachineclusterinstancetypes",
					"virtualmachinepreferences",
					"virtualmachineclusterpreferences",
				]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["pool.kubevirt.io"]
				resources: ["virtualmachinepools"]
				verbs: [
					"get",
					"delete",
					"create",
					"update",
					"patch",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"get",
					"list",
				]
			}, {
				apiGroups: ["migrations.kubevirt.io"]
				resources: ["migrationpolicies"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: ["kubevirts"]
				verbs: [
					"get",
					"list",
				]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: [
					"virtualmachines/expand-spec",
					"virtualmachineinstances/guestosinfo",
					"virtualmachineinstances/filesystemlist",
					"virtualmachineinstances/userlist",
					"virtualmachineinstances/sev/fetchcertchain",
					"virtualmachineinstances/sev/querylaunchmeasurement",
				]
				verbs: ["get"]
			}, {
				apiGroups: ["subresources.kubevirt.io"]
				resources: ["expand-vm-spec"]
				verbs: ["update"]
			}, {
				apiGroups: ["kubevirt.io"]
				resources: [
					"virtualmachines",
					"virtualmachineinstances",
					"virtualmachineinstancepresets",
					"virtualmachineinstancereplicasets",
					"virtualmachineinstancemigrations",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["snapshot.kubevirt.io"]
				resources: [
					"virtualmachinesnapshots",
					"virtualmachinesnapshotcontents",
					"virtualmachinerestores",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["export.kubevirt.io"]
				resources: ["virtualmachineexports"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["clone.kubevirt.io"]
				resources: ["virtualmachineclones"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["instancetype.kubevirt.io"]
				resources: [
					"virtualmachineinstancetypes",
					"virtualmachineclusterinstancetypes",
					"virtualmachinepreferences",
					"virtualmachineclusterpreferences",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["pool.kubevirt.io"]
				resources: ["virtualmachinepools"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["migrations.kubevirt.io"]
				resources: ["migrationpolicies"]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["instancetype.kubevirt.io"]
				resources: [
					"virtualmachineclusterinstancetypes",
					"virtualmachineclusterpreferences",
				]
				verbs: [
					"get",
					"list",
					"watch",
				]
			}, {
				apiGroups: ["authentication.k8s.io"]
				resources: ["tokenreviews"]
				verbs: ["create"]
			}, {
				apiGroups: ["authorization.k8s.io"]
				resources: ["subjectaccessreviews"]
				verbs: ["create"]
			}]

		}
		clusterrolebinding: {
			apiVersion: "rbac.authorization.k8s.io/v1"
			kind:       "ClusterRoleBinding"
			metadata: {
				labels: "kubevirt.io": ""
				name: "kubevirt-operator"
			}
			roleRef: {
				apiGroup: "rbac.authorization.k8s.io"
				kind:     "ClusterRole"
				name:     "kubevirt-operator"
			}
			subjects: [{
				kind:      "ServiceAccount"
				name:      "kubevirt-operator"
				namespace: #config.targetNamespace
			}]
		}
		deployment: {
			apiVersion: "apps/v1"
			kind:       "Deployment"
			metadata: {
				labels: "kubevirt.io": "virt-operator"
				name:      "virt-operator"
				namespace: #config.targetNamespace
			}
			spec: {
				replicas: 2
				selector: matchLabels: "kubevirt.io": "virt-operator"
				strategy: type: "RollingUpdate"
				template: {
					metadata: {
						labels: {
							"kubevirt.io":            "virt-operator"
							name:                     "virt-operator"
							"prometheus.kubevirt.io": "true"
						}
						name: "virt-operator"
					}
					spec: {
						affinity: podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
							podAffinityTerm: {
								labelSelector: matchExpressions: [{
									key:      "kubevirt.io"
									operator: "In"
									values: ["virt-operator"]
								}]
								topologyKey: "kubernetes.io/hostname"
							}
							weight: 1
						}]
						containers: [{
							args: [
								"--port",
								"8443",
								"-v",
								"2",
							]
							command: ["virt-operator"]
							env: [{
								name:  "VIRT_OPERATOR_IMAGE"
								value: "quay.io/kubevirt/virt-operator:v1.3.1"
							}, {
								name: "WATCH_NAMESPACE"
								valueFrom: fieldRef: fieldPath: "metadata.annotations['olm.targetNamespaces']"
							}, {
								name:  "KUBEVIRT_VERSION"
								value: "v1.3.1"
							}]
							image:           "quay.io/kubevirt/virt-operator:v1.3.1"
							imagePullPolicy: "IfNotPresent"
							name:            "virt-operator"
							ports: [{
								containerPort: 8443
								name:          "metrics"
								protocol:      "TCP"
							}, {
								containerPort: 8444
								name:          "webhooks"
								protocol:      "TCP"
							}]
							readinessProbe: {
								httpGet: {
									path:   "/metrics"
									port:   8443
									scheme: "HTTPS"
								}
								initialDelaySeconds: 5
								timeoutSeconds:      10
							}
							resources: requests: {
								cpu:    "10m"
								memory: "450Mi"
							}
							securityContext: {
								allowPrivilegeEscalation: false
								capabilities: drop: ["ALL"]
								seccompProfile: type: "RuntimeDefault"
							}
							volumeMounts: [{
								mountPath: "/etc/virt-operator/certificates"
								name:      "kubevirt-operator-certs"
								readOnly:  true
							}, {
								mountPath: "/profile-data"
								name:      "profile-data"
							}]
						}]
						nodeSelector: "kubernetes.io/os": "linux"
						priorityClassName: "kubevirt-cluster-critical"
						securityContext: {
							runAsNonRoot: true
							seccompProfile: type: "RuntimeDefault"
						}
						serviceAccountName: "kubevirt-operator"
						tolerations: [{
							key:      "CriticalAddonsOnly"
							operator: "Exists"
						}]
						volumes: [{
							name: "kubevirt-operator-certs"
							secret: {
								optional:   true
								secretName: "kubevirt-operator-certs"
							}
						}, {
							emptyDir: {}
							name: "profile-data"
						}]
					}
				}
			}
		}}}
